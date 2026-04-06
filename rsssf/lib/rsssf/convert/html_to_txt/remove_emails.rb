module Rsssf
class PageConverter


EMAIL_RE = %r{ \s*
\(
 [a-z][a-z0-9_]+
   @[a-z]+(\.[a-z]+)+
 \)
}imx   


def remove_emails( html )
  ### remove converted ("blinded") mailto anchors
  ##  note   usually inside () e.g.
  ##    (‹mailto›) 
  ##   plus slurp up all leading whitespace (incl. newline) - why? why not?
  html = html.gsub( /\s*
                      \(‹mailto›\)
                     /xm, '' )
  
   ###
   ##  remove "regular emails too e.g.
   ##
   ## Thanks to Marcelo Leme de Arruda (___@___.__.br),
   ##  Ricardo FF Pontes (___@____.com), 
   ## Santiago Reis (____@____.com.br),
   ## Marcos Lacerda Queiroz (___@____.com.br)
   ##  etc.

  ## check for "free-standing e.g. on its own line" emails only for now
   html = html.gsub( EMAIL_RE ) do |match|
    puts "removing  email >#{match}<"
    ''   
   end
   html
end



end # module PageConverter
end # module Rsssf

