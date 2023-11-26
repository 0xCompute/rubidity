# (Build Your Own) Ethscriptions Indexer Notes


##  ethscriptions.com (Indexer) Quirks


### mistyped mimetypes

- plain/text   instead of text/plain
- image/jpg    instead of image/jpeg


more quirks
- plain/text;   - parameter separator but no parameters


svg
- unifiy   image/svg  and image/svg+xml  - why? why not?

upcase  - auto downcase content type - why? why not?
TEXT/PLAIN   - is valid 
IMAGE/PNG    - is valid 



### invalid mimetypes accepted

"EthscriptionsApe0000;image/png"=>1,
"EthscriptionsApe3332;image/png"=>1,
 


### datauris - uri encoding/decoding

- text with unencoded newline (`\n`)  - should idealy use %0A ??
example:
- inscribe no.   trailing newline



### protocols

- how to identify protocol text messages (using json)

- allow no mimetype  if starting with `{`
- allow plain/text mimetype (and variants) if starting with `{`
- allow application/json
- others?  - why? why not?

- [ ]  add a new protocol score to model (do NOT use text for queries!!!)





### Appendix

mimetype usage in sub100k (via escriptions.com)

```
{"text/plain"=>77513,
 nil=>13343,
 "image/png"=>6145,
 "image/jpeg"=>2712,
 "image/gif"=>156,
 "application/pdf"=>36,
 "image/webp"=>22,
 "image/svg+xml"=>19,
 "plain/text;"=>13,
 "application/json"=>9,
 "image/svg"=>7,
 "text/html"=>7,
 "image/svg+xml;utf8"=>4,
 "audio/ogg"=>2,
 "image/bmp"=>2,
 "EthscriptionsApe0000;image/png"=>1,
 "EthscriptionsApe3332;image/png"=>1,
 "IMAGE/PNG"=>1,
 "audio/flac"=>1,
 "audio/mpeg"=>1,
 "audio/wav"=>1,
 "dadabots/was+here"=>1,
 "image/jpg"=>1,
 "text/html;"=>1,
 "text/plain;utf8"=>1}
```