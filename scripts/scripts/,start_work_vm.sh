#!/usr/bin/env bash

vm="work_ubuntu22.04"

if ! pgrep -f "$vm"; then
    virsh -c qemu:///system start work_ubuntu22.04
fi
virt-viewer -c qemu:///system --full-screen
