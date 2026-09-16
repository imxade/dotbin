#!/bin/sh
set -eu

usage() {
    cat <<EOF
Usage:
  $0 --key <ssh-key> --target <user@host>

Example:
  $0 --key ~/.config/osnix/oracle/oracle.key --target root@132.226.187.186
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

TMP_DIR=$(mktemp -d /tmp/osnix-apply-XXXXXX)
LOCAL_SESSION_TMP=$(mktemp -d /tmp/job-apply-session-XXXXXX)
trap 'rm -rf "$TMP_DIR" "$LOCAL_SESSION_TMP"' EXIT

echo "Preparing osnix configuration..."

cp -a "$OSNIX_DIR/." "$TMP_DIR/"

# Never copy private keys, sessions, or build symlinks into the public/remote flake tree
find "$TMP_DIR" -type f \
    \( -name '*.key' -o -name '*.key.pub' -o -name '*.pem' -o -name 'oracle.key' -o -name '.env*' \) \
    -delete
find "$TMP_DIR" -type d \
    \( -name 'sessions' -o -name '__pycache__' \) \
    -exec rm -rf {} + 2>/dev/null || true
find "$TMP_DIR" -type l -name 'result*' -delete 2>/dev/null || true

echo "Copying osnix configuration to $TARGET:$REMOTE_DIR..."

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

# ==========================================================
# 1. APPLY NIXOS SYSTEM CONFIGURATION
# ==========================================================
echo "Applying oracle-free configuration..."

ssh \
    -i "$SSH_KEY" \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$TARGET" \
    "nixos-rebuild switch --flake '$REMOTE_DIR#oracle-free'"

# ==========================================================
# 2. AUTO-EXTRACT & STREAM SESSIONS FROM LOCAL DEFAULT PROFILE
# ==========================================================
echo "Checking for active local browser sessions..."

python3 -c "
import asyncio, json
from pathlib import Path

async def extract():
    out_dir = Path('$LOCAL_SESSION_TMP')
    # Check Chrome CDP port file
    active_port_file = Path.home() / '.config/google-chrome/DevToolsActivePort'
    if not active_port_file.is_file():
        return
    try:
        from playwright.async_api import async_playwright
        lines = active_port_file.read_text().splitlines()
        ws_url = f'ws://127.0.0.1:{lines[0].strip()}{lines[1].strip()}'
        async with async_playwright() as pw:
            browser = await pw.chromium.connect_over_cdp(ws_url)
            cookies = await browser.contexts[0].cookies()
            if cookies:
                out_dir.mkdir(parents=True, exist_ok=True)
                (out_dir / 'all_cookies.json').write_text(json.dumps(cookies, indent=2))
                platforms = {
                    'naukri': ['naukri.com'],
                    'indeed': ['indeed.com'],
                    'instahyre': ['instahyre.com'],
                    'wellfound': ['wellfound.com', 'angel.co'],
                }
                for plat, doms in platforms.items():
                    pc = [c for c in cookies if any(d in c.get('domain', '') for d in doms)]
                    if pc:
                        (out_dir / f'{plat}.json').write_text(json.dumps(pc, indent=2))
    except Exception:
        pass

asyncio.run(extract())
" 2>/dev/null || true

REMOTE_SESSIONS="/var/lib/browser-session"

if ls "$LOCAL_SESSION_TMP"/*.json >/dev/null 2>&1; then
    echo "Syncing freshly extracted browser sessions to $TARGET:$REMOTE_SESSIONS..."
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
        "$LOCAL_SESSION_TMP"/*.json \
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
    echo "Notice: No local active browser session extracted. Preserving existing VPS sessions in $REMOTE_SESSIONS."
fi

echo "Done. Oracle configuration applied successfully."