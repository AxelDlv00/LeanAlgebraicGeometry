# lean-vs-blueprint-checker — SectionGradedRing, iter-058

One file, one chapter:
- Lean: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean
- Blueprint: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

Verify bidirectionally:
- Lean→blueprint: new decls `relTensorActL`, `relTensorActR`, `relTensorProj`, `objRestrict_id`,
  `objRestrict_comp` — which have blueprint blocks / `\lean{}` pins and which are missing
  (leandag-unmatched)? `relTensorActL` appears to have a block (`def:relTensorActL`); `relTensorActR`
  and `relTensorProj` appear uncovered.
- blueprint→Lean: do existing `\lean{}` pins resolve? Is the coequalizer-rows chapter detailed
  enough to guide `relTensorProj.naturality` (the one remaining sorry, blocked on a forget₂
  CommRingCat-vs-RingCat carrier transport)?
- Flag signature mismatches / stale pins.
