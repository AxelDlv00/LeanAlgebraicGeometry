# Lean-vs-blueprint check

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

This iter the prover added: `SheafOfModules.GeneratingSections.map`, `map_I`, `map_isFiniteType`
(GeneratingSections transport engine — no blueprint block yet), `gf_localGenerators_restrict`
(`lem:gf_localGenerators_restrict`, seam-1a), `gf_finiteType_affine_finite_cover_generated`
(`lem:gf_finiteType_affine_finite_cover_generated`, seam-1 assembly).

Verify bidirectionally:
- Lean→blueprint: do the two seam-1 lemmas match their blueprint statements? Note that the Lean
  `gf_finiteType_affine_finite_cover_generated` DROPPED a `[F.IsQuasicoherent]` hypothesis the prose
  may still carry — flag any mismatch.
- blueprint→Lean: is the chapter detailed enough; any fake/placeholder statements; `\lean{}` name
  mismatches; the `transport of generating sections` engine (map/map_I/map_isFiniteType) missing a block.
Report must-fix items.
