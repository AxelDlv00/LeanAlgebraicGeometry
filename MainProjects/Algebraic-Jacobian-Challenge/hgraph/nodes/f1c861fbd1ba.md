---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.FGDescent.rTensorAlgHom_tmul
file: AlgebraicJacobian/Picard/FinitePresentationFunctor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.FGDescent.rTensorAlgHom_tmul
type: lean
updated: '2026-07-16T21:14:26'
---
lemma rTensorAlgHom_tmul {R R' : Type w} [CommRing R] [CommRing R']
    [Algebra k R] [Algebra k R'] (ρ : R →ₐ[k] R')
    (B : Type v) [CommRing B] [Algebra k B] (r : R) (b : B) :
    rTensorAlgHom ρ B (r ⊗ₜ b) = ρ r ⊗ₜ b :=
  rfl