---
author: sync
content_type: theorem
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.descentEquiv_tmul
file: AlgebraicJacobian/Descent/AlgebraDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.descentEquiv_tmul
type: lean
updated: '2026-08-01T13:18:07'
---
theorem descentEquiv_tmul (D : DescentDatum A B R) [Module.Flat A B]
    (b : B) (x : D.descended) :
    D.descentEquiv (b ⊗ₜ x) = b • (x : R) :=
  D.comparison_tmul b x

variable {S T : Type u} [CommRing S] [CommRing T]
  [Algebra A S] [Algebra B S] [IsScalarTower A B S]
  [Algebra A T] [Algebra B T] [IsScalarTower A B T]