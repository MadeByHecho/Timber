Pod::Spec.new do |s|
  s.name         = "Timber"
  s.version      = "0.1.0"
  s.summary      = "A debug log framework for use in Swift projects."

  s.description  = <<-DESC
                    Allows you to log details to the console (and optionally a file), just like you would have with NSLog or println, but with additional information, such as the date, function name, filename and line number.
                    DESC
  s.homepage     = "https://github.com/ScottPetit/Timber"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Scott Petit" => "petit.scott@gmail.com" }
  s.social_media_url   = "http://twitter.com/ScottPetit"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/ScottPetit/Timber.git", :tag => "v0.1.0" }
  s.source_files  = "Timber/*.swift"

  s.framework  = "Foundation"
end
