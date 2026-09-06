/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.PicEtCoverBridge
import Mathlib.AlgebraicGeometry.Gluing

/-!
# Gluing degree-zero Picard classes on a scheme gluing

A family of degree-zero classes on the charts of a `Scheme.GlueData` glues
uniquely when its two restrictions agree on every explicit overlap. Mathlib's
overlap pullback property derives compatibility on arbitrary common tests,
allowing the morphism-cover sheaf theorem to apply to the literal glued scheme.
-/

set_option autoImplicit false

universe u

open CategoryTheory CategoryTheory.Limits

namespace AlgebraicGeometry.Scheme.GlueData

noncomputable section

variable (D : Scheme.GlueData.{u}) {k : Type u} [Field k]
  (pi : D.glued ⟶ Spec (.of k))

/-- A chart inclusion, regarded as a morphism over the field. -/
def ιOver (i : D.J) : Over.mk (D.ι i ≫ pi) ⟶ Over.mk pi :=
  Over.homMk (D.ι i) rfl

/-- The first overlap leg, regarded as a morphism over the field. -/
def fstOver (i j : D.J) :
    Over.mk (D.f i j ≫ D.ι i ≫ pi) ⟶ Over.mk (D.ι i ≫ pi) :=
  Over.homMk (D.f i j) rfl

/-- The second overlap leg, including the transition to the reversed overlap. -/
def sndOver (i j : D.J) :
    Over.mk (D.f i j ≫ D.ι i ≫ pi) ⟶ Over.mk (D.ι j ≫ pi) :=
  Over.homMk (D.t i j ≫ D.f j i) (by
    change (D.t i j ≫ D.f j i) ≫ (D.ι j ≫ pi) = D.f i j ≫ D.ι i ≫ pi
    simpa only [Category.assoc] using
      congrArg (fun f => f ≫ pi) (D.glue_condition i j))

