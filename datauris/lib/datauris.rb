
require 'base64'   ## pull in Base64.strict_encode64/decode64 (standard) module
require 'uri'      ## pull in URI.decode_uri_component


## our own code
require_relative 'datauris/version'     # let version go first


module DataUri
    REGEX_V0 = %r{
      \Adata:
      (?<mediatype>
        (?<type> .+? / .+? )?
        (?<parameters> (?: ; .+? = .+? )* )
      )?
      (?<base64extension>;base64)?
      ,
      (?<data>.*)\z
    }x

    ## allow type only - why? why not?
    ## split subtype into [tree prefix] and subtype
    ##  check if type can include dash (-) - why? why not?
    ## 
    ## note: \w =>  A word character 
    ##               is a character a-z, A-Z, 0-9, including _ (underscore).
    ##
    ## official grammar:
    ##   mime-type = type "/" [tree "."] subtype ["+" suffix]* [";" parameter];
    ##
    ## Types
    ##  The "type" part defines the broad use of the media type. 
    ##   As of November 1996, the registered types were:
    ##   application, audio, image, message, multipart, text and video.
    #    By December 2020, the registered types included the foregoing, 
    ##   plus font, example, and model.
    ##
    ##  An unofficial top-level type in common use is chemical

    ## examples with numbers:
    #    application/vnd.software602.filler.form+xml
    #    application/x-shockwave-flash2-preview
    #    application/vnd.isac.fcs; version="1.0-3.1"

   ## make parameters key/value more strict  - why? why not?
   ##  e.g. MIME_PARAM_RE = /^;([-\w.+]+)=([^;,]+)/.freeze
   ##
   ##  allow  +(plus) or .(dot) in param key - possible?? why? why not?

    REGEX = %r{
      \A
      data:
      (?<mediatype>
        (?:
            (?<type> [\w-]+? )  
             / 
            (?<subtype> [\w.+-]+? )
        )?
        (?<parameters> (?: ; 
                           [\w.+-]+? 
                              = 
                              .+? 
                        )* 
        )
      )?
      (?<base64extension>;base64)?
      ,
      (?<data>.*)
      \z
    }x


    def self._parse( str ) REGEX.match( str ); end

    def self.parse( str )
        m = _parse( str ) 
  
        if m
          ## 1) return mediatype (mimetype PLUS optional parameters)
          ## 2) return data (base64 decoded or not)
  
          mediatype = m[:mediatype]  
          data      = if m[:base64extension]   ## assume base64 encoded
                         Base64.strict_decode64(m[:data])
                      else
                         ## e.g. %20 => space(20)
                         ##  etc.
                         ## todo/double check - use a different URI decoder - why? why not?
                         URI.decode_uri_component(m[:data])
                      end
          [mediatype, data]
        else
           raise ArgumentError, "invalid datauri - cannot match regex; sorry"
        end
    end


    def self.valid?( str )
      m = _parse( str )
      if m 
        if m[:base64extension]   ## assume base64
          begin
            Base64.strict_decode64(m[:data])
            true
          rescue ArgumentError
            false
          end
        else
          true
        end
      else
        false
      end
    end


   ###
   ## fix-fix-fix - use our own encode_uri instead of encode_uri_component
   ##                 why? keep more chars unescaped
   ##                   e.g.   ??
   ## 
   ##   check about space ( ) - must be encoded - why? why not??
   ##               comma (,)
   ##               more from json -  [] or {} or ""
   ##
   ## see <https://en.wikipedia.org/wiki/Percent-encoding>


   ## RFC 3986 section 2.3 Unreserved Characters (January 2005)
   ##   A-Z => A	B	C	D	E	F	G	H	I	J	K	L	M	N	O	P	Q	R	S	T	U	V	W	X	Y	Z
   ##   a-z => a	b	c	d	e	f	g	h	i	j	k	l	m	n	o	p	q	r	s	t	u	v	w	x	y	z
   ##   0-9 => 0	1	2	3	4	5	6	7	8	9
   ##   	-	_	.	~	
   ##  Other characters in a URI must be percent-encoded.   

   ## RFC 3986 section 2.2 Reserved Characters (January 2005)
   ##  !	#	$	&	'	(	)	*	+	,	/	:	;	=	?	@	[	]
   ##
   ##  what's missing in reserved?  
   ##              space(20)  and 
   ##              double quoutes (") and
   ##              curly bracket ({}), and ??
   ##
   ##  note:  Reserved characters that have no reserved purpose in a particular context
   ##  may also be percent-encoded but
   ##   are not semantically different from those that are not.


   ## add more reserved chars here - to keep verbatim (as literal) and NOT percent-encoded
   ##   why? why not?


    NOT_SAFECHARS_RX = /([^a-zA-Z0-9\-_.~]+)/

    def self.encode_uri( str )
      encoding = str.encoding
      str.b.gsub( NOT_SAFECHARS_RX ) do |m|
        '%' + m.unpack('H2' * m.bytesize).join('%').upcase
      end.force_encoding(encoding)
    end


    ## base64 - force base64 encoding (instead of "automagic")
    def self.build( data, type=nil, base64: nil )
        uri = "data:"
        uri += type      if type   ## note: allow optional / no type
        
        ## puts "  type: #{type.inspect}, base64: #{base64.inspect}"

        ## add more (binary) media types here - why? why not?
        ##   note svg is text AND an image => image/svg+xml
        if base64.nil?                   
            base64 = if type 
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
        end

        if base64    
            uri += ";base64," + Base64.strict_encode64( data )
        else
            ## use encode_uri_component by default - why? why not?
            ##  space becomes %20
            ##  :     becomes %3A
            ##  ,     becomes %2C  and so on
            uri += "," + encode_uri( data )
        end   
    end
      


    ## add alias convenience names - why? why not?
    class << self 
      alias_method :is_valid?,   :valid?
      alias_method :decode,      :parse
      alias_method :encode,      :build
    end
end  # module  DataUri



puts  DataUri.banner      # say hello