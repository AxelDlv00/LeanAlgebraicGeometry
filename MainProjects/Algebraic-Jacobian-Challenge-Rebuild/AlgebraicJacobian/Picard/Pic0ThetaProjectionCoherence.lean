/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

/-!
# Projection coherence for the degree-zero Picard base-change comparison

This file supplies the scheme-level equalities used to compare the affine transport
families underlying `pic0Theta`. It proves that the inverse same-carrier comparison has
the expected first projection over any field extension, and identifies the whole
comparison at the identity extension with whiskering by `baseChange.idIso`.

The proof keeps the proof-bearing `eqToIso` in `baseChange.idIso` opaque. Its component
projection is obtained from adjunction conjugation and proof irrelevance, avoiding a
large simplifier expansion of `Over.pullbackId`.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

/-! ## Congruence of étale-plus transports (the reduction key)

Both the base-field shuffle (`PicEtAff.baseFieldShuffle`, via `crossBaseTransportFamily`) and
the curve transport (`PicEtAff.curveMap`, via `curveTransportFamily`) are
`RelPicTransportFamily.picEtAffHom`s, and `picEtAffHom_mk`/`descentHom_coe`/`relPicHom_mk`
express the transport as `CechPic.map` of the family's `hom` scheme morphism. Hence two
families with pointwise-equal `hom` fields induce equal transports — the lemma through which
the two θ-cocycle atoms reduce to a scheme-morphism identity on the product carriers. -/
theorem RelPicTransportFamily.picEtAffHom_congr {kD kE kT : Type u}
    [Field kD] [Field kE] [Field kT] [Algebra kD kT] [Algebra kE kT]
    {D : Over (Spec (.of kD))} {E : Over (Spec (.of kE))}
    (S T : RelPicTransportFamily kT D E)
    (h : ∀ (B : Type u) [CommRing B] [Algebra kD B] [Algebra kE B] [Algebra kT B]
      [IsScalarTower kD kT B] [IsScalarTower kE kT B], S.hom B = T.hom B)
    (A : Type u) [CommRing A] [Algebra kD A] [Algebra kE A] [Algebra kT A]
    [IsScalarTower kD kT A] [IsScalarTower kE kT A] (a : PicEtAff E A) :
    S.picEtAffHom A a = T.picEtAffHom A a := by
  induction a using PicEtAff.ind with
  | _ U x =>
    rw [RelPicTransportFamily.picEtAffHom_mk, RelPicTransportFamily.picEtAffHom_mk]
    refine congrArg (PicEtAff.mk D U) (Subtype.ext ?_)
    rw [RelPicTransportFamily.descentHom_coe, RelPicTransportFamily.descentHom_coe]
    generalize (x : relPic E (overSpec kE U.Carrier)) = y
    induction y using relPic.ind with
    | mk L =>
      rw [RelPicTransportFamily.relPicHom_mk, RelPicTransportFamily.relPicHom_mk, h]

/-! ## Base-change-identity/composite pullback helpers -/

open Limits in
/-- `Over.pullbackId`'s forward comparison has first projection the identity: the
base-change-along-`𝟙` section reads off the original object on the first factor. -/
theorem pullbackId_hom_app_left.{w} {D : Type w} [Category.{u} D] [HasPullbacks D]
    {S : D} (X : Over S) :
    (Over.pullbackId.hom.app X).left = pullback.fst X.hom (𝟙 S) := by
  change ((conjugateEquiv (Over.mapPullbackAdj (𝟙 S))
    (Adjunction.id (C := Over S)) (Over.mapId S).inv).app X).left = _
  rw [conjugateEquiv_adjunction_id]
  simp only [Over.comp_left, Over.mapId_inv_app_left,
    Over.mapPullbackAdj_counit_app, Over.homMk_left]
  simp

