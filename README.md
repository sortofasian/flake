# System Configuration

This is my system config flake, which holds configs for my PC running NixOS (Famine) and my Macbook Air M1 2020 (War).
I plan to migrate my server (Pestilence) to NixOS and include it in this flake as well.

---

## Hosts

Named after the Four Horsemen of the Apocalypse.
For what reason? I don't know.
I'm likely going to run out of horsemen at some point too.

### Famine

Custom built PC

- CPU: AMD Ryzen 5600x
- GPU: Nvidia RTX 2070 SUPER
- RAM: 32GB
- Storage: 1TB NVME with an extra unused 2TB backup drive
- Networking: 2.5g Ethernet, Wi-Fi (Intel AX200)

For general purposes and occasional gaming


### War

2020 Macbook Air

- CPU: Apple M1
- GPU: Apple M1
- RAM: 8GB
- Storage: 256GB SSD (help)
- Networking: Wi-fi and an AIO dongle with ethernet

For when I don't have access to Famine or when I want to work in bed


### Pestilence (not in flake yet)

2U Supermicro X8DT3

- CPU: Intel X5650 x2
- GPU: N/A
- RAM: 24GB
- Storage: 16TB HDD array
- Networking: 4x1Gb Ethernet, 2x10g SFP+ (unused, supposed to be for local transfer only)

For experimentation and hosting all my completely legal services

---

## Directories

### `pkgs/`

Custom derivations as well as wrappers to provide configs to programs

### `modules/`

Common configuration. Contains one common config, and a config for each OS.

### `hosts/`

Machine specific configuration.

### `lib/`

Custom utility functions and such
