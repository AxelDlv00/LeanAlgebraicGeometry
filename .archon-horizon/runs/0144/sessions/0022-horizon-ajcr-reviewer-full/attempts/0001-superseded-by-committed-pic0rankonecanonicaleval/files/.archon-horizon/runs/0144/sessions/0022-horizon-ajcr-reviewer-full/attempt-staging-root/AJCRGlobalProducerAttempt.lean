import AlgebraicJacobian.Picard.Pic0RankOneAbelInverse
import AlgebraicJacobian.Picard.DivRepAffFaithfullyFlatDescent
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorFree

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable section

abbrev canon := canonicalRankOneDivisorOfMem
abbrev canon_abel := canonicalRankOneDivisorOfMem_abel
abbrev canon_unique := canonicalRankOneDivisorOfMem_unique

private theorem canonicalSection_compat {T : Over (Spec (.of k))}
    (lam : picDegLayer C (genus C : ℤ) T)
    (hlam : lam ∈ (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    ∀ (U V : T.left.affineOpens) (h : U.1 ≤ V.1),
      DivFamZarAff.mapAlgHom (Over.resAlgHom T h)
          (canon (pi := divRepAffP1Map C)
            (divRepAffP1Map_comp C)
            (picRankOneOpen_map_mem (divRepAffP1Map C) (Over.fromSpecAffine T V).op hlam))
        = canon (pi := divRepAffP1Map C)
            (divRepAffP1Map_comp C)
            (picRankOneOpen_map_mem (divRepAffP1Map C) (Over.fromSpecAffine T U).op hlam) := by
  intro U V h
  let fU : overSpec k Γ(T.left, U.1) ⟶ T := Over.fromSpecAffine T U
  let fV : overSpec k Γ(T.left, V.1) ⟶ T := Over.fromSpecAffine T V
  let r : Γ(T.left, V.1) →ₐ[k] Γ(T.left, U.1) := Over.resAlgHom T h
  let lamU : picDegLayer C (genus C : ℤ) (overSpec k Γ(T.left, U.1)) :=
    (picDegLayerFunctor C (genus C : ℤ)).map fU.op lam
  let lamV : picDegLayer C (genus C : ℤ) (overSpec k Γ(T.left, V.1)) :=
    (picDegLayerFunctor C (genus C : ℤ)).map fV.op lam
  have hlamU : lamU ∈ (PicRankOneOpen (divRepAffP1Map C)).obj
      (op (overSpec k Γ(T.left, U.1))) :=
    picRankOneOpen_map_mem (divRepAffP1Map C) fU.op hlam
  have hlamV : lamV ∈ (PicRankOneOpen (divRepAffP1Map C)).obj
      (op (overSpec k Γ(T.left, V.1))) :=
    picRankOneOpen_map_mem (divRepAffP1Map C) fV.op hlam
  have hclass : lamU.1 = picEtMap C (Over.overSpecMap r) lamV.1 := by
    change picEtMap C (Over.fromSpecAffine T U) lam.1 =
      picEtMap C (Over.overSpecMap (Over.resAlgHom T h))
        (picEtMap C (Over.fromSpecAffine T V) lam.1)
    rw [← picEtMap_comp]
    exact congrArg (fun q => picEtMap C q lam.1)
      (Over.fromSpecAffine_resAlgHom h).symm
  have habel : abelDivAffPlus C Γ(T.left, U.1)
      (DivFamZarAff.mapAlgHom r
        (canon (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) hlamV)) =
      picEtAffineEquiv C Γ(T.left, U.1) lamU.1 := by
    calc
      abelDivAffPlus C Γ(T.left, U.1)
          (DivFamZarAff.mapAlgHom r
            (canon (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) hlamV))
          = PicEtAff.mapAlg C r
              (abelDivAffPlus C Γ(T.left, V.1)
                (canon (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) hlamV)) :=
            (abelDivAffPlus_mapAlgHom r _).symm
      _ = PicEtAff.mapAlg C r
          (picEtAffineEquiv C Γ(T.left, V.1) lamV.1) := by
            rw [canon_abel (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) hlamV]
      _ = picEtAffineEquiv C Γ(T.left, U.1)
          (picEtMap C (Over.overSpecMap r) lamV.1) :=
            (picEtAffineEquiv_naturality C r lamV.1).symm
      _ = picEtAffineEquiv C Γ(T.left, U.1) lamU.1 := by rw [hclass]
  exact canon_unique (pi := divRepAffP1Map C)
    (divRepAffP1Map_comp C) hlamU
    (DivFamZarAff.mapAlgHom r
      (canon (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) hlamV)) habel

noncomputable def canonicalSection {T : Over (Spec (.of k))}
    (lam : picDegLayer C (genus C : ℤ) T)
    (hlam : lam ∈ (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    divFamZarAff C (genus C) T :=
  ⟨fun U => canon (pi := divRepAffP1Map C)
      (divRepAffP1Map_comp C)
      (picRankOneOpen_map_mem (divRepAffP1Map C)
        (Over.fromSpecAffine T U).op hlam),
    canonicalSection_compat lam hlam⟩

private theorem picEtAffineEquiv_map_fromSpecAffine
    (T : Over (Spec (.of k))) (s : picEt C T) (U : T.left.affineOpens) :
    picEtAffineEquiv C Γ(T.left, U.1)
        (picEtMap C (Over.fromSpecAffine T U) s) = s.1 U := by
  rw [picEtAffineEquiv_apply, picEtMap_val,
    picEtMapVal_eq_mapAlg C (Over.fromSpecAffine T U) s
      (top_le_preimage_fromSpecAffine T U)]
  set psi := Over.appLEAlgHom (Over.fromSpecAffine T U) U.1
    (overSpecTopAffine Γ(T.left, U.1)).1
      (top_le_preimage_fromSpecAffine T U) with hpsi
  set e := (Over.overSpecΓTopAlgEquiv k Γ(T.left, U.1)).toAlgHom with he
  have hcomp : e.comp psi = AlgHom.id k Γ(T.left, U.1) := by
    rw [he, hpsi]
    exact fromSpecAffine_ΓTop_comp_appLEAlgHom T U
  calc
    PicEtAff.mapAlg C e (PicEtAff.mapAlg C psi (s.1 U)) =
        PicEtAff.mapAlg C (e.comp psi) (s.1 U) :=
      (PicEtAff.mapAlg_comp C psi e (s.1 U)).symm
    _ = PicEtAff.mapAlg C (AlgHom.id k Γ(T.left, U.1)) (s.1 U) := by rw [hcomp]
    _ = s.1 U := PicEtAff.mapAlg_id C (s.1 U)

theorem canonicalSection_abel {T : Over (Spec (.of k))}
    (lam : picDegLayer C (genus C : ℤ) T)
    (hlam : lam ∈ (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    abelDivAff' C (genus C) T (canonicalSection lam hlam) = lam.1 := by
  refine picEt.ext fun U => ?_
  rw [abelDivAff'_val, canonicalSection]
  calc
    abelDivAffPlus C Γ(T.left, U.1)
        (canon (pi := divRepAffP1Map C) (divRepAffP1Map_comp C)
          (picRankOneOpen_map_mem (divRepAffP1Map C)
            (Over.fromSpecAffine T U).op hlam))
        = picEtAffineEquiv C Γ(T.left, U.1)
            ((picDegLayerFunctor C (genus C : ℤ)).map
              (Over.fromSpecAffine T U).op lam).1 :=
          canon_abel (pi := divRepAffP1Map C) (divRepAffP1Map_comp C) _
    _ = lam.1.1 U := picEtAffineEquiv_map_fromSpecAffine T lam.1 U

theorem canonicalSection_layer {T : Over (Spec (.of k))}
    (lam : (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    (abelDivAffTrans C (genus C)).app (op T)
        (canonicalSection lam.1 lam.2) = lam.1 := by
  apply Subtype.ext
  exact canonicalSection_abel lam.1 lam.2

theorem canonicalSection_naturality {T T' : Over (Spec (.of k))}
    (f : T' ⟶ T)
    (lam : (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    divFamZarAff.map C (genus C) f (canonicalSection lam.1 lam.2) =
      canonicalSection
        (((PicRankOneOpen (divRepAffP1Map C)).toFunctor.map f.op lam).1)
        (((PicRankOneOpen (divRepAffP1Map C)).toFunctor.map f.op lam).2) := by
  let lam' := (PicRankOneOpen (divRepAffP1Map C)).toFunctor.map f.op lam
  let s := divFamZarAff.map C (genus C) f (canonicalSection lam.1 lam.2)
  let s' := canonicalSection lam'.1 lam'.2
  have habel : abelDivAff' C (genus C) T' s =
      abelDivAff' C (genus C) T' s' := by
    calc
      abelDivAff' C (genus C) T' s =
          picEtMap C f (abelDivAff' C (genus C) T
            (canonicalSection lam.1 lam.2)) :=
        (picEtMap_abelDivAff' f (canonicalSection lam.1 lam.2)).symm
      _ = picEtMap C f lam.1.1 := by rw [canonicalSection_abel lam.1 lam.2]
      _ = lam'.1.1 := rfl
      _ = abelDivAff' C (genus C) T' s' :=
        (canonicalSection_abel lam'.1 lam'.2).symm
  have hclass : (abelDivAffTrans C (genus C)).app (op T') s = lam'.1 := by
    apply Subtype.ext
    exact habel.trans (canonicalSection_abel lam'.1 lam'.2)
  have hmem : (abelDivAffTrans C (genus C)).app (op T') s ∈
      (PicRankOneOpen (divRepAffP1Map C)).obj (op T') := by
    rw [hclass]
    exact lam'.2
  exact divFamZarAff_eq_of_rankOne (divRepAffP1Map C) T' s s' hmem habel

noncomputable def canonicalSectionTrans :
    (PicRankOneOpen (divRepAffP1Map C)).toFunctor ⟶
      (divRankOnePresentationPreimageAff (divRepAffP1Map C)).toFunctor where
  app T := TypeCat.ofHom fun lam =>
    ⟨canonicalSection lam.1 lam.2, by
      change (abelDivAffTrans C (genus C)).app T
        (canonicalSection lam.1 lam.2) ∈
          (PicRankOneOpen (divRepAffP1Map C)).obj T
      rw [canonicalSection_layer]
      exact lam.2⟩
  naturality T T' f := by
    ext lam
    apply Subtype.ext
    exact (canonicalSection_naturality f.unop lam).symm

noncomputable def canonicalRepresenterTrans :
    (PicRankOneOpen (divRepAffP1Map C)).toFunctor ⟶
      (divRankOnePresentationPreimageRepresenter (divRepAffP1Map C)).toFunctor where
  app T := TypeCat.ofHom fun lam =>
    ⟨(divFunctorAff_genus_representableBy C).toIso.inv.app T
        ((canonicalSectionTrans (C := C)).app T lam).1, by
      have h := (divFunctorAff_genus_representableBy C).toIso.hom_inv_id_app_apply T
          ((canonicalSectionTrans (C := C)).app T lam).1
      exact h ▸ ((canonicalSectionTrans (C := C)).app T lam).2⟩
  naturality T T' f := by
    ext lam
    apply Subtype.ext
    change (yoneda.obj (divRepAffGenusScheme C)).map f
        ((divFunctorAff_genus_representableBy C).toIso.inv.app T
          ((canonicalSectionTrans (C := C)).app T lam).1) =
      (divFunctorAff_genus_representableBy C).toIso.inv.app T'
        ((canonicalSectionTrans (C := C)).app T'
          ((PicRankOneOpen (divRepAffP1Map C)).toFunctor.map f lam)).1
    rw [← ConcreteCategory.comp_apply,
      ← (divFunctorAff_genus_representableBy C).toIso.inv.naturality]
    exact congrArg
      (fun s => (divFunctorAff_genus_representableBy C).toIso.inv.app T' s)
      (ConcreteCategory.congr_hom
        ((canonicalSectionTrans (C := C)).naturality f) lam)

theorem canonicalRepresenterTrans_abel
    {T : (Over (Spec (.of k)))ᵒᵖ}
    (lam : (PicRankOneOpen (divRepAffP1Map C)).obj T) :
    (rankOneAbelRepresented (divRepAffP1Map C)).app T
        ((canonicalRepresenterTrans (C := C)).app T lam) = lam := by
  apply Subtype.ext
  have h := (divFunctorAff_genus_representableBy C).toIso.hom_inv_id_app_apply T
      ((canonicalSectionTrans (C := C)).app T lam).1
  change (abelDivAffTrans C (genus C)).app T
      ((divFunctorAff_genus_representableBy C).toIso.hom.app T
        ((divFunctorAff_genus_representableBy C).toIso.inv.app T
          ((canonicalSectionTrans (C := C)).app T lam).1)) = lam.1
  rw [h]
  exact canonicalSection_layer lam

noncomputable def canonicalEvaluationDivisorData :
    PicRankOneEvaluationDivisorData (C := C) (divRepAffP1Map C) where
  divisor := Over.sigmaExtensionNat (canonicalRepresenterTrans (C := C))
  divisor_abel := by
    ext Y x
    rcases x with ⟨a, lam⟩
    exact congrArg (Sigma.mk a) (canonicalRepresenterTrans_abel lam)

end

end AlgebraicGeometry
