#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
ALLOW_DIRTY=0

while (($# > 0)); do
	case "$1" in
	--dry-run)
		DRY_RUN=1
		shift
		;;
	--allow-dirty)
		ALLOW_DIRTY=1
		shift
		;;
	*)
		printf 'Unknown argument: %s\n' "$1" >&2
		exit 1
		;;
	esac
done

VSCODE_ARGS=()
ZED_ARGS=()

if ((DRY_RUN)); then
	VSCODE_ARGS+=("--dry-run")
	ZED_ARGS+=("--dry-run")
fi

if ((ALLOW_DIRTY)); then
	ZED_ARGS+=("--allow-dirty")
fi

"$SCRIPT_DIR/publish-vscode.sh" "${VSCODE_ARGS[@]}"
"$SCRIPT_DIR/publish-zed.sh" "${ZED_ARGS[@]}"
