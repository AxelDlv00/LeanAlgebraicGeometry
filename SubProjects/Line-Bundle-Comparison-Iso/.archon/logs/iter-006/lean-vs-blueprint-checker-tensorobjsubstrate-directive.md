# Lean ↔ Blueprint Checker Directive

## Slug
tensorobjsubstrate

## Lean file
/home/archon/proj/Line-Bundle-Comparison-Iso/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- `exists_tensorObj_inverse` (L690) carries a sorry by design (import-cycle gated; closes via the DUAL chain in DualInverse.lean). Do not flag its sorry as a defect.
- `pullbackTensorMap_restrict` (L2971) carries one residual sorry (Sq3/Sq4 interleave, not yet constructed). Known-open; flag only if the Lean statement diverges from the chapter prose.
- `sheafificationCompPullback_comp_natTrans` (private, ~L2469) and `sheafifyIdOf` (private abbrev, ~L2461) are new this iter and not yet in the blueprint — already tracked for blueprinting; report under unreferenced/coverage but not as a Lean defect.
