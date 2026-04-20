

=begin

todo - remove all "trailing" nav links in section

‹1974/75, see page oost75›.

‹1976/77, see page oost77›.

‹list of final tables, see page oosthist›.

‹list of champions, see page oostchamp›.

‹list of cup finals, see page oostcuphist›.

‹list of super cup finals, see page oostsupcuphist›.

‹list of foundation dates, see page oostfound›.
=end





TITLE_RE = %r{
    <TITLE>(?<text>.*?)</TITLE>
}ixm

def find_title( html )
  if m=TITLE_RE.match( html )
     text = m[:text].strip
     ## note - convert html entities
     ##  e.g. Brazil 2000 - Copa Jo&atilde;o Havelange
     text = Rsssf::PageConverter.convert_html_entities( text )
     text
  else
     nil
  end
end


=begin
e.g.

Authors: Hans Schöggl, Jan Schoenmakers and Karel Stokkermans

Last updated: 7 Mar 2023

-or-

Authors: Ambrosius Kutschera
and Karel Stokkermans
Last updated: 31 Oct 2004

-or-

Author: RSSSF

Last updated: 15 Jun 2022

-or-

Authors: Andreas Exenberger, Hans Schöggl
and Karel Stokkermans

Last updated: 15 Jul 2022

=end

ABOUT_META_RE = %r{
    ## (i) author(s) info
   \b authors? [ ]* :
    \s+
      (?<author> .+?)    ## note - non-greedy (may incl. newline break!!)
    \s+
    ## (ii) followed by date
    \b last [ ]+ updated [ ]*:
      \s*
      (?<date> \d{1,2} [ ]+              ## day
                [a-z]{3,10} [ ]+         ## month  
                \d{4} \b)                ## year
}ixm



## change name to authors_n_updated or such - why? why not?
def find_author_n_date( txt )
  ##
  ## fix/todo: move authors n last updated 
  ##  whitespace cleanup  - why? why not?? 

  if m=ABOUT_META_RE.match( txt )
     
    authors = m[:author].strip.gsub(/\s+/, ' ' )  # cleanup whitespace; squish-style
    authors = authors.gsub( /[ ]*,[ ]*/, ', ' )    # prettify commas - always single space after comma (no space before)

    updated = m[:date].strip.gsub(/\s+/, ' ' ) 
 
    [authors, updated]
  else
     ## report error or raise exception??
     ##  return nil for now
     [nil,nil]  ## or return (single) nil ??
  end
end






###
##  remove trailing about document meta backmatter
##  == About this document  ‹§about›
## 

START_W_ABOUT_RE = %r{  \A
                  [ \n]*   ## trailing spaces or blank lines
                  ={2,} [ ]* About [ ]+ this [ ]+ document
                   .*?
              }ix


##
## todo - fix
##
##   remove all menu, ul,li, tags etc.
##    before nav check
##    see https://rsssf.github.io/tables/2014q.html
##       as an example!!!

START_W_NAV_RE = %r{  \A
                [ \n]*    ## trailing spaces or blank lines 
                ‹.+?›    ##  link  (exlude named anchor - why? why not? §)
             }ix
          
             


###
#  note  - check for special cases (later) with no about this docu section!!
#
##   https://rsssf.org/tablesb/braz98.html
##         has not about document section
#       and only a last update: 22 Apr 1999   line (no author)


def do_edits( txt )

  ### record edits in its own txt file  
  edits = []
  about = nil

###
##  step 1
##   split by horizontal rules (hrs)
##       and remove navigations sections
##             starting with links e.g.   
## ‹Bundesliga, see §bund›

   sects = txt.split( /^=-=-=-=-=-=-=-=-=-=-=-=-=-=-=$/ )

   
   sects = sects.select do |sect|
             if START_W_NAV_RE.match?( sect )
               edit = String.new 
               edit += "-- removing nav(igation) section:"
               edit += sect

               puts edit

               edits << edit   ## record edit
         
               false           ## remove (nav) section 
             elsif START_W_ABOUT_RE.match?( sect )
               about = sect
               false           ## remove (about) section
             else
               true            ## keep section 
             end     
           end

   ## sects.each_with_index do |sect,i|
   ##  puts "==> #{i+1}/#{sects.size}"
   ##  pp sect
   ## end
   ##  puts "  #{sects.size} sect(s)"
 
   
   ## note - replace hr with blank line
   txt = sects.join( "\n\n" )


   ###
   ## remove pre comments
   txt = txt.gsub( "<!-- start pre -->\n", '' )
   txt = txt.gsub( "<!-- end pre -->\n", '' )


   ## note - return (new) txt AND recorded edits (& erratas)
   ##        return edits as array or joined (single) string - why? why not?
   ##   note - return empty array if no edits!!
   [txt, edits, about]
end



def convert_pages( pages, outdir: )
  pages.each_with_index do |config,i|
    puts
    puts "==> [#{i+1}/#{pages.size}] converting #{config.pretty_inspect}..."

    page     = config['page']
    url      = "https://rsssf.org/#{page}"

    html     = Webcache.read( url )
  

    edits = []

    txt, more_edits = Rsssf::PageConverter.convert( html, url: url )
    edits += more_edits

    txt, more_edits, about = do_edits( txt )
    edits += more_edits

    basename = File.basename( page, File.extname( page ))
    dirname  = File.dirname( page )




    title  =  find_title( html ) || 'n/a'
    ## note - title quick typo fix (in brazil) remove <
    ##   e.g. <TITLE>Brazil 1988<</TITLE>
    title = title.gsub( '<', '' )

    authors, updated = about ? find_author_n_date( about ) : [nil,nil]

 header_props = <<EOS 
     title:   #{title}
     source:  #{url}
EOS

   if authors && updated
      ##  assume plural if and or command (,) 
      header_props +=  if /\band\b|,/i.match( authors )
                         "     authors: #{authors}\n"
                       else
                         "     author:  #{authors}\n"
                       end
      header_props +=    "     updated: #{updated}"
   end


  header = <<EOS 
  <!--
#{header_props}    
    -->
EOS


     ## note - (auto-) add (comment) header to written out txt!!!
     write_text( "#{outdir}/#{dirname}/#{basename}.txt", header+txt )

     ## todo/check - delete edits file if no edits - why? why not?
     if edits.size > 0
        write_text( "#{outdir}/#{dirname}/#{basename}.edits.txt", edits.join("\n") )
     end

     ## todo/check - delete about file if no about - why? why not?
     if about
        write_text( "#{outdir}/#{dirname}/#{basename}.about.txt", about )
     end

  end
end
