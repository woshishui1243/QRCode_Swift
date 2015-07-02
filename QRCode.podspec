Pod::Spec.new do |s|
s.name          = 'QRCode'
s.version       = 'v1.0.0'
s.summary       = 'QRCode in Swift'
s.description   = <<-DESC
QRCode in Swift  V1
DESC
s.homepage     = "https://git.oschina.net/woshishui1243/QRCode_Swift.git"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author             = { "DaYu" => "dayu_0518@163.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://git.oschina.net/woshishui1243/QRCode_Swift.git", :tag => s.version}
s.source_files = "QRCode/Source/*.swift"
s.resources    = "QRCode/Source/*.xcassets", "QRCode/Source/*.xib", "QRCode/Source/*.plist", "QRCode/Source/*.htm"
s.public_header_files = "QRCode/Source/*.h"
s.framework  = "AVFoundation"
s.requires_arc = true

end