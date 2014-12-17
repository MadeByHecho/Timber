Pod::Spec.new do |s|
  s.name         = "Timber"
  s.version      = "0.0.1"
  s.summary      = "A debug log framework for use in Swift projects."

  s.description  = <<-DESC
                    Allows you to log details to the console (and optionally a file), just like you would have with NSLog or println, but with additional information, such as the date, function name, filename and line number.
                    DESC
  s.homepage     = "https://github.com/ScottPetit/Timber"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author             = { "Scott Petit" => "petit.scott@gmail.com" }
  s.social_media_url   = "http://twitter.com/ScottPetit"
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/ScottPetit/Timber.git", :commit => "51c7629a96122924072b67f349ea95cdaff3727c" }
  s.source_files  = "Timber/*.swift"

  s.framework  = "Foundation"
  s.compiler_flags = '-DSWIFT_OPTIMIZATION_LEVEL=-Onone'
end