Pod::Spec.new do |s|
  s.name     = 'TGLExpandingButton'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A control that expands and collapses when one of its button subviews is tapped -- perfect for simple menus or option selection.'
  s.homepage = 'https://github.com/gleue/TGLExpandingButton'
  s.authors  = { 'Tim Gleue' => 'tim@gleue-interactive.com' }
  s.source   = { :git => 'https://github.com/gleue/TGLExpandingButton.git', :tag => s.version.to_s }
  s.source_files = 'TGLExpandingButton'

  s.requires_arc = true
  s.platform = :ios, '9.0'
end
