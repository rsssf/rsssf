module Rsssf
class PageConverter


##
## todo/fix/fix/fix
##    add filenames/urls for quick fixes!!!


def self.errata_html( html )
   ## auto-fix known typos / errors
   ###   kind of PRE-processing, see errata_txt for POST-processing
   ###  check - rename to errata_pre/post - why? why not?


     ## quick fix - rm </ADDRESS>
    ##  </ADDRESS>
    ##   tablesb/braz94.html
    html = html.gsub( '</ADDRESS>', ''  )

   ## quick fix   </a  => </a>   
   ##  <a href="#play6">Gold League (Calle 6)</a
   ##  <a href="#zpl">PBZ Premier League 2025/26</a
   ##  <a href="#lig1">Championnat National Ligue 1</a

   html = html.gsub( /<\/A
                          (?! [ ]*>)     ## negative lookahead
                      /ix, '</A>' )

   ## quick fix  </br>  => <br>
   html = html.gsub( /<\/BR>/i, '<BR>' )



  ## quick fix - change typo <H1></H2>
  ##  tables/58full.html
  html = html.gsub( '<H1>Quarterfinals</H2>', '<H2>Quarterfinals</H2>' ) 

  ## quick fix - change typo <M>,<N> to <B>
  ##   tables/54full.html
  html = html.gsub( '<M>MEX</B>', '<B>MEX</B>' ) 
  ##   tables/58full.html 
  html = html.gsub( '<N>CZE</B>', '<B>CZE</B>' ) 


  ## quick fix -
  ##   tablesb/braz88.html 
  html = html.gsub( '<</TITLE>', '</TITLE>' )

  
  ## quick fix
  ##   hr (horizontal rule) via img
  ##   in  tables/30full.html and others
  ##   
  ## <IMG SRC="xshadow.gif.pagespeed.ic.AbdeNVcmzw.png" ALT="-----------">
  ##   look  for
  ## <IMG   ALT="---">
  html = html.gsub(  /<IMG
                            [^>]+?
                           ALT="-{3,}"
                         >/ixm, '<HR>' )


  html
end
def errata_html( html ) self.class.errata_html( html ); end


def self.errata_html_entities( html )
    ########
    ## typos / autofix - keep - why? why not?
    html = html.gsub( "&oulm;", 'ö' )    ## support typo in entity (&ouml;)
    html = html.gsub( "&uml;",  'ü' )    ## support typo in entity (&uuml;) - why? why not?
    html = html.gsub( "&slig;", "ß" )    ## support typo in entity (&szlig;)
    html = html.gsub( "&aaacute;", "á" )  ## typo for &aacute; 
    html = html.gsub( "&nitlde;", "ñ" )  ## typ for &ntilde;   
    html
end
def errata_html_entities( html ) self.class.errata_html_entities( html ); end



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

