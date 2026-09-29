# vendor/elm-interpreter-fork

This folder contains the calculation engine of elm-foldbook: a fork of Leonardo Taglialegne's
[elm-interpreter](https://github.com/miniBill/elm-interpreter) (BSD-3-Clause), extended by
Luca Erzegovesi with the multidimensional data model (`XModel.elm`, `TypesXModel.elm`),
range-name parsing (`XParser.elm`, `FormulaParser.elm`), financial functions
(`Financial.elm`) and array-aware evaluation (changes in `Kernel.elm`, `Eval/*.elm`,
`Types.elm`, `Environment.elm`, `Value.elm`).

The fork is developed in the public repository
[lerzegov/elm-interpreter-fork](https://github.com/lerzegov/elm-interpreter-fork)
(public since 29 July 2024). It is included here so that elm-foldbook builds without
external checkouts.

## Which state of the fork this is

elm-foldbook v0.7 (16 December 2024) was compiled against a working copy of the fork. That
working copy was committed two days later, on 18 December 2024 (commits `78f5925` and
`bc148ee`), together with a refactoring that renamed and moved some identifiers. No public
commit of the fork therefore compiles with v0.7 unchanged.

This folder reconstructs the 16 December 2024 state:

- **base:** public commit `bc148ee` (18 December 2024);
- **reverted the 18 December renames:**
  - `DimOrDAr` → `DimVariant`
  - `DimOrDArRef` → `DimVariantRef`
  - `CoordSingle` / `IndexSingle` → `SingleCoord` / `SingleIndex`
  - `dimOrDAr*` → `dimVariant*`
  - `removeCoord` → `deleteCoord`
  - `updatedDimOrDArRef` → `updatedDimRef`
- **moved back into `XModel.elm`:** the sample model from `XModelSample.elm` and the empty
  values from `TypesXModel.elm`;
- **`generated/`:** produced by the fork's elm-codegen pipeline (elm/core 1.0.5), so no Node
  toolchain is needed.

The procedure is scripted in `vendor/reconstruct-fork-2024-12-16.sh`. You can run it on a
fresh clone of the public fork, then run `yarn install && make` in that clone to regenerate `generated/`.

**Verification.** The reconstruction was checked against `public/ui.js`, the compiled
application committed in v0.7 on 16 December 2024. Elm's development build keeps a
module-qualified name for every definition, so the two builds can be compared definition by
definition:

- 1,256 of the 1,281 application definitions are byte-identical;
- 23 differ only in the order of record destructuring or in local parameter names;
- one sample-data list is built differently but holds the same 54 values;
- one function lacks a debug-logging call.

No difference affects behaviour.

The application sources in `src/` and the existing files in `srcjs/` are unchanged from v0.7.
