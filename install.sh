#!/bin/bash

# Остановить выполнение при любой ошибке
set -e

# --- Цвета для оформления ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}   Hyprland Setup: Tokyo Night Edition    ${NC}"
echo -e "${BLUE}==========================================${NC}"

# 1. Проверка на Arch Linux
if [ ! -f /etc/arch-release ]; then
  echo -e "${RED}✘ Ошибка: Скрипт предназначен только для Arch Linux.${NC}"
  exit 1
fi

# 2. Установка помощника AUR (yay), если его нет
if ! command -v yay &>/dev/null; then
  echo -e "${BLUE}➜ Установка yay (AUR helper)...${NC}"
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
fi

# 3. Полный список пакетов для твоей системы и скриптов
PACKAGES=(
  # Ядро системы
  "hyprland"
  "waybar"
  "kitty"
  "wofi"
  "swww"

  # Инструменты для твоих скриптов (powermenu, rotator и др.)
  "grim"         # Скриншоты
  "slurp"        # Выбор области экрана
  "wl-clipboard" # Работа с буфером обмена
  "cliphist"     # История буфера
  "hyprlock"     # Блокировщик экрана для powermenu
  "libnotify"    # Уведомления системы
  "jq"           # Парсинг JSON

  # Внешний вид и шрифты
  "ttf-iosevka-nerd"
  "ttf-font-awesome"
  "nwg-look"     # GTK темы
  "qt6ct"        # Темы для Qt6 приложений
  "polkit-gnome" # Графическая авторизация (sudo в GUI)
)

echo -e "${BLUE}➜ Проверка и установка пакетов...${NC}"
for pkg in "${PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo -e "${GREEN}✓ $pkg уже установлен${NC}"
  else
    echo -e "${BLUE}➜ Установка $pkg...${NC}"
    yay -S --needed --noconfirm "$pkg" || echo -e "${RED}! Не удалось установить $pkg${NC}"
  fi
done

# 4. Создание символьных ссылок (Связываем репозиторий с ~/.config)
CONFIG_DIR="$HOME/.config"
DOT_DIR=$(realpath .)
MODULES=("hypr" "waybar" "kitty" "wofi")

echo -e "${BLUE}➜ Настройка конфигурационных файлов...${NC}"
mkdir -p "$CONFIG_DIR"

for module in "${MODULES[@]}"; do
  if [ -d "$DOT_DIR/$module" ]; then
    # Удаляем старую папку или старый симлинк перед созданием нового
    rm -rf "$CONFIG_DIR/$module"
    ln -s "$DOT_DIR/$module" "$CONFIG_DIR/$module"
    echo -e "${GREEN}✓ Модуль $module подключен через симлинк${NC}"
  else
    echo -e "${RED}! Папка $module не найдена в директории dotfiles${NC}"
  fi
done

# 5. Настройка прав доступа для твоих скриптов
if [ -d "$DOT_DIR/hypr/scripts" ]; then
  echo -e "${BLUE}➜ Делаем скрипты исполняемыми...${NC}"
  chmod +x "$DOT_DIR/hypr/scripts/"*.sh
  echo -e "${GREEN}✓ Права доступа настроены${NC}"
fi

# 6. Финальное сообщение
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}✨ Установка завершена успешно!${NC}"
echo -e "${BLUE}Инфо: Перезагрузите систему или выйдите из сессии,${NC}"
echo -e "${BLUE}чтобы все изменения вступили в силу.${NC}"
echo -e "${BLUE}==========================================${NC}"
