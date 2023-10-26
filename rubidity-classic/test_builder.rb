require_relative 'builder'


source = Builder.load_file( 'PublicMintERC20' ).source
pp source


source = Builder.load_file( 'GenerativeERC721' ).source
pp source


puts "bye"