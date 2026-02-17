Pod::Spec.new do |s|
  s.name             = 'Storage'
  s.version          = '0.1.0'
  s.summary          = 'Локальное хранилище и работа с данными'
  s.description      = 'Локальный модуль для сохранения и чтения данных в iOS приложениях: Core Data, UserDefaults, файловая система, кэширование.'
  s.homepage         = 'https://github.com/dev-lis/Todo'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Aleksandr Lis' => 'mr.aleksandr.lis@gmail.com' }
  s.source           = { path: '.' }
  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'
  s.source_files = 'Storage/Classes/**/*.swift'
end
