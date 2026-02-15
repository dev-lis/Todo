# Todo

iOS приложение на Swift с архитектурой Viper.

## Требования

- **Xcode** 16.4+
- **Swift** 5.0+
- **CocoaPods** — `sudo gem install cocoapods`
- **iOS** 16.0+

## Сборка

### Первый запуск (полная настройка)

```bash
cd Scripts
chmod +x setup.sh
./setup.sh
```

Скрипт выполняет:
- Установку CocoaPods зависимостей (Network и др.)
- Установку Viper шаблона в Xcode Templates

### Сборка в Xcode

1. Откройте **Todo.xcworkspace** в Xcode (не .xcodeproj)
2. Выберите симулятор или устройство
3. Нажмите **⌘B** или **Product → Build**

## Структура проекта

```
Todo/
├── Todo/                 # Исходный код приложения
├── TodoTests/            # Unit тесты
├── Network/              # Локальный CocoaPods под (сеть)
├── Templates/            # Viper шаблон для Xcode
├── Scripts/              # Скрипты настройки
├── Podfile               # CocoaPods зависимости
├── Todo.xcworkspace      # Открывать в Xcode (после pod install)
└── Todo.xcodeproj
```

## Viper шаблон

Шаблон для быстрого создания Viper модулей. После `./setup.sh` доступен в Xcode: **File → New → File → Viper**.

Подробнее: [Templates/README.md](Templates/README.md)
