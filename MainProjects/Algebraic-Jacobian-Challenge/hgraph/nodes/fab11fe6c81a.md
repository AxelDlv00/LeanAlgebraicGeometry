---
author: sync
content_type: instance
created: '2026-07-27T22:48:27'
decl: AlgebraicGeometry.Adelic.instIsStandardSmoothOfRelativeDimensionOnePolynomial
docstring: '`R[T]` is standard smooth of relative dimension one over `R`.'
file: AlgebraicJacobian/Picard/RigidPushforwardP1Witness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.instIsStandardSmoothOfRelativeDimensionOnePolynomial
type: lean
updated: '2026-07-29T11:05:41'
---
instance instIsStandardSmoothOfRelativeDimensionOnePolynomial (R : Type u) [CommRing R] :
    Algebra.IsStandardSmoothOfRelativeDimension 1 R (Polynomial R) :=
  Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1)
    (MvPolynomial.uniqueAlgEquiv R Unit)

/-! ### §2.2. The chart section rings, and the conclusion -/

section Charts

open Opposite

/-- The `k`-algebra structure on a chart section ring of `ℙ¹_k`, as an `Over (Spec k)` object.
Local to this section: it is the structure `p1ChartSectionsAlgEquivX`/`Y` are stated for. -/
noncomputable local instance instAlgebraP1ChartSections (i : ULift.{u} (Fin 2)) :
    Algebra k Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k i) :=
  Scheme.toModuleKSheaf.algebraSection
    (Over.mk (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)) ↘ Spec (CommRingCat.of k)))
    (op (p1Chart k i))

/-- Each standard chart ring of `ℙ¹_k` is standard smooth of relative dimension one over `k` —
it *is* `k[T]` (`Picard/RigidPushforwardP1ChartSections.lean`), and §2.1 applies.

`local`, deliberately: its statement mentions the `local` algebra structure above, so a global
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