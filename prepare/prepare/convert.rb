

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
#  note  - check for special cases (later) with no about this docu section!!
#
##   https://rsssf.org/tablesb/braz98.html
##         has not about document section
#       and only a last update: 22 Apr 1999   line (no author)



##          see page 2006f
##   see page ../tablesw/worldcup›
##  e.g. ‹League C, see page 2023uefanl§lgc›
##       ‹League A, see page 2023uefanl.html#lga›
##   todo/fix - fix upstream ?? (e.g. remove. html and replace #=>§)
LINK_APAGE_RE = %r{  ‹(?<title> [^›]+?)
                       , [ ] see [ ] page [ ]
                      (?<pageref> [^›]+?)
                    ›
                }ix

=begin
["1973/74", "oost74"],
 ["1975/76", "oost76"],
 ["list of final tables", "oosthist"],
 ["list of champions", "oostchamp"],
 ["list of cup finals", "oostcuphist"],
 ["list of super cup finals", "oostsupcuphist"],
 ["list of foundation dates", "oostfound"]]
=end

def expand_pageref( pageref, dirname: )

                  ##
                  ##  note - pre-proces
                  ##   2023uefanl.html#lga
                  ##     stkitts2025.html#pres
                  ##
                  ##   remove .html
                  ##    and optional anchor
                  ##
                  ##   fix - upstream - why? why not?

                   pageref = pageref.sub(  %r{ \.html\b }ix, '' )
                   ## check - only really one # allowed in url path???
                   pageref = pageref.sub(  '#', '§' )


                 if /^[a-z0-9][a-z0-9-§]*$/.match?( pageref )
                    ## assume relative page in "local" dir
                    "#{dirname}/#{pageref}"
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


def collect_links( txt, basename:, dirname: )

  links = txt.scan( LINK_APAGE_RE )

  links.map do |link|
                   link[1] = expand_pageref( link[1], dirname: dirname )
                   link
               end

  links
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


    basename = File.basename( page, File.extname( page ))
    dirname  = File.dirname( page )


    ##
    ##  post-process .txt page

    txt, more_edits, links, about = postproc_page( txt, basename: basename,
                                                        dirname: dirname )
    edits += more_edits





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

     ## todo/check - delete links file if no links - why? why not?
     if links.size > 0
         buf = links.map do |link|
                              title   = link[0]
                              pageref = link[1]
                             "#{'%-30s' % pageref}  :  #{title}"
                        end.join( "\n")

         write_text( "#{outdir}/#{dirname}/#{basename}.links.txt", buf )
     end

     ## todo/check - delete about file if no about - why? why not?
     if about
        write_text( "#{outdir}/#{dirname}/#{basename}.about.txt", about )
     end

  end
end
