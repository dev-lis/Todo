Pod::Spec.new do |s|
  s.name             = 'Network'
  s.version          = '0.1.0'
  s.summary          = 'HTTP client для сетевых запросов'
  s.description      = 'Локальный CocoaPods под для работы с сетевыми запросами'
  s.homepage         = 'https://github.com/aleksandr/Todo'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = 'Aleksandr'
  s.source           = { path: '.' }
  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'
  s.source_files = 'Network/Classes/**/*.swift'
end
