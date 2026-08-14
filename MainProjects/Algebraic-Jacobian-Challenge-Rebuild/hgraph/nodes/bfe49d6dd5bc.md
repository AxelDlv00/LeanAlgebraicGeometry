---
author: sync
content_type: theorem
created: '2026-08-14T14:17:16'
decl: AlgebraicGeometry.pointwiseCoverage_of_residueField
docstring: 'A family of representable open immersions covers pointwise as soon as
  it covers the class at

  every residue-field point.  Relative representability pulls a chosen field factorization
  back to

  an open immersion over the test; its open range is the required neighborhood.'
file: AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pointwiseCoverage_of_residueField
type: lean
updated: '2026-08-14T14:17:16'
---
theorem pointwiseCoverage_of_residueField
    {I : Type u} {X : I → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (hf : ∀ i, IsOpenImmersion.presheaf (f i))
    (hfield : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : T),
      ∃ (Y : Scheme.{u}) (q : Y) (y : Y ⟶ T) (i : I) (x : Y ⟶ X i),
        y.base q = t ∧
          (f i).app (op Y) x = (pic0SigmaSheaf C).1.map y.op s) :
    PointwiseCoverage C f := by
  intro T s t
  obtain ⟨Y, q, y, i, x, hyt, hx⟩ := hfield T s t
  let g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1 := yonedaEquiv.symm s
  obtain ⟨Z, snd, fst, hpb⟩ := (hf i).rep g
  letI : IsOpenImmersion snd := (hf i).property g fst snd hpb
  have hpbY := (IsPullback.iff_app.mp hpb) (op Y)
  rw [Types.isPullback_iff] at hpbY
  have hg : g.app (op Y) y = (pic0SigmaSheaf C).1.map y.op s := by
    exact yonedaEquiv_symm_app_apply s _ y
  obtain ⟨z, hz₁, hz₂⟩ := hpbY.2.2 x y (hx.trans hg.symm)
  let W : T.Opens := snd.opensRange
  have htW : t ∈ W := by
    change t ∈ snd.opensRange
    apply Scheme.Hom.mem_opensRange.mpr
    refine ⟨z.base q, ?_⟩
    have hz := congrArg (fun m : Y ⟶ T => m.base q) hz₂
    exact hz.trans hyt
  refine ⟨W, htW, i, fst.app (op (W : Scheme.{u})) snd.isoOpensRange.inv, ?_⟩
  have hpbW := (IsPullback.iff_app.mp hpb) (op (W : Scheme.{u}))
  rw [Types.isPullback_iff] at hpbW
  have hcomm := congrArg
    (fun q => (ConcreteCategory.hom q) snd.isoOpensRange.inv) hpbW.1
  change (f i).app (op (W : Scheme.{u}))
      (fst.app (op (W : Scheme.{u})) snd.isoOpensRange.inv) = _
  change (f i).app (op (W : Scheme.{u}))
      (fst.app (op (W : Scheme.{u})) snd.isoOpensRange.inv) =
    g.app (op (W : Scheme.{u})) (snd.isoOpensRange.inv ≫ snd) at hcomm
  rw [Scheme.Hom.isoOpensRange_inv_comp] at hcomm
  change (f i).app (op (W : Scheme.{u}))
      (fst.app (op (W : Scheme.{u})) snd.isoOpensRange.inv) =
    (yonedaEquiv.symm s).app (op (W : Scheme.{u})) W.ι at hcomm
  rwa [yonedaEquiv_symm_app_apply] at hcomm

/-! ## The separably closed field-point producer -/

variable [IsSepClosed k]