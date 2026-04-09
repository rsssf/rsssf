module Rsssf
class PageConverter


##
## todo/fix/fix/fix
##    add filenames/urls for quick fixes!!!


def errata_html( html )
   ## auto-fix known typos / errors
   ###   kind of PRE-processing, see errata_txt for POST-processing
   ###  check - rename to errata_pre/post - why? why not?


  ## quick fix - change typo <H1></H2>
  ##  tables/58full.html
  html = html.gsub( '<H1>Quarterfinals</H2>', '<H2>Quarterfinals</H2>' ) 

  ## quick fix - change typo <M>,<N> to <B>
  ##   tables/54full.html
  html = html.gsub( '<M>MEX</B>', '<B>MEX</B>' ) 
  ##   tables/58full.html 
  html = html.gsub( '<N>CZE</B>', '<B>CZE</B>' ) 

  html
end


def errata_html_entities( html )
    ########
    ## typos / autofix - keep - why? why not?
    html = html.gsub( "&oulm;", 'ö' )    ## support typo in entity (&ouml;)
    html = html.gsub( "&uml;",  'ü' )    ## support typo in entity (&uuml;) - why? why not?
    html = html.gsub( "&slig;", "ß" )    ## support typo in entity (&szlig;)
    html = html.gsub( "&aaacute;", "á" )  ## typo for &aacute; 
    html = html.gsub( "&nitlde;", "ñ" )  ## typ for &ntilde;   
    html
end



def errata_txt( txt )
  ## kind-of POST-processing, see errata_html for PRE-processing

   ## quick fix - squish spaces (to single)
   ##   tables/82full.html
   txt = txt.gsub( 'Second  phase', 'Second phase' )


   ## quick fix - add (missing) closing bracket (])
   ##   tables/70q.html
   txt = txt.gsub(/^South America Group 10 \[Brazil$/,
                   'South America Group 10 [Brazil]' )


  txt
end


end # module PageConverter
end # module Rsssf

