#!/usr/bin/env python3

"""
Purge and install packages in Linux Mint
"""

import subprocess
import argparse

# Packages to purge
PURGE = [
    "celluloid",
    "vlc",
    "hypnotix",
    "thingy",
    "mintchat",
    "transmission-gtk",
    "transmission-common",
    "qsynth",
]

# PPAs that will be added with add-apt-repository
PPAS = [
    "ppa:openrazer/stable",
    "ppa:polychromatic/stable",
]

# Packages to install, categorized
INSTALL = dict()
INSTALL["core"] = [
    "kitty",
    "dconf-editor",
    "neovim",
    "guake",
    "gparted",
    "direnv",
    "signal-desktop",
    "xfdashboard",
    "xfdashboard-plugins",
    "etckeeper",
    "stow",
]

INSTALL["virtualization"] = [
    "wine-installer",
    "qemu-kvm",
    "libvirt-daemon",
    "libvirt-clients",
    "bridge-utils",
    "virt-manager",
    "virt-viewer",
    "libguestfs-tools",
]

INSTALL["code"] = [
    "git",
    "build-essential",
    "automake",
    "nasm",
    "cmake",
    "clang",
    "valgrind",
    "geany",
    "mypy",
]

INSTALL["shell"] = [
    "kitty",
    "fish",
    "shellcheck",
]

INSTALL["cli"] = [
    "rsync",
    "htop",
    "ripgrep",
    "fd-find",
    "bat",
    "eza",
    "fdupes",
    "ranger",
    "p7zip",
    "dos2unix",
    "tldr",
    "s-tui",
]

INSTALL["gaming"] = [
    "steam-installer",
    "lutris",
    "openrazer-meta",
    "polychromatic",
]

INSTALL["media"] = [
    "mpv",
    "obs-studio",
    "ffmpeg",
    "yt-dlp",
    "feh",
]

MANUAL_INSTALL_LINKS = [
    "https://discord.com/download",
    "https://code.visualstudio.com/Download",
    "https://mullvad.net/en/download/vpn/linux",
]


def purge(purges: list):
    """Purge packages we don't want."""
    purge_cmd = ["sudo", "apt-get", "purge"] + purges
    subprocess.run(purge_cmd, check=True)
    subprocess.run(["sudo", "apt-get", "autoremove"], check=True)


def update_ppas(ppas: list):
    """Update ppas. Only needed once."""
    subprocess.run(["./add_signal-desktop_repository.sh"], check=True)
    for ppa in ppas:
        ppa_cmd = ["sudo", "add-apt-repository", ppa]
        subprocess.run(ppa_cmd, check=True)


def install(installs: dict):
    """Install the packages defined"""
    subprocess.run(["sudo", "apt-get", "update"], check=True)
    packages = [pkg for install_list in installs.values() for pkg in install_list]
    install_cmd = ["sudo", "apt-get", "install"] + packages
    subprocess.run(install_cmd, check=True)

    subprocess.run(["./install_fisher.fish"], check=True)


def manual_install(manual_install_links: list):
    """Manual installs, just opens the download pages in Firefox"""
    manual_install_cmd = ["firefox"] + manual_install_links
    subprocess.run(manual_install_cmd, check=True)


def main(update_ppa: bool):
    """Entry point"""
    purge(PURGE)

    # NOTE: This is only needed once
    if update_ppa:
        update_ppas(PPAS)

    install(INSTALL)
    manual_install(MANUAL_INSTALL_LINKS)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--ppa", action="store_true")
    args = parser.parse_args()
    main(args.ppa)
