---
author: sync
content_type: theorem
created: '2026-07-29T22:53:22'
decl: AlgebraicGeometry.restrictedChartFibre_bot
docstring: "**`RestrictedChartFibre` at `V = ⊥` is inhabited, with no hypotheses beyond\
  \ the data the\nstatement mentions.**\n\nTake `W := ⊥` as well.  Then:\n\n* `r`\
  \ is the unique map out of an empty scheme (`isInitialOfIsEmpty`);\n* `sq` is an\
  \ equality of natural transformations out of `yoneda.obj ↑⊥`; after `ext S x` the\n\
  \  morphism `x : S.unop ⟶ ↑⊥` forces `S.unop` empty, and\n  `pic0Sigma_obj_subsingleton_of_isEmpty`\
  \ closes it;\n* `exists_factor` is free: `v : S ⟶ ↑⊥` forces `S` empty, hence initial,\
  \ so the factoring map\n  and both compatibilities are unique.\n\n**Why this is\
  \ worth landing rather than just knowing.**  `Pic0ChartRestrictedFibre.lean` said\
  \ a\nlane picking up that row \"should produce that witness first … it decides whether\
  \ the repair is\nreal\".  It does, and the answer is yes: the class is not empty,\
  \ so the repaired route to\n`IsChartUniv` is not a route to an uninhabitable hypothesis."
file: AlgebraicJacobian/Picard/Pic0ChartRestrictedFibreSat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.restrictedChartFibre_bot
type: lean
updated: '2026-08-01T09:44:16'
---
theorem restrictedChartFibre_bot {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    RestrictedChartFibre C π n rep m Z hdeg ⊥ := by
  intro T g
  refine ⟨⟨⊥, isInitialOfIsEmpty.to _, ?_, ?_⟩⟩
  · ext S x
    have : IsEmpty (S.unop : Scheme.{u}) := x.base.hom.1.isEmpty
    exact (pic0Sigma_obj_subsingleton_of_isEmpty (C := C) S.unop).elim _ _
  · intro S v w _
    have : IsEmpty S := v.base.hom.1.isEmpty
    exact ⟨isInitialOfIsEmpty.to _, isInitialOfIsEmpty.hom_ext _ _,
      isInitialOfIsEmpty.hom_ext _ _⟩

variable (C) in