# blueprint-reviewer directive — iter-026 QUOT fast-path (scoped)

SCOPED re-review of ONE chapter only: `blueprint/src/chapters/Picard_QuotScheme.tex`. This is the
same-iter HARD-GATE fast path after a rewrite. Your earlier whole-blueprint pass this iter
(`blueprint-reviewer-iter026`) returned this chapter CONDITIONAL: the gap1 block hand-waved the
globalization. The chapter has since been rewritten using a mathlib-analogist API study
(`analogies/quot-qcoh-affine-globalization.md`). Re-verify ONLY whether the QUOT chapter now clears the
HARD GATE (complete + correct, no must-fix) for a prover dispatch on
`AlgebraicJacobian/Picard/QuotScheme.lean`.

## What changed (verify these specifically)
1. The dependency circularity is fixed. Honest order is now declared:
   **G1-core (`lem:qcoh_affine_section_localization`) → gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`) →
   general keystone (`lem:qcoh_section_localization_basicOpen`)**. Confirm the `\uses{}` edges match this
   (keystone uses gap1 + the affine engine; gap1 uses G1-core + `isLocalizedModule_tilde_restrict`;
   G1-core uses only `isLocalization_basicOpen_mathlib`). Confirm no block `\uses` a descendant.
2. **G1-core** `lem:qcoh_affine_section_localization` is the NEW concrete mathlib-build target: QC `M` on
   `Spec R` ⟹ `Γ(M,⊤) → Γ(M,D(f))` is `IsLocalizedModule (powers f)`. Its proof gives a 4-step skeleton
   (cover-refine to basic opens + finite subcover by quasi-compactness → local-tilde via
   `isLocalization_basicOpen` → flat localization of the finite sheaf-equalizer → conclude). **Judge: is
   this skeleton detailed enough for a mathlib-build prover to start, or does a step still hand-wave?**
3. **gap1** now FOLLOWS from G1-core by the cheap stalk/section assembly (basis-of-basic-opens ⟹ check
   `fromTildeΓ` iso on each `D(f)` component via `IsLocalizedModule.linearEquiv` +
   `isLocalizedModule_tilde_restrict` + `toOpen_fromTildeΓ_app`, then fully-faithful reflects iso).
   Confirm this is no longer hand-waving the global step.

## Verdict required
- HARD-GATE for `Picard_QuotScheme.tex` w.r.t. dispatching a mathlib-build prover whose target is G1-core
  `lem:qcoh_affine_section_localization`: complete + correct + no must-fix? If yes, say so explicitly. If
  a step still hand-waves, name it precisely.
- You need NOT re-audit the rest of the chapter (Quot/Grassmannian stubs, SNAP, annihilator) beyond
  confirming the rewrite did not break their wiring.
