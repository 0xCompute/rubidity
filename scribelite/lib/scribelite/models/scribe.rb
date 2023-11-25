
module ScribeDb
    module Model
  
  class Scribe < ActiveRecord::Base
    has_one :tx, foreign_key: 'id'
 
    ## convernience helper
    ##  forward to blob.content
    ##    blob.content - encoding is BINARY (ASCII-7BIT)
    ##    blob.text    - force_encoding is UTF-8 (return a copy)
    # def content() blob.content; end
    # def text() blob.text; end


    ################################
    ### scope like helpers
    def self.png() where( content_type: 'image/png' ); end
    def self.gif() where( content_type: 'image/gif' ); end
    def self.jpg() where( content_type: 'image/jpeg' ); end
    def self.webp() where( content_type: 'image/webp' ); end
    def self.svg()  where( content_type: 'image/svg+xml' ); end
    def self.avif() where( content_type: 'image/avif' ); end

    class << self
       alias_method :jpeg, :jpg
    end     

    def self.image  
         ## change to/or add alias e.g. image/images - why? why not
        where( content_type: [
            'image/png',
            'image/jpeg',
            'image/gif',
            'image/webp',
            'image/svg+xml',
            'image/avif',
            ])
    end

    def self.html
        where( content_type: [
           'text/html;charset=utf-8',
           'text/html',
          ])
    end

    def self.js
        where( content_type: [
           'text/javascript',
           'application/javascript',
          ])
    end

     class << self
        alias_method :javascript, :js
     end     
 
    def self.text
        ## change to/or add alias e.g. text/texts - why? why not
        ## include html or svg in text-only inscription - why? why not?
        ##  include markdown in text-only inscription - why? why not?
        ##   make content_type lower case with lower() - why? why not?
        where( content_type: [
                  'text/plain',
                  'text/plain;charset=utf-8',
                  'text/plain;charset=us-ascii',
                  'application/json',
             ])
    end
 
=begin    
    def self.search( q )   ## "full-text" search helper
        ##  rename to text_search - why? why not?        
        ## auto-sort by num - why? why not?
        joins(:blob).text.where( "content LIKE '%#{q}%'" ).order('num')
    end
=end    
    
   def self.sub1k()  where( 'num < 1000' ); end
   def self.sub2k()  where( 'num < 2000' ); end
   def self.sub10k()  where( 'num < 10000' ); end
   def self.sub20k()  where( 'num < 20000' ); end
   def self.sub100k()  where( 'num < 100000' ); end
   def self.sub1m()  where( 'num < 1000000' ); end
   def self.sub2m()  where( 'num < 2000000' ); end
   def self.sub10m()  where( 'num < 10000000' ); end
   def self.sub20m()  where( 'num < 20000000' ); end
   def self.sub21m()  where( 'num < 21000000' ); end
 

   def self.largest
      order( 'bytes DESC' )
   end

   def self.content_type_counts
       group( 'content_type' )
       .order( Arel.sql( 'COUNT(*) DESC, content_type')).count
   end

   class << self
      alias_method :biggest, :largest
      alias_method :counts_by_content_type, :content_type_counts
   end

 ###
 # instance methods
def extname
  ## map mime type to file extname
  ## see https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  ##  for real-world usage, see https://dune.com/dgtl_assets/bitcoin-ordinals-analysis
  ##  https://github.com/casey/ord/blob/master/src/media.rs

   if content_type.start_with?( 'text/plain' )
      '.txt'
   elsif content_type.start_with?( 'text/markdown' )
      '.md'
   elsif content_type.start_with?( 'text/html' )
      '.html'
   elsif content_type.start_with?( 'text/javascript' ) ||
         content_type.start_with?( 'application/javascript' )
      ## note: application/javascript is considered bad practice/legacy
      '.js'
   elsif content_type.start_with?( 'image/png' )
       ## Portable Network Graphics (PNG)
      '.png'
   elsif content_type.start_with?( 'image/jpeg' )
        ##  Joint Photographic Expert Group image (JPEG) 
       '.jpg'   ## use jpeg - why? why not?
   elsif content_type.start_with?( 'image/webp' )
        ## Web Picture format (WEBP)
       '.webp'   ## note: no three-letter extension available
   elsif content_type.start_with?( 'image/svg' )
        ## Scalable Vector Graphics (SVG) 
       '.svg'
   elsif content_type.start_with?( 'image/gif' ) 
       ##  Graphics Interchange Format (GIF)
       '.gif'
   elsif content_type.start_with?( 'image/avif' )  
       ## AV1 Image File Format (AVIF)
       '.avif'
   elsif content_type.start_with?( 'application/epub' )
       '.epub'
   elsif content_type.start_with?( 'application/pdf' )
       '.pdf'
   elsif content_type.start_with?( 'application/json' )
       '.json'
   elsif content_type.start_with?( 'application/pgp-signature' )
       '.sig'
   elsif content_type.start_with?( 'audio/mpeg' )
       '.mp3'
   elsif content_type.start_with?( 'audio/midi' )
       '.midi'
   elsif content_type.start_with?( 'video/mp4' )
       '.mp4'
   elsif content_type.start_with?( 'video/webm' )
       '.wepm'
   elsif content_type.start_with?( 'audio/mod' )  
      ## is typo? possible? only one inscription in 20m?
       '.mod'   ## check/todo/fix if is .wav?? 
   else
      puts "!! ERROR - no file extension configured for content type >#{content_type}<; sorry:"
      pp self
      exit 1
   end
end

=begin
def export_path  ## default export path
   numstr = "%08d" % num   ###  e.g. 00000001  
   "./tmp/#{numstr}#{extname}" 
end
def export( path=export_path )
   if blob
     write_blob( path, blob.content )
   else
      ## todo/fix: raise exception - no content
      puts "!! ERROR - inscribe has no content (blob); sorry:"
      pp self
      exit 1
   end
end
=end

  end  # class Scribe
  
    end # module Model
end # module ScribeDb
  