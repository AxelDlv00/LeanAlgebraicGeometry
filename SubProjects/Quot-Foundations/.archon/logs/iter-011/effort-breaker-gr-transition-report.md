# Effort Breaker Report

## Slug
gr-transition

## Target
`def:gr_transition` (`AlgebraicGeometry.Grassmannian.transitionMap`) in
`blueprint/src/chapters/Picard_GrassmannianCells.tex`.

## Status
COMPLETE — the monolithic transition `def` is re-expressed as a 7-step
matrix-algebra chain plus 5 Mathlib dependency anchors. The named target
`transitionMap` survives as the final localization-lift (step 7); all downstream
`\uses{def:gr_transition}` edges remain valid.

## Effort before → after
- target `effort_local`: **1576 → 835** (and it is now a thin
  `IsLocalization.Away.lift` wrapper over its two new deps).
- sub-lemmas/defs added: **8 project blocks + 5 Mathlib anchors = 13**.
- `dep_count` of target: 1 → 4.

## Chain added (target ← … ← leaves)
Project blocks (each with `\label`, `\lean{...}`, `% LEAN SIGNATURE`, informal
proof, `\uses`):

- `def:gr_universal_matrix` `\lean{…universalMatrix}` — the universal `d×r`
  matrix `X^I` over the chart ring (identity `I`-minor, free entries off `I`).
  effort ≈ 583. (\uses{def:gr_affine_chart})
- `def:gr_minor_det` `\lean{…minorDet}` — `P^I_J := det(X^I_J) ∈ ℤ[X^I]`, the
  localization element; notes `P^I_I = 1`. effort ≈ 692.
  (\uses{def:gr_universal_matrix})
- `def:gr_universal_minor` `\lean{…universalMinor}` — `X^I_J` base-changed to
  `R^I_J = ℤ[X^I,1/P^I_J]`. effort ≈ 441.
  (\uses{def:gr_universal_matrix, def:gr_minor_det})
- `lem:gr_minorDet_unit` `\lean{…isUnit_det_universalMinor}` (step 2) —
  `IsUnit (det X^I_J)` in `R^I_J`. effort ≈ 374.
  (\uses{def:gr_universal_minor, def:gr_minor_det, lem:mathlib_away_algebraMap_isUnit})
- `def:gr_universalMinorInv` `\lean{…universalMinorInv}` (step 3 def) —
  `(X^I_J)⁻¹`. effort ≈ 258. (\uses{def:gr_universal_minor})
- `lem:gr_universalMinorInv_identities` `\lean{…universalMinorInv_mul_cancel}`
  (step 3 lem) — the two-sided inverse identities. effort ≈ 348.
  (\uses{def:gr_universalMinorInv, lem:gr_minorDet_unit,
  lem:mathlib_nonsing_inv_mul, lem:mathlib_mul_nonsing_inv})
- `def:gr_image_matrix` `\lean{…imageMatrix}` (step 4) — `M = (X^I_J)⁻¹ X^I`.
  effort ≈ 656. (\uses{def:gr_universalMinorInv, def:gr_universal_matrix})
- `def:gr_transition_pre` `\lean{…transitionPreMap}` (step 5) — the pre-loc hom
  `ℤ[X^J] → R^I_J` via `MvPolynomial.aeval`. effort ≈ 615.
  (\uses{def:gr_image_matrix})
- `lem:gr_transition_pre_unit` `\lean{…isUnit_transitionPreMap_minorDet}`
  (step 6) — `θ̃(P^J_I) = (P^I_J)⁻¹` is a unit. effort ≈ 646.
  (\uses{def:gr_transition_pre, def:gr_minor_det,
  lem:gr_universalMinorInv_identities, lem:gr_minorDet_unit})
- **`def:gr_transition`** `\lean{…transitionMap}` (step 7, TARGET) — the
  away-localization lift. effort_local 835.
  (\uses{def:gr_transition_pre, lem:gr_transition_pre_unit, lem:mathlib_away_lift,
  def:gr_affine_chart})
- `lem:gr_transition_self` `\lean{…transitionMap_self}` — `θ_{I,I} = id`
  corollary. (\uses{def:gr_transition, def:gr_minor_det})

