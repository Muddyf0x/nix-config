# NixOS Configuration

This repository contains my NixOS configuration, managed using **Nix Flakes**, **Home Manager**, and designed for **multiple hosts and users**. It is structured to be modular, maintainable, and extensible.

---

## Features

- **Multi-host support**: Configurations for different machines (laptop, desktop, etc.).
- **Multi-user support**: User-specific configurations via Home Manager.
- **Flakes**: Reproducible, declarative system and user environments.
- **Modular structure**: Shared and host/user-specific configurations.
- **Planned expansions**: `sops-nix` for secrets, `disko` for disk management, and `impermanence` for persistent state.

---

## File Structure

```bash
.
├── flake.nix          # Main flake definition
├── hosts/             # Host-specific configurations
│   ├── laptop.nix     # Laptop configuration
│   ├── desktop.nix    # Desktop configuration
│   ├── hardware/      # Hardware-specific modules
│   ├── common/        # Shared host modules
│   ├── users/         # User-specific host modules
│   └── opt/           # Optional host modules
└── home/              # Home Manager configurations
    └── user/          # User configurations
        ├── default.nix
        ├── nixConfigs/ # NixOS-specific user configs
        └── linkedConfigs/ # Linked user configs
            ├── default.nix
            └── configs/   # User-specific configs
```

---

## Usage

### 1. Build and Switch

To build and switch to a host configuration:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with the name of your host (e.g., `laptop`, `desktop`).

### 2. Update Flake Inputs

To update all flake inputs (e.g., Nixpkgs, Home Manager):

```bash
nix flake update
```

---

## TODO

- **sops-nix**
  - [ ] Add to flake inputs
  - [ ] Set up age keys
  - [ ] Create secrets directory
  - [ ] Integrate secrets into configs

- **disko**
  - [ ] Add to flake inputs
  - [ ] Define disk layouts
  - [ ] Update host configs

- **impermanence**
  - [ ] Add to flake inputs
  - [ ] Define persistent paths
  - [ ] Set up systemd services
