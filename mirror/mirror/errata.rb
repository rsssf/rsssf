

##
##  use errata_html - why? why not?
##
##
##  todo/fix - move errata to .txt only
##          use  read/parse_edits !!!
##
##   use g/  for global sub
##   and s/  or nothing for single sub - why? why not
##   or    add option at the end    a => b
##     for option use   !g or !!g or /g or ?g or ??


def errata( html, url: )

     base_url = URI( url )

       if base_url.path = '/tablesp/poland-satrip77.html'
           html = html.sub( %q{<a href="..//nersssf.html">},
                            %q{<a href="../nersssf.html">}  )
       end

       if base_url.path = '/miscellaneous/torre-madrid.html'
           html = html.sub( %q{<a href="..m/tablesm/madridtops.html">},
                            %q{<a href="../tablesm/madridtops.html">}  )
       end

       if base_url.path = '/tablesa/arg2017.html'
           html = html.sub( %q{<a href="../tablesc/%20chevserena2017.html">},
                            %q{<a href="../tablesc/chevserena2017.html">}  )
       end





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

=begin
<a href="4#n">Norrland</a> |
<a href="4#ns">Norra Svealand</a> |
<a href="4#os">&Ouml;stra Svealand</a> |
<a href="4#mg">Mellersta G&ouml;taland</a> |
<a href="4#vg">V&auml;stra G&ouml;taland</a> <br>|
<a href="4#sg">S&ouml;dra G&ouml;taland</a> |
<a href="4#rp">Relegation playoff</a>
=end
   if base_url.path = "/tablesz/zwed06.html"
         html = html.sub( %q{<a href="4#n">},
                          %q{<a href="#4n">} )
       ## add six subs more here, see above !!!
   end

=begin
<a href="2apercuad">Qualified</a>    10x!!
<a href="2claucuad">Qualified</a>
=end
   if base_url.path = "/tablesc/col2012.html"
         html = html.gsub( %q{<a href="2apercuad">},
                           %q{<a href="#2apercuad">} )
         html = html.gsub( %q{<a href="2claucuad">},
                           %q{<a href="#2claucuad">} )
   end


   if base_url.path = "/tablesk/kaz-wom2024.html"
         html = html.sub( %q{<A HREF="kaz-wom20223html">},
                          %q{<A HREF="kaz-wom2023.html">} )
   end

###
##  autofix - missing mailto:  - why? why not??
##   e.g.
=begin
Authors: Alan Morley
(<a href="manager@socceraust.co.uk">manager@socceraust.co.uk</a>),
=end
  if base_url.path = "/tablesr/rwan06.html"
         html = html.sub( %q{<a href="manager@socceraust.co.uk">},
                          %q{<a href="mailto:manager@socceraust.co.uk">} )
   end


       html
end