
##
##  fix - change errata format to plain txt!!!


class PatchDe





def on_parse( txt, name, season )
  puts "  [debug] patch on_parse #{name}, #{season}"

## quick fix
##  remove crashing note for now
##   in DFB Pokal 2019/20
   if name == 'cup' && season == Season('2019/20')    # duit2020
  note =<<TXT
NB: 1.FC Saarbrücken are the first club ever to reach the cup semifinals while
    playing at the fourth league level (they were promoted to the third level
    at the end of May following the abandonment of their regional league); they
    host their cup matches in nearby Völklingen as the Ludwigspark stadium in
    Saarbrücken is undergoing renovation
TXT
    txt = txt.sub( note, '' )
   end


   if name == '1-bundesliga' && season == Season('2003/04' )
    ##        1:0 Klose 90.
    ##  or
    ##         1:0 van Lent 5pen, 1:1 Diabang 60, 1:2 Madsen 89, 2:2 van Lent 90.
    ###  or
    ##        0:1 Micoud 10, 0:2 Klasnic 40, 0:3 Stalteri 70, 1:3 Scherz 79,
    ##         1:4 Charisteas 90.
    ##  more
    ##  1:0-2:0 Rosicky 25, 51, 3:0 Amoroso 74, 4:0 Koller 87.
    ##    1:0-2:0-3:0 Max 18, 54, 66pen.
    ##   1:0 Franca 2, 2:0-3:0 Neuville 9, 51, 4:0 Bierofka 72.
    ##    1:0 Christiansen 16, 1:1-1:2 Max 43, 63,
    ##   2:2 Christiansen 66, 3:2 Simak 71, 3:3 Vorbeck 93.

           ## wrap in []
           ##   slurp up everything to next dot.
           ##   note - use gsub (global) - replace all

=begin
           txt = txt.gsub( /  ( ^\s* )    ## 1) leading space
                              (\d:\d \b   ## 2)
                               [^.]+?
                              )
                              ( \. )      ## 3) traling space (cut-off)
                          /ixm ,
                           '\1[\2]' )
=end
          ### remove
           txt = txt.gsub( /   ^\s*
                              \d:\d \b
                               [^.]+?
                               \.
                          /ixm ,  '' )

        end

        if name == '1-bundesliga'
# quick hack: remove all  [] with  m/pen
##    [67 Kuster (Arminia) m/pen]   for now
##
##  note - some are buggy e.g.
##  [88 Cyliax (Dortmund) m/pen)  or such

             txt = txt.gsub( %r{ \[
                                     [^\]]+?   ## non-greedy
                                  m/pen
                                     [^\]]*?   ## non-greedy
                                    \]
                             }ixm, '' )

### remove all (sent off: )
###  e.g.   (sent off: Karnhof (Schalke, 40), Rehhagel
##               (Hertha, 40))
##
###  plus typo e.g
##        (ent off: Sternkopf (Bayern, 87))
            txt = txt.gsub( %r{
                                 \(
                                    s?ent [ ] off:
                                       ( [^()]+?
                                         \(
                                             [^()]+?
                                         \)
                                       )+
                                 \)
                              }ixm, '' )


        end

    txt
  end
end    # class PatchDe
