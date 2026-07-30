---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.tripleQuotientMap
docstring: The quotient map from the source triple intersection to its quotient open.
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.tripleQuotientMap
type: lean
updated: '2026-07-31T02:29:39'
---
noncomputable def tripleQuotientMap [FiniteDimensional K L]
    (i j k : StableAffineOpen ρ) :
    ((i.U ⊓ j.U) ⊓ (i.U ⊓ k.U)).toScheme ⟶
      quotientTriple ρ i j k := by
  letI := ρ.sectionsMulSemiringAction i.stable
  letI := SemilinearGalAction.sectionsAlgebra f i.U
  letI := SemilinearGalAction.sectionsAlgebraK (K := K) f i.U
  letI := SemilinearGalAction.sections_isScalarTower (K := K) f i.U
  letI := ρ.isSemilinear_sections i.stable
  exact SemilinearGalAction.stableAffineQuotientMapRestrict
    ρ i.stable i.affine (le_trans inf_le_left inf_le_left)
      (triple_stable ρ i j k)

/-- The triple-overlap projection followed by its chart inclusion is the
ambient affine quotient map restricted from the source triple intersection. -/
@[reassoc]