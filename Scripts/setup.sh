#!/bin/bash
# Установка CocoaPods зависимостей и Viper шаблона

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Установка зависимостей проекта ==="
echo ""

# 1. Проверка CocoaPods
if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods не найден."
    echo "Установите: sudo gem install cocoapods"
    exit 1
fi

# 2. Установка CocoaPods зависимостей
echo "📦 Установка CocoaPods подов..."
cd "$PROJECT_ROOT"
pod install
echo "✓ CocoaPods зависимости установлены"
echo ""

# 3. Установка Viper шаблона
echo "📁 Установка Viper шаблона..."
"$SCRIPT_DIR/install_template.sh"
echo ""

echo "=== Готово! ==="
echo "Откройте Todo.xcworkspace в Xcode (не Todo.xcodeproj)"
