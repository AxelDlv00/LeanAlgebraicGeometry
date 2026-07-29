---
author: sync
content_type: structure
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.RelPicTransportFamily
docstring: 'A transport family between the relative Picard theories of a curve bundle
  `D` over

  `kD` and a curve bundle `E` over `kE`, on affine tests: for every test algebra `B`
  in

  scalar towers over both base fields through a common overfield `kT`, a scheme morphism

  between the product carriers, compatible with the second projections and natural
  in `B`.

  Descending along `Scheme.CechPic.map`, such a family induces a transport

  `PicEtAff E A →* PicEtAff D A` of étale-plus Picard groups over the literally shared

  étale-cover index (`picEtAffHom`).'
file: AlgebraicJacobian/Picard/PicEtAffTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.RelPicTransportFamily
type: lean
updated: '2026-07-29T15:31:47'
---
structure RelPicTransportFamily (kT : Type u) [Field kT] [Algebra kD kT] [Algebra kE kT]
    (D : Over (Spec (.of kD))) (E : Over (Spec (.of kE))) where
  /-- The underlying family of scheme morphisms between the product carriers. -/
  hom : ∀ (B : Type u) [CommRing B] [Algebra kD B] [Algebra kE B] [Algebra kT B]
    [IsScalarTower kD kT B] [IsScalarTower kE kT B],
    (D ⊗ overSpec kD B).left ⟶ (E ⊗ overSpec kE B).left
  /-- The family commutes with the second projections (both carriers project to the
  shared scheme `Spec B`). -/
  hom_snd : ∀ (B : Type u) [CommRing B] [Algebra kD B] [Algebra kE B] [Algebra kT B]
    [IsScalarTower kD kT B] [IsScalarTower kE kT B],
    hom B ≫ (snd E (overSpec kE B)).left = (snd D (overSpec kD B)).left
  /-- The family is natural against restriction along any pair of algebra maps over the
  two base fields with equal underlying functions. -/
  hom_naturality : ∀ (B B' : Type u) [CommRing B] [Algebra kD B] [Algebra kE B]
    [Algebra kT B] [IsScalarTower kD kT B] [IsScalarTower kE kT B]
    [CommRing B'] [Algebra kD B'] [Algebra kE B'] [Algebra kT B']
    [IsScalarTower kD kT B'] [IsScalarTower kE kT B']
    (fD : B →ₐ[kD] B') (fE : B →ₐ[kE] B'), (∀ b, fD b = fE b) →
    hom B' ≫ (E ◁ Over.overSpecMap fE).left
      = (D ◁ Over.overSpecMap fD).left ≫ hom B

namespace RelPicTransportFamily

variable {kT : Type u} [Field kT] [Algebra kD kT] [Algebra kE kT]
variable {D : Over (Spec (.of kD))} {E : Over (Spec (.of kE))}
variable (T : RelPicTransportFamily kT D E)

noncomputable section

/-! ## The relative Picard transport -/

section RelPicHom

variable (B : Type u) [CommRing B] [Algebra kD B] [Algebra kE B] [Algebra kT B]
  [IsScalarTower kD kT B] [IsScalarTower kE kT B]