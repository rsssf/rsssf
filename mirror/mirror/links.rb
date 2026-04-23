


## get all links
##   ignore anchor links and
##     split into internal and external
def _find_links( html,
                 url:,
                 verbose: true )


       base_url = URI( url )


### move to errata  (_html) or such
       if base_url.path == '/results-afr.html'
            ## add missing closing quote
           html = html.sub( %q{<A HREF="tablesm/mauri2023.html#aga>},
                            %q{<A HREF="tablesm/mauri2023.html#aga">}  )

           html = html.sub( %q{<A HREF=" tablesr rodri2025.html#super">},
                            %q{<A HREF="tablesr/rodri2025.html#super">} )
       end

       if base_url.path == '/profiles.html'
           html = html.sub( %q{<A HREF=http://www.daleucampeon.4t.com">},
                            %q{<A HREF="http://www.daleucampeon.4t.com">} )
       end


## Standard HTML4-style parsing (default)
## doc = Nokogiri::HTML(malformed_html)

## More robust HTML5 parsing
##doc = Nokogiri::HTML5(malformed_html)


      doc = Nokogiri::HTML( html )

    ##
    ## note: Array#compact removes all nil values from an array.
    ##    if no href in a - nokigiri return nil
    ##
    ##     might still incl. empty string ("") - remove too - why? why not?
    links = doc.css('a').map { |a| a['href'] }.compact

    ## split into internal & external
    ## make links absolute

    anchors = []
    pages = []
    externals = []
    links.each do |href|

                    ## strip leading & trailing spaces e.g.
                    ##   "http://www.danskfodbold.dk "
                    ##    is invalid uri!!!

                    href = href.strip

## note - skip mailto links
                next   if /\Amailto/i.match?( href )


                      page_url = nil
                      begin
                         page_url = URI.join(base_url, href)

                      rescue => ex
                         ## skip bad urls and log

                         msg = "bad url in #{base_url.path}:\n#{href}\nex:#{ex}\n"

                         ## note - only report in verbose mode (fresh download or such)!!!
                         if verbose
                           log( msg )
                           puts "!! " + msg
                         end

                         next
                      end


                      if page_url.host == 'rsssf.org'
                          if page_url.path == base_url.path
                                 puts "   anchor  #{href}  =>  #{page_url.fragment}"     if verbose
                              anchors << page_url.fragment
                          else
                               puts "   internal page  #{href}  =>  #{page_url.path}"     if verbose
                              pages << page_url.path
                          end
                      else
                         puts "!! external  #{href}  =>  #{page_url}"      if verbose
                         externals << page_url.to_s
                      end
                    end

     ## make uniq
     pages     = pages.uniq
     anchors   = anchors.uniq
     externals = externals.uniq

      if verbose
      puts "   #{pages.size} internal (& #{anchors.size} anchor) & #{externals.size} external link(s) found in #{base_url.path}:"


    pp pages
    pp anchors
    pp externals
      end

    [pages, externals]
end



__END__

 broken html in
  https://rsssf.org/results-afr.html
  bad URI(is not URI?):
  "tablesm/mauri2023.html#aga>\n
  Agalega Islands (2022)</a>\n       <LI><A HREF=" (URI::InvalidURIError)

  missing closing quote
  <LI><A HREF="tablesm/mauri2023.html#aga>
       Agalega Islands (2022)</a>
       =>
<LI><A HREF="tablesm/mauri2023.html#aga">




bad URI(is not URI?): " tablesr rodri2025.html#super"
(URI::InvalidURIError)