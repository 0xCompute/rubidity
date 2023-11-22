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

