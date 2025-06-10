# prawndown-ext

An extension of [Prawndown](https://github.com/kaspermeyer/prawndown), used for Jekyll blogs (but can be used for other stuff too).

## Usage

When using prawn, you can call the ``markdown`` method in your calls to render markdown.

``content`` is the markdown content you want to render.
``options`` is a hash/dictionary of options that can modify how the text is rendered.

```
markdown (content, options: options)
```

## Supported Markdown

Supports the following effects:
* Header
* Links
* Bold, italic, strikethrough
* Images
* Quotes

Removes the following:
* ``<iframe>`` references such as YouTube videos

### Options

This is a list of possible options you can pass to prawndown-ext.

* ``"header1_size"`` - Header 1 font size (default 28)
* ``"header2_size"`` - Header 2 font size (default 24)
* ``"header3_size"`` - Header 3 font size (default 20)
* ``"header4_size"`` - Header 4 font size (default 18)
* ``"header5_size"`` - Header 5 font size (default 16)
* ``"header6_size"`` - Header 6 font size (default 14)
* ``"quote_size"`` - Quoted text font size (default 14)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Other Stuff

Check out [PetitFelix](https://github.com/badgernested/petitfelix) which uses prawndown-ext for producing printable PDFs from markdown pages.

