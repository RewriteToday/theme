#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT_DIR/scripts/package.sh"

NAME="$(jq -r '.name' "$ROOT_DIR/package.json")"
VERSION="$(jq -r '.version' "$ROOT_DIR/package.json")"
VSIX_PATH="$ROOT_DIR/${NAME}-${VERSION}.vsix"

"$ROOT_DIR/node_modules/.bin/vsce" publish --packagePath "$VSIX_PATH" "$@"
