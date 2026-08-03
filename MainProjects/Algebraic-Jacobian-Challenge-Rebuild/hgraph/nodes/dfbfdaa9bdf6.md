---
author: sync
content_type: theorem
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.component_relAffSectionsMap_mem_nonZeroDivisors
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveEffectivity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.component_relAffSectionsMap_mem_nonZeroDivisors
type: lean
updated: '2026-08-03T18:38:51'
---
theorem component_relAffSectionsMap_mem_nonZeroDivisors
    (hfib : ∀ (j : D.index) (p : PrimeSpectrum B), Function.Injective
      ((Scheme.mulSectionEnd B (D.component s j)).rTensor p.asIdeal.ResidueField))
    (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
    [IsScalarTower k B B'] (j : D.index) :
    relAffSectionsMap C B' (D.pieces j) (D.component s j) ∈
      nonZeroDivisors Γ(relCurve C B', relCurveMap C B B' ⁻¹ᵁ D.pieces j) := by
  letI : Algebra B Γ(relCurve C B, D.pieces j) :=
    ((relCurve C B).overAlgebraMap B (D.pieces j)).toAlgebra
  letI : Module.Flat B Γ(relCurve C B, D.pieces j) :=
    flat_sections_isAffineOpen C B (D.isAffineOpen_pieces j)
  have hbase :=
    Algebra.TensorProduct.includeRight_mem_nonZeroDivisors_of_forall_tmul_residueField
      (fun p => D.component_tmul_one_mem_nonZeroDivisors s hfib j p) B'
  have hpulled := map_mem_nonZeroDivisors'
    (relSectionsBaseChangeAff C B' (D.isAffineOpen_pieces j)).toRingEquiv hbase
  have hmap : (relSectionsBaseChangeAff C B' (D.isAffineOpen_pieces j)).toRingEquiv
      (Algebra.TensorProduct.includeRight (D.component s j)) =
        relAffSectionsMap C B' (D.pieces j) (D.component s j) := by
    rw [Algebra.TensorProduct.includeRight_apply]
    exact relSectionsBaseChangeAff_one_tmul C B'
      (D.isAffineOpen_pieces j) (D.component s j)
  rwa [hmap] at hpulled

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] in