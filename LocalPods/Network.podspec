Pod::Spec.new do |s|
  s.name             = 'Network'
  s.version          = '0.1.0'
  s.summary          = 'HTTP client для сетевых запросов'
  s.description      = 'Локальный CocoaPods под для работы с сетевыми запросами в iOS проектах на Swift'
  s.homepage         = 'https://github.com/dev-lis/Todo'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Aleksandr Lis' => 'mr.aleksandr.lis@gmail.com' }
  s.source           = { path: '.' }
  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'
  s.source_files = 'Network/Classes/**/*.swift'
end
