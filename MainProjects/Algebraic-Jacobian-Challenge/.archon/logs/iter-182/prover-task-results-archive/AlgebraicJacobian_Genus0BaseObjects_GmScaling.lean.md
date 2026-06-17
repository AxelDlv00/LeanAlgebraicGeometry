# AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

## Iter-182 Lane B — cross01 cocycle via Mathlib `Proj.pullbackAwayιIso`

**Status**: PARTIAL (structural advance). Build GREEN; 4 sorries (no
regression from iter-181); 0 project axioms; the new helper
`gmScalingP1_cover_intersection_X_iso` is kernel-clean.

### Sorry landscape

- L362 `gmScalingP1_chart_agreement_cross01` — structural lift via
  `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv` set up;
  residual = ring-level identity (substantive).
- L498 `gmScalingP1_collapse_at_zero` — off-target (iter-183+).
- L580 `gm_geomIrred` — off-target (Mathlib gap).
- L610 `projGm_isReduced` — off-target (Mathlib gap).

## `gmScalingP1_cover_intersection_X_iso` (new helper, ~67 LOC, axiom-clean)
### Attempt 1
- **Approach**: chain-iso construction per `analogies/intersection-ring-cross01.md`
  Recipe 1, using Mathlib's `Proj.pullbackAwayιIso` (the iter-182 analogist's
  KEY finding — Mathlib DOES ship the inner intersection iso).
- **Result**: RESOLVED axiom-clean.
- **Key lemmas used**:
  - `pullbackRightPullbackFstIso` — paste outer pullback into composition.
  - `pullback.congrHom pullback.condition rfl` — `(cover.f i) ≫ q = snd ≫ awayι_i`.
  - `Proj.pullbackAwayιIso` (Mathlib) — `pullback awayι_0 awayι_1 ≅ Spec(Away(X_0 X_1))`.
  - `pullback.map` with `asIso` — replace inner pullback source via the iso.
  - `Proj.pullbackAwayιIso_hom_SpecMap_awayMap_left` — projection identity.
  - `pullbackLeftPullbackSndIso` — bring outer pullback into `pullback q (...)`.
  - `Proj.SpecMap_awayMap_awayι` — fuse `Spec.map (awayMap _ _) ≫ awayι_0 = awayι_(X_0 X_1)`.
  - `awayι_comp_PLB_hom kbar (m := 2)` — apply standard recipe at the
    merged generator (degree 2 via `MvPolynomial.IsHomogeneous.mul`).
  - `pullbackSpecIso` — final Spec identification.
- **Structural impact**: kills the iter-181 task_result's "build project-side
  `Away_X0_X1_iso`" dead-end plan (verified WRONG by iter-182 analogist —
  Mathlib ships it at `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:258`).
  Foundation for iter-183+ closure of the cocycle.

## `gmScalingP1_chart_agreement_cross01` (cocycle body) (line 362)
### Attempt 1
- **Approach**: `apply (cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv).mp`
  to lift the goal from `pullback ((cover).f 0) ((cover).f 1) ⟶ Proj 𝒜`
  to `Spec ((Away X_0X_1) ⊗ GmRing) ⟶ Proj 𝒜`. Followed by `simp` to push
  the iso projections.
- **Result**: PARTIAL — the `cancel_epi` step works (lifts goal cleanly).
  The follow-up `simp only [gmScalingP1_cover_intersection_X_iso, Iso.trans_inv, ...]`
  unfolds the iso chain to a ~800-line composition that simp can't collapse
  without dedicated projection lemmas.
- **Blocker**: each of the 7 iso stages (`pullbackSpecIso.inv`,
  `pullback.congrHom.inv`, `pullbackRightPullbackFstIso.inv`,
  `pullbackSymmetry.inv`, `pullback.congrHom.inv`,
  `pullbackLeftPullbackSndIso.inv`, `inv (pullback.map ... pullbackAwayιIso.hom ...)`)
  needs an `inv ≫ pullback.fst/snd` projection lemma that simp can fire on.
  Mathlib provides these for each individual iso step, but the *composed*
  chain needs aggregated projection lemmas to be useful.

### Iter-183 path forward (concrete recipe)
1. **Add `@[simps]` annotation** to `gmScalingP1_cover_intersection_X_iso`
   OR prove 2 named projection lemmas:
   - `gmScalingP1_cover_intersection_X_iso_inv_comp_fst :
        iso.inv ≫ pullback.fst ((cover).f 0) ((cover).f 1) = (specific Spec.map)`
   - same for `snd`.
   Each ~30-40 LOC unfolding the chain stage by stage.
2. **Then** the cocycle closes in ~10 LOC: `apply cancel_epi iso.inv`,
   then `simp` collapses both sides to Spec.maps via the projection lemmas,
   then `Spec.map_injective` reduces to ring equality, closed by
   `Algebra.TensorProduct.tmul_mul_tmul` + `IsLocalization.Away.mul_invSelf`.

### Dead ends recorded (for iter-183+)
- Direct `rfl` / `aesop_cat` / `aesop` — fails on the iso composition.
- `simp only [...]` with the inner iso projection lemmas alone — patterns
  don't match because `gmScalingP1_cover_intersection_X_iso` is opaque to simp.
- `cancel_mono` on `awayι_(X 0 * X 1)` directly without first lifting via
  the intersection iso — both sides don't factor cleanly through `awayι_(X 0 * X 1)`
  without the iso bridging.
- Closing via over-coherence: `LHS ≫ PLB.hom = RHS ≫ PLB.hom` is easy
  via `gmScalingP1_chart_PLB_eq + pullback.condition`, but PLB.hom is not
  a mono, so doesn't conclude.

## Helper budget accounting
- Used: 1 of 2 (the new `gmScalingP1_cover_intersection_X_iso`).
- Reserved: 1 for the substantive ring-level identity (deferred iter-183
  pending the projection-lemma work above).

## Disclosure tier
- `gmScalingP1_cover_intersection_X_iso`: **TIER 1** — kernel-clean
  (only `propext`, `Classical.choice`, `Quot.sound`); no project axioms;
  no sorry in its body.
- `gmScalingP1_chart_agreement_cross01`: **TIER 3** — direct sorry, but
  preceded by a non-trivial structural reduction (`cancel_epi` against the
  new axiom-clean iso). Future iter has a concrete clear path.

## Iter-181 task_result corrections (per iter-182 analogist)
- "build project-side `Away_X0_X1_iso`" plan — **DROPPED** (Mathlib ships
  it as `Proj.pullbackAwayιIso`).
- "70-115 LOC" estimate — recalibrated: actual ~67 LOC for the intersection
  iso (built); residual cross01 body ~100-120 LOC (projection lemmas + ring
  algebra) over iter-183.

## Blueprint readiness
- `gmScalingP1_cover_intersection_X_iso` is a new helper; not in the
  blueprint chapter. Suggest blueprint-writer add a brief note pointing to
  `analogies/intersection-ring-cross01.md` Decision 2 (Mathlib API alignment).
  No `\lean{...}` pin needed (private helper, not protected).
- `gmScalingP1_chart_agreement_cross01` (and the parent
  `gmScalingP1_chart_agreement`) docstrings updated to reflect the
  iter-182 structural advance.

## Build verification
- `lake build AlgebraicJacobian.Genus0BaseObjects.GmScaling`: GREEN (10s).
- `lean_diagnostic_messages`: 4 warnings (all `declaration uses sorry`),
  no errors.
- `lean_verify gmScalingP1_cover_intersection_X_iso`: axioms = `propext,
  Classical.choice, Quot.sound` (kernel-only, no project axioms).
