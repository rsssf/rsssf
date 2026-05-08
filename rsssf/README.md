# rsssf - tools 'n' scripts for RSSSF (Rec.Sport.Soccer Statistics Foundation) archive data


* home  :: [github.com/rsssf/scripts](https://github.com/rsssf/scripts)
* bugs  :: [github.com/rsssf/scripts/issues](https://github.com/rsssf/scripts/issues)
* gem   :: [rubygems.org/gems/rsssf](https://rubygems.org/gems/rsssf)
* rdoc  :: [rubydoc.info/gems/rsssf](http://rubydoc.info/gems/rsssf)




## What's the Rec.Sport.Soccer Statistics Foundation (RSSSF)?

The RSSSF collects and offers football (soccer) league tables, match results and more
from all over the world online in plain text. Example:

```
Round 1
[May 25]
Vasco da Gama   1-0 Portuguesa
 [Carlos Tenório 47']
Vitória         2-2 Internacional
 [Maxi Biancucchi 2', Gabriel Paulista 11'; Diego Forlán 29', Fred 63']
Corinthians     1-1 Botafogo
 [Paulinho 73'; Rafael Marques 24']
[May 26]
Grêmio          2-0 Náutico         [played in Caxias do Sul-RS]
 [Zé Roberto 15', Elano 70']
Ponte Preta     0-2 São Paulo
 [Lúcio 9', Jádson 44'p]
Criciúma        3-1 Bahia
 [Matheus Ferraz 45'+1', Lins 46', João Vítor 82'; Diones 72']
Santos          0-0 Flamengo        [played in Brasília-DF]
Fluminense      2-1 Atlético/PR     [played in Macaé-RJ]
 [Rafael Sóbis 15'p, Samuel 53'; Manoel 28']
Cruzeiro        5-0 Goiás
 [Diego Souza 5', Bruno Rodrigo 30', Nílton 40',79', Borges 42']
Coritiba        2-1 Atlético/MG
 [Deivid 53', Arthur 90'+1'; Diego Tardelli 51']
```

[Find out more about the Rec.Sport.Soccer Statistics Foundation (RSSSF) »](http://www.rsssf.com)



## Usage


### Download (and Cache)  Pages

To download (and cache) pages from the world wide web use:

``` ruby
Rsssf.download_page( 'https://rsssf.org/tablese/eng2024.html',
                      encoding: 'Windows-1252' )

Rsssf.download_page( 'https://rsssf.org/tablesb/braz2024.html',
                      encoding: 'Windows-1252' )
```

Note:  Most pages on rsssf.org use the Windows-1252 (character) encoding.
To "auto-magically" convert to unicode (utf-8)
add the encoding option (default is `UTF-8`).

<!--
Or as a convenience shortcut download (pre-configured table) pages by country code (e.g `eng` - England, `es` - Spain (España), `de` - Germany (Deutschland), `br` - Brazil (Brasil) etc.)
and season (e.g. `2023/24` or `2024` etc.)

``` ruby
Rsssf.download_table( 'eng', season: '2023/24' )

Rsssf.download_table( 'br', season: '2024' )
```
-->


Note: The rsssf machinery uses a built-in (local) web cache.  All downloads get "auto-magically" cached (in `./cache/rsssf.org`).



### Working with Pages  (from .HTML to .TXT)


Note: The `RsssfPage` machinery lets you convert rsssf archive pages
from hypertext (.html) to plain text (.txt) e.g.

```
<hr>
<a href="#premier">Premier League</A><br>
<a href="#cups">Cup Tournaments</A><br>
<a href="#champ">Championship</A><br>
<a href="#first">Division 1</A><br>
<a href="#second">Division 2</A><br>
<a href="#conf">Conference</A>
<hr>
<h4><a name="premier">Premier League</A></h4>
<pre>
Final Table:

 1.Chelsea                 38  26  9  3  73-32  87  Champions
 2.Manchester City         38  24  7  7  83-38  79
 3.Arsenal                 38  22  9  7  71-36  75
...
```

will become

```
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
‹Premier League›
‹Cup Tournaments›
‹Championship›
‹Division 1›
‹Division 2›
‹Conference›
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

==== Premier League


Final Table:

 1.Chelsea                 38  26  9  3  73-32  87  Champions
 2.Manchester City         38  24  7  7  83-38  79
 3.Arsenal                 38  22  9  7  71-36  75
...
```



Tip - See the [`/tables` source repo](https://github.com/rsssf/tables)
for a public online copy / mirror of converted
tables in .txt (preserving the original "ad-hoc" formats).




To fetch pages from the world wide web for many seasons in batch use
a (tabular) datafile in the comma-separted values (.csv) format.

Step 1: List all archive pages

In `eng.csv` list all archive pages to fetch. Example:


``` csv
season,  page,                 encoding
2020/21, tablese/eng2021.html, windows-1252
2021/22, tablese/eng2022.html, windows-1252
2022/23, tablese/eng2023.html, windows-1252
2023/24, tablese/eng2024.html, windows-1252
2024/25, tablese/eng2025.html, windows-1252
```

Step 2: Download all archive pages

Use:

``` ruby
pages = read_csv( './eng.csv')

Rsssf::Prep.download_pages( pages )

## convert from .html to .txt

Rsssf::Prep.convert_pages( pages, outdir: './tables' )
```




For more and the latest news 'n' updates
incl. how to mirror the rsssf.org website (all 40000+ pages),
see the [`/scripts` source repo »](https://github.com/rsssf/scripts)


That's it.





### Preparing Archive Pages for SQL Database Imports

Note:  The rsssf machinery includes helpers
that try the best to convert the "ad-hoc" rsssf formats into
the structured Football.TXT format but expect no miracles
and fix any remaining errors "by hand"
or with your own little search & replace scripts
or why not with
the help of the latest and greatest large language models (LLMs)?


To split-up the all-in-one page and break-out sections
such as the  Premier League or FA Cup from the `eng2015.txt`, for example,
use:

``` ruby
page = RsssfPage.read_txt( './pages/eng2015.txt')

schedule = page.find_schedule( header: 'Premier League')   ## returns RsssfSchedule obj
schedule.save( './2014-15/1-premierleague.txt' )

schedule = page.find_schedule( header: 'FA Cup' )
schedule.save( './2014-15/facup.txt' )
```




Tip: See the [`/clubs` source repo](https://github.com/rsssf/clubs)
for public sample pages with format autofixes applied. Including:

- [`/england`](https://github.com/rsssf/clubs/tree/master/england)    - rsssf archive data for England - Premier League, Championship, FA Cup etc.
- [`/germany`](https://github.com/rsssf/clubs/tree/master/germany) - rsssf archive data for Germany (Deutschland) - Deutsche Bundesliga, 2. Bundesliga, 3. Liga, DFB Pokal etc.
- [`/spain`](https://github.com/rsssf/clubs/tree/master/spain)      - rsssf archive data for España (Spain) - Primera División / La Liga, Copa de Rey, etc.
- [`/austria`](https://github.com/rsssf/clubs/tree/master/austria)     - rsssf archive data for Austria (Österreich) - Österr. Bundesliga, Erste Liga, ÖFB Pokal etc.
- [`/brazil`](https://github.com/rsssf/clubs/tree/master/brazil)      - rsssf archive data for Brazil (Brasil) - Campeonato Brasileiro Série A / Brasileirão etc.
- and more



## License

The `rsssf` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
