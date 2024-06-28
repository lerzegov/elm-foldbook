# Notes
## create repo version
git tag -a v0.2 -m "Version 0.2"
git push origin v0.2


# TODO
- unary assignments on external datasets not mapping on destination dataArray
    - work on CalcEngine.calcExpressionToXModel after getting result
- inter-dataset updates and evalFormulas triggering
- assignment of Integers to dataArrays
- handle local variables in formulas for Error in getExprDataArray from rangeNameToDef: Undefined dataset: TaxRate
    - search in other module functions before calling rangeNameToDef
- CalcEngine.Input => reinit no longer triggered because was used by viewInput (elm-ui textbox)
    - trigger it in DatasetPage event on editorElement?

# NICE TO HAVE
- change XValue to interpreter Value in SpreadsheetUI

# DONE
- binary func on data arrays are order sensitive => rules for swapping dAr1 e dAr2 in calc
    - add a field Maybe Bool isExternalDataset to DataArrayValue
    - set that field in evalNonVariant provided that curDatasetRef is visible and comparable to datasetRef in rangeDef
    - then change Kernel Twonumbers swapping leftDAr and rightDAr if leftDAr.isExternalDataset and not (rightDAr.isExternalDataset)