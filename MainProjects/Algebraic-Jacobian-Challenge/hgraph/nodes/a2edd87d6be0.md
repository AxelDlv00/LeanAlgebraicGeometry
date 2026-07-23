---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.biproduct_matrix_comp
docstring: 'Composition of two `biproduct.matrix` morphisms is the matrix of pointwise
  sums of

  composites — the categorical matrix product. Project-local helper for `matrixEnd_comp`.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.biproduct_matrix_comp
type: lean
updated: '2026-07-24T03:02:11'
---
private lemma biproduct_matrix_comp {S : Scheme.{0}} {d : ℕ}
    (mM mN : Fin d → Fin d →
      (SheafOfModules.unit S.ringCatSheaf ⟶ SheafOfModules.unit S.ringCatSheaf)) :
    biproduct.matrix (f := fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf)
        (g := fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf) mM ≫ biproduct.matrix mN
      = biproduct.matrix (fun i q => ∑ p, mM i p ≫ mN p q) := by
  refine biproduct.hom_ext' _ _ (fun i => biproduct.hom_ext _ _ (fun q => ?_))
  simp only [Category.assoc, biproduct.ι_matrix_assoc, biproduct.matrix_π, biproduct.lift_desc,
    biproduct.ι_matrix, biproduct.lift_π]