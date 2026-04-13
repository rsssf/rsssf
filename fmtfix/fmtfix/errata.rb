



ERRATAS = {
## in austria
##       avoid confusion with  /DD is year!!!
##          maybe make it a switch to turn on
    '[Nov 13/14]' => '[Nov 13,14]',
    '[Mar 25/26]' => '[Mar 25,26]',
    '[Aug 12/13]' => '[Aug 12,13]',



## "classic" typos 
    ## month
    '[Niv 8]' => '[Nov 8]',
    '[Mov 7]'  => '[Nov 7]',
    '[Mov 26]' => '[Nov 26]',
    ## double brackets
    '[Apr 15]]'                    => '[Apr 15]',
    "[[36' Hansen, 58' Glasner]"  => "[36' Hansen, 58' Glasner]",
    ### more
    '  att; '  => ' att: '   ##  e.g. Wembley; att; 11,689
    
}




def handle_errata_txt( txt )
   ERRATAS.each do |errata,replace|
      txt = txt.gsub( errata, replace )
   end

   txt
end