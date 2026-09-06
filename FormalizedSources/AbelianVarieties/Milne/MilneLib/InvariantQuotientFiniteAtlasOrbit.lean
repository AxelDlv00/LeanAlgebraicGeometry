/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasCanonical

/-!
# Orbit fibres of the finite quotient atlas

The affine invariant quotient identifies exactly the points in one finite-group
orbit.  This module transports that statement through a stable affine chart and
then through the canonical glued quotient atlas.  In particular, the global
projection is invariant under the original action.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated]

omit [Finite G] in
/-- The quotient map of a stable affine chart is invariant under the restricted
geometric action. -/
@[reassoc]
theorem actRes_comp_stableAffineQuotientMap
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) (g : G) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    actRes act i.stable g ≫ stableAffineQuotientMap act p hact i =
      stableAffineQuotientMap act p hact i := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  calc
    actRes act i.stable g ≫ stableAffineQuotientMap act p hact i =
        (actRes act i.stable g ≫ i.affine.isoSpec.hom) ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
      rfl
    _ = (i.affine.isoSpec.hom ≫ (specAction G Γ(X, i.U) g).hom) ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
      rw [actRes_isoSpec_hom_specAction]
    _ = i.affine.isoSpec.hom ≫
        ((specAction G Γ(X, i.U) g).hom ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G)) :=
      Category.assoc _ _ _
    _ = i.affine.isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U)) (G := G) := by
      rw [specAction_hom_affineInvariantQuotientMap]
    _ = stableAffineQuotientMap act p hact i := by
      rfl

/-- Two points of a stable affine chart have the same quotient image exactly
when they lie in the same orbit of the restricted action. -/
theorem stableAffineQuotientMap_eq_iff_exists_actRes
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) (x y : i.U.toScheme) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (stableAffineQuotientMap act p hact i).base x =
        (stableAffineQuotientMap act p hact i).base y ↔
      ∃ g : G, (actRes act i.stable g).base x = y := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  change
    (affineInvariantQuotientMap
        (k := k) (A := Γ(X, i.U)) (G := G)).base
          (i.affine.isoSpec.hom.base x) =
      (affineInvariantQuotientMap
        (k := k) (A := Γ(X, i.U)) (G := G)).base
          (i.affine.isoSpec.hom.base y) ↔ _
  rw [affineInvariantQuotientMap_eq_iff_exists_specAction]
  constructor
  · rintro ⟨g, hg⟩
    refine ⟨g, i.affine.isoSpec.hom.homeomorph.injective ?_⟩
    have hcoord := congrArg (fun f => f x)
      (actRes_isoSpec_hom_specAction act i.stable i.affine g)
    rw [Scheme.Hom.comp_apply, Scheme.Hom.comp_apply] at hcoord
    exact hcoord.trans hg
  · rintro ⟨g, hg⟩
    refine ⟨g, ?_⟩
    have hcoord := congrArg (fun f => f x)
      (actRes_isoSpec_hom_specAction act i.stable i.affine g)
    rw [Scheme.Hom.comp_apply, Scheme.Hom.comp_apply] at hcoord
    exact hcoord.symm.trans (congrArg i.affine.isoSpec.hom.base hg)

section FiniteCover

variable [CompactSpace X]
variable (p : X ⟶ Spec (CommRingCat.of k))
variable (hact : ∀ g : G, (act g).hom ≫ p = p)
variable (h : OrbitsInAffineOpen act)

