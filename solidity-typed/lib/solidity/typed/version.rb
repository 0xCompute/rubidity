module Solidity
  module Module
    module Typed
      MAJOR = 0
      MINOR = 2
      PATCH = 1
      VERSION = [MAJOR,MINOR,PATCH].join('.')
    
      def self.version
        VERSION
      end
    
      def self.banner
        "solidity-typed/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
      end
    
      def self.root
        File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
      end
    
    end # module Typed
  end # module Module
end # module Solidity