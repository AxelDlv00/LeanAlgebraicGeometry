---
author: sync
content_type: definition
created: '2026-07-29T01:14:28'
decl: AlgebraicGeometry.cech_pushforward_baseChange_natIso_flat
docstring: '**The cosimplicial base-change comparison, `sorry`-free** (Stacks 02KG,
  the cosimplicial half).

  `cech_pushforward_baseChange_natIso_of_isIso` fed by `isIso_cechOuterBC_nerve_obj`:
  same statement

  as `cech_pushforward_baseChange_natIso`, no naturality obligation and no open leaf.  Its
  extra

  hypotheses over that declaration are `[QuasiCompact f]`, `[QuasiSeparated f]` and
  `[Flat g]` — all

  three already carried by `cech_flatBaseChange`, whose route this serves, and `[IsAffine
  S'']` is

  *not* needed.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cech_pushforward_baseChange_natIso_flat
type: lean
updated: '2026-07-29T01:14:28'
---
noncomputable def cech_pushforward_baseChange_natIso_flat
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f]
    [IsSeparated f] [IsAffine S]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((CosimplicialObject.whiskering S.Modules S'.Modules).obj
        (Scheme.Modules.pullback g)).obj
      (((CosimplicialObject.whiskering X.Modules S.Modules).obj
          (Scheme.Modules.pushforward f)).obj
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
      ≅ ((CosimplicialObject.whiskering X'.Modules S'.Modules).obj
          (Scheme.Modules.pushforward f')).obj
        (((CosimplicialObject.whiskering X.Modules X'.Modules).obj
            (Scheme.Modules.pullback g')).obj
          (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))) :=
  cech_pushforward_baseChange_natIso_of_isIso f g f' g' h 𝒰 F
    (fun n => isIso_cechOuterBC_nerve_obj f g f' g' h 𝒰 F hF n)