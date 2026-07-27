---
author: sync
content_type: instance
created: '2026-07-27T16:23:54'
decl: AlgebraicGeometry.Adelic.here
file: AlgebraicJacobian/Picard/RigidPushforwardP1Witness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.here
type: lean
updated: '2026-07-28T00:32:01'
---
instance here would export a term that nothing downstream could re-derive. -/
local instance instIsStandardSmoothOfRelativeDimensionOneP1ChartSections
    (i : ULift.{u} (Fin 2)) :
    Algebra.IsStandardSmoothOfRelativeDimension 1 k
      Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k i) := by
  have e : Polynomial k ≃ₐ[k]
      Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k i) := by
    obtain ⟨i⟩ := i
    match i with
    | 0 => exact (p1ChartSectionsAlgEquivX k).symm
    | 1 => exact (p1ChartSectionsAlgEquivY k).symm
  exact Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1) e