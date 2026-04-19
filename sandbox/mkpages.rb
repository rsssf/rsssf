############
#  to run use:
#   $ ruby sandbox/mkpages.rb 

##
###  generate web site
##      - web pages in .html from .txt


require_relative 'helper'




## use workdir or rootdir or such - why? why not?
def collect_datafiles( *globs, dir: )
   files = []
   globs.each do |glob|
      Dir.chdir( dir) do 
        more_files =  Dir.glob( glob )
        puts "==> #{glob}"
        puts "  #{more_files.size} file(s)"
        files += more_files
     end
   end
   files
end


def build_index( files, dir: )
   master = {
        '_' => {},
        'a' => {},      
        'b' => {},      
        'c' => {},      
        'd' => {},      
        'e' => {},      
        'f' => {},      
        'g' => {},      
        'h' => {},      
        'i' => {},      
        'j' => {},      
        'k' => {},      
        'l' => {},      
        'm' => {},      
        'n' => {},      
        'o' => {},      
        'p' => {},      
        'q' => {},      
        'r' => {},      
        's' => {},      
        't' => {},      
        'u' => {},      
        'v' => {},      
        'w' => {},      
        'x' => {},      
        'y' => {},      
        'z' => {},      
   }  ## master index 


   puts "==> building index for #{files.size} pages..."


##
##  sort by basename
   files.sort do |l,r|
      lbasename = File.basename( l, File.extname(l))
      rbasename = File.basename( r, File.extname(r))
      lbasename <=> rbasename     
   end


   ## use numbers, and a-z (26 chars)
   files.each_with_index do |file,i|

      ## use basename as key
      dirname = File.dirname( file )
      extname = File.extname( file )
      basename = File.basename( file, extname)
 
      first = basename[0].downcase

      ## use underscore (_) for numerics / numbers
      first = '_'   if  %w[0 1 2 3 4 5 6 7 8 9].include?(first)

      
      ##
      ## todo/fix:
      ##   get page title 
      ##    from source file comment
      ##  <!--  title:  -->
      ##  for now get from page cache in html!!!
      ##     

      print "."
      html = read_text( "./cache/rsssf.org/#{dirname}/#{basename}.html" )
      title = find_title( html )

      ## fix typos  - e.g. remove <
      ##    e.g. Brazil 1988<
      title = title.gsub( '<', '' )


      idx = master[first] 
      idx[basename] = { path: file,
                        title: title }
   end
   print "\n"

   buf = String.new


   master.each do |first, idx|
      if idx.size > 0
         header =     first == '_' ? '0-9' : first
         buf << "**#{header}** (#{idx.size}) - \n"

         idx.each do |key, h|
            path =  h[:path]
            title = h[:title]

            buf << "`#{key}` [#{title}](#{path})\n"
         end
       
         buf << "\n\n"
      end
   end

   buf
end   



## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹§ (?<ref> [^›]+?) ›
            )?
         }


HX_RE = %r{^
                   [ ]* 
                     ## negative lookahead
                     ##   do NOT match  =-=
                     ##   do NOT match  ===========  (without any heading text!!)
                     ##     e.g. 
                     ##       Fall season
                     ##       ===========

                    (?!     =-= 
                         |  ={1,} [ ]* $
                     )  

                  (?<marker> ={1,6})   
                     [ ]*
                  (?<text> .+?)
                     #{OPT_REF}
                     [ ]*
            $}x


def build_toc( txt, min: 2 )

     hx =  txt.scan( HX_RE )
    
     buf = String.new

     ## require a min of 2 headings
     if hx.size >= 2

       buf += "  Table of contents:\n\n"

       hx.each do |marker,text,ref|
          ## indent text by marker size (multiply by 2 - e.g. use 2x??)
          ## buf << "    %-6s %s" % [marker, ' '*marker.size]
          buf << "   %s" % [' '*marker.size]
          buf <<  "  "
          buf << text
          buf << "  (see <a href=\"\##{ref}\">§#{ref}</a>)"    if ref
          buf << "\n"
       end
     end

    buf
end




def build_page( txt, file: )


   toc = build_toc( txt, min: 2 )

   ## remove html-style comments
   txt = txt.gsub( /<!-- .*? -->/ixm, '' )


   ## replace headings (h1/h2/h3/h4/h5/h6)
   txt = txt.gsub( HX_RE ) do |_|
                m = Regexp.last_match

                level = m[:marker].size

                if m[:ref]
                  "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}  <a name=\"#{m[:ref]}\">§#{m[:ref]}</a></h#{level}>\n"
                else
                  "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}</h#{level}>\n"
                end
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
banner += "  "
banner += "<a href=\"#{rsssf_url}\">original @ rsssf.org</a>"
banner += " - "
banner += "<a href=\"#{github_url}\" title=\"yes, you can!\">view/edit this .txt page @ github</a>"

=begin
banner += " - "
banner += "<a href=\"\">football.txt version</a>"
banner += " ("
banner += "<a href=\"\">.json</a>"
banner += ", "
banner += "<a href=\"\">.log</a>"
banner += ")"
=end

banner += "\n\n"


body = String.new
if toc.empty?  
   ## do nothing
else
   body   += toc
end
body   += buf
body   += "\n"


   page = String.new
   page += <<HTML
<html>
<head>
   <title>add title here</title>
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


def build_pages( files, dir: )
    files.each do |file|
      dirname   = File.dirname( file )
      basename  = File.basename( file, File.extname( file ))

      path = "#{dir}/#{file}"
      txt = read_text( path )
      html = build_page( txt, file: file )

      write_text( "./tmp-site/#{dirname}/#{basename}.html", html )
    end
end


root_dir = '../tables'
globs = ['tables/*.txt',
         'tables[a-z]/*.txt'
        ]

files = collect_datafiles( *globs, dir: root_dir )
puts "  #{files.size} file(s)"
#=> 632 file(s)


test_files = [files[0], files[100], files[200], files[300]]
build_pages( test_files, dir: root_dir )



puts "bye"



__END__
buf = String.new
buf <<  "#  Tables Index A-Z\n\n"
buf <<  build_index( files, dir: root_dir)

puts buf


write_text( "../tables/INDEX.md", buf )

puts "bye"




