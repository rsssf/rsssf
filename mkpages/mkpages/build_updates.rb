
def build_updates( site, outdir: )

   puts "==> building (latest) updates (index) for #{site.size} pages..."


   pages = site.pages.sort do |l,r|
                       ## for no date (nil) use old date  (e.g. 1850-01-01)
                  res =  (r.updated || Date.new(1850,1,1)) <=> (l.updated || Date.new(1850,1,1))
                  res =   l.basename <=> r.basename     if res == 0
                  res  
             end

   ##
   ##  maybe later add counts and break with headers by year!!!
   ##
    
   buf = String.new

   buf << %Q{<table style="width:100%">\n}
   buf << %Q{<tr><th style="width:150px"></th><th></th><th>Author(s)</th></tr>\n}
   pages.each do |page|

      buf << "<tr>\n"
      buf << "<td>#{page.updated ? page.updated.strftime('%b %d, %Y') : '-' }</td>\n"
      buf << "<td><code>#{page.basename}</code> <a href=\"#{page.basename}.html\">#{page.title}</a></td>\n"
      buf << "<td>#{page.author}</td>\n"
      buf << "</tr>\n\n"
   end
   buf << "</table>\n"
 


   banner = build_site_banner()
   title = "Latest Updates"
   body =  "<h1>#{title}</h1>\n\n" + buf
 
   html = build_layout( title: title, body: body,
                          banner: banner )

   write_text( "#{outdir}/updates.html", html )
   
   html

end


