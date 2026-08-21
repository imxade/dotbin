#!/bin/sh
set -eu

usage() {
    cat <<EOF
Usage:
  $0 --key <ssh-key> --target <user@host>

Example:
  $0 --key ~/.config/osnix/oracle/oracle.key --target root@137.23.55.240
EOF
    exit 1
}

SSH_KEY=""
TARGET=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --key)
            [ "$#" -ge 2 ] || usage
            SSH_KEY="$2"
            shift 2
            ;;
        --target)
            [ "$#" -ge 2 ] || usage
            TARGET="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: unknown argument: $1" >&2
            usage
            ;;
    esac
done

[ -n "$SSH_KEY" ] || usage
[ -n "$TARGET" ] || usage
[ -f "$SSH_KEY" ] || {
    echo "Error: SSH key not found: $SSH_KEY" >&2
    exit 1
}

OSNIX_DIR="${HOME}/.config/osnix"
REMOTE_DIR="/root/.config/osnix"

[ -d "$OSNIX_DIR" ] || {
    echo "Error: osnix directory not found: $OSNIX_DIR" >&2
    exit 1
}

SSH_KEY=$(realpath "$SSH_KEY")

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Preparing osnix configuration..."

cp -a "$OSNIX_DIR/." "$TMP_DIR/"

# Never copy private keys to the VM.
find "$TMP_DIR" -type f \
    \( -name '*.key' -o -name '*.pem' -o -name 'oracle.key' \) \
    -delete

echo "Copying osnix to $TARGET:$REMOTE_DIR..."

ssh \
    -i "$SSH_KEY" \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$TARGET" \
    "mkdir -p '$REMOTE_DIR'"

scp -r \
    -i "$SSH_KEY" \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$TMP_DIR/." \
    "$TARGET:$REMOTE_DIR/"

echo "Applying oracle-free configuration..."

ssh \
    -i "$SSH_KEY" \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$TARGET" \
    "nixos-rebuild switch --flake '$REMOTE_DIR#oracle-free'"

echo "Done."