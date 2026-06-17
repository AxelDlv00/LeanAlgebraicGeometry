# Blueprint Reviewer Directive — p3b-realign-recheck (same-iter fast path)

## Iteration
011

## Why this re-check
Earlier this iter you cleared `Cohomology_CechHigherDirectImage.tex` (slug
`injcech-recheck`: complete + correct, HARD GATE clears). Since then a mathlib-analogist
(`analogies/p3b-presheafcech.md`) found the §"Presheaf-level Čech machinery" was mis-aligned
(bespoke `j_!` parallel-API risk) and over-engineered (routed `injective_cech_acyclic` through
enough-injectives + a Čech δ-functor that Mathlib lacks and the result does not need). A
blueprint-writer (slug `p3b-realign`) + blueprint-clean re-routed it. This is the fast-path
re-review to re-clear the gate THIS iter so prover lanes on the covered files can dispatch.

## What changed (focus your check here)
In `Cohomology_CechHigherDirectImage.tex`:
- `def:cech_free_presheaf_complex` — now realizes the shriek summand as
  `(PresheafOfModules.free).obj (yoneda U)` (no bespoke `j_!`); `K(𝒰)_•` a
  `ChainComplex X.PresheafOfModules ℕ`.
- NEW `def:section_cech_complex` (`\lean{AlgebraicGeometry.sectionCechComplex}`) — section Čech
  complex of `O_X(U)`-modules, flagged distinct from the relative `CechComplex`.
- `lem:cech_complex_hom_identification` — restated `Hom(K_•,F) ≅ Č•(𝒰,F)` against the section
  complex, proof via `freeAdjunction` + Yoneda + `evaluation`.
- `lem:cech_free_complex_quasi_iso` — proof prose updated (objectwise homology).
- `lem:injective_cech_acyclic` — proof rewritten via `CategoryTheory.Injective.injective_of_adjoint`
  + `PresheafOfModules.sheafificationAdjunction`, using only the section-complex identification +
  free resolution + injectivity. Drops enough-injectives and the δ-functor.
- NEW `\mathlibok` anchors `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`.
- REMOVED `lem:presheaf_modules_enough_injectives`, `lem:cech_delta_functor_presheaves`,
  `lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck`.

## Checks to run
1. **Formalization-readiness of the realigned subsection + `lem:injective_cech_acyclic`** —
   are the proofs complete, with every step backed by a declared sub-lemma / Mathlib anchor
   (no "developed as part of chapter content" placeholders)? Is the direct injective route
   self-contained without the removed blocks?
2. **No dangling `\uses{}`** to the four removed labels anywhere in the blueprint
   (`leandag build --json`: `unknown_uses`, `conflicts`).
3. **`\mathlibok` faithfulness** of the two new anchors (`CategoryTheory.Injective.injective_of_adjoint`,
   `PresheafOfModules.sheafificationAdjunction`) against the live Mathlib.
4. **P3 block unchanged + still cleared**: confirm `lem:cech_acyclic_affine` and
   `def:standard_affine_cover` are untouched and remain complete + correct (the P3 prover lane
   `CechAcyclic.lean` depends only on these).
5. **Non-circularity preserved**: `cech_to_cohomology_on_basis` → `affine_serre_vanishing`
   still one-directional; `injective_cech_acyclic` does not depend on `affine_serre_vanishing`.
6. Source-quote verbatim spot-check of the new/edited blocks.

## Verdict needed
Per-chapter `complete`/`correct` for `Cohomology_CechHigherDirectImage.tex`, and an explicit
HARD-GATE statement: does it CLEAR for `CechAcyclic.lean` (P3) and for the P3b presheaf-machinery
files? List any must-fix-this-iter findings.
