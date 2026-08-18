---
author: sync
content_type: theorem
created: '2026-08-14T10:32:16'
decl: AlgebraicGeometry.PicRankOneLocalPresentation.exists_carrier_divFamZarAff_abel
docstring: A rank-one presentation carries an Abel-correct divisor on its etale carrier.
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorCarrierWitness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneLocalPresentation.exists_carrier_divFamZarAff_abel
type: lean
updated: '2026-08-18T20:51:05'
---
theorem exists_carrier_divFamZarAff_abel
    (P : PicRankOneLocalPresentation pi lam)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    ∃ F : DivFamZarAff C P.cover.Carrier (genus C),
      abelDivAffPlus C P.cover.Carrier F =
        PicEtAff.mapAlg C ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
          (picEtAffineEquiv C A lam.1) := by
  classical
  obtain ⟨S⟩ := P.nonempty_noetherianStage hpi
  obtain ⟨F, hFrel⟩ := S.exists_glued_divFamZarAff hpi
  set F' : DivFamZarAff C P.cover.Carrier (genus C) :=
    DivFamZarAff.mapAlgHom (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier) F with hF'def
  have hF'pic : F'.picClass =
      Scheme.CechPic.map (relCurveMap C S.A0 P.cover.Carrier) F.picClass := by
    rw [hF'def, DivFamZarAff.mapAlgHom_eq_mapAlg
      (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier) (fun _ => rfl),
      DivFamZarAff.picClass_mapAlg]
  have hcurveB :
      (C ◁ Over.overSpecMap (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier)).left =
        relCurveMap C S.A0 P.cover.Carrier := by
    refine congrArg
      (fun t : overSpec k P.cover.Carrier ⟶ overSpec k S.A0 => (C ◁ t).left) ?_
    exact Over.OverMorphism.ext rfl
  have hclassB : P.datum.cechPicClass =
      Scheme.CechPic.map (relCurveMap C S.A0 P.cover.Carrier)
        (S.D0.baseChange S.A0).cechPicClass := by
    rw [← S.hbase]
    exact (S.D0.baseChange S.A0).cechPicClass_baseChange P.cover.Carrier
  have hrelB : relPicMk C (overSpec k P.cover.Carrier) F'.picClass =
      relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass := by
    have h := congrArg
      (relPicAlgMap C (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier)) hFrel
    rw [relPicAlgMap_mk, relPicAlgMap_mk, hcurveB] at h
    rw [hF'pic, hclassB]
    exact h
  have htarget :
      PicEtAff.mapAlg C ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
          (picEtAffineEquiv C A lam.1) =
        PicEtAff.unit C P.cover.Carrier
          (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
    rw [← P.represents, PicEtAff.mapAlg_mk_eq_unit_self]
  refine ⟨F', ?_⟩
  calc abelDivAffPlus C P.cover.Carrier F'
      = PicEtAff.unit C P.cover.Carrier
          (relPicMk C (overSpec k P.cover.Carrier) F'.picClass) := rfl
    _ = PicEtAff.unit C P.cover.Carrier
          (relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass) := by
        rw [hrelB]
    _ = PicEtAff.unit C P.cover.Carrier
          (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
        rw [← P.datum_class]
    _ = PicEtAff.mapAlg C ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
          (picEtAffineEquiv C A lam.1) := htarget.symm