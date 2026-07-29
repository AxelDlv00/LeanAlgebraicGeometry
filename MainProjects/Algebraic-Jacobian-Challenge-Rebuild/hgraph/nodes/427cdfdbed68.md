---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.exists_flat_pieceTrivialization_of_le
docstring: '**Localize-and-flatten** ((C2) effectivity, brick E4): every point of
  a trivialized

  piece lies in a basic affine subpiece carrying a **flat** trivialization — one whose

  glued comparison unit is `1`.  The avoidance brick at the germ prime of the point
  makes

  the descended class trivial after restriction (`pieceDescentClass_res`), and flattening

  produces the trivialization.'
file: AlgebraicJacobian/Picard/EffectivityOverlap.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.exists_flat_pieceTrivialization_of_le
type: lean
updated: '2026-07-29T15:26:18'
---
theorem exists_flat_pieceTrivialization_of_le [Module.FaithfullyFlat A B]
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    {𝒩 : (XB).PointedCover} {γ : (XB).unitsCocycle 𝒩}
    (W : NormalizedCechComparison k A B C σ 𝒩 γ) {V₁ : (XA).Opens}
    (hV₁ : IsAffineOpen V₁) (T₁ : PieceTrivialization C 𝒩 γ V₁) {x : XA}
    (hx : x ∈ V₁) :
    ∃ (V : (XA).Opens) (_ : IsAffineOpen V), x ∈ V ∧
      ∃ T : PieceTrivialization C 𝒩 γ V, pieceComparisonUnit C σ W T = 1 := by
  classical
  -- the germ prime of `x` over `V₁`
  set p : Ideal Γ(XA, V₁) :=
    Ideal.comap ((XA).presheaf.germ V₁ x hx).hom
      (IsLocalRing.maximalIdeal ((XA).presheaf.stalk x)) with hp
  haveI : p.IsPrime := Ideal.IsPrime.comap _
  -- the avoidance brick at the single prime `p`
  obtain ⟨f, hfp, hfree⟩ := Module.Invertible.exists_notMem_isUnit_free
    (pieceDescentClass C σ W hV₁ T₁).AsModule (fun _ : PUnit.{u+1} => p)
  set V : (XA).Opens := (XA).basicOpen f with hV'
  have hV : IsAffineOpen V := hV₁.basicOpen f
  have hle : V ≤ V₁ := (XA).basicOpen_le f
  have hxV : x ∈ V := by
    rw [hV', Scheme.mem_basicOpen (XA) f x hx]
    by_contra hnu
    exact hfp PUnit.unit (by
      rw [hp, Ideal.mem_comap]
      exact (IsLocalRing.mem_maximalIdeal _).mpr (mem_nonunits_iff.mpr hnu))
  -- the restricted descended class is trivial
  have hres : pieceDescentClass C σ W hV (T₁.res C hle) = 1 := by
    rw [pieceDescentClass_res C σ W hV₁ hV hle T₁]
    letI := sectionsResAlgebra C hle
    haveI := hfree Γ(XA, V) ((XA).toRingedSpace.isUnit_res_basicOpen f)
    rw [CommRing.Pic.mapAlgebra_apply]
    exact CommRing.Pic.mk_eq_one _ _
  obtain ⟨T, hT⟩ := exists_pieceComparisonUnit_eq_one C σ W hV (T₁.res C hle) hres
  exact ⟨V, hV, hxV, T, hT⟩