---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.fibreMulAux
docstring: '(Implementation) The multiplication comparison induced by a pullback homomorphism

  `ψ` compatible with the structure actions: `a ⊗ c ↦ ψ a · ρ c`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedFibre.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.fibreMulAux
type: lean
updated: '2026-07-29T15:26:31'
---
private noncomputable def fibreMulAux {A B : Type u} [CommRing A] [CommRing B]
    [Algebra R A] (ψ : A →+* B) (ρ : R' →+* B)
    (hψρ : ∀ r : R, ψ (algebraMap R A r) = ρ (algebraMap R R' r)) :
    A ⊗[R] R' →+* B :=
  letI : Algebra R' B := ρ.toAlgebra
  letI : Algebra R B := (ρ.comp (algebraMap R R')).toAlgebra
  haveI : IsScalarTower R R' B := IsScalarTower.of_algebraMap_eq' rfl
  (Algebra.TensorProduct.productMap
    { toRingHom := ψ, commutes' := hψρ } (IsScalarTower.toAlgHom R R' B)).toRingHom

set_option synthInstance.maxHeartbeats 200000 in
-- tensor-algebra instance assembly exceeds the lakefile default