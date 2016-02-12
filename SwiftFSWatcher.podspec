Pod::Spec.new do |s|

  s.name         = "SwiftFSWatcher"
  s.version      = "0.1.0"
  s.summary      = "A simple easy to use / extend File System watcher using Swift."

  s.homepage     = "https://github.com/gurinderhans/SwiftFSWatcher"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Gurinder Hans" => "hello@gurinderhans.me" }
  s.social_media_url   = "http://twitter.com/itsgurinderhans"

  s.platform     = :osx

  s.source       = { :git => "https://github.com/gurinderhans/SwiftFSWatcher.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "SwiftFSWatcher/SwiftFSWatcher*.{h,m}"

end
