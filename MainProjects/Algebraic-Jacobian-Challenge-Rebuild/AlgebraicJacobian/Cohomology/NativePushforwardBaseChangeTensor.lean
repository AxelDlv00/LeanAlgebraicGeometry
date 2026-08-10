/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.AlgebraicGeometry.Modules.Tilde

/-!
# Pullback of a tilde module along a morphism of affine schemes

This file supplies the affine tensor dictionary needed by native pushforward base change.
For a ring map `A \to B`, pullback along `Spec B \to Spec A` takes the tilde sheaf of an
`A`-module to the tilde sheaf of its scalar extension to `B`.

The proof uses uniqueness of left adjoints.  The only comparison required on the right-adjoint
side is that global sections after pushforward along `Spec.map phi` are restriction of scalars
along `phi`; on underlying sections this is restriction along `top <= (Spec.map phi) ^-1(top)`,
which is the identity.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace Opposite

namespace AlgebraicGeometry

open Scheme Scheme.Modules

set_option backward.isDefEq.respectTransparency false in
private lemma modulesRestrictionPreimageTopEqId {X Y : Scheme.{u}} (g : Y ⟶ X)
    (N : Y.Modules) (e : (⊤ : Y.Opens) ≤ g ⁻¹ᵁ ⊤) :
    N.presheaf.map (homOfLE e).op = 𝟙 _ :=
  (congrArg N.presheaf.map
    (show (homOfLE e).op = 𝟙 (Opposite.op (⊤ : Y.Opens)) from rfl)).trans
    (N.presheaf.map_id _)

set_option backward.isDefEq.respectTransparency false in
private lemma ringRestrictionPreimageTopEqId {X Y : Scheme.{u}} (g : Y ⟶ X)
    (e : (⊤ : Y.Opens) ≤ g ⁻¹ᵁ ⊤) :
    Y.presheaf.map (homOfLE e).op = 𝟙 _ :=
  (congrArg Y.presheaf.map
    (show (homOfLE e).op = 𝟙 (Opposite.op (⊤ : Y.Opens)) from rfl)).trans
    (Y.presheaf.map_id _)

set_option backward.isDefEq.respectTransparency false in
private noncomputable def pullbackTildeGammaBridgeHom {A B : CommRingCat.{u}}
    (phi : A ⟶ B) (N : (Spec B).Modules) :
    (Scheme.Modules.pushforward (Spec.map phi) ⋙ moduleSpecΓFunctor (R := A)).obj N ⟶
      (moduleSpecΓFunctor (R := B) ⋙ ModuleCat.restrictScalars phi.hom).obj N :=
  ConcreteCategory.ofHom
    { toFun := fun x =>
        (N.presheaf.map (homOfLE (le_top :
          (⊤ : (Spec B).Opens) ≤ Spec.map phi ⁻¹ᵁ ⊤)).op).hom x
      map_add' := fun x y => map_add _ x y
      map_smul' := fun a x =>
        (Scheme.Modules.map_smul N (homOfLE (le_top :
          (⊤ : (Spec B).Opens) ≤ Spec.map phi ⁻¹ᵁ ⊤))
          (((Spec.map phi).app ⊤).hom ((Scheme.ΓSpecIso A).inv.hom a)) x).trans
        (congrArg (fun r => r • (N.presheaf.map (homOfLE (le_top :
            (⊤ : (Spec B).Opens) ≤ Spec.map phi ⁻¹ᵁ ⊤)).op).hom x)
          ((congrArg (fun (k : Γ(Spec B, Spec.map phi ⁻¹ᵁ ⊤) ⟶ Γ(Spec B, ⊤)) =>
              k.hom (((Spec.map phi).app ⊤).hom ((Scheme.ΓSpecIso A).inv.hom a)))
            (ringRestrictionPreimageTopEqId (Spec.map phi) le_top)).trans
           ((congrArg (fun (psi : A ⟶ Γ(Spec B, ⊤)) => psi.hom a)
              (Scheme.ΓSpecIso_inv_naturality phi)).symm))) }

set_option backward.isDefEq.respectTransparency false in
private lemma pullbackTildeGammaBridgeHom_isIso {A B : CommRingCat.{u}}
    (phi : A ⟶ B) (N : (Spec B).Modules) :
    IsIso (pullbackTildeGammaBridgeHom phi N) := by
  rw [ConcreteCategory.isIso_iff_bijective]
  change Function.Bijective (fun x => (N.presheaf.map (homOfLE (le_top :
    (⊤ : (Spec B).Opens) ≤ Spec.map phi ⁻¹ᵁ ⊤)).op).hom x)
  rw [modulesRestrictionPreimageTopEqId (Spec.map phi) N le_top]
  exact Function.bijective_id

set_option backward.isDefEq.respectTransparency false in
private noncomputable def pullbackTildeGammaBridge {A B : CommRingCat.{u}}
    (phi : A ⟶ B) :
    Scheme.Modules.pushforward (Spec.map phi) ⋙ moduleSpecΓFunctor (R := A) ≅
      moduleSpecΓFunctor (R := B) ⋙ ModuleCat.restrictScalars phi.hom := by
  refine NatIso.ofComponents
    (fun N => @asIso _ _ _ _ _ (pullbackTildeGammaBridgeHom_isIso phi N))
    (fun {N N'} h => ?_)
  ext x
  exact (congrArg (fun (k : Γ(N, Spec.map phi ⁻¹ᵁ ⊤) ⟶ Γ(N', ⊤)) => k.hom x)
    ((Scheme.Modules.Hom.mapPresheaf h).naturality (homOfLE (le_top :
      (⊤ : (Spec B).Opens) ≤ Spec.map phi ⁻¹ᵁ ⊤)).op)).symm

set_option backward.isDefEq.respectTransparency false in
/-- Pullback along `Spec.map phi` carries a tilde module to the tilde of scalar extension.

This is the affine `pullback of tilde = tilde of tensor product` comparison (Stacks 01HQ).
It is canonical: it is the uniqueness isomorphism between two left adjoints of global sections
with restriction of scalars. -/
noncomputable def Scheme.Modules.pullbackTildeIso {A B : CommRingCat.{u}}
    (phi : A ⟶ B) :
    tilde.functor A ⋙ Scheme.Modules.pullback (Spec.map phi) ≅
      ModuleCat.extendScalars phi.hom ⋙ tilde.functor B :=
  Adjunction.leftAdjointUniq
    (((tilde.adjunction (R := A)).comp
      (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map phi))).ofNatIsoRight
      (pullbackTildeGammaBridge phi))
    ((ModuleCat.extendRestrictScalarsAdj phi.hom).comp (tilde.adjunction (R := B)))

end AlgebraicGeometry
