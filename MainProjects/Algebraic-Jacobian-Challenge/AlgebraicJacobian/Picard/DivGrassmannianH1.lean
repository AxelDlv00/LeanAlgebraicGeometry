/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianClass
import AlgebraicJacobian.Picard.AffineOpenStalkLocalization
import AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.QcohTildeSections
import AlgebraicJacobian.Cohomology.AbsoluteCohomology

/-!
# Cohomological lifting for the divisor Grassmannian evaluation

This file supplies the `H^1`-lifting step in the divisor-to-Grassmannian
construction without importing the much larger analytic embedding module.
For a twisted divisor quotient over an affine test scheme, vanishing of the
kernel's degree-one absolute cohomology makes the quotient surjective on
sections.  Affine quasi-coherent descent then makes its pushforward an
epimorphism.

This isolates the terminal long-exact-sequence lifting substep corresponding
to Kleiman, *The Picard scheme*, `sb:Q`, TeX lines 1926--1934.  Kleiman first
derives a stronger higher-direct-image vanishing statement from fibrewise
`H^1`; that uniform geometric producer remains a separate obligation here.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/- These local helpers mirror results in `DivGrassmannianEmbedding`.  They stay
private here because importing that analytic module makes this focused
cohomological producer inherit its hour-long elaboration path. -/

