# Notes on (Character) Encodings


default on rsssf is windows 1256


some pages use unicode encoding bom (byte order mark) aka "magic bytes"



## Encodings

ASCII 7-Bit  (UTF-8 Compatible)

- check all pages if ASCII 7-Bit
  - report all non ascci-7 bit chars


Non-Unicode  (8-Bit/1-Byte) Charsets / pages:

- iso ??
- latin 1  a.k.a. window 1256 ???
- latin 5


Unicode (Multi-Byte)
- UTF-8    -  note - BOM optional  (is a two-byte non-breaking space e.g. )
- UTF-16LE   - check if BOM required?


- report all undef, invalid replace with unicode conversion






## more (old) commentary

```

  ## note: assume plain 7-bit ascii for now
  ##  -- assume rsssf uses ISO_8859_15 (updated version of ISO_8859_1)
  ###-- does NOT use utf-8 character encoding!!!

  ## note:
  ##   assume (default) to ISO 3166-15 (an updated version of ISO 3166-1) for now
  ##
  ##  other possible alternatives - try:
  ##  - Windows CP 1562  or
  ##  - ISO 3166-2  (for eastern european languages )
  ##
  ## note: german umlaut use the same code (int)
  ##    in ISO 3166-1/15 and 2 and Windows CP1562  (other chars ARE different!!!)


  # html = html.force_encoding( Encoding::ISO_8859_15 )
  # html = html.encode( Encoding::UTF_8 )    # try conversion to utf-8
```