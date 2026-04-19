############
#  to run use:
#   $ ruby sandbox/mkstats.rb 


require_relative 'helper'



##
## note - use File.file? instead of File.exist? 
##            (checks if file exists AND file is a file NOT a directory)


def find_file( name, path: )
    return name    if File.file?( name )

    path.each do |dir|
        filepath = File.join( dir, name )
        return filepath   if File.file?(  filepath )
    end

    puts "!! ERROR - file <#{name}> not found; looking in path: #{path.inspect}"
    exit 1
end









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


##
##  Last updated: 22 Apr 1999
##  Last updated: 2 Apr 2005
## 
LAST_UPDATED_RE = %r{
       \b
       last [ ] updated: [ ]+ 
          (?<day>\d{1,2})  [ ]
          (?<month>[a-z]{3,10}) [ ] 
          (?<year>\d{4})
        \b    
}ixm

def find_last_updated( html )
  if m=LAST_UPDATED_RE.match( html )
      date = Date.strptime( "#{m[:day]} #{m[:month]} #{m[:year]}",
                            "%d %b %Y") 
      date.strftime( '%Y-%m-%d')  ## convert to iso date
  else
     'n/a'
  end
end




def mkstats( filename )

  pages = read_csv( filename )

  rows = []

  pages.each do |config|
    encoding = config['encoding']
    page     = config['page']
    url      = "https://rsssf.org/#{page}"

    html = Webcache.read( url )

    ##  note - quick-fix known html errors
    ##   e.g  ##  <</TITLE> in tablesb/braz88.html 
    html = Rsssf::PageConverter.errata_html( html )


    title        = find_title( html )
    last_updated = find_last_updated( html )


     ## check for number of pre(formatted) blocks
     pres =  html.scan( /<PRE>/i )
     pre_count = pres.size.to_s

     puts
     puts "==> #{page}  -  #{title}    #{last_updated}"

     ## load .txt 
     tables_dir = '../tables'

     dirname  = File.dirname( page )
     basename = File.basename( page, File.extname( page) ) 
     txt = read_text( "#{tables_dir}/#{dirname}/#{basename}.txt" )

     hr =  txt.scan( /^[ ]* 
                        =-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
                       [ ]* $/x )

     hr_count = hr.size.to_s 

     ##
     ## note - ascii hr replacement is
     ##            =-=-= !!!!!!

     h1 =  txt.scan( /^[ ]* =    (?! [=-]) .+? $/x )
     h2 =  txt.scan( /^[ ]* ={2} (?! [=-]) .+? $/x )
     h3 =  txt.scan( /^[ ]* ={3} (?! [=-]) .+? $/x )
     h4 =  txt.scan( /^[ ]* ={4} (?! [=-]) .+? $/x )
     h5 =  txt.scan( /^[ ]* ={5} (?! [=-]) .+? $/x )
     h6 =  txt.scan( /^[ ]* ={6} (?! [=-]) .+? $/x )
  
     hx =  txt.scan( /^[ ]* 
                          (?<marker>={1,6})  (?! [=-]) 
                           [ ]*
                          (?<text>.+?)
                       [ ]*
                     $/x )
   
     h_count = "#{h1.size==0 ? '-' : h1.size}/" +
               "#{h2.size==0 ? '-' : h2.size}/" +
               "#{h3.size==0 ? '-' : h3.size}/" +
               "#{h4.size==0 ? '-' : h4.size}/" +
               "#{h5.size==0 ? '-' : h5.size}/" +
               "#{h6.size==0 ? '-' : h6.size}"


     puts "pre    " +
          "#{h1.size==0 ? '-' : 'h1'}/" +
          "#{h2.size==0 ? '-' : 'h2'}/" +
          "#{h3.size==0 ? '-' : 'h3'}/" +
          "#{h4.size==0 ? '-' : 'h4'}/" +
          "#{h5.size==0 ? '-' : 'h5'}/" +
          "#{h6.size==0 ? '-' : 'h6'}" +
          "   hr"
     
          puts "#{pre_count}    #{h_count}    #{hr_count}:"
     hx.each do |marker,text|
        print "  (%d) %-6s" % [marker.size, marker]
        print "  "
        print text
        print "\n"
     end
=begin     
     puts "h1: #{h1.pretty_inspect}"  if h1.size > 0
     puts "h2: #{h2.pretty_inspect}"  if h2.size > 0
     puts "h3: #{h3.pretty_inspect}"  if h3.size > 0
     puts "h4: #{h4.pretty_inspect}"  if h4.size > 0
     puts "h5: #{h5.pretty_inspect}"   if h5.size > 0
     puts "h5: #{h6.pretty_inspect}"   if h6.size > 0
=end   
 
   ## count anchors (aka a name)
   ##  e.g 
      aname = txt.scan( /‹§  [^›]+  ›/x )
     aname_count = aname.size.to_s
     puts "aname #{aname_count}:"
     puts aname.join( ',' )

     rows << [page, title, last_updated, pre_count, h_count, hr_count, aname_count]
  end
   rows
end




PATH = [
   './config',
]

args = ARGV

outdir = './config'



rows = []

args.each do |arg|
   filename = find_file( "#{arg}.csv", path: PATH )
   rows += mkstats( filename )
end


outname = if args.size > 1 
              'all-stats.csv'   # generic stats for all pages (use star-stats or max-stats or such?)
          else
              arg = args[0]
              ## basename = File.basename( arg, File.extname( arg))
              "#{arg}-stats.csv"
          end

headers = ['page', 
           'title', 
           'updated', 
           'pre_count',
           'h_count',
           'hr_count',
           'aname_count']

write_csv( "#{outdir}/#{outname}", rows, headers: headers )


puts "bye"



__END__

pages = []
pages += read_csv( "./config/eng.csv" )
pages += read_csv( "./config/es.csv" )
pages += read_csv( "./config/de.csv" )
pages += read_csv( "./config/at.csv" )
pages += read_csv( "./config/br.csv" )
pages += read_csv( "./config/worldcup.csv" )
pages += read_csv( "./config/worldcup_quali.csv" )

## pages += read_csv( "./config/curdom.csv" )
## pages += read_csv( "./config/curtour.csv" )
pp pages



