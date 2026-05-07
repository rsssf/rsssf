
module Rsssf
class  Prep    ## todo: find a better name e.g. BatchPrep or ??


###
#  note  - check for special cases (later) with no about this docu section!!
#
##   https://rsssf.org/tablesb/braz98.html
##         has not about document section
#       and only a last update: 22 Apr 1999   line (no author)





TITLE_RE = %r{
    <TITLE>(?<text>.*?)</TITLE>
}ixm

def find_title( html )
  if m=TITLE_RE.match( html )
     text = m[:text].strip

     ## note - convert html entities
     ##  e.g. Brazil 2000 - Copa Jo&atilde;o Havelange
     text = PageConverter.convert_html_entities( text )

     ##  add autofix known typos/erratas here!!!
     ## note - title quick typo fix (in brazil) remove <
     ##   e.g. <TITLE>Brazil 1988<</TITLE>
     text = text.gsub( '<', '' )

     text
  else
     nil
  end
end



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


end    ## class Prep
end    ## module Rsssf



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