/-- The canonical map to the glued quotient atlas is invariant under the
original action on the source. -/
@[reassoc]
theorem act_hom_comp_finiteStableCanonicalQuotientProjection (g : G) :
    (act g).hom ≫ finiteStableCanonicalQuotientProjection act p hact h =
      finiteStableCanonicalQuotientProjection act p hact h := by
  apply Scheme.Cover.hom_ext (finiteStableAffineCover act h)
  intro i
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  have hf : (finiteStableAffineCover act h).f i = C.U.ι :=
    finiteStableAffineCover_f act h i
  have hq :
      C.U.ι ≫ finiteStableCanonicalQuotientProjection act p hact h =
        stableAffineQuotientMap act p hact C ≫
          (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
    rw [← hf]
    exact finiteStableCover_f_finiteStableCanonicalQuotientProjection
      act p hact h i
  change C.U.ι ≫
      ((act g).hom ≫ finiteStableCanonicalQuotientProjection act p hact h) =
    C.U.ι ≫ finiteStableCanonicalQuotientProjection act p hact h
  rw [← Category.assoc, ← actRes_ι act C.stable g, Category.assoc, hq,
    ← Category.assoc,
    actRes_comp_stableAffineQuotientMap act p hact C g, ← hq]

/-- Two points have the same image under the canonical quotient projection
exactly when they lie in the same orbit of the original action. -/
theorem finiteStableCanonicalQuotientProjection_eq_iff_exists_act
    (x y : X) :
    (finiteStableCanonicalQuotientProjection act p hact h).base x =
        (finiteStableCanonicalQuotientProjection act p hact h).base y ↔
      ∃ g : G, (act g).hom.base x = y := by
  constructor
  · intro hxy
    obtain ⟨i, xi, rfl⟩ := (finiteStableAffineCover act h).exists_eq x
    let C := finiteStableAffineChart act h i
    change C.U.toScheme at xi
    letI := sectionsAlgebra p C.U
    letI := sectionsMulSemiringAction act C.stable
    letI := sectionsSMulCommClass act p hact C.stable
    rw [finiteStableAffineCover_f] at hxy
    change
      (finiteStableCanonicalQuotientProjection act p hact h).base
          (C.U.ι.base xi) =
        (finiteStableCanonicalQuotientProjection act p hact h).base y at hxy
    have hq :
        C.U.ι ≫ finiteStableCanonicalQuotientProjection act p hact h =
          stableAffineQuotientMap act p hact C ≫
            (finiteStableQuotientGlueData act p hact h).ι i := by
      rw [← finiteStableAffineCover_f act h i]
      exact finiteStableCover_f_finiteStableCanonicalQuotientProjection
        act p hact h i
    have hxRange :
        (finiteStableCanonicalQuotientProjection act p hact h).base
            (C.U.ι.base xi) ∈
          ((finiteStableQuotientGlueData act p hact h).ι i).opensRange := by
      apply Scheme.Hom.mem_opensRange.mpr
      refine ⟨(stableAffineQuotientMap act p hact C).base xi, ?_⟩
      have hqi := congrArg (fun f => f.base xi) hq
      rw [Scheme.Hom.comp_apply, Scheme.Hom.comp_apply] at hqi
      exact hqi.symm
    have hyRange :
        (finiteStableCanonicalQuotientProjection act p hact h).base y ∈
          ((finiteStableQuotientGlueData act p hact h).ι i).opensRange := by
      rw [← hxy]
      exact hxRange
    have hy : y ∈ C.U := by
      rw [← finiteStableCanonicalQuotientProjection_preimage_opensRange
        act p hact h i]
      exact hyRange
    let yi : C.U.toScheme := ⟨y, hy⟩
    have hlocal :
        (stableAffineQuotientMap act p hact C).base xi =
          (stableAffineQuotientMap act p hact C).base yi := by
      apply ((finiteStableQuotientGlueData act p hact h).ι i).isOpenEmbedding.injective
      have hqxi := congrArg (fun f => f.base xi) hq
      have hqyi := congrArg (fun f => f.base yi) hq
      rw [Scheme.Hom.comp_apply, Scheme.Hom.comp_apply] at hqxi hqyi
      exact hqxi.symm.trans (hxy.trans hqyi)
    obtain ⟨g, hg⟩ :=
      (stableAffineQuotientMap_eq_iff_exists_actRes
        act p hact C xi yi).mp hlocal
    refine ⟨g, ?_⟩
    have hres := congrArg (fun f => f.base xi) (actRes_ι act C.stable g)
    rw [Scheme.Hom.comp_apply, Scheme.Hom.comp_apply] at hres
    exact hres.symm.trans (congrArg C.U.ι.base hg)
  · rintro ⟨g, rfl⟩
    have hq := congrArg (fun f => f.base x)
      (act_hom_comp_finiteStableCanonicalQuotientProjection
        act p hact h g)
    simpa only [Scheme.Hom.comp_apply] using hq.symm

/- The pointwise surjectivity theorem above is also exposed through the
scheme-morphism property API, so downstream finite/descent consumers can use
the canonical projection directly. -/
instance finiteStableCanonicalQuotientProjection_surjective_instance
    : Surjective (finiteStableCanonicalQuotientProjection act p hact h) :=
  ⟨finiteStableCanonicalQuotientProjection_surjective act p hact h⟩

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
