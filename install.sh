#!/bin/sh
# Installs deskstance for the current user. Run with --uninstall to remove it.
set -eu

src=$(dirname "$0")
data=${XDG_DATA_HOME:-$HOME/.local/share}
dest=$data/deskstance
bin=$HOME/.local/bin/deskstance
app=$data/applications/deskstance.desktop
autostart=${XDG_CONFIG_HOME:-$HOME/.config}/autostart/deskstance.desktop

if [ "${1:-}" = --uninstall ]; then
    rm -rf "$dest" "$bin" "$app" "$autostart"
    echo "deskstance uninstalled"
    exit
fi

# deskstance finds its tray icon relative to its own location, so the icon is
# installed beside it and the script is linked onto PATH.
install -Dm755 "$src/deskstance" "$dest/deskstance"
install -Dm644 "$src/icons/deskstance-symbolic.svg" "$dest/icons/deskstance-symbolic.svg"
mkdir -p "$(dirname "$bin")" "$(dirname "$app")" "$(dirname "$autostart")"
ln -sf "$dest/deskstance" "$bin"
# ~/.local/bin is not always on PATH for desktop sessions, so use absolute paths.
sed -e "s|^Exec=deskstance|Exec=\"$dest/deskstance\"|" \
    -e "s|^Icon=deskstance-symbolic|Icon=$dest/icons/deskstance-symbolic.svg|" \
    "$src/deskstance.desktop" > "$app"
cp "$app" "$autostart"
echo "deskstance installed; it will start on your next login, or run: $bin"
