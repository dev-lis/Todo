#!/bin/bash
# Установка Viper модуля в Xcode Templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_SOURCE="$PROJECT_ROOT/Templates/Viper.xctemplate"
XCODE_TEMPLATES_DIR="$HOME/Library/Developer/Xcode/Templates/File Templates"

echo "Установка Viper шаблона..."
echo "Источник: $TEMPLATE_SOURCE"
echo "Назначение: $XCODE_TEMPLATES_DIR"

# Создаём директорию если её нет
mkdir -p "$XCODE_TEMPLATES_DIR"

# Копируем шаблон
if [ -d "$XCODE_TEMPLATES_DIR/$TEMPLATE_NAME" ]; then
    rm -rf "$XCODE_TEMPLATES_DIR/$TEMPLATE_NAME"
fi
cp -R "$TEMPLATE_SOURCE" "$XCODE_TEMPLATES_DIR/"

echo "✓ Viper шаблон успешно установлен!"
echo ""
echo "Использование:"
echo "  1. В Xcode: File → New → File (⌘N)"
echo "  2. Выберите 'Viper' в разделе iOS"
echo "  3. Введите имя модуля (например: TodoList)"
echo "  4. Нажмите Create"
echo ""
echo "Модуль создаётся в папке Modules/ИмяМодуля/:"
echo "  - View"
echo "  - Assembly"
echo "  - Interactor"
echo "  - Presenter"
echo "  - Router"
