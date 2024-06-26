# Notes
## create repo version
git tag -a v0.1 -m "Version 0.1"
git push origin v0.1


# TODO
- handle local variables in formulas for Error in getExprDataArray from rangeNameToDef: Undefined dataset: TaxRate
    - search in othe module functions before calling rangeNameToDef
- CalcEngine.Input => reinit no longer triggered because was used by viewInput (elm-ui textbox)
    - trigger it in DatasetPage event on editorElement?