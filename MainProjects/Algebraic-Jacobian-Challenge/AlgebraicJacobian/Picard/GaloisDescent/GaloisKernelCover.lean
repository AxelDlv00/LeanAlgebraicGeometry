/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.GaloisDescent.PicEtGaloisCover
import Mathlib.AlgebraicGeometry.EffectiveEpi

open CategoryTheory Limits AlgebraicGeometry

universe u

namespace AlgebraicJacobian.GaloisDescent

open scoped TensorProduct
open AlgebraicGeometry.Scheme.PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
  [FiniteDimensional k k'] [IsGalois k k']

noncomputable def fieldSelfSection (γ : k' ≃ₐ[k] k') :
    Spec (CommRingCat.of k') ⟶
      pullback (specMapAlgebra k k') (specMapAlgebra k k') :=
  Limits.Sigma.ι (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k')) γ ≫
    (selfTensorSpecCoproduct k k').hom ≫
    (AlgebraicGeometry.pullbackSpecIso k k' k').inv

@[simp, reassoc]
theorem fieldSelfSection_fst (γ : k' ≃ₐ[k] k') :
    fieldSelfSection (k := k) (k' := k') γ ≫
      pullback.fst (specMapAlgebra k k') (specMapAlgebra k k') = 𝟙 _ := by
  unfold fieldSelfSection selfTensorSpecCoproduct
  simp only [Iso.trans_hom, Category.assoc, asIso_hom,
    AlgebraicGeometry.pullbackSpecIso_inv_fst]
  rw [AlgebraicGeometry.ι_sigmaSpec]
  rw [Scheme.Spec_map, ← Spec.map_comp, ← Spec.map_comp]
  apply Spec.map_injective
  ext x
  exact AlgebraicJacobian.GaloisDescent.galoisSelfTensor_includeLeft k k' γ x

@[simp, reassoc]
theorem fieldSelfSection_snd (γ : k' ≃ₐ[k] k') :
    fieldSelfSection (k := k) (k' := k') γ ≫
      pullback.snd (specMapAlgebra k k') (specMapAlgebra k k') = specGal γ := by
  unfold fieldSelfSection selfTensorSpecCoproduct
  simp only [Iso.trans_hom, Category.assoc, asIso_hom,
    AlgebraicGeometry.pullbackSpecIso_inv_snd]
  rw [AlgebraicGeometry.ι_sigmaSpec]
  rw [Scheme.Spec_map, ← Spec.map_comp, ← Spec.map_comp]
  apply Spec.map_injective
  ext x
  exact AlgebraicJacobian.GaloisDescent.galoisSelfTensor_includeRight k k' γ x

instance fieldSelfSection_isOpenImmersion (γ : k' ≃ₐ[k] k') :
    IsOpenImmersion (fieldSelfSection (k := k) (k' := k') γ) := by
  haveI : IsOpenImmersion
      (Limits.Sigma.ι (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k')) γ) :=
    (Scheme.sigmaOpenCover
      (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k'))).map_prop γ
  unfold fieldSelfSection
  infer_instance

theorem fieldSelfSection_jointlySurjective :
    ∀ x : pullback (specMapAlgebra k k') (specMapAlgebra k k'),
      ∃ (γ : k' ≃ₐ[k] k') (y : Spec (CommRingCat.of k')),
        fieldSelfSection (k := k) (k' := k') γ y = x := by
  intro x
  let e := selfTensorSpecCoproduct k k' ≪≫
    (AlgebraicGeometry.pullbackSpecIso k k' k').symm
  obtain ⟨γ, y, hy⟩ := (Scheme.sigmaOpenCover
    (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k'))).exists_eq (e.inv x)
  refine ⟨γ, y, ?_⟩
  change (Limits.Sigma.ι
    (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k')) γ ≫ e.hom) y = x
  rw [← Scheme.Hom.comp_apply, hy]
  change e.hom (e.inv x) = x
  rw [← Scheme.Hom.comp_apply]
  simp

noncomputable def fieldSelfOpenCover :
    Scheme.OpenCover (pullback (specMapAlgebra k k') (specMapAlgebra k k')) :=
  Scheme.Cover.mkOfCovers (P := @IsOpenImmersion) (k' ≃ₐ[k] k')
    (fun _ => Spec (CommRingCat.of k'))
    (fun γ => fieldSelfSection (k := k) (k' := k') γ)
    (fieldSelfSection_jointlySurjective (k := k) (k' := k'))
    (fun γ => fieldSelfSection_isOpenImmersion (k := k) (k' := k') γ)

noncomputable def relativeFieldSelfSection
    (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    pullback T.hom (specMapAlgebra k k') ⟶
      pullback (pullback.snd T.hom (specMapAlgebra k k'))
        (pullback.fst (specMapAlgebra k k') (specMapAlgebra k k')) :=
  pullback.lift (𝟙 _)
    (pullback.snd T.hom (specMapAlgebra k k') ≫
      fieldSelfSection (k := k) (k' := k') γ)
    (by simp)

noncomputable def relativeFieldSelfOpenCover
    (T : Over (Spec (CommRingCat.of k))) :
    Scheme.OpenCover
      (pullback (pullback.snd T.hom (specMapAlgebra k k'))
        (pullback.fst (specMapAlgebra k k') (specMapAlgebra k k'))) :=
  Scheme.Pullback.openCoverOfRight (fieldSelfOpenCover (k := k) (k' := k'))
    (pullback.snd T.hom (specMapAlgebra k k'))
    (pullback.fst (specMapAlgebra k k') (specMapAlgebra k k'))

theorem relativeFieldSelfOpenCover_factors
    (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    (relativeFieldSelfOpenCover (k := k) (k' := k') T).f γ =
      pullback.fst (pullback.snd T.hom (specMapAlgebra k k'))
          (fieldSelfSection (k := k) (k' := k') γ ≫
            pullback.fst (specMapAlgebra k k') (specMapAlgebra k k')) ≫
        relativeFieldSelfSection (k := k) (k' := k') T γ := by
  apply pullback.hom_ext <;>
    simp [relativeFieldSelfOpenCover, relativeFieldSelfSection]

theorem relativeFieldSelfSection_jointlySurjective
    (T : Over (Spec (CommRingCat.of k))) :
    ∀ x : pullback (pullback.snd T.hom (specMapAlgebra k k'))
        (pullback.fst (specMapAlgebra k k') (specMapAlgebra k k')),
      ∃ (γ : k' ≃ₐ[k] k') (y : pullback T.hom (specMapAlgebra k k')),
        relativeFieldSelfSection (k := k) (k' := k') T γ y = x := by
  intro x
  obtain ⟨γ, z, hz⟩ :=
    (relativeFieldSelfOpenCover (k := k) (k' := k') T).exists_eq x
  refine ⟨γ,
    pullback.fst (pullback.snd T.hom (specMapAlgebra k k'))
      (fieldSelfSection (k := k) (k' := k') γ ≫
        pullback.fst (specMapAlgebra k k') (specMapAlgebra k k')) z, ?_⟩
  rw [← Scheme.Hom.comp_apply, ← relativeFieldSelfOpenCover_factors]
  exact hz

noncomputable def coverSelfRelativeFieldIso
    (T : Over (Spec (CommRingCat.of k))) :
    (pullback (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T)).left ≅
      pullback (pullback.snd T.hom (specMapAlgebra k k'))
        (pullback.fst (specMapAlgebra k k') (specMapAlgebra k k')) :=
  selfPullback_coverMap_left_iso (k := k) (k' := k') T ≪≫
    ((pullbackRightPullbackFstIso (specMapAlgebra k k')
        (specMapAlgebra k k')
        (pullback.snd T.hom (specMapAlgebra k k'))) ≪≫
      pullback.congrHom pullback.condition.symm rfl).symm

theorem coverSelfSection_comp_coverSelfRelativeFieldIso
    (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    (coverSelfSection (k := k) (k' := k') T γ).left ≫
        (coverSelfRelativeFieldIso (k := k) (k' := k') T).hom =
      relativeFieldSelfSection (k := k) (k' := k') T γ := by
  apply pullback.hom_ext <;>
    simp [coverSelfRelativeFieldIso, selfPullback_coverMap_left_iso,
      relativeFieldSelfSection, coverSelfSection, twistTest, twistLeft]

theorem coverSelfSection_jointlySurjective
    (T : Over (Spec (CommRingCat.of k))) :
    ∀ x : (pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left,
      ∃ (γ : k' ≃ₐ[k] k')
        (y : ((restrictTest k k').obj (baseTest (k' := k') T)).left),
        (coverSelfSection (k := k) (k' := k') T γ).left y = x := by
  intro x
  obtain ⟨γ, y, hy⟩ := relativeFieldSelfSection_jointlySurjective
    (k := k) (k' := k') T
    ((coverSelfRelativeFieldIso (k := k) (k' := k') T).hom x)
  refine ⟨γ, y, ?_⟩
  apply (Scheme.homeoOfIso
    (coverSelfRelativeFieldIso (k := k) (k' := k') T)).injective
  rw [← Scheme.Hom.comp_apply, coverSelfSection_comp_coverSelfRelativeFieldIso]
  exact hy

noncomputable def coverSelfSectionOpenCover
    (T : Over (Spec (CommRingCat.of k))) :
    Scheme.OpenCover
      (pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).left :=
  Scheme.Cover.mkOfCovers (P := @IsOpenImmersion) (k' ≃ₐ[k] k')
    (fun _ => ((restrictTest k k').obj (baseTest (k' := k') T)).left)
    (fun γ => (coverSelfSection (k := k) (k' := k') T γ).left)
    (coverSelfSection_jointlySurjective (k := k) (k' := k') T)
    (fun γ => isOpenImmersion_coverSelfSection_left T γ)

theorem coverSelfSection_hom_ext
    (T : Over (Spec (CommRingCat.of k))) {Z : Scheme.{u}}
    {a b : (pullback (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T)).left ⟶ Z}
    (h : ∀ γ : k' ≃ₐ[k] k',
      (coverSelfSection (k := k) (k' := k') T γ).left ≫ a =
        (coverSelfSection (k := k) (k' := k') T γ).left ≫ b) :
    a = b :=
  Scheme.Cover.hom_ext (coverSelfSectionOpenCover (k := k) (k' := k') T) a b h

theorem coverSelfSection_generate_mem_etaleTopology
    (T : Over (Spec (CommRingCat.of k))) :
    Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      etaleTopologyOver k (pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)) :=
  hcov_of_jointlySurjective T
    (coverSelfSection_jointlySurjective (k := k) (k' := k') T)

end AlgebraicJacobian.GaloisDescent
