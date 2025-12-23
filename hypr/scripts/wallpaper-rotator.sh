#!/bin/bash

# Конфигурация
WALL_DIR="$HOME/.config/hypr/wallpapers"
INTERVAL=300

# Запуск демона, если он не запущен
swww query || swww-daemon &

while true; do
  # 1. Получаем путь текущих обоев
  CURRENT_WP=$(swww query | grep 'image: ' | sed 's/.*image: //')

  # 2. Выбираем случайный файл, исключая текущий
  NEXT_WP=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | grep -vF "$CURRENT_WP" | shuf -n 1)

  # 3. Устанавливаем новые обои, если файл найден
  if [ -n "$NEXT_WP" ]; then
    swww img "$NEXT_WP" --transition-type wipe --transition-duration 2
  fi

  # 4. Ожидание
  sleep "$INTERVAL"
done
