# Scripts

Вспомогательные скрипты для настройки проекта.

## Первичная настройка проекта

Зависимости проекта устанавливаются так:

1. **Ruby (Bundler)** — зависимости из `Gemfile` (в т.ч. CocoaPods):
   ```bash
   bundle install
   ```

2. **CocoaPods** — поды (Network, AppUIKit, Storage, SwiftLint, Sourcery):
   ```bash
   bundle exec pod install
   ```
   Выполнять из корня проекта. После этого открывать **Todo.xcworkspace**.

Sourcery и SwiftLint подключаются через CocoaPods, отдельная установка (SPM или gem) не нужна.

## setup.sh

Устанавливает зависимости и шаблоны одним запуском:

1. **CocoaPods** — при необходимости напомнит выполнить `bundle exec pod install`.
2. **Viper-шаблон** — копирует шаблон VIPER-модуля в Xcode Templates.

```bash
cd Scripts
chmod +x setup.sh
./setup.sh
```

Запускать из папки `Scripts` или передать путь к корню проекта.

## install_template.sh

Устанавливает только Viper-шаблон в Xcode (в `~/Library/Developer/Xcode/Templates/File Templates/`).

```bash
cd Scripts
chmod +x install_template.sh
./install_template.sh
```

После установки шаблон доступен в Xcode: **File → New → File → Viper**.
