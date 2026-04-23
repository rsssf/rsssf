####
#  to run use:
#
#    $ ruby mirror/test_enc.rb

$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webclient/lib' )
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )


require 'cocos'
require 'webget'           ## incl. webget, webcache, webclient, etc.


## url = "https://rsssf.org/tablest/turkm2026.html"
url = "https://rsssf.org/tablesc/caribe2016.html"


response = Webclient.get( url )
html = response.text( encoding: 'windows-1252')

pp html[0,100]
puts "---"
puts html
pp html.encoding

puts "bye"

__END__

before:
GET https://rsssf.org/tablest/turkm2026.html...
"\xFF\xFE<\u0000!\u0000D\u0000O\u0000C\u0000T\u0000Y\u0000P\u0000E\u0000 \u0000H\u0000T\u0000M\u0000L\u0000 \u0000P\u0000U\u0000B\u0000L\u0000I\u0000C\u0000 \u0000\"\u0000-\u0000/\u0000/\u0000W\u00003\u0000C\u0000/\u0000/\u0000D\u0000T\u0000D\u0000 \u0000H\u0000T\u0000M\u0000L\u0000 \u00003\u0000.\u00002\u0000 \u0000F\u0000i\u0000n\u0000a\u0000l\u0000"

after:
