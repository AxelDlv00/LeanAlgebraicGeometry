# Iter-011 objectives (dispatched)

Two parallel `mathlib-build` prover lanes. Both files compile green; both blueprint-gated
complete+correct (`blueprint-reviewer-p3b-realign-recheck`).

## Lane 1 — P3 — `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Target: close `CechAcyclic.affine` (re-signed to the spanning bundle this iter).
- Build L1 (`Γ(D(s_σ))=M_{s_σ}`) + L3 (localised module homotopy), apply L2
  (`exact_of_isLocalized_span`, spanning elements `Away (s_r)`), then close.
- Recipe: `analogies/p3-localisation.md`. Blueprint: `lem:cech_acyclic_affine`,
  `def:standard_affine_cover`.

## Lane 2 — P3b — `AlgebraicJacobian/Cohomology/PresheafCech.lean`
- Build bottom-up: `sectionCechComplex` → `cechFreePresheafComplex` (free(yoneda), NO `j_!`) →
  `cechComplex_hom_identification` → `cechFreeComplex_quasiIso` → `injective_cech_acyclic`
  (via `Injective.injective_of_adjoint` + `sheafificationAdjunction`).
- Recipe: `analogies/p3b-presheafcech.md`. Blueprint §"Presheaf-level Čech machinery".

## Subagents dispatched this iter
- blueprint-writer `p3b-realign` (realign P3b machinery) → COMPLETE
- blueprint-clean `p3b-realign` → COMPLETE (no changes needed)
- blueprint-reviewer `p3b-realign-recheck` → P3 + P3b machinery HARD GATE CLEAR
- lean-scaffolder `p3-split` (CechAcyclic.lean, re-signed) → COMPLETE, build green
- lean-scaffolder `p3b-skeleton` (PresheafCech.lean roadmap) → COMPLETE, build green
- mathlib-analogist `p5a-01xj` (P5a design for next iter) → COMPLETE (NEEDS_GAP_FILL)
- (earlier in session: blueprint-reviewer `iter011`, strategy-critic `iter011`, blueprint-writer
  `injcech`, blueprint-clean `injcech`, blueprint-reviewer `injcech-recheck`, mathlib-analogist
  `p3b-presheafcech`)

## Deferred
- P5a/01XJ lane (`HigherDirectImagePresheaf.lean`): blueprint realign per `analogies/p5a-01xj.md`
  then scaffold next iter (third independent lane).
