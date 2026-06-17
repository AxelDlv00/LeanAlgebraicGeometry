# blueprint-writer directive — Picard_GrassmannianCells.tex (glue coverage + cocycle ring identity)

## Chapter
`blueprint/src/chapters/Picard_GrassmannianCells.tex`

## Why this dispatch
iter-028 landed 4 new axiom-clean glue-data declarations with NO dedicated `\lean{}` anchors (coverage
debt) and reduced the remaining `cocycle` field to a concrete ring identity. The chapter's
`def:gr_glued_scheme` is silent on its partial state and under-specifies the cocycle. Fix coverage and
detail the remaining build so the next GR prover can close it from the blueprint.

## Required edits

### 1. Add 4 coverage-debt blocks for the iter-028 helpers (all axiom-clean in-file)
- `def:gr_chart_transition'` — `\lean{AlgebraicGeometry.Grassmannian.chartTransition'}`. The `t'`
  triple-overlap field: composite `apᴵᴶ.hom ≫ Spec.map(cocycleΘIJ) ≫ Spec.map(awayMulCommEquiv …) ≫ apᴶ.inv`,
  with the order-swap `awayMulCommEquiv` reconciling `Away(P^J_K·P^J_I)` vs the `cocycleΘIJ` codomain
  `Away(P^J_I·P^J_K)`. `\uses{def:gr_away_pullback_iso, def:gr_cocycleΘIJ-or-equiv, def:gr_away_mul_comm_equiv}`
  (use the actual existing labels for `awayPullbackIso`/`cocycleΘIJ`/`awayMulCommEquiv`).
- `lem:gr_chartTransition'_fac` — `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_fac}`. The
  `t_fac` compatibility field `t' ≫ pullback.snd = pullback.fst ≫ chartTransition`. Proof sketch: both
  fibre products are affine, so reduce to the ring identity (`lem:gr_chartTransition'_ringIdentity`) via
  the leg lemmas `awayPullbackIso_inv_fst/_snd` + `Spec`-faithfulness. `% NOTE:` the `HasPullback`
  instance diamond requires `erw [awayPullbackIso_inv_snd]` + `exact congrArg`/`Iso.inv_comp_eq`
  (defeq-inside-`exact`), NOT keyed `rw`/`simp` (documented technique).
  `\uses{lem:gr_chartTransition'_ringIdentity, def:gr_chart_transition', def:gr_away_pullback_iso}`.
- `lem:gr_chartTransition'_ringIdentity` — `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_ringIdentity}`.
  The explicit equation `cocycleΘIJ.comp (awayMulCommEquiv.comp awayInclRight) = awayInclLeft.comp transitionMap`.
  Proof: `IsLocalization.ringHom_ext (powers (minorDet J I))` then the comp-algebraMap leg lemmas +
  `IsLocalization.Away.lift_comp` collapse both sides to `ι^L ∘ θ̃_{I,J}`.
- `lem:gr_awayMulCommEquiv_comp_algebraMap` — `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_algebraMap}`.
  Helper: `awayMulCommEquiv` lies over the base ring (`(awayMulCommEquiv x y).toRingHom.comp (algebraMap …) = algebraMap …`).
  Proof: `IsLocalization.algEquiv.commutes`. (Minor; fold near `def:gr_away_mul_comm_equiv` if you prefer.)

### 2. Expand `def:gr_glued_scheme` — partial-state note + cocycle ring identity + GlueData assembly
- Add a `% NOTE:` acknowledging partial progress (iter-028): `chartTransition'` (t'),
  `chartTransition'_fac` (t_fac), and the ring helpers are in Lean; remaining = `cocycle`, `theGlueData`,
  `Grassmannian.scheme`.
- Detail the **cocycle** obligation as the next prover's target (from the Lean HANDOFF block): the
  categorical reduction is solved — both internal `apXY.inv ≫ apXY.hom` pairs cancel (shared instance
  from the `chartTransition'` def), reducing the cocycle to the RING identity
  `Φ = RingHom.id (Localization.Away (minorDet I J · minorDet I K))`, where
  `Φ := cocycleΘIJ(I,J,K) ∘ swap_J ∘ cocycleΘIJ(J,K,I) ∘ swap_K ∘ cocycleΘIJ(K,I,J) ∘ swap_I`
  (`swap_X` the matching `awayMulCommEquiv`). This is a **rotated analogue of the existing `lem:gr_cocycle`**
  (`cocycleCondition`): prove by `IsLocalization.ringHom_ext (powers (minorDet I J · minorDet I K))` →
  chart-ring generators → reuse the `cocycle_imageMatrix_eq` matrix-cocycle machinery. ~30–50 LOC,
  ring-level (no diamond). Then `theGlueData` (the `Scheme.GlueData` with `U:=affineChart`,
  `V:=chartOverlap`, `f:=chartIncl`, `t:=chartTransition`, `t_id:=chartTransition_self`,
  `t':=chartTransition'`, `t_fac:=chartTransition'_fac`, `cocycle`), and
  `Grassmannian.scheme := theGlueData.glued`.
- Keep the `\lean{AlgebraicGeometry.Grassmannian.scheme}` pin on `def:gr_glued_scheme` (the final
  output); the new `def:gr_chart_transition'` etc. carry their own pins for the intermediate fields.

## Out of scope
- Do NOT add/remove `\leanok`.
- Do NOT touch the chart/transition/`lem:gr_cocycle` blocks already landed (just `\uses`-wire to them).
- `lem:gr_separated` / `lem:gr_proper` — next phase, untouched.

## References
The Grassmannian big-cell construction is Nitsure §1/§5 (`references/nitsure-hilbert-quot.*`) and
Hartshorne II.7. The cocycle is a project-bespoke matrix computation (no new verbatim quote needed).
`references/**` is in your write domain only if you find a citation genuinely missing.
