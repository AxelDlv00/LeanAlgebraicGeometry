# Lean ↔ Blueprint Checker Directive

## Slug
tos-rerun

## Lean file
/home/archon/proj/Line-Bundle-Comparison-Iso/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- `exists_tensorObj_inverse` (L712) carries a sorry by design (import-cycle gated; closes via the DUAL chain in DualInverse.lean). Do not flag its sorry as a defect.
- `pullbackTensorMap_restrict` (L3144) carries one residual sorry (Sq3/Sq4 interleave, not yet constructed). Known-open; flag only if the Lean statement diverges from the chapter prose.
- `sheafificationCompPullback_comp_tail` is now CLOSED (sorry-free) this iter; `sheafificationCompPullback_comp` is end-to-end green.
- `sheafificationCompPullback_comp_natTrans` (private, ~L2469) and `sheafifyIdOf` (private abbrev, ~L2461) are new this iter and not yet in the blueprint — report under coverage/unreferenced, NOT as a Lean defect.
- A prior reviewer noted a possibly-stale `\lean{...}` hint for `tensorObjOnProduct` (declaration moved to RelPicFunctor.lean) and a label collision (two `\label`s pointing at one Lean decl). Confirm and report if real.
