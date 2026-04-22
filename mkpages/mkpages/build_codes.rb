

## split basename
##
##  assume year/season for num - why? why not?
##    add/list exceptions here:

CODES_RE = %r{ \A
(
    ## (i) starts with year
    ##         e.g. 30f or 30full or 30q-det
      (?:
            (?:   (?<yyyy> [12]\d{3})
                | (?<yy>   \d{2})
            ) 
            (?<alpha> [a-z-]+)
       )
    ## (ii) starts with alpha (ends with year)
    ##         e.g. braz-joao00, braz01 
    ##     special case:       mex2-2010   incl. digit in alpha!!
    ##     special case:       p-rico2026a  or wwc2023f
    | (?:
            (?<alpha> [a-z-]+)
            
               (?: (?<version> [2]) -)?  ## optional e.g. match 2- in 2-2010 
              (?:   (?<yyyy> [12]\d{3})
                  | (?<yy>   \d{2})
              ) 
              (?<qualifier> [af])?    ## optional e.g. match f in 2023f or 
                                            ##                     a in 2026a etc.   
       )          
    ## (iii) alpha only
    | (?:
            (?<alpha> [a-z-]+)
       )
) \z  
}ix



def _build_code_titles( idx, sep: ' · ' )

    titles_counter = idx[:titles]
    ## note - sort by count
    sorted = titles_counter.sort do |l,r|
                              ## note [0] is key   (title)
                              ##      [1] is value (count)
                              r[1] <=> l[1]
                        end

    sorted.map do |title, count|
                      ## note - only incl. count if greater than one (1)!!
                      if count > 1
                          "#{title} (#{count})"
                      else
                          "#{title}"
                      end
                   end.join( sep )
end  



def build_codes( site, outdir: )


   master = {}  ## master index 


   puts "==> building codes (index) for #{site.size} pages..."


   site.each_page do |page|

    
### move 
##   to build_site   page!!!
##    for easy reuse!!!

      if m=CODES_RE.match(page.basename)
      
        alpha         = m[:alpha] 
        
        year       =  if m[:yy]            ## keep a string e.g. 01, 02, etc.
                           ## 00,01,..09 => 2000,2001,..2009
                           ## 10         => 1910,1911,
                         m[:yy].to_i(10) <= 9 ? "20#{m[:yy]}".to_i : "19#{m[:yy]}".to_i
                      elsif m[:yyyy]
                         m[:yyyy].to_i
                      else
                         nil   ## no year (e.g. intconcup page) 
                      end

        version   = m[:version]    ## e.g. mex2-2020 (=> v2)
        qualifier = m[:qualifier]  ## e.g. p-rico2026a  or wwc2023f 

        idx = master[alpha] ||= { years: {},
                                  titles: Hash.new(0),   ## use titles w/ counts
                                  dirs:   Hash.new(0),   ## use dirs w/ counts
                                }

         ## mex2-2020  =>   2020_2   
         ## p-rico2026a =>  2026a  
         ##    wwc2023f =>  2023f
        full_year = String.new
        full_year +=   year ? year.to_s : '_'  ## note: use underscore (_) if no number/year availabe                        
        full_year += qualifier        if qualifier
        full_year += "_#{version}"    if version    ## add at last

        idx[:dirs][page.dirname] +=1


        idx[:years][full_year] = page
      

        ### for (re)use move to Page class - why? why not?
        ## XXXX/11
        ##
        ## note special case title with two seasons (years)
        ##  Puerto Rico XXXX/XX (Clausura XXXX)
        title_masked = page.title.sub( %r{\b
                                       [12]\d{3} 
                                         [/-] 
                                    (?:   \d{2}
                                        | [12]\d{3} 
                                    )
                                      \b}x, 'XXXX/XX')

       title_masked = title_masked.sub( %r{\b
                                        [12]\d{3} 
                                        \b}x, 'XXXX')

        idx[:titles][title_masked] +=1
      else
        puts "!! ERROR - invalid rsssf page basename #{page.basename} (#{page.pretty_inspect}); cannot match; sorry"
        exit 1
      end

      print "."

   end
   print "\n"

  

 
   buf = String.new

   ## sort keys!!
   codes = master.keys.sort
   
   ## print summary - list all codes
   buf << codes.map do |code| 
                       "<code>" +
                       "<a href=\"##{code}\" title=\"#{_build_code_titles(master[code])}\">" +
                       "#{code}" +
                       "</a></code>" 
                    end.join( ' ' )
   buf << "\n\n"


   buf << "<table>\n"
   buf << %Q{<table style="width:100%">\n}
   buf << %Q{<tr><th style="width:150px"></th><th>Title(s)</th><th>Season(s)</th></tr>\n}
   

   codes.each do |code|
      idx = master[code]
 
      ## assert all in same dir - why? why not?
      if idx[:dirs].size != 1 
          raise ArgumentError, "expected all tables in same dir; got #{idx.pretty_inspect}"
      end

      years = idx[:years]




      buf << "<tr>"
      buf << "<td><b><code><a name=\"#{code}\">#{code}</a></code></b> (#{years.size})</td>\n"
      ## add titles
      buf << "<td>"
      buf  << _build_code_titles( idx )
      buf << "</td>\n"
      buf << "<td>"
      buf <<   years.keys.sort.reverse.map do |year|
                           "<a href=\"#{years[year].basename}.html\" title=\"#{years[year].title}\">#{year}</a>"
                         end.join( ', ' )
      buf << "</td>\n"
      buf << "</tr>\n\n"
   end
   buf << "</table>\n"
 

   banner = build_site_banner()
   title = "Codes Index A-Z"
   body =  "<h1>#{title}</h1>\n\n" + buf
 
   html = build_layout( title: title, body: body,
                          banner: banner )

   write_text( "#{outdir}/codes.html", html )
   
   html
end