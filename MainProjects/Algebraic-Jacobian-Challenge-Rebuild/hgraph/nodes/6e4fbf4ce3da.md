---
author: sync
content_type: definition
created: '2026-08-14T14:17:15'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.tripleToOverlapRight
docstring: 'The canonical restriction from a triple quotient open to its right

  pairwise overlap.'
file: AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.tripleToOverlapRight
type: lean
updated: '2026-08-14T14:17:15'
---
noncomputable def tripleToOverlapRight [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    quotientTriple ρ i j k ⟶ quotientOverlap ρ i k := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  unfold quotientTriple quotientOverlap
  exact Scheme.homOfLE _ (quotientTriple_le_overlapRight ρ i j k)

/-- Restricting a triple quotient open to the right pairwise overlap and then
including it recovers the triple inclusion. -/
@[reassoc]