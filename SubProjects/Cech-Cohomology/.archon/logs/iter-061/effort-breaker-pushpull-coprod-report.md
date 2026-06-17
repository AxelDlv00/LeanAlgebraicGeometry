# Effort Breaker Report

## Slug
pushpull-coprod

## Target
`lem:pushPull_coprod_prod` (`AlgebraicGeometry.pushPull_coprod_prod`) in
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Status
COMPLETE — target re-expressed as a `\uses`-linked chain of two new leaves + the (now
induction-only) top node. All three directive steps are cut at real mathematical seams; the binary
base case (L2) is flagged below as a possible further re-break.

## Effort before → after
- target `effort_local`: 2068 → 2212 (see note: the heuristic is prose-length-proportional, so it
  does **not** drop on decomposition — `effort_total` of the cone is now 5261 = 2212 + 2456 + 593,
  i.e. the heuristic just re-sums the prose. The real win is **structural**: the monolith is now
  three independent, self-contained goals, and the hardest seam — binary disjoint-union
  decomposition vs. finite induction — is cut.)
- sub-lemmas added: 2 (the top node keeps its statement/`\lean` and becomes the induction assembly).

## Chain added (target ← induction; induction ← L2 ← L1)
- `\label{lem:isIso_modules_of_toPresheaf}` `\lean{AlgebraicGeometry.isIso_modules_of_toPresheaf}`
  — **L1, reflection wrapper.** A morphism in `X.Modules` is an iso if its image under the
  forgetful functor to the underlying presheaf of abelian groups is. `effort_local` ≈ 593 (small).
  `\uses{lem:forget_reflectsIso_mathlib}` (reuses the existing `SheafOfModules.fullyFaithfulForget`
  anchor at L3895; the presheaf-vs-sheaf inclusion is also fully faithful, noted in the proof).
- `\label{lem:pushPull_binary_coprod_prod}` `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod}`
  — **L2, binary base case.** For two legs `Y₀,Y₁ : Over X`,
  `pushPullObj F (Over.mk (coprod.desc Y₀.hom Y₁.hom)) ≅ pushPullObj F Y₀ × pushPullObj F Y₁` in
  `X.Modules`. Proof: reflect to presheaf via L1; over each open `V`, the preimage in the coproduct
  space splits as the disjoint union of the two `inl/inr` traces, so the binary disjoint-union
  decomposition gives the product of trace-sections, matched to the RHS by evaluation-preserves-
  products. `effort_local` ≈ 2456. `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf,
  lem:coprodPresheafObjIso_mathlib, lem:isProductOfDisjoint_mathlib,
  lem:evaluation_preserves_products_mathlib}`.
- Target `lem:pushPull_coprod_prod` proof **rewritten** to the finite-index induction (empty/initial
  base via L1; `Option`/cons successor step splits one index, applies L2, folds the tail by IH).
  `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf, lem:pushPull_binary_coprod_prod}`.

**Re-homing decision (per directive "out of scope"):** I kept `lem:pushPull_coprod_prod` as the top
assembly node (the explicitly-endorsed option) rather than spinning the induction into a redundant
same-statement `Fin n` lemma. `lem:pushPull_sigma_iso`'s `\uses{lem:pushPull_coprod_prod}` edge is
**unchanged and still resolves** (verified: dep_count 3, edge intact). No repoint needed.

## Graph verification
- `archon dag-query ancestors --node lem:pushPull_coprod_prod` now lists both new leaves
  (`isIso_modules_of_toPresheaf`, `pushPull_binary_coprod_prod`) plus the four Mathlib anchors
  reached transitively through L2. No broken `\uses`.
- Whole-file `\begin`/`\end` balanced (lemma 208/208, proof 154/154); both new `\label`s unique.
- `lem:pushPull_sigma_iso` unaffected (proved=True, dep_count=3).

## Still hard (re-break candidates)
- `lem:pushPull_binary_coprod_prod` (L2, ≈2456) is the substantive node and is still sizeable. If
  the prover stalls, re-break it at finer granularity into: (a) **construct** the module-linear
  comparison map into the binary product from the `inl/inr` push–pull projections; (b) the
  **geometric fact** that `q⁻¹(V)` is the disjoint union of the two coproduct-summand traces (an
  `IsOpen`/`Disjoint` preimage computation on the coproduct space); (c) the **sectionwise
  identification** combining `coprodPresheafObjIso`/`isProductOfDisjoint` with
  `evaluation_preserves_products` and the over-triangle to read off `Γ(V, pushPullObj F Yₖ)`.
- The target's **induction** is now its own concern (no binary content inline). The one piece of
  real Lean plumbing left in it is the **coproduct reassociation** `∐_{Option ι} legs ≅
  legs(none) ⊔ ∐_{ι} (legs∘some)` over `X` (a `sigmaOptionIso`-style step) that feeds L2 at each
  successor. If the induction proves heavy, extract that reassociation as a leaf
  (`lem:sigma_option_coprod_reassoc`, with `lem:isIso_modules_of_toPresheaf` for the iso check) and
  keep the target as a clean `Fintype.induction_empty_option` skeleton.

## Could not decompose (strategy items)
- None. All three mathematical steps are covered by the chain; no step was dropped or relabelled.

## References consulted
- None external. Reused two existing in-chapter `\mathlibok` anchors verbatim
  (`lem:coprodPresheafObjIso_mathlib`, `lem:isProductOfDisjoint_mathlib`) plus
  `lem:forget_reflectsIso_mathlib` and `lem:evaluation_preserves_products_mathlib`; no
  reference-retriever needed. No `% SOURCE` citation required (decomposition of an existing internal
  proof, not a source-derived block).

## Notes for dispatcher
- `\lean{}` names I assigned by convention (new build targets, do not yet exist — confirm/scaffold):
  `AlgebraicGeometry.isIso_modules_of_toPresheaf`, `AlgebraicGeometry.pushPull_binary_coprod_prod`.
- L1 is genuinely small and ready (a 2-line `reflects_iso` wrapper over the existing
  `SheafOfModules.fullyFaithfulForget` anchor) — good first leaf for the prover.
- The `effort_local` heuristic is prose-length-based and will not register a "drop" from breaking;
  judge this split by structure (three independent leaves, hardest seam cut), not by the number.
- No new macros needed; `\coprod.desc`/`\amalg`/`\times` all render with existing macros.
