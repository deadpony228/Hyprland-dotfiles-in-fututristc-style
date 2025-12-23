#!/bin/bash

# Варианты меню
op1="󰐥 Выключить"
op2="󰜉 Перезагрузить"
op3="󰤄 Сон"
op4="󰗽 Выйти"
op5="󰘚 Заблокировать"

options="$op1\n$op2\n$op3\n$op4\n$op5"

# --location 0 ставит окно ровно по центру
# --yoffset 0 убирает смещение
chosen="$(echo -e "$options" | wofi --dmenu --prompt "Действие:" --width 350 --height 300 --location 0 --style ~/.config/wofi/style.css --cache-file /dev/null)"

case $chosen in
$op1)
  systemctl poweroff
  ;;
$op2)
  systemctl reboot
  ;;
$op3)
  systemctl suspend
  ;;
$op4)
  hyprctl dispatch exit
  ;;
$op5)
  hyprlock
  ;; # или hyprlock, если используешь его
esac