variable (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Classes agreeing on the explicit overlaps agree on every common test of two
charts of the glued scheme. -/
theorem pic0Map_eq_of_overlap
    (x : ∀ i, pic0Subgroup C (Over.mk (D.ι i ≫ pi)))
    (hx : ∀ i j, pic0Map C (D.fstOver pi i j) (x i) =
      pic0Map C (D.sndOver pi i j) (x j))
    (i j : D.J) (Z : Over (Spec (.of k)))
    (gi : Z ⟶ Over.mk (D.ι i ≫ pi)) (gj : Z ⟶ Over.mk (D.ι j ≫ pi))
    (h : gi ≫ D.ιOver pi i = gj ≫ D.ιOver pi j) :
    pic0Map C gi (x i) = pic0Map C gj (x j) := by
  have hleft : gi.left ≫ D.ι i = gj.left ≫ D.ι j :=
    congrArg Over.Hom.left h
  let cone := PullbackCone.mk gi.left gj.left hleft
  let q : Z.left ⟶ D.V (i, j) := (D.vPullbackConeIsLimit i j).lift cone
  have hqi : q ≫ D.f i j = gi.left :=
    (D.vPullbackConeIsLimit i j).fac cone WalkingCospan.left
  have hqj : q ≫ (D.t i j ≫ D.f j i) = gj.left :=
    (D.vPullbackConeIsLimit i j).fac cone WalkingCospan.right
  let qOver : Z ⟶ Over.mk (D.f i j ≫ D.ι i ≫ pi) :=
    Over.homMk q (by
      change q ≫ (D.f i j ≫ D.ι i ≫ pi) = Z.hom
      rw [← Category.assoc, hqi]
      exact gi.w)
  have hqiOver : qOver ≫ D.fstOver pi i j = gi := by
    ext
    exact hqi
  have hqjOver : qOver ≫ D.sndOver pi i j = gj := by
    ext
    exact hqj
  apply Subtype.ext
  have hclasses := congrArg (fun z => (pic0Map C qOver z).val) (hx i j)
  change picEtMap C qOver (picEtMap C (D.fstOver pi i j) (x i).val) =
    picEtMap C qOver (picEtMap C (D.sndOver pi i j) (x j).val) at hclasses
  rw [← picEtMap_comp, ← picEtMap_comp, hqiOver, hqjOver] at hclasses
  exact hclasses

/-- A compatible family of degree-zero chart classes glues to a unique class on
the literal glued scheme, with the prescribed structure map to the ground field. -/
theorem pic0Subgroup_existsUnique
    (x : ∀ i, pic0Subgroup C (Over.mk (D.ι i ≫ pi)))
    (hx : ∀ i j, pic0Map C (D.fstOver pi i j) (x i) =
      pic0Map C (D.sndOver pi i j) (x j)) :
    ∃! s : pic0Subgroup C (Over.mk pi), ∀ i, pic0Map C (D.ιOver pi i) s = x i := by
  letI (i : D.J) : IsOpenImmersion (D.ιOver pi i).left :=
    inferInstanceAs (IsOpenImmersion (D.ι i))
  apply pic0Subgroup_existsUnique_of_cover (D.ιOver pi)
    (fun p => ?_) x (D.pic0Map_eq_of_overlap pi C x hx)
  obtain ⟨i, y, hy⟩ := D.ι_jointly_surjective p
  exact ⟨i, y, hy⟩

/-- Compatible classes on charts with prescribed structure maps glue uniquely.
Keeping those maps explicit lets affine presentations use their canonical
algebra structures without transporting every class along a chart equality. -/
theorem pic0Subgroup_existsUnique_of_chartMaps
    (σ : ∀ i, D.U i ⟶ Spec (.of k))
    (ρ : ∀ i j, D.V (i, j) ⟶ Spec (.of k))
    (incl : ∀ i, Over.mk (σ i) ⟶ Over.mk pi)
    (hι : ∀ i, (incl i).left = D.ι i)
    (fL : ∀ i j, Over.mk (ρ i j) ⟶ Over.mk (σ i))
    (hL : ∀ i j, (fL i j).left = D.f i j)
    (fR : ∀ i j, Over.mk (ρ i j) ⟶ Over.mk (σ j))
    (hR : ∀ i j, (fR i j).left = D.t i j ≫ D.f j i)
    (x : ∀ i, pic0Subgroup C (Over.mk (σ i)))
    (hx : ∀ i j, pic0Map C (fL i j) (x i) = pic0Map C (fR i j) (x j)) :
    ∃! s : pic0Subgroup C (Over.mk pi), ∀ i, pic0Map C (incl i) s = x i := by
  letI (i : D.J) : IsOpenImmersion (incl i).left := by
    have hi : IsOpenImmersion (D.ι i) := inferInstance
    exact (hι i).symm ▸ hi
  refine pic0Subgroup_existsUnique_of_cover incl (fun p => ?_) x ?_
  · obtain ⟨i, y, hy⟩ := D.ι_jointly_surjective p
    change ∃ i, p ∈ Set.range (incl i).left.base
    simp only [hι]
    exact ⟨i, y, hy⟩
  intro i j Z gi gj h
  have hleft : gi.left ≫ (incl i).left = gj.left ≫ (incl j).left :=
    congrArg Over.Hom.left h
  rw [hι, hι] at hleft
  let cone := PullbackCone.mk gi.left gj.left hleft
  let q : Z.left ⟶ D.V (i, j) := (D.vPullbackConeIsLimit i j).lift cone
  have hqi : q ≫ D.f i j = gi.left :=
    (D.vPullbackConeIsLimit i j).fac cone WalkingCospan.left
  have hqj : q ≫ (D.t i j ≫ D.f j i) = gj.left :=
    (D.vPullbackConeIsLimit i j).fac cone WalkingCospan.right
  let qOver : Z ⟶ Over.mk (ρ i j) := Over.homMk q (by
    change q ≫ ρ i j = Z.hom
    have hwL : (fL i j).left ≫ σ i = ρ i j := (fL i j).w
    exact (congrArg (fun a => q ≫ a) hwL.symm).trans
      ((Category.assoc q (fL i j).left (σ i)).symm.trans
        ((congrArg (fun a => a ≫ σ i)
          ((congrArg (fun a => q ≫ a) (hL i j)).trans hqi)).trans gi.w)))
  have hqiOver : qOver ≫ fL i j = gi := by
    ext
    change q ≫ (fL i j).left = gi.left
    rw [hL]
    exact hqi
  have hqjOver : qOver ≫ fR i j = gj := by
    ext
    change q ≫ (fR i j).left = gj.left
    rw [hR]
    exact hqj
  apply Subtype.ext
  have hclasses := congrArg (fun z => (pic0Map C qOver z).val) (hx i j)
  change picEtMap C qOver (picEtMap C (fL i j) (x i).val) =
    picEtMap C qOver (picEtMap C (fR i j) (x j).val) at hclasses
  rw [← picEtMap_comp, ← picEtMap_comp, hqiOver, hqjOver] at hclasses
  exact hclasses

end

end AlgebraicGeometry.Scheme.GlueData
