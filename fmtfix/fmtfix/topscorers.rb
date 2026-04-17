
##
## process/handle Topscoreres: ... to first blank line (\n\n)

=begin

Topscorers:
16 Diego Cervero                - UD Logroñés
16 Jon Altuna                   - Éibar
15 Iker Torre                   - Zamora
13 Urko Vera                    - Lemona
13 Gorka Brit                   - Real Unión
12 "Javi" Fernandez Anunziatta  - Osasuna B
12 "Jito" Juan Silvestre        - Alavés
12 Alejandro Suárez             - Palencia

-or-

Topscorers

41 "Cristiano Ronaldo" dos Santos Aveiro - Real Madrid
31 Lionel Messi                          - Barcelona
20 Sergio Agüero                         - Atlético
20 Alvaro Negredo                        - Sevilla
18 Fernando  Llorente                    - Athletic
18 "Rossi" - Giuseppe Scurto             - Villarreal
18 Roberto Soldado                       - Valencia
18 David Villa                           - Barcelona

-or   "inline"

Topscorers: Rudi BRUNNENMEIER (TSV) - 24, Timo KONIETZKA
(Dortmund) - 22, Christian MÜLLER (Köln) - 18

Topscorers: Timo KONIETZKA (TSV) - 26, Arnold SCHÜTZ
(Werder) - 20, Hannes LÖHR (Köln) and Peter GROSSER
(TSV) - 18

Topscorers: Gerd MÜLLER (Bayern) - 40, Klaus FISCHER (Schalke) and
Hans WALITZA (Bochum) - 22, Ferdinand KELLER (Hannover) - 20

-or-  ### singular

Topscorer: Danilo Pitbull (Guarany), 11 goals.

Topscorer: Bruno Rangel (Paysandu), 8 goals.
     Cascata (ABC) and Felipe Mamão (Águia), 5 goals.

-or-    top scorer/top scorers

Top scorers:
Jurcevic        (Austria Salzburg)         14 (2p)
Pfeifenberger   (Austria Salzburg)         14 (1p)

Top scorer:

Stumpf          (Linz)                     21



=end



TOPSCORERS_RE = %r{^     [ ]* Top [ ]? scorers?  
                           :?           ## note - optional colon
                         [ ]*
                          \n{0,2}       ## note - optional leading blank line!!

                        .*?             ## non-greedy - match everything until
                      (?:   \n (?= \n)    ## blank line (\n\n) or end-of-string/file
                          | \z
                      )
                    }ixm

                    
def handle_topscorers( txt, topscorers: [], opts: {} )
   txt = txt.gsub( TOPSCORERS_RE ) do |match|
                 if opts[:topscorers]
                   puts "  proc topscorers block:"
                   puts match
                 end
                 
                    ## remove everyting
                    ##  or put in comment block later with command line option/switch!! 
                    ##    ''
                    
                    ## replace with "collapsed" marker
                      topscorers << match
                    topscorers_id = topscorers.size 
                    "<!-- $topscorers#{topscorers_id}$ -->\n\n"   
                  end
   txt
end


