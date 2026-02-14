# Todo

iOS приложение на Swift с архитектурой Viper.

## Требования

- **Xcode** 16.4+
- **Swift** 5.0+
- **XcodeGen** — для генерации проекта (`brew install xcodegen`)
- **iOS** 16.0+

## Сборка

### Первый запуск (полная настройка)

Запустите скрипт настройки:

```bash
cd Scripts
chmod +x setup.sh
./setup.sh
```

Скрипт выполняет:
- Разрешение SPM зависимостей (SwiftLint и др.)
- Установку Viper шаблона в Xcode Templates

### Сборка в Xcode

1. Откройте `Todo.xcodeproj` в Xcode
2. Выберите симулятор или устройство
3. Нажмите **⌘B** или **Product → Build**

## Структура проекта

```
Todo/
├── Todo/                 # Исходный код приложения
├── TodoTests/            # Unit тесты
├── Templates/            # Viper шаблон для Xcode
├── Scripts/              # Скрипты настройки
├── project.yml           # Конфигурация XcodeGen
└── Todo.xcodeproj        # Генерируется скриптом setup.sh
```

## Viper шаблон

Шаблон для быстрого создания Viper модулей. После `./setup.sh` доступен в Xcode: **File → New → File → Viper**.

Подробнее: [Templates/README.md](Templates/README.md)
