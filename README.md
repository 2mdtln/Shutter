# Shutter

**Shutter** is a Windows service that schedules automatic system shutdowns based on a configurable time. It runs in the background and ensures that your system shuts down at the specified time every day. 

## ✨ Features

- Runs as a Windows service
- Reads shutdown time from a configuration file
- Automatically shuts down the system at the specified time
- Includes an installer and uninstaller for easy setup

## 📥 Installation

1. Download `ShutterInstaller.exe` from the [Releases](https://github.com/2mdtln/Shutter/releases) page.
2. Run the installer as an administrator.
3. The service will be installed and started automatically.

## ⚙️ Configuration

The shutdown time is specified in a JSON configuration file.

### Default Configuration File Location:
```
C:\Program Files (x86)\Shutter\config.json
```

### Example `config.json`:
```json
{
    "shutdown_time": "22:30"
}
```
- ⏰ The time format is **HH:MM** (24-hour format).
- If the config file is missing or invalid, the default shutdown time is **17:40**.

## 🔧 How It Works

1. **Service Execution**  
   - The service reads the shutdown time from the config file.
   - It checks the current system time every minute.
   - If the current time matches the shutdown time, it executes `shutdown /s /t 0` to turn off the computer.

2. **Installation Script**  
   - Uses NSIS (`install-shutter.nsi`) to install the service and copy necessary files.
   - Registers the service with `sc create` and starts it automatically.

## 🗑 Uninstallation

To uninstall Shutter:

1. Run `Uninstall.exe` from the installation directory (`C:\Program Files (x86)\Shutter`).
2. Alternatively, run the following command in an administrator command prompt:
   ```sh
   sc stop ShutterService
   sc delete ShutterService
   ```
3. Delete the installation folder manually if needed.

## 🏗️ Building from Source

### Requirements:
- Go compiler
- NSIS (to create the installer)

### Steps:
1. Clone the repository:
   ```sh
   git clone https://github.com/2mdtln/Shutter.git
   cd Shutter
   ```
2. Build the executable:
   ```sh
   go build -o shutter.exe
   ```
3. Create the installer:
   ```sh
   makensis install-shutter.nsi
   ```

## 📜 License
This project is open-source and available under the **MIT License**.
 
