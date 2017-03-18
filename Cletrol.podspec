Pod::Spec.new do |s|
  s.name = 'Cletrol'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Simple data delegator view controller with coordination'
  s.homepage = 'https://github.com/davoda/Cletrol'
  s.social_media_url = 'https://twitter.com/NSDavidObject'
  s.authors = { 'David Elsonbaty' => 'dave@elsonbaty.ca' }
  s.source = { :git => 'https://github.com/davoda/Cletrol.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Cletrol/**/*.swift'

  s.requires_arc = true
end
