---
author: sync
content_type: definition
created: '2026-08-01T13:18:07'
decl: AlgebraicGeometry.pic0GaloisActionRestricted
docstring: The action on the `k`-Picard-zero functor restricted to `L`-tests.
file: AlgebraicJacobian/Picard/Pic0GaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0GaloisActionRestricted
type: lean
updated: '2026-08-01T13:18:07'
---
noncomputable def pic0GaloisActionRestricted (gamma : L ≃ₐ[k] L) :
    (pic0TwistTestFunctor gamma).op ⋙
        ((pic0GaloisRestrictTest (k := k) (L := L)).op ⋙
          pic0TypeFunctor C) ≅
      (pic0GaloisRestrictTest (k := k) (L := L)).op ⋙
        pic0TypeFunctor C :=
  (Functor.associator _ _ _).symm ≪≫
    Functor.isoWhiskerRight
      (NatIso.op (pic0GaloisRestrictTwistIso gamma)).symm
      (pic0TypeFunctor C)