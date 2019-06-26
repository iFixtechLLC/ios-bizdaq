# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

target 'Bizdaq' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # RxSwift
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  
  # UI
  pod 'Segmentio', '~> 3.0'
  pod 'TTRangeSlider'
  pod 'IHKeyboardAvoiding'
  pod 'JGProgressHUD'
  pod 'MessageKit'
  pod 'JTAppleCalendar', '~> 7.0'
  
  # Networking
  pod 'Alamofire', '~> 4.7'
  pod 'Kingfisher', '~> 4.0'
  
  # Notifications
  pod 'OneSignal', '>= 2.6.2', '< 3.0'
  
  target 'BizdaqTests' do
    inherit! :search_paths
  end
end

target 'OneSignalNotificationServiceExtension' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    pod 'OneSignal', '>= 2.6.2', '< 3.0'
end
