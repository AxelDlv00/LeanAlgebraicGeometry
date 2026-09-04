/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianClass
import AlgebraicJacobian.Picard.FiniteSupportTwistRank
import AlgebraicJacobian.Picard.PullbackTensorOneSided
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf
import AlgebraicJacobian.Projective.EffectiveCartierSupport

/-!
# Fibre rank of a finite-support line-bundle twist

This file supplies the fibre-rank producer required by the divisor-to-Grassmannian
route.  A quasi-coherent module descends to its schematic support without changing
global sections.  When that support is finite over a field, tensoring by a locally
trivial module preserves the dimension of global sections.  Applying the result to
the fibre of a divisor family identifies the fibre `H^0` of its twist with the
divisor's fibre degree.

No Riemann--Roch or global-generation hypothesis enters this equality.  Those
hypotheses belong to the evaluation epimorphism, not to the rank of a line bundle
restricted to a finite divisor.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite
open scoped AlgebraicGeometry TensorProduct

noncomputable section

namespace AlgebraicGeometry

namespace Scheme.Modules

/-! ## Global sections and support descent -/

/-- An isomorphism `F ~= i_* N` preserves the dimension of global sections over
the field below `i`.  The scalar compatibility is the identity
`(i >> p).appTop = i.appTop >> p.appTop`. -/
theorem finrank_globalSections_eq_of_iso_pushforward
    {K : CommRingCat.{u}} (hK : IsField K) {Y D : Scheme.{u}}
    (p : Y ⟶ Spec K) (i : D ⟶ Y)
    {F : Y.Modules} (N : D.Modules)
    (hdesc : F ≅ (pushforward i).obj N) :
    (letI : Field K := hK.toField
     let α : K →+* Γ(Y, (⊤ : Y.Opens)) :=
      p.appTop.hom.comp ((Scheme.ΓSpecIso K).inv.hom)
     letI : Module K Γ(F, (⊤ : Y.Opens)) := Module.compHom _ α
     letI : Module K Γ(N, (⊤ : D.Opens)) :=
       Module.compHom _ ((i ≫ p).appTop.hom.comp
         ((Scheme.ΓSpecIso K).inv.hom))
     Module.finrank K Γ(F, (⊤ : Y.Opens)) =
       Module.finrank K Γ(N, (⊤ : D.Opens))) := by
  letI : Field K := hK.toField
  dsimp
  let pD := i ≫ p
  let αY : K →+* Γ(Y, (⊤ : Y.Opens)) :=
    p.appTop.hom.comp ((Scheme.ΓSpecIso K).inv.hom)
  let αD : K →+* Γ(D, (⊤ : D.Opens)) :=
    pD.appTop.hom.comp ((Scheme.ΓSpecIso K).inv.hom)
  letI : Module K Γ(F, (⊤ : Y.Opens)) := Module.compHom _ αY
  letI : Module Γ(Y, (⊤ : Y.Opens)) Γ(N, (⊤ : D.Opens)) :=
    Module.compHom _ i.appTop.hom
  letI : Module K Γ(N, (⊤ : D.Opens)) := Module.compHom _ αD
  letI := i.baseSectionsModule N (⊤ : D.Opens)
  let γ₀ : Γ(F, (⊤ : Y.Opens)) ≃ₗ[Γ(Y, (⊤ : Y.Opens))]
      Γ((pushforward i).obj N, (⊤ : Y.Opens)) :=
    ((toPresheafOfModules Y ⋙
      PresheafOfModules.evaluation Y.ringCatSheaf.obj
        (Opposite.op (⊤ : Y.Opens))).mapIso hdesc).toLinearEquiv
  let γ := γ₀ ≪≫ₗ pushforwardTopEquivBaseSections i N
  let eK : Γ(F, (⊤ : Y.Opens)) ≃ₗ[K] Γ(N, (⊤ : D.Opens)) :=
    { toFun := fun z => γ z
      invFun := fun z => γ.symm z
      map_add' := γ.map_add
      map_smul' := by
        intro c z
        change γ (αY c • z) = αD c • γ z
        rw [γ.map_smul, i.baseSectionsModule_smul_def]
        have hscalar :
            (i.appLE (⊤ : Y.Opens) (⊤ : D.Opens) le_top).hom (αY c) = αD c := by
          change (i.appLE (⊤ : Y.Opens) (⊤ : D.Opens) le_top).hom (αY c) =
            (i.app (⊤ : Y.Opens)).hom (αY c)
          exact congrArg (fun (φ : Γ(Y, ⊤) ⟶ Γ(D, ⊤)) => φ.hom (αY c))
            (Scheme.Hom.appLE_eq_app i)
        rw [hscalar]
      left_inv := γ.left_inv
      right_inv := γ.right_inv }
  exact eK.finrank_eq

