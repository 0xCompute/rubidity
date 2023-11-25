# Notes


see <https://docs.ethscriptions.com/overview/how-ethscriptions-work#the-details>


### How to interpret hex input data as UTF-8

Any method functionally equivalent to this code will work. Note that null bytes are removed even though they are valid UTF-8. This is a pragmatic choice based around the special behavior of these characters in postgres string columns.

``` js
function hexToUTF8(hexString) {
  if (hexString.indexOf('0x') === 0) {
    hexString = hexString.slice(2);
  }

  const bytes = new Uint8Array(hexString.length / 2);

  for (let index = 0; index < bytes.length; index++) {
    const start = index * 2;
    const hexByte = hexString.slice(start, start + 2);
    const byte = Number.parseInt(hexByte, 16);
    if (Number.isNaN(byte) || byte < 0)
      throw new Error(
        `Invalid byte sequence ("${hexByte}" in "${hexString}").`
      );
    bytes[index] = byte;
  }

  let result = new TextDecoder().decode(bytes);
  return result.replace(/\0/g, '');
}
```


## How to validate a dataURI

Any method functionally equivalent to this Ruby class will work. Note that any syntactically valid mimetype is allowed.

```ruby

class DataUri
  REGEXP = %r{
    data:
    (?<mediatype>
      (?<mimetype> .+? / .+? )?
      (?<parameters> (?: ; .+? = .+? )* )
    )?
    (?<extension>;base64)?
    ,
    (?<data>.*)
  }x.freeze

  def self.valid?(uri)
    match = REGEXP.match(uri)

    match && valid_base64_content?(match[:data], match[:extension])
  end

  private 

  def self.valid_base64_content?(data, extension)
    if extension
      begin
        Base64.strict_decode64(data)
        true
      rescue ArgumentError
        false
      end
    else
      true
    end
  end
end
```


##  alternate hex_to_utf8 and utf8_to_hex

### hex_to_utf8

```
    # str.scan(/../).map { |x| x.hex }.pack('c*')
    ## fix: will NOT work for multi-byte chars
    ## str.scan(/../).map { |x| x.hex.chr }.join
```

official version in facet (nov 25, 2023)

``` ruby
def hex_to_utf8(hex_string)
  clean_hex_string = hex_string.gsub(/\A0x/, '')

  ary = clean_hex_string.scan(/../).map { |pair| pair.to_i(16) }
  
  utf8_string = ary.pack('C*').force_encoding('utf-8')
  
  unless utf8_string.valid_encoding?
    utf8_string = utf8_string.encode('UTF-8', invalid: :replace, undef: :replace, replace: "\uFFFD")
  end
  
  utf8_string.delete("\u0000")
end
```

what's different?

-  error handling on non-hex chars
   e.g.  'xx'.to_i(16) => 0   while ['xx'].unpack( 'H*' ) results in "undefined overflow" byte e.g "\x11" (not 0) - not sure what the rule is here


### utf8_to_hex

```
   # str.unpack('U'*str.length).map {|b| b.to_s(16) }.join
    # str.unpack('H*').first
    ## note: 0 or 3 must be 00 or 03 with padding!!
    ##  or use rjust( 2, '0' ) - why? why not?
    # str.each_byte.map { |b| '%02x' % b }.join

```
