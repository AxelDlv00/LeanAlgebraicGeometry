/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors, The AlgebraicJacobian Contributors
-/

import HartshorneLib.Chapter2LineBundleGluingPullback
import HartshorneLib.Chapter2ModulePullbackFrames

/-!
# Pullback isomorphism for glued line bundles

The comparison with the module glued on a refinement of the inverse-image
cover is an isomorphism. Its proof checks the actual comparison on the local
generators in the chosen frames.

The local-generator argument is adapted from
`AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangePullback.lean`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry
open Scheme.Modules

namespace Hartshorne.LineBundleGluing

universe u v

noncomputable section

private lemma restrictUnitIso_hom_app_top_one
    {A B : Scheme.{u}} (j : A ⟶ B) [IsOpenImmersion j] :
    ((restrictUnitIso j).hom.app ⊤).hom
      (1 : Γ(B, j ''ᵁ (⊤ : A.Opens))) = (1 : Γ(A, ⊤)) := by
  let N : B.Modules := SheafOfModules.unit B.ringCatSheaf
  let er : (⊤ : A.Opens) ≤ j ⁻¹ᵁ j.opensRange :=
    le_of_eq (Scheme.Hom.preimage_opensRange j).symm
  have hopen := ModulePullbackFrames.open_hom_baseMap j N (1 : Γ(B, j.opensRange))
  have hcast : (N.presheaf.map
      (eqToHom (Scheme.Hom.image_top_eq_opensRange j)).op).hom
        (1 : Γ(B, j.opensRange)) = (1 : Γ(B, j ''ᵁ (⊤ : A.Opens))) := by
    exact map_one (B.presheaf.map
      (eqToHom (Scheme.Hom.image_top_eq_opensRange j)).op).hom
  rw [hcast] at hopen
  have hresOne : (N.presheaf.map
      (homOfLE (le_top : j.opensRange ≤ (⊤ : B.Opens))).op).hom
        (1 : Γ(B, ⊤)) = (1 : Γ(B, j.opensRange)) := by
    exact map_one (B.presheaf.map
      (homOfLE (le_top : j.opensRange ≤ (⊤ : B.Opens))).op).hom
  have hbase := ModulePullbackFrames.baseMap_res j N
    (le_top : (⊤ : A.Opens) ≤ j ⁻¹ᵁ (⊤ : B.Opens)) er
    (le_top : j.opensRange ≤ (⊤ : B.Opens)) (le_refl (⊤ : A.Opens))
    (1 : Γ(B, ⊤))
  rw [hresOne] at hbase
  have hbase' : ModulePullbackFrames.baseMap j N er (1 : Γ(B, j.opensRange)) =
      ModulePullbackFrames.baseMap j N
        (le_top : (⊤ : A.Opens) ≤ j ⁻¹ᵁ (⊤ : B.Opens)) (1 : Γ(B, ⊤)) := by
    exact hbase.symm.trans (ConcreteCategory.congr_hom
      (((Scheme.Modules.pullback j).obj N).presheaf.map_id (op (⊤ : A.Opens))) _)
  change ((ModulePullbackFrames.pullbackUnitIso j).hom.app ⊤).hom
      ((((restrictFunctorIsoPullback j).hom.app N).app ⊤).hom
        (1 : Γ(B, j ''ᵁ (⊤ : A.Opens)))) = _
  rw [hopen, hbase', ModulePullbackFrames.pullbackUnitIso_baseMap_one]

variable {X Y : Scheme.{max u v}} (f : X ⟶ Y)
variable {I : Type (max u v)} {J : Type v} (U : J → Y.Opens) (V : I → X.Opens)
  (g : ∀ i j, Γ(Y, U i ⊓ U j)ˣ) (h : ∀ i j, Γ(X, V i ⊓ V j)ˣ)
  (τ : I → J) (hV : ∀ i, V i ≤ f ⁻¹ᵁ U (τ i))
  (htrans : ∀ i j,
    f.appLE (U (τ i) ⊓ U (τ j)) (V i ⊓ V j)
      (le_inf (inf_le_left.trans (hV i)) (inf_le_right.trans (hV j)))
      (g (τ i) (τ j)).val = (h i j).val)

/-- The adjoint comparison sends the pullback of a section to its componentwise
pullback, also after restriction to a smaller source open. -/
lemma pullbackHom_baseMap {W : Y.Opens} {A : X.Opens}
    (e : A ≤ f ⁻¹ᵁ W) (s : sectionSubmodule U g W) :
    ((pullbackHom f U V g h τ hV htrans).app A).hom
        (ModulePullbackFrames.baseMap f (gluedModule U g) e s) =
      res V h e (pullbackSections f U V g h τ hV htrans W s) := by
  let φ := pullbackHom f U V g h τ hV htrans
  let η := (Scheme.Modules.pullbackPushforwardAdjunction f).unit.app (gluedModule U g)
  have hunit := congrArg
    (fun q : gluedModule U g ⟶ (Scheme.Modules.pushforward f).obj (gluedModule V h) =>
      (q.app W).hom s)
    (unit_comp_pushforward_pullbackHom f U V g h τ hV htrans)
  have hnat := congrArg (fun q => q.hom ((η.app W).hom s))
    ((Scheme.Modules.Hom.mapPresheaf φ).naturality (homOfLE e).op)
  change (φ.app A).hom
      ((((Scheme.Modules.pullback f).obj (gluedModule U g)).presheaf.map
        (homOfLE e).op).hom ((η.app W).hom s)) =
    ((gluedModule V h).presheaf.map (homOfLE e).op).hom
      ((φ.app (f ⁻¹ᵁ W)).hom ((η.app W).hom s)) at hnat
  change (φ.app (f ⁻¹ᵁ W)).hom ((η.app W).hom s) =
    pullbackSections f U V g h τ hV htrans W s at hunit
  exact hnat.trans (congrArg
    (fun t => ((gluedModule V h).presheaf.map (homOfLE e).op).hom t) hunit)

set_option maxRecDepth 4000 in
/-- The pullback comparison is an isomorphism when the refinement covers the
source and both families of transition units satisfy the cocycle identities. -/
theorem isIso_pullbackHom (hc : IsCocycle U g) (hd : IsCocycle V h)
    (hcover : iSup V = ⊤) : IsIso (pullbackHom f U V g h τ hV htrans) := by
  apply ModulePullbackFrames.isIso_of_isIso_restrict_cover
    (pullbackHom f U V g h τ hV htrans) V
  · intro x
    have hx : x ∈ iSup V := by rw [hcover]; trivial
    exact Opens.mem_iSup.mp hx
  · intro i
    let N := gluedModule U g
    let eS := ModulePullbackFrames.pullbackFrameIso f (U (τ i)) (V i) (hV i)
      N (trivialization hc (τ i))
    let eT := trivialization hd i
    let r := (restrictFunctor (V i).ι).map (pullbackHom f U V g h τ hV htrans)
    let s : sectionSubmodule U g (U (τ i)) := (sectionTriv hc (τ i) le_rfl).symm 1
    have hs : sectionTriv hc (τ i) le_rfl s = 1 := LinearEquiv.apply_symm_apply _ _
    let eOpen : (V i).ι ''ᵁ (⊤ : (V i).toScheme.Opens) ≤ f ⁻¹ᵁ U (τ i) := by
      simpa using hV i
    let z := ModulePullbackFrames.baseMap f N eOpen s
    let oneP : Γ(SheafOfModules.unit (V i).toScheme.ringCatSheaf, ⊤) :=
      (1 : Γ((V i).toScheme, ⊤))
    have hPiece : ((trivialization hc (τ i)).hom.app ⊤).hom
        ((N.presheaf.map (eqToHom (Scheme.Opens.ι_image_top (U (τ i)))).op).hom s) =
        (1 : Γ((U (τ i)).toScheme, ⊤)) := by
      change ((restrictUnitIso (U (τ i)).ι).hom.app ⊤).hom
        (sectionTriv hc (τ i) ((U (τ i)).ι_image_le ⊤)
          ((N.presheaf.map (eqToHom (Scheme.Opens.ι_image_top (U (τ i)))).op).hom s)) = _
      have hm : eqToHom (Scheme.Opens.ι_image_top (U (τ i))) =
          homOfLE ((U (τ i)).ι_image_le (⊤ : (U (τ i)).toScheme.Opens)) :=
        Subsingleton.elim _ _
      rw [hm]
      change ((restrictUnitIso (U (τ i)).ι).hom.app ⊤).hom
        (sectionTriv hc (τ i) ((U (τ i)).ι_image_le ⊤)
          (res U g ((U (τ i)).ι_image_le ⊤) s)) = _
      rw [sectionTriv_res hc (τ i) ((U (τ i)).ι_image_le ⊤) le_rfl s, hs, map_one]
      exact restrictUnitIso_hom_app_top_one (U (τ i)).ι
    have hSource : (eS.hom.app ⊤).hom z = oneP :=
      ModulePullbackFrames.pullbackFrameIso_baseMap_one f (U (τ i)) (V i) (hV i)
        N (trivialization hc (τ i)) s hPiece
    have hInv : (eS.inv.app ⊤).hom oneP = z := by
      have h := congrArg (fun x => (eS.inv.app ⊤).hom x) hSource
      simpa only [← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app,
        eS.hom_inv_id, Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id,
        AddMonoidHom.id_apply] using h.symm
    let t := res V h eOpen (pullbackSections f U V g h τ hV htrans (U (τ i)) s)
    have hCompare : (r.app ⊤).hom z = t :=
      pullbackHom_baseMap f U V g h τ hV htrans eOpen s
    have hTarget : (eT.hom.app ⊤).hom t = oneP := by
      change ((restrictUnitIso (V i).ι).hom.app ⊤).hom
        (sectionTriv hd i ((V i).ι_image_le ⊤)
          (res V h eOpen (pullbackSections f U V g h τ hV htrans (U (τ i)) s))) = _
      rw [sectionTriv_pullbackSections f U V g h τ hV htrans hc hd i le_rfl
        ((V i).ι_image_le ⊤) eOpen s, hs, map_one]
      exact restrictUnitIso_hom_app_top_one (V i).ι
    have hconj : eS.inv ≫ r ≫ eT.hom = 𝟙 _ := by
      apply ModulePullbackFrames.unit_hom_ext_top
      change (eT.hom.app ⊤).hom ((r.app ⊤).hom ((eS.inv.app ⊤).hom oneP)) = oneP
      rw [hInv, hCompare, hTarget]
    haveI : IsIso (eS.inv ≫ r ≫ eT.hom) := by
      rw [hconj]
      infer_instance
    haveI : IsIso (eS.inv ≫ r) := IsIso.of_isIso_comp_right (eS.inv ≫ r) eT.hom
    exact IsIso.of_isIso_comp_left eS.inv r

/-- Pullback of the glued module agrees with gluing the pulled-back transition
units on a covering refinement. -/
def pullbackIso (hc : IsCocycle U g) (hd : IsCocycle V h) (hcover : iSup V = ⊤) :
    (Scheme.Modules.pullback f).obj (gluedModule U g) ≅ gluedModule V h := by
  letI := isIso_pullbackHom f U V g h τ hV htrans hc hd hcover
  exact asIso (pullbackHom f U V g h τ hV htrans)

end
end Hartshorne.LineBundleGluing
