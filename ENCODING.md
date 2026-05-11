# Notes on (Character) Encodings


default on rsssf is windows-1252  (8-bit)



## Quick 8-bit encoding family overview


| Encoding     | Main purpose                            | Region/languages                                               |
| ------------ | --------------------------------------- | -------------------------------------------------------------- |
| ISO-8859-1   | Western European Latin alphabet         | English, French, German, Spanish, Portuguese, etc.             |
| ISO-8859-2   | Central/Eastern European Latin alphabet | Polish, Czech, Hungarian, Croatian, Romanian (older use), etc. |
| Windows-1252 | Microsoft “Western Europe” extension    | Same general region as ISO-8859-1                              |
| Windows-1250 | Microsoft “Central Europe” extension    | Same general region as ISO-8859-2                              |

The important thing is:

* **8859-1 vs 8859-2** → different letters for different languages.
* **Windows-1252 vs ISO-8859-1** → mostly the same, but Windows adds useful punctuation/symbols.
* **Windows-1250 vs ISO-8859-2** → same idea for Central European languages.



Western Latin

| Encoding     | Region                     |
| ------------ | -------------------------- |
| ISO-8859-1   | Western Europe             |
| Windows-1252 | Western Europe (Microsoft) |

Central European Latin   (incl. Polish, Czech, etc.)

| Encoding     | Region                     |
| ------------ | -------------------------- |
| ISO-8859-2   | Central Europe             |
| Windows-1250 | Central Europe (Microsoft) |

Cyrillic

| Encoding     | Region               |
| ------------ | -------------------- |
| ISO-8859-5   | Cyrillic             |
| Windows-1251 | Cyrillic (Microsoft) |


Turkish

| Encoding     | Region              |
| ------------ | ------------------- |
| ISO-8859-9   | Turkish             |
| Windows-1254 | Turkish (Microsoft) |




some pages use unicode encoding bom (byte order mark) aka "magic bytes"



## Encodings

ASCII 7-Bit  (UTF-8 Compatible)

- check all pages if ASCII 7-Bit
  - report all non ascci-7 bit chars


Non-Unicode  (8-Bit/1-Byte) Charsets / pages:

- iso ??
- latin 1  a.k.a. windows 1252 ???
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

---


#  q & a

q: charset encodings. can you explain how ISO 8859-1 and ISO 8859-2 differ? and what about windows-1250 or windows-1252?

These are all **8-bit character encodings** from the pre-Unicode era. They each define how byte values `0x00–0xFF` (0-255) map to characters, but they target different languages and regions.

## Quick overview

| Encoding     | Main purpose                            | Region/languages                                               |
| ------------ | --------------------------------------- | -------------------------------------------------------------- |
| ISO-8859-1   | Western European Latin alphabet         | English, French, German, Spanish, Portuguese, etc.             |
| ISO-8859-2   | Central/Eastern European Latin alphabet | Polish, Czech, Hungarian, Croatian, Romanian (older use), etc. |
| Windows-1252 | Microsoft “Western Europe” extension    | Same general region as ISO-8859-1                              |
| Windows-1250 | Microsoft “Central Europe” extension    | Same general region as ISO-8859-2                              |

The important thing is:

* **8859-1 vs 8859-2** → different letters for different languages.
* **Windows-1252 vs ISO-8859-1** → mostly the same, but Windows adds useful punctuation/symbols.
* **Windows-1250 vs ISO-8859-2** → same idea for Central European languages.

---

# 1. ISO-8859-1 (“Latin-1”)

ISO/IEC 8859-1

Designed for Western European languages.

It includes characters like:

* `é ñ ö ç å`
* `£ § ©`

But it **does not** include many Central/Eastern European letters.

For example:

| Character | Present in 8859-1? |
| --------- | ------------------ |
| é         | yes                |
| ñ         | yes                |
| ø         | yes                |
| ł         | no                 |
| č         | no                 |
| ő         | no                 |

