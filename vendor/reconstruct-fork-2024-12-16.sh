#!/bin/bash
# Ricostruisce lo stato di elm-interpreter-fork usato per compilare elm-foldbook v0.7 (16/12/2024).
# Base: commit pubblico bc148ee (18/12/2024). Si annullano le rinomine e gli spostamenti fatti
# nel refactoring del 18/12, usando come riferimento i nomi di public/ui.js della v0.7.
set -euo pipefail
D=${1:?cartella clone elm-interpreter-fork}
cd "$D"
git checkout -q -f bc148ee && git reset -q --hard bc148ee && git clean -qfd src
for f in $(git ls-files 'src/*.elm'); do
  perl -pi -e 's/\bDimOrDArRef\b/DimVariantRef/g; s/\bDimOrDAr\b/DimVariant/g;
               s/\bdimOrDAr(?=[A-Z])/dimVariant/g;
               s/\bCoordSingle\b/SingleCoord/g; s/\bIndexSingle\b/SingleIndex/g;
               s/\bdimVariantToDimRefString\b/dimVariantToDimVariantRef/g;
               s/\bcoordSpecifierToString\b/coordSpecToString/g;
               s/\bupdatedDimOrDArRef\b/updatedDimRef/g' "$f"
done
perl -pi -e 's/\bremoveCoord\b/deleteCoord/g' src/XModel.elm
perl -pi -e "s/TypesXModel\.emptyDataArray/XModel.emptyDataArray/" src/Kernel.elm
python3 - <<'PY'
import re
t=open('src/TypesXModel.elm').read()
m=re.search(r'^-- init data\nemptyDataArray :.*?(?=^-- usable by loc iloc)',t,re.S|re.M)
empties=m.group(0); t=t.replace(empties,'')
open('src/TypesXModel.elm','w').write(t)
s=open('src/XModelSample.elm').read()
body=s[s.index('-- ============== SAMPLE DATA'):]
x=open('src/XModel.elm').read().rstrip()+'\n\n\n'+empties+'\n\n'+body
open('src/XModel.elm','w').write(x)
PY
git rm -qf src/XModelSample.elm
perl -pi -e 's/^import XModelSample$/import XModel/; s/XModelSample\.createTestEnvValues/XModel.createTestEnvValues/' src/Eval/Module.elm
