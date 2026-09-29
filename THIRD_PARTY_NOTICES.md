# Third-party notices

elm-foldbook is released under the BSD 3-Clause License (see `LICENSE`).
It includes, or is compiled together with, the third-party components listed below.
All of them use permissive licenses. Full license texts are in `licenses/` or in the
package source indicated.

## Source code included in this repository

| Component | Location | Copyright | License |
|---|---|---|---|
| elm-interpreter | `vendor/elm-interpreter-fork/` (interpreter core, `generated/`, `helpers/`) | © 2023-present Leonardo Taglialegne | BSD-3-Clause (`vendor/elm-interpreter-fork/LICENSE`) |
| Elm core library sources, re-generated for the interpreter | `vendor/elm-interpreter-fork/generated/` | © Evan Czaplicki and elm/core contributors | BSD-3-Clause |
| lang-elm-markup (CodeMirror 6 language for elm-markup) | `srcjs/codemirror/lang-elm-markup.recovered.js` | © 2024 Luca Erzegovesi; based on the CodeMirror language package template © Marijn Haverbeke | MIT |

## Bundled JavaScript and assets in `public/`

| Component | Files | Copyright | License |
|---|---|---|---|
| MathLive | `public/mathlive-bundle.js`, `public/fonts/`, `public/sounds/` | © 2017-present Arno Gourdol | MIT (`licenses/mathlive-LICENSE.txt`) |
| Cortex Compute Engine | `public/mathlive-bundle.js` | © 2019 CortexJS | MIT (`licenses/compute-engine-LICENSE.txt`) |
| KaTeX fonts (distributed with MathLive) | `public/fonts/KaTeX_*` | © 2013-2020 Khan Academy and contributors | MIT (`licenses/katex-fonts-LICENSE.txt`) |
| speech-rule-engine (math maps) | `public/mathmaps/` | © Volker Sorge | Apache-2.0 (`licenses/speech-rule-engine-LICENSE.txt`) |
| CodeMirror 6, Lezer, @codemirror/legacy-modes (Elm mode) | `public/codemirror-bundle.js` | © 2018-2021 Marijn Haverbeke and others | MIT (`licenses/codemirror-LICENSE.txt`) |
| thememirror | `public/codemirror-bundle.js` | © Vadim Demedes | MIT |
| tslib | bundles | © Microsoft Corporation | 0BSD |

## Elm packages compiled into `public/ui.js`

| Package | License |
|---|---|
| elm/core, browser, html, json, parser, http, url, time, regex, random, bytes, file, virtual-dom | BSD-3-Clause |
| mdgriffith/elm-ui | BSD-3-Clause |
| lerzegov/elm-markup-fork 2.0.0 (fork of mdgriffith/elm-markup, © 2018-2019 Matthew Griffith) | BSD-3-Clause (`licenses/elm-markup-LICENSE.txt`) |
| stil4m/elm-syntax | MIT |
| the-sett/elm-pretty-printer, the-sett/elm-syntax-dsl | BSD-3-Clause |
| annaghi/dnd-list, stoeffel/editable, JoshuaHall/elm-2d-array | BSD-3-Clause |
| micahhahn/elm-safe-recursion, miniBill/elm-fast-dict, miniBill/elm-rope, miniBill/elm-unicode | BSD-3-Clause |
| elm-community/array-extra, list-extra, maybe-extra, basics-extra, random-extra | BSD-3-Clause / MIT |
| PaackEng/elm-ui-dropdown, NoRedInk/elm-string-conversions, cuducos/elm-format-number, rtfeldman/elm-hex, ryannhg/date-format, justinmimbs/date, time-extra, timezone-data, myrho/elm-round, Chadtech/elm-bool-extra, stil4m/structured-writer, avh4/elm-color | MIT / BSD-3-Clause |

The license of each Elm package is in its source distribution, downloaded by the Elm
compiler into `~/.elm/0.19.1/packages/`.

## Acknowledgements (no code copied)

- The hierarchical row/column headers of the spreadsheet grid were first prototyped on top of
  [elm-pivot-table](https://github.com/integral424/elm-pivot-table) by integral424 (BSD-3-Clause)
  and then re-implemented. Version 0.7 contains no code from that package.
- `Financial.cdf` (normal CDF) in the interpreter fork was translated from the Haskell example
  "SayBlackScholes" by Joseph Goguen (UCSD).
