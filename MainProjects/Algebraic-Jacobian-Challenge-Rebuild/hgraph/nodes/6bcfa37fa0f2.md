---
author: sync
content_type: theorem
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.mul_mem_unitGluedSubmodule
docstring: '**Twists multiply**: the componentwise product of a `u`-twisted and a
  `v`-twisted glued

  family is `(u * v)`-twisted.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.mul_mem_unitGluedSubmodule
type: lean
updated: '2026-07-31T20:15:24'
---
theorem mul_mem_unitGluedSubmodule {s t : A.chartProd}
    (hs : s ∈ unitGluedSubmodule A u) (ht : t ∈ unitGluedSubmodule A v) :
    s * t ∈ unitGluedSubmodule A (u * v) := by
  rw [mem_unitGluedSubmodule_iff] at hs ht ⊢
  intro p
  have h1 : (s * t) p.1 = s p.1 * t p.1 := rfl
  have h2 : (s * t) p.2 = s p.2 * t p.2 := rfl
  have h3 : (((u * v) p.1 p.2 : Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)ˣ) :
      Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2))
      = ((u p.1 p.2 : Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)ˣ) :
          Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2))
        * ((v p.1 p.2 : Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)ˣ) :
          Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)) := rfl
  rw [h1, h2, h3, map_mul, map_mul, map_mul, hs p, ht p]
  ring

variable (u) in