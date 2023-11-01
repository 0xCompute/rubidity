module Rubidity
  module Module
    module Lang
      MAJOR = 0
      MINOR = 8
      PATCH = 2
      VERSION = [MAJOR,MINOR,PATCH].join('.')
    
      def self.version
        VERSION
      end
    
      def self.banner
        "rubidity/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
      end
    
      def self.root
        File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
      end
    
    end # module Lang
  end # module Module
end # module Rubidity
