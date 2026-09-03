#!/usr/bin/env bash
# ==============================================================================
# Antigravity-Asana-Plugin Installer
# Installs and scopes the Asana plugin for Google Antigravity and Jetski.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
TARGET="both"
STRICT_SCOPE="true"
WORKSPACE_GID="${ASANA_WORKSPACE_GID:-}"
TEAM_GID="${ASANA_TEAM_GID:-}"
ACCESS_TOKEN="${ASANA_ACCESS_TOKEN:-}"

print_usage() {
  cat <<EOF
Usage: ./install.sh [OPTIONS]

Options:
  -w, --workspace-gid GID   Required. Target Asana Workspace GID (e.g. 1213807836434812)
  -t, --team-gid GID        Required. Target Asana Team GID (e.g. 1213807836434813)
  -a, --access-token TOKEN  Optional. Asana Personal Access Token
  -s, --strict [true|false] Enforce strict workspace/team scope (default: true)
  --target [antigravity|jetski|both]
                            Installation target environment (default: both)
  -h, --help                Show this help message

Examples:
  ./install.sh --workspace-gid 1213807836434812 --team-gid 1213807836434813
  ./install.sh -w 1213807836434812 -t 1213807836434813 --target antigravity
EOF
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -w|--workspace-gid)
      WORKSPACE_GID="$2"
      shift 2
      ;;
    -t|--team-gid)
      TEAM_GID="$2"
      shift 2
      ;;
    -a|--access-token)
      ACCESS_TOKEN="$2"
      shift 2
      ;;
    -s|--strict)
      STRICT_SCOPE="$2"
      shift 2
      ;;
    --target)
      TARGET="$2"
      shift 2
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      exit 1
      ;;
  esac
done

# Interactive prompts if required arguments are missing
if [[ -z "${WORKSPACE_GID}" ]]; then
  read -rp "Enter target Asana Workspace GID: " WORKSPACE_GID
fi

if [[ -z "${TEAM_GID}" ]]; then
  read -rp "Enter target Asana Team GID: " TEAM_GID
fi

if [[ -z "${WORKSPACE_GID}" || -z "${TEAM_GID}" ]]; then
  echo "Error: Both Workspace GID and Team GID are required to configure plugin scoping."
  exit 1
fi

echo "============================================================"
echo "Installing Antigravity-Asana-Plugin"
echo "  Workspace GID : ${WORKSPACE_GID}"
echo "  Team GID      : ${TEAM_GID}"
echo "  Strict Scope  : ${STRICT_SCOPE}"
echo "  Target        : ${TARGET}"
echo "============================================================"

# 1. Compile TypeScript
echo "Building server..."
(cd "${SCRIPT_DIR}" && npm install && npm run build)

# 2. Generate scoped mcp_config.json
echo "Configuring scoped mcp_config.json..."
cat <<EOF > "${SCRIPT_DIR}/mcp_config.json"
{
  "mcpServers": {
    "asana": {
      "command": "node",
      "args": [
        "dist/index.js"
      ],
      "env": {
        "ASANA_ACCESS_TOKEN": "${ACCESS_TOKEN:-\${ASANA_ACCESS_TOKEN\}}",
        "ASANA_WORKSPACE_GID": "${WORKSPACE_GID}",
        "ASANA_TEAM_GID": "${TEAM_GID}",
        "ASANA_STRICT_SCOPE": "${STRICT_SCOPE}"
      }
    }
  }
}
EOF

# 3. Create Plugin Symlinks
install_to() {
  local dir="$1"
  local env_name="$2"
  mkdir -p "${dir}"
  rm -f "${dir}/asana"
  ln -s "${SCRIPT_DIR}" "${dir}/asana"
  echo "✓ Installed to ${env_name}: ${dir}/asana"
}

if [[ "${TARGET}" == "antigravity" || "${TARGET}" == "both" ]]; then
  install_to "${HOME}/.gemini/antigravity/plugins" "Antigravity"
fi

if [[ "${TARGET}" == "jetski" || "${TARGET}" == "both" ]]; then
  install_to "${HOME}/.gemini/config/plugins" "Jetski"
fi

echo ""
echo "============================================================"
echo "Successfully installed Antigravity-Asana-Plugin!"
echo ""
echo "Pinned Scope:"
echo "  Workspace GID: ${WORKSPACE_GID}"
echo "  Team GID:      ${TEAM_GID}"
echo ""
if [[ -z "${ACCESS_TOKEN}" ]]; then
  echo "Remember to set your personal access token before starting:"
  echo "  export ASANA_ACCESS_TOKEN=\"your_token_here\""
fi
echo "============================================================"
