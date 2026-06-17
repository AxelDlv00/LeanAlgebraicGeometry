# Blueprint Writer Report

## Slug
loctriv-pivot

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(section `\label{sec:tensorobj_pullback_monoidality}`,
"Pullback-monoidality: invertibility under a general scheme morphism")

## Summary
Rewrote the section so the load-bearing result is the pullback–tensor comparison
**isomorphism restricted to locally-trivial pairs** (the new
`lem:pullback_tensor_iso_loctriv`), obtained by upgrading the already-built oplax
comparison **map** `pullbackTensorMap` to an iso via a chart-chase — NOT by any general
filtered-colimit / Lan construction. The old general strong-monoidal build
(`lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`) is demoted to an explicitly
abandoned, off-critical-path record. `lem:isinvertible_pullback` is re-routed onto the
loc-triv comparison; the forward bridge `lem:isinvertible_implies_locallytrivial` is kept
off-path with a strengthened "unnecessary" NOTE.

## Changes Made
- **Revised** section-opener prose — reframed the consumer need: the relative Picard
  carrier `OnProduct = { L // IsLocallyTrivial L }` needs the comparison iso only on
  locally-trivial pairs, never general modules.
- **Revised** the "reduction" paragraph — Stacks 3-line reduction now keyed to the
  loc-triv comparison; **rewrote** the "genuine content" paragraph to **correct the
  misattribution**: the `Γ(ℙ¹,𝒪(1))=0` counterexample concerns the *lax tensorator of
  pushforward* (a right adjoint), not the *oplax δ of pullback* (a left adjoint); pullback
  provably preserves local triviality so δ IS an iso on loc-triv objects. Replaced the
  old (D1)–(D4) general-construction itemize with the new (D1′)–(D4′) chart-chase route.
- **Added lemma** `lem:pullback_tensor_map_natural` (`\lean{…pullbackTensorMap_natural}`,
  D1′) — δ_sheaf naturality in (M,N), from Mathlib `δ_natural` + sheafification naturality.
  Proof sketch: Y.
- **Added lemma** `lem:pullback_tensor_iso_unit` (`\lean{…pullbackTensorMap_unit_isIso}`,
  D2′) — δ on the unit pair (𝒪,𝒪) is an iso, via `pullbackUnitIso` + unitors + Mathlib
  `δ_comp_η_tensorHom`/`δ_comp_tensorHom_η`. Proof sketch: Y.
- **Added lemma** `lem:pullback_tensor_map_basechange` (`\lean{…pullbackTensorMap_restrict}`,
  D3′, flagged as the SOLE genuinely-new sub-step) — δ commutes with the open-immersion
  base-change square `gᵢ : f⁻¹Uᵢ → Uᵢ`, tensorator analog of the proven
  `pullbackObjUnitToUnit_comp`, via mate calculus (Mathlib `comp_δ` +
  `conjugateEquiv_pullbackComp_inv`). Proof sketch: Y.
- **Added lemma** `lem:pullback_tensor_iso_loctriv`
  (`\lean{…pullbackTensorIsoOfLocallyTrivial}`, D4′, the live target) — `f^*(M⊗N) ≅ f^*M ⊗
  f^*N` for locally-trivial M,N, by chart-chase over a common trivialising cover `{f⁻¹Uᵢ}`
  using D1′/D2′/D3′ and `isIso_of_isIso_restrict`, mirroring `IsLocallyTrivial.pullback`.
  Proof sketch: Y. Cited (Stacks `lemma-tensor-product-pullback` + `lemma-pullback-locally-free`).
- **Revised (demoted)** `lem:pullback_tensor_iso` — prepended an ABANDONED/off-path NOTE
  and an in-statement parenthetical; math/proof retained, but it is no longer on the live
  `lem:isinvertible_pullback` path (that edge was removed).
- **Revised (demoted)** `lem:pullback_lan_decomposition` — OFF-path NOTE (proven, retained
  as general infrastructure, no longer load-bearing).
- **Revised (demoted)** `lem:pullback0_tensor_iso` — ABANDONED-route NOTE (the Mathlib-scale
  filtered-colimit/⊗ interchange, never needed by the consumer).
