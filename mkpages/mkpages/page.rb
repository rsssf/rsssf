

## (i)  replace anchored names
##           ‹§pbengo
ANAME_RE = %r{‹§ (?<ref> [^›]+?) ›}ix

## (ii)   replace ref
##          see §pbengo
##  note - use positive lookahead for › (do NOT incl.) 
SEE_ANAME_RE = %r{\bsee [ ] § (?<ref> [^›]+?) ?=›}ix

## (iii)  replace page links
##          see page 2006f
##   see page ../tablesw/worldcup›
##  note - use positive lookahead for › (do NOT incl.) 
SEE_APAGE_RE = %r{\bsee [ ] page [ ] (?<page> [^›]+?) ?=›}ix



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



HTML_COMMENT_RE = %r{<!-- 
                          [ \n]* 
                        (?<text> .+?) 
                         [ \n]* 
                   -->}imx

## note - allow no (empty) title? why? why not?                        
TITLE_PROP_RE = %r{ ^ [ ]* 
                        (?<key> title) 
                          [ ]*  :  [ ]* 
                        (?<value> .*?) 
                      [ ]*
                   $}ix


def find_title_in_comment( txt )
     comments = txt.scan( HTML_COMMENT_RE )
    
     ## assume first comment is "header" comments
     ##   note - match is an array of captures (even if only one capture) 
     comment = comments[0][0]
     if m = TITLE_PROP_RE.match( comment )
        m[:value]
     else
       nil
     end
end



def build_page( txt, file: )

##
##  clean-up windows-style newlines - why? why not?
    txt = txt.gsub( "\r\n", "\n" )

    
    title = find_title_in_comment( txt ) || 'n/a'


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

                if m[:ref]
                  "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}  <a name=\"#{m[:ref]}\">§#{m[:ref]}</a></h#{level}>"
                else
                  "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}</h#{level}>"
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
               page = m[:page]
               page = page.sub( %r{^\.\./tables[a-z]?/}, '' )
               page = page.sub( %r{^\.\./}, '' )

                "see page <a href=\"#{page}.html\">#{page}</a>"        
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

   buf = txt




   dirname   = File.dirname( file )
   basename  = File.basename( file, File.extname( file ))

rsssf_url  = "https://rsssf.org/#{dirname}/#{basename}.html"
github_url = "https://github.com/rsssf/tables/blob/master/#{dirname}/#{basename}.txt"


banner = String.new
banner += "<a href=\"./index.html\" title=\"Tables Index A-Z\">/</a>"
banner += " - "
banner += "<a href=\"#{rsssf_url}\">original @ rsssf.org</a>"
## banner += " @ <a href=\"https://rsssf.org\">rsssf.org</a>"
banner += " - "
banner += "<a href=\"#{github_url}\" title=\"yes, you can! changes tracked @ github\">view/edit this page</a>"
banner += " ("
banner += "<a href=\"https://github.com/rsssf/tables/raw/refs/heads/master/#{dirname}/#{basename}.txt\">.txt</a>"
banner += ")"
## banner += " @ <a href=\"https://github.com/rsssf\">github</a>"
banner += " - "
banner += "<a href=\"\" title=\"SOON!\">football.txt version</a>"
banner += " ("
banner += "<a href=\"\" title=\"SOON!\">.json</a>"
banner += ", "
banner += "<a href=\"\" title=\"SOON!\">.log</a>"
banner += ")"

banner += "\n"


=begin
-- use  for toc???
  position: fixed;
  top: 10px;
  right: 10px;
=end

style = String.new
style += <<CSS
#toc {
  float: right;
  width: 300px;  
  z-index: 9999;
  padding: 7px;
  border: 1px solid #AAA;
  background-color: #F9F9F9;
}
CSS



body = String.new

if toc.empty?  
   ## do nothing
else
=begin   
   body   += "<div id=\"toc\">\n"
   body   += toc
   body   += "</div>\n"
=end

   body   += toc
   body   += "\n"

end

body   += buf

=begin
<style>
#{style}
</style>
=end

   page = String.new
   page += <<HTML
<!DOCTYPE html>   
<html>
<head>
   <meta charset="utf-8">
   <title>#{title}</title>
</head>
<body>
<pre>
#{banner}
#{body}
</pre>
</body></html>
HTML

   page
end

