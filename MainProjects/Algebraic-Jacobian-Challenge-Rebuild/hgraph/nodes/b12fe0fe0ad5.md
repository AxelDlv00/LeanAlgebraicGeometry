---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.productChartSections_naturality
docstring: '**Restriction naturality of the identification, in both factors**: for
  affine opens

  `U'' ≤ U` of `X.left` and `V'' ≤ V` of `T.left`, restricting the identified section
  to

  `𝔚 U'' V''` is identifying the factorwise-restricted tensor. The map on tensor products
  is

  `Algebra.TensorProduct.map` of the two restrictions `Over.resAlgHom`.'
file: AlgebraicJacobian/Curve/ProductCharts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.productChartSections_naturality
type: lean
updated: '2026-07-30T15:46:01'
---
theorem productChartSections_naturality {U U' : X.left.Opens} {V V' : T.left.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V) (hU' : IsAffineOpen U')
    (hV' : IsAffineOpen V') (hUU : U' ≤ U) (hVV : V' ≤ V)
    (x : Γ(X.left, U) ⊗[k] Γ(T.left, V)) :
    (X ⊗ T).left.presheaf.map (homOfLE (productChart_mono X T hUU hVV)).op
        (productChartSections X T hU hV x)
      = productChartSections X T hU' hV'
          (Algebra.TensorProduct.map (Over.resAlgHom X hUU) (Over.resAlgHom T hVV) x) := by
  induction x with
  | zero => simp only [map_zero]
  | add x y hx hy => simp only [map_add, hx, hy]
  | tmul s t =>
    rw [Algebra.TensorProduct.map_tmul, Over.resAlgHom_apply, Over.resAlgHom_apply,
      productChartSections_tmul, productChartSections_tmul, map_mul]
    congr 1
    · rw [← CommRingCat.comp_apply, Scheme.Hom.appLE_map, ← CommRingCat.comp_apply,
        Scheme.Hom.map_appLE]
    · rw [← CommRingCat.comp_apply, Scheme.Hom.appLE_map, ← CommRingCat.comp_apply,
        Scheme.Hom.map_appLE]

/-! ## The lift-app rule (D5 (iii)) -/

variable {X T} in