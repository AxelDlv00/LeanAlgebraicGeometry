# Mathlib Analogist Report

## Mode
api-alignment

## Slug
l1bridge

## Iteration
017

## Question
Before dispatching a mathlib-build prover at L1 (the categorical→module bridge for
`CechAcyclic.affine` / `lem:cech_acyclic_affine`), confirm the L1 API path is real on
today's Mathlib so the lane does not burn a 3rd iter. Confirm/refute each of: (1) section
= away-localisation + quasicoherent `F ≅ tilde (Γ F)`; (2) restriction = localisation map;
(3) `IsZero (homology p)` ⇒ `Function.Exact` of R-module maps; (4) the outer `pushforward f`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 localisation building blocks (`IsLocalizedModule` on `D(g)`, `isUnit…basicOpen`, `tilde.adjunction`) | PROCEED (confirmed real) | informational |
| Q1 quasicoherent `F ≅ tilde (Γ F)` on affine | NEEDS_MATHLIB_GAP_FILL | major (buildable, ~100-150 LOC) |
| Q2 restriction = canonical localisation map | PROCEED (confirmed real) | informational |
| Q3 endpoints (`exactAt_iff_isZero_homology`, `moduleCat_exact_iff`, `exact_of_isLocalized_span`) | PROCEED (confirmed real) | informational |
| Q3 categorical→module identification (terms+differentials+δ/c) | NEEDS_MATHLIB_GAP_FILL | major (the bulk, ~250-400 LOC) |
| Q4 outer `pushforward f` exactness/homology-preservation | NEEDS_MATHLIB_GAP_FILL **or** reformulate unprotected statement | critical (decisive blocker) |

## Overall verdict: **NOT-FEASIBLE-YET as a single mathlib-COMPOSE lane this iter.**
The localisation engine is real and composable, but closing L1 end-to-end requires two
genuine new-infrastructure constructions absent from Mathlib (affine `F ≅ tilde(Γ F)`; affine
`pushforward f` exactness/sidestep) PLUS the large categorical→module identification. A prover
told to "fill the L1 bridge" hits the same wall the last two iters did. Decompose into
sub-lanes (below) instead of dispatching a monolithic L1 lane.

## Confirm/refute per the directive

1. **Section = localisation.** CONFIRMED present, exactly as iter-016 reported:
   - `AlgebraicGeometry.tilde.instIsLocalizedModulePowersHomToOpenBasicOpen` —
     `instance (f : R) : IsLocalizedModule (.powers f) (tilde.toOpen M (basicOpen f)).hom`,
     `Mathlib/AlgebraicGeometry/Modules/Tilde.lean:115`.
   - `AlgebraicGeometry.tilde.isUnit_algebraMap_end_basicOpen`, `Tilde.lean:182`.
   - The bridge `quasicoherent F ⇒ F ≅ tilde (Γ F)` is **PARTIAL / GAP**. Mathlib has
     `Scheme.Modules.fromTildeΓ` (counit `tilde (Γ F) ⟶ F`, `Tilde.lean:195`),
     `isIso_fromTildeΓ_iff` (`:340`, `IsIso ↔ essImage`), and
     `isIso_fromTildeΓ_of_presentation` (`:398`). It has **NO** `IsQuasicoherent F →
     IsIso F.fromTildeΓ`: the constructor needs a **global** `F.Presentation`, but
     `IsQuasicoherent` (`Quasicoherent.lean:249`) yields only **local** `QuasicoherentData`.
     Globalising on the affine (Stacks 01I8, `QCoh(Spec R) ≃ Mod R`) is project-side, buildable.

2. **Restriction = localisation map.** CONFIRMED. `tilde.toOpen_res` (`Tilde.lean:111`) makes
   the restriction commute with the `toOpen` localisation maps; with the `IsLocalizedModule`
   instances + `IsLocalizedModule.lift` uniqueness, the restriction between two basic opens IS
   the canonical localisation map. `IsAffineOpen.isLocalization_of_eq_basicOpen`
   (`AffineScheme.lean:716`) installs the `IsLocalization.Away` algebra. No gap.

