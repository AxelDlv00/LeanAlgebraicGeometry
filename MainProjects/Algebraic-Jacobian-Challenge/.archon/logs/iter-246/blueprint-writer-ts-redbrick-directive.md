# Blueprint-writer directive — Picard_TensorObjSubstrate.tex — reduction-brick block + D2' refinement

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, section `sec:tensorobj_pullback_monoidality`
(the loc-triv pullback–tensor comparison-iso section).

## Strategy context (the slice that matters)
The A.1.c critical-path substrate builds the pullback–tensor comparison iso on line bundles by
upgrading the already-built oplax comparison MAP `pullbackTensorMap` (= sheafified δ,
`\cref{lem:pullback_tensor_map}`, axiom-clean) to an isomorphism on locally-trivial pairs. The iter-245
prover landed a **reduction lemma** that is the shared entry point for all of D2'–D4': it reduces
iso-ness of the 4-fold `pullbackTensorMap` composite to iso-ness of a single sheafified presheaf
comparison. This lemma is axiom-clean and load-bearing but currently has **no blueprint block** — a
gap the lean-vs-blueprint checker flagged MAJOR.

## Task 1 — add a lemma block for the reduction brick

Insert a new `\begin{lemma}...\end{lemma}` (+ `\begin{proof}`) block in
`sec:tensorobj_pullback_monoidality`, placed AFTER the `lem:pullback_tensor_map` block
(`\label{lem:pullback_tensor_map}`, around line 3034) and BEFORE the D1' block
(`\label{lem:pullback_tensor_map_natural}`, around line 3217). Use:

- `\label{lem:isiso_pullbacktensormap_of_sheafifydelta}`
- `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}`
- `\uses{lem:pullback_tensor_map}` (and the sheafification helpers it composes through, if those have
  labels — `sheafifyTensorUnitIso`, `pullbackValIso`, `sheafificationCompPullback`).

**Statement (in project notation):** Let `f : Y ⟶ X` be a morphism of schemes and `M N : X.Modules`.
Write `φ' : (X.presheaf ⋙ forget₂) ⟶ (Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂)` for the induced
presheaf-of-modules map and `a_Y` for sheafification on `Y`. If the sheafified presheaf oplax
comparison `a_Y.map (δ (PresheafOfModules.pullback φ') M.val N.val)` is an isomorphism, then the
comparison map `pullbackTensorMap f M N : f^*(M ⊗ N) ⟶ f^*M ⊗ f^*N` is an isomorphism.

**Proof sketch:** `pullbackTensorMap` unfolds to a 4-fold composite
`p₁ ≫ a_Y.map δ ≫ p₃ ≫ p₄` where `p₁ = (sheafificationCompPullback).hom`,
`p₃ = (sheafifyTensorUnitIso).hom`, and `p₄ = a_Y.map (sheafified tensor of the two pullbackValIso)`.
Factors `p₁, p₃` are isomorphisms by construction (they are `.hom` of isos); `p₄` is an isomorphism
(the sheafification of a tensor product of the two `pullbackValIso` isomorphisms); the hypothesis
gives the middle factor `a_Y.map δ`. Composition of isomorphisms gives the result. Note this lemma is
the shared entry point: every downstream target D2'–D4' and `IsInvertible.pullback` reduces, via this
lemma, to proving the single goal `IsIso (a_Y.map δ …)`.

This block is Archon-original (project-bespoke categorical bookkeeping over the already-cited Stacks
material); no external `% SOURCE:` quote is required for it.

## Task 2 — refine the D2' block proof sketch

In the existing D2' block (`\label{lem:pullback_tensor_iso_unit}`, around line 3259), update the proof
sketch so its FIRST step explicitly applies the reduction brick
`\cref{lem:isiso_pullbacktensormap_of_sheafifydelta}`, reducing to `IsIso (a_Y.map (δ 𝟙_ 𝟙_))`; then
the unit-pair δ is handled via Mathlib oplax-monoidal unit coherence
(`Functor.OplaxMonoidal.left_unitality_hom`) which rewrites it through the presheaf unit comparison
`η (pullback φ')`; the genuine remaining content is then `IsIso (a_Y.map (η (pullback φ')))` — the
sheafification-mate bridge identifying the presheaf unit comparison with the sheaf-level
`pullbackUnitIso` (the unit-side analog of the proven `pullbackObjUnitToUnit_comp`). Add
`\uses{lem:isiso_pullbacktensormap_of_sheafifydelta}` to the D2' block.

## Out of scope
- Do NOT touch the abandoned-general-route blocks (`lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`,
  `lem:pullback_lan_decomposition`) — they stay as record-only.
- Do NOT add or remove any `\leanok` / `\mathlibok` markers (the deterministic sync owns `\leanok`).
- Do NOT restructure other sections.
