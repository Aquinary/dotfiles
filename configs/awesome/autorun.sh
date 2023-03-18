#!/usr/bin/env bash

# Меняем раскладку мыши (т.е. пкм меняем на лкм)

if ! $(pgrep qemu>/dev/null); then
  xmodmap -e "pointer = 3 2 1" &
fi

# Переключение раскладки на капс 
setxkbmap -device $(xinput list --id-only "Virtual core XTEST keyboard") -layout "us,ru" -option grp:caps_toggle
setxkbmap -layout "us,ru" -option grp:caps_toggle


# Менеджер буфера
if ! $(pgrep copyq >/dev/null); then
  copyq &
fi


# Скриншотер
if ! $(pgrep crow >/dev/null); then
  crow &
fi

# GUI аунтификация для рута
if ! $(pgrep polkit-gnome-authentication-agent-1 >/dev/null); then
 # $HOME/.nix-profile/libexec/polkit-gnome-authentication-agent-1 &
  $HOME/.nix-profile/libexec/polkit-mate-authentication-agent-1 &
fi

# Композитор
if ! $(pgrep picom >/dev/null); then
  picom --animations &
fi

# Регулировка громкости через GUI
if ! $(pgrep volctl >/dev/null); then
  volctl &
fi

# Установка заставки рабочего стола. Делаем не через WM, так как иногда она устанавливает заставку только на один рабочий стол
if ! $(pgrep feh >/dev/null); then
  feh --bg-fill /home/$USER/.config/awesome/images/wall.png &
fi

# Запуск клиента для шаринка переферии
if ! $(pgrep barrierc>/dev/null); then
  barrierc --disable-crypto --name yoshinon -f 192.168.122.48 &
fi

# gnome-keyring
dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets
