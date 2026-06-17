# Blueprint Writer Report

## Slug
gr-glue

## Status
COMPLETE — all four coverage-debt blocks added and `def:gr_glued_scheme` expanded
(partial-state NOTE + cocycle ring identity + GlueData assembly); `leandag` clean.

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made
- **Added lemma** `\label{lem:gr_awayMulCommEquiv_comp_algebraMap}` /
  `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_algebraMap}` — the
  order-swap isomorphism lies over the base ring (`\mathrm{swap}_{x,y}` intertwines
  the two structure maps `A → A[1/(xy)]`, `A → A[1/(yx)]`). Folded immediately
  after `def:gr_away_mul_comm_equiv` as directed. Proof sketch: Y, one line via
  `IsLocalization.algEquiv.commutes`. `\uses{def:gr_away_mul_comm_equiv,
  lem:mathlib_isLocalization_algEquiv}`.
- **Added subsection** `The triple-overlap glue field \(t'\)` with three blocks:
  - **Added definition** `\label{def:gr_chart_transition'}` /
    `\lean{AlgebraicGeometry.Grassmannian.chartTransition'}` — the `t'`-field
    `U^I_J ×_{U^I} U^I_K → U^J_K ×_{U^J} U^J_I`, written as the four-arrow composite
    `ap^{IJ}.hom ≫ Spec Θ_{I,J} ≫ Spec swap ≫ ap^{JK}.inv`, with the order-swap
    reconciling `P^J_K P^J_I` (target pullback order) vs `P^J_I P^J_K` (codomain of
    `Θ_{I,J}`). `\uses{def:gr_away_pullback_iso, def:gr_cocycle_theta_ij,
    def:gr_away_mul_comm_equiv}`.
  - **Added lemma** `\label{lem:gr_chartTransition'_ringIdentity}` /
    `\lean{...chartTransition'_ringIdentity}` — the ring equation
    `Θ_{I,J} ∘ swap ∘ ι^R = ι^L ∘ θ_{I,J}` over `R^J[1/P^J_I] → S_I`.
    Proof sketch: Y — `IsLocalization` universal property reduces to the chart ring
    `R^J`, where both sides unwind to `ι^L ∘ θ̃_{I,J}` via the leg lemmas +
    `Away.lift_comp`. `\uses{def:gr_cocycle_theta_ij, def:gr_away_mul_comm_equiv,
    def:gr_away_incl_right, def:gr_away_incl_left, def:gr_transition,
    lem:gr_awayInclRight_comp_algebraMap, lem:gr_awayMulCommEquiv_comp_algebraMap,
    lem:mathlib_away_lift}`.
  - **Added lemma** `\label{lem:gr_chartTransition'_fac}` /
    `\lean{...chartTransition'_fac}` — the `t_fac` compatibility
    `pr₂ ∘ t'_{I,J,K} = t_{I,J} ∘ pr₁`. Proof sketch: Y — affine reduction to the
    ring identity via the pullback leg lemmas. Carries the `% NOTE:` documenting the
    `HasPullback` instance-diamond technique (`erw [awayPullbackIso_inv_snd]` +
    `congrArg (_ ≫ ·)` / `Iso.inv_comp_eq` defeq-inside-`exact`, not keyed
    `rw`/`simp`). `\uses{def:gr_chart_transition',
    lem:gr_chartTransition'_ringIdentity, def:gr_away_pullback_iso,
    lem:gr_awayPullbackIso_inv_fst, lem:gr_awayPullbackIso_inv_snd,
    def:gr_chart_transition}`.
- **Revised** `def:gr_glued_scheme`:
  - Extended `\uses{}` with `def:gr_chart_transition'`, `lem:gr_chartTransition'_fac`,
    `lem:gr_chartTransition'_ringIdentity`, `lem:gr_cocycle_imageMatrix_eq`.
  - Rewrote the `% NOTE:` partial-state block: triple-overlap fields `t'`, `t_fac`,
    the ring identity, and the order-swap helper are formalized & axiom-clean;
    remaining = `cocycle`, `Scheme.GlueData`, `Grassmannian.scheme`.
  - Replaced the inline `t'` paragraph with cross-references to the new blocks, and
    added the **residual cocycle obligation**: the categorical reduction (both
    internal `ap.inv ∘ ap` pairs cancel from the shared instance) leaves the ring
    identity `Φ = id` with
    `Φ := Θ_{I,J} ∘ swap_J ∘ Θ_{J,K} ∘ swap_K ∘ Θ_{K,I} ∘ swap_I`, proved as a
    rotated analogue of `lem:gr_cocycle` via `IsLocalization.ringHom_ext` on
    `powers(P^I_J P^I_K)` → chart-ring generators → reuse of
    `lem:gr_cocycle_imageMatrix_eq`. Then spelled out the `Scheme.GlueData`
    assembly (`U/V/f/t/t_id/t'/t_fac` + cocycle) and `Grassmannian.scheme :=
    (glue datum).glued`.

The `\lean{AlgebraicGeometry.Grassmannian.scheme}` pin on `def:gr_glued_scheme` is
unchanged; each new intermediate block carries its own pin.

## Cross-references introduced
All resolve (verified via `leandag build --json`: `unknown_uses: []`):
- New blocks `\uses{}` only labels already present in this chapter:
  `def:gr_away_pullback_iso`, `def:gr_cocycle_theta_ij`, `def:gr_away_mul_comm_equiv`,
  `def:gr_away_incl_left`, `def:gr_away_incl_right`, `def:gr_transition`,
  `def:gr_chart_transition`, `lem:gr_awayInclRight_comp_algebraMap`,
  `lem:gr_awayPullbackIso_inv_fst`, `lem:gr_awayPullbackIso_inv_snd`,
  `lem:gr_cocycle_imageMatrix_eq`, `lem:mathlib_away_lift`,
  `lem:mathlib_isLocalization_algEquiv`, plus the new
  `lem:gr_awayMulCommEquiv_comp_algebraMap` / `def:gr_chart_transition'` /
  `lem:gr_chartTransition'_ringIdentity`.

## leandag verification
- `leandag build --json`: `unknown_uses: []`, no conflicts.
- `leandag query --isolated --chapter Picard_GrassmannianCells`: 0 results (none of
  my new blocks isolated; the 4 project-wide isolated nodes are all in the Quot
  scheme chapter, pre-existing, untouched).
- All four new nodes matched their real Lean declarations
  (`chartTransition'`, `chartTransition'_fac`, `chartTransition'_ringIdentity`,
  `awayMulCommEquiv_comp_algebraMap`) with dep counts 3 / 6 / 8 / 2. `proved=False`
  in the DAG only reflects the absent `\leanok` marker — these are axiom-clean in
  Lean, so the deterministic `sync_leanok` phase will mark them (I did not add
  `\leanok`, per descriptor).

## References consulted
None opened this session. All four new blocks are project-bespoke (the directive
states the cocycle is a project-internal matrix computation needing no external
quote), so they carry no `% SOURCE:`/`% SOURCE QUOTE:` lines — consistent with the
existing project-local helper blocks in the same chapter
(e.g. `lem:gr_mul_submatrix_col`, `def:gr_cocycle_theta_ij`).

## Macros needed (if any)
None. All new prose uses existing macros (`\Spec`, `\cref`, standard math).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The next GR prover can now close the build straight from the blueprint: the
  `cocycle` ring identity `Φ = id` is spelled out in `def:gr_glued_scheme` with its
  proof route (rotated `cocycleCondition` via `cocycle_imageMatrix_eq`), and the
  `theGlueData`/`scheme` assembly is fully enumerated. The end-of-file HANDOFF
  comment in `GrassmannianCells.lean` already matches this prose.
- `lem:gr_separated` / `lem:gr_proper` remain blueprinted but unformalized (next
  phase, untouched as directed). They `\uses{def:gr_glued_scheme}`, so they unblock
  only once `Grassmannian.scheme` exists in Lean.

## Strategy-modifying findings
None.
