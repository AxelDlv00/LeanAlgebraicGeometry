# Mathlib-analogist directive — slug `tosheaf-epi`

## Mode: api-alignment

## Question
We need the project-local fact: the forgetful functor
`SheafOfModules.toSheaf : SheafOfModules R ⥤ Sheaf J AddCommGrpCat` (for `R` the sheaf of
rings of a scheme `X`, `J = Opens.grothendieckTopology X`) **preserves epimorphisms**.
Target Lean name: `AlgebraicGeometry.toSheaf_preservesEpimorphisms`. Used to pass from
`Epi g` in `X.Modules` to local section surjectivity (via
`Sheaf.isLocallySurjective_iff_epi'`).

Decide the cleanest Mathlib-aligned route, and whether Mathlib already supplies it (or a
near-equivalent we should build on rather than reinvent). Specifically resolve these:

1. Does Mathlib already have `(SheafOfModules.toSheaf R).PreservesEpimorphisms`, or
   `PreservesFiniteColimits`/`PreservesColimits`/right-exactness for `SheafOfModules.toSheaf`?
   (Mathlib is known to ship `PreservesFiniteLimits (toSheaf R)` in
   `Mathlib.Algebra.Category.ModuleCat.Sheaf.Limits`, plus `Faithful`, `Additive` — but
   apparently NOT the colimit/epi side. Confirm or refute.)

2. Is there an `epi_iff_isLocallySurjective` / `epi ↔ locally surjective` characterization for
   `SheafOfModules R` (an `Epi`-in-`SheafOfModules` ⟹ `IsLocallySurjective (toSheaf g)`
   bridge)? Mathlib has `Sheaf.isLocallySurjective_iff_epi'` and
   `Sheaf.epi_of_isLocallySurjective` on the abelian-sheaf side; is there the analogue, or a
   `SheafOfModules`-level `IsLocallySurjective`, that closes the gap directly?

3. Is `SheafOfModules R` known to Mathlib as abelian / balanced, and does the abelian/balanced
   structure plus `toSheaf` faithful+exact-on-one-side give epi-preservation cheaply?

4. How does Mathlib compute colimits in `SheafOfModules R`? (sheafification of the
   presheaf-of-modules colimit? the `SheafOfModules.sheafification` adjunction?) Is there a
   coherence iso `toSheaf ∘ sheafification ≅ presheafToSheaf ∘ toPresheaf` already in Mathlib,
   or building blocks for `PreservesFiniteColimits (toSheaf R)`?

## Failed approaches (prover, iter-032, all attempted in Lean)
1. `Functor.preservesEpimorphisms_of_preserves_shortExact_right` — hypothesis needs `Epi (toSheaf g)` = the goal (circular).
2. `Sheaf.isLocallySurjective_iff_epi'` — reduces to the missing `Epi g (SheafOfModules) ⟹ IsLocallySurjective (toSheaf g)`; also `Balanced (Sheaf …)` fails to synthesize under `rw`.
3. Stalk route (`TopCat.Presheaf.locally_surjective_iff_surjective_on_stalks`) — needs stalk-exactness of the SheafOfModules SES = the same content.
4. `toSheaf ≅ (forget ⋙ toPresheaf) ⋙ presheafToSheaf` — fails: `forget` (toPresheafOfModules) is a RIGHT adjoint, does not preserve epis.

## What I need back
A ranked set of concrete routes (each: Mathlib citation + whether it exists today + the build
shape if it must be built), and an explicit verdict: is this a small instance we missed, or a
genuine multi-lemma project build? If the latter, the minimal lemma chain. Persist the rationale
to `analogies/tosheaf-epi.md`.
