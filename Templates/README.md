# Viper Module Template

Шаблон Xcode для быстрого создания Viper-модулей в iOS-проектах.

## Структура модуля

При создании модуля с именем `TodoList` генерируются следующие файлы в папке `Modules`:

```
Modules/
└── TodoList/
    ├── TodoListViewController.swift       — UIViewController, отображает UI
    ├── TodoListAssembly.swift             — Сборка модуля (DI)
    ├── TodoListPresenter.swift            — Бизнес-логика презентации
    ├── TodoListInteractor.swift           — Работа с данными и сервисами
    └── TodoListRouter.swift               — Навигация
```

Папка `Modules` создаётся автоматически при первом использовании шаблона.

## Установка

### Через терминал

```bash
cd Scripts
chmod +x install_template.sh
./install_template.sh
```

### Вручную

Скопируйте папку `Viper.xctemplate` в:

```
~/Library/Developer/Xcode/Templates/File Templates/
```

## Использование

1. В Xcode: **File → New → File** (⌘N)
2. Выберите шаблон **Viper** в разделе iOS
3. Введите имя модуля (например: `TodoList`, `TaskDetail`)
4. Нажмите **Create**

## Интеграция с Coordinator

После создания модуля добавьте его в `AppCoordinator` или дочерний Coordinator:

```swift
// Пример: показать TodoList модуль
let todoListVC = TodoListAssembly.asseble()
rootController?.pushViewController(todoListVC, animated: true)
```

## Примечание

Xcode создаёт папку как физическую директорию. Если нужно создать Xcode Group:

1. ПКМ по родительской группе → **Add Files to "..."**
2. Выберите созданную папку модуля
3. Выберите **Create groups**
4. Удалите старую ссылку на папку (Remove reference)
