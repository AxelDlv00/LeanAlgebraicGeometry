---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.fibreMulAux_tmul
file: AlgebraicJacobian/Picard/DivSchemeSeedFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.fibreMulAux_tmul
type: lean
updated: '2026-07-17T16:57:13'
---
private lemma fibreMulAux_tmul {A B : Type u} [CommRing A] [CommRing B]
    [Algebra R A] (ψ : A →+* B) (ρ : R' →+* B)
    (hψρ : ∀ r : R, ψ (algebraMap R A r) = ρ (algebraMap R R' r))
    (a : A) (c : R') :
    fibreMulAux ψ ρ hψρ (a ⊗ₜ c) = ψ a * ρ c := by
  letI : Algebra R' B := ρ.toAlgebra
  letI : Algebra R B := (ρ.comp (algebraMap R R')).toAlgebra
  haveI : IsScalarTower R R' B := IsScalarTower.of_algebraMap_eq' rfl
  exact Algebra.TensorProduct.productMap_apply_tmul
    { toRingHom := ψ, commutes' := hψρ } (IsScalarTower.toAlgHom R R' B) a c

end MulAux

set_option synthInstance.maxHeartbeats 400000 in
-- tensor-algebra instance searches on the large section rings exceed the lakefile default