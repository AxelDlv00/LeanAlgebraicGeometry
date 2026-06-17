# lean-vs-blueprint-checker — SectionGradedRing (iter-052)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

Verify bidirectionally:
- 3 new lemmas (isIso_sheafification_map_iff, localIso_toPresheaf_map_unit, isIso_sheafification_map_unit) are lean_aux with NO blueprint block — coverage debt. Confirm they are genuine reduction-chain steps toward lem:isIso_sheafification_whiskerRight_unit.
- The crux lem:isIso_sheafification_whiskerRight_unit is NOT formalized (reduced to one abelian gap J.W(toPresheaf.map(η_P ▷ Q))). Does the blueprint accurately reflect this is open, or claim more?
- tensorObjAssoc/tensorPowAdd (cor:sheafTensorObjAssoc, lem:sheafTensorPow_add) ride on the open crux — flag if blueprint marks them ready.
- `sheafification` un-privated to public def — does def:schemeModuleSheafification \lean pin now match?
Report both directions. Mark must-fix-this-iter findings.