open Limits in
private theorem pullbackId_transport_hom_app_left.{w}
    {D : Type w} [Category.{u} D] [HasPullbacks D] {S : D}
    (f : S ⟶ S) (hf : f = 𝟙 S)
    (h : Over.pullback f = Over.pullback (𝟙 S)) (X : Over S) :
    ((eqToIso h ≪≫ Over.pullbackId).hom.app X).left = pullback.fst X.hom f := by
  subst f
  have hh : h = rfl := Subsingleton.elim _ _
  cases hh
  simpa only [Iso.trans_hom, NatTrans.comp_app, eqToIso.hom, eqToHom_refl,
    Over.comp_left, Category.id_comp] using pullbackId_hom_app_left X

open Limits in
/-- The forward identity base-change iso on the frozen `Challenge` spelling has first
projection `pullback.fst` along the trivial base map. -/
theorem baseChange_idIso_hom_app_left (k : Type u) [Field k] (C : Over (Spec (.of k))) :
    ((baseChange.idIso k).app C).hom.left
      = pullback.fst C.hom (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
  unfold baseChange.idIso
  exact pullbackId_transport_hom_app_left _ (by simp) _ C

open MonoidalCategory CartesianMonoidalCategory in
/-- The inverse same-carrier comparison followed by the first projection is the first
projection of the original curve, after composing with the base-change pullback map. -/
theorem crossBaseAffineIso_inv_fst (k L : Type u) [Field k] [Field L]
    [Algebra k L] (C : Over (Spec (.of k))) (A : Type u) [CommRing A]
    [Algebra k A] [Algebra L A] [IsScalarTower k L A] :
    (crossBaseAffineIso k L C A).inv ≫
        ((fst ((baseChange k L).obj C) (overSpec L A)).left ≫
          Limits.pullback.fst C.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k L)))) =
      (fst C (overSpec k A)).left := by
  rw [crossBaseAffineIso, Iso.trans_inv, Functor.mapIso_inv, Category.assoc,
    Over.crossBaseIso_inv_fst]
  change (C ◁ (mapOverSpecIso k L A).inv).left ≫
    (fst C ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj
      (overSpec L A))).left = (fst C (overSpec k A)).left
  exact Over.whiskerLeft_left_fst (mapOverSpecIso k L A).inv

/-! ## The identity-extension comparison

The K-1a Leg-4 atom is the scheme identity
`((baseChange.idIso k).app C).inv ▷ overSpec k B).left = (crossBaseAffineIso k k C B).inv`,
is proved by `(Over.isPullback_left _ _).hom_ext` on the two projections. -/

open MonoidalCategory CartesianMonoidalCategory in
/-- **The `snd` leg of the K-1a Leg-4 atom**: the whiskered identity base-change comparison
and the affine same-carrier comparison agree on the second projection — both are
`(snd C (overSpec k B)).left`.

