
module Rsssf
class PageConverter
 

   
  ENTITIES =  %w[
À   &Agrave;
Á   &Aacute;
Â   &Acirc;
Ã   &Atilde;
Ä   &Auml;
Å   &Aring;

à   &agrave;
á   &aacute;
â   &acirc;
ã   &atilde;
ä   &auml;
å   &aring;
Æ   &AElig;
æ   &aelig;
ß   &szlig;
Ç   &Ccedil;
ç   &ccedil;
È   &Egrave;
É   &Eacute;
Ê   &Ecirc;
Ë   &Euml;
è   &egrave;
é   &eacute;
ê   &ecirc;
ë   &euml;
Ì   &Igrave;
Í   &Iacute;
Î   &Icirc;
Ï   &Iuml;
ì   &igrave;
í   &iacute;
î   &icirc;
ï   &iuml;
Ñ   &Ntilde;
ñ   &ntilde;
Ò   &Ograve;
Ó   &Oacute;
Ô   &Ocirc;
Õ   &Otilde;
Ö   &Ouml;
ò   &ograve;
ó   &oacute;
ô   &ocirc;
õ   &otilde;
ö   &ouml;
Ø   &Oslash;
ø   &oslash;
Ù   &Ugrave;
Ú   &Uacute;
Û   &Ucirc;
Ü   &Uuml;
ù   &ugrave;
ú   &uacute;
û   &ucirc;
ü   &uuml;
Ý   &Yacute;
ý   &yacute;
ÿ   &yuml;

<    &lt;
>    &gt;
&    &amp;
©    &copy;
®    &reg;

]



  def convert_html_entities( html )
    ## check for html entities
    html = html.gsub( "&auml;", 'ä' )
    html = html.gsub( "&ouml;", 'ö' )
    html = html.gsub( "&uuml;", 'ü' )
    html = html.gsub( "&Auml;", 'Ä' )
    html = html.gsub( "&Ouml;", 'Ö' )
    html = html.gsub( "&Uuml;", 'Ü' )
    html = html.gsub( "&szlig;", 'ß' )
  
    ## typos / autofix - keep - why? why not?
    html = html.gsub( "&oulm;", 'ö' )    ## support typo in entity (&ouml;)
    html = html.gsub( "&uml;",  'ü' )    ## support typo in entity (&uuml;) - why? why not?
    html = html.gsub( "&slig;", "ß" )    ## support typo in entity (&szlig;)
    html = html.gsub( "&aaacute;", "á" )  ## typo for &aacute; 
    html = html.gsub( "&nitlde;", "ñ" )  ## typ for &ntilde;   
   

    ENTITIES.each_slice(2) do |str, entity|
       html = html.gsub( entity, str )
    end



    ##############
    ## check for more entities
    ##   limit &---; to length 10 - why? why not?


    ## check for decimal entities (mapping 1:1 to unicode) 
    html = html.gsub(/&#(\d+);/) do |match|
             uni =  if match == '&#307;'   ## use like Van D&#307;k  -> Van Dijk
                     'ij'
                    else
                     [$1.to_i].pack("U")          
                    end 
         
              ##puts "   converting numeric html entity #{match} to unicode char #{uni}"

             uni
          end

        
    html = html.gsub( /&[^; ]{1,10};/) do |match|

                  msg = "found unencoded html entity #{match}"
                  puts "*** WARN - #{msg}"
                  log( msg )  ## log too (see log.txt)

                  match   ## pass through as is (1:1)
         
    end
    
    html
  end




end # module PageConverter
end # module Rsssf

