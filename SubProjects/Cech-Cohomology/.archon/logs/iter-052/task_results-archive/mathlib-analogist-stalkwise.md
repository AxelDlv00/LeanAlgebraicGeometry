# Mathlib Analogist Report

## Mode
api-alignment

## Slug
stalkwise

## Iteration
052

## Question
What is the Mathlib-aligned way to prove `cechAugmentedComplex 𝒰 F` is exact in `X.Modules`
(the Čech nerve is a resolution of quasi-coherent `F`)? Stalk-reflection vs sections/basis detour —
given Mathlib has no `SheafOfModules.stalk` and no "complex exact iff stalkwise" criterion.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Reflection backbone (faithful `toSheaf`, not a `SheafOfModules.stalk` functor) | ALIGN_WITH_MATHLIB | informational (no divergent shipped code) |
| B. Underlying-exactness route: sections/sheafification, NOT stalkwise | PROCEED (sections); avoid stalk gap-fill | major (proposal-stage route choice) |

## Answers to the four questions

**Q1 — canonical reflection idiom.** Yes, the directive's decomposition step (1) is right and Mathlib
backs it with a *weaker-than-expected* hypothesis: `CategoryTheory.Functor.reflects_exact_of_faithful`
(`Mathlib.CategoryTheory.Abelian.Exact`) gives `(S.map F).Exact → S.Exact` for any
`S : ShortComplex C` from just `[F.PreservesZeroMorphisms] [F.Faithful]` (abelian `C, D`). For
`F = SheafOfModules.toSheaf R` all hypotheses are Mathlib instances:
`instFaithfulSheafAddCommGrpCatToSheaf`, `instAdditiveSheafAddCommGrpCatToSheaf`,
`instReflectsIsomorphismsSheafOfModulesSheafAddCommGrpCatToSheaf`,
`instReflectsFiniteLimitsSheafOfModulesSheafAddCommGrpCatToSheaf`
(and `instPreservesFiniteLimits…` in `…Sheaf.Limits`). So step (1) is *free* and the project's
`toSheaf_preservesFiniteColimits` is **not** needed for reflection.
Step (2) ("abelian-sheaf complex exact iff stalkwise") is genuinely **absent** from Mathlib: it has
only the *mono/iso* stalk reflections (`TopCat.Presheaf.mono_iff_stalk_mono`,
`isIso_iff_stalkFunctor_map_iso`, `mono_of_stalk_mono`, `stalkFunctor_preserves_mono`) — nothing for
exactness of a complex, no packaged "`stalkFunctor` is exact", no "sheaf = 0 iff stalks = 0". So (2)
as a *stalk* statement would have to be built. The recommended route (Q3) sidesteps it.

**Q2 — existing "exact iff stalkwise" to port?** No. Mathlib's stalkwise reflections stop at
monomorphisms and isomorphisms (`Mathlib.Topology.Sheaves.Stalks`), for any fixed concrete `C`
(including `ModuleCat R` with fixed `R`). There is no exactness-of-complex version for any sheaf
category. The technique it *would* need (stalkFunctor exact + jointly conservative) is only
half-present: conservativity is there (`isIso_iff_stalkFunctor_map_iso`), but stalkFunctor-exactness
is not instantiated (only the AB5/filtered-colimit ingredients exist loose). Porting cost is high
relative to the sheafification route, and none of it carries the varying-stalk-ring `X.Modules` data
— you would still forget to `AddCommGrp` first.

**Q3 — sections/affines detour: is there a Mathlib-aligned route without stalks?** Yes, and it is the
recommended one. The precise mechanism is **"homology sheaf = sheafification of presheaf homology,
and sheafification kills basis-locally-zero presheaves"**:
- `PresheafOfModules.homologyIsoSheafify` (PROJECT, `HigherDirectImagePresheaf.lean:112`):
  `K.homology i ≅ (sheafification α).obj ((forget K).homology i)` — built from `Functor.mapHomologyIso'`
  + sheafification-exact. This already reflects exactness *inside the module category*.
