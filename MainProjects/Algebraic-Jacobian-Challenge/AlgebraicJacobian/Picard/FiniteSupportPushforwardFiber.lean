/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.RigidPushforwardTransfer
import AlgebraicJacobian.Picard.RigidPushforwardRank

/-!
# Fibres of pushforwards with finite schematic support

This file isolates the fibre calculation used by the divisor-to-Grassmannian
construction.  If a quasi-coherent module has schematic support finite over an
affine base, its pushforward commutes with residue-field base change.  Hence the
fibre rank of its top section module computes fibre `H⁰`.

The final theorem also closes the affine carrier mismatch between that
ring-level fibre rank and `Scheme.Modules.pointRank`.  The transport is along
`Scheme.ΓSpecIso`; it requires no flatness or finiteness hypothesis on the
section module.  Applied to a twisted divisor family, this is the rank
calculation in Kleiman, *The Picard scheme*, Section 3, `sb:Q` and `ex:DivC`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

noncomputable section

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-- On an affine spectrum, geometric point rank is the fibre rank of top
sections over the original coordinate ring.  The definition of `pointRank`
uses the isomorphic ring `Γ(Spec R, ⊤)`; this theorem performs the missing
`ΓSpecIso` transport, including the induced residue-field equivalence. -/
theorem pointRank_spec_eq_fiberRank_gammaTop
    {R : CommRingCat.{u}} (M : (Spec R).Modules) [M.IsQuasicoherent]
    (t : PrimeSpectrum R) :
    pointRank (Spec R) M t =
      Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber Γ(M, (⊤ : (Spec R).Opens))) := by
  let hTop : IsAffineOpen (⊤ : (Spec R).Opens) := isAffineOpen_top (Spec R)
  let xTop : (⊤ : (Spec R).Opens) := ⟨t, trivial⟩
  let p := hTop.primeIdealOf xTop
  have hp : p = Spec.map (Scheme.ΓSpecIso R).hom t := by
    haveI : IsIso hTop.fromSpec := by
      rw [IsAffineOpen.fromSpec_top]
      infer_instance
    apply (ConcreteCategory.bijective_of_isIso hTop.fromSpec.base).injective
    rw [hTop.fromSpec_primeIdealOf, IsAffineOpen.fromSpec_top,
      ← Scheme.isoSpec_Spec_hom]
    rw [← Scheme.Hom.comp_apply, Iso.hom_inv_id]
    rfl
  have hpIdeal : p.asIdeal =
      t.asIdeal.comap (Scheme.ΓSpecIso R).hom.hom := by
    exact congrArg PrimeSpectrum.asIdeal hp
  rw [pointRank_eq_chartFiberRank M (V := ⟨⊤, hTop⟩) t trivial]
  change Module.finrank p.asIdeal.ResidueField
      (p.asIdeal.Fiber Γ(M, (⊤ : (Spec R).Opens))) =
    Module.finrank t.asIdeal.ResidueField
      (t.asIdeal.Fiber Γ(M, (⊤ : (Spec R).Opens)))
  refine finrank_tensor_eq_of_ringEquiv
    (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv
    (Ideal.residueFieldRingEquiv p.asIdeal t.asIdeal
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv hpIdeal) ?_
    (AddEquiv.refl _) ?_
  · intro r
    change Ideal.ResidueField.map p.asIdeal t.asIdeal
      (Scheme.ΓSpecIso R).hom.hom hpIdeal
        (algebraMap Γ(Spec R, (⊤ : (Spec R).Opens))
          p.asIdeal.ResidueField r) =
      algebraMap R t.asIdeal.ResidueField
        ((Scheme.ΓSpecIso R).hom.hom r)
    exact Ideal.ResidueField.map_algebraMap p.asIdeal t.asIdeal
      (Scheme.ΓSpecIso R).hom.hom hpIdeal r
  · intro r n
    change r • n =
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv r • n
    rw [smul_gammaSpecTop M
      ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv r) n]
    change r • n = (Scheme.ΓSpecIso R).inv.hom
      ((Scheme.ΓSpecIso R).hom.hom r) • n
    rw [← CommRingCat.comp_apply, Iso.hom_inv_id]
    rfl

