# Directive — mathlib-analogist

## Mode: api-alignment

## Context (minimal)
A project builds sheaf cohomology of `O_X`-modules on a scheme `X`. The category of sheaves of
`O_X`-modules is `X.Modules` (`= SheafOfModules (X.ringCatSheaf)` / `AlgebraicGeometry.Scheme.Modules`),
an abelian category. We have constructed an augmented cochain complex `cechAugmentedComplex` in
`CochainComplex X.Modules ℕ` (the augmented Čech complex `0 → F → C⁰ → C¹ → ⋯`, where `Cᵖ` are
pushforwards of restrictions of a quasi-coherent `F`). We need to prove this complex is **exact**
(acyclic) — the Čech nerve is a resolution of `F`.

## The structural problem
We need a **stalkwise-exactness reflection criterion** for complexes in `X.Modules`:

> "A `ShortComplex` (or `HomologicalComplex`) in `X.Modules` is exact iff it is exact on every
> stalk" — i.e. exactness of a complex of sheaves of `O_X`-modules can be checked stalk-by-stalk.

A prover verified (loogle/leansearch) that Mathlib has **no `SheafOfModules.stalk` functor** and **no
"complex of `X.Modules` exact iff stalkwise exact" criterion**. Mathlib DOES have, for presheaves
valued in a *fixed* concrete category: `TopCat.Presheaf.stalkFunctor`, `TopCat.Presheaf.mono_iff_stalk_mono`,
`isIso_iff_stalkFunctor_map_iso`, and `HomologicalComplex.exact_iff_degreewise_exact` (degreewise, NOT
stalkwise). The obstacle: the value category of `X.Modules` varies stalk-to-stalk (each stalk is a module
over the stalk ring `O_{X,x}`).

## Specific questions (please answer each)

1. **Canonical idiom for the reflection.** What is the Mathlib-aligned way to prove "a complex in
   `X.Modules` is exact"? Candidate decomposition the prover sketched:
   - (1) `X.Modules` complex exact ⇐ exact on underlying abelian sheaves, via the forgetful
     `SheafOfModules.toSheaf` / `forget₂ … AddCommGrp` being exact + faithful/conservative.
   - (2) Abelian-sheaf complex (`TopCat.Sheaf AddCommGrp`) exact iff stalkwise exact, via
     `TopCat.Presheaf.stalkFunctor` exact + jointly conservative.
   Is this the right shape? Does Mathlib already provide (1) (forget-from-SheafOfModules exactness /
   reflects-exactness) and/or (2) (stalkwise exactness reflection for `TopCat.Sheaf AddCommGrp`)?
   Name the exact declarations if they exist (`Sheaf.exact_iff_stalk...`, `stalkFunctor` exactness,
   `Functor.ReflectsExactSequences`, conservative/jointly-faithful instances, etc.).

2. **Is there an existing "exact iff stalkwise" for any sheaf category in Mathlib** that we can port
   (e.g. for `TopCat.Sheaf (ModuleCat R)` with a *fixed* base ring, or for abelian sheaves)? If so,
   what technique does it use and how much carries over to the varying-stalk-ring `X.Modules` case?

3. **The sections-on-affines detour.** An alternative the lean-vs-blueprint checker floated: instead of
   stalks, use the tilde-isomorphism machinery already in scope (`qcoh_iso_tilde_sections`: for qcoh `F`
   on affine `Spec R`, `F ≅ ~M`) and the section-level standard-cover Čech exactness already proved
   (`sectionCech_affine_vanishing` / `sectionCech_homology_exact_of_localizationAway`). Is there a
   Mathlib-aligned route to conclude **sheaf-complex exactness** from **section-complex exactness on an
   affine basis** WITHOUT a stalk functor — e.g. via `Sheaf.exact_iff` on a basis, an exactness criterion
   for sheaves checked on a basis of opens, or `Sheaf`/`Presheaf` exactness being detectable on a
   covering family? Sections are NOT exact in general, so name the precise mechanism if one exists
   (basis-local exactness of complexes, or the homology-sheaf-is-zero-iff-zero-on-a-basis idea).

4. **Recommendation.** Which route (stalk reflection vs sections/basis detour) is the lower-LOC,
   lower-risk path given current Mathlib? Give a concrete starting decomposition (named Mathlib
   declarations to lean on, the project-side lemmas to build, rough LOC) so a `mathlib-build` prover
   can start. If stalk reflection, name the `stalkFunctor`-exactness and conservativity lemmas to
   build on; if the detour, name the basis-exactness mechanism.

## Out of scope
Do not propose changing `cechAugmentedComplex` or any frozen signature. Do not write Lean proofs —
return the route, the Mathlib citations, and the decomposition. Persist your findings to
`analogies/stalkwise-exact-xmodules.md`.
