# Paralyze Technical Documentation

> **Notice**: Paralyze is an educational project demonstrating Command & Control (C2) architecture. It is intended for research, security education, and controlled lab environments only.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Architecture](#2-architecture)
3. [Bot Agent](#3-bot-agent)
   - 3.1 [Initialization & Registration](#31-initialization--registration)
   - 3.2 [ControlModule](#32-controlmodule)
   - 3.3 [NetworkModule](#33-networkmodule)
   - 3.4 [DoSModule](#34-dosmodule)
   - 3.5 [LoaderModule](#35-loadermodule)
   - 3.6 [ProxyModule](#36-proxymodule)
   - 3.7 [MaintenanceModule](#37-maintenancemodule)
   - 3.8 [ExfiltrationModule](#38-exfiltrationmodule)
   - 3.9 [NukeModule](#39-nukemodule)
   - 3.10 [Support Utilities](#310-support-utilities)
4. [C2 Server](#4-c2-server)
   - 4.1 [Server Initialization](#41-server-initialization)
   - 4.2 [CCServer](#42-ccserver)
   - 4.3 [DBController (MariaDB)](#43-dbcontroller-mariadb)
   - 4.4 [ConfigModule (MongoDB)](#44-configmodule-mongodb)
   - 4.5 [API Endpoints](#45-api-endpoints)
   - 4.6 [Authentication Flow](#46-authentication-flow)
5. [Control Panel](#5-control-panel)
   - 5.1 [Backend API](#51-backend-api)
   - 5.2 [Frontend UI](#52-frontend-ui)
6. [Data Formats](#6-data-formats)
   - 6.1 [Instruction Schema](#61-instruction-schema)
   - 6.2 [Bot Database Record](#62-bot-database-record)
   - 6.3 [MongoDB Instruction Document](#63-mongodb-instruction-document)
7. [Communication Protocol](#7-communication-protocol)
8. [Configuration Reference](#8-configuration-reference)
9. [Build System & Dependencies](#9-build-system--dependencies)
10. [Security Model](#10-security-model)

---

## 1. Overview

Paralyze is a modular Command & Control (C2) framework consisting of three independent components:

| Component | Language | Purpose |
|-----------|----------|---------|
| **Bot Agent** | C++ | Deployed agent that fetches and executes instructions |
| **C2 Server** | C++ | Central server that manages bots and serves instructions |
| **Control Panel** | Node.js + HTML/JS | Web-based operator interface for managing the C2 |

All bot-to-server communication is encrypted over TLS and formatted as standard HTTPS traffic, with the server presenting itself as an Apache web server. Instructions are stored in MongoDB and dispatched per-bot; bot identity and status are tracked in MariaDB.

**Key design principles:**

- **Modular**: Bot functionality is split into independent modules registered at runtime. Any subset of modules can be activated or deactivated without recompilation.
- **Configuration-driven**: All bot behavior is defined by JSON instruction documents stored server-side. No changes to the bot binary are required to alter its behavior.
- **Async I/O throughout**: Both the bot and the server use Boost.Asio for non-blocking network operations, enabling high concurrency without proportional thread overhead.
- **Dual-database**: MariaDB handles structured, relational bot identity data; MongoDB handles flexible, document-based instruction and configuration storage.

---

## 2. Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Operator Workstation                         │
│                                                                     │
│   ┌───────────────────────────────────────────────────────────┐     │
│   │               Control Panel  (Node.js :3000)              │     │
│   │  ┌──────────┐  ┌────────────┐  ┌───────────────────────┐  │     │
│   │  │ Status   │  │ C2 Config  │  │  Instruction Builder  │  │     │
│   │  │ Monitor  │  │  Editor    │  │  (DoS / Proxy / etc.) │  │     │
│   │  └──────────┘  └────────────┘  └───────────────────────┘  │     │
│   └───────────────────────────────────────────────────────────┘     │
│                            │ REST (HTTP :3000)                      │
└────────────────────────────┼────────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────────┐
│                    Infrastructure Layer                             │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │             C2 Server  (C++ / Boost.Asio :5050 TLS)          │   │
│  │                                                              │   │
│  │   handle_auth_request()   handle_settings_request()          │   │
│  │   handle_file_request()   send_instructions()                │   │
│  └───────────────┬──────────────────────┬───────────────────────┘   │
│                  │                      │                           │
│  ┌───────────────▼──────┐  ┌────────────▼──────────────────────┐    │
│  │  MariaDB             │  │  MongoDB                          │    │
│  │  (bots table)        │  │  server_configs / bot_configs /   │    │
│  │  uuid, ip, status,   │  │  bot_instructions collections     │    │
│  │  jwt token, OS …     │  └───────────────────────────────────┘    │
│  └──────────────────────┘                                           │
└─────────────────────────────────────────────────────────────────────┘
                             │ HTTPS / TLS
         ┌───────────────────┼──────────────────────┐
         │                   │                      │
┌────────▼────────┐  ┌───────▼────────┐  ┌─────────▼──────────┐
│  Bot Agent A    │  │  Bot Agent B   │  │  Bot Agent N       │
│  ControlModule  │  │  ControlModule │  │  ControlModule     │
│  DoSModule      │  │  ProxyModule   │  │  LoaderModule      │
│  …              │  │  …             │  │  …                 │
└─────────────────┘  └────────────────┘  └────────────────────┘
```

---

## 3. Bot Agent

**Entry point**: `Bot/Sources/ParalyzeBot.cpp`  
**Build target**: `ParalyzeBot`

The bot agent is a self-contained C++ executable. On startup it creates a `ControlModule`, loads the API endpoint map from disk, and enters an infinite fetch-execute loop. All outbound connections use TLS over a single persistent socket.

### 3.1 Initialization & Registration

```
main()
  │
  ├── BotLogger::get_instance()          — start buffered logging thread
  ├── ControlModule(server_ip, port)     — construct main orchestrator
  ├── load api_endpoints.json            — populate endpoint map
  ├── register_module(DoSModule)         — optional, disabled by default
  ├── register_module(LoaderModule)      — optional, disabled by default
  └── start_module()                     — enter instruction loop
```

Modules are registered by calling `ControlModule::register_module(IModule*)`. Only registered modules are reachable during instruction dispatch. Omitting a registration call effectively disables that capability at runtime without removing compiled code.

---

### 3.2 ControlModule

**File**: `Bot/Headers/ControlModule.h` / `Bot/Sources/ControlModule.cpp`  
**Inherits**: `NetworkModule`, `IModule`

The ControlModule is the top-level orchestrator of the bot. It drives the main execution loop and delegates to other modules.

**Responsibilities:**

| Responsibility | Method |
|----------------|--------|
| Obtain JWT from C2 | `receive_jwt()` (via `NetworkModule`) |
| Fetch current instructions | `fetch_instructions()` → GET `/api/settings` |
| Parse instruction metadata | `evaluate_basic_instructions(json)` |
| Dispatch to correct module | `evaluate_module(json)` |
| Register child modules | `register_module(IModule*)` |
| Apply timing/sleep | Handled inside `start_module()` |

**Execution loop:**

```
start_module()
  └── loop forever
        ├── fetch_instructions()          — GET /api/settings + Bearer JWT
        ├── evaluate_basic_instructions() — read module, timing, sleep fields
        ├── sleep (random 1–60 s)
        └── evaluate_module()             — dispatch to registered IModule
```

Sleep duration between cycles is randomized (uniform distribution, 1–60 seconds) to avoid predictable beacon intervals. An explicit `"sleep"` field in the instruction JSON overrides this with a fixed delay or another random value.

**Module dispatch** is a map lookup keyed on the `"module"` field of the instruction:

```
"module": "dos"         → DoSModule::execute_module()
"module": "loader"      → LoaderModule::execute_module()
"module": "proxy"       → ProxyModule::execute_module()
"module": "maintenance" → MaintenanceModule (handled directly)
```

---

### 3.3 NetworkModule

**File**: `Bot/Headers/NetworkModule.h` / `Bot/Sources/NetworkModule.cpp`  
**Used by**: ControlModule, LoaderModule, MaintenanceModule, ExfiltrationModule

NetworkModule is the base class for all components that communicate with the C2 server. It owns the TLS socket and exposes typed HTTP primitives.

**Key members:**

| Member | Type | Purpose |
|--------|------|---------|
| `m_ssl_socket` | `boost::asio::ssl::stream<tcp::socket>` | Encrypted socket |
| `m_api_endpoints` | `map<string, string>` | Name → URL path mapping |
| `m_jwt` | `string` | Current bearer token |

**Public interface:**

```cpp
void connect_to_server();
void receive_jwt();
string send_https_get_request(const string& endpoint);
string send_https_post_request(const string& endpoint, const string& body);
```

**TLS configuration**: The SSL context is initialized with `TLSv1_2_client_method`. Certificate validation is performed against the server's certificate. The client loads its own PEM certificate and private key from paths defined in `api_endpoints.json`.

**JWT acquisition**: On first connect (or when the stored JWT is absent), the bot sends the hardcoded initial credential `"feel_nothing"` to `/api/auth/jwt`. The server validates this token, creates a bot record, generates an RS256 JWT, and returns it. The bot writes the JWT to a local file and reuses it on subsequent runs.

---

### 3.4 DoSModule

**File**: `Bot/Headers/DoSModule.h` / `Bot/Sources/DoSModule.cpp`  
**Implements**: `IModule`

DoSModule performs a TCP-level denial-of-service attack by opening many concurrent connections to a target host and continuously sending HTTP requests.

**Instruction parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `target_ip` | string | Destination host or IP address |
| `target_port` | integer | Destination TCP port |
| `connection_count` | integer | Number of simultaneous connections |
| `delay_ms` | integer | Milliseconds between connection attempts |
| `until` | string (ISO 8601) | Timestamp at which the attack stops |

**Internal flow:**

```
execute_module(instructions)
  │
  ├── parse parameters from JSON
  ├── create io_context + thread pool
  ├── for i in range(connection_count):
  │     async_connect() → on_connect()
  │       └── async_write(http_request) → reschedule
  └── run io_context until "until" timestamp
```

Each connection is an independent async operation. Connections that are reset or refused are rescheduled after `delay_ms`. The attack terminates when the current system time exceeds the `until` timestamp.

---

### 3.5 LoaderModule

**File**: `Bot/Headers/LoaderModule.h` / `Bot/Sources/LoaderModule.cpp`  
**Inherits**: `NetworkModule`, `IModule`

LoaderModule downloads a binary tool payload from the C2 server and executes it in-process using memory-mapped executable memory.

**Execution flow:**

```
execute_module(instructions)
  │
  ├── GET /api/files                       — download binary blob
  ├── mmap(NULL, size, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_ANON|MAP_PRIVATE)
  ├── validate signature (check 0x55 = push rbp at offset 0)
  ├── memcpy blob to executable region
  ├── reinterpret_cast<void(*)()>(mmap_ptr)()   — invoke
  └── munmap()
```

**Signature validation**: Before execution the module verifies that the first byte of the downloaded binary is `0x55` (the x86-64 `push rbp` instruction, the standard prologue of a compiled C function). This acts as a minimal integrity check to avoid running non-executable data.

> **Note**: LoaderModule is compiled into the binary but not registered in the default build. To activate it, uncomment its `register_module()` call in `ParalyzeBot.cpp`.

---

### 3.6 ProxyModule

**File**: `Bot/Headers/ProxyModule.h` / `Bot/Sources/ProxyModule.cpp`  
**Implements**: `IModule`

ProxyModule turns the bot into a bidirectional TCP relay, forwarding traffic between two endpoints. This enables network pivoting through compromised hosts.

**Instruction parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `c2_host` | string | Address of the upstream C2 relay |
| `c2_port` | integer | Port of the upstream relay |

**Internal model:**

The module opens two sockets—one to the upstream C2 relay and one accepting local connections—and creates two async read-write loops that move data between them in both directions. Data is forwarded raw with no inspection or transformation.

---

### 3.7 MaintenanceModule

**File**: `Bot/Headers/MaintenanceModule.h` / `Bot/Sources/MaintenanceModule.cpp`  
**Inherits**: `NetworkModule`

MaintenanceModule handles bot self-updates and remote configuration changes pushed by the operator. It is invoked directly by ControlModule (not via the IModule registry) when the instruction specifies `"module": "maintenance"`.

**Capabilities:**

- Fetch updated connection settings (server IP/port) from C2
- Update local certificate files with new PEM data received from the server
- Re-register modules with updated parameters
- Reload `api_endpoints.json` after receiving a new endpoint map

---

### 3.8 ExfiltrationModule

**File**: `Bot/Headers/ExfiltrationModule.h` / `Bot/Sources/ExfiltrationModule.cpp`  
**Inherits**: `NetworkModule`

ExfiltrationModule uploads captured data from the bot's local filesystem to the C2 server.

**Key methods:**

| Method | Description |
|--------|-------------|
| `send_data_to_server(path)` | Reads file at `path` and POST it to the C2 |
| `obfuscate_data(bytes)` | Applies a lightweight transform to the payload before sending |

Data is sent as an HTTP POST body to a dedicated exfiltration endpoint defined in `api_endpoints.json`.

---

### 3.9 NukeModule

**File**: `Bot/Headers/NukeModule.h` / `Bot/Sources/NukeModule.cpp`

NukeModule provides self-destruct functionality. It is not an `IModule` implementor and is called directly.

**`nuke_paralyze()`**: Removes the bot's JWT file, configuration files, and optionally the bot binary itself, erasing its local presence before the process exits.

---

### 3.10 Support Utilities

#### BotEssentials (Singleton)

General-purpose utilities used across all bot modules.

| Method | Description |
|--------|-------------|
| `read_file(path)` | Returns file contents as `vector<uint8_t>` |
| `write_file(path, data)` | Writes bytes to disk |
| `encrypt(data, key)` | OpenSSL EVP symmetric encryption |
| `decrypt(data, key)` | OpenSSL EVP symmetric decryption |
| `bytes_to_json(bytes)` | Converts raw bytes to nlohmann::json |
| `json_to_string(json)` | Serializes JSON to string |

#### NetworkEssentials (Singleton)

Cryptographic helpers for certificate operations.

| Method | Description |
|--------|-------------|
| `load_pem_certificate(path)` | Returns X.509 certificate from PEM file |
| `load_pem_private_key(path)` | Returns private key from PEM file |
| `convert_cert_format(cert)` | Converts between DER/PEM encodings |

#### BotLogger (Singleton)

Buffered, module-aware logging system.

| Log Level | Usage |
|-----------|-------|
| `TRACE` | Verbose internal state (default in dev builds) |
| `DEBUG` | Module lifecycle events |
| `INFO` | Normal operational messages |
| `WARNING` | Recoverable errors |
| `ERROR` | Non-fatal failures |
| `FATAL` | Unrecoverable errors, triggers shutdown |

Log entries include the emitting module's name. A dedicated background thread drains the log buffer to stdout/file to avoid blocking the async I/O loop.

---

## 4. C2 Server

**Entry point**: `Server/Sources/MainServer.cpp`  
**Build target**: `CCServer`

The C2 server is a multithreaded HTTPS server built on Boost.Beast. It maintains a thread pool for async I/O, a TLS context loaded with its server certificate and private key, and two database backends accessed through singleton controllers.

### 4.1 Server Initialization

```
main()
  │
  ├── ConfigModule::init(config_module.json)    — connect MongoDB
  ├── DBController::init(db_controller.conf)    — connect MariaDB
  ├── load control_server.json                  — server address/port/SSL paths
  ├── CCServer(address, port, ssl_context)
  └── CCServer::start_server()                  — bind, listen, start accepting
```

### 4.2 CCServer

**File**: `Server/Headers/CCServer.h` / `Server/Sources/CCServer.cpp`  
**Inherits**: `BaseServer`

CCServer is the main server class. It owns the Boost.Asio `io_context`, the SSL context, and the TCP acceptor. A thread pool drives the `io_context`, giving the server concurrent request handling.

**Request routing:**

```
handle_request(socket, http_request)
  │
  ├── validate "Authorization: Bearer <jwt>" header
  │     └── on failure → 401 Unauthorized
  ├── extract UUID from JWT claims
  └── route by URL path:
        /api/auth/jwt     → handle_auth_request()
        /api/settings     → handle_settings_request()
        /api/files        → handle_file_request()
        *                 → 404 Not Found
```

**Bot lifecycle management:**

| Method | Description |
|--------|-------------|
| `create_bot(ip, port, os)` | Inserts new bot record into MariaDB; returns UUID |
| `send_instructions(uuid, json)` | Writes instruction document to MongoDB |
| `generate_jwt(uuid)` | Creates RS256-signed JWT containing the UUID claim |

**Server masquerade**: All HTTP responses include the header `Server: Apache/2.4.6` to blend with expected web traffic.

---

### 4.3 DBController (MariaDB)

**File**: `Server/Headers/DBController.h` / `Server/Sources/DBController.cpp`  
**Pattern**: Singleton

DBController manages the MariaDB connection and all operations on the `bots` table.

**Schema — `bots` table:**

| Column | Type | Description |
|--------|------|-------------|
| `uuid` | VARCHAR (PK) | Unique bot identifier |
| `ip_address` | VARCHAR | Bot's observed IP address |
| `port` | INT | Bot's source port |
| `location` | VARCHAR | Geolocation string |
| `status` | VARCHAR | `active`, `inactive`, or `lost` |
| `last_seen` | TIMESTAMP | Most recent activity |
| `bot_type` | VARCHAR | Bot variant label |
| `token` | VARCHAR | Current JWT |
| `OS` | VARCHAR | Operating system string |

**Public interface:**

| Method | Description |
|--------|-------------|
| `insert_bot(record)` | Adds a new row |
| `update_bot(uuid, record)` | Updates all fields for a bot |
| `delete_bot(uuid)` | Removes a bot row |
| `update_bot_status(uuid, status)` | Updates `status` and `last_seen` |
| `get_token(uuid)` → string | Returns the JWT for a given UUID |
| `get_uuid(token)` → string | Reverse-lookup UUID from JWT |

**Configuration** is read from a plain key=value text file (`db_controller.conf`):

```
host=localhost
port=3306
user=c2user
password=secret
database=paralyze
```

---

### 4.4 ConfigModule (MongoDB)

**File**: `Server/Headers/ConfigModule.h` / `Server/Sources/ConfigModule.cpp`  
**Pattern**: Singleton

ConfigModule stores all dynamic configuration and instruction data in MongoDB. It abstracts three collections under two databases.

**Collections:**

| Collection | Database | Purpose |
|------------|----------|---------|
| `server_configs.configs` | `server_configs` | Global C2 server parameters |
| `bot_configs.configs` | `bot_configs` | Per-bot configuration overrides |
| `bot_instructions.instructions` | `bot_instructions` | Instruction documents per bot |

**Public interface:**

| Method | Description |
|--------|-------------|
| `get_bot_config(uuid)` → json | Retrieves config document for a specific bot |
| `get_instruction(uuid)` → json | Fetches the current instruction for a bot |
| `set_bot_instructions(uuid, json)` | Stores or replaces an instruction document |
| `get_init_token()` → string | Returns the expected initial auth token |

**Document lookup** is keyed by the `_id` field containing the bot's UUID. If no per-bot document exists, the server falls back to the global config.

---

### 4.5 API Endpoints

| Method | Path | Auth Required | Description |
|--------|------|--------------|-------------|
| `POST` | `/api/auth/jwt` | Initial token | Register bot and obtain JWT |
| `GET` | `/api/settings` | Bearer JWT | Fetch current instruction |
| `GET` | `/api/files` | Bearer JWT | Download tool binary payload |

All endpoints return JSON-encoded bodies. The `/api/files` endpoint streams a raw binary for `LoaderModule` to execute.

---

### 4.6 Authentication Flow

```
Bot                                      C2 Server
 │                                           │
 │  POST /api/auth/jwt                       │
 │  Body: { "token": "feel_nothing" }        │
 ├──────────────────────────────────────────►│
 │                                           ├── validate initial token
 │                                           ├── create_bot(ip, port, os) → uuid
 │                                           ├── generate_jwt(uuid) → RS256 JWT
 │                                           ├── store JWT in MariaDB
 │◄──────────────────────────────────────────┤
 │  { "jwt": "<token>" }                     │
 │                                           │
 │  (subsequent requests)                    │
 │                                           │
 │  GET /api/settings                        │
 │  Authorization: Bearer <jwt>              │
 ├──────────────────────────────────────────►│
 │                                           ├── verify JWT signature (RS256)
 │                                           ├── extract uuid claim
 │                                           ├── get_uuid(jwt) via MariaDB
 │                                           ├── get_instruction(uuid) via MongoDB
 │◄──────────────────────────────────────────┤
 │  { "module": "...", "parameters": {...} } │
```

JWTs are signed with RS256 (RSA + SHA-256). The private key path is specified in `control_server.json`; the public key is derived from the same file for verification. Token payloads include the bot UUID as a claim and a standard expiry (`exp`).

---

## 5. Control Panel

**Entry point**: `Interface/Panel/server.js`  
**Port**: `3000`  
**Tech stack**: Node.js, Express, MariaDB driver, MongoDB driver

The control panel is the operator's primary interface for configuring the C2 and building instructions. It provides a lightweight REST API consumed by its own HTML/JS frontend.

### 5.1 Backend API

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/status/db` | Test MariaDB + MongoDB connectivity |
| `GET` | `/api/status/c2` | Probe C2 server reachability |
| `POST` | `/api/instructions` | Write an instruction JSON file to disk |
| `POST` | `/api/save-instruction-json` | Save a custom raw instruction document |
| `POST` | `/api/c2-config` | Overwrite `control_server.json` |
| `POST` | `/save-settings` | Persist panel settings to `interface_settings.conf` |
| `GET` | `/get-instruction-path` | Return configured instructions directory path |

All POST endpoints expect `application/json` request bodies. Responses use standard HTTP status codes.

---

### 5.2 Frontend UI

The frontend is a single-page HTML application served as static files by the Express backend. It communicates exclusively with the panel's own Node.js API.

**Status panel**: Polls `/api/status/db` and `/api/status/c2` every 10 seconds. Displays a green/red badge for each component.

**Instruction Builder**: A modal dialog with per-module forms. The operator fills in parameters, clicks Save, and the panel POSTs the resulting JSON to `/api/instructions`.

| Module Form | Parameters Exposed |
|-------------|-------------------|
| DoS | target IP, target port, connection count, delay (ms), end time |
| Proxy | C2 upstream host and port |
| Maintenance | module list, new server address |
| Init / Sleep | sleep duration, execution time |

**C2 Configuration Editor**: Allows the operator to update `control_server.json` fields (address, port, TLS cert paths, API endpoint map) without touching the filesystem directly.

**Custom JSON Editor**: A textarea for pasting arbitrary instruction JSON, with a file-upload fallback. Posted directly to `/api/save-instruction-json`.

**Database Configuration**: Input fields for MariaDB and MongoDB connection strings. Written to their respective config files via save-settings.

**Settings Persistence**: Panel configuration (config file paths, instruction directory) is written to `interface_settings.conf` as key=value pairs and re-read on every restart.

---

## 6. Data Formats

### 6.1 Instruction Schema

Instruction documents are JSON objects. The `module` and `parameters` fields are always required; other fields are optional.

```json
{
  "module": "dos | loader | proxy | maintenance | control",
  "execution_time": "now | <ISO 8601 timestamp>",
  "sleep": "<integer seconds> | random",
  "until": "<ISO 8601 timestamp>",
  "parameters": {
    "target_ip":        "<string>",
    "target_port":      "<integer>",
    "connection_count": "<integer>",
    "delay_ms":         "<integer>",
    "c2_host":          "<string>",
    "c2_port":          "<integer>"
  }
}
```

**Field semantics:**

| Field | Description |
|-------|-------------|
| `module` | Which IModule implementation to invoke |
| `execution_time` | `"now"` executes immediately; an ISO 8601 string defers execution until that time |
| `sleep` | Fixed seconds or `"random"` (1–60 s) to wait after execution |
| `until` | For timed attacks (DoS): stop after this timestamp |

---

### 6.2 Bot Database Record

Stored as a row in the MariaDB `bots` table. Queried and updated by DBController.

```
uuid         — e.g. "a3f2c1d0-9b8e-4c7a-bf12-..."
ip_address   — "192.168.1.42"
port         — 54312
location     — "DE / Berlin"
status       — "active"
last_seen    — "2024-03-15 14:22:01"
bot_type     — "ParalyzeBot"
token        — "<jwt string>"
OS           — "Linux 5.15"
```

---

### 6.3 MongoDB Instruction Document

Stored in the `bot_instructions.instructions` collection. Retrieved by `ConfigModule::get_instruction(uuid)`.

```json
{
  "_id": "<bot-uuid>",
  "config_name": "dos_attack_1",
  "module": "dos",
  "execution_time": "now",
  "parameters": {
    "target_ip": "10.0.0.5",
    "target_port": 80,
    "connection_count": 500,
    "delay_ms": 10,
    "until": "2024-03-15T16:00:00Z"
  }
}
```

The `_id` field is the bot's UUID. Writing a new document for the same UUID overwrites the existing instruction, allowing the operator to change a bot's behavior on the next fetch cycle.

---

## 7. Communication Protocol

All bot-to-server traffic uses HTTPS (HTTP/1.1 over TLS 1.2+). The bot constructs standard HTTP requests using Boost.Beast and sends them over a `boost::asio::ssl::stream`.

**Request format (instruction fetch):**

```
GET /api/settings HTTP/1.1
Host: 10.0.10.1:5050
Authorization: Bearer <jwt>
Date: <RFC 7231 date>
Accept: application/json
```

**Response format:**

```
HTTP/1.1 200 OK
Server: Apache/2.4.6
Content-Type: application/json
Content-Length: <n>

{"module":"dos","parameters":{...}}
```

**Beacon interval**: The bot sleeps a random interval (1–60 seconds) between instruction fetches. An explicit `"sleep"` field in the instruction JSON overrides this with a fixed value or another random draw.

**Connection handling**: Each fetch cycle may reuse the existing TLS socket or reconnect if the connection was dropped. `NetworkModule::connect_to_server()` is called defensively before each request.

---

## 8. Configuration Reference

### `configs/control_server.json`

C2 server runtime configuration. Read by `CCServer` at startup.

| Field | Description |
|-------|-------------|
| `address` | Bind address (e.g. `"0.0.0.0"`) |
| `port` | Listening port (e.g. `5050`) |
| `ssl_cert` | Path to server TLS certificate (PEM) |
| `ssl_key` | Path to server TLS private key (PEM) |
| `ssl_dh` | Path to DH parameters file |
| `api_endpoints` | Object mapping endpoint names to URL paths |

### `configs/config_module.json`

MongoDB connection settings. Read by `ConfigModule` at startup.

| Field | Description |
|-------|-------------|
| `uri` | MongoDB connection URI |
| `server_config_db` | Database name for server configs |
| `bot_config_db` | Database name for bot configs |
| `instructions_db` | Database name for instructions |

### `configs/db_controller.conf`

MariaDB credentials. Key=value text format.

| Key | Description |
|-----|-------------|
| `host` | MariaDB hostname |
| `port` | MariaDB port |
| `user` | Database user |
| `password` | Database password |
| `database` | Schema name |

### `configs/api_endpoints.json`

Loaded by the bot agent at startup.

| Key | Default Path | Description |
|-----|-------------|-------------|
| `instructions` | `/api/settings` | Instruction fetch endpoint |
| `tool_suites` | `/api/files` | Binary payload endpoint |
| `jwt` | `/api/auth/jwt` | Authentication endpoint |

### `interface_settings.conf`

Persisted by the control panel. Key=value text format.

| Key | Description |
|-----|-------------|
| `mariadb_path` | Absolute path to `db_controller.conf` |
| `mongodb_path` | Absolute path to `config_module.json` |
| `c2_path` | Absolute path to `control_server.json` |
| `instructions_path` | Directory where instruction JSON files are stored |

---

## 9. Build System & Dependencies

Paralyze uses **CMake** (≥ 3.15) with **Conan** for dependency management. Each component has its own `CMakeLists.txt` and `conanfile.txt`.

### Bot Agent

| Dependency | Version | Usage |
|------------|---------|-------|
| Boost | 1.86.0 | Asio (async I/O), Beast (HTTP), System |
| OpenSSL | 3.3.2 | TLS socket, EVP crypto |
| fmt | 11.1.1 | String formatting (header-only) |

**Compiler flags**: `Clang++`, `-fsanitize=address` in debug builds.

```bash
cd Bot
conan install . --output-folder=build --build=missing
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
cmake --build .
```

### C2 Server

| Dependency | Version | Usage |
|------------|---------|-------|
| Boost | 1.82.0 | Asio, Beast, Thread |
| OpenSSL | 3.3.2 | TLS, JWT signing |
| MongoDB C++ Driver | 3.11.0 | Document store access |
| MariaDB Connector/C | 3.3.8 | Relational bot registry |
| nlohmann_json | 3.11.2 | JSON parsing/serialization |
| jwt-cpp | 0.4.0 | RS256 JWT generation and validation |
| zstd | 1.5.5 | Compression support |

```bash
cd Server
conan install . --output-folder=build --build=missing
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
cmake --build .
```

### Control Panel

```bash
cd Interface/Panel
npm install
node server.js
```

**Node.js dependencies**: `express`, `mariadb`, `mongodb`

---

## 10. Security Model

### Transport Security

- All bot-to-server traffic is TLS 1.2 or higher.
- The server loads a certificate + private key at startup (`ssl_cert`, `ssl_key` in config).
- The bot validates the server certificate against a trusted CA bundle loaded from disk.
- Client certificate authentication is supported via `NetworkEssentials::load_pem_certificate()`.

### Authentication

- Bots authenticate using short-lived RS256 JWT tokens.
- Initial registration uses a shared static secret (`"feel_nothing"`); this should be rotated for production deployments.
- JWTs contain the bot UUID as a claim and carry a standard `exp` field.
- The server validates both the JWT signature and the `exp` claim on every request before querying the database.

### Traffic Masquerade

- The server sends `Server: Apache/2.4.6` in all HTTP responses.
- API paths (`/api/settings`, `/api/files`, `/api/auth/jwt`) are configurable to mimic arbitrary web application routes.

### Isolation Recommendations

Since this is an educational project, always deploy in an isolated lab network:

- Use a dedicated, air-gapped or firewalled network segment.
- Do not use real hostnames or certificates tied to public infrastructure.
- Rotate the initial token (`"feel_nothing"`) before any lab use.
- Ensure the control panel (port 3000) is not reachable from untrusted hosts.