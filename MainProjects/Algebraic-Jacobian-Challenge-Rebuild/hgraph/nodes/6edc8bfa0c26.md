---
author: sync
content_type: theorem
created: '2026-08-13T12:33:46'
decl: AlgebraicGeometry.rankOneDivisorUniqueness
docstring: '**The rank-one divisor uniqueness interface holds** (the T5 discharge):
  over every

  affine test whose plus class lies in the rank-one locus, at most one widened locally

  certified divisor class of degree `genus C` has Abel value the input class.


  Injectivity is restored on the rank-one locus precisely because the presentation''s
  `H⁰` is

  finite projective of stalk rank one — single-point linear systems — which feeds
  the

  unit-extraction engine of the datum-class uniqueness core; away from the locus the
  widened

  Abel map is genuinely non-injective (`Pic0ChartAbelNonInjective`).'
file: AlgebraicJacobian/Picard/Pic0RankOneUniquenessDischarge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rankOneDivisorUniqueness
type: lean
updated: '2026-08-13T12:33:46'
---
theorem rankOneDivisorUniqueness : RankOneDivisorUniqueness pi := by
  intro S _ _ lam hlam F G hF hG
  classical
  -- a presentation of the input class, from the identity test; its plus class is `lam.1`
  obtain ⟨P⟩ := (mem_picRankOneOpen_iff pi lam).mp hlam S (𝟙 (overSpec k S))
  have e : ((picDegLayerFunctor C (genus C : ℤ)).map
      (𝟙 (overSpec k S)).op lam).1 = lam.1 :=
    picEtMap_id C lam.1
  -- inject along the faithfully flat étale carrier
  apply DivFamZarAff.mapAlgHom_injective_of_faithfullyFlat
    (S := S) (S' := P.cover.Carrier)
  set φ0 : S →ₐ[k] P.cover.Carrier := IsScalarTower.toAlgHom k S P.cover.Carrier with hφ0
  -- the restricted Abel values are the unit of the representative, so both restricted
  -- `picClass`es agree with the datum's Čech class in the relative Picard group
  have hofId : ((Algebra.ofId S P.cover.Carrier).restrictScalars k) = φ0 :=
    AlgHom.ext fun _ => rfl
  have hrep : PicEtAff.mk C P.cover P.representative = picEtAffineEquiv C S lam.1 := by
    rw [← e]
    exact P.represents
  have htarget : PicEtAff.mapAlg C φ0 (picEtAffineEquiv C S lam.1)
      = PicEtAff.unit C P.cover.Carrier
          (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
    rw [← hrep, ← hofId, PicEtAff.mapAlg_mk_eq_unit_self]
  have key : ∀ H : DivFamZarAff C S (genus C),
      abelDivAffPlus C S H = picEtAffineEquiv C S lam.1 →
      relPicMk C (overSpec k P.cover.Carrier)
          (DivFamZarAff.mapAlgHom φ0 H).picClass
        = relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass := by
    intro H hH
    rw [← P.datum_class]
    apply PicEtAff.unit_injective C P.cover.Carrier
    calc PicEtAff.unit C P.cover.Carrier (relPicMk C (overSpec k P.cover.Carrier)
          (DivFamZarAff.mapAlgHom φ0 H).picClass)
        = abelDivAffPlus C P.cover.Carrier (DivFamZarAff.mapAlgHom φ0 H) := rfl
      _ = PicEtAff.mapAlg C φ0 (abelDivAffPlus C S H) :=
          (abelDivAffPlus_mapAlgHom φ0 H).symm
      _ = PicEtAff.mapAlg C φ0 (picEtAffineEquiv C S lam.1) := by rw [hH]
      _ = PicEtAff.unit C P.cover.Carrier
            (P.representative : relPic C (overSpec k P.cover.Carrier)) := htarget
  -- per-prime agreement, upgraded to a finite spanning family, separates over the carrier
  obtain ⟨m, g, hgspan, hggood⟩ := exists_fin_span_eq_top_of_forall_prime
    (fun f => DivFamZarAff.mapAlgHom
        (IsScalarTower.toAlgHom k P.cover.Carrier (Localization.Away f))
        (DivFamZarAff.mapAlgHom φ0 F)
      = DivFamZarAff.mapAlgHom
        (IsScalarTower.toAlgHom k P.cover.Carrier (Localization.Away f))
        (DivFamZarAff.mapAlgHom φ0 G))
    (fun q => P.exists_notMem_mapAlgHom_eq pi (key F hF) (key G hG) q)
  exact DivFamZarAff.eq_of_awaySpan_eq g hgspan hggood

/-! ## Immediate consumers: the canonical rank-one divisor, unconditionally -/

variable {A : Type u} [CommRing A] [Algebra k A]
  {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}