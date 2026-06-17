## Mode: api-alignment

## Project declaration / design under question

We are assembling a "section-localization Hfr datum" for a quasi-coherent module `M` on `Spec R`
(`R : CommRingCat`). Setup:

- `j : Spec S ⟶ Spec R` is an open immersion onto a basic open `D(s) ⊆ Spec R`, where
  `S := Γ(q.X i, ι⁻¹ᵁ D(s))` is itself a `CommRingCat` (the global sections of an affine open of
  another scheme). Concretely `j := isoSpec.inv ≫ ι_W ≫ ι_{q.X i}`.
- `M' := (AlgebraicGeometry.Scheme.Modules.pullback j).obj M` is the pulled-back module on `Spec S`.
- `Γ(M', V)` (global/over-`V` sections of `M'`) is naturally a module. Two scalar actions are in play
  and we must reconcile them:
  (1) The **`ModuleCat S` action**: `Γ(M', ⊤)` and `Γ(M', D(f'))` as objects of `ModuleCat S` (the
      `S`-module structure used by our localization engine
      `isLocalizedModule_restrict_of_isIso_fromTildeΓ`, which produces
      `IsLocalizedModule (powers f') (restriction map)` over the CommRingCat `S`).
  (2) The **structure-sheaf action**: our already-proven semilinearity lemma
      `gammaPullbackImageIso_hom_semilinear` expresses the section-transport iso `gammaPullbackImageIso`
      as semilinear over `gammaImageRingEquiv j V : Γ(Spec S, V) ≃+* Γ(Spec R, j''ᵁ V)`, i.e. the action
      of the **structure-sheaf ring** `Γ(Spec S, V)`. At `V = ⊤` this is `Γ(Spec S, ⊤)`.

`S` and `Γ(Spec S, ⊤)` are related by `AlgebraicGeometry.Scheme.ΓSpecIso S : Γ(Spec S, ⊤) ≅ S`
(a `CommRingCat` iso). Our intended `σ : S ≃+* A` is the composite
`(ΓSpecIso S).symm-as-RingEquiv ≪≫ gammaImageRingEquiv j ⊤`.

## The precise question

The "genuine hard core" is: **what is Mathlib's canonical idiom for relating the `ModuleCat S` scalar
action on the sections of a module-on-`Spec S` to the `Γ(Spec S, ⊤)` structure-sheaf scalar action,
given `ΓSpecIso S`?** Specifically:

1. For `M'` a `Scheme.Modules` (or `SheafOfModules`/`PresheafOfModules`) object on `Spec S`, the
   `Γ(M', ⊤)`-sections carry a module structure over the structure-sheaf ring `Γ(Spec S, ⊤)`. Our engine
   instead views `Γ(M', ⊤)` as a `ModuleCat S`. Is the bridge between these two `restrictScalars` along
   `(ΓSpecIso S).hom` (or `.inv`), and is it **defeq** in Mathlib's construction (i.e. does the
   `ModuleCat S` action literally factor through `ΓSpecIso`), or does it require an explicit transport?
2. How does `AlgebraicGeometry.Scheme.Modules` (or whatever functor takes a `ModuleCat S` /
   `Spec`-side module to its sheaf — the project calls a piece of this `modulesSpecToSheaf`) re-base the
   scalar action along `ΓSpecIso`? Is there a Mathlib lemma equating
   `(structure-sheaf action) = restrictScalars (ΓSpecIso S).hom (ModuleCat-S action)` on sections, or a
   naturality square we can invoke?
3. Is there a cleaner Mathlib-aligned `σ` than our `ΓSpecIso.symm ≪≫ gammaImageRingEquiv` composite —
   i.e. does Mathlib already provide the ring iso between the `Spec`-side CommRingCat and the
   structure-sheaf-at-⊤ in a form that makes the semilinearity re-basing a one-step `restrictScalars`
   rather than a hand-built composite?

## What I need back

- The Mathlib idiom (named lemmas / instances) for the `Spec`-side `ModuleCat R` action vs the
  structure-sheaf `Γ(Spec R, ⊤)` action reconciliation — `ΓSpecIso`, `Spec.structureSheaf`,
  `StructureSheaf`, `toOpen`/`toStalk`, `ΓSpecIso`-naturality, `restrictScalars` bridges.
- Whether the reconciliation is defeq or needs an explicit `LinearEquiv.restrictScalars` /
  `ModuleCat.restrictScalars` transport, with the concrete lemma names.
- A concrete recommendation: keep the `ΓSpecIso.symm ≪≫ gammaImageRingEquiv` composite `σ`, or align to a
  Mathlib idiom that avoids it.

Relevant Mathlib anchors the prover already cited: `AlgebraicGeometry.Scheme.ΓSpecIso` (Scheme.lean:606),
`Algebra Γ(X,U) Γ(X, X.basicOpen f)` via `.hom.toAlgebra` (Scheme.lean:725, Restrict.lean:200).
Read the relevant Lean source to ground your answer; persist the recipe to `analogies/<slug>.md`.
