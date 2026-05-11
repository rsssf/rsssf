module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??


#####
## note - line-by-line processing / matching

##
##  note allows "custom" patterns e.g.
##               header_round_re etc.

def handle_header( line,
                      header_round_re:        nil,
                      header_round_n_date_re: nil )
      ## note - returns    newline (matched header line reformatted)
      ##                    or nil (if no match!!)
      ##
       line = line.rstrip   ## expect chomp of newline "upstream" - why? why not?


      if m = (HEADER_ROUND_RE.match(line) ||
               (header_round_re && header_round_re.match(line)))
                   "▪ #{m[:round]} ▪\n"
      elsif m = HEADER_DATE_RE.match(line)
                   ## e.g. [Nov 20]
                   ## e.g. [April 1]
                   date = _norm_date( m )
                   "_ #{date} _\n"
      elsif m = HEADER_DATE_N_CITY_RE.match(line)
                   ## e.g. [Jun 3, Ferrol]
                   ## e.g. [Apr 2, Wembley]
                   ##   [Sat May 17 - at Millennium Stadium, Cardiff]
                   ##   [Sun May 25 - at Millennium Stadium, Cardiff]

                   date = _norm_date( m )

                   ##  note - check for special case
                   ##     [Dec 10, replay]
                   ##  change to  ▪ Replay ▪   _ Dec 10 _
                   if m[:city] == 'replay'
                      "▪ Replay ▪  _ #{date} _\n"
                   else
                      "_ #{date} _ @ #{m[:city]}\n"
                   end
      elsif m = HEADER_DATE_II_RE.match(line)
                    ##  note - no enclosing brackets []!!!
                    ## e.g. Nov 20 1999  or Nov 20, 1999
                    ##      Apr 1 2000   or Apr 1, 2000
                     date = _norm_date( m )
                   "_ #{date} _\n"
      elsif m = HEADER_DATE_ALT_RE.match(line)
                    ## e.g. [07-09]
                    ##      [30-05, Thaur]
                    ## date = _norm_date( m, format: 'numeric' )
                    date = _norm_date( m  )
                    buf = String.new
                    buf += "_ #{date} _"
                    buf += " @ #{m[:city]}"    if m[:city]
                    buf += "\n"
                    buf
      elsif m = (HEADER_ROUND_N_DATE_RE.match(line.strip) ||
                 (header_round_n_date_re && header_round_n_date_re.match(line.strip)))
                     date = _norm_date( m )
                   "▪ #{m[:round]} ▪  #{date}\n"
      elsif m = HEADER_ROUND_N_DATE_N_CITY_RE.match(line.strip)
                     date = _norm_date( m )
                   "▪ #{m[:round]} ▪  #{date} @ #{m[:city]}\n"
      elsif m = HEADER_ROUND_N_CITY_RE.match(line.strip)
                   "▪ #{m[:round]} ▪  @ #{m[:city]}\n"
      elsif m = HEADER_ROUND_N_CITY_N_DATE_RE.match(line.strip)
                     date = _norm_date( m )
                    ## note - reverse (rotate) date & city
                   "▪ #{m[:round]} ▪  #{date} @ #{m[:city]}\n"
       else
         nil
       end
end


####
## more helpers
def _norm_date( m, format: nil )
   ## quick fix for undefined group name reference
   m = m.named_captures.transform_keys(&:to_sym)  if m.is_a?(MatchData)

  if m[:date_list]
    _fmt_date_list(_build_date_list( m ), format: format )
  elsif m[:date_legs]
    _fmt_date_legs(_build_date_legs( m ), format: format )
  elsif m[:date_range]
    _fmt_date_range(_build_date_range( m ), format: format )
  else   ## assume m[:date]
    _fmt_date(_build_date( m ), format: format )
  end
end


end    ## class Fmtfix
end    ## module Rsssf
