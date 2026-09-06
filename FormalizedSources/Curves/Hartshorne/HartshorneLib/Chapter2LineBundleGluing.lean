/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/
import HartshorneLib.Chapter2AffineCech
import HartshorneLib.Chapter2LineBundleAPI

/-!
# Gluing line bundles by transition units

Compatible families are glued componentwise in the structure sheaf. The section
construction and its gluing proof adapt `AlgebraicJacobian/Cohomology/GluedSheaf.lean`
(Copyright (c) 2026 The AlgebraicJacobian authors), with the scalar action upgraded
to the structure sheaf so the result is a scheme module.
-/

set_option autoImplicit false

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.LineBundleGluing

universe u v

variable {X : Scheme.{max u v}} {J : Type v} (U : J → X.Opens)

lemma inclSnd (W : X.Opens) (i j : J) : W ⊓ U i ⊓ U j ≤ W ⊓ U j :=
  le_inf (inf_le_left.trans inf_le_left) inf_le_right

lemma inclCoc (W : X.Opens) (i j : J) : W ⊓ U i ⊓ U j ≤ U i ⊓ U j :=
  le_inf (inf_le_left.trans inf_le_right) inf_le_right

/-- Normalized transition functions, in the convention `s_i = g_ij * s_j`. -/
structure IsCocycle (g : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ) : Prop where
  unit_self : ∀ i, (g i i : Γ(X, U i ⊓ U i)) = 1
  mul_res : ∀ i j l,
    X.resHom (inf_le_left : U i ⊓ U j ⊓ U l ≤ U i ⊓ U j)
        (g i j : Γ(X, U i ⊓ U j)) *
      X.resHom (inclCoc U (U i) j l) (g j l : Γ(X, U j ⊓ U l)) =
    X.resHom (inclSnd U (U i) j l) (g i l : Γ(X, U i ⊓ U l))

variable (g : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ)

lemma IsCocycle.mul_res_of_le (hc : IsCocycle U g) {i j l : J} {W : X.Opens}
    (hW : W ≤ U i ⊓ U j ⊓ U l) :
    X.resHom (hW.trans inf_le_left) (g i j : Γ(X, U i ⊓ U j)) *
      X.resHom (hW.trans (inclCoc U (U i) j l)) (g j l : Γ(X, U j ⊓ U l)) =
    X.resHom (hW.trans (inclSnd U (U i) j l)) (g i l : Γ(X, U i ⊓ U l)) := by
  have h := congrArg (X.resHom hW) (hc.mul_res i j l)
  simpa only [map_mul, Scheme.resHom_resHom] using h

noncomputable abbrev componentModule (W : X.Opens) (i : J) :
    Module Γ(X, W) Γ(X, W ⊓ U i) :=
  Module.compHom _ (X.resHom (inf_le_left : W ⊓ U i ≤ W))

attribute [local instance] componentModule

/-- Sections on an open are matching families, with componentwise scalar action. -/
noncomputable def sectionSubmodule (W : X.Opens) :
    Submodule Γ(X, W) (∀ i : J, Γ(X, W ⊓ U i)) where
  carrier := {s | ∀ i j,
    X.resHom (inf_le_left : W ⊓ U i ⊓ U j ≤ W ⊓ U i) (s i) =
      X.resHom (inclCoc U W i j) (g i j : Γ(X, U i ⊓ U j)) *
        X.resHom (inclSnd U W i j) (s j)}
  add_mem' {s t} hs ht i j := by
    change X.resHom _ (s i + t i) = _ * X.resHom _ (s j + t j)
    rw [map_add, map_add, mul_add, hs i j, ht i j]
  zero_mem' i j := by simp
  smul_mem' r s hs i j := by
    change X.resHom _ (X.resHom inf_le_left r * s i) =
      _ * X.resHom _ (X.resHom inf_le_left r * s j)
    simp only [map_mul, Scheme.resHom_resHom]
    rw [hs i j, mul_left_comm]

