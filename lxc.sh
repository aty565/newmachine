#!/bin/sh
set -e

# --- Ensure curl is installed ---
if ! command -v curl >/dev/null 2>&1; then
    echo "[INFO] Installing curl..."
    if command -v apt >/dev/null 2>&1; then
        apt update
        apt upgrade -y
        apt install -y curl
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y curl
    elif command -v apk >/dev/null 2>&1; then
        apk add --no-cache curl
    else
        echo "[ERROR] No known package manager found. Install curl manually."
        exit 1
    fi
fi

# --- Function to prompt and run a command ---
prompt_install() {
    MESSAGE="$1"
    COMMAND="$2"
    echo -n "$MESSAGE [y/N] "
    read ANSWER </dev/tty
    case "$ANSWER" in
        [yY][eE][sS]|[yY])
            echo "[INFO] Installing..."
            sh -c "$COMMAND"
            ;;
        *)
            echo "[INFO] Skipping."
            ;;
    esac
}

# --- Prompt for Docker installation ---
prompt_install "Do you want to install Docker?" "curl -fsSL https://get.docker.com | sh"

# --- Prompt for Tailscale installation ---
prompt_install "Do you want to install Tailscale?" "curl -fsSL https://tailscale.com/install.sh | sh"
