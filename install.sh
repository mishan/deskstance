#!/bin/sh
# Installs deskstance for the current user. Run with --uninstall to remove it.
set -eu

src=$(dirname "$0")
data=${XDG_DATA_HOME:-$HOME/.local/share}
bin=$HOME/.local/bin/deskstance
icon=$data/icons/hicolor/scalable/apps/deskstance-symbolic.svg
app=$data/applications/deskstance.desktop
autostart=${XDG_CONFIG_HOME:-$HOME/.config}/autostart/deskstance.desktop

if [ "${1:-}" = --uninstall ]; then
    rm -f "$bin" "$icon" "$app" "$autostart"
    echo "deskstance uninstalled"
    exit
fi

install -Dm755 "$src/deskstance" "$bin"
install -Dm644 "$src/icons/deskstance-symbolic.svg" "$icon"
# ~/.local/bin is not always on PATH for desktop sessions, so point Exec at it directly.
mkdir -p "$(dirname "$app")" "$(dirname "$autostart")"
sed "s|^Exec=deskstance|Exec=$bin|" "$src/deskstance.desktop" > "$app"
cp "$app" "$autostart"
echo "deskstance installed; it will start on your next login, or run: $bin"
