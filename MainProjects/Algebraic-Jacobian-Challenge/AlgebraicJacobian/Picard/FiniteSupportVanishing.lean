/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivFamilyZero
import AlgebraicJacobian.Picard.DivCurvePushforwardProducers

/-!
# Vanishing of modules with finite support

Global sections detect a quasi-coherent module on an affine scheme.  By descent
to schematic support, the same holds for a module whose support is finite over
an affine base.  This supplies the vanishing step for degree-zero effective
divisors in Kleiman, *The Picard scheme*, Section 3, `ex:DivC`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace AlgebraicGeometry.Scheme.Modules

/-- A quasi-coherent module on a spectrum is zero when its global sections are
zero.  The affine module equivalence supplies the implication. -/
theorem isZero_of_subsingleton_sections_spec
    {R : CommRingCat.{u}} (F : (Spec R).Modules) [F.IsQuasicoherent]
    (hF : Subsingleton Γ(F, (⊤ : (Spec R).Opens))) : IsZero F := by
  letI := hF
  haveI : Subsingleton (moduleSpecΓFunctor.obj F) := by
    change Subsingleton Γ(F, (⊤ : (Spec R).Opens))
    exact hF
  have hGamma : IsZero (moduleSpecΓFunctor.obj F) :=
    ModuleCat.isZero_of_subsingleton _
  exact IsZero.of_iso ((tilde.functor R).map_isZero hGamma)
    (qcoh_iso_tilde_sections F)

/-- Global sections detect vanishing of a quasi-coherent module on any affine
scheme, independently of a chosen presentation as a spectrum. -/
theorem isZero_of_subsingleton_sections_of_isAffine
    {X : Scheme.{u}} [IsAffine X] (F : X.Modules) [F.IsQuasicoherent]
    (hF : Subsingleton Γ(F, (⊤ : X.Opens))) : IsZero F := by
  let G := (pushforward X.isoSpec.hom).obj F
  letI := hF
  haveI : G.IsQuasicoherent := pushforward_isQuasicoherent X.isoSpec.hom F
  have hGamma : Subsingleton Γ(G, (⊤ : (Spec Γ(X, ⊤)).Opens)) :=
    Function.Injective.subsingleton
      (pushforwardTopEquivBaseSections X.isoSpec.hom F).injective
  have hG : IsZero G := isZero_of_subsingleton_sections_spec G hGamma
  rw [IsZero.iff_id_eq_zero]
  apply (pushforward X.isoSpec.hom).map_injective
  rw [CategoryTheory.Functor.map_id, CategoryTheory.Functor.map_zero]
  exact hG.eq_of_src _ _

/-- A quasi-coherent module with support finite over an affine base vanishes
when its global sections vanish.  The finite support is affine, so its
restricted module is detected by global sections; schematic support descent
then transports the vanishing to the ambient scheme. -/
theorem isZero_of_subsingleton_sections_of_isFinite_schematicSupport
    {X S : Scheme.{u}} [IsAffine S] (f : X ⟶ S)
    (F : X.Modules) [F.IsQuasicoherent]
    (hfin : IsFinite (schematicSupportι F ≫ f))
    (hF : Subsingleton Γ(F, (⊤ : X.Opens))) : IsZero F := by
  let i := schematicSupportι F
  let N := (pullback i).obj F
  letI : IsFinite (i ≫ f) := hfin
  haveI : IsAffine (schematicSupport F) := isAffine_of_isAffineHom (i ≫ f)
  haveI : N.IsQuasicoherent := pullback_isQuasicoherent_hom i F inferInstance
  let e : F ≅ (pushforward i).obj N := schematicSupportDescentIso F
  letI := hF
  have hPush : Subsingleton Γ((pushforward i).obj N, (⊤ : X.Opens)) := by
    exact Function.Injective.subsingleton
      (ConcreteCategory.bijective_of_isIso (e.inv.app ⊤)).injective
  letI := hPush
  have hN : Subsingleton Γ(N, (⊤ : (schematicSupport F).Opens)) :=
    Function.Injective.subsingleton
      (pushforwardTopEquivBaseSections i N).symm.injective
  exact IsZero.of_iso
    ((pushforward i).map_isZero (isZero_of_subsingleton_sections_of_isAffine N hN)) e

end AlgebraicGeometry.Scheme.Modules
