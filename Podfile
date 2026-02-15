platform :ios, '16.0'

target 'Todo' do
  pod 'Network', :path => 'LocalPods/Network'
  pod 'AppUIKit', :path => 'LocalPods/AppUIKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