3. **Homology ↔ exactness.** Endpoints CONFIRMED: `exactAt_iff_isZero_homology`
   (`Algebra/Homology/SingleHomology.lean:40`), `ShortComplex.ShortExact.moduleCat_exact_iff_function_exact`
   (`ModuleCat/Localization.lean:90`), `exact_of_isLocalized_span` & `exact_of_localized_span`
   (`RingTheory/LocalProperties/Exactness.lean:173,211`). The MISSING idiom is the move from
   `(Spec R).Modules`-homology to `ModuleCat R`. `SheafOfModules.evaluation` / `moduleSpecΓFunctor`
   is a right adjoint — "Γ preserves homology on the affine" is circular. The non-circular route
   is **equivalence-on-essImage**: show the upstairs Čech complex is `tilde.functor.mapHomologicalComplex D`
   (each term in `essImage (tilde.functor R)`, each differential = `tilde` of a localisation map),
   then `Γ` restricted to `essImage` reflects `IsZero homology` (unit iso, `Tilde.lean:306`); finish
   with `exactAt_iff_isZero_homology` + `moduleCat_exact_iff` + `exact_of_isLocalized_span` + the
   L3 `depDiff_exact`. This identification is the project's genuine new infrastructure (no Mathlib
   one-liner). `alternatingFaceMapComplex ⋙ F.mapHomologicalComplex = …` (`AlternatingFaceMapComplex.lean:183`)
   confirms an additive functor commutes with the alternating complex.

4. **Pushforward along `f`.** It COMPLICATES the identification and is the decisive blocker.
   `pushforward f` is `IsRightAdjoint` (`Modules/Sheaf.lean:181`): preserves kernels, NOT
   cokernels/homology. There is **no** affine-pushforward exactness, no
   `PreservesFiniteColimits (pushforward f)`, and no affine quasicoherent cohomology-vanishing
   anywhere in `Mathlib/AlgebraicGeometry/`. Since
   `CechComplex f 𝒰 F ≅ (pushforward f).mapHomologicalComplex (upstairs complex)`, reducing
   `IsZero (homology p)` to the upstairs vanishing needs `pushforward f` to preserve homology =
   affine-pushforward exactness (Stacks 01XF/02KC) — a real gap. **Cheapest fix:**
   `CechAcyclic.affine` is NOT protected (only `cech_computes_higherDirectImage` is), so the
   `pushforward f` can be lifted out of its statement (restate the vanishing upstairs in
   `(Spec R).Modules`). Recommend a mathematician decision on this before any L1 prove lane.

## Major

- **Q1 globalisation (sub-lane β, ~100-150 LOC):** build `IsQuasicoherent F → IsIso F.fromTildeΓ`
  on `Spec R` by globalising `QuasicoherentData` to a global `F.Presentation`, then
  `isIso_fromTildeΓ_of_presentation`. Self-contained, Mathlib-gradient, no protected signatures.
- **Q3 identification (sub-lane γ, ~250-400 LOC):** identify the upstairs Čech complex with
  `tilde.functor.mapHomologicalComplex (∏_σ M_{s_σ})`, construct `δ`/`c` + `hu`/`hsh`/`hcomm`
  from the `IsLocalizedModule (.powers …)` instances, reflect homology via equivalence-on-essImage,
  feed L2+L3. The bulk of the bridge.

## Informational

- **Q4 sidestep is a planning/owner decision, not a prove task** — surface to the mathematician:
  should `pushforward f` be in `CechAcyclic.affine`'s (unprotected) statement at all? Removing it
  deletes the single hardest gap.
- **Do the prior designs hold?** `cech-koszul-precedent.md`: localisation/L2 engine confirmed
  valid, but its ExtraDegeneracy acyclicity-route is **superseded** by the project's from-scratch
  `CombinatorialCech` cores (the `CechAcyclic.lean` header explicitly forbids the simplicial
  `ExtraDegeneracy` route — wrong variance, no cosimplicial dual). `finite-prod-loc`:
  `IsLocalizedModule.pi` + Away-adapter + `LinearEquiv.exact_iff` still hold and feed sub-lane γ;
  the `ModuleCat k` post-hoc R-linearity trap does NOT recur (the current cores are plain R-modules).
- **Stale pointer:** the directive and several in-file comments cite `analogies/p3-localisation.md`,
  which does not exist on disk. The L1/L2/L3 recipe in the `CechAcyclic.lean` header is the design
  of record; recommend the planner either create that file or repoint the comments.

## Persistent file
- `analogies/l1-bridge.md` — full design-rationale, the equivalence-on-essImage route, and the
  three-sub-lane decomposition, captured for future iters.

Overall verdict: the localisation engine is real (Q1 basics, Q2, L2, L3 all confirmed), but L1 as
a whole is NOT one composable mathlib lane this iter — it is two Mathlib gaps (affine tilde
equivalence; affine pushforward exactness/sidestep) plus a large categorical→module identification;
decompose into sub-lanes Q4-decision → β → γ rather than dispatch a monolithic L1 prover.