/-- Passing from a quasi-coherent module to its restriction to the schematic
support does not change the dimension of global sections over a base field. -/
theorem finrank_globalSections_eq_pullback_schematicSupport
    {K : CommRingCat.{u}} (hK : IsField K) {Y : Scheme.{u}}
    (p : Y ⟶ Spec K)
    {F : Y.Modules} [F.IsQuasicoherent] :
    (letI : Field K := hK.toField
     let α : K →+* Γ(Y, (⊤ : Y.Opens)) :=
      p.appTop.hom.comp ((Scheme.ΓSpecIso K).inv.hom)
     letI : Module K Γ(F, (⊤ : Y.Opens)) := Module.compHom _ α
     letI : Module K Γ((pullback (schematicSupportι F)).obj F,
        (⊤ : (schematicSupport F).Opens)) :=
       Module.compHom _ ((schematicSupportι F ≫ p).appTop.hom.comp
         ((Scheme.ΓSpecIso K).inv.hom))
     Module.finrank K Γ(F, (⊤ : Y.Opens)) =
       Module.finrank K Γ((pullback (schematicSupportι F)).obj F,
         (⊤ : (schematicSupport F).Opens))) :=
  finrank_globalSections_eq_of_iso_pushforward hK p (schematicSupportι F)
    ((pullback (schematicSupportι F)).obj F) (schematicSupportDescentIso F)

/-! ## Tensor rank on finite support -/

/-- Tensoring a quasi-coherent module by a locally trivial module preserves
the dimension of global sections when the original module has finite schematic
support over the base field. -/
theorem finrank_globalSections_tensor_of_finite_support
    {K : CommRingCat.{u}} (hK : IsField K) {Y : Scheme.{u}}
    (p : Y ⟶ Spec K)
    {L F : Y.Modules} (hL : LineBundle.IsLocallyTrivial L)
    [F.IsQuasicoherent]
    (hfin : IsFinite (schematicSupportι F ≫ p)) :
    (letI : Field K := hK.toField
     let α : K →+* Γ(Y, (⊤ : Y.Opens)) :=
      p.appTop.hom.comp ((Scheme.ΓSpecIso K).inv.hom)
     letI : Algebra K Γ(Y, (⊤ : Y.Opens)) := α.toAlgebra
     letI : Module K Γ(F, (⊤ : Y.Opens)) := Module.compHom _ α
     letI : Module K Γ(tensorObj L F, (⊤ : Y.Opens)) := Module.compHom _ α
     Module.finrank K Γ(tensorObj L F, (⊤ : Y.Opens)) =
       Module.finrank K Γ(F, (⊤ : Y.Opens))) := by
  letI : Field K := hK.toField
  dsimp
  let i := schematicSupportι F
  let D := schematicSupport F
  let N := (pullback i).obj F
  let pD := i ≫ p
  letI : IsFinite pD := hfin
  haveI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom (annihilator F).subschemeι)
  haveI : IsAffineHom pD := IsFinite.toIsAffineHom
  haveI : N.IsQuasicoherent := pullback_isQuasicoherent_hom i F inferInstance
  have hdim := finrank_globalSections_tensor_of_finite hK pD
    (hL.pullback i) (F := N)
  have hFsupport := finrank_globalSections_eq_pullback_schematicSupport hK p (F := F)
  haveI : L.IsQuasicoherent := by
    haveI := hL.isFinitePresentation
    infer_instance
  haveI : (tensorObj L F).IsQuasicoherent := tensorObj_isQuasicoherent L F
  have hAnn : annihilator (tensorObj L F) = annihilator F :=
    annihilator_tensorObj_eq_right_of_isLocallyTrivial_support L F hL
  let NT := (pullback i).obj (tensorObj L F)
  haveI hunitT : IsIso
      ((pullbackPushforwardAdjunction i).unit.app (tensorObj L F)) := by
    dsimp [i]
    exact isIso_unit_subschemeι_of_le_annihilator (annihilator F)
      (tensorObj L F) (fun U => by
        rw [← hAnn]
        exact annihilator_ideal_le (tensorObj L F) U)
  let hdescT : tensorObj L F ≅ (pushforward i).obj NT :=
    @asIso _ _ _ _ _ hunitT
  have hTsupport := finrank_globalSections_eq_of_iso_pushforward hK p i NT hdescT
  let ePull : (pullback i).obj (tensorObj L F) ≅
      tensorObj ((pullback i).obj L) N :=
    (pullback i).mapIso (tensorObj_braiding L F) ≪≫
      pullbackTensorIsoOfRightLocallyTrivial i F L hL ≪≫
      tensorObj_braiding ((pullback i).obj F) ((pullback i).obj L)
  let αD : K →+* Γ(D, (⊤ : D.Opens)) :=
    pD.appTop.hom.comp ((Scheme.ΓSpecIso K).inv.hom)
  letI : Module K Γ((pullback i).obj (tensorObj L F), (⊤ : D.Opens)) :=
    Module.compHom _ αD
  letI : Module K Γ(tensorObj ((pullback i).obj L) N, (⊤ : D.Opens)) :=
    Module.compHom _ αD
  let ePullK : Γ((pullback i).obj (tensorObj L F), (⊤ : D.Opens)) ≃ₗ[K]
      Γ(tensorObj ((pullback i).obj L) N, (⊤ : D.Opens)) :=
    { toFun := (Hom.app ePull.hom (⊤ : D.Opens)).hom
      invFun := (Hom.app ePull.inv (⊤ : D.Opens)).hom
      map_add' := map_add _
      map_smul' := by
        intro c z
        change (Hom.app ePull.hom (⊤ : D.Opens)).hom (αD c • z) = _
        exact Hom.app_smul ePull.hom (αD c) z
      left_inv := by
        intro z
        change (Hom.app (ePull.hom ≫ ePull.inv) (⊤ : D.Opens)).hom z = z
        rw [ePull.hom_inv_id]
        rfl
      right_inv := by
        intro z
        change (Hom.app (ePull.inv ≫ ePull.hom) (⊤ : D.Opens)).hom z = z
        rw [ePull.inv_hom_id]
        rfl }
  have hPull := ePullK.finrank_eq
  dsimp at hdim hFsupport hTsupport
  exact hTsupport.trans (hPull.trans (hdim.trans hFsupport.symm))

