# Mathlib Analogist Report

## Mode
api-alignment

## Slug
pullbackspeciso-bypass

## Iteration
180

## Question

Concrete options for bypassing the `Algebra.compHom`-based instance
synthesis heartbeat sink at the `pullbackSpecIso_hom_base` application
site in `gmScalingP1_chart_PLB_eq`. The chart-bridge body recipe has
been stuck for 5 iters (iter-175 → iter-179) at the 5th of 6 recipe
steps. Ranked by Mathlib-idiom cleanness across 5 sub-options.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) Project-side wrapper `pullbackSpecIso_hom_base'` | NOT_VIABLE (shifts the sink) | informational |
| (2) `pullback.mapIso` direct construction | NOT_VIABLE (no shorter chain exists) | informational |
| (3) Replace `Algebra.compHom` with another instance form | NOT_VIABLE (high cost, wrong root cause) | informational |
| (4) `set_option backward.isDefEq.respectTransparency false` | ALIGN_WITH_MATHLIB | critical |
| (5) Alternative Mathlib bridge (`fst_of_hom`, Spec-pullback symmetry) | NOT_VIABLE (none exists) | informational |

## Must-fix-this-iter

- **Decision 4**: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:213`
  (`gmScalingP1_chart_PLB_eq`) should add
  `set_option backward.isDefEq.respectTransparency false in` immediately
  above the lemma declaration. This is the **canonical Mathlib idiom for
  Algebra.compHom-chain-driven defeq sinks in pullback constructions**.
  Without it, the iter-180 prover Lane A will continue to hit the
  200k-heartbeat `isDefEq` timeout on `pullbackSpecIso_hom_base`. The
  current TEMP axioms `gmScalingP1_chart_data_temp` and
  `gmScalingP1_collapse_at_zero_temp` (admitted iter-177) remain alive
  until this fix lands.

## Empirical verification

Verified via `lean_multi_attempt` at line 250 of
`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (the sticky `sorry`
site). The crucial snippet:

```lean
set_option backward.isDefEq.respectTransparency false in
  (unfold gmScalingP1_cover_X_iso; simp only [Iso.trans_hom, Category.assoc,
    pullbackSpecIso_hom_base])
```

produces the goal:

```
... ≫
  (pullback.congrHom ⋯ ⋯).hom ≫
    pullback.fst
      (Spec.map (CommRingCat.ofHom (algebraMap kbar (HomogeneousLocalization.Away ... (![X 0, X 1] i)))))
      (Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))) ≫
    Spec.map (CommRingCat.ofHom (algebraMap kbar (HomogeneousLocalization.Away ... (![X 0, X 1] i)))) =
  (gmScalingP1_cover kbar).f i ≫ (ProjectiveLineBar kbar ⊗ Gm kbar).hom
```

I.e., `pullbackSpecIso_hom_base` HAS FIRED and rewritten the LHS into
the canonical `pullback.fst _ _ ≫ Spec.map (algMap kbar Away_i)` form.

**WITHOUT the option**, the SAME simp lemma is reported "unused" (= LHS
pattern not matched), producing the unchanged goal — the same failure
mode as iter-179 Attempts 4 and 5.

A subsequent simp with `[pullback.congrHom_hom, pullback.lift_fst_assoc,
Category.id_comp]` further collapses to:

```
(pullbackSymmetry ...).hom ≫
  (pullbackRightPullbackFstIso ...).hom ≫
    pullback.fst (Proj.awayι (![X 0, X 1] i) ⋯ ⋯ ≫ (ProjectiveLineBar kbar).hom) (Gm kbar).hom ≫
    Spec.map (CommRingCat.ofHom (algebraMap kbar ...)) = ...
```

i.e. STAGE-(1) of the residual cleanup (per
`analogies/pullbackspeciso-bypass.md` recommendation) closes
mechanically. STAGES (2)-(4) need the cover-bridge-uniform-i
`pullbackRightPullbackFstIso_hom_fst_assoc` +
`pullbackSymmetry_hom_comp_snd_assoc` to fire — these still report
"unused" in the verification because they need a `change` or a
`Scheme.AffineOpenCover.openCover_f` simp to align
`(cover).openCover.f i` with `Proj.awayι (![X 0, X 1] i) ...`. The
`respectTransparency false` option SHOULD allow `simp` to see through
this defeq, but a backup `change` is documented in the recipe file.

## Informational

- **Decision 1** (`pullbackSpecIso_hom_base'` wrapper): buildable in
  ~6 LOC (analogous to existing `pullbackSpecIso_hom_fst'` at
  Mathlib `Pullbacks.lean:750-752`), but the wrapper's proof or the
  call-site `hφ` discharge re-triggers the same defeq sink. SHIFTS the
  problem rather than eliminating it. Skip.

- **Decision 2** (`pullback.mapIso` direct construction): no separate
  `pullback.mapIso` exists — `pullback.congrHom` IS the iso form of
  `pullback.map`. The 4-layer iso chain in `gmScalingP1_cover_X_iso`
  matches the EXACT Mathlib precedent
  `OpenCover.pullbackCoverAffineRefinementObjIso`
  (`Mathlib.AlgebraicGeometry.Cover.Open:160-166`); shortening it isn't
  possible without re-rolling all four transformations inline (same
  total algebra burden, plus loss of named intermediates).

- **Decision 3** (algebra-instance refactor): `algebraKbarAway` is
  Mathlib-aligned (`Algebra.compHom` is the canonical lift for
  `Algebra kbar (Away)` given Mathlib only ships
  `Algebra ↥(𝒜 0) (Away)`). A minimal `lean_run_code` repro shows the
  defeq sink is NOT primarily triggered by `compHom` itself — it fires
  only when the goal is BURIED in the 4-layer iso chain. Refactoring
  away `compHom` would break ~12 downstream sites for no benefit.

- **Decision 5** (alternative Mathlib bridge): searched
  `pullback.fst_of_hom`, `pullback.snd_of_hom`, Spec-pullback symmetry
  variants. None exists. The closest analogue
  `isPullback_SpecMap_pushout` (`Pullbacks.lean:776-780`) doesn't bypass
  the algebra-on-tensor-product instance synthesis when reduced to
  `pullback.fst`/`snd` form. `pullbackSpecIso_hom_base` is the right
  tool; the option fix is the right enabler.

## Persistent file
- `analogies/pullbackspeciso-bypass.md` — design-rationale + full
  Mathlib citations + concrete recipe for the iter-180 prover lane,
  including residual cleanup steps and reversal trigger.

Overall verdict: **set_option backward.isDefEq.respectTransparency
false** is the canonical Mathlib idiom for this blocker — Mathlib's
`Normalization.lean`, `pullback.congrHom_inv`, `pullback.map_isIso`,
and ~14 RingTheory/TensorProduct sites use it for the same family of
heartbeat sinks. Empirically verified iter-180 to fire
`pullbackSpecIso_hom_base` on the actual stuck goal.
