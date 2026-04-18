############
#  to run use:
#   $ ruby sandbox/mkindex.rb 


require_relative 'helper'




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
     'n/a'
  end
end



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

root_dir = '../tables'
globs = ['tables/*.txt',
         'tables[a-z]/*.txt'
        ]

files = collect_datafiles( *globs, dir: root_dir )
puts "  #{files.size} file(s)"
#=> 632 file(s)



buf = String.new
buf <<  "#  Tables Index A-Z\n\n"
buf <<  build_index( files, dir: root_dir)

puts buf


write_text( "../tables/INDEX.md", buf )

puts "bye"




