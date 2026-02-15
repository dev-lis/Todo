Pod::Spec.new do |s|
  s.name             = 'AppUIKit'
  s.version          = '0.1.0'
  s.summary          = 'UI‑компоненты, расширения и утилиты для UIKit'
  s.description      = 'Локальный модуль с переиспользуемыми UI‑компонентами, расширениями UIKit и утилитами для работы с интерфейсом'
  s.homepage         = 'https://github.com/dev-lis/Todo'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Aleksandr Lis' => 'mr.aleksandr.lis@gmail.com' }
  s.source           = { path: '.' }
  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'
  s.source_files = 'AppUIKit/Classes/**/*.swift'
end
