



def build_index( site, outdir: )
   master = {
        '_' => [],
        'a' => [],      
        'b' => [],      
        'c' => [],      
        'd' => [],      
        'e' => [],      
        'f' => [],      
        'g' => [],      
        'h' => [],      
        'i' => [],      
        'j' => [],      
        'k' => [],      
        'l' => [],      
        'm' => [],      
        'n' => [],      
        'o' => [],      
        'p' => [],      
        'q' => [],      
        'r' => [],      
        's' => [],      
        't' => [],      
        'u' => [],      
        'v' => [],      
        'w' => [],      
        'x' => [],      
        'y' => [],      
        'z' => [],      
   }  ## master index 


   puts "==> building index for #{site.size} pages..."

   ## use _ for numbers (0-9), and a-z (26 chars)
   site.each_page do |page|   
      idx = master[  page.first ] 
      idx <<  page
   end
   
 
   buf = String.new

   master.each do |first, idx|
      if idx.size > 0
         
         ## sort by basename     
         idx = idx.sort do |l,r|
                        l.basename <=> r.basename
                     end

         ## use first.upcase e.g. a => A for index - why? why not?
         header =     first == '_' ? '0-9' : first
         buf << "<p><b>#{header}</b> (#{idx.size}) - \n"

         idx.each do |page|
            buf << "<code>#{page.basename}</code> <a href=\"#{page.basename}.html\">#{page.title}</a>\n"
         end
       
         buf << "</p>\n\n"
      end
   end

   
   banner = build_site_banner()
   title = "Tables Index A-Z"
   body =  "<h1>#{title}</h1>\n\n" + buf

   html = build_layout( title: title, body: body,
                         banner: banner )

   write_text( "#{outdir}/index.html", html )
   
   html
end   





