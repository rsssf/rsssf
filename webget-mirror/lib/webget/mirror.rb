$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webclient/lib' )
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )


require 'cocos'
require 'webget'           ## incl. webget, webcache, webclient, etc.
require 'nokogiri'

require 'active_record'   ## todo: add sqlite3? etc.



=begin
module Mirror
  class Configuration
     def host() @base_url.host; end

     def base_url
        raise ArgumentError, "config.base_url not set"   if @base_url.nil?
        @base_url
     end
     def base_url=( url )
        @base_url = URI( url )   ## note URI() same as URI.parse()
     end
  end # class Configuration


 ## lets you use
 ##   Webcache.configure do |config|
 ##      config.root = './cache'
 ##   end
 def self.configure() yield( config ); end
 def self.config()    @config ||= Configuration.new;  end


 ## add "high level" root convenience helpers
 ##   use delegate helper - why? why not?
 ## def self.host()       config.host; end
 ## def self.host=(value) config.host = value; end
end   # module Mirror
=end





require_relative 'mirror/database'


require_relative 'mirror/find_links'  ## find_links helper 'n' more
require_relative 'mirror/download_page'

### commands
require_relative 'mirror/list'
require_relative 'mirror/mirror'


## auto log errors  (append to logs.txt)
def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   File.open( './mirror_logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end





HTML_CHARSET_RE = %r{
   <meta [ ]+
       [^<>]*?        ## note - use non-greedy (shortest) match
  \bcharset
        [ ]*=[ ]*
          ['"]?       ## optional opening quote
        (?<charset>[a-z0-9-]+)
}ix


HTML_DOCTYPE_RE = %r{
   <!DOCTYPE [ ]+
        (?<doctype> [^<>]+?)  ## note - use non-greedy (shortest) match
                               ## do NOT allow opening/closing brackets for now
                               ##  ever possible? double check
            [ ]*
   >
}ix







module Mirror
class Website
  def host
     raise ArgumentError, "website.base_url not set"   if @base_url.nil?
     @base_url.host
  end

  def base_url=( url )
      @base_url = URI( url )   ## note URI() same as URI.parse()
  end
  def base_url
      raise ArgumentError, "website.base_url not set"   if @base_url.nil?
      @base_url.to_s     ## note - returns string NOT uri object!!!
  end



  ## array of hash (table) records e.g.
  ##    page,         encoding
  ##    /index.html,  windows-1252
  def start_pages=( config )
    @start_pages = config
  end
  def start_pages
      raise ArgumentError, "website.start_pages not set"   if @start_pages.nil?
      @start_pages
  end


  def default_page_encoding=( encoding )
       @default_page_encoding = encoding
  end
  def _default_page_encoding
       defined?( @default_page_encoding ) ?  @default_page_encoding : 'UTF-8'
  end


  ## default page encoding (lookup by path);
  ##    change to windows-1256 if needed
  def page_encoding( path ) _default_page_encoding; end

  ### quick fix html w/ search & replace
  ##    default: do nothing
  def errata( html, url: ) html; end


  def mirror_pages

    ## add seed/start pages
    start_pages.each do |config|
      path     = config['page']
      encoding = config['encoding']
      encoding = page_encoding( path )   if config['encoding'].nil? || config['encoding'].empty?

      page_rec = MirrorDb::Model::Page.find_or_create_by!( path: path ) do |rec|
                      puts "  add page #{rec.path} (cached: false) to mirror.db"

                      rec.basename = File.basename( rec.path, File.extname( rec.path ))
                      rec.extname  = File.extname( rec.path )
                      rec.dirname  = File.dirname( rec.path )

                      rec.encoding = encoding
                      rec.cached   = false
                end
      pp page_rec

      _mirror_pages( site: self )
    end
  end
end  # class Website
end  ## module Mirror
