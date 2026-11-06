#!/usr/bin/env bash
# Richtet den CSS-Plugin-Marketplace für GitHub Copilot CLI und Claude Code ein
# und schaltet das Auto-Update ein. Einmal pro Arbeitsplatz ausführen.
#
# Hintergrund: Copilot CLI ignoriert «autoUpdate» in .github/copilot/settings.json.
# Das Auto-Update wird nur aus den User-Settings (~/.copilot/settings.json) gelesen.
set -euo pipefail

MARKETPLACE_NAME="css-plugins"
MARKETPLACE_URL="https://scm.grudligstrasse.ch/css/copilot-plugins.git"
PLUGIN="css-baseline@${MARKETPLACE_NAME}"

if command -v copilot >/dev/null 2>&1; then
  echo "GitHub Copilot CLI: Marketplace ${MARKETPLACE_NAME} registrieren"
  COPILOT_SETTINGS="${COPILOT_HOME:-$HOME/.copilot}/settings.json"
  mkdir -p "$(dirname "${COPILOT_SETTINGS}")"
  # Marketplace mit autoUpdate in die User-Settings mergen (bestehende Einträge bleiben erhalten)
  python3 - "${COPILOT_SETTINGS}" "${MARKETPLACE_NAME}" "${MARKETPLACE_URL}" <<'PY'
import json, os, sys
path, name, url = sys.argv[1:4]
data = {}
if os.path.exists(path) and os.path.getsize(path) > 0:
    with open(path) as f:
        data = json.load(f)
data.setdefault("extraKnownMarketplaces", {})[name] = {
    "source": {"source": "git", "url": url},
    "autoUpdate": True,
}
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
  copilot plugin install "${PLUGIN}"
  copilot plugin update "${PLUGIN}"
else
  echo "GitHub Copilot CLI nicht gefunden, übersprungen."
fi

if command -v claude >/dev/null 2>&1; then
  echo "Claude Code: Marketplace ${MARKETPLACE_NAME} registrieren"
  claude plugin marketplace add "${MARKETPLACE_URL}" || true
  claude plugin install "${PLUGIN}" --scope project || true
  echo "Auto-Update für Claude Code ist über .claude/settings.json (autoUpdate: true) aktiv."
else
  echo "Claude Code nicht gefunden, übersprungen."
fi

echo "Fertig. Neue Session starten, damit die Skills arc42-docs und kafka-event-design geladen werden."
