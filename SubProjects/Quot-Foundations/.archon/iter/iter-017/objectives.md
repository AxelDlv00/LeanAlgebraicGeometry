# Iter 017 — Objectives detail

Three import-independent prover lanes. Per-lane attempt history accumulates here.

## Lane 1 — FBC (fine-grained): abstract-variable-legs Seam-2 refactor

- **File:** `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- **Mode:** fine-grained (CHURNING corrective; blueprint provides the atomic decomposition)
- **Targets:** `base_change_mate_fstar_reindex` (sorry 1248) → `base_change_mate_gstar_transpose` (1293)
- **Blueprint:** `chapters/Cohomology_FlatBaseChange.tex` — proof of `lem:base_change_mate_fstar_reindex`
  steps (i)/(ii)/(iii); `lem:pullbackPushforward_unit_comp` (engine, proved); Seam-3 block.
- **Recipe (3 atomic lemmas to extract):**
  - (i) abstract `base_change_mate_codomain_read`-with-variable-legs over `g' f'` + cone-leg equality
    hyps → `subst` acts on a well-typed motive (kills "motive is not type correct").
  - (ii) Γ-collapse of transparent `pushforwardComp`/`pushforwardCongr` coherences (section values =
    id / canonical transport).
  - (iii) reduce to Seam 1 via `pullbackPushforward_unit_comp` (a:=e pullbackSpecIso, b:=Spec ι_A,
    N:=tilde M); invertible `e`-unit absorbed into `Θ_tgt`; surviving `Spec ι_A`-unit = Seam 1 value →
    `base_change_mate_inner_value`.
- **Partial bar:** Seam 2 (the 3 lemmas). **OOS:** affine (1466), FBC-B (1488).
- **Constraint:** no opaque helper without the subst-able-legs restructure.

### Attempts
- (pending iter-017 prover)

## Lane 2 — GF (prove): defuse OreLocalization diamond, close L5

- **File:** `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- **Mode:** prove
- **Targets:** `exists_free_localizationAway_polynomial` L5 (sorry 1517) → L4 (516) →
  `genericFlatnessAlgebraic` (1597)
- **Blueprint:** `chapters/Picard_FlatteningStratification.tex` (`lem:gf_polynomial_core`,
  `lem:gf_noether_clear_denominators`). Recipe `analogies/gf-generic-rank-ses.md`.
- **Fix:** `gf_torsion_reindex` emits its 6th existential over canonical `OreLocalization.*` instances
  (currently `inferInstance` → `DistribMulAction`-wrapped, ~1245–1252); rebuild `htower` consistently;
  OR restate `free_localizationAway_of_away_tower`'s `hfree` over `CommRing.toCommSemiring`/`hmod2`.
  Recorded 5-line assembly then closes verbatim.
- **Partial bar:** L5 close. **OOS:** `genericFlatness` (1664).
- **Critical watch:** 2-iter OreLocalization blocker → STUCK at iter-018 if unresolved.

### Attempts
- (pending iter-017 prover)

## Lane 3 — QUOT (mathlib-build): Route-2 graded-API, first dispatch

- **File:** `AlgebraicJacobian/Picard/QuotScheme.lean`
- **Mode:** mathlib-build
- **Targets (CREATE bottom-up):** `subquotientHilb` → `subquotient_ker_coker` →
  `subquotient_degreewise_diff` → `subquotient_finite_transfer` → `subquotient_hilbertSeries_rational`
  → `(⊤,⊥)` bridge into `gradedModule_hilbertSeries_rational`.
- **Blueprint:** `chapters/Picard_QuotScheme.tex` (Route-2 `AlgebraicGeometry.GradedModule.*` blocks).
- **Reuse:** landed `IsRatHilb` toolkit + G1 (2 ambient halves) + D5.
- **HARD CONSTRAINT:** no `DirectSum.Decomposition`/`IsInternal`/`GradedDecomposition` on quotient/
  subtype carriers — every object ambient `Naux ⊓ ℳn`. isDefEq/whnf recurrence ⇒ STOP + report (no
  heartbeat raise). 4 downstream stubs (126/165/201/228) untouched.

### Attempts
- (pending iter-017 prover — first Route-2 data)
