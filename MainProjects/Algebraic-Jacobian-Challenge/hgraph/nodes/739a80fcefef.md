---
author: sync
content_type: definition
created: '2026-07-29T01:14:28'
decl: AlgebraicGeometry.cechComplex_baseChange_iso_flat
docstring: '**The tensorial base change of the Čech complex, with the S-level leaf
  REMOVED** (run 0068 r3).

  Same conclusion as `cechComplex_baseChange_iso`, built from

  `cechComplex_baseChange_cosimplicialIso_flat`, so `cech_pushforward_baseChange_natIso`
  — one of the

  two open leaves of that declaration — is **absent from this proof term**.  The single
  remaining

  leaf is `twisted_cech_nerve_iso`''s naturality square.


  Extra binder over `cechComplex_baseChange_iso`: `[Flat g]`, which every consumer
  of that

  declaration in this file already has.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechComplex_baseChange_iso_flat
type: lean
updated: '2026-07-29T01:14:28'
---
noncomputable def cechComplex_baseChange_iso_flat
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((Scheme.Modules.pullback g).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (CechComplex f 𝒰 F)
      ≅ CechComplex f'
          ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
          ((Scheme.Modules.pullback g').obj F) :=
  cechComplex_baseChange_iso_of_cosimplicialIso f g f' g' h 𝒰 F
    (cechComplex_baseChange_cosimplicialIso_flat f g f' g' h 𝒰 F hF)