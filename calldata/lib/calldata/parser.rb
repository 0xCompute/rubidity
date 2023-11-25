
class Calldata

   def self.valid_data?( utf8 )
        DataUri.valid?( utf8 )
   end

   ## add alias convenience names - why? why not?
   class << self 
     alias_method :is_data?,    :valid_data?
     alias_method :data?,       :valid_data?
   end



   ## check - use its own method (or check args to "automagically" decode_hex) - why? why not?
   def self.parse_hex( hex )  parse_data( decode( hex )); end

   def self.parse_data( utf8 )
       data, type = DataUri.parse( utf8 )  ## note: data, type order switched in datauris 1.0.1+
        
       binary = if type 
                   if type.start_with?( 'image/svg+xml' )
                        false
                   elsif type.start_with?( 'image/') ||
                         type.start_with?( 'application/octet-stream' )
                        true
                   else 
                        false
                   end
                else # no type (assume text)
                  false
                end
   
       if binary
          blob = data.b
          Blob.new( blob, type )
       else
          text = data.force_encoding( 'UTF-8' )
          if type == '' ## "automagically - check if text is json or not - why? why not?
              if Msg.valid?( text )
                 Msg.parse( text )
              else
                 Text.new( text, 'text/plain' )  ## assume text/plain
              end
          else
             if type.start_with?( 'application/json')
                Msg.parse( text ) 
             else
                Text.new( text, type )
             end
          end
       end
   end


   ## use embedded classes - why? why not?
   ##   e.g. Inscribe, Transfer, ContractCall, ContractCreate/Deploy, etc. 
   ##        use InscribeText, InscribeData/Struct and InscribeBlob - why? why not?
   class Text < Calldata  ## or use CalldataInscribe or CalldataText or CalldataBlob??
      attr_reader :type, :text
      def initialize( text, type )
         @text = text
         @type = type   ## parse type (split off parameter and such - why? why not?)
      end

      def write( path ) write_text( path, @text ); end
   end # class Text

   class Blob < Calldata
      attr_reader :type, :blob
      def initialize( blob, type )
         @blob = blob
         @type = type   ## parse type (split off parameter and such - why? why not?)
      end

      def write( path ) write_blob( path, @blob ); end
   end

   class Msg < Calldata

      def self.valid?( text )
         ## quick check for now
         ##  stripped text MUST start with { and  end with }
         ##  for auto-detect 
         text = text.strip
         text.start_with?( '{') && text.end_with?( '}' )
      end

      def self.parse( text )
         data = JSON.parse( text )
         new( data )
      end

      attr_reader :type, :data
      def initialize( data )
         @data = data
         @type = 'application/json'
      end

      ## add direct hash-like methods - why? why not?
      def [](key) @data[key]; end
      def key?( key ) @data.key?( key); end
      alias_method :has_key?, :key?
      def keys() @data.keys; end
      def values() @data.values; end
     
      def to_h() @data; end

      def write( path ) write_json( path, @data ); end
   end
end   # class Calldata
