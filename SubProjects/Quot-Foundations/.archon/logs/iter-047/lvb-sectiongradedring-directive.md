# lean-vs-blueprint-checker — SectionGradedRing

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

Verify bidirectionally:
- Lean→blueprint: do tensorObj/tensorPow/moduleTensorPow match def:sheafTensorObj / def:sheafTensorPow / def:sheafModuleTwist statements? Any fake/placeholder/signature mismatch?
- blueprint→Lean: is lem:sheafTensorPow_add (\lean{...tensorPowAdd}) correctly UNformalized (decl absent this iter)? Flag if its \leanok is wrongly set.
- Coverage: 8 new helper decls (sheafification, MonoidalPresheaf, unitModule, sheafificationCounitIso, tensorObjUnitIso, tensorObjRightUnitor, tensorBraiding, tensorPow_zero/succ, moduleTensorPow_zero) have NO blueprint block — report as coverage debt.
- Is the chapter detailed enough to have guided this formalization?
