#!/bin/bash
# Run once: Install Ansible if not present
set -euo pipefail

if ! command -v ansible &> /dev/null; then
    echo "🚀 Installing Ansible..."
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
    echo "✅ Ansible installed"
else
    echo "✅ Ansible already installed"
fi