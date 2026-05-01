

##
##  todo/check - use errata_html - why? why not?
##

ERRATA_EDITS = read_edits( './mirror/errata.txt' )

def errata( html, url: )
     ## lookup edits by path e.g. /tablesp/poland-satrip77.html
     ##                       or  /miscellaneous/torre-madrid.html

     base_url = URI( url )

     edits = ERRATA_EDITS[base_url.path]

     ## note - for now always use gsub (not sub)
     ##   maybe add option later
     if edits
        edits.each do |search,replace|
                        html = html.gsub( search, replace )
                   end
     end

     html
end