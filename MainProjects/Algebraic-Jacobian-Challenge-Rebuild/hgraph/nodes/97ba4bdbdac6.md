---
author: sync
content_type: theorem
created: '2026-07-31T17:31:52'
decl: AlgebraicGeometry.DivisorAdaptation.cokernelπ_app_eq_zero_of_germ_mem
docstring: "The pointwise range of the theta-ideal sheaf inclusion on global sections\
  \ is exactly\nthe intrinsic, cover-independent divisor-family vanishing submodule.\
  \ -/\ntheorem range_thetaIdealInclApp_top (B : DivisorAdaptation C R π d) (a : ℕ)\
  \ :\n    LinearMap.range (B.thetaIdealInclApp (a := a) ⊤) =\n      d.vanishingSubmodule\
  \ R (relCover C R (fiberTwoCover π)).V₀\n        (relCover C R (fiberTwoCover π)).V₁\
  \ (relThetaCocycle C R π a) := by\n  ext x\n  constructor\n  · rintro ⟨s, rfl⟩\n\
  \    rw [thetaIdealInclApp_top_eq_gluedToVanishing C R π B a s]\n    exact (B.gluedToVanishingₗ\
  \ a s).property\n  · intro hx\n    let y : ↥(d.vanishingSubmodule R (relCover C\
  \ R (fiberTwoCover π)).V₀\n        (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle\
  \ C R π a)) := ⟨x, hx⟩\n    refine ⟨(B.gluedEquivVanishing a).symm y, ?_⟩\n    rw\
  \ [thetaIdealInclApp_top_eq_gluedToVanishing C R π B]\n    exact congrArg Subtype.val\
  \ ((B.gluedEquivVanishing a).apply_symm_apply y)\n\n/-! ## The local cokernel kernel\n\
  \nThe arbitrary-open range producer immediately gives the corresponding kernel fact\
  \ for\nthe sheaf cokernel.  Keeping this at an arbitrary open is useful when the\
  \ intrinsic\ndescent proof compares restrictions before specializing to `⊤`."
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCokernelGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.cokernelπ_app_eq_zero_of_germ_mem
type: lean
updated: '2026-08-01T09:44:13'
---
theorem cokernelπ_app_eq_zero_of_germ_mem (B : DivisorAdaptation C R π d)
    {a : ℕ} {W : (relCurve C R).Opens}
    (x : (relThetaTwistSheaf C R π a).obj.obj (op W))
    (hx0 : ∀ (z : relCurve C R) (hz : z ∈ W ⊓
      (relCover C R (fiberTwoCover π)).V₀),
      ((relCurve C R).presheaf.germ (W ⊓
        (relCover C R (fiberTwoCover π)).V₀) z hz).hom x.val.1 ∈ d.stalkIdeal z)
    (hx1 : ∀ (z : relCurve C R) (hz : z ∈ W ⊓
      (relCover C R (fiberTwoCover π)).V₁),
      ((relCurve C R).presheaf.germ (W ⊓
        (relCover C R (fiberTwoCover π)).V₁) z hz).hom x.val.2 ∈ d.stalkIdeal z) :
    ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app (op W)).hom x = 0 := by
  obtain ⟨s, hs⟩ := B.exists_thetaIdealInclApp_of_germ_mem (a := a) x hx0 hx1
  rw [← hs]
  have hnat := congrArg
    (fun f : (B.thetaIdealDatum a).sheaf ⟶ cokernel (B.thetaIdealIncl (a := a)) =>
      f.hom.app (op W)) (cokernel.condition (B.thetaIdealIncl (a := a)))
  have hlin := congrArg ModuleCat.Hom.hom hnat
  exact LinearMap.congr_fun hlin s

end DivisorAdaptation

/-! ## Restriction through the glued--twist equivalence -/