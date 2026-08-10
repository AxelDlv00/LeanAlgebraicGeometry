---
author: sync
content_type: theorem
created: '2026-08-10T13:01:42'
decl: AlgebraicGeometry.PicRankOneFibrePresentationInput.picRankOneOpen_isOpen_of_evaluationDivisorPullbackFamilies
docstring: "Assemble the public fibre presentation from the represented canonical\
  \ evaluation-divisor\nsquare.  Its `exists_factor` field is derived from the pullback\
  \ universal property. -/\nnoncomputable def toFibrePresented_of_evaluationDivisorPullback\n\
  \    (F : PicRankOneFibrePresentationInput pi E g)\n    (hpb : F.EvaluationDivisorPullback)\
  \ :\n    PicRankOneOpen.FibrePresented pi g where\n  W := F.W\n  fst := F.fst\n\
  \  sq := F.fst_comp_incl\n  exists_factor := by\n    simpa only [FibreFactorizationClause]\
  \ using\n      F.fibreFactorizationClause_of_evaluationDivisorPullback hpb\n\n@[simp]\n\
  lemma toFibrePresented_of_evaluationDivisorPullback_W\n    (F : PicRankOneFibrePresentationInput\
  \ pi E g)\n    (hpb : F.EvaluationDivisorPullback) :\n    (F.toFibrePresented_of_evaluationDivisorPullback\
  \ hpb).W = F.W :=\n  rfl\n\nlemma toFibrePresented_of_evaluationDivisorPullback_isPullback\n\
  \    (F : PicRankOneFibrePresentationInput pi E g)\n    (hpb : F.EvaluationDivisorPullback)\
  \ :\n    IsPullback F.fst (yoneda.map F.W.ι) (picRankOneOpenSigmaIncl pi) g :=\n\
  \  (F.toFibrePresented_of_evaluationDivisorPullback hpb).isPullback\n\n/-! ## Immediate\
  \ openness consumer"
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneFibrePresentationInput.picRankOneOpen_isOpen_of_evaluationDivisorPullbackFamilies
type: lean
updated: '2026-08-10T13:01:42'
---
theorem picRankOneOpen_isOpen_of_evaluationDivisorPullbackFamilies
    (E : PicRankOneEvaluationDivisorData pi)
    (D : ∀ (X : Scheme.{u})
      (g : yoneda.obj X ⟶ rankOneAmbient (C := C)),
      PicRankOneFibrePresentationInput pi E g)
    (hpb : ∀ (X : Scheme.{u})
      (g : yoneda.obj X ⟶ rankOneAmbient (C := C)),
      (D X g).EvaluationDivisorPullback) :
    PicRankOneOpen.IsOpen pi := by
  apply picRankOneOpen_isOpen_of_fibrePresented pi
  intro X g
  exact (D X g).toFibrePresented_of_evaluationDivisorPullback (hpb X g)