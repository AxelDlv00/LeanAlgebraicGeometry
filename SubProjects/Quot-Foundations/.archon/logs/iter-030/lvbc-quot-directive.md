# Lean vs Blueprint checker — QuotScheme (iter-030)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex
(note: this chapter `% archon:covers` both QuotScheme.lean and GradedHilbertSerre.lean)

## This iter's prover work
- Added 6 axiom-clean declarations (~L786–875) in `section OverSiteSheafEquivalence`: `overEquivalence_functor_isCocontinuous`, `overEquivalence_inverse_isCocontinuous`, `overEquivalence_inverse_isDenseSubsite`, `overEquivalence_functor_isContinuous`, `overEquivalence_inverse_isContinuous`, `overEquivalence_sheafCongr`. These form the topological/topos-theoretic layer of the gap1 slice-bridge C (`lem:over_restrict_iso`), filling an explicit Mathlib `Topology/Sheaves/Over.lean` TODO. The gap1 cone targets `overRestrictIso` (C), `isIso_fromTildeΓ_restrict_basicOpen` (P1), `section_localization_descent` (D), `isIso_fromTildeΓ_of_isQuasicoherent` (gap1) were NOT added.

Report: (a) does the Lean follow the blueprint (the 6 new decls are project-local infra with no blueprint block — confirm they are honest coverage debt, not fake statements; check no protected stub was silently re-typed); (b) is the gap1-cone chapter (the C → P1 → D → assemble decomposition) detailed enough to have guided the remaining build, or too thin? Flag any `\lean{}` pin pointing at an absent/renamed decl. Severity-tag findings.
