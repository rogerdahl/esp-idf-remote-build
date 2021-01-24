## Utilities for building ESP32 ESP-IDF projects on a remote machine

These simple shell scripts enable me to work on ESP-IDF projects on my wimpy laptop and have them automatically build on my beefy server. 

The scripts handle the following tasks:

- Sync source code to the remote machine when it is modified

- Trigger builds on the remote machine

- Flash firmware `.bin` files residing on the remote machine
  directly to ESP32 development boards connected to the local machine.
  
### Scripts

* `flash-client.sh`: Sends firmware .bin files over the network to a machine running the flash server.

* `flash-server.sh`: Receives firmware .bin files from the flash-server and writes them to a locally connected device.

