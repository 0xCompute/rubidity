# Data URI Notes


## todos:


- [ ]  - fix/fix/fix - change parse return args  - data first, type second - why? why not?

- [ ]  return default media type (text/plain) if non specified - why? why not?
       - and add charset=ASCII - why? why not? (and change string encoding?)
- [ ]  check for charset parameter and (auto-)change string encoding - why? why not?
- [ ]  return parameters in media type - why? why not?
- [ ]  add support for URI and openuri - see <https://github.com/dball/data_uri> - why? why 
not?
- [ ] FIX FIX FIX  check if parameters MUST use URI.encode_uri_component!!!

>  "attribute" and "value" are the corresponding tokens from RFC2045,
>   represented using URL escaped encoding of RFC2396 as necessary.

about quoted values:

> Attribute values in RFC2045 are allowed to be either represented 
> as tokens or as quoted strings. 
> However, within a "data" URL,
>  the "quoted-string" representation would be awkward, 
> since the quote mark is itself not a valid urlchar. 
> For this reason, parameter values
> should use the URL Escaped encoding instead of quoted string if the
>  parameter values contain any "tspecial".


RFC2396: Berners-Lee, T., Fielding, R., and L. Masinter,
               "Uniform Resource Identifiers (URI): Generic Syntax", RFC
               2396, August 1998.

RFC2045:   Freed N., and N. Borenstein., "Multipurpose Internet Mail
               Extensions (MIME) Part One: Format of Internet Message
               Bodies", RFC 2045, November 1996.



check for url safe characters - what is the official set???

url encoding == percent-encoded characters
see <https://en.wikipedia.org/wiki/Percent-encoding>

Reserved characters that have no reserved purpose in a particular context may also be percent-encoded but are not semantically different from those that are not.



## check

from the spec:

Without ";base64", the data (as a sequence of octets) is represented using ASCII encoding for octets inside the
   range of safe URL characters and using the standard %xx hex encoding
   of URLs for octets outside that range.  If `<mediatype>` 
   is omitted, it
   defaults to text/plain;charset=US-ASCII.  As a shorthand,
   "text/plain" can be omitted but the charset parameter supplied.

<https://datatracker.ietf.org/doc/html/rfc2397>

for URI.encode_uri_compenent  check what are safe URL characters
why encode space or comma and such into %xx - keep for readability the verbatim charachter 
if possible - why? why not?




## More data uri / urls gems

- search rubygems for data uri - resulting in hundreds!
- use dataurl instead of datauri - why? why not?


### Inside

most downloaded data_uri gem (anno 2014) - 4+ millions - <https://rubygems.org/gems/data_uri>

source - <https://github.com/dball/data_uri>


strict-data-uri gem

source - <https://github.com/ekampp/strict-data-uri>


> This was inspired by data-uri. The main difference being 
> (a) more precise error handling and 
> (b) using Ruby's Base64.strict_encode64
> instead of Base64.encode64 which prevents the addition of newline (\n) characters 
> every 60 characters in the encoded string.
> 


data-uri gem (anno 2012) - <https://rubygems.org/gems/data-uri>

```ruby
def self.decode(uri)
  if uri.match(%r{^data:(.*?);(.*?),(.*)$})
    type = $1
    encoder = $2
    data = $3
    if encoder == "base64"
      return Base64.decode64(data)
    end
  end

  raise "Illegal format error: #{uri.inspect}"
end

def self.encode(data, type="text/plain")
  "data:" + type + ";base64," + Base64.encode64(data).rstrip
end
```




## More data uri modules / libraries

Python

- <https://pypi.org/project/python-datauri/>


Node.js

- <https://www.npmjs.com/package/datauri>