- W-equivalence / locally-bijective theory (`Mathlib.CategoryTheory.Sites.LocallyBijective`,
  `…/LocallySurjective`): `Sheaf.isLocallyBijective_iff_isIso`,
  `Presheaf.isLocallySurjective_presheafToSheaf_map_iff`,
  `GrothendieckTopology.WEqualsLocallyBijective` (instance for `AddCommGrp`). A presheaf zero on a
  basis makes `0 ⟶ P` a `J.W`, so `sheafify P ≅ 0`.
- Basis vanishing is **already proved**: `sectionCech_affine_vanishing` /
  `sectionCech_homology_exact_of_localizationAway` give section-homology `= 0` over every `D(f)`.
"Sections are not exact in general" is a non-issue: sheafification needs only *local* vanishing, which
the affine basis supplies exactly.

**Q4 — recommendation.** Take the **sections/sheafification route** (lower LOC, lower risk, maximal
reuse). Do not build a `SheafOfModules` stalk functor and do not fill the stalkwise-exactness gap.
Concrete decomposition (LOC, lowest-risk first):
1. `cechAugmented_exact` from `∀ i, IsZero (homology i)` via `HomologicalComplex.exactAt_…` — ~30–50.
2. Sheafification-kills-basis-locally-zero: `homologyIsoSheafify` + `J.W` argument
   (`Sheaf.isLocallyBijective_iff_isIso`, `isLocallySurjective_presheafToSheaf_map_iff`,
   `WEqualsLocallyBijective AddCommGrp`, `affineCoverSystem`/`standard_cover_cofinal`), reflect `IsZero`
   back via faithful `toSheaf` — ~80–120 (**highest risk**, sheafification plumbing).
3. Presheaf-homology = `sectionCechComplex` homology per open (mapHomologicalComplex-vs-concrete
   plumbing; diamond-prone, cf. `keystone-tile-reconciliation-not-rfl`) — ~80–150.
4. Augmentation node (degree 0: `F→C⁰` mono + `H⁰ = M_f`) via `exact_of_isLocalized_span`,
   complementing `sectionCech_affine_vanishing`'s degrees ≥ 1 — ~60–100.
Total ≈ 250–420 LOC.

## Major

- **Decision B (route choice, proposal-stage)**: the planner should direct the `cechAugmented_exact`
  prover to the **sections/sheafification** route built on `PresheafOfModules.homologyIsoSheafify` +
  the `LocallyBijective` W-equivalence theory, reusing `sectionCech_affine_vanishing`. Explicitly
  steer AWAY from constructing a `SheafOfModules.stalk` functor or an "exact iff stalkwise" criterion:
  those are a Mathlib gap-fill (stalkFunctor-exactness + sheaf-zero-iff-stalk-zero) that this route
  never needs, and they discard the varying-stalk-ring structure anyway.

## Informational

- **Decision A**: `reflects_exact_of_faithful` (only `Faithful` + `PreservesZeroMorphisms`) is the
  canonical reflection; `toSheaf` satisfies it via existing Mathlib instances. Useful both as the
  `IsZero`-reflection step inside the recommended route and as a standalone fallback (reflect each
  degree's ShortComplex exactness through `toSheaf`, then run the same `J.W` argument on the
  `AddCommGrp` complex).
- Mathlib stalkwise API (`Mathlib.Topology.Sheaves.Stalks`) tops out at mono/iso reflection; the
  exactness version is absent — recorded so future iters don't re-search for it.

## Persistent file
- `analogies/stalkwise-exact-xmodules.md` — full route rationale, citations, and decomposition.

Overall verdict: reflect through faithful `toSheaf` and prove exactness via
`homologyIsoSheafify` + "sheafification kills basis-locally-zero presheaves" (`LocallyBijective`
W-equivalences) using the already-proved `sectionCech_affine_vanishing`; do **not** build a
`SheafOfModules` stalk functor or an "exact iff stalkwise" criterion.