Term-mode by necessity: the identity base change spells its codomain `(𝟭 _).obj C`, so `rw`
reports "did not find an occurrence" on a goal that visibly contains the pattern (the R4/R5
spelling friction of I-0216, measured here). -/
theorem crossBaseAffineIso_inv_whiskerRight_snd (k : Type u) [Field k]
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left
        ≫ (snd ((baseChange k k).obj C) (overSpec k B)).left
      = (crossBaseAffineIso k k C B).inv
          ≫ (snd ((baseChange k k).obj C) (overSpec k B)).left := by
  calc
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left ≫
        (snd ((baseChange k k).obj C) (overSpec k B)).left =
      (snd ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left :=
      Over.whiskerRight_left_snd ((baseChange.idIso k).app C).inv
    _ = (snd C (overSpec k B)).left := rfl
    _ = (crossBaseAffineIso k k C B).inv ≫
        (snd ((baseChange k k).obj C) (overSpec k B)).left :=
      (crossBaseAffineIso_inv_snd k k C B).symm

open MonoidalCategory CartesianMonoidalCategory in
/-- The inverse cross-base comparison and the whiskered identity base-change comparison
agree on the first projection. -/
theorem crossBaseAffineIso_inv_whiskerRight_fst (k : Type u) [Field k]
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (B : Type u) [CommRing B] [Algebra k B] :
    (((baseChange.idIso k).app C).inv ▷ overSpec k B).left
        ≫ (fst ((baseChange k k).obj C) (overSpec k B)).left =
      (crossBaseAffineIso k k C B).inv
        ≫ (fst ((baseChange k k).obj C) (overSpec k B)).left := by
  haveI : IsIso
      (Limits.pullback.fst C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k k)))) := by
    rw [← baseChange_idIso_hom_app_left k C]
    exact ((Over.forget _).mapIso ((baseChange.idIso k).app C)).isIso_hom
  apply (cancel_mono
    (Limits.pullback.fst C.hom
      (Spec.map (CommRingCat.ofHom (algebraMap k k))))).1
  have hunit :
      (((fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫
          ((baseChange.idIso k).app C).inv.left) ≫
        Limits.pullback.fst C.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k k)))) =
        (fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left := by
    have hcancel : ((baseChange.idIso k).app C).inv.left ≫
        ((baseChange.idIso k).app C).hom.left = 𝟙 _ :=
      Over.inv_left_hom_left ((baseChange.idIso k).app C)
    calc
      (((fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫
            ((baseChange.idIso k).app C).inv.left) ≫
          Limits.pullback.fst C.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k k)))) =
        (fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫
          (((baseChange.idIso k).app C).inv.left ≫
            ((baseChange.idIso k).app C).hom.left) := by
        rw [← baseChange_idIso_hom_app_left, Category.assoc]
        rfl
      _ = (fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫ 𝟙 _ :=
        congrArg (fun q =>
          (fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫ q) hcancel
      _ = (fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left :=
        Category.comp_id _
  have hunit' :
      (((fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫
          ((baseChange.idIso k).app C).inv.left) ≫
        Limits.pullback.fst C.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k k)))) =
        (fst C (overSpec k B)).left := by
    simpa only [Functor.id_obj] using hunit
  calc
    ((((baseChange.idIso k).app C).inv ▷ overSpec k B).left
          ≫ (fst ((baseChange k k).obj C) (overSpec k B)).left) ≫
        Limits.pullback.fst C.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k k))) =
      (((fst ((𝟭 (Over (Spec (.of k)))).obj C) (overSpec k B)).left ≫
          ((baseChange.idIso k).app C).inv.left) ≫
        Limits.pullback.fst C.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k k)))) :=
      congrArg (fun q => q ≫ Limits.pullback.fst C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k k))))
        (Over.whiskerRight_left_fst ((baseChange.idIso k).app C).inv)
    _ = (fst C (overSpec k B)).left := hunit'
    _ = ((crossBaseAffineIso k k C B).inv ≫
          (fst ((baseChange k k).obj C) (overSpec k B)).left) ≫
        Limits.pullback.fst C.hom
          (Spec.map (CommRingCat.ofHom (algebraMap k k))) := by
      rw [Category.assoc, crossBaseAffineIso_inv_fst]

open MonoidalCategory CartesianMonoidalCategory in
/-- The inverse same-carrier comparison at the identity field extension is exactly
whiskering by the inverse identity base-change comparison. -/
theorem crossBaseAffineIso_inv_eq_whiskerRight (k : Type u) [Field k]
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (B : Type u) [CommRing B] [Algebra k B] :
    (crossBaseAffineIso k k C B).inv =
      (((baseChange.idIso k).app C).inv ▷ overSpec k B).left := by
  apply (Over.isPullback_left ((baseChange k k).obj C) (overSpec k B)).hom_ext
  · exact (crossBaseAffineIso_inv_whiskerRight_fst k C B).symm
  · exact (crossBaseAffineIso_inv_whiskerRight_snd k C B).symm

end AlgebraicGeometry
