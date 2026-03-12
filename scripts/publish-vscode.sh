#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/release-common.sh"

DRY_RUN=0

while (($# > 0)); do
	case "$1" in
	--dry-run)
		DRY_RUN=1
		shift
		;;
	*)
		printf 'Unknown argument: %s\n' "$1" >&2
		exit 1
		;;
	esac
done

ROOT_DIR="$(release_root_dir)"
VSCODE_DIR="$ROOT_DIR/vscode"
VERSION="$(release_vscode_version)"

release_require_cmd bun
release_require_cmd jq
release_assert_versions_match

(
	cd "$VSCODE_DIR"
	bun install --frozen-lockfile
	bun run package

	if ((DRY_RUN)); then
		printf 'Dry run: VS Code package built for version %s. Skipping Marketplace publish.\n' "$VERSION"
		exit 0
	fi

	if [[ -z "${VSCE_PAT:-}" ]]; then
		printf 'VSCE_PAT is not set. Export it before publishing to the VS Code Marketplace.\n' >&2
		exit 1
	fi

	bun run publish:extension
)
