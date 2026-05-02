# (Conversion) Pipeline


##  mirror/mirror

mirror the website (& download/cache web pages)


- convert all web pages ALWAYS to UTF-8 encoding

all web pages get cached in (local) `./cache/rsssf.org`
and indexed in `./mirror.db`


## prepare/prepare   (from .html to .txt)

- convert all web pages from .html to .txt
- expand tabstops (length=8)

```
ruby prepare/prepare.rb at -u
```

all pages get converted to .txt and saved in the `/tables` repo



## fmtfix/fmtfix  (on .txt)

- try to get the .txt source closer to the football.txt format
  - mark round headers
  - mark date headers
  - ...
- try to fix the heading hierarchy  (starting with h2/== and title in header comment)

```
ruby fmtfix/fmtfix.rb at -u
```


## more

- generate summary pages for the .txt pages (e.g. `austria/pages/README.md`)

```
ruby sandbox/at_pages.rb
```

- split the all-in-one pages into leagues & cups (e.g. `austria/2025-26/1-bundesliga`, etcl.)


```
ruby sandbox/at_schedules.rb
```
