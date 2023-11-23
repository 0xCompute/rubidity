# Data URI Notes


## todos:

- [ ]  return default media type (text/plain) if non specified - why? why not?
       - and add charset=ASCII - why? why not? (and change string encoding?)
- [ ]  check for charset parameter and (auto-)change string encoding - why? why not?
- [ ]  return parameters in media type - why? why not?
- [ ]  add support for URI and openuri - see <https://github.com/dball/data_uri> - why? why not?


## More data uri gems

- search rubygems for data uri - resulting in hundreds!



### Inside

most downloaded data_uri gem (anno 2014) - 4+ millions - <https://rubygems.org/gems/data_uri>

source - <https://github.com/dball/data_uri>





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


