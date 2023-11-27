
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
    def self.jpg() where( content_type: ['image/jpeg',
                                         'image/jpg'] ); end
    def self.webp() where( content_type: 'image/webp' ); end
    def self.svg()  where( content_type: 'image/svg+xml' ); end
    def self.avif() where( content_type: 'image/avif' ); end

    def self.pdf()  where( content_type: 'application/pdf' ); end

    def self.facet()  where( content_type: 'application/vnd.facet.tx+json' ); end


        
    class << self
       alias_method :jpeg, :jpg
    end     

    def self.image  
         ## change to/or add alias e.g. image/images - why? why not
        where( content_type: [
            'image/png',
            'image/jpeg',
            'image/jpg',
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


   def self.block_counts
       joins(:tx).group( 'block' )
         .order( 'block').count
   end 

   def self.block_with_timestamp_counts
       joins(:tx).group( Arel.sql( "block || ' @ ' || date" ))
         .order( 'block' ).count
   end


   def self.date_counts
      ## note: strftime is SQLite specific/only!!!
      joins(:tx).group( Arel.sql("strftime('%Y-%m-%d', date)"))
       .order( Arel.sql("strftime('%Y-%m-%d', date)")).count
   end

   def self.month_counts
      ## note: strftime is SQLite specific/only!!!
      joins(:tx).group( Arel.sql("strftime('%Y-%m', date)"))
       .order( Arel.sql("strftime('%Y-%m', date)")).count
   end

   def self.year_counts
      ## note: strftime is SQLite specific/only!!!
      joins(:tx).group( Arel.sql("strftime('%Y', date)"))
       .order( Arel.sql("strftime('%Y', date)")).count
   end
 
   def self.hour_counts
     ## note: strftime is SQLite specific/only!!!
      joins(:tx).group( Arel.sql("strftime('%Y-%m-%d %Hh', date)"))
      .order( Arel.sql("strftime('%Y-%m-%d %Hh', date)")).count
   end


   def self.from_counts
    ## note: from is sql keyword!!!
    ##  wrap in [] for sqlite - check if works for others!!!  
      joins(:tx).group( '[from]' )
       .order( Arel.sql( 'COUNT(*) DESC')).count
   end 


   class << self
      alias_method :biggest, :largest
      alias_method :counts_by_content_type, :content_type_counts
      alias_method :counts_by_date,         :date_counts
      alias_method :counts_by_day,          :date_counts
      alias_method :counts_by_month,        :month_counts
      alias_method :counts_by_year,         :year_counts
      alias_method :counts_by_hour,         :hour_counts
      alias_method :counts_by_block,        :block_counts
      alias_method :counts_by_block_with_timestamp,  :block_with_timestamp_counts
      alias_method :counts_by_address,      :from_counts
    end
  end  # class Scribe
  
    end # module Model
end # module ScribeDb
  