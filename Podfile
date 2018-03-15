platform :ios, '10.3'

source 'https://github.com/CocoaPods/Specs.git'
source 'git@git.i.masterinter.net:master_ios/podspecs.git'

def core_pods
    pod 'SnapKit', '~> 3.2.0'
    pod 'XCGLogger', '~> 5.0.5' # Swift 3.0-3.2
    pod 'RealmSwift'
end

target 'GlyphMaker' do
  use_frameworks!

  core_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