end Scheme.Modules

namespace Scheme.DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S}

/-- The fibre `H^0` of a line-bundle twist of a divisor module equals the
divisor's fibre degree once the divisor fibre has finite schematic support.
This is the rank input for the D2 Grassmannian target. -/
theorem fiberH0_twist_eq_fiberDeg_of_isFiniteSupport
    {T : Over S} (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (t : (T.left : Scheme.{u}))
    (hfin : IsFinite
      (Modules.schematicSupportι
        ((pullback.snd π T.hom).fiberModule t x.F) ≫
          (pullback.snd π T.hom).fiberToSpecResidueField t)) :
    (pullback.snd π T.hom).fiberH0 (x.twist L) t = x.fiberDeg t := by
  let q := pullback.snd π T.hom
  let LT := (Modules.pullback (pullback.fst π T.hom)).obj L
  let A := q.fiberModule t LT
  let G := q.fiberModule t x.F
  have hLT : LineBundle.IsLocallyTrivial LT :=
    hL.pullback (pullback.fst π T.hom)
  have hA : LineBundle.IsLocallyTrivial A := hLT.pullback (q.fiberι t)
  haveI : x.F.IsQuasicoherent := by
    letI := x.isFinitePresentation
    infer_instance
  haveI : G.IsQuasicoherent := pullback_isQuasicoherent_hom (q.fiberι t) x.F inferInstance
  let eFiber : q.fiberModule t (x.twist L) ≅ Modules.tensorObj A G :=
    (Modules.pullback (q.fiberι t)).mapIso
        (Modules.tensorObj_braiding LT x.F) ≪≫
      Modules.pullbackTensorIsoOfRightLocallyTrivial
        (q.fiberι t) x.F LT hLT ≪≫
      Modules.tensorObj_braiding G A
  have hIso := finrank_fiberSections_eq_of_iso q t eFiber
  have hdim := Modules.finrank_globalSections_tensor_of_finite_support
    (Field.toIsField (T.left.residueField t))
    (q.fiberToSpecResidueField t) hA (F := G) hfin
  exact hIso.trans (by
    convert hdim using 1 <;> rfl)

/-- On a smooth proper geometrically integral relative curve, twisting a
relative effective Cartier divisor by a line bundle preserves its fibre
`H^0`-dimension.  The finite-support hypothesis of
`fiberH0_twist_eq_fiberDeg_of_isFiniteSupport` is supplied by the curve
geometry in `isFinite_schematicSupport_fiberModule_of_curve`. -/
theorem fiberH0_twist_eq_fiberDeg_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    {T : Over S} (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (t : (T.left : Scheme.{u})) :
    (pullback.snd π T.hom).fiberH0 (x.twist L) t = x.fiberDeg t :=
  fiberH0_twist_eq_fiberDeg_of_isFiniteSupport L hL x t
    (isFinite_schematicSupport_fiberModule_of_curve T π x t)

end Scheme.DivFamily

end AlgebraicGeometry
