#!/bin/bash

# Function to check if nmap is installed
check_nmap_installed() {
    if ! command -v nmap &> /dev/null; then
        return 1
    else
        return 0
    fi
}

# Function to install nmap on Debian-based systems
install_nmap_debian() {
    echo "Installing nmap..."
    if sudo apt-get update && sudo apt-get install -y nmap; then
        echo "nmap installed successfully."
    else
        echo "Error: Failed to install nmap." >&2
        exit 1
    fi
}

# Function to install nmap on Red Hat-based systems
install_nmap_redhat() {
    echo "Installing nmap..."
    if sudo yum install -y nmap; then
        echo "nmap installed successfully."
    else
        echo "Error: Failed to install nmap." >&2
        exit 1
    fi
}

# Function to scan IP address with nmap
scan_ip() {
    echo "Scanning IP address $1 with nmap..."
    if nmap -A "$1"; then
        echo "Scan completed successfully."
    else
        echo "Error: Failed to scan IP address $1." >&2
        exit 1
    fi
}

# Main script starts here
if ! check_nmap_installed; then
    if command -v apt-get &> /dev/null; then
        install_nmap_debian
    elif command -v yum &> /dev/null; then
        install_nmap_redhat
    else
        echo "Error: Unsupported package manager." >&2
        exit 1
    fi
fi

# Check if IP address argument is provided
if [ $# -eq 0 ]; then
    echo "Error: IP address argument is missing." >&2
    echo "Usage: $0 <IP_ADDRESS>" >&2
    exit 1
fi

# Scan the provided IP address
scan_ip "$1"
