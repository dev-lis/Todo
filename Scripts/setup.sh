#!/bin/bash
# Установка SPM зависимостей и Viper шаблона

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_FILE="$PROJECT_ROOT/Todo.xcodeproj"

echo "=== Установка зависимостей проекта ==="
echo ""

# 1. Разрешение SPM зависимостей
echo "📦 Разрешение SPM пакетов..."
xcodebuild -resolvePackageDependencies -project "$PROJECT_FILE" -scheme Todo
echo "✓ SPM зависимости установлены"
echo ""

# 2. Установка Viper шаблона
echo "📁 Установка Viper шаблона..."
"$SCRIPT_DIR/install_template.sh"
echo ""

echo "=== Готово! ==="
