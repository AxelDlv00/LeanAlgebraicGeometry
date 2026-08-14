---
author: sync
content_type: definition
created: '2026-08-14T14:17:16'
decl: AlgebraicJacobian.GaloisDescent.GaloisEquivariantOver.precomp
docstring: Pull an equivariant map back along a morphism over `Spec K`.
file: AlgebraicJacobian/Picard/Pic0FiniteGaloisDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.GaloisEquivariantOver.precomp
type: lean
updated: '2026-08-14T14:17:16'
---
noncomputable def precomp
    {T T' : Over (Spec (CommRingCat.of K))} (a : T' ⟶ T)
    (h : GaloisEquivariantOver rho T) : GaloisEquivariantOver rho T' where
  hom := pullbackBaseChange K L T.hom T'.hom a.left a.w ≫ h.hom
  commutes := by
    rw [Category.assoc, h.commutes, pullbackBaseChange_snd]
  equivariant := SemilinearGalAction.isEquivariant_pullbackBaseChange_comp
    T.hom T'.hom rho h.equivariant a.left a.w

@[ext]