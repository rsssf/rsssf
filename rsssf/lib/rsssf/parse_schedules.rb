

##
## todo/check - find a better name
##       rename to parse_sections/leagues/??? - why? why not?
def parse_schedules( txt )
   rows = parse_csv( txt )
   ## transform seasons column to seasons objects
   rows.each do |row|
      if row['seasons'] && !row['seasons'].empty?
        row['seasons'] = Season.parse_line( row['seasons'] )
      end
   end
   rows
end
def read_schedules( path )  parse_schedules( read_text(path)); end




__END__

############
## sample usage

configs = parse_schedules( <<TXT )

header,       seasons,             basename,      title
Bundesliga,   2010/11..2025/26,    1-bundesliga,  Austria | Bundesliga {season}
ÖFB Cup,      2010/11..2025/26,    cup,           Austria | ÖFB Cup {season}

TXT

## pp configs
