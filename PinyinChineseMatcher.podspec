#
# Be sure to run `pod lib lint PinyinChineseMatcher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PinyinChineseMatcher'
  s.version          = '0.1.2'
  s.summary          = 'Given Chinese String and pinyin, find all ranges in Chinese String that matches pinyin'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    This Library is mean to help highlight Chinese text which match related pinyin
    这个库可以用来实现根据拼音高亮汉字
                       DESC

  s.homepage         = 'https://github.com/wrlqwe/PinyinChineseMatcher'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wrlqwe' => '515045622@qq.com' }
  s.source           = { :git => 'https://github.com/wrlqwe/PinyinChineseMatcher.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PinyinChineseMatcher/Classes/**/*'

  s.default_subspec = 'Pinyin4Objc'
  # s.resource_bundles = {
  #   'PinyinChineseMatcher' => ['PinyinChineseMatcher/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.subspec 'Pinyin4Objc' do |sp|
    sp.source_files = 'PinyinChineseMatcher/Pinyin4Objc/**/*'
    sp.dependency 'PinYin4Objc_FrameworksSupport', '~> 1.1.2'
  end
end
