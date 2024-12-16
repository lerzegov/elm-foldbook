# Notes

## create repo version

git tag -a v0.3 -m "Version 0.3"
git push origin v0.3

# TODO test e sviluppo

- adjust show/hide hover buttons in rendered document
- view mode only datasets
- sidebar with navigation on viewed document (only sheets if filtered)

- handle values from sheet expressions
    – insert/delete text blocks via inline buttons
    – define yaml content for models and datasets
    – define yaml content for dataset views and formatting
- use latex to define calculation formulas
    - try packages like cortex https://github.com/cortex-js using MathJSON, emulates and extend latex2simpy
- define best practices to have models with plain formulas using data list functions to avoid complex expressions

# elm-markup

Parsed document structure analyzed in `/elm/lerzegov/elm-markup-fork/myDocs/Parsed.log.elm`

# MathLive gotchas

- toggle LaTeX mode in formula editor with Esc
- start LaTeX mode also with \
- select suggestion with TAB (not ENTER)
- Use Mathfield.executeCommand or MathfieldElement.executeCommand, returns true if state is dirty
- can convert asciimath to/from latex
- macros https://cortexjs.io/mathlive/guides/macros/
    - It may also be convenient to associate the macro with an inline shortcut. Inline shortcuts can be typed without having to enter the LaTeX editing mode (without having to type the \ key). To define an associated inline shortcut, use the inlineShortcuts option.
    - for macro/shorcut one must also add a latexTrigger to the latexDictionary in the compute engine: https://cortexjs.io/compute-engine/guides/latex-syntax/
    - see example in mathlive-element.ts
- mathJson generation can raise errors which disrupt also latex visualization in foldbook

## MathJson standard library

https://cortexjs.io/compute-engine/guides/standard-library/
see code in /Dropbox/cortex-js/compute-engine

- latexDictionary entries (for MathJson parsing and serializing) : src/compute-engine/latex-syntax/dictionary
    - e.g. definitions-arithmetic.ts => DEFINITIONS_ARITHMETIC: LatexDictionary
- library entries (for evaluation and compilation): src/compute-engine/library
    - e.g. arithmetic.ts => ARITHMETIC_LIBRARY: IdentifierDefinitions
    - To declare multiple functions and symbols, use the ce.declare() method with a dictionary of definitions. ce.assign is more flexible and takes polymorphic input (javascript, MathJson, latex with or without ce.parse)

      ### Adding New Definitions

      https://cortexjs.io/compute-engine/guides/augmenting/
- NB _identifierTrigger_ is a shorter way of defining a latexTrigger, nothing to do with inlineShortcuts => It is a string, usually wrapped in a LaTeX command, that will trigger the entry.For example, if identifierTrigger is floor, the LaTeX command \mathrm{floor} or \operatorname{floor} will trigger the entry. Only one of latexTrigger or identifierTrigger should be provided

## LateX symbols and commands

https://cortexjs.io/mathlive/reference/commands/

- also Chemistry Physics extensions

# TODO OLD

- unary assignments on external datasets not mapping on destination dataArray
    - work on CalcEngine.calcExpressionToXModel after getting result
- inter-dataset updates and evalFormulas triggering
- assignment of Integers to dataArrays
- handle local variables in formulas for Error in getExprDataArray from rangeNameToDef: Undefined dataset: TaxRate
    - search in other module functions before calling rangeNameToDef
- CalcEngine.Input => reinit no longer triggered because was used by viewInput (elm-ui textbox)
    - trigger it in DatasetPage event on editorElement?

# NICE TO HAVE

- change XValue to elm-interpreter Value in SpreadsheetUI

# DONE

- binary func on data arrays are order sensitive => rules for swapping dAr1 e dAr2 in calc
    - add a field Maybe Bool isExternalDataset to DataArrayValue
    - set that field in evalNonVariant provided that curDatasetRef is visible and comparable to datasetRef in rangeDef
    - then change Kernel Twonumbers swapping leftDAr and rightDAr if leftDAr.isExternalDataset and not (rightDAr.isExternalDataset)
