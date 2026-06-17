# Effort Breaker Report

## Slug
l3-split

## Target
`lem:gr_bundleCocycle_transport` (`AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport`)
in `blueprint/src/chapters/Picard_GrassmannianQuot.tex`.

## Status
COMPLETE — L3 transport re-expressed as a 3-lemma chain (atom + (a) + (b)) consumed by a
thinned residual assembly.

## Effort before → after
- target `effort_local`: 2065 → 1558 (residual transport is now pure assembly)
- sub-lemmas added: 3 (one atom + the two infra pieces the prover named)
- largest single new goal: 1258 (was a single 2065 goal that also had to invent both infra pieces inline)

## Chain added (target ← {a,b} ← atom)
- `\label{lem:gr_scalarEnd_pullback}` `\lean{…Grassmannian.scalarEnd_pullback}` — **atom**:
  scalarEnd naturality under pullback. For `p : T → S`, `a ∈ Γ(S,O)`, the unit-pullback
  comparison `q = pullbackObjUnitToUnit` (= `pullbackFreeIso` at a one-element index) conjugates
  `p^*(scalarEnd a) = q⁻¹ ∘ scalarEnd(p^♯ a) ∘ q`. effort_local ≈ 888.
  `\uses{def:gr_scalarEnd, lem:gr_pullbackFreeIso, def:modules_pullbackComp}`.
- `\label{lem:gr_matrixEnd_pullback}` `\lean{…Grassmannian.matrixEnd_pullback}` — **(a)**:
  matrixEnd naturality under pullback. `p^*(matrixEnd M) = Q⁻¹ ∘ matrixEnd(p^♯ M) ∘ Q` with
  `Q = pullbackFreeIso p (Fin d)`. Proof: `p^*` left adjoint ⇒ additive ⇒ biproduct-preserving;
  per-component reduce to the atom. effort_local ≈ 1258.
  `\uses{def:gr_matrixEnd, def:gr_scalarEnd, lem:gr_scalarEnd_pullback, lem:gr_pullbackFreeIso,
  def:modules_pullbackComp}`.
- `\label{lem:gr_baseChange_bridge}` `\lean{…Grassmannian.baseChange_bridge}` — **(b)**:
  identifies the scheme-pullback base-change maps `Γ(U^I_J) → Γ(V_IJK)` (the two projections +
  triple transition `t'`) with L1's ring homs `awayInclLeft`/`awayInclRight`/`cocycleΘIJ` via
  ΓSpecIso naturality on the affine charts and the `theGlueData`/`chartTransition`-from-
  `transitionMap` assembly. effort_local ≈ 1141.
  `\uses{def:gr_transition, def:gr_glued_scheme, def:gr_the_glue_data, lem:gr_bundleCocycle_matrix,
  def:gr_cocycle_theta_ij, def:gr_away_incl_left, def:gr_away_incl_right}`.
- Target `lem:gr_bundleCocycle_transport` proof rewritten to consume the chain:
  `\uses{…, lem:gr_matrixEnd_pullback, lem:gr_baseChange_bridge, …}` added to both statement
  and proof. The proof is now a short assembly: (a) turns each transport into `matrixEnd` of a
  base-changed Cramer inverse over the bridges, (b) names those base-changed matrices as L1's
  `(X^I_J)⁻¹` etc., then L2 (`matrixToFreeIso_mul`) + L1 (`bundleCocycle_matrix`) close it.

## Still hard (re-break candidates)
- None flagged. The atom `lem:gr_scalarEnd_pullback` is the single irreducible new claim (one
  multiplication-on-the-unit-module computation across the comparison `q`); (a) and (b) are
  each one structural reduction. If the prover stalls, (b) is the likely re-break target —
  it could split into "projection ↦ awayInclLeft/Right" and "triple transition ↦ cocycleΘIJ"
  as two ΓSpecIso-naturality sub-claims.

## Could not decompose (strategy items)
- None.

## References consulted
- `informal/bundleTransition_cocycle_L3_transport.md` — prover's iter-061 roadmap; the (a)/(b)
  split and the scalarEnd-naturality atom are taken verbatim from it. (No external/library
  source; project-bespoke infra, so no `% SOURCE` lines per directive.)

## Notes for dispatcher
- `\lean{}` forward pins assigned (no Lean decl yet — prover builds this iter):
  `AlgebraicGeometry.Grassmannian.scalarEnd_pullback`, `…matrixEnd_pullback`, `…baseChange_bridge`.
  Confirm/scaffold these three names.
- No `\leanok` added (sync owns it). All `\uses` targets verified to resolve as existing labels
  (cross-chapter to `Picard_GrassmannianCells.tex` for `def:gr_transition`, `def:gr_glued_scheme`,
  `def:gr_the_glue_data`, `def:gr_cocycle_theta_ij`, `def:gr_away_incl_left/right`,
  `lem:gr_bundleCocycle_matrix`).
- `\begin`/`\end` balanced (lemma 32/32, proof 35/35); dag-query parses all three new nodes.
- No macros needed; `ΓSpecIso` / `chartTransition` / `transitionMap` referenced as inline text,
  not new labels (they are Lean-side decls, not blueprint blocks).
