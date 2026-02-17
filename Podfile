platform :ios, '16.0'

target 'Todo' do
  pod 'Network', :path => 'LocalPods/Network'
  pod 'AppUIKit', :path => 'LocalPods/AppUIKit'
  pod 'Storage', :path => 'LocalPods/Storage'
  pod 'SwiftLint', '~> 0.63', :configurations => %w[Debug Dev Stage]
  pod 'Sourcery', '~> 2.0', :configurations => %w[Debug Dev Stage]
end

target 'TodoTests' do
  inherit! :search_paths
  pod 'Network', :path => 'LocalPods/Network'
  pod 'AppUIKit', :path => 'LocalPods/AppUIKit'
  pod 'Storage', :path => 'LocalPods/Storage'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
