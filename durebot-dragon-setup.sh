#!/usr/bin/env bash
set -euo pipefail
PROJECT_DIR="${1:-$PWD/DURESBOT-DRAGON}"
mkdir -p "$PROJECT_DIR/theme" "$PROJECT_DIR/installer" "$PROJECT_DIR/bot"
cat > "$PROJECT_DIR/README.md" <<'EOF'
# DURESBOT DRAGON
Starter scaffold, not a production-ready theme or universal installer.
This script creates project files only; it does not modify Pterodactyl.
Confirm panel version and test on staging before integrating.
EOF
cat > "$PROJECT_DIR/theme/dragon.css" <<'EOF'
:root {
  --db-dragon-bg:#080d12; --db-dragon-panel:#101b17;
  --db-dragon-green:#00ff88; --db-dragon-green-deep:#063d2e;
  --db-dragon-text:#f5fff9; --db-dragon-glow:0 0 18px rgba(0,255,136,.16);
}
body { background:var(--db-dragon-bg); color:var(--db-dragon-text); }
a,.text-primary { color:var(--db-dragon-green); }
button,.btn,input[type="submit"] { transition:box-shadow .18s ease; }
button:hover,.btn:hover,input[type="submit"]:hover { box-shadow:var(--db-dragon-glow); }
.db-dragon-watermark {
 position:fixed;right:12px;bottom:8px;z-index:999;opacity:.24;
 color:var(--db-dragon-green);font-size:11px;font-weight:800;
 letter-spacing:.22em;pointer-events:none;user-select:none;
}
EOF
cat > "$PROJECT_DIR/theme/INSTALL-NOTES.md" <<'EOF'
1. Confirm panel version with: php artisan --version
2. Back up the panel or use staging first.
3. Find a supported customization method for that exact version.
4. Integrate dragon.css through that method; do not blindly inject it.
5. Add watermark element in a supported component; CSS alone cannot create it.
6. Test login, server list, console, files, mobile layout and updates.
EOF
cat > "$PROJECT_DIR/installer/check.sh" <<'EOF'
#!/usr/bin/env bash
set -uo pipefail
PANEL_DIR="${1:-/var/www/pterodactyl}"
echo "=== DURESBOT DRAGON — READ-ONLY CHECK ==="
if [[ ! -d "$PANEL_DIR" || ! -f "$PANEL_DIR/artisan" ]]; then
 echo "ERROR: panel path not found: $PANEL_DIR"; exit 2
fi
(cd "$PANEL_DIR" && php artisan --version) || exit 3
command -v node >/dev/null 2>&1 && node --version || echo "Node.js not installed."
command -v npm >/dev/null 2>&1 && npm --version || echo "npm not installed."
echo "Read-only check complete; no files changed."
EOF
chmod +x "$PROJECT_DIR/installer/check.sh"
cat > "$PROJECT_DIR/bot/README.md" <<'EOF'
Telegram bot integration plan:
- Never collect/store users' root passwords.
- Have the VPS owner run a reviewable installer, or use a narrowly scoped agent.
- Check versions, back up, ask before changes, and stop on unknown versions.
- Never run arbitrary shell commands sent through Telegram.
- Keep bot tokens in environment variables, never in public source.
EOF
echo "Created starter project at $PROJECT_DIR"
echo "No Pterodactyl files were changed."
