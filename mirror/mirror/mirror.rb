
## use recursive_download_page or such - why? why not?
##   or add recursive flag

=begin
visited: 100 (downloaded: 98) -  35586 page(s) indexed (9158 cached, 26428 missing)
    [98/26526 -  0.00%]  2:14 mins -  1.38 secs/page, estimate: 608:53 mins
=end

def fmt_time_diff( time_start, time_end=Time.now, count:, step: nil )
   time_diff  = time_end - time_start
   buf = String.new

    if step
       buf +=  "  [#{step}/#{count} - %5.2f%%]" % [step*100/count]

       buf +=  "  %d:%02d mins" % [time_diff/60, time_diff%60]
       buf +=  " - %5.2f secs/page" % [time_diff/step]

       time_estimate = (time_diff/step) * count
       buf +=  ", estimate: %d:%02d mins" % [time_estimate/60, time_estimate%60]
    else
      buf +=  "  %d:%02d mins" % [time_diff/60, time_diff%60]
      buf +=  " - %5.2f secs/page  (#{count} pages)" % [time_diff/count]
   end

   buf
end



##
##  use limit for batch - why? why not?
##     start of / try a batch of a hundred
def mirror_pages( force: false,
                  batch: 1000 )

    visited    = 0
    downloaded = 0

    time_start = Time.now

    loop do
      ## todo - add
       ##       prefer pages
       ##  starting with /tables,/tables[a-z]/
       ##    - add to select
       ## prefer pages
       ##    starting with /tables,/tables[a-z]/
       ##
       ##   queue.keys.find do |key|
       ##                       %{\A/tables[a-z]?/}.match?(key)
       ##                 end

       ##   prioritize main pages
       ##     fix - pass in via seed / use seed !!!
       ## /curdom.html
       ## /curtour.html
       ## /histdom.html
       ## /intclub.html
       ## /intland.html

      page_recs =  MirrorDb::Model::Page.where( cached: false,
                                                path: ['/curdom.html',
                                                       '/curtour.html',
                                                        '/histdom.html',
                                                        '/intclub.html',
                                                        '/intland.html']
                                               ).limit( batch )

       ## note - sql (like) wildcard rules/syntax:
       ##      %: Matches zero or more characters
       ##      _: Matches exactly one character

      if page_recs.size == 0
        page_recs =  MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '/table%' ).limit( batch )
      end

      if page_recs.size == 0   ## retry if nothing found matching /table*
        page_recs =  MirrorDb::Model::Page.where( cached: false ).limit( batch )
      end


      ## break   if visited == batch || page_recs.size == 0
      break   if page_recs.size == 0



       page_recs.each_with_index do |page_rec,i|

         ##  note - ignore known pages (404 not found)!!
         if PAGES_404.include?( page_rec.path )
            ## set cached to true to avoid infinite loop!!
            ##   keep in 404s in db - why? why not?
            page_rec.update!( http_status: 404,
                              cached:       true )
            next
         end


         ### special case for non .html pages (e.g. .pdf others too??)
         ##    do NOT download / mirror / cache for now
         if File.extname( page_rec.path ) != '.html'
            page_rec.update!( cached: true )
            next
         end



         ## note - on download (not if cached)
         ##        encoding
         ##           might be get changed
         ##        ALWAYS use updated encoding!!

         html, response_meta  = _download_page( page_rec.url,
                                             encoding: page_rec.encoding,
                                            force: force )

         ##  if response meta data present than fresh download (not cached)
         cached  = response_meta ? false : true

         if response_meta
             downloaded += 1
             puts " ---  " + fmt_time_diff( time_start,  count: downloaded )

             ###
             ## special case
             ##  check for 404 NOT FOUND
             if response_meta[:status] == 404
                      page_rec.update!( http_status: 404,
                                        cached:      true )

               next   ### note - skip further processing on 404 (no links etc.)!!
             end

         end


         ## turn on verbose mode only if page downloaded (not on cache hit)
         verbose = cached ? false : true
         ## verbose = true


          html = errata( html, url: page_rec.url  )

         ## Standard HTML4-style parsing (default)
         ## doc = Nokogiri::HTML(malformed_html)
         ##  -or-
         ## More robust HTML5 parsing
         ##doc = Nokogiri::HTML5(malformed_html)

           doc = Nokogiri::HTML( html )

           ### try to find page title
           ##    not - title might be missing (nil)!!
             title_el =  doc.at_css('title')
             title =  title_el ? title_el.text.strip :  nil


           internals, _ = _find_links( doc,
                                       url: page_rec.url,
                                       verbose: verbose
                                     )


            ## add links to db
            internals.each do |path|
               internal_rec = MirrorDb::Model::Page.find_or_create_by!(
                                                            path: path ) do |rec|
                                    puts "     add linked page #{rec.path}"

                                    rec.basename = File.basename( rec.path, File.extname( rec.path ))
                                    rec.extname  = File.extname( rec.path )
                                    rec.dirname  = File.dirname( rec.path )

                                    rec.encoding = PAGES_ENCODING[ rec.path ]
                                    rec.cached   = false
                                 end

               ## puts "  add link from #{page_rec.path} to #{internal_rec.path} to mirror.db"
               ###  note allow - find (may happen after "crash" or interrupt)
               link_rec = MirrorDb::Model::Link.find_or_create_by!(
                                                         from_page_id: page_rec.id,
                                                         to_page_id:   internal_rec.id )
            end

            puts "  [#{i+1}/#{page_recs.size}] update page #{page_rec.path} w/ #{internals.size} page(s) linked - >#{title || 'n/a'}<"


            attribs = {
                cached: true
            }
            ## add (optional) title - might be missing in some pages
            attribs[ :title]     = title               if title

            ## check for encoding when fresh download (via response meta data)
            if response_meta
               encoding = response_meta[:encoding]

               attribs[ :encoding ] = encoding.downcase   if encoding
            end


            page_rec.update!( **attribs )



            visited += 1

           if visited % 100 == 0
              puts "\n visited: #{visited} (downloaded: #{downloaded}) - " +
                 " #{MirrorDb::Model::Page.count} page(s) indexed " +
                 "(#{MirrorDb::Model::Page.cached.count} cached, " +
                 "#{MirrorDb::Model::Page.not_cached.count} missing)"

             puts "  " + fmt_time_diff( time_start,  step: downloaded,
                                                      count: downloaded+MirrorDb::Model::Page.not_cached.count )


           end
       end
    end



            puts "\n visited: #{visited} (downloaded: #{downloaded}) - " +
                 " #{MirrorDb::Model::Page.count} page(s) indexed " +
                 "(#{MirrorDb::Model::Page.cached.count} cached, " +
                 "#{MirrorDb::Model::Page.not_cached.count} missing)"
end
