
##
### check for all referenced pages (links)
##    and if present or not

=begin
## (iii)  replace page links
##          see page 2006f
##   see page ../tablesw/worldcup›
##  note - use positive lookahead for › (do NOT incl.)
SEE_APAGE_RE = %r{\bsee [ ] page [ ] (?<page> [^›]+?) (?=›)}ix

##  fix - change capture page to pageref!!!
=end

def build_links( site, outdir: )

   ## simple counter index for now
    master =  Hash.new(0)


   puts "==> building links (index) for #{site.size} pages..."


   site.each_page_with_index do |page,i|

       txt = page._read_text()  ## get a fresh copy - why? why not?
       pagerefs = txt.scan( SEE_APAGE_RE )
       pagerefs = pagerefs.flatten      ## e.g. [['a'],['b']] => ['a','b']

       ## puts
       ## pp pagerefs

## make "absolute"

        pagerefs = pagerefs.map do |pageref|
                  ##
                  ##  note - pre-proces
                  ##   2023uefanl.html#lga
                  ##     stkitts2025.html#pres
                  ##
                  ##   remove .html
                  ##    and optional anchor

                   pageref = pageref.sub( %r{\.html
                                                (?: \#[a-z0-9][a-z0-9-]* )?
                                             $
                                            }ix, '' )


                 if /^[a-z0-9][a-z0-9-]*$/.match?( pageref )
                    ## assume relative page in "local" dir
                    "#{page.dirname}/#{pageref}"
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
        ## puts "  =>"

        ## make pagerefs unique !!
        pagerefs = pagerefs.uniq
        ## pp pagerefs

        pagerefs.each do |pageref|
            master[pageref] += 1
        end
   end

   ## pp master


   ## split into available and not available pages!!
   pages_found    = []
   pages_missing  = []

   master.each do |path, count|
       page = site.mirror[ path ]
       if page
          pages_found << [path,count,page]
       else
          pages_missing << [path,count]
       end
   end

   puts "  found (#{pages_found.size}):"

   buf = String.new
   buf << "<p>#{pages_found.size} referenced pages found: \n"

   pages_found = pages_found.sort do |l,r|
                           l[0] <=> r[0]    ## by basename
                      end



    buf <<  pages_found.map do |found|
                                basename = File.basename( found[0] )
                                count = found[1]
                                page     = found[2]
                                "<code><a href=\"#{basename}.html\" title=\"#{page.title}\">#{basename}</a></code> (#{count})"
                           end.join( "\n" )
     buf << "</p>\n\n"



   pages_missing = pages_missing.sort do |l,r|
                           l[0] <=> r[0]    ## by basename
                      end

   puts
   puts "  missing (#{pages_missing.size}):"
   pp pages_missing


     buf << "<p>#{pages_missing.size} referenced pages missing: \n"

    buf <<  pages_missing.map do |missing|
                                path =  missing[0]
                                count = missing[1]
                                "<code><a href=\"https://rsssf.org/#{path}.html\">#{path}</a></code> (#{count})"
                           end.join( "\n" )

     buf << "</p>\n\n"



   banner = build_site_banner()
   title = "Links"
   body =  "<h1>#{title}</h1>\n\n" + buf

   html = build_layout( title: title, body: body,
                          banner: banner )

   write_text( "#{outdir}/links.html", html )

   html
end
