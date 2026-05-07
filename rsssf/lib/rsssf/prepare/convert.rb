
module Rsssf
class  Prep    ## todo: find a better name e.g. BatchPrep or ??


## convenience helper
def self.convert_pages( pages, outdir: )
      @@prep ||= new   ## use a "shared" built-in prep
      @@prep.convert_pages( pages, outdir: outdir )
end


def convert_pages( pages, outdir: )
  pages.each_with_index do |config,i|
    puts
    puts "==> [#{i+1}/#{pages.size}] converting #{config.pretty_inspect}..."

    page     = config['page']
    url      = "https://rsssf.org/#{page}"

    html     = Webcache.read( url )


    edits = []

    txt, more_edits = PageConverter.convert( html, url: url )
    edits += more_edits


    basename = File.basename( page, File.extname( page ))
    dirname  = File.dirname( page )


    ##
    ##  post-process .txt page

    txt, more_edits, links, about = postproc_page( txt, basename: basename,
                                                        dirname: dirname )
    edits += more_edits



    title  =  find_title( html ) || 'n/a'

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



end    ## class Prep
end    ## module Rsssf