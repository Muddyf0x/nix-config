# NixOS Configuration

This repository contains my NixOS configuration, managed using **Nix Flakes**, **Home Manager**, and designed for **multiple hosts and users**. It is structured to be modular, maintainable, and extensible.

---

## Features

- **Multi-host support**: Configurations for different machines (laptop, desktop, etc.).
- **Multi-user support**: User-specific configurations via Home Manager.
- **Flakes**: Reproducible, declarative system and user environments.
- **Modular structure**: Shared and host/user-specific configurations.
- **Full disk encryption**: LUKS2 over a btrfs pool with subvolumes for `/nix`, `/home`, `/persist`, `/var/lib`, `/var/log`, and swap.
- **Impermanence**: Ephemeral root rolled back to a blank btrfs snapshot on every boot. Only explicitly declared paths survive reboots.
- **Declarative secrets**: `sops-nix` with age keys derived from SSH host keys.

---

## File Structure

```bash
.
├── flake.nix          # Main flake (inputs: nixpkgs, home-manager, sops-nix, disko, impermanence)
├── secrets.yaml       # sops-encrypted secrets
├── hosts/
│   ├── laptop.nix     # Laptop host entry point
│   ├── hardware/      # Auto-generated hardware modules (kernel modules, CPU)
│   ├── disko/         # Declarative disk layouts (btrfs + FDE)
│   ├── common/        # Shared modules (locale, sops, impermanence, networking, …)
│   ├── users/         # User account definitions
│   └── opt/           # Optional modules (DE, gaming, bluetooth, …)
└── home/
    └── muddy/
        ├── default.nix
        ├── nixConfigs/    # Programs configured via Nix
        └── linkedConfigs/ # Dotfiles symlinked from the repo (nvim, alacritty)
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

## Fresh Install

### 1. Boot and connect

Boot the NixOS live ISO and connect to the internet.

```bash
# Quick wifi via nmtui if needed
sudo systemctl start NetworkManager
nmtui
```

### 2. Clone the config

```bash
nix-shell -p git
git clone <your-repo-url> /tmp/nix-config
cd /tmp/nix-config
```

### 3. Check the disk device

```bash
lsblk
```

The disko config targets `/dev/nvme0n1`. Edit `hosts/disko/laptop.nix` if your disk is different before continuing.

### 4. Partition, format, and mount with disko

```bash
sudo nix run github:nix-community/disko/latest -- --mode disko hosts/disko/laptop.nix
```

This creates the GPT layout, LUKS2 partition, btrfs pool with all subvolumes, and the swapfile. All filesystems are left mounted under `/mnt`.

### 5. Bootstrap the sops host key

The SSH host key must exist **before** `nixos-install` so that sops-nix can derive the age key on first boot. Without this step secrets will fail to decrypt.

```bash
# Create the persist directory for SSH keys
mkdir -p /mnt/persist/etc/ssh

# Generate the host key (same path sops.nix points to)
ssh-keygen -t ed25519 -N "" -f /mnt/persist/etc/ssh/id_ed25519

# Get the age public key
cat /mnt/persist/etc/ssh/id_ed25519.pub | ssh-to-age
```

Copy the age public key output, then on a machine that already has access to `secrets.yaml`:

```bash
# Add the new age key as a recipient in .sops.yaml, then:
sops updatekeys secrets/secrets.yaml
git commit -am "add laptop host key"
git push
```

Pull the updated secrets on the live ISO:

```bash
git pull
```

### 6. Install

```bash
sudo nixos-install --flake /tmp/nix-config#laptop --no-root-passwd
```

### 7. Reboot

```bash
sudo reboot
```

On first boot the initrd rollback service wipes the ephemeral `/root` subvolume and boots into a clean root. NixOS activation regenerates everything from the Nix store. sops-nix reads `/persist/etc/ssh/id_ed25519`, derives the age key, and decrypts `secrets.yaml` to set the `muddy` password.

---

## TODO

- [ ] Configure home-manager impermanence once ready to cut down persistent `/home` — see task 6 notes in the commit history
- [ ] `desktop.nix` host config (currently missing)
- [ ] Firefox declarative config
- [ ] nixvirt — declarative VM management
- [ ] stylix — unified theming
- [ ] Fix fingerprint reader (currently disabled, incompatible with sddm)
