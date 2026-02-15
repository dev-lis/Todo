# Network

Локальный CocoaPods под для сетевых запросов в iOS проектах на Swift.

## Структура

```
Network/
└── Classes/
    ├── HTTPClient.swift           — протокол HTTP‑клиента
    ├── URLSessionHTTPClient.swift — реализация на URLSession
    ├── NetworkError.swift         — типы ошибок сети
    └── NetworkService.swift       — высокоуровневый сервис с поддержкой Decodable
```

## Использование

### Низкоуровневый запрос (Data + URLResponse)

```swift
let client = URLSessionHTTPClient()
let (data, response) = try await client.perform(request)
```

### Через NetworkService с декодированием

```swift
let service = NetworkService()

struct Todo: Decodable {
    let id: Int
    let title: String
}

let todos: [Todo] = try await service.request(request)
```

### Внедрение зависимости (для тестов)

```swift
let mockClient = MockHTTPClient()
let service = NetworkService(client: mockClient)
```
