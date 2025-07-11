## [Released]

## [0.1.17] - 2025-06-30

- Fixed blockquote generation.

## [0.1.16] - 2025-06-26

- Fixed bug that caused paragraphs to not render properly.

## [0.1.15] - 2025-06-24

- Added detecting tag ``<div class="output-exclude"></div>`` which will exclude its contents from the output.
- Added detecting tag ``<div class="webpage-exclude"></div>``. It will just remove the tag. It is expected from the developer of the website to set CSS for the class ``webpage-exclude`` to ``display: none;``.
- Migrated to [redcarpet](https://github.com/vmg/redcarpet/) for more accurate markdown parsing and additional features. (Documentation has not been updated yet)

## [0.1.14] - 2025-06-18

- Fixed bug that caused output error

## [0.1.13] - 2025-06-18

- Added ``image_pad``, ``horizontal_margin`` and ``vertical_margin`` for textboxes (like quotes).

## [0.1.12] - 2025-06-14

- Made it so <br> works more intuitively with ColumnBox
- Added ``image_width`` and ``image_height``

## [0.1.11] - 2025-06-13

- Minor bug fixes

## [0.1.10] - 2025-06-12

- Added support for custom image directory
- Added new page command ``<br><br>``

## [0.1.9] - 2025-06-11

- Added support for Windows new lines

## [0.1.7-8] - 2025-06-10

- Added support for line spacing.

## [0.1.6] - 2025-06-10

- Added support for custom fonts, size and spacing for quotes.

## [0.1.4-0.1.5] - 2025-06-09

- Improved how variables are replaced.

## [0.1.3] - 2025-06-09

- Fixed bugs with rendering quotes.

## [0.1.2] - 2025-06-09

- Added support for images and quotes.

## [0.1.0] - 2025-06-07

- Initial release
