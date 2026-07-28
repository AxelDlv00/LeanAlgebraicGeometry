---
author: sync
content_type: theorem
created: '2026-07-29T07:37:18'
decl: AlgebraicGeometry.hasWitnessH1Vanishing_of_isSplitWitness_tower
docstring: '**The descent step, with the `A`-tower in `hplus`''s binder** — otherwise

  `hasWitnessH1Vanishing_of_isSplitWitness_at` verbatim.


  The landed form asks for the plus-class identity at *every* `A`-algebra structure
  on `L`; this

  asks for it only at those compatible with `A → κ(t) → L`, which is all its proof
  ever uses and

  all that `hfib` can give (see the section note above).  With this binder the transport

  `isChartDatumPlusFibreAt_of_isScalarTower` applies, and CHART-U(b)''s residue follows
  from `hfib`

  alone.'
file: AlgebraicJacobian/Picard/Pic0ChartPlusFibreTower.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.hasWitnessH1Vanishing_of_isSplitWitness_tower
type: lean
updated: '2026-07-29T07:37:18'
---
theorem hasWitnessH1Vanishing_of_isSplitWitness_tower {A : Type u} [CommRing A] [Algebra k A]
    (μ : picEt C (overSpec k A)) (D : BasicOpenCocycleDatum C A π)
    (t : (overSpec k A).left)
    (hplus : ∀ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (_ : Algebra (Over.testPointField (T := overSpec k A) t) L)
      (_ : IsScalarTower k (Over.testPointField (T := overSpec k A) t) L)
      (_ : Algebra A L) (_ : IsScalarTower k A L)
      (_ : IsScalarTower A (Over.testPointField (T := overSpec k A) t) L),
      IsChartDatumPlusFibreAt C π μ D t L)
    (h : IsSplitWitness C (picEtMap C (Over.testPoint t) μ)) :
    D.HasWitnessH1Vanishing (Over.testPointField (T := overSpec k A) t) := by
  obtain ⟨L, hLf, hLk, hLK, hLtow, hLfin, hLsep, M, hM, W, hW, hW1⟩ := h
  obtain ⟨hAL, hAtow, hATow⟩ := towerOfResidueFieldExtension (k := k) t L
  have hid : PicEtAff.unit C L (relPicMk C (overSpec k L) M)
      = PicEtAff.unit C L
        (relPicMk C (overSpec k L)
          (Scheme.CechPic.map (relCurveMap C A L) D.cechPicClass)) := by
    rw [← hM]
    exact hplus L hLf hLk hLK hLtow hAL hAtow hATow
  have hMcl : M = Scheme.CechPic.map (relCurveMap C A L) D.cechPicClass :=
    relPicMk_injective_of_subsingleton C (overSpec k L)
      (PicEtAff.unit_injective C L hid)
  refine (D.hasWitnessH1Vanishing_iff_of_fieldExtension
    (Over.testPointField (T := overSpec k A) t) L).mpr ⟨W, ?_, hW1⟩
  rw [hW, hMcl]

/-! ## CHART-U(b)'s residue from `hfib` alone -/

variable (C π) in