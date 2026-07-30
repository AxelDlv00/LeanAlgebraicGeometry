---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.Scheme.presentationDivisor_eq_of_divEq
docstring: '**DivEq-invariance of the presentation divisor.** Two divisor-equal local-equation
  systems

  (`Scheme.LocalEquations.DivEq`: a common refinement on which the equations agree
  up to units at

  every point) cut out the same Weil divisor. Finer than `picClass_eq_of_divEq`: the
  order of the

  equation at a closed point only changes by the trivial order of a unit germ.'
file: AlgebraicJacobian/Picard/DivisorFamilyField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.presentationDivisor_eq_of_divEq
type: lean
updated: '2026-07-30T15:46:04'
---
theorem presentationDivisor_eq_of_divEq {d₁ d₂ : X.LocalEquations}
    (h : LocalEquations.DivEq d₁ d₂) :
    presentationDivisor K d₁.presentation = presentationDivisor K d₂.presentation := by
  obtain ⟨𝒲, h₁, h₂, H⟩ := h
  refine CurveDivisor.ext_coeffAt fun x hx => ?_
  rw [coeffAt_presentationDivisor, coeffAt_presentationDivisor]
  obtain ⟨u, hu⟩ := H x
  -- the trivializing element of `d₁` is the unit germ of `u` times that of `d₂`
  have hkey : d₁.presentation.elem x
      = germGenericUnits (𝒲.genericPoint_mem_opens x) u * d₂.presentation.elem x := by
    refine Units.ext ?_
    rw [Units.val_mul, germGenericUnits_val, LocalEquations.presentation_elem_val,
      LocalEquations.presentation_elem_val,
      ← X.presheaf.germ_res_apply (homOfLE (h₁ x)) (genericPoint X)
        (𝒲.genericPoint_mem_opens x) (d₁.eqn x),
      ← X.presheaf.germ_res_apply (homOfLE (h₂ x)) (genericPoint X)
        (𝒲.genericPoint_mem_opens x) (d₂.eqn x), ← map_mul, ← hu]
  rw [hkey, map_mul,
    ordZ_germGenericUnits K (𝒲.genericPoint_mem_opens x) u hx (𝒲.mem_opens x), one_mul]