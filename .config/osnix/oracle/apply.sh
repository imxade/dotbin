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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SSH_KEY="${ORACLE_KEY:-}"
TARGET="${ORACLE_TARGET:-}"

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

if [ -z "$SSH_KEY" ] && [ -f "$SCRIPT_DIR/oracle.key" ]; then
    SSH_KEY="$SCRIPT_DIR/oracle.key"
fi
if [ -z "$TARGET" ]; then
    TARGET="root@132.226.187.186"
fi

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

# Never copy private keys or build symlinks to the VM.
find "$TMP_DIR" -type f \
    \( -name '*.key' -o -name '*.pem' -o -name 'oracle.key' \) \
    -delete
find "$TMP_DIR" -type l -name 'result*' -delete 2>/dev/null || true

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

# ==========================================================
# SYNC BROWSER SESSIONS (All 4 portal logins)
# ==========================================================
LOCAL_SESSIONS=""
if [ -d "${HOME}/.job-apply-mcp/sessions" ]; then
    LOCAL_SESSIONS="${HOME}/.job-apply-mcp/sessions"
elif [ -d "/var/lib/browser-session" ]; then
    LOCAL_SESSIONS="/var/lib/browser-session"
fi

REMOTE_SESSIONS="/var/lib/browser-session"

if [ -n "$LOCAL_SESSIONS" ] && ls "$LOCAL_SESSIONS"/*.json >/dev/null 2>&1; then
    echo "Syncing browser sessions from $LOCAL_SESSIONS to $TARGET:$REMOTE_SESSIONS..."
    ssh \
        -i "$SSH_KEY" \
        -o IdentitiesOnly=yes \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "$TARGET" \
        "mkdir -p '$REMOTE_SESSIONS'"

    scp \
        -i "$SSH_KEY" \
        -o IdentitiesOnly=yes \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "$LOCAL_SESSIONS"/*.json \
        "$TARGET:$REMOTE_SESSIONS/"

    ssh \
        -i "$SSH_KEY" \
        -o IdentitiesOnly=yes \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "$TARGET" \
        "chmod 777 '$REMOTE_SESSIONS' && chmod 666 '$REMOTE_SESSIONS'/*.json 2>/dev/null || true"
    echo "Browser sessions synced successfully."
else
    echo "Notice: No browser session cookies found locally, skipping session sync."
fi

echo "Done."