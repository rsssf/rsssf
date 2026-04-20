



def build_index( files, dir:, outdir: )
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
      txt = read_text( "#{dir}/#{dirname}/#{basename}.txt" )

      title = find_title_in_comment( txt ) || 'n/a'
      
      idx = master[first] 
      idx[basename] = { path: "#{basename}.html",
                        title: title }
   end
   print "\n"




   buf = String.new
   buf <<  "<h1>Tables Index A-Z</h1>\n\n"

   master.each do |first, idx|
      if idx.size > 0
         ## use first.update e.g. a => A for index - why? why not?
         header =     first == '_' ? '0-9' : first
         buf << "<p><b>#{header}</b> (#{idx.size}) - \n"

         idx.each do |key, h|
            path =  h[:path]
            title = h[:title]

            buf << "<code>#{key}</code> <a href=\"#{path}\">#{title}</a>\n"
         end
       
         buf << "</p>\n\n"
      end
   end


   write_text( "#{outdir}/index.html", buf )
   
   buf
end   





