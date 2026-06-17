# Blueprint-writer report — ts-redbrick (iter-246)

## Summary
Both directive tasks completed in `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`,
section `sec:tensorobj_pullback_monoidality`.

## Task 1 — reduction-brick lemma block (DONE)
Inserted a new `\begin{lemma}…\end{lemma}` + `\begin{proof}` block immediately after the
`lem:pullback_tensor_map` proof (and before the pushforward/pullback unit-coherence blocks,
well ahead of the D1' block `lem:pullback_tensor_map_natural`).

- `\label{lem:isiso_pullbacktensormap_of_sheafifydelta}`
- `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}`
- `\uses{lem:pullback_tensor_map}`

Statement: for `f : Y ⟶ X`, `M N : X.Modules`, if `a_Y.map (δ (pullback φ') M.val N.val)` is an
iso then `pullbackTensorMap f M N` is an iso. Proof sketch gives the 4-fold composite
`p₁ ≫ a_Y.map δ ≫ p₃ ≫ p₄` with `p₁ = sheafificationCompPullback.hom`,
`p₃ = sheafifyTensorUnitIso.hom`, `p₄ = a_Y.map (tensorHom of the two pullbackValIso)`; outer
three are isos unconditionally, hypothesis supplies the middle, composition closes. Notes it is
the shared entry point for D2'–D4' and `IsInvertible.pullback`. Grounded against the actual Lean
proof (`unfold pullbackTensorMap; extract_lets; IsIso.comp_isIso'` chain at L1335–1352).

Marked Archon-original (no `% SOURCE:` quote), per directive.

## Task 2 — D2' proof-sketch refinement (DONE)
In `lem:pullback_tensor_iso_unit`:
- Added `lem:isiso_pullbacktensormap_of_sheafifydelta` to both the lemma-header `\uses` and the
  proof-body `\uses`.
- Rewrote the proof sketch so the FIRST step applies the reduction brick (reducing to
  `IsIso (a_Y.map (δ 𝟙 𝟙))` via the `(SheafOfModules.unit _).val = 𝟙` defeq), then uses
  Mathlib `Functor.OplaxMonoidal.left_unitality_hom` to rewrite the unit-pair δ through the
  presheaf unit comparison `η (pullback φ')`, leaving the genuine remaining content
  `IsIso (a_Y.map (η (pullback φ')))`, closed by the sheafification-mate bridge to the
  sheaf-level `pullbackUnitIso` (the unit-side analog of the proven
  `pullbackObjUnitToUnit_comp`, `\cref{lem:pullbackObjUnitToUnit_comp}`).

## Notes / scope adherence
- The composed-through helpers `sheafifyTensorUnitIso`, `sheafificationCompPullback`,
  `pullbackValIso` have NO `\label{}` in the blueprint (referenced inline via `\mathtt{}`), so
  they could not be `\uses`-cited; only `lem:pullback_tensor_map` was citable, as the directive
  allowed ("if those have labels").
- Did not touch the abandoned-general-route blocks (`lem:pullback_tensor_iso`,
  `lem:pullback0_tensor_iso`, `lem:pullback_lan_decomposition`).
- Did not add/remove any `\leanok` / `\mathlibok` markers (deterministic sync owns `\leanok`).
- No other sections restructured.
