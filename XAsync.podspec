Pod::Spec.new do |s|
  s.name                  = "XAsync"
  s.version               = "1.0.0"
  s.summary               = "Convenient wrapper for async operations."
  s.description           = "Allows to write an asyncronous code in synchronous manner. Inspired by C#'s await instruction."
  s.cocoapods_version     = ">= 0.36"
  s.homepage              = "https://github.com/p-orbitum/XAsync"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Pavlo Gorb" => "p.orbitum@gmail.com" }
  s.platforms             = { :osx => "10.11", :ios => "8.0", :watchos => "2.0", :tvos => "9.0" }
  s.source                = { :git => "https://github.com/p-orbitum/XAsync.git", :tag => s.version }  
  s.module_name           = "XAsync"
  s.source_files          = "Content/**/*"
  s.requires_arc          = true
end