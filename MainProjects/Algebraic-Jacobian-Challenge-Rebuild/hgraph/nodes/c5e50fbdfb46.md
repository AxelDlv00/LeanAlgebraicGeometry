---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.termFamily_cover
docstring: The base-changed family covers the base-changed chart.
file: AlgebraicJacobian/Cohomology/GluedSheafTermBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.termFamily_cover
type: lean
updated: '2026-07-30T15:46:00'
---
lemma termFamily_cover (hspan : Ideal.span (Set.range h) = ⊤) :
    ((fst C (overSpec k B')).left ⁻¹ᵁ V : (relCurve C B').Opens) ≤
      ⨆ i : ι, (relCurve C B').basicOpen (termFamily B' V h i) := by
  have hsup := iSup_basicOpen_of_span_eq_top
    ((fst C (overSpec k B')).left ⁻¹ᵁ V : (relCurve C B').Opens)
    (Set.range (termFamily B' V h)) (termFamily_span B' V h hspan)
  conv_lhs => rw [← hsup]
  refine iSup₂_le_iff.mpr fun g hg => ?_
  obtain ⟨i, rfl⟩ := hg
  exact le_iSup (fun i => (relCurve C B').basicOpen (termFamily B' V h i)) i

end Terms

section Comparison

variable (V : C.left.Opens)
variable [Scheme.QcohOn D.sheaf ((fst C (overSpec k B)).left ⁻¹ᵁ V)]
variable [Scheme.QcohOn (D.baseChange B').sheaf ((fst C (overSpec k B')).left ⁻¹ᵁ V)]