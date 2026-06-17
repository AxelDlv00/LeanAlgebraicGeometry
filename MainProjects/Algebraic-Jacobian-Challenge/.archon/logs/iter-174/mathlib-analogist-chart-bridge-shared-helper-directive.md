# Mathlib Analogist Directive

## Slug
chart-bridge-shared-helper

## Mode
api-alignment

## Iteration
174

## Project context (one paragraph)

`AlgebraicJacobian/Genus0BaseObjects.lean` builds a scheme morphism `σ_× : ℙ¹ × 𝔾_m → ℙ¹` (the `𝔾_m`-scaling action on `ℙ¹` over an algebraically closed field `k̄`) via two affine charts + a cocycle. iter-173 closed the chart bodies axiom-clean via the 30-LOC analogist recipe (`pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫ pullback.congrHom ≫ pullbackSpecIso` — see `analogies/chart-bridge.md`). Two scaffold sorries remain:
- `gmScalingP1_chart_agreement` (L944) — the chart cocycle `∀ x y, pullback.fst (cover.f x) (cover.f y) ≫ chart x = pullback.snd _ _ ≫ chart y`.
- `gmScalingP1_over_coherence` (L961) — the over-coherence `(cover).glueMorphisms chart agreement ≫ PLB.hom = (PLB ⊗ Gm).hom`.

The iter-173 prover task result identifies the closure as a single shared private helper `gmScalingP1_chart_PLB_eq` (~50-60 LOC) bundling 4 sub-pieces: (a) kbar-linearity `chartMap.comp (algebraMap kbar Away) = algebraMap kbar (Away ⊗ GmRing)`; (b) bridge-structure `iso.hom ≫ Spec.map includeLeft = pullback.snd`; (c) per-cover pullback-condition chain; (d) `awayι_comp_PLB_hom` reuse.

## Specific question

I'm about to commit a private helper of the form

```
private lemma gmScalingP1_chart_PLB_eq (kbar : Type u) [Field kbar] [IsAlgClosed kbar]
    (i : Fin 2) :
    gmScalingP1_chart kbar i ≫ ProjectiveLineBarScheme kbar = ⋯
```

unifying the iter-174 PRIMARY 2 + PRIMARY 3 closures. The blueprint sketch is:

1. Apply `Cover.hom_ext` on the cocycle pair-wise.
2. Per-`i` case: reduce LHS to `iso_i.hom ≫ Spec.map (chartMap_i.comp (algebraMap kbar Away_i)) ≫ Proj.awayι` using `awayι_comp_PLB_hom`.
3. Show RHS via `tensorObj_hom` (pullback projection) → `pullback.snd ≫ Spec.map (algebraMap kbar (Away ⊗ GmRing))`.
4. Use `pullbackSpecIso_hom_fst` + `pullbackRightPullbackFstIso_hom_fst` + `pullbackSymmetry_hom_comp_fst` to identify `iso.hom ≫ Spec.map includeLeft = pullback.snd`.
5. Combine.

The cross-cases (`i = 0, j = 1` etc.) need the ring identity `λ · u = (1/t) · λ` in `Localization.Away t ⊗[kbar] GmRing` per `analogies/gmscaling-deep.md`.

**My question**: is there a structural Mathlib idiom for "a morphism out of a glued cover factors through a `Spec.map (algebraMap kbar _)` to a target scheme via a per-chart shared certificate"? Specifically: does Mathlib have a helper for the pattern

> Given a `Scheme.Cover c` of `X`, two morphisms `f, g : X → Y` agree iff they agree on every chart restricted via `c.f i` AND the gluing-data per-chart certificate composes appropriately.

This appears to be very close to `Scheme.Cover.hom_ext_of_glue` if it exists. Verify:
- Does Mathlib have a name like `Scheme.Cover.glueMorphisms_comp` or `Cover.hom_ext_of_agreement`?
- If so, what's the right way to invoke it so the cocycle agreement reduces to a per-`i` algebraMap equation?
- If NOT, is the helper-budget=0 sustainable, or is this a sign that a Mathlib mini-bridge would unblock multiple Cover.glueMorphisms invocations downstream?

## Failed approaches

- iter-172: 4-attack-1-close (PRIMARY 1 only, via direct analysis without analogist).
- iter-173: 3-attack-1-close (PRIMARY 1 only, with the chart-bridge recipe; PRIMARY 2 + 3 deferred as the analyst's recipe doesn't yet specialize to the cocycle).
- The recurring blocker phrase across 2 iters is "chart-bridge specialisation" — meaning the standard `pullback*` identities don't compose without project-side glue.

## Search radius
narrow (same algebraic-geometry sub-area).

## What I need

1. Verify presence/absence of `Scheme.Cover.glueMorphisms_comp` / `Cover.hom_ext_of_agreement` (or similarly-named idiom).
2. Concrete recipe — 5–8 named Mathlib lemmas to chain — for the shared helper `gmScalingP1_chart_PLB_eq`.
3. If recipe diverges from the iter-173 sketch (steps 1–5 above), name the structural mismatch and propose a corrected one.
4. Optional: cross-domain (Mathlib pullback / monoidal idioms in `Mathlib.CategoryTheory.Monoidal`) precedents.

## Output

Persist as `analogies/chart-bridge-shared-helper.md` with the recipe + named lemmas. Report under `task_results/mathlib-analogist-chart-bridge-shared-helper.md`.
