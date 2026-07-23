---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.awayMap_coord_mul_eq_one
docstring: 'The image of the coordinate `Xⱼ/Xᵢ` under the away-restriction `Away 𝒜
  Xᵢ → Away 𝒜 (X₀X₁)`

  computed on the standard chart pair: `awayMap` of the two coordinate fractions multiply
  to `1`

  in `Away 𝒜 (X₀X₁)` (both are `X₀X₁`-fractions and mutually inverse), stated through
  the

  hoisted product `p1XY`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/P1ChartData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.awayMap_coord_mul_eq_one
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma awayMap_coord_mul_eq_one :
    HomogeneousLocalization.awayMap (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
        (ProjTwist.X_mem_deg_one (ULift.{u} (Fin 2)) ⟨1⟩)
        (rfl : p1XY = X (⟨0⟩ : ULift.{u} (Fin 2)) * X (⟨1⟩ : ULift.{u} (Fin 2)))
        (p1CoordAway (ULift.{u} (Fin 2)) ⟨0⟩ ⟨1⟩)
      * HomogeneousLocalization.awayMap (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
          (ProjTwist.X_mem_deg_one (ULift.{u} (Fin 2)) ⟨0⟩)
          p1XY_eq_comm
          (p1CoordAway (ULift.{u} (Fin 2)) ⟨1⟩ ⟨0⟩) = 1 :=
  awayMap_coord_mul_eq_one_aux rfl p1XY_eq_comm