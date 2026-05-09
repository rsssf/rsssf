module Rsssf
class  Prep   ## todo: find a better name e.g. BatchPrep or ??


##
## note - array of strings expected for year e.g. ['09'] etc.
def self.filter_pages( pages, year: )
   if year.size > 0

      ## convert to full years
      ##  todo/check - better use Season() std - why? why not?
      year = year.map do |item|
                        item.is_a?(String) ? Utils.year_from_name( item ) : item
                      end


      pages = pages.select do |config|
                                  page     = config['page']
                                  ## note:
                                  ##  skip/ignore pages without year
                                  page_year = Utils.year_from_name( page, fail_on_error: false )
                                  if page_year
                                    year.include?( page_year )
                                  else
                                    false
                                  end
                           end
      pages
   else
      pages
   end
end


end    # class  Prep
end    # module Rsssf