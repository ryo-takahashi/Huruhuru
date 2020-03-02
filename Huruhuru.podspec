Pod::Spec.new do |spec|
  spec.name         = "Huruhuru"
  spec.version      = "0.7.0"
  spec.summary      = "support issue reporting development tool"
  spec.homepage     = "https://twitter.com/k0uhashi"
  spec.license         = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "ryo-takahashi" => "ryo.takahashi.work@gmail.com" }
  spec.source       = { :git => "https://github.com/ryo-takahashi/huruhuru.git", :tag => "#{spec.version}" }

  spec.source_files  = "Huruhuru/**/*.{swift}"
  spec.resources     = "Huruhuru/**/*.{xib,png}"
  spec.exclude_files = "Classes/Exclude"
  spec.swift_version = "5.1"
  spec.platform      = :ios, "10.0"
end
