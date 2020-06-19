#
# Be sure to run `pod lib lint NNPlateKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NNPlateKeyboard'
  s.version          = '1.4.1'
  s.summary          = '车牌键盘重构（重写级别）'
  s.description      = '车牌键盘重构（重写级别）,详情见代码'

  s.homepage         = 'https://github.com/shang1219178163/NNPlateKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shang1219178163' => 'shang1219178163@gmail.com' }
  s.source           = { :git => 'https://github.com/shang1219178163/NNPlateKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = "5.0"
  s.requires_arc = true
  
  s.source_files = 'NNPlateKeyboard/Classes/**/*'
  s.resource_bundles = {
     'NNPlateKeyboard' => ['NNPlateKeyboard/*.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#   s.dependency 'SwiftExpand', '~> 1.9.6.5'
   s.dependency 'SwiftExpand'
   s.dependency 'SnapKit'
   s.dependency 'SnapKitExtend'
end
