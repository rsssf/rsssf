

     ##
     ## note - ascii hr replacement is
     ##            =-=-= (do NOT match) !!!!!!


HX_RE = %r{          ## negative lookahead
                     ##   do NOT match  =-=
                     ##   do NOT match  ===========  (without any heading text!!)
                     ##     e.g.
                     ##       Fall season
                     ##       ===========

                    (?! ^[ ]* (?:    =-=
                                 |  ={1,} [ ]* $
                               )
                     )

                     ^
                    [ ]*

                  (?<marker> ={1,6})
                     [ ]*
                  (?<text> .+?)
                     #{OPT_REF}
                     [ ]*
            $}x





def autofix_outline( txt, title: )


     hx =  txt.scan( HX_RE )

     ### note - shortcircuit if no headings found!!!
     return txt    if hx.size == 0




     ## update counts/usage of h1,h2,h3,h4,h5,h6
     counts = [nil,0,0,0,0,0,0]
     hx.each do |marker,_|
                   level = marker.size;
                   counts[ level ] += 1
     end

      ## flatten level; only record levels with heading counts
      levels = []
      counts.each_with_index do  |count,level|
            levels << level    if count && count > 0
      end



      #####
      ### special case for first heading
      ##    check if heading is matching title AND the only one in top level
      htop_marker, htop_header = hx[0]
      htop_level = htop_marker.size

      ##  top heading MUST always be lowest (top)
      if htop_level == levels[0]
        if counts[htop_level] == 1
          ##  check if same as title
          ##    if yes pop (that is, remove too)
          if htop_header == title
             counts[htop_level] = 0  ## update/reset counter
             levels.shift            ## remove first level (inline op)!!!

             ### note - space in header must be replaces with [ ]!!!!
             ##                    or \\   with Regex.escape!!!
             ###  note - MUST escape string for regex e.g. [Bra..] or 1.
             ###
             ###   V COPA BRASIL - 1979 [Brazilian Championship]
             ##    check if space works with escape??

             htop_re = %r{
                            ^
                           [ ]* #{htop_marker}
                           [ ]* #{Regexp.escape(htop_header)}
                              .*?
                           $    ## or use \n - why? why not?
                         }x
             ## remove line in txt too
             txt = txt.sub( htop_re ) do |match|
                   puts "   removing top heading matching title  -- >#{match}<"
                                 ''
                              end
          else
             ## warn/log  - heading top NOT matching page title
             msg = "first top heading NOT matching page title  #{htop_header} <=> #{title}"
             puts "!! WARN #{msg}"
             log( msg )
          end
        else
          ## warn/log   - more than one top level heading!!!
          msg = "more than one (#{counts[htop_level]}) top heading #{htop_level} found " +
                "in page with title #{title}"
          ## maybe add headers in the future - why? why not?
          log( msg )
       end
      else
         ## warn/log   - top heading NOT top!!
          msg = "top heading #{htop_level} not top (#{levels[0]}) " +
                "in page with title #{title}"
          log( msg )
      end


       mapping = {}
       levels.each_with_index do |level,i|
            from = level
            to   = i+1
            mapping[from] = to
       end


      # rewrite headings
       txt = txt.gsub( HX_RE ) do
                 m = Regexp.last_match
                 old_marker = m[:marker]
                 old_level  = m[:marker].size

                 new_level = mapping[old_level]

                 if new_level.nil?
                    puts "!! no heading #{old_level} mapping found in page >#{title}<:"
                    puts "match:"
                    pp m
                    puts "counts:"
                    pp counts
                    puts "levels:"
                    pp levels
                    puts "mapping:"
                    pp mapping
                    exit 1
                 end

                 new_marker =  '=' * new_level

                 ## remove level diff from marker
                 ##
                 ##  maybe in the future use track trailing marker too
                 ##   and rebuild heading/header instead of gsub

                ## note -  always start at level 2 (page title like in wikipedia is level 1)
                 ##                  thus, new_level+1

                 if (old_level - new_level+1) > 0
                    ## note - will remove diff from leading (and possibly trailing) marker too
                    m[0].gsub( old_marker, new_marker+'=' )
                 else
                    m[0]
                 end
           end


    txt

end



def _scan_outline( txt )   txt.scan( HX_RE );  end

def build_outline( txt )

     hx =  txt.scan( HX_RE )


     counts = [nil,0,0,0,0,0,0]  ## note - index 0 is nil
                                 ##  index 1 (h1) is 0 etc.

     hx.each { |marker,_| counts[ marker.size ] +=1 }


     buf = String.new
     buf += "  outline:"
     buf += " " +
          "#{counts[1]==0 ? '-' : 'h1'}/" +
          "#{counts[2]==0 ? '-' : 'h2'}/" +
          "#{counts[3]==0 ? '-' : 'h3'}/" +
          "#{counts[4]==0 ? '-' : 'h4'}/" +
          "#{counts[5]==0 ? '-' : 'h5'}/" +
          "#{counts[6]==0 ? '-' : 'h6'}" +
          "\n"

         buf += "           " +
              "#{counts[1]==0 ? '-' : counts[1]}/" +
               "#{counts[2]==0 ? '-' : counts[2]}/" +
               "#{counts[3]==0 ? '-' : counts[3]}/" +
               "#{counts[4]==0 ? '-' : counts[4]}/" +
               "#{counts[5]==0 ? '-' : counts[5]}/" +
               "#{counts[6]==0 ? '-' : counts[6]}" +
               "\n"

     hx.each do |marker,text|
        buf << "    (%d) %-6s" % [marker.size, marker]
        buf <<  "  "
        buf << text
        buf << "\n"
     end


     ## count anchors (aka a name)
     ##  e.g
       aname = txt.scan( /‹§  [^›]+  ›/x )

        if aname.size > 0
          buf << "\n"
          buf << "  aname #{aname.size}: "
          buf <<  aname.join( ',' )
          buf << "\n"
        end

        buf
end