So Polish or Czech text cannot be represented properly.

Example:

```text
Français déjà vu
```

works fine in 8859-1.

But:

```text
Zażółć gęślą jaźń
```

(Polish) does not.

---

# 2. ISO-8859-2 (“Latin-2”)

ISO/IEC 8859-2

Created for Central and Eastern European languages using Latin script.

It replaces some Western European characters with:

* `ą ć ę ł ń ś ź ż`
* `č ř š ž`
* `ő ű`

Example languages:

* Polish
* Czech
* Slovak
* Hungarian
* Croatian
* Slovene

Example:

```text
Příliš žluťoučký kůň
```

(Czech) works in 8859-2.

But some Western characters from 8859-1 are missing.

---

# 3. Windows-1252

Windows-1252

Microsoft’s extension of Western European Latin encodings.

This became extremely common on Windows and the web.

## Key difference from ISO-8859-1

The byte range `0x80–0x9F` is the big change.

In ISO-8859-1:

* those positions are control characters.

In Windows-1252:

* they contain printable symbols like:

| Byte | Windows-1252 |
| ---- | ------------ |
| 0x80 | €            |
| 0x91 | ‘            |
| 0x92 | ’            |
| 0x93 | “            |
| 0x94 | ”            |
| 0x95 | •            |
| 0x96 | –            |
| 0x97 | —            |

This is why copied “smart quotes” often broke old systems.

## Very important historical detail

Many webpages claimed to be:

```html
charset=ISO-8859-1
```

but were actually encoded as Windows-1252.

Browsers became tolerant and effectively treated “ISO-8859-1” as Windows-1252 in practice.

That historical mess is still visible today.

---

# 4. Windows-1250

Windows-1250

Microsoft’s Central European encoding.

Comparable relationship:

```text
ISO-8859-2  → standard version
Windows-1250 → Microsoft enhanced version
```

Supports Central European letters plus Windows punctuation additions.

Used heavily for:

* Polish
* Czech
* Slovak
* Hungarian
* Croatian

---

# Visual comparison

## Western Europe example

Text:

```text
España déjà vu
```

Works in:

* 8859-1
* 1252

Usually fine in:

* 8859-2
* 1250

---

## Central Europe example

Text:

```text
Příliš žluťoučký kůň
```

Needs:

* 8859-2
* 1250

Will fail in:

* 8859-1
* 1252

---

# Why this mattered

Before Unicode, computers could only use 256 byte values per encoding.

So different regions needed different code pages.

The same byte could mean different characters in different encodings.

Example byte:

```text
0xB9
```

might represent:

* one character in 8859-1
* another in 8859-2
* another in Windows-1250

That caused “mojibake” (garbled text).

---

# Unicode replaced all of this

Today almost everything uses:

UTF-8

UTF-8 can represent:

* Western European
* Central European
* Cyrillic
* Greek
* Arabic
* Chinese
* emoji
* everything together

without switching encodings.

---

# Practical modern advice

If you see old files:

| If text looks like                 | Try                         |
| ---------------------------------- | --------------------------- |
| Western European with weird quotes | Windows-1252                |
| Polish/Czech/Hungarian text        | Windows-1250 or ISO-8859-2  |
| Old HTML claiming ISO-8859-1       | Often actually Windows-1252 |

---

# One especially confusing point

People often say:

> “Latin-1”

but may mean:

* true ISO-8859-1
* Windows-1252
* browser default Western European text

Historically those got blurred together.

Strictly speaking:

* Latin-1 = ISO-8859-1
* Windows-1252 ≠ ISO-8859-1

even though they are very similar.


## q: what about windows 1251 or 1254?

Those are additional Microsoft “code pages” for other language groups.

* Windows-1251 → Cyrillic languages
* Windows-1254 → Turkish

They fit the same overall pattern as:

* 1252 = Western Europe
* 1250 = Central Europe

