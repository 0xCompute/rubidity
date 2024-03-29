module Rubysol
  module Module
    module Lang
      MAJOR = 0
      MINOR = 1
      PATCH = 0
      VERSION = [MAJOR,MINOR,PATCH].join('.')
    
      def self.version
        VERSION
      end
    
      def self.banner
        "rubysol/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
      end
    
      def self.root
        File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
      end
    
    end # module Lang
  end # module Module
end # module Rubysol
