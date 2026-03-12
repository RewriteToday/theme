#!/usr/bin/env bash

set -euo pipefail

RELEASE_COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_ROOT_DIR="$(cd "$RELEASE_COMMON_DIR/../.." && pwd)"

release_root_dir() {
	printf '%s\n' "$RELEASE_ROOT_DIR"
}

release_require_cmd() {
	local cmd="$1"

	if ! command -v "$cmd" >/dev/null 2>&1; then
		printf 'Missing required command: %s\n' "$cmd" >&2
		exit 1
	fi
}

release_vscode_version() {
	jq -r '.version' "$RELEASE_ROOT_DIR/vscode/package.json"
}

release_zed_version() {
	sed -n 's/^version = "\(.*\)"$/\1/p' "$RELEASE_ROOT_DIR/zed/extension.toml" | head -n 1
}

release_zed_id() {
	sed -n 's/^id = "\(.*\)"$/\1/p' "$RELEASE_ROOT_DIR/zed/extension.toml" | head -n 1
}

release_zed_path() {
	printf '%s\n' "zed"
}

release_assert_versions_match() {
	local vscode_version
	local zed_version

	vscode_version="$(release_vscode_version)"
	zed_version="$(release_zed_version)"

	if [[ -z "$vscode_version" || -z "$zed_version" ]]; then
		printf 'Could not read version metadata from vscode/package.json or zed/extension.toml.\n' >&2
		exit 1
	fi

	if [[ "$vscode_version" != "$zed_version" ]]; then
		printf 'Version mismatch: vscode=%s zed=%s\n' "$vscode_version" "$zed_version" >&2
		exit 1
	fi
}

release_assert_file_exists() {
	local path="$1"

	if [[ ! -f "$path" ]]; then
		printf 'Missing required file: %s\n' "$path" >&2
		exit 1
	fi
}

release_normalize_github_url() {
	local remote_url="$1"
	local path

	case "$remote_url" in
	https://github.com/*)
		printf '%s\n' "$remote_url"
		;;
	git@github.com:*)
		path="${remote_url#git@github.com:}"
		printf 'https://github.com/%s\n' "$path"
		;;
	ssh://git@github.com/*)
		path="${remote_url#ssh://git@github.com/}"
		printf 'https://github.com/%s\n' "$path"
		;;
	*)
		printf 'Unsupported GitHub remote URL: %s\n' "$remote_url" >&2
		exit 1
		;;
	esac
}

release_repo_is_dirty() {
	local root_dir="$1"

	if [[ -n "$(git -C "$root_dir" status --porcelain)" ]]; then
		return 0
	fi

	return 1
}