Mathlib anchors (`\mathlibok`, real re-exports, verified via `#check`):
- `lem:mathlib_away_algebraMap_isUnit` — `IsLocalization.Away.algebraMap_isUnit`
- `lem:mathlib_isUnit_iff_isUnit_det` — `Matrix.isUnit_iff_isUnit_det`
- `lem:mathlib_nonsing_inv_mul` — `Matrix.nonsing_inv_mul`
- `lem:mathlib_mul_nonsing_inv` — `Matrix.mul_nonsing_inv`
- `lem:mathlib_away_lift` — `IsLocalization.Away.lift`

## Repointed edges
- `lem:gr_cocycle` (statement + proof) `\uses` now adds `def:gr_image_matrix`,
  `lem:gr_universalMinorInv_identities`, `lem:gr_transition_self` — the sub-blocks
  its matrix computation `(AB)⁻¹=B⁻¹A⁻¹`, the cancellation `X^I_J(X^I_J)⁻¹=1`,
  and `θ_{I,I}=id` actually rely on. `def:gr_transition` / `def:gr_affine_chart`
  retained.
- `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` left intact (they
  depend on `def:gr_transition` as a whole, which is preserved).

## Verification
- `archon dag-query node --node def:gr_transition`: effort 1576→835, dep_count
  1→4, all 14 ancestors present with small efforts; Mathlib anchors at 0.
- `archon blueprint-doctor`: **clean — no structural or rendering findings**
  (no broken `\uses`/`\ref`, LaTeX balanced).
- All 5 Mathlib anchor names `#check`-verified against the project's Mathlib.

## Still hard (re-break candidates)
- None obviously over-large. The biggest remaining leaves are `def:gr_minor_det`
  (≈692) and `def:gr_image_matrix` (≈656) / `def:gr_transition_pre` (≈615); each
  is a single construction (a determinant of a reindexed submatrix; a matrix
  product; one `MvPolynomial.aeval`). If the prover stalls on the `J ≃ Fin d`
  column-reindexing plumbing (the only non-trivial bookkeeping, flagged in the
  `% LEAN SIGNATURE` blocks of `def:gr_universal_matrix` / `def:gr_minor_det`),
  re-dispatch the breaker to isolate the "choose an order-iso `Fin d ≃o I`"
  helper as its own atom.

## Could not decompose (strategy items)
- None. Every gap the original proof crossed is covered by a named sub-block.

## References consulted
- The Nitsure §1 SOURCE QUOTE already embedded in the original
  `def:gr_transition` (L807-L848 of
  `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`) was split
  verbatim across the sub-blocks: the `P^I_J=det(X^I_J)` / `U^I_J` fragment to
  `def:gr_minor_det` + `def:gr_universal_minor` + `lem:gr_minorDet_unit`; the
  `θ_{I,J}(X^J)=(X^I_J)⁻¹X^I` fragment to `def:gr_image_matrix` +
  `def:gr_transition_pre`; the `θ_{I,J}(P^J_I)=1/P^I_J` extension fragment to
  `lem:gr_transition_pre_unit` + `def:gr_transition`; the `X^I` definition
  fragment (L807-L821) to `def:gr_universal_matrix`; the `θ_{I,I}=id` fragment
  (L838-L848) to `lem:gr_transition_self`.

## Notes for dispatcher
- `\lean{}` names assigned by convention (confirm/scaffold in
  `AlgebraicJacobian/Picard/GrassmannianCells.lean`, namespace
  `AlgebraicGeometry.Grassmannian`): `universalMatrix`, `minorDet`,
  `universalMinor`, `isUnit_det_universalMinor`, `universalMinorInv`,
  `universalMinorInv_mul_cancel`, `imageMatrix`, `transitionPreMap`,
  `isUnit_transitionPreMap_minorDet`, `transitionMap_self`. (`transitionMap`
  unchanged.)
- The `universalMinorInv_mul_cancel` lemma is stated as a conjunction of both
  inverse identities; the prover may prefer two declarations — fine, but then
  split the `\lean{}` correspondingly (review-agent call).
- No new macros needed; all notation (`\Spec`, `\det`, etc.) already in
  `common.tex`. Did NOT add `\leanok` (sync owns it).