private theorem tensorObj_functoriality_epi_right_for_divGrassmannianH1
    {X : Scheme.{u}} {M N N' : X.Modules} (g : N ⟶ N') [hg : Epi g] :
    Epi (tensorObj_functoriality (𝟙 M) g) := by
  let J := Opens.grothendieckTopology X
  letI : (SheafOfModules.toSheaf X.ringCatSheaf).PreservesEpimorphisms :=
    AlgebraicGeometry.toSheaf_preservesEpimorphisms X.ringCatSheaf
  have hgSheaf : Epi ((SheafOfModules.toSheaf X.ringCatSheaf).map g) :=
    @Functor.map_epi _ _ _ _ (SheafOfModules.toSheaf X.ringCatSheaf) _ _ _ g hg
  have hgLoc : PresheafOfModules.IsLocallySurjective J g.val := by
    exact (Sheaf.isLocallySurjective_iff_epi'
      AddCommGrpCat ((SheafOfModules.toSheaf X.ringCatSheaf).map g)).mpr hgSheaf
  let M' : _root_.PresheafOfModules
      (X.presheaf ⋙ forget₂ CommRingCat RingCat) := M.val
  let g' : MonoidalCategory.tensorObj M' N.val ⟶
      MonoidalCategory.tensorObj M' N'.val := M' ◁ g.val
  have htLoc : PresheafOfModules.IsLocallySurjective J g' :=
    PresheafOfModules.isLocallySurjective_whiskerLeft M' g.val hgLoc
  have htSheafLoc : Sheaf.IsLocallySurjective
      ((presheafToSheaf J AddCommGrpCat).map
        ((PresheafOfModules.toPresheaf
          (X.presheaf ⋙ forget₂ CommRingCat RingCat)).map g')) := by
    rw [Presheaf.isLocallySurjective_presheafToSheaf_map_iff]
    exact htLoc
  have htSheafEpi : Epi
      ((presheafToSheaf J AddCommGrpCat).map
        ((PresheafOfModules.toPresheaf
          (X.presheaf ⋙ forget₂ CommRingCat RingCat)).map g')) :=
    (Sheaf.isLocallySurjective_iff_epi' AddCommGrpCat.{u} _).mp htSheafLoc
  have hmap : Epi ((SheafOfModules.toSheaf X.ringCatSheaf).map
      (tensorObj_functoriality (𝟙 M) g)) := by
    change Epi ((presheafToSheaf J AddCommGrpCat).map
      ((PresheafOfModules.toPresheaf
        (X.presheaf ⋙ forget₂ CommRingCat RingCat)).map g'))
    exact htSheafEpi
  exact (SheafOfModules.toSheaf X.ringCatSheaf).epi_of_epi_map hmap

private theorem epi_of_globalSections_surjective_for_divGrassmannianH1
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    (q : M ⟶ N)
    (hM : M.IsQuasicoherent) (hN : N.IsQuasicoherent)
    (hq : Function.Surjective
      ((moduleSpecΓFunctor (R := R)).map q).hom) :
    Epi q := by
  letI : M.IsQuasicoherent := hM
  letI : N.IsQuasicoherent := hN
  have hM : IsIso M.fromTildeΓ := isIso_fromTildeΓ_of_quasicoherent M
  have hN : IsIso N.fromTildeΓ := isIso_fromTildeΓ_of_quasicoherent N
  haveI hqΓ : Epi ((moduleSpecΓFunctor (R := R)).map q) := by
    rw [ModuleCat.epi_iff_surjective]
    exact hq
  haveI hqtilde : Epi
      ((tilde.functor R).map ((moduleSpecΓFunctor (R := R)).map q)) := by
    infer_instance
  haveI : IsIso M.fromTildeΓ := hM
  haveI : IsIso N.fromTildeΓ := hN
  have key : M.fromTildeΓ ≫ q =
      (tilde.functor R).map ((moduleSpecΓFunctor (R := R)).map q) ≫
        N.fromTildeΓ :=
    ((fromTildeΓNatTrans (R := R)).naturality q).symm
  rw [← epi_comp_iff_of_epi M.fromTildeΓ]
  rw [key]
  exact epi_comp' hqtilde
    (@IsIso.epi_of_iso _ _ _ _ N.fromTildeΓ hN)

end Modules

namespace DivFamily

private theorem twistQuotientMap_epi_for_divGrassmannianH1
    {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}
    (L : X.Modules) (x : DivFamily π T) :
    Epi (x.twistQuotientMap L) := by
  letI := x.epi
  haveI : Epi (Modules.tensorObj_functoriality
      (𝟙 ((Modules.pullback (pullback.fst π T.hom)).obj L))
      ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)) :=
    Modules.tensorObj_functoriality_epi_right_for_divGrassmannianH1 _
  change Epi ((Modules.tensorObj_right_unitor
    ((Modules.pullback (pullback.fst π T.hom)).obj L)).inv ≫
      Modules.tensorObj_functoriality
        (𝟙 ((Modules.pullback (pullback.fst π T.hom)).obj L))
        ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q))
  letI : Epi (Modules.tensorObj_right_unitor
      ((Modules.pullback (pullback.fst π T.hom)).obj L)).inv := inferInstance
  infer_instance

noncomputable local instance hasExtModulesForDivGrassmannianH1 {Y : Scheme.{u}} :
    CategoryTheory.HasExt.{u + 1, u, u + 1} Y.Modules :=
  CategoryTheory.HasExt.standard _

set_option maxHeartbeats 1000000 in
-- Elaborating the pushed quasi-coherence witnesses traverses both pullback cones.
/-- **The twisted divisor quotient remains epi after pushforward when its
degree-one lifting obstruction vanishes.**  Over an affine test scheme, the
vanishing is expressed by subsingleton `Ext^1` of the kernel over the top open.
The long exact absolute-cohomology sequence then makes the quotient surjective
on global sections, and affine quasi-coherent descent reflects that
surjectivity to an epimorphism of pushed module sheaves.

This is the terminal LES lifting substep corresponding to Kleiman,
*The Picard scheme*, `sb:Q`, TeX lines 1926--1934; the preceding fibrewise
`H^1`-to-higher-direct-image vanishing argument is not asserted here. -/
theorem pushforward_twistQuotientMap_epi_of_kernel_absoluteCohomology_one_subsingleton
    {R : CommRingCat.{u}} {S X : Scheme.{u}} {π : X ⟶ S} [IsProper π]
    (f : Spec R ⟶ S) (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π (Over.mk f))
    [Subsingleton (CategoryTheory.Abelian.Ext
      (jShriekOU (⊤ : (pullback π f).Opens))
      (kernel (x.twistQuotientMap L)) 1)] :
    Epi ((Modules.pushforward (pullback.snd π f)).map
      (x.twistQuotientMap L)) := by
  haveI : L.IsFinitePresentation := hL.isFinitePresentation
  have hLqc : L.IsQuasicoherent := inferInstance
  have hPullLqc :
      ((Modules.pullback (pullback.fst π (Over.mk f).hom)).obj L).IsQuasicoherent :=
    pullback_isQuasicoherent_hom _ L hLqc
  haveI : x.F.IsFinitePresentation := x.isFinitePresentation
  have hFqc : x.F.IsQuasicoherent := inferInstance
  have hTwistqc : (x.twist L).IsQuasicoherent := by
    dsimp [twist]
    exact @Modules.tensorObj_isQuasicoherent _ _ _ hPullLqc hFqc
  letI : ((Modules.pullback
      (pullback.fst π (Over.mk f).hom)).obj L).IsQuasicoherent := hPullLqc
  letI : (x.twist L).IsQuasicoherent := hTwistqc
  have hqc : QuasiCompact (pullback.snd π f) := inferInstance
  have hqs : QuasiSeparated (pullback.snd π f) := inferInstance
  have hPushPullqc : ((Modules.pushforward (pullback.snd π f)).obj
      ((Modules.pullback (pullback.fst π (Over.mk f).hom)).obj L)).IsQuasicoherent :=
    @Modules.pushforward_isQuasicoherent _ _ (pullback.snd π f) hqc hqs _ hPullLqc
  have hPushTwistqc : ((Modules.pushforward (pullback.snd π f)).obj
      (x.twist L)).IsQuasicoherent :=
    @Modules.pushforward_isQuasicoherent _ _ (pullback.snd π f) hqc hqs _ hTwistqc
  have hqEpi : Epi (x.twistQuotientMap L) :=
    twistQuotientMap_epi_for_divGrassmannianH1 L x
  apply Modules.epi_of_globalSections_surjective_for_divGrassmannianH1 _
    hPushPullqc hPushTwistqc
  change Function.Surjective
    (Modules.Hom.app (x.twistQuotientMap L) (⊤ : (pullback π f).Opens)).hom
  exact @sections_surjective_of_kernel_absoluteCohomology_one_subsingleton _
    (⊤ : (pullback π f).Opens) _ _ (x.twistQuotientMap L) hqEpi inferInstance

end DivFamily

end Scheme

end AlgebraicGeometry
