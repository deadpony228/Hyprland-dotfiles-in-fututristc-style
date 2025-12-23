WALLPAPER_DIR="~/.config/hypr/wallpapers/"

# Проверяем, существует ли папка
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Ошибка: Папка $WALLPAPER_DIR не найдена."
  exit 1
fi
# 1. Выбираем один случайный файл из указанной директории
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

# 2. Устанавливаем его
if [ -f "$RANDOM_WALLPAPER" ]; then
  swww img "$RANDOM_WALLPAPER" \
    --transition-type grow \
    --transition-duration 0.5 # Быстрый эффект перехода
else
  echo "Error: Wallpaper not found."
fi
