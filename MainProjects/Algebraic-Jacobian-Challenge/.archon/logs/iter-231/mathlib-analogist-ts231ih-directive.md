# mathlib-analogist directive — ts231ih

## Mode: api-alignment

## The project declaration / situation

The project (`Picard/TensorObjSubstrate.lean`) builds a project-local internal hom for
`PresheafOfModules` (namespace `PresheafOfModules.InternalHom.internalHom`) and a "dual"
`ℋom(L, 𝒪_X)`. It needs the following lemma to close `exists_tensorObj_inverse` (every
locally-trivial 𝒪_X-module has a ⊗-inverse via its dual):

**Target lemma — internal-hom-commutes-with-restriction along an open immersion.**
For an open immersion `j : U ↪ X` of schemes (so `pushforward j` on `PresheafOfModules` over the
structure presheaves is essentially restriction `V ↦ V ∩ U`), we need a natural iso of
presheaves-of-modules:
```
j_* (ℋom_{𝒪_U}(L, 𝒪_U))  ≅  ℋom_{𝒪_X}(j_* L, 𝒪_X)
```
evaluated at `V`, as `𝒪_X(V)`-modules. The difficulty flagged by the prover: the value category
"varies with the ring" — at `V` the hom-module is over `𝒪(V)` — so a value-category-FIXED
sheaf-site equivalence (which the project already built, `overSliceSheafEquiv`, via
`Equivalence.sheafCongr`) does NOT transport this varying-ring module structure. The prover claims
this is "genuinely missing Mathlib infrastructure, ~150–300 LOC".

## Your questions (api-alignment)

1. **Does Mathlib already have this, or a directly reusable shadow?** Search for:
   - `PresheafOfModules` internal hom and any lemma relating it to `pushforward` / `restrictScalars`
     / pullback along a morphism (especially an open immersion / `Opens` restriction).
   - `ModuleCat` / `Module` level: `Hom`/`linearHom` commuting with base change, restriction of
     scalars, or localization (e.g. `LinearMap` and `IsLocalizedModule`, or
     `Module.Hom`-base-change isos). The single-ring shadow the project may need to lift.
   - Sheaf-theoretic: `f_*` (pushforward) commuting with internal hom for an open immersion in
     `Mathlib/Topology/Sheaves` or `AlgebraicGeometry`.
   - Whether `PresheafOfModules.pushforward` along an open immersion has a known
     "restriction is just `V ↦ V ∩ U`" characterization already in Mathlib.

2. **Is the project building a PARALLEL API it should instead align to?** The project's
   internal hom + dual are project-local. If Mathlib has a canonical `PresheafOfModules` internal
   hom (or an `Abelian`/`MonoidalClosed` structure on `PresheafOfModules`/`SheafOfModules`), the
   project may be re-deriving it. Report the cost of NOT aligning.

3. **Feasibility read on the planner's claim** that on the relevant opens `V ⊆ U` both sides are
   LITERALLY equal (since pushforward along an open immersion restricted to `V ⊆ U` gives `L(V)`
   on both sides), so the target is near-definitional rather than a 150–300 LOC build. Is that
   plausible, or is there a real coherence/naturality obstruction the planner is underestimating?

Report citations (file + decl) for anything you find. Persist the rationale under
`analogies/ts231ih.md`.
