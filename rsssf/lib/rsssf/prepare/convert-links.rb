
module Rsssf
class  Prep    ## todo: find a better name e.g. BatchPrep or ??



##          see page 2006f
##   see page ../tablesw/worldcup›
##  e.g. ‹League C, see page 2023uefanl§lgc›
##       ‹League A, see page 2023uefanl.html#lga›
##   todo/fix - fix upstream ?? (e.g. remove. html and replace #=>§)
LINK_APAGE_RE = %r{  ‹(?<title> [^›]+?)
                       , [ ] see [ ] page [ ]
                      (?<pageref> [^›]+?)
                    ›
                }ix

=begin
["1973/74", "oost74"],
 ["1975/76", "oost76"],
 ["list of final tables", "oosthist"],
 ["list of champions", "oostchamp"],
 ["list of cup finals", "oostcuphist"],
 ["list of super cup finals", "oostsupcuphist"],
 ["list of foundation dates", "oostfound"]]
=end

def expand_pageref( pageref, dirname: )

                  ##
                  ##  note - pre-proces
                  ##   2023uefanl.html#lga
                  ##     stkitts2025.html#pres
                  ##
                  ##   remove .html
                  ##    and optional anchor
                  ##
                  ##   fix - upstream - why? why not?

                   pageref = pageref.sub(  %r{ \.html\b }ix, '' )
                   ## check - only really one # allowed in url path???
                   pageref = pageref.sub(  '#', '§' )


                 if /^[a-z0-9][a-z0-9§-]*$/.match?( pageref )
                    ## assume relative page in "local" dir
                    "#{dirname}/#{pageref}"
                 elsif pageref.start_with?( '../')
                    ## ../tablesw/worldcup
                     pageref.sub( "../", '' )
                 elsif pageref.start_with?( './' )
                     raise ArgumentError, "found (unsupported) ./ pageref >#{pageref}<"
                 elsif pageref.start_with?( '/' )
                     raise ArgumentError, "found (unsupported) / pageref >#{pageref}<"
                 elsif pageref.start_with?( %r{^https?:}i )
                     raise ArgumentError, "found (unsupported) https?: pageref >#{pageref}<"
                 else
                     raise ArgumentError, "found (unsupported) pageref >#{pageref}<"
                 end
end


def collect_links( txt, basename:, dirname: )

  links = txt.scan( LINK_APAGE_RE )

  links.map do |link|
                   link[1] = expand_pageref( link[1], dirname: dirname )
                   link
               end

  links
end


end    ## class Prep
end    ## module Rsssf