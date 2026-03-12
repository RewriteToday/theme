#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/release-common.sh"

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

ROOT_DIR="$(release_root_dir)"
EXTENSION_ID="$(release_zed_id)"
EXTENSION_VERSION="$(release_zed_version)"
EXTENSION_PATH="$(release_zed_path)"
THEME_REMOTE_URL="$(release_normalize_github_url "$(git -C "$ROOT_DIR" remote get-url origin)")"
THEME_REMOTE_LABEL="${THEME_REMOTE_URL%.git}"
CURRENT_BRANCH="$(git -C "$ROOT_DIR" branch --show-current || true)"
LOCAL_SHA="$(git -C "$ROOT_DIR" rev-parse HEAD)"
THEME_SHA="${RELEASE_THEME_SHA:-$LOCAL_SHA}"
THEME_FETCH_REF="${RELEASE_THEME_FETCH_REF:-$CURRENT_BRANCH}"

release_require_cmd gh
release_require_cmd git
release_require_cmd jq
release_require_cmd pnpm
release_assert_versions_match

if ((ALLOW_DIRTY == 0)) && release_repo_is_dirty "$ROOT_DIR"; then
	printf 'Refusing to publish Zed extension from a dirty working tree.\n' >&2
	exit 1
fi

if [[ -z "$THEME_FETCH_REF" ]]; then
	printf 'Could not determine the remote ref for the theme repository. Set RELEASE_THEME_FETCH_REF when running from a detached HEAD.\n' >&2
	exit 1
fi

REMOTE_SHA=""
if [[ -n "$CURRENT_BRANCH" ]]; then
	REMOTE_SHA="$(git -C "$ROOT_DIR" ls-remote --heads origin "$CURRENT_BRANCH" | awk '{print $1}')"
fi

if ((DRY_RUN == 0)) && { [[ -z "$REMOTE_SHA" ]] || [[ "$LOCAL_SHA" != "$REMOTE_SHA" ]]; }; then
	if [[ -z "$CURRENT_BRANCH" ]]; then
		printf 'The checked out commit is detached and is not available from origin. Push the ref first or set RELEASE_THEME_FETCH_REF to a published ref.\n' >&2
		exit 1
	fi

	git -C "$ROOT_DIR" push -u origin "$CURRENT_BRANCH"
	REMOTE_SHA="$(git -C "$ROOT_DIR" ls-remote --heads origin "$CURRENT_BRANCH" | awk '{print $1}')"
	THEME_SHA="$REMOTE_SHA"
fi

FORK_OWNER="${ZED_FORK_OWNER:-$(gh api user --jq .login)}"
FORK_REPO="${ZED_FORK_REPO:-extensions}"
FORK_SLUG="$FORK_OWNER/$FORK_REPO"
BRANCH_NAME="release/${EXTENSION_ID}-v${EXTENSION_VERSION}"
PR_TITLE="Add ${EXTENSION_ID} v${EXTENSION_VERSION}"
PR_BODY="$(cat <<EOF
## Summary

- add ${EXTENSION_ID} ${EXTENSION_VERSION}
- point the submodule at ${THEME_REMOTE_LABEL}@${THEME_SHA}
- load the extension from \`${EXTENSION_PATH}\`
EOF
)"

if ! gh repo view "$FORK_SLUG" >/dev/null 2>&1; then
	if ((DRY_RUN)); then
		printf 'Dry run: would create fork %s from zed-industries/extensions.\n' "$FORK_SLUG"
	else
		gh repo fork zed-industries/extensions --fork-name "$FORK_REPO" --default-branch-only
	fi
fi

WORK_DIR="$(mktemp -d /tmp/rewrite-zed-release.XXXXXX)"
REPO_SLUG="$FORK_SLUG"

if ((DRY_RUN)) && ! gh repo view "$FORK_SLUG" >/dev/null 2>&1; then
	REPO_SLUG="zed-industries/extensions"
fi

cleanup() {
	rm -rf "$WORK_DIR"
}

trap cleanup EXIT

gh repo clone "$REPO_SLUG" "$WORK_DIR/extensions-repo" -- --depth=1

cd "$WORK_DIR/extensions-repo"

git checkout -B "$BRANCH_NAME"

if [[ ! -d node_modules ]]; then
	pnpm install --frozen-lockfile
fi

if grep -qx "\[$EXTENSION_ID\]" extensions.toml; then
	PR_TITLE="Update ${EXTENSION_ID} to v${EXTENSION_VERSION}"
fi

SUBMODULE_PATH="extensions/$EXTENSION_ID"

if [[ -e "$SUBMODULE_PATH" ]]; then
	git submodule set-url "$SUBMODULE_PATH" "$THEME_REMOTE_URL"
else
	git submodule add "$THEME_REMOTE_URL" "$SUBMODULE_PATH"
fi

git -C "$SUBMODULE_PATH" fetch --depth=1 origin "$THEME_FETCH_REF"
git -C "$SUBMODULE_PATH" checkout "$THEME_SHA"

TMP_EXTENSIONS_TOML="$(mktemp /tmp/rewrite-zed-extensions.toml.XXXXXX)"

awk -v id="$EXTENSION_ID" '
BEGIN { skipping = 0 }
/^\[/ {
	if ($0 == "[" id "]") {
		skipping = 1
		next
	}
	skipping = 0
}
!skipping { print }
' extensions.toml > "$TMP_EXTENSIONS_TOML"

printf '\n[%s]\nsubmodule = "extensions/%s"\npath = "%s"\nversion = "%s"\n' \
	"$EXTENSION_ID" \
	"$EXTENSION_ID" \
	"$EXTENSION_PATH" \
	"$EXTENSION_VERSION" >> "$TMP_EXTENSIONS_TOML"

mv "$TMP_EXTENSIONS_TOML" extensions.toml

pnpm sort-extensions

git add .gitmodules extensions.toml "$SUBMODULE_PATH"

if git diff --cached --quiet; then
	printf 'No Zed registry changes were necessary.\n'
	exit 0
fi

git commit -m "${PR_TITLE}"

if ((DRY_RUN)); then
	printf 'Dry run: prepared Zed registry update branch %s in %s.\n' "$BRANCH_NAME" "$WORK_DIR/extensions-repo"
	exit 0
fi

git push --force-with-lease -u origin "$BRANCH_NAME"

EXISTING_PR_URL="$(gh pr list --repo zed-industries/extensions --head "${FORK_OWNER}:${BRANCH_NAME}" --json url --jq '.[0].url // ""')"

if [[ -n "$EXISTING_PR_URL" ]]; then
	printf 'Existing Zed PR: %s\n' "$EXISTING_PR_URL"
	exit 0
fi

gh pr create \
	--repo zed-industries/extensions \
	--base main \
	--head "${FORK_OWNER}:${BRANCH_NAME}" \
	--title "$PR_TITLE" \
	--body "$PR_BODY"
