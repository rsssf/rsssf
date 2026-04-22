

## (i)  replace anchored names
##           ‹§pbengo
ANAME_RE = %r{‹§ (?<ref> [^›]+?) ›}ix

## (ii)   replace ref
##          see §pbengo
##  note - use positive lookahead for › (do NOT incl.) 
SEE_ANAME_RE = %r{\bsee [ ] § (?<ref> [^›]+?) (?=›)}ix

## (iii)  replace page links
##          see page 2006f
##   see page ../tablesw/worldcup›
##  note - use positive lookahead for › (do NOT incl.) 
SEE_APAGE_RE = %r{\bsee [ ] page [ ] (?<page> [^›]+?) (?=›)}ix



## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹§ (?<ref> [^›]+?) ›
            )?
         }


HX_RE = %r{          ## negative lookahead
                     ##   do NOT match  =-=
                     ##   do NOT match  ===========  (without any heading text!!)
                     ##     e.g. 
                     ##       Fall season
                     ##       ===========

                    (?! ^[ ]* (?:    =-= 
                                 |  ={1,} [ ]* $
                               )
                     )  

                     ^        
                    [ ]* 

                  (?<marker> ={1,6})   
                     [ ]*
                  (?<text> .+?)
                     #{OPT_REF}
                     [ ]*
            $}x




def build_page( page )

    txt   = page.txt
    
    title = page.title
    

   toc = build_toc( txt, min: 2 )

   ## remove html-style comments
   txt = txt.gsub( /<!-- .*? -->/ixm, '' )
   
   ## remove all leading spaces & newlines
   txt = txt.lstrip  

    ## remove newlines if more than double
    txt = txt.gsub( /\n{2,}/, "\n\n" )


   ## replace headings (h1/h2/h3/h4/h5/h6)
   txt = txt.gsub( HX_RE ) do |_|
                m = Regexp.last_match

                level = m[:marker].size

                ## note - for level 5,6 
                ##     for now do NOT print markers!!!
                if level >= 5
                  if m[:ref]
                    "<h#{level}>#{m[:text]}  <a name=\"#{m[:ref]}\">§#{m[:ref]}</a></h#{level}>"
                  else
                    "<h#{level}>#{m[:text]}</h#{level}>"
                  end
                else  
                  if m[:ref]
                    "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}  <a name=\"#{m[:ref]}\">§#{m[:ref]}</a></h#{level}>"
                  else
                    "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}</h#{level}>"
                  end
               end
             end

   txt = txt.gsub( ANAME_RE ) do |_|
                m = Regexp.last_match
                "<a name=\"#{m[:ref]}\">§#{m[:ref]}</a>"
             end

   txt = txt.gsub( SEE_ANAME_RE ) do |_|
                m = Regexp.last_match
                "see <a href=\"\##{m[:ref]}\">§#{m[:ref]}</a>"        
            end

   txt = txt.gsub( SEE_APAGE_RE ) do |_|
                m = Regexp.last_match

        ### note - auto-patch page href for "flattened" space
        ##            e.g. dirs /tables & /tables[a-z] removed
        ##       
               pageref = m[:page]
               pageref = pageref.sub( %r{^\.\./tables[a-z]?/}, '' )
               pageref = pageref.sub( %r{^\.\./}, '' )

               ##
               ## 
               ##  2023uefanl.html#lga
               ##   remove .html  and replace # with §
               pageref = pageref.sub( %r{\.html\b}i, '' )
               pageref = pageref.sub( '#', '§' )
    
               ## todo/fix - report external links (if any)
               ##              that is, outside of  rsssf.org


                "see page <a href=\"#{pageref}.html\">#{pageref}</a>"
            end


  ## build table of contents (toc)


=begin
‹XLVIII Girabola, see §girabola›
‹Taça, see §taca›
‹Segundona, see §segundona›
‹Provincial Leagues, see §province›
=end

##
##  fix/fix//fix - must escape &




 
   banner = build_banner( page: page )


body = String.new
body   += toc   if toc

## note - wrap rsssf .txt page in its own pre block 
body   += "<pre>\n"
body   += txt
body   += "</pre>\n"


  ## change body to content - why? why not?
   html = build_layout( title: title, 
                        body: body,
                        banner: banner )
                       

   html
end