- **Revised** `lem:presheaf_pullback_oplaxmonoidal` closing sentence — now points to the
  chart-chase of `lem:pullback_tensor_iso_loctriv` (was: `lem:isinvertible_pullback`).
- **Revised** `lem:isinvertible_implies_locallytrivial` — strengthened NOTE (off-path AND
  unnecessary; only the easy reverse `exists_tensorObj_inverse` is consumed) and corrected
  the body sentence that wrongly claimed the corollary uses the general comparison
  "without ever invoking local triviality."
- **Revised** `lem:isinvertible_pullback` — re-routed: NOTE updated; statement now carries
  `IsLocallyTrivial M`, `IsLocallyTrivial N` hypotheses; `\uses` retargeted to
  `lem:pullback_tensor_iso_loctriv` (+ `def:IsLocallyTrivial`); proof composite now uses
  `(pullback_tensor_iso_loctriv)⁻¹ ≫ f^*e ≫ pullbackUnitIso`.

## Cross-references introduced
- `lem:pullback_tensor_iso_loctriv` `\uses` → `def:IsLocallyTrivial`, `lem:pullback_tensor_map`,
  `lem:pullback_tensor_map_natural`, `lem:pullback_tensor_iso_unit`,
  `lem:pullback_tensor_map_basechange`, `lem:isiso_of_isiso_restrict`,
  `lem:tensorobj_preserves_locally_trivial`, `lem:IsLocallyTrivial_pullback` — all verified
  to exist (the last is in `Picard_LineBundlePullback.tex:163`; the rest in this chapter).
- `lem:pullback_tensor_map_basechange` `\uses` → `lem:pullbackObjUnitToUnit_comp`,
  `lem:tensorobj_restrict_iso`, `lem:pullback_tensor_map`, `lem:pullback_tensor_map_natural`.
- `lem:isinvertible_pullback` `\uses` → `lem:pullback_tensor_iso_loctriv`,
  `lem:pullback_unit_iso`, `def:scheme_modules_isinvertible`, `def:IsLocallyTrivial`.
- Removed live edge: `lem:isinvertible_pullback` no longer `\uses` `lem:pullback_tensor_iso`.

## References consulted
- `references/stacks-modules.tex` — verbatim quotes for `lem:pullback_tensor_iso_loctriv`:
  `lemma-tensor-product-pullback` (L2392–2400, reused byte-faithfully from the existing
  block) and `lemma-pullback-locally-free` (L2112–2118, newly transcribed). Also read the
  surrounding locally-free section (L2071–2191) to confirm the geometric anchor.

## Macros needed (if any)
- None. All commands used (`\Scheme`, `\cref`, `\mathcal`, `\otimes`, `\mathtt`) are already
  in use elsewhere in the chapter.

## Reference-retriever dispatches (if any)
- None. The needed source (`lemma-pullback-locally-free`) was already present in
  `references/stacks-modules.tex`.

## Notes for Plan Agent
- The new `\lean{…}` hint names (`pullbackTensorMap_natural`, `pullbackTensorMap_unit_isIso`,
  `pullbackTensorMap_restrict`, `pullbackTensorIsoOfLocallyTrivial`) are not yet in the Lean
  source; the prover may self-adjust them. blueprint-doctor will report them as unformalized
  (no `\leanok`) until the prover lands them — expected.
- `lem:isinvertible_pullback` now takes explicit `IsLocallyTrivial M`/`IsLocallyTrivial N`
  hypotheses. If the Lean declaration `IsInvertible.pullback` is protected with a frozen
  signature that does NOT carry those hypotheses, the prover/plan will need to either add the
  hypotheses to that signature or expose the loc-triv comparison `pullbackTensorIsoOfLocallyTrivial`
  as the consumer-facing API instead. (Mathematically, for a *locally-trivial* `M` one can
  always take a locally-trivial inverse `N` via the dual, so the hypotheses are satisfiable.)
- The demoted `lem:pullback_tensor_iso` block's internal proof still contains the
  "no shortcut from the bare oplax map" paragraph (true in the *general* setting). Left intact
  per "demote, do not delete the math"; the top-of-block ABANDONED NOTE scopes it.

## Strategy-modifying findings
None. The rewrite implements the iter-245 adversarial-analyst conclusion
(`analogies/invertible-loctriv-bridge.md`) faithfully; no new strategy-level issue surfaced.
