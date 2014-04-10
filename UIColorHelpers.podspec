Pod::Spec.new do |s|
  s.name         = "UIColorHelpers"
  s.platform     = :ios
  s.version      = "1.0.1"
  s.summary      = "UIColorHelpers is a collecion of factory method extensions for generating colors from hex and 8bit RGB values."
  s.homepage     = "https://github.com/willowtreeapps/uicolor-helpers"
  s.license      = "MIT"
  s.authors      = { "Joel Garrett" => "joel.garrett@willowtreeapps.com" }
  s.source       = { :git => "https://github.com/willowtreeapps/uicolor-helpers.git", :tag => '1.0.1' }
  s.framework    = 'CoreGraphics', 'UIKit'
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.requires_arc = true
end
