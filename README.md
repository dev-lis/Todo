# Todo

iOS-приложение на Swift с архитектурой VIPER.

## Требования

- **Xcode** 16+
- **Swift** 5.0+
- **iOS** 16.0+
- **CocoaPods** — установка через Bundler (см. ниже)
- **Ruby** (Bundler) — для `bundle exec pod install`

## Первый запуск

```bash
# Установка Ruby-зависимостей (CocoaPods и др.)
bundle install

# Установка подов (Network, AppUIKit, Storage, SwiftLint, Sourcery)
bundle exec pod install

# Открыть проект в Xcode (обязательно .xcworkspace)
open Todo.xcworkspace
```

После этого в Xcode выберите схему **Dev** (или **Stage**) и соберите проект (**⌘B**).

## Схемы

| Схема           | Назначение |
|-----------------|------------|
| **Dev**         | Сборка и запуск приложения (конфигурация Dev) |
| **Stage**       | Сборка и запуск (Stage) |
| **Todo**        | Сборка по умолчанию (Debug) |
| **Tests**       | Запуск unit-тестов. Использовать **Product → Test** (⌘U) |
| **Generate Mocks** | Только генерация моков (Sourcery), без запуска приложения |

## Сборка и запуск

1. Откройте **Todo.xcworkspace** (не .xcodeproj).
2. Выберите схему **Dev** или **Stage**.
3. Выберите симулятор или устройство.
4. **⌘R** — запуск приложения, **⌘B** — только сборка.

## Тесты

1. Выберите схему **Tests**.
2. **⌘U** (Product → Test) — запуск всех тестов.

Моки для протоколов генерируются Sourcery и лежат в `TodoTests/Generated/`. Они пересобираются при сборке таргетов Todo и TodoTests. Подробнее про моки — в разделе [Sourcery](#sourcery).

## CI (GitHub Actions)

При **push** и **Pull Request** в ветки `main`, `master`, `develop` автоматически запускается workflow **Tests**:

- Устанавливаются зависимости (`bundle install`, `pod install`).
- Запускаются unit-тесты на симуляторе (схема **Todo**, таргет TodoTests).

Конфигурация: [.github/workflows/test.yml](.github/workflows/test.yml). Раннеры GitHub-hosted, отдельная настройка не требуется.

## Структура проекта

```
Todo/
├── Todo/                    # Исходный код приложения
│   ├── Coordinators/        # Координаторы навигации
│   ├── DI/                  # Service Locator, конфигурация
│   ├── Models/              # DTO, маппинг (Entity ↔ DTO)
│   ├── Modules/             # VIPER-модули (например TodoList)
│   ├── Resources/           # Info.plist, локализация
│   └── Services/            # Сетевой слой, билдеры запросов
├── TodoTests/               # Unit-тесты
│   ├── Generated/           # Сгенерированные моки (Sourcery)
│   └── ...
├── LocalPods/               # Локальные CocoaPods-модули
│   ├── AppUIKit/            # UI-компоненты, форматтеры
│   ├── Network/             # Сетевой слой
│   └── Storage/             # Core Data, репозиторий
├── Templates/               # Шаблоны
│   ├── AutoMockable.stencil # Шаблон Sourcery для моков
│   └── Viper.xctemplate     # Шаблон Xcode для VIPER-модулей
├── Scripts/                  # Скрипты настройки (setup, шаблоны)
├── .github/workflows/       # CI (тесты на PR/push)
├── Podfile                  # Зависимости CocoaPods
├── Todo.xcworkspace         # Открывать в Xcode (после pod install)
└── Todo.xcodeproj
```

## Зависимости

- **CocoaPods** (через Gemfile): CocoaPods, зависимости для скриптов.
- **Поды**: Network, AppUIKit, Storage (локальные из `LocalPods/`), SwiftLint и Sourcery (конфигурации Debug, Dev, Stage).
- **TodoTests** наследует пути поиска подов и использует те же модули (Network, AppUIKit, Storage) для тестов.

## Sourcery (моки)

Моки для протоколов генерируются автоматически при сборке.

- **Аннотация**: добавьте к протоколу комментарий `// sourcery: AutoMockable`.
- **Шаблон**: [Templates/AutoMockable.stencil](Templates/AutoMockable.stencil).
- **Выход**: `TodoTests/Generated/AutoMockable.generated.swift` (только в таргете TodoTests).
- **Конфиг**: [.sourcery.yml](.sourcery.yml).

Ручной запуск (из корня проекта):

```bash
./Pods/Sourcery/bin/sourcery
```

Либо схема **Generate Mocks** в Xcode (Pre-Action запускает Sourcery).

## SwiftLint

Запускается при сборке таргета Todo (Run Script). Правила и исключения: [.swiftlint.yml](.swiftlint.yml). Проверка **TodoTests** и **Todo/Generated** отключена (каталоги в `excluded`).

## Viper-шаблон

Шаблон Xcode для быстрого создания VIPER-модулей. После установки (см. [Scripts/README.md](Scripts/README.md)) доступен: **File → New → File → Viper**.

Подробнее: [Templates/README.md](Templates/README.md).

## Дополнительно

- **Scripts**: установка зависимостей и Viper-шаблона — [Scripts/README.md](Scripts/README.md).