lemma section_res {W' W : X.Opens} (h : W' ≤ W)
    {s : ∀ i : J, Γ(X, W ⊓ U i)} (hs : s ∈ sectionSubmodule U g W) :
    (fun i => X.resHom (inf_le_inf_right (U i) h) (s i)) ∈
      sectionSubmodule U g W' := by
  intro i j
  have key := congrArg
    (X.resHom (inf_le_inf_right (U j) (inf_le_inf_right (U i) h) :
      W' ⊓ U i ⊓ U j ≤ W ⊓ U i ⊓ U j)) (hs i j)
  simpa only [map_mul, Scheme.resHom_resHom] using key

/-- Restriction is componentwise restriction of the structure sheaf. -/
noncomputable def res {W' W : X.Opens} (h : W' ≤ W) :
    sectionSubmodule U g W →+ sectionSubmodule U g W' where
  toFun s := ⟨fun i => X.resHom (inf_le_inf_right (U i) h) (s.val i),
    section_res U g h s.property⟩
  map_zero' := by ext i; exact map_zero _
  map_add' s t := by ext i; exact map_add _ _ _

@[simp]
lemma res_apply {W' W : X.Opens} (h : W' ≤ W)
    (s : sectionSubmodule U g W) (i : J) :
    (res U g h s).val i = X.resHom (inf_le_inf_right (U i) h) (s.val i) := rfl

noncomputable def presheaf : X.Opensᵒᵖ ⥤ AddCommGrpCat.{max u v} where
  obj W := AddCommGrpCat.of (sectionSubmodule U g W.unop)
  map f := AddCommGrpCat.ofHom (res U g f.unop.le)
  map_id W := by
    apply AddCommGrpCat.hom_ext
    ext s i
    exact Scheme.resHom_self _ _
  map_comp f h := by
    apply AddCommGrpCat.hom_ext
    ext s i
    exact (Scheme.resHom_resHom _ _ _).symm

/-- Compatible families glue in the structure sheaf, component by component. -/
theorem isSheaf_presheaf :
    Presheaf.IsSheaf (Opens.grothendieckTopology (X : TopCat)) (presheaf U g) := by
  have h : TopCat.Presheaf.IsSheaf (C := AddCommGrpCat.{max u v})
      (X := (X : TopCat)) (presheaf U g) := by
    rw [TopCat.Presheaf.isSheaf_iff_isSheafUniqueGluing]
    intro ι W sf hsf
    have hres : ∀ a b : ι,
        res U g (inf_le_left : W a ⊓ W b ≤ W a) (sf a) =
          res U g (inf_le_right : W a ⊓ W b ≤ W b) (sf b) := fun a b => hsf a b
    have hcov : ∀ j : J, (iSup W) ⊓ U j ≤ ⨆ a, W a ⊓ U j := fun j => by
      rw [iSup_inf_eq]
    have hcompat : ∀ j : J, TopCat.Presheaf.IsCompatible X.presheaf
        (fun a => W a ⊓ U j) (fun a => (sf a).val j) := by
      intro j a b
      have key := congrArg (fun q : sectionSubmodule U g (W a ⊓ W b) =>
        X.resHom (le_inf
          (le_inf (inf_le_left.trans inf_le_left) (inf_le_right.trans inf_le_left))
          (inf_le_left.trans inf_le_right) :
            (W a ⊓ U j) ⊓ (W b ⊓ U j) ≤ (W a ⊓ W b) ⊓ U j) (q.val j)) (hres a b)
      simp only [res_apply, Scheme.resHom_resHom] at key
      exact key
    have H : ∀ j : J, ∃! tj : Γ(X, (iSup W) ⊓ U j),
        ∀ a : ι, X.resHom (inf_le_inf_right (U j) (le_iSup W a)) tj = (sf a).val j := by
      intro j
      obtain ⟨tj, htj, htju⟩ := TopCat.Sheaf.existsUnique_gluing'
        (X := (X : TopCat)) (C := CommRingCat.{max u v}) X.sheaf
        (fun a => W a ⊓ U j) ((iSup W) ⊓ U j)
        (fun a => homOfLE (inf_le_inf_right (U j) (le_iSup W a))) (hcov j)
        (fun a => (sf a).val j) (hcompat j)
      exact ⟨tj, fun a => htj a, fun y hy => htju y fun a => hy a⟩
    choose t ht htu using H
    have hrel : t ∈ sectionSubmodule U g (iSup W) := by
      intro i j
      have hcovΩ : (iSup W) ⊓ U i ⊓ U j ≤ ⨆ a, W a ⊓ U i ⊓ U j := by
        rw [iSup_inf_eq, iSup_inf_eq]
      apply TopCat.Sheaf.eq_of_locally_eq' (X := (X : TopCat))
        (C := CommRingCat.{max u v}) X.sheaf
        (fun a => W a ⊓ U i ⊓ U j) ((iSup W) ⊓ U i ⊓ U j)
        (fun a => homOfLE
          (inf_le_inf_right (U j) (inf_le_inf_right (U i) (le_iSup W a)))) hcovΩ
      intro a
      change X.resHom (inf_le_inf_right (U j) (inf_le_inf_right (U i) (le_iSup W a)))
          (X.resHom inf_le_left (t i)) =
        X.resHom (inf_le_inf_right (U j) (inf_le_inf_right (U i) (le_iSup W a)))
          (X.resHom (inclCoc U (iSup W) i j) (g i j : Γ(X, U i ⊓ U j)) *
            X.resHom (inclSnd U (iSup W) i j) (t j))
      have hloc := (sf a).property i j
      have hti := congrArg
        (X.resHom (inf_le_left : W a ⊓ U i ⊓ U j ≤ W a ⊓ U i)) (ht i a)
      have htj := congrArg (X.resHom (inclSnd U (W a) i j)) (ht j a)
      rw [map_mul]
      simp only [Scheme.resHom_resHom] at hti htj hloc ⊢
      rw [← hti, ← htj] at hloc
      exact hloc
    refine ⟨⟨t, hrel⟩, fun a => ?_, fun s hs => ?_⟩
    · exact Subtype.ext (funext fun j => ht j a)
    · have hs' : ∀ a, res U g (le_iSup W a) s = sf a := fun a => hs a
      refine Subtype.ext (funext fun j => ?_)
      refine htu j (s.val j) fun a => ?_
      rw [← hs' a, res_apply]
  exact h

/-- The presheaf of modules over the structure sheaf. -/
noncomputable def modulePresheaf : X.PresheafOfModules :=
  letI : ∀ W : X.Opensᵒᵖ,
      Module (X.ringCatSheaf.obj.obj W) ((presheaf U g).obj W) :=
    fun W => inferInstanceAs (Module Γ(X, W.unop) (sectionSubmodule U g W.unop))
  PresheafOfModules.ofPresheaf (R := X.ringCatSheaf.obj) (presheaf U g) (by
    intro V W f r s
    apply Subtype.ext
    funext i
    change X.resHom _ (X.resHom inf_le_left r * s.val i) =
      X.resHom inf_le_left (X.resHom f.unop.le r) * X.resHom _ (s.val i)
    simp only [map_mul, Scheme.resHom_resHom])

/-- The structure-sheaf module obtained from the transition functions. -/
noncomputable def gluedModule : X.Modules :=
  ⟨modulePresheaf U g, isSheaf_presheaf U g⟩

variable {U g} (hc : IsCocycle U g)

/-- Projection to the chosen component trivializes sections on a chart. -/
noncomputable def sectionTriv (j : J) {W : X.Opens} (hW : W ≤ U j) :
    sectionSubmodule U g W ≃ₗ[Γ(X, W)] Γ(X, W) where
  toFun s := X.resHom (le_inf le_rfl hW) (s.val j)
  map_add' s t := map_add _ _ _
  map_smul' r s := by
    change X.resHom _ (X.resHom inf_le_left r * s.val j) = r * _
    rw [map_mul, Scheme.resHom_resHom, Scheme.resHom_self]
  invFun t := ⟨fun i =>
    X.resHom (le_inf inf_le_right (inf_le_left.trans hW) : W ⊓ U i ≤ U i ⊓ U j)
        (g i j : Γ(X, U i ⊓ U j)) *
      X.resHom (inf_le_left : W ⊓ U i ≤ W) t, by
    intro i i'
    have hO : W ⊓ U i ⊓ U i' ≤ U i ⊓ U i' ⊓ U j :=
      le_inf (le_inf (inf_le_left.trans inf_le_right) inf_le_right)
        ((inf_le_left.trans inf_le_left).trans hW)
    have hcoc := hc.mul_res_of_le U g hO
    rw [map_mul, map_mul]
    simp only [Scheme.resHom_resHom]
    rw [← hcoc, mul_assoc]⟩
  left_inv s := by
    refine Subtype.ext (funext fun i => ?_)
    have hloc := s.property i j
    have key := congrArg
      (X.resHom (le_inf le_rfl (inf_le_left.trans hW) :
        W ⊓ U i ≤ W ⊓ U i ⊓ U j)) hloc
    rw [map_mul] at key
    simp only [Scheme.resHom_resHom] at key
    rw [Scheme.resHom_self] at key
    change X.resHom (le_inf inf_le_right (inf_le_left.trans hW))
        (g i j : Γ(X, U i ⊓ U j)) *
        X.resHom (inf_le_left : W ⊓ U i ≤ W)
          (X.resHom (le_inf le_rfl hW) (s.val j)) = s.val i
    rw [Scheme.resHom_resHom, ← key]
  right_inv t := by
    change X.resHom (le_inf le_rfl hW)
        (X.resHom (le_inf inf_le_right (inf_le_left.trans hW) : W ⊓ U j ≤ U j ⊓ U j)
            (g j j : Γ(X, U j ⊓ U j)) *
          X.resHom (inf_le_left : W ⊓ U j ≤ W) t) = t
    rw [map_mul, hc.unit_self j, map_one, map_one, one_mul, Scheme.resHom_resHom,
      Scheme.resHom_self]

lemma sectionTriv_res (j : J) {W' W : X.Opens} (h : W' ≤ W) (hW : W ≤ U j)
    (s : sectionSubmodule U g W) :
    sectionTriv hc j (h.trans hW) (res U g h s) =
      X.resHom h (sectionTriv hc j hW s) := by
  change X.resHom _ (X.resHom _ (s.val j)) = X.resHom _ (X.resHom _ (s.val j))
  simp only [Scheme.resHom_resHom]

/-- On an overlap, the trivializations recover the given transition unit. -/
lemma sectionTriv_eq_unit_mul (i j : J) {W : X.Opens} (hWi : W ≤ U i) (hWj : W ≤ U j)
    (s : sectionSubmodule U g W) :
    sectionTriv hc i hWi s =
      X.resHom (le_inf hWi hWj) (g i j : Γ(X, U i ⊓ U j)) *
        sectionTriv hc j hWj s := by
  have key := congrArg
    (X.resHom (le_inf (le_inf le_rfl hWi) hWj : W ≤ W ⊓ U i ⊓ U j))
    (s.property i j)
  change X.resHom _ (s.val i) = _ * X.resHom _ (s.val j)
  simpa only [map_mul, Scheme.resHom_resHom] using key

/-- The chartwise equivalence, with scalars transported through the open immersion. -/
noncomputable def restrictedSectionTriv (j : J) (W : (U j).toScheme.Opens) :
    (((Scheme.Modules.restrictFunctor (U j).ι).obj (gluedModule U g)).val.obj (op W)) ≃ₗ[
        (U j).toScheme.ringCatSheaf.obj.obj (op W)]
      (((Scheme.Modules.restrictFunctor (U j).ι).obj
        (SheafOfModules.unit X.ringCatSheaf)).val.obj (op W)) where
  toFun := sectionTriv hc j ((U j).ι_image_le W)
  invFun := (sectionTriv hc j ((U j).ι_image_le W)).symm
  left_inv := (sectionTriv hc j ((U j).ι_image_le W)).left_inv
  right_inv := (sectionTriv hc j ((U j).ι_image_le W)).right_inv
  map_add' := (sectionTriv hc j ((U j).ι_image_le W)).map_add
  map_smul' r s := by
    exact (sectionTriv hc j ((U j).ι_image_le W)).map_smul
      (((U j).ι.appIso W).inv r) s

/-- The compatible-family sheaf restricts to the structure sheaf on each chart. -/
noncomputable def trivialization (j : J) :
    (Scheme.Modules.restrictFunctor (U j).ι).obj (gluedModule U g) ≅
      SheafOfModules.unit (U j).toScheme.ringCatSheaf := by
  refine ?_ ≪≫ restrictUnitIso (U j).ι
  apply (SheafOfModules.fullyFaithfulForget _).preimageIso
  refine PresheafOfModules.isoMk
    (fun W => (restrictedSectionTriv hc j W.unop).toModuleIso) ?_
  intro V W f
  apply ModuleCat.hom_ext
  ext s
  exact sectionTriv_res hc j ((U j).ι.image_mono f.unop.le) ((U j).ι_image_le V.unop) s

include hc in
/-- Transition units on an open cover define a line bundle. -/
theorem isLineBundle (hcover : iSup U = ⊤) : IsLineBundle (gluedModule U g) := by
  intro x
  have hx : x ∈ iSup U := by rw [hcover]; trivial
  obtain ⟨j, hj⟩ := Opens.mem_iSup.mp hx
  exact ⟨U j, hj, ⟨trivialization hc j⟩⟩

end Hartshorne.LineBundleGluing
