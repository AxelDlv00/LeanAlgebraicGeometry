---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_semilinear
docstring: '**Semilinearity of the pullback section transport** (gap1 semilinearity
  wall). The forward map

  of `gammaPullbackImageIso` is `σ_V`-semilinear (`σ_V = gammaImageRingEquiv`): for
  `a : Γ(X, V)` a

  section of the structure sheaf and `x` a section of the pullback module,

  `hom (a • x) = σ_V a • hom x`. The pullback-side action is the structure-sheaf action
  through

  the pullback''s `mapPresheaf`; the action on the `M` side is `M`''s action through
  `σ_V`.

  Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_semilinear
type: lean
updated: '2026-07-24T03:02:11'
---
theorem gammaPullbackImageIso_hom_semilinear {X Y : Scheme.{u}} (j : X ⟶ Y) [IsOpenImmersion j]
    (M : Y.Modules) (V : X.Opens) (a : Γ(X, V))
    (x : Γ((Scheme.Modules.pullback j).obj M, V)) :
    (gammaPullbackImageIso j M V).hom (a • x)
      = gammaImageRingEquiv j V a • (gammaPullbackImageIso j M V).hom x := by
  -- `gammaPullbackImageIso j M V`'s forward map is `Γ(-, V)` of the `Ab`-morphism
  -- `ψ := ((restrictFunctorIsoPullback j).symm.app M).hom`, i.e. the section map `ψ.app V`.
  simp only [gammaPullbackImageIso, Functor.mapIso_hom, Functor.comp_map,
    Scheme.Modules.toPresheaf_map, CategoryTheory.evaluation_obj_map,
    Scheme.Modules.mapPresheaf_app]
  -- `ψ.app V` is `Γ(X, V)`-linear (`Hom.app_smul`): `ψ.app V (a • x) = a • ψ.app V x`, the
  -- `Γ(X, V)`-action being `restrictFunctor`'s `restrictScalars`-action along `(j.appIso V).inv`.
  erw [Scheme.Modules.Hom.app_smul]
  -- The `restrictScalars` action `a •_{restrict} m` is defeq to `(j.appIso V).inv a •_M m`,
  -- and `σ_V a = gammaImageRingEquiv j V a = (j.appIso V).inv a`, so the two sides agree by `rfl`.
  rfl

/-! ## Project-local Mathlib supplement — gap1-D Hfr: combined algebra transport

The two `IsLocalizedModule` bridges (I) `isLocalizedModule_of_ringEquiv_semilinear` and (II)
`isLocalizedModule_restrictScalars_powers_algebraMap` are chained into a single transport lemma:
the localization that P1 (`IsIso fromTildeΓ`) produces on the slice `Spec R_r` (a localization at
`powers f'` over the section ring `S`) is read back, across the `σ`-semilinear section isos and the
base change `R → A` (`A = R_r`), as a localization at `powers f` over the base ring `R`. -/