except targeted at different alphabets/languages.

---

# Windows-1251

Used for **Cyrillic scripts**.

Typical languages:

* Russian
* Bulgarian
* Serbian (Cyrillic)
* Macedonian
* Ukrainian (partially)
* Belarusian

Example text:

```text id="0f1t4n"
Привет мир
```

(“Hello world” in Russian)

1251 is fundamentally different from 1250/1252 because:

* it maps many byte positions to Cyrillic letters instead of Latin ones.

Example:

| Byte | Windows-1252 | Windows-1251 |
| ---- | ------------ | ------------ |
| `C0` | À            | А            |
| `E0` | à            | а            |

So the same bytes produce entirely different scripts.

---

# Related ISO encoding

Windows-1251 roughly corresponds to:

ISO/IEC 8859-5

But in practice:

* Windows-1251 became much more common than ISO-8859-5.

Especially on:

* Windows,
* old web pages,
* email,
* Eastern European software.

---

# Detecting Windows-1251

This is actually easier than distinguishing:

* 1250 vs 8859-2

because Cyrillic text has strong statistical signatures.

Detectors look for:

* frequent Russian letter patterns,
* common byte ranges,
* valid Cyrillic word structures.

Example:

* Russian text in UTF-8 misread as 1251 produces very recognizable mojibake.

---

# Windows-1254

Used for Turkish.

Example text:

```text id="5f98r0"
İstanbul'da çalışıyorum
```

Key Turkish letters:

* `ğ`
* `ş`
* `ı`
* `İ`

---

# Related ISO encoding

ISO/IEC 8859-9

Windows-1254 is closely related to ISO-8859-9.

Same relationship pattern again:

```text id="grrj5s"
ISO standard version
        vs
Microsoft Windows extension
```

---

# Why Turkish needed its own encoding

Turkish has special letters not present in Western European alphabets:

| Character | Meaning          |
| --------- | ---------------- |
| ı         | dotless i        |
| İ         | capital dotted I |
| ş         | s-cedilla        |
| ğ         | soft g           |

The `i/ı/İ/I` distinction is especially important in Turkish text processing.

---

# A subtle historical issue:

# Turkish “I” bugs

This became famous in programming.

In English:

```text id="4h9ovw"
i → I
```

But in Turkish:

```text id="b6v74n"
i → İ
ı → I
```

So naïve upper/lowercase logic broke Turkish software.

This problem still exists today in some codebases.

---

# Quick family overview

## Western Latin

| Encoding     | Region                     |
| ------------ | -------------------------- |
| ISO-8859-1   | Western Europe             |
| Windows-1252 | Western Europe (Microsoft) |

---

## Central European Latin

| Encoding     | Region                     |
| ------------ | -------------------------- |
| ISO-8859-2   | Central Europe             |
| Windows-1250 | Central Europe (Microsoft) |

---

## Cyrillic

| Encoding     | Region               |
| ------------ | -------------------- |
| ISO-8859-5   | Cyrillic             |
| Windows-1251 | Cyrillic (Microsoft) |

---

## Turkish

| Encoding     | Region              |
| ------------ | ------------------- |
| ISO-8859-9   | Turkish             |
| Windows-1254 | Turkish (Microsoft) |

---

# One important observation

Most Windows code pages follow this pattern:

```text id="iw8vr8"
Windows-125x
=
regional 8-bit encoding
+
extra Microsoft punctuation/symbols
```

Especially in the `0x80–0x9F` range:

* smart quotes,
* euro sign,
* em dash,
* bullets,
* etc.

That’s one reason Windows encodings became more popular than the ISO versions in practice.

---

# Modern reality

Today:

* almost all new systems use UTF-8,
* but old databases/files/email archives still contain:

  * 1250
  * 1251
  * 1252
  * 1254
  * KOI8-R
  * MacRoman
  * Shift-JIS
  * etc.

So charset detection and repair are still very relevant in data migration work.
