

module Rsssf


  PageStat = Struct.new(
    :source,     ## e.g. https://rsssf.org/tabled/duit89.html
    :year,       ## e.g. 1989     -- note: always four digits
    :title,
    :authors,
    :last_updated,
    :line_count,  ## todo: rename to (just) lines - why? why not?
    :char_count,  ## todo: rename to (just) char(ectar)s  - why? why not?
    :sections)


###
## note:
#    a rsssf page may contain:
#     many leagues, cups
#     - tables, schedules (rounds), notes, etc.
#
#   a rsssf page MUST be in plain text (.txt) and utf-8 character encoding assumed
#

class Page

  include Utils   ## e.g. year_from_name, etc.

def self.read_cache( url )  ### use read_cache /web/html or such - why? why not?
  html = Webcache.read( url )

  puts "html:"
  pp html[0..400]

  txt = PageConverter.convert( html, url: url )
  txt

  new( txt )
end


def self.read_txt( path )  ## use read_txt
    # note: always assume sources (already) converted from html to txt!!!!
  txt = read_text( path )
  new( txt )
end



### use text alias too (for txt) - why? why not?
attr_accessor :txt

## quick hack? used for auto-patch machinery
attr_accessor :patch
attr_accessor :url  ### source url


def initialize( txt )
  @txt = txt

  @patch = nil
  @url   = nil
end




HTML_COMMENT_HEADER_RE = %r{  \A
                            [ \n]*  ## trailing spaces and blank lines
                       <!--
                            [ \n]*
                          (?<text> .+?)
                            [ \n]*
                        -->
                   }imx


###
##   find meta data block (via html-style comment header )
##    incl.   title, autor(s), url,  updated
##  e.g.
##    <!--
##       title:   Austria 2024/25
##       source:  https://rsssf.org/tableso/oost2025.html
##       author:  Hans Schöggl
##       updated: 7 Jul 2025
##      -->
##  -or-
##      authors: Hans Schöggl and Karel Stokkermans

def _parse_meta( txt )
     meta = {}
     m = HTML_COMMENT_HEADER_RE.match( txt )
     if m
        text = m[:text]
        text.each_line do |line|
            line = line.strip

            ## note - allow "inline" blank lines and comment lines (starting w/ #)
            next if line.empty?  || line.start_with?('#')

            ## split line on first colon (:) (only)
            ##   note - limit split to two pieces!!!
            key, value = line.split( /[ ]*:[ ]*/, 2)
            ## use a symbol (not string) as key - why? why not?
            meta[ key.to_sym ] = value
        end
        meta
     else
        nil ## no meta data (comment header) found
     end
end


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



##
## change to outline - why? why not?
def _build_toc( txt )

     hx =  txt.scan( HX_RE )

     toc = []
       hx.each do |marker,text,ref|
          toc <<  "#{marker} #{text}"
       end
     toc
end





=begin
<!--
     title:   Austria 2002/03
     source:  https://rsssf.org/tableso/oost03.html
     authors: Andreas Exenberger and Karel Stokkermans
     updated: 15 Jun 2022
    -->

=end

def build_stat
  title        = nil
  source       = nil
  authors      = nil
  last_updated = nil

  meta = _parse_meta( @txt ) || {}

  title        = meta[:title]
  source       = meta[:source]
  authors      = meta[:author] || meta[:authors]   ## note - check for author & authors !!!
  last_updated = meta[:updated]


  puts "*** !!! missing source"  if source.nil?
  puts "*** !!! missing authors and last updated"   if authors.nil? || last_updated.nil?


  ## get year from source (url)
  url_path  = URI.parse( source ).path
  basename  = File.basename( url_path, File.extname( url_path ) )  ## e.g. duit92.txt or duit92.html => duit92
  puts "   basename=>#{basename}<"
  year      = year_from_name( basename )


  sections = _build_toc( txt )

  ## count lines
  line_count = 0
  @txt.each_line { |line| line_count +=1 }


  rec = PageStat.new
  rec.source       = source         # e.g. http://rsssf.org/tabled/duit89.html   -- use source_url - why?? why not??
  rec.year         = year
  rec.title        = title
  rec.authors      = authors
  rec.last_updated = last_updated
  rec.line_count   = line_count
  rec.char_count   = @txt.size      ## fix: use "true" char count not byte count
  rec.sections     = sections

  rec
end  ## method build_stat


def save( path )
  write_text( path, @txt )
end  ## method save

end  ## class Page
end  ## module Rsssf