set_option maxHeartbeats 1600000 in
-- Support descent expands two affine base-change transports; the default budget
-- times out before the affine-instance reduction finishes.
set_option synthInstance.maxHeartbeats 400000 in
/-- **Finite-support base change.**  A quasi-coherent module whose schematic
support is finite over the base has the expected arbitrary base-change
isomorphism.  The support descent presentation turns the statement into the
affine base-change theorem twice: once for the finite support map and once for
its closed immersion into the ambient scheme.  No flatness of the base change
is used. -/
noncomputable def pullbackPushforwardIso_of_isFinite_schematicSupport
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) (F : X.Modules) [F.IsQuasicoherent]
    (hfin : IsFinite (schematicSupportι F ≫ f)) :
    (pullback g).obj ((pushforward f).obj F) ≅
      (pushforward f').obj ((pullback g').obj F) := by
  let i := schematicSupportι F
  let N := (pullback i).obj F
  haveI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom F.annihilator.subschemeι)
  haveI : IsFinite (i ≫ f) := hfin
  haveI : IsAffineHom (i ≫ f) := inferInstance
  have sq₁ : IsPullback (Limits.pullback.fst i g') (Limits.pullback.snd i g') i g' :=
    IsPullback.of_hasPullback _ _
  have sqZ : IsPullback (Limits.pullback.fst i g')
      (Limits.pullback.snd i g' ≫ f') (i ≫ f) g :=
    sq₁.paste_vert sq
  haveI : IsAffineHom (Limits.pullback.snd i g') :=
    MorphismProperty.pullback_snd _ _ (inferInstance : IsAffineHom i)
  haveI : IsAffineHom (Limits.pullback.snd i g' ≫ f') :=
    MorphismProperty.of_isPullback sqZ inferInstance
  haveI : N.IsQuasicoherent := pullback_isQuasicoherent_hom i F inferInstance
  let hdesc : F ≅ (pushforward i).obj N := schematicSupportDescentIso F
  let eSupport := AlgebraicGeometry.pushforwardPullbackBaseChangeIso sqZ N
  let eImmersion := AlgebraicGeometry.pushforwardPullbackBaseChangeIso sq₁ N
  exact (pullback g).mapIso
      ((pushforward f).mapIso hdesc ≪≫
        ((pushforwardComp i f).app N).symm) ≪≫
    eSupport ≪≫
    (pushforwardComp (Limits.pullback.snd i g') f').app _ ≪≫
    (pushforward f').mapIso
      (eImmersion.symm ≪≫ (pullback g').mapIso hdesc.symm)

set_option backward.isDefEq.respectTransparency false in
/-- The fibre of affine global sections computes fibre `H⁰` once pushforward
commutes with the residue-field base change. -/
theorem fiberRank_gammaTop_eq_fiberH0_of_iso
    {R : CommRingCat.{u}} {X : Scheme.{u}} (f : X ⟶ Spec R)
    (F : X.Modules) [F.IsQuasicoherent] [QuasiCompact f] [QuasiSeparated f]
    (t : PrimeSpectrum R)
    (e : (Scheme.Modules.pullback
          ((Spec R).fromSpecResidueField (t : Spec R))).obj
          ((pushforward f).obj F) ≅
        (pushforward (f.fiberToSpecResidueField t)).obj (f.fiberModule t F)) :
    Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber
          Γ((pushforward f).obj F, (⊤ : (Spec R).Opens))) =
      f.fiberH0 F t := by
  let M := (pushforward f).obj F
  haveI : M.IsQuasicoherent := pushforward_isQuasicoherent f F
  letI aRK : Algebra Γ(Spec R, ⊤)
      Γ(Spec ((Spec R).residueField t), ⊤) :=
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  have step₁ : Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber Γ(M, (⊤ : (Spec R).Opens))) =
      Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (TensorProduct Γ(Spec R, ⊤)
          Γ(Spec ((Spec R).residueField t), ⊤) Γ(M, ⊤)) := by
    refine finrank_tensor_eq_of_ringEquiv
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm
      (specResidueFieldRingEquiv R t) ?_ (AddEquiv.refl _) ?_
    · intro r
      have h := appLE_fromSpecResidueField_apply R t
        ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm r)
      rw [RingEquiv.apply_symm_apply] at h
      exact h.symm
    · intro r n
      rw [smul_gammaSpecTop M r n]
      rfl
  obtain ⟨⟨ePull, -⟩⟩ := pullback_app_isoTensor_baseMap_sectionLinearEquiv
    ((Spec R).fromSpecResidueField (t : Spec R)) M (isAffineOpen_top _)
      (isAffineOpen_top _) le_top
  letI fiberBase := (f.fiberToSpecResidueField t).baseSectionsModule
    (f.fiberModule t F) (⊤ : (f.fiber t).Opens)
  let eSheaf : Γ(((Scheme.Modules.pullback
      ((Spec R).fromSpecResidueField t)).obj M), ⊤) ≃ₗ[
        Γ(Spec ((Spec R).residueField t), ⊤)]
      Γ(((Scheme.Modules.pushforward (f.fiberToSpecResidueField t)).obj
        (f.fiberModule t F)), ⊤) := by
    let eAdd := ((toPresheafOfModules (Spec ((Spec R).residueField t)) ⋙
      PresheafOfModules.evaluation (Spec ((Spec R).residueField t)).ringCatSheaf.obj
        (Opposite.op ⊤)).mapIso e).toLinearEquiv.toAddEquiv
    refine eAdd.toLinearEquiv ?_
    intro r x
    exact Scheme.Modules.Hom.app_smul e.hom r x
  let ePush := Scheme.Modules.pushforwardTopEquivBaseSections
    (f.fiberToSpecResidueField t) (f.fiberModule t F)
  let eΓ := eSheaf.trans ePush
  have step₂ : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (TensorProduct Γ(Spec R, ⊤)
          Γ(Spec ((Spec R).residueField t), ⊤) Γ(M, ⊤)) =
      Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        Γ((f.fiberModule t F), ⊤) := by
    exact (LinearEquiv.finrank_eq ePull).trans (LinearEquiv.finrank_eq eΓ)
  have step₃ : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        Γ((f.fiberModule t F), ⊤) = f.fiberH0 F t := by
    letI := f.fiberSectionsModule t (f.fiberModule t F)
    refine finrank_eq_of_ringEquiv_addEquiv
      (Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv
      (AddEquiv.refl _) ?_
    intro r m
    change r • m = _
    rw [Scheme.Hom.baseSectionsModule_smul_def]
    change _ = ((f.fiberResidueMap t).hom
      ((Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv r)) • m
    congr 1
    simp only [Scheme.Hom.fiberResidueMap, CommRingCat.hom_comp, RingHom.comp_apply]
    have hLE : (f.fiberToSpecResidueField t).appLE ⊤ ⊤ le_top =
        (f.fiberToSpecResidueField t).appTop := Scheme.Hom.appLE_eq_app _
    rw [hLE]
    congr 1
    have h₁ := congrArg (fun φ : Γ(Spec ((Spec R).residueField t), ⊤) ⟶
        Γ(Spec ((Spec R).residueField t), ⊤) => φ.hom r)
      (Scheme.ΓSpecIso ((Spec R).residueField t)).hom_inv_id
    simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_id,
      RingHom.id_apply] at h₁
    exact h₁.symm
  exact step₁.trans (step₂.trans step₃)

theorem fiberRank_gammaTop_eq_fiberH0_of_isFinite_schematicSupport
    {R : CommRingCat.{u}} {X : Scheme.{u}} (f : X ⟶ Spec R)
    (F : X.Modules) [F.IsQuasicoherent] [QuasiCompact f] [QuasiSeparated f]
    (hfin : IsFinite (schematicSupportι F ≫ f)) (t : PrimeSpectrum R) :
    Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber
          Γ((pushforward f).obj F, (⊤ : (Spec R).Opens))) =
      f.fiberH0 F t :=
  fiberRank_gammaTop_eq_fiberH0_of_iso f F t
    (pullbackPushforwardIso_of_isFinite_schematicSupport
      (IsPullback.of_hasPullback f
        ((Spec R).fromSpecResidueField (t : Spec R))) F hfin)

/-- A quasi-coherent module with finite schematic support has point rank equal
to the `H⁰` dimension of its geometric fibre.  This composes finite-support
base change with the affine `ΓSpecIso` carrier transport and requires neither
flatness nor projectivity of the pushforward. -/
theorem pointRank_pushforward_eq_fiberH0_of_isFinite_schematicSupport
    {R : CommRingCat.{u}} {X : Scheme.{u}} (f : X ⟶ Spec R)
    (F : X.Modules) [F.IsQuasicoherent] [QuasiCompact f] [QuasiSeparated f]
    (hfin : IsFinite (schematicSupportι F ≫ f)) (t : PrimeSpectrum R) :
    pointRank (Spec R) ((pushforward f).obj F) t = f.fiberH0 F t := by
  letI : ((pushforward f).obj F).IsQuasicoherent :=
    pushforward_isQuasicoherent f F
  exact (pointRank_spec_eq_fiberRank_gammaTop ((pushforward f).obj F) t).trans
    (fiberRank_gammaTop_eq_fiberH0_of_isFinite_schematicSupport f F hfin t)

end Modules

end Scheme

end AlgebraicGeometry
