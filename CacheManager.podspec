Pod::Spec.new do |s|

s.name         = "CacheManager"
s.version      = "0.0.2"
s.summary      = "CacheManager"

s.homepage     = "https://github.com/mackoj/swift-cache-manager"
s.license      = "MIT"
s.author             = { "Jeffrey MACKO" => "github.jm@macko.fr" }
s.platform     = :ios, "11.0"

s.source       = { :git => "git@github.com:mackoj/swift-cache-manager.git", :tag => "#{s.version}" }

spec.source_files  = "Sources/swift-cache-manager/**/*.{swift}"

s.swift_version = '5.0'

end
