#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/rewrite-vscode-package.XXXXXX)"

cleanup() {
	rm -rf "$TMP_DIR"
}

trap cleanup EXIT

mkdir -p "$TMP_DIR/themes"

cp "$ROOT_DIR/package.json" "$TMP_DIR/package.json"
cp "$ROOT_DIR/LICENSE" "$TMP_DIR/LICENSE"
cp "$ROOT_DIR/.vscodeignore" "$TMP_DIR/.vscodeignore"
cp "$ROOT_DIR"/themes/*.json "$TMP_DIR/themes/"

NAME="$(jq -r '.name' "$ROOT_DIR/package.json")"
VERSION="$(jq -r '.version' "$ROOT_DIR/package.json")"
OUT_PATH="$ROOT_DIR/${NAME}-${VERSION}.vsix"

(
	cd "$TMP_DIR"
	"$ROOT_DIR/node_modules/.bin/vsce" package \
		--no-dependencies \
		--out "$OUT_PATH" \
		--baseContentUrl "https://github.com/RewriteToday/theme/blob/main/vscode" \
		--baseImagesUrl "https://github.com/RewriteToday/theme/raw/main/vscode"
)

printf 'Packaged VSIX: %s\n' "$OUT_PATH"
