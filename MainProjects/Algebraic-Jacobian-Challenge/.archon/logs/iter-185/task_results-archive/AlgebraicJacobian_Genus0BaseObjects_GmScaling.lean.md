# AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

**Lane B (CHURNING post-corrective) — iter-185 outcome: FAILURE on decrement
gate (sorry count stays 4 → 4).**

Per the directive's acceptable-outcome list, this is outcome (iii). The
mandatory decrement gate 4 → ≤3 was not hit. Per the directive, this
triggers iter-186 re-dispatch of the analogist for Recipes 2 / 3 plus the
genus-0 separated-locus alternative for the chart-bridge cross-case.

## gmScalingP1_chart_agreement_cross01 (L412)

### Attempt 1 — Recipe 2 named projection lemmas via simp chain

- **Approach:** Per `analogies/gmscaling-projection-idiom.md` Recipe 2,
  add two `@[reassoc (attr := simp)]` projection lemmas
  `gmScalingP1_cover_intersection_X_iso_inv_fst` and `_snd` whose bodies
  unfold the iso chain and let `simp only` collapse all 9 `≪≫` steps
  through Mathlib's `pullbackRightPullbackFstIso_inv_fst`,
  `pullbackLeftPullbackSndIso_inv_*`, `pullback.congrHom_inv`,
  `Proj.pullbackAwayιIso_inv_*`, the project-side Recipe 1 helpers
  `pullback_map_fst_proj` / `_snd_proj` (already in file from iter-184),
  and `Proj.SpecMap_awayMap_awayι` to produce a `Spec.map` of a single
  ring map.

- **Result:** **FAILED at the very first simp step.** The Mathlib lemma
  `pullbackRightPullbackFstIso_inv_fst` matches the pattern
  `(iso).inv ≫ pullback.fst f' (pullback.fst f g)`. In our goal the
  rewrite target is
  `(iso).inv ≫ pullback.fst ((gmScalingP1_cover kbar).f 0) ((gmScalingP1_cover kbar).f 1)`.
  The required pattern needs the SECOND argument of the outer
  `pullback.fst` to be SYNTACTICALLY `pullback.fst _ _`. Here it is
  `(gmScalingP1_cover kbar).f 1`, which is DEFINITIONALLY equal to
  `pullback.fst (pullback.fst PLB.hom Gm.hom) ((cover.openCover).f 1)`
  (per `PreZeroHypercover.pullback₁_f`), but **not syntactically displayed
  as such**.

- **Dead end:** Selective `simp only [PreZeroHypercover.pullback₁_f]`
  unfolds the SECOND argument of `pullback.fst` (good) but ALSO unfolds
  the FIRST argument (= `(gmScalingP1_cover kbar).f 0`). This breaks the
  rewrite because the iso `pullbackRightPullbackFstIso (pullback.fst _ _)
  (cover.openCover.f 1) ((gmScalingP1_cover kbar).f 0)` retains
  `(gmScalingP1_cover kbar).f 0` as its `f'` argument, but the actual
  `pullback.fst`'s first argument is now `pullback.fst _ _`. The `?f'`
  metavariable cannot unify with both forms simultaneously.

- **Empirically verified (via `lean_multi_attempt`):** 35-lemma simp set
  produced 30+ "unused simp arg" warnings, indicating the chain did NOT
  fire past the initial `Iso.trans_inv` expansion. Direct `rw
  [pullbackRightPullbackFstIso_inv_fst]` failed with the same syntactic
  mismatch.

- **Lemmas found / verified:** `pullbackRightPullbackFstIso_inv_fst`,
  `pullbackRightPullbackFstIso_inv_snd_fst`,
  `pullbackRightPullbackFstIso_inv_snd_snd`,
  `pullbackLeftPullbackSndIso_inv_fst`,
  `pullbackLeftPullbackSndIso_inv_fst_snd`,
  `pullbackLeftPullbackSndIso_inv_snd_snd`,
  `pullbackSymmetry_inv_comp_fst`, `pullbackSymmetry_inv_comp_snd`,
  `pullback.congrHom_inv` (`@[simp]`),
  `Proj.pullbackAwayιIso_inv_fst`, `Proj.pullbackAwayιIso_inv_snd`,
  `Proj.SpecMap_awayMap_awayι` — all `@[reassoc (attr := simp)]` or
  `@[simp]` per the analogist verdict. NOT firing for the project's
  specific iso pattern is the unblocking gap.

### Attempt 2 — cancel_mono on Proj.awayι (X 0 * X 1)

- **Approach:** Identify both sides as factoring through
  `Proj.awayι ((MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1)`
  (the chart of the intersection `D₊(X_0 · X_1)`), then `cancel_mono`
  reduces to a ring-algebra residual.

- **Result:** **FAILED at unification.** `cancel_mono` requires both sides
  to LITERALLY END WITH the cancelled mono. The cocycle's LHS ends with
  `Proj.awayι (X 0)` (after chart 0); the RHS with `Proj.awayι (X 1)`
  (after chart 1). Both factor through `awayι (X 0 * X 1)` via
  `Proj.SpecMap_awayMap_awayι` (which says `Spec.map (awayMap g_deg hx) ≫
  awayι f f_deg hm = awayι x ...`), BUT in the forward direction. The
  backward direction `awayι (X 0 * X 1) → Spec.map (awayMap) ≫ awayι (X 0)`
  doesn't help because the goal contains `awayι (X 0)` WITHOUT a preceding
  `Spec.map (awayMap)` — the chart's `Spec.map rm_0` is a different ring
  map (built from `MvPolynomial.eval₂Hom` + `homogeneousLocalizationAwayIso`,
  not `awayMap`). Factoring `rm_0 = some_eval₂ ∘ awayMap (X 1)` would
  require constructing the chart-(X_0 · X_1) ring map as a new helper
  (banned by helper budget = 0).

- **Dead end:** without a helper for the merged-chart ring map, no
  syntactic rewrite reduces both sides to a common `Spec.map ≫ awayι
  (X 0 * X 1)` form.

### Attempt 3 — aesop_cat / pullback.hom_ext / set_option transparency

- **Approach:** Try Mathlib's category-theoretic automation (`aesop_cat`),
  pullback universal-property (`pullback.hom_ext`), and the
  `set_option backward.isDefEq.respectTransparency false` recipe from
  `analogies/pullbackspeciso-bypass.md` that closed
  `gmScalingP1_chart_PLB_eq`.

- **Result:** **FAILED.** `aesop_cat` only canceled the iso.inv
  pre-composition (a safe step) and stopped — the bare cocycle
  `pullback.fst (cover.f 0) (cover.f 1) ≫ chart 0 = pullback.snd ... ≫
  chart 1` does not yield to safe-rule chasing. `pullback.hom_ext`
  requires the codomain to BE a pullback (it's `Proj`, not a pullback).
  The `respectTransparency` recipe is specific to `pullbackSpecIso_hom_base`
  firing inside `chart_PLB_eq`'s chain and doesn't apply here.

### Attempt 4 — composing with PLB.hom to test agreement

- **Approach:** Both sides of the cocycle, composed with `PLB.hom`, agree
  (derived from `gmScalingP1_chart_PLB_eq i` + `pullback.condition` for
  `cover.f 0, cover.f 1`). PLB.hom is the structure morphism
  ProjectiveLineBarScheme → Spec kbar.

- **Result:** **FAILED as a closure mechanism.** PLB.hom is not mono
  (the structure map of P¹), so agreement after PLB.hom does not imply
  agreement before. The structural derivation is documented in the proof
  body (`hpb` + `hpl0` + `hpl1` `have` statements committed to the code).

### Saved partial progress

Per "Always save partial progress in the code", the existing
`apply (cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv).mp`
step is retained, and three new `have` lemmas are added before it:

- `hpb := Limits.pullback.condition (f := cover.f 0) (g := cover.f 1)` —
  the cocycle's pullback.condition (cover.f 0/f 1 agree on the intersection).
- `hpl0 := gmScalingP1_chart_PLB_eq kbar 0` — chart 0's over-coherence.
- `hpl1 := gmScalingP1_chart_PLB_eq kbar 1` — chart 1's over-coherence.

These together prove `LHS ≫ PLB.hom = RHS ≫ PLB.hom`. The residual sorry
captures the gap (PLB.hom is not mono).

### Concrete iter-186 next-step recommendations

1. **Re-fire analogist** with the specific finding above: the gap is
   `pullback₁_f`-unfolding vs iso elaboration shape mismatch. Possible
   resolutions:
   - (a) refactor `gmScalingP1_cover_intersection_X_iso` definition to
     **unfold the SECOND argument of `pullback.fst` BEFORE building the
     iso** — passing `pullback.fst (pullback.fst PLB.hom Gm.hom)
     (cover.openCover.f 1)` directly as the iso's source rather than
     `(cover).f 1`. (Helper budget +0, but signature-frozen check needed.)
   - (b) prove the projection lemmas by **`pullback.hom_ext` decomposition
     on the cover.f-pullback** (testing on fst and snd of the cover.f
     pullback), avoiding the chained-iso simp entirely. ~80-120 LOC each,
     budget-incompatible.
   - (c) bypass the iso projection lemmas entirely and construct the
     merged-chart ring map `chartCross_ringMap : Away (X_0 * X_1) → (Away
     (X_0 * X_1)) ⊗ GmRing` as a new helper, prove both sides factor
     through `Spec.map chartCross_ringMap ≫ awayι (X_0 * X_1)`, then
     `cancel_mono awayι (X_0 * X_1)` and reduce to ring algebra. ~80 LOC
     + 1 helper.

2. **Genus-0 separated-locus alternative** (per STRATEGY.md Open Qs):
   instead of proving the cocycle via the intersection chart, use the
   fact that the cover charts are open IMMERSIONS (mono) and the cocycle
   lives on a SEPARATED P¹ × G_m, so equality on a dense open suffices.
   Untried — analogist recommendation needed.

3. **Refactor recommendation for the iso definition**: the iso uses
   `(gmScalingP1_cover kbar).f 0` and `(gmScalingP1_cover kbar).f 1` as
   arguments. This wrapping breaks the simp-firing on the projection
   lemmas. A refactor could **inline** the underlying `pullback.fst`
   into the iso's first/second argument so the inner `pullback.fst` is
   exposed syntactically; this is the closest analog to recipe (a) above
   and is the most surgical fix.

## gmScalingP1_collapse_at_zero (L568)

NOT ATTEMPTED iter-185. The stretch goal would close this for sorry
count 4 → ≤2. Per the docstring, it requires unfolding `gmScalingP1` to
its `glueMorphisms` form, applying `Scheme.Cover.hom_ext` to reduce to a
per-chart identity, then computing the chart-1 ring map on `zeroPt`'s
global section — similar in complexity to the cocycle and likewise gated
on the same cover/chart projection idioms.

## gm_geomIrred (L650), projGm_isReduced (L680)

Mathlib-gap sorries, off-target per the directive. Untouched.

## Helper budget consumed

0 / 0 (directive's hard cap respected).
No new declarations were added to the file beyond comments and `have`
scaffolding inside `gmScalingP1_chart_agreement_cross01`.

## Sorry count

- Entering iter-185: **4** (L412, L539, L621, L651 prior to my edits).
- Exiting iter-185: **4** (L412, L568, L650, L680 — line numbers shifted
  by ~30 lines from the documentation/`have` additions).
- Decrement gate **4 → ≤3**: **FAILED** (count stays 4).

## Per the directive's failure protocol

Outcome (iii) FAILURE: iter-186 plan-phase should re-trigger analogist
for Recipes 2 / 3 AND open the genus-0 separated-locus alternative per
STRATEGY.md Open Qs. The Lane B 6-iter mandatory pivot trigger fires.
