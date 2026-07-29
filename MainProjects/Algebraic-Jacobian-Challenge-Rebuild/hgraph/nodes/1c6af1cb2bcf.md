---
author: sync
content_type: definition
created: '2026-07-28T13:42:18'
decl: AlgebraicGeometry.stalkHomCompatEquivAlgHom
docstring: 'Step 3 of `overDualNumberAtEquivAlgHom`: ring homomorphisms out of the

  stalk compatible with the structure homomorphisms are exactly the

  `k`-algebra homomorphisms.'
file: AlgebraicJacobian/Tangent/TangentStalkAlgebra.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.stalkHomCompatEquivAlgHom
type: lean
updated: '2026-07-29T15:26:11'
---
noncomputable def stalkHomCompatEquivAlgHom
    (X : Over (Spec (CommRingCat.of k))) (x : X.left) :
    {q : {φ : X.left.presheaf.stalk x ⟶ CommRingCat.of (DualNumber k) //
          ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ.hom a) = 0} //
        stalkStructureHom X.hom x ≫ q.1
          = CommRingCat.ofHom (algebraMap k (DualNumber k))}
      ≃ {φ : X.left.presheaf.stalk x →ₐ[k] DualNumber k //
          ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ a) = 0} where
  toFun q :=
    ⟨⟨q.1.1.hom, fun c => DFunLike.congr_fun (congrArg CommRingCat.Hom.hom q.2) c⟩, q.1.2⟩
  invFun φ :=
    ⟨⟨CommRingCat.ofHom φ.1.toRingHom, φ.2⟩,
      CommRingCat.hom_ext (RingHom.ext fun c => φ.1.commutes c)⟩
  left_inv _ := rfl
  right_inv _ := Subtype.ext (AlgHom.ext fun _ => rfl)