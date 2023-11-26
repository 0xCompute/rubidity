$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub100k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   100000 scribe(s)
#=>   100000 tx(s)

Scribe.biggest.limit(20).each do |scribe|
    print "#{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) - "
    print "Scribe №#{scribe.num} (#{scribe.content_type}) - "
    print "#{scribe.tx.date}"    # - #{scribe.tx.}.fee} fee in ??"
    print "\n"
end
  
=begin
127 KB (129744 bytes) - Scribe №17454 (application/pdf) - 2023-06-17 20:35:47 UTC
124 KB (126760 bytes) - Scribe №17445 (application/pdf) - 2023-06-17 20:33:35 UTC
122 KB (124807 bytes) - Scribe №17446 (image/jpeg) - 2023-06-17 20:34:35 UTC
122 KB (124671 bytes) - Scribe №17449 (image/jpeg) - 2023-06-17 20:35:11 UTC
122 KB (124579 bytes) - Scribe №17450 (image/jpeg) - 2023-06-17 20:35:23 UTC
122 KB (124451 bytes) - Scribe №17452 (image/jpeg) - 2023-06-17 20:35:35 UTC
122 KB (124431 bytes) - Scribe №17453 (image/jpeg) - 2023-06-17 20:35:47 UTC
121 KB (124371 bytes) - Scribe №17456 (image/jpeg) - 2023-06-17 20:35:59 UTC
121 KB (124255 bytes) - Scribe №17458 (image/jpeg) - 2023-06-17 20:36:11 UTC
121 KB (124247 bytes) - Scribe №17459 (image/jpeg) - 2023-06-17 20:36:23 UTC
121 KB (124187 bytes) - Scribe №17460 (image/jpeg) - 2023-06-17 20:36:35 UTC
121 KB (124171 bytes) - Scribe №17447 (image/jpeg) - 2023-06-17 20:34:47 UTC
121 KB (124167 bytes) - Scribe №17448 (image/jpeg) - 2023-06-17 20:34:59 UTC
121 KB (124143 bytes) - Scribe №17569 (image/jpeg) - 2023-06-17 20:47:59 UTC
121 KB (124139 bytes) - Scribe №17540 (image/jpeg) - 2023-06-17 20:44:59 UTC
121 KB (124095 bytes) - Scribe №17555 (image/jpeg) - 2023-06-17 20:46:23 UTC
121 KB (124015 bytes) - Scribe №17564 (image/jpeg) - 2023-06-17 20:47:35 UTC
121 KB (123995 bytes) - Scribe №17567 (image/jpeg) - 2023-06-17 20:47:47 UTC
121 KB (123991 bytes) - Scribe №17486 (image/jpeg) - 2023-06-17 20:39:11 UTC
121 KB (123979 bytes) - Scribe №17584 (image/jpeg) - 2023-06-17 20:49:35 UTC
=end


pp Scribe.counts_by_date   ## or count_by_day

=begin
{"2016-05-29"=>1,
 "2017-03-17"=>1,
 "2017-07-06"=>1,
 "2018-06-29"=>1,
 "2019-07-23"=>1,
 "2019-12-04"=>1,
 "2020-01-08"=>1,
 "2020-02-06"=>1,
 "2020-07-28"=>1,
 "2020-08-22"=>1,
 "2022-08-30"=>1,
 "2023-06-14"=>10,
 "2023-06-15"=>319,
 "2023-06-16"=>9884,
 "2023-06-17"=>7837,
 "2023-06-18"=>44627,
 "2023-06-19"=>23587,
 "2023-06-20"=>13725}
=end

pp Scribe.counts_by_month

=begin
{"2016-05"=>1,
 "2017-03"=>1,
 "2017-07"=>1,
 "2018-06"=>1,
 "2019-07"=>1,
 "2019-12"=>1,
 "2020-01"=>1,
 "2020-02"=>1,
 "2020-07"=>1,
 "2020-08"=>1,
 "2022-08"=>1,
 "2023-06"=>99989}
=end

pp Scribe.counts_by_content_type

=begin
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
=end

puts "bye"