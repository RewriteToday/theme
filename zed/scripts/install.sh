#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

THEME_CHOICE="${1:-night}"

case "$THEME_CHOICE" in
night)
	MODE="dark"
	ACTIVE_THEME="Rewrite Night"
	;;
day|light)
	MODE="light"
	ACTIVE_THEME="Rewrite Day"
	;;
*)
	printf 'Unknown theme choice: %s\n' "$THEME_CHOICE" >&2
	printf 'Use: %s [night|day]\n' "$0" >&2
	exit 1
	;;
esac

CONFIG_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}"
ZED_CONFIG_DIR="$CONFIG_ROOT/zed"
ZED_DATA_DIR="$DATA_ROOT/zed"
THEMES_DIR="$ZED_CONFIG_DIR/themes"
EXTENSIONS_DIR="$ZED_DATA_DIR/extensions/installed"
SETTINGS_PATH="$ZED_CONFIG_DIR/settings.json"

mkdir -p "$THEMES_DIR" "$EXTENSIONS_DIR"

ln -sfn "$PACKAGE_DIR" "$EXTENSIONS_DIR/rewrite-theme"
ln -sfn "$PACKAGE_DIR/themes/rewrite.json" "$THEMES_DIR/rewrite.json"

THEME_BLOCK=$(cat <<EOF
  "theme": {
    "mode": "$MODE",
    "light": "Rewrite Day",
    "dark": "Rewrite Night"
  }
EOF
)

if [[ -f "$SETTINGS_PATH" ]]; then
	cp "$SETTINGS_PATH" "$SETTINGS_PATH.bak"
	THEME_BLOCK="$THEME_BLOCK" perl -0pi -e '
		my $block = $ENV{"THEME_BLOCK"};
		if (s/"theme"\s*:\s*\{.*?\}(,)?/$block/s) {
			exit 0;
		}
		s/\n}\s*$/,\n$block\n}\n/s or die "Could not update settings.json\n";
	' "$SETTINGS_PATH"
else
	cat > "$SETTINGS_PATH" <<EOF
{
$THEME_BLOCK
}
EOF
fi

printf 'Rewrite Theme installed for Zed.\n'
printf 'Active theme: %s\n' "$ACTIVE_THEME"
printf 'If Zed is already open, restart it or switch themes once to reload.\n'
