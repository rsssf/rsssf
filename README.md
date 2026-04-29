# football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) tools & scripts



## command line tools

**mirror**

use `mirror` to mirror
the complete rsssf.org website
(about 40 000+ .html pages - about 800 MB)
by following (and recording) all internal links.
the command will download (and cache all .html pages
converted to utf-8)
and build-up a local (sqlite) `mirror.db` (about 20 MB)
with the link structure (ingoing and outgoing) & titles
using a `pages` and `links` table.

> [!NOTE]
> with a one second delay between downloads
> you can expect a run of 40 000 times 2 seconds,
> that is, about 22 hours.


```
$ ruby mirror/mirror.rb
```

note - the web pages get (by default) cached in `./cache`



> [!TIP]
>
>  Use the `report` command in the `mirror` tool to generate a page &
>   diretory statistics summary. Example:
>
>      $ ruby mirror/report.rb
>
>  resulting in [`mirror/SUMMARY.md`](mirror/SUMMARY.md).
>
>
>  Or use the `export` command to export all pages to datasets
>  in the comma-separated values (.csv) format. Example:
>
>      $ ruby mirror/export.rb
>
>  resulting in `pages_html.csv`, `pages_html_404.csv`, `pages_pdf.csv`,
>  `pages_other.csv` in the `tmp-mirror/` directory.




**prepare**

use `prepare` to download (if not cached or forced)
and convert tables (in .html to .txt)

pass in a pages config (e.g.
[eng](config/eng.csv),
[de](config/de.csv),
[worldcup](config/worldcup.csv), etc.)  with a list of table files
in a comma-separated values (csv) file.



```
$ ruby prepare/prepare.rb eng
$ ruby prepare/prepare.rb --force eng       ## (force) redownload all
```

note - the web pages get (by default) cached in `./cache`
and the converted tables (in .txt ) get written
to the default outdir  `../tables`

tip: see <https://github.com/rsssf/tables> for a public online copy / mirror of converted
tables in .txt (preserving the original format).



<!--

**mkstats**

use `mkstats` for statistics and document structure for tables

pass in a pages config (e.g.
[eng](config/eng.csv),
[de](config/de.csv),
[worldcup](config/worldcup.csv), etc.) with a list of table files
in a comma-separated values (csv) file.




```
$ ruby sandbox/mkstats.rb eng
```

note - default search path for pages config is `./config`
and the default outdir for the page stats is `./config` the same.
the outname defaults to `<slug>-stats.csv`, that is, `eng`  becomes `eng-stats.csv`.


-->



**fmtfix**

use `fmtfix` to convert .txt tables (original format only in .txt)
to .txt pages (applied "autofixes" for football.txt parsing)

pass in (i) individual table files e.g
[eng2010.txt](https://github.com/rsssf/tables/blob/master/tablese/eng2010.txt) or
[34f.txt](https://github.com/rsssf/tables/blob/master/tables/30f.txt)
or (ii) a pages config (e.g.
[eng](config/eng.csv),
[de](config/de.csv),
[worldcup](config/worldcup.csv), etc.)
with a list of table files
in a comma-separated values (csv) file.


```
$ ruby fmtfix/fmtfix.rb eng2010.txt eng2011.txt
$ ruby fmtfix/fmtfix.rb eng
```


note - the outdir for pages config default to `./tmp-<slug>` e.g. `eng` becomes `./tmp-eng` and so on;  for individual table files the outdir defaults to `./tmp-fmtfix`


tip: see <https://github.com/rsssf/clubs>,
<https://github.com/rsssf/world>,
<https://github.com/rsssf/worldcup>,
for public online copies / mirrors for .txt pages with applied "autofixes"
for football.txt parsing  (look inside the /pages directories).
