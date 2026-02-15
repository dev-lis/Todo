# Network

Локальный CocoaPods под для работы с сетевыми запросами.

## Структура

```
Network/
├── Network.podspec
└── Network/
    └── Classes/
        ├── HTTPClient.swift           — Протокол HTTP клиента
        └── URLSessionHTTPClient.swift — Реализация на URLSession
```

## Подключение

Под подключён в Podfile:

```ruby
pod 'Network', :path => 'Network'
```

После `pod install` под доступен в проекте.
