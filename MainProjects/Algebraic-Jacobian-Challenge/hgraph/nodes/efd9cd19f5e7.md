---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.overlapCocycle_
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.overlapCocycle_
type: lean
updated: '2026-07-24T03:02:13'
---
lemma AffineCoverMVSquare.overlapCocycle_π (j : Fin 2 → ULift.{u} (Fin 2)) :
    S.overlapCocycle F ≫ Pi.π (cechTerm S.coverFamily F 2) j
      = S.overlapCocycleComponent F j :=
  Pi.lift_π _ _