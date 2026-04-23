
## use recursive_download_page or such - why? why not?
##   or add recursive flag


def mirror_page( config, force:  false )
    pages    = {}
    visited  = {}
    externals = Hash.new(0)   ## only track ref/usage counts

    page = config['page']
    pages[ page ] = config

    loop do
       break if pages.empty?


       ## prefer pages
       ##  starting with /tables,/tables[a-z]/

       curpage = pages.keys.find do |key|
                              %{\A/tables[a-z]?/}.match?(key)
                        end


       curpage =  pages.keys[0]    if curpage.nil?

       curconfig = pages.delete( curpage )


## todo / double check fix read_csv upstream
##    if   empty column has comment it is "" empty string otherwise
##                it is nil!!!  ??

       encoding = curconfig['encoding']
       encoding = 'windows-1252'   if encoding.nil? || encoding.empty?

       page     = curconfig['page']
       url      = "#{BASE_URL}#{page}"

       html, cached  = _download_page( url,
                                   encoding: encoding,
                                   force: force )

       ## turn on verbose mode only if page downloaded (not on cache hit)
       verbose = cached ? false : true

       visited[ curpage ] = curconfig



       internals, more_externals = _find_links( html,
                                                url: url,
                                                verbose: verbose
                                                )

       more_pages = 0
       internals.each do |page|
              config = visited[page]
              if config
                ## already visited (downloaded)
                ##   add up count in future??
              else
                 config = pages[page]
                 if config
                    ## already in queue
                    ## add up count ??
                 else

##
##  skip known 404 pages e..g
##   !! HTTP ERROR - 404 Not Found:
##  GET https://rsssf.org/tablesn/nedantcup09.html...
                    next if page == '/tablesn/nedantcup09.html'


                    pages[page] = { 'page' => page }
                    more_pages +=1
                    puts "  adding new page #{page}"  if verbose
                 end
              end
       end

       puts "  added #{more_pages} new page(s) in #{curpage} to queue - #{pages.size} page(s) waiting"   if verbose


       more_externals.each do |link|
                       externals[link] += 1
                    end

    end




      puts "  #{visited.size} internal link(s) processed:"
      pp visited

      puts "  #{externals.size} external link(s) found:"
      pp externals

end
