####
# to run use:
#   $ ruby sandbox/library

require_relative 'helper'


module LibHello
    extend Library

    sig []
    def hello
      puts 'hello'
    end
 
    sig []
    def hi
       puts 'hi'
    end

    sig [String]
    def greet( name: )
        puts "Hello, #{name}!"
    end
end  # module LibHello


module LibAsset
  extend Library

  struct :AssetType, 
     assetClass: Bytes,
     data:       Bytes 

   struct :Asset,
     assetType: AssetType,
     value:     UInt

   sig [AssetType], :pure, returns: Bytes   
   def dumpAssetType( assetType: )
      puts "assetType.assetClass: #{assetType.assetClass}" 
      puts "assetType.data:       #{assetType.data}"

      "0x11"
   end

   ## note: CANNOT overload function only by input type
   sig [Asset], :pure, returns: Bytes
   def dumpAsset( asset: )
      dumpAssetType( asset.assetType )
      puts "asset.value: #{asset.value}"
      
      "0x22"
  end
end  # module LibHello



LibHello.hello
LibHello.hi

LibHello.greet( name: 'World' )
LibHello.greet( 'World' )


pp LibAsset::AssetType
pp LibAsset::Asset

assetType = LibAsset::AssetType.new(
                assetClass:  '0xaaaa',
                data:        '0xffff' )
pp assetType

asset = LibAsset::Asset.new( 
                assetType: assetType,
                value:     123 )
pp asset


LibAsset.dumpAssetType( assetType: assetType )
LibAsset.dumpAssetType( assetType )

LibAsset.dumpAsset( asset: asset )
LibAsset.dumpAsset( asset )


puts "bye"