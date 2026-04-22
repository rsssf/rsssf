

##
# build a site (page) index
#



class SiteIndex


def self.build( files, dir: )
   idx = self.new( dir: dir )
   idx.add( files )
   idx
end



## use basedir - why? why not?
attr_reader :dir

attr_reader :mirror    ## make (org site map mirror) public for now - why? why not?



def initialize( dir: )
    @dir = dir
    @pages  = {}  ## indexed by basename/slug (as key)

    @mirror = {}  ## mirror / map of org site (keeps org path/names)
end



class Page
    ## maybe later -  read meta (title) on demand only
    attr_reader :site, :dirname, :basename


    def initialize( site:, dirname:, basename: )
        @site = site    # link to (parent) site

        @dirname  = dirname
        @basename = basename

        ## get meta data block via html-style comment header (in .txt)
        ##    incl.   title, autor(s), source,  updated
        ##  e.g.
        ##    <!--
        ##       title:   Austria 2024/25
        ##       source:  https://rsssf.org/tableso/oost2025.html
        ##       author:  Hans Schöggl
        ##       updated: 7 Jul 2025
        ##      -->
        ##  -or-
        ##      authors: Hans Schöggl and Karel Stokkermans
        @meta   =   parse_meta( _read_text() )
    end



    def _read_text
        txt = read_text( "#{@site.dir}/#{dirname}/#{basename}.txt" )

        ## check windows files on unix  -- remove \r - carriage return (cr)
        ##  clean-up windows-style newlines - why? why not?
        txt = txt.gsub( "\r\n", "\n" )
        txt
    end

    ## note - maybe memorize (cache) txt later - why? why not?
    ##    do NOT reread - and freeze text (to make read-only)??
    alias_method :txt,  :_read_text
    alias_method :text, :_read_text


    def first  ## or use letter - used for building an a-z index
      first = @basename[0].downcase
      ## use underscore (_) for numerics / numbers
      first = '_'   if  %w[0 1 2 3 4 5 6 7 8 9].include?(first)
      first
    end


    def source()   @meta[:source]; end   ## (original) rsssf source url
    def title()    @meta[:title] || 'n/a' ; end   ## (original) html page title <title></title>

    ## note - author incl. authors!!
    def author()   @meta[:author] || @meta[:authors]; end

    def updated
        ## auto-convert to date type - why? why not?
        ##  fix/fix   maybe already upstream (always use iso-style 2026-04-22) - why? why not?
        ##
        ##   7 Jul 2025
        str = @meta[:updated]

        ## note - return nil if no updated entry present
        ##   %b: Abbreviated month name (Jan, Feb)
        str ? Date.strptime( str, '%d %b %Y' ) : nil
    end
 end # (nested) class Page




def add( files )

   files.each_with_index do |file,i|

      ## use basename as key
      dirname = File.dirname( file )
      extname = File.extname( file )
      basename = File.basename( file, extname )

      page = @pages[ basename ]
      if page
         raise ArgumentError, "page slug #{basename} (#{file}) already in use - #{page.pretty_inspect}; cannot add duplicate; sorry"
      end

      print "."
      page = @pages[ basename ] = Page.new( site: self,
                                            dirname:   dirname,
                                            basename:  basename )

      ## add to mirror too?
      ##   fix/fix - check if dirname is ./ or such
      ##      for now always assume a dirname is present!!!
      @mirror[ "#{dirname}/#{basename}" ] = page
   end
   print "\n"
end


def each_page( &block )
    ##  note - sort by basename/slug (as key) - why? why not?
    @pages.keys.sort.each do |key|
        block.call( @pages[key] )
    end
end

def each_page_with_index( &block )

    ##  note - sort by basename/slug (as key) - why? why not?
    @pages.keys.sort.each_with_index do |key,i|
        block.call( @pages[key], i )
    end
end


def pages()  @pages.values; end
def size()   @pages.size; end

def has_page?( basename )   @pages.has_key?( basename ); end


end  # class SiteIndex