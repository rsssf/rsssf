

def convert_pages( pages, outdir: )
  pages.each_with_index do |config,i|
    puts
    puts "==> [#{i+1}/#{pages.size}] converting #{config.pretty_inspect}..."

    page     = config['page']
    url      = "https://rsssf.org/#{page}"

    html     = Webcache.read( url )
  
    txt = Rsssf::PageConverter.convert( html, url: url )

    
    basename = File.basename( page, File.extname( page ))
    dirname  = File.dirname( page )

    write_text( "#{outdir}/#{dirname}/#{basename}.txt", txt )
  end
end
