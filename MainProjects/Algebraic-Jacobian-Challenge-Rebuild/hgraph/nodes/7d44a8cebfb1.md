---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.ker_graphSectionEval_eq_primeIdealOf
docstring: '**The point ↔ evaluation dictionary**: on an affine open `W` containing
  the graph

  point, the kernel of the evaluation at the graph section is the prime ideal of the
  graph

  point.  Both inclusions go through the locality of the stalk map of `σ_t`: a section
  is a

  unit at `x_t` exactly when its evaluation is nonzero in the field `F`.'
file: AlgebraicJacobian/RiemannRoch/GraphSectionEval.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ker_graphSectionEval_eq_primeIdealOf
type: lean
updated: '2026-07-30T15:28:00'
---
theorem ker_graphSectionEval_eq_primeIdealOf (t : overSpec k K ⟶ C)
    {W : (C ⊗ overSpec k K).left.Opens} (hW : IsAffineOpen W)
    (hx : Over.graphPoint C t ∈ W) :
    RingHom.ker (graphSectionEval t hx)
      = (hW.primeIdealOf ⟨Over.graphPoint C t, hx⟩).asIdeal := by
  letI : Algebra Γ((C ⊗ overSpec k K).left, W)
      ((C ⊗ overSpec k K).left.presheaf.stalk (Over.graphPoint C t)) :=
    (C ⊗ overSpec k K).left.presheaf.algebra_section_stalk ⟨Over.graphPoint C t, hx⟩
  haveI hloc : IsLocalization.AtPrime
      ((C ⊗ overSpec k K).left.presheaf.stalk (Over.graphPoint C t))
      (hW.primeIdealOf ⟨Over.graphPoint C t, hx⟩).asIdeal :=
    hW.isLocalization_stalk ⟨Over.graphPoint C t, hx⟩
  have hgerm : ∀ f : Γ((C ⊗ overSpec k K).left, W),
      ¬ IsUnit (((C ⊗ overSpec k K).left.presheaf.germ W (Over.graphPoint C t) hx).hom f)
        ↔ f ∈ (hW.primeIdealOf ⟨Over.graphPoint C t, hx⟩).asIdeal := by
    intro f
    rw [show ((C ⊗ overSpec k K).left.presheaf.germ W (Over.graphPoint C t) hx).hom f
        = algebraMap Γ((C ⊗ overSpec k K).left, W)
            ((C ⊗ overSpec k K).left.presheaf.stalk (Over.graphPoint C t)) f from rfl,
      IsLocalization.AtPrime.isUnit_to_map_iff
        ((C ⊗ overSpec k K).left.presheaf.stalk (Over.graphPoint C t))
        (hW.primeIdealOf ⟨Over.graphPoint C t, hx⟩).asIdeal f]
    exact not_not
  -- the germ of the evaluated section on the one-point test
  have hstalk : ∀ f : Γ((C ⊗ overSpec k K).left, W),
      ((overSpec k K).left.presheaf.germ ⊤ default trivial).hom (graphSectionEval t hx f)
        = ((Over.sectionOfPoint t).left.stalkMap default).hom
            (((C ⊗ overSpec k K).left.presheaf.germ W (Over.graphPoint C t) hx).hom f) := by
    intro f
    have h1 : graphSectionEval t hx f
        = ((overSpec k K).left.presheaf.map
            (homOfLE (Over.top_le_sectionOfPoint_preimage t hx)).op).hom
            (((Over.sectionOfPoint t).left.app W).hom f) := rfl
    rw [h1, TopCat.Presheaf.germ_res_apply]
    exact ((Over.sectionOfPoint t).left.germ_stalkMap_apply W default hx f).symm
  refine le_antisymm ?_ ?_
  · -- `ε f = 0 → f ∈ p`: the stalk map preserves units
    intro f hf
    rw [RingHom.mem_ker] at hf
    rw [← hgerm f]
    intro hunit
    have h1 : IsUnit (((overSpec k K).left.presheaf.germ ⊤ default trivial).hom
        (graphSectionEval t hx f)) := by
      rw [hstalk f]
      exact hunit.map ((Over.sectionOfPoint t).left.stalkMap default).hom
    rw [hf, map_zero] at h1
    exact not_isUnit_zero h1
  · -- `f ∈ p → ε f = 0`: the target is a field and the stalk map reflects units
    intro f hf
    rw [RingHom.mem_ker]
    by_contra hne
    have hFunit : IsUnit (graphSectionEval t hx f) := by
      letI : Field Γ((overSpec k K).left, ⊤) := isField_sections_top_overSpec.toField
      exact isUnit_iff_ne_zero.mpr hne
    have h1 : IsUnit (((Over.sectionOfPoint t).left.stalkMap default).hom
        (((C ⊗ overSpec k K).left.presheaf.germ W (Over.graphPoint C t) hx).hom f)) := by
      rw [← hstalk f]
      exact hFunit.map ((overSpec k K).left.presheaf.germ ⊤ default trivial).hom
    have h2 : IsUnit (((C ⊗ overSpec k K).left.presheaf.germ W
        (Over.graphPoint C t) hx).hom f) :=
      isUnit_of_map_unit ((Over.sectionOfPoint t).left.stalkMap default).hom _ h1
    exact ((hgerm f).mpr hf) h2

/-! ## The quotient by the kernel is a copy of `K` -/

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] in