/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientFiniteAtlasOrbit
import MilneLib.Quotient.InvariantQuotientSections

/-!
# Invariant sections of the finite quotient atlas

The affine invariant-section calculation passes through the stable affine
coordinate maps and the canonical quotient charts.  Sheaf gluing then identifies
the image of pullback along the canonical global projection with the sections
fixed by the geometric action.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry TopologicalSpace

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated]

/-- Pullback along a stable affine chart quotient is injective on every open. -/
theorem stableAffineQuotientMap_app_injective
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : StableAffineOpen act) :
    letI := sectionsAlgebra p C.U
    letI := sectionsMulSemiringAction act C.stable
    letI := sectionsSMulCommClass act p hact C.stable
    ∀ U, Function.Injective ((stableAffineQuotientMap act p hact C).app U).hom := by
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  intro U s t hst
  apply InvariantLocalization.affineInvariantQuotientMap_app_injective U
  exact (ConcreteCategory.bijective_of_isIso
    (C.affine.isoSpec.hom.app _)).injective hst

section FiniteCover

variable [CompactSpace X]
variable (p : X ⟶ Spec (CommRingCat.of k))
variable (hact : ∀ g : G, (act g).hom ≫ p = p)
variable (h : OrbitsInAffineOpen act)

/-- Pullback along the glued quotient is injective on sections over every open. -/
theorem finiteStableCanonicalQuotientProjection_app_injective
    (U : (finiteStableQuotientGlueData act p hact h).glued.Opens) :
    Function.Injective
      ((finiteStableCanonicalQuotientProjection act p hact h).app U).hom := by
  let D := finiteStableQuotientGlueData act p hact h
  let q := finiteStableCanonicalQuotientProjection act p hact h
  intro s t hst
  apply D.openCover.ext_elem s t
  intro i
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  apply stableAffineQuotientMap_app_injective act p hact C
  have htransport {Z : Scheme.{u}} (f g : Z ⟶ D.glued) (hf : f = g) :
      (f.app U).hom s = (f.app U).hom t ↔
        (g.app U).hom s = (g.app U).hom t := by
    subst hf
    rfl
  have hr := congrArg (((finiteStableAffineCover act h).f i).app (q ⁻¹ᵁ U)).hom hst
  exact (htransport _ _
    (finiteStableCover_f_finiteStableCanonicalQuotientProjection act p hact h i)).mp hr

/-- The inverse image of every quotient open is stable under the source action. -/
theorem finiteStableCanonicalQuotientProjection_preimage_isStableOpen
    (U : (finiteStableQuotientGlueData act p hact h).glued.Opens) :
    IsStableOpen act
      (finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ U) :=
  isStableOpen_preimage_of_invariant act
    (finiteStableCanonicalQuotientProjection act p hact h)
    (act_hom_comp_finiteStableCanonicalQuotientProjection act p hact h) U

set_option backward.isDefEq.respectTransparency false in
/-- A fixed section descends over every open contained in one quotient chart. -/
theorem finiteStableCanonicalQuotientProjection_mem_range_app_of_le_chart
    (i : (finiteStableAffineCover act h).I₀)
    (U : (finiteStableQuotientGlueData act p hact h).glued.Opens)
    (hU : U ≤ ((finiteStableQuotientGlueData act p hact h).ι i).opensRange)
    (s : Γ(X, finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ U))
    (hs : ∀ g : G, (actApp act
      (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
        g).hom s = s) :
    s ∈ Set.range
      ((finiteStableCanonicalQuotientProjection act p hact h).app U).hom := by
  let D := finiteStableQuotientGlueData act p hact h
  let q := finiteStableCanonicalQuotientProjection act p hact h
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  let r := affineInvariantQuotientMap (k := k) (A := Γ(X, C.U)) (G := G)
  let c := C.affine.fromSpec
  let j := D.ι i
  have hq : c ≫ q = r ≫ j := by
    change (C.affine.isoSpec.inv ≫ C.U.ι) ≫ q = r ≫ j
    have hh := finiteStableCover_f_finiteStableCanonicalQuotientProjection
      act p hact h i
    rw [finiteStableAffineCover_f] at hh
    change C.U.ι ≫ q = (C.affine.isoSpec.hom ≫ r) ≫ j at hh
    rw [Category.assoc, hh]
    simp only [← Category.assoc, Iso.inv_hom_id, Category.id_comp]
  let W := r ⁻¹ᵁ (j ⁻¹ᵁ U)
  have hW : W = c ⁻¹ᵁ (q ⁻¹ᵁ U) := by
    change (r ≫ j) ⁻¹ᵁ U = (c ≫ q) ⁻¹ᵁ U
    rw [hq]
  let cf := c.appLE (q ⁻¹ᵁ U) W hW.le
  have hle : q ⁻¹ᵁ U ≤ c.opensRange := by
    rw [C.affine.opensRange_fromSpec]
    rw [← finiteStableCanonicalQuotientProjection_preimage_opensRange act p hact h i]
    exact (Opens.map q.base).monotone hU
  letI : IsIso cf := by
    haveI := c.isIso_app (q ⁻¹ᵁ U) hle
    change IsIso (c.app (q ⁻¹ᵁ U) ≫
      (Spec Γ(X, C.U)).presheaf.map (eqToHom hW).op)
    infer_instance
  letI : IsIso (j.app U) := j.isIso_app U hU
  have hsq : q.app U ≫ cf = j.app U ≫ r.app (j ⁻¹ᵁ U) := by
    change q.app U ≫ c.appLE (q ⁻¹ᵁ U) W hW.le = _
    rw [← Scheme.Hom.comp_appLE, appLE_congr_hom hq]
    change (r ≫ j).appLE U ((r ≫ j) ⁻¹ᵁ U) le_rfl = _
    rw [Scheme.Hom.appLE_eq_app, Scheme.Hom.comp_app]
  have hc (g : G) :
      (specAction G Γ(X, C.U) g).hom ≫ c = c ≫ (act g).hom := by
    dsimp [c]
    rw [← C.affine.isoSpec_inv_ι, ← Category.assoc,
      specAction_hom_isoSpec_inv act C.stable C.affine g,
      Category.assoc, actRes_ι, ← Category.assoc]
  have hs' : ∀ g : G,
      (actApp (specAction G Γ(X, C.U))
        (InvariantLocalization.affineInvariantQuotientMap_preimage_isStableOpen
          (j ⁻¹ᵁ U)) g).hom (cf.hom s) = cf.hom s := by
    intro g
    have hh := appLE_actApp_of_equivariant (specAction G Γ(X, C.U)) act c hc
      (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
      (InvariantLocalization.affineInvariantQuotientMap_preimage_isStableOpen
        (j ⁻¹ᵁ U)) hW.le g
    exact (congrArg (fun f => f.hom s) hh).trans (congrArg cf.hom (hs g))
  obtain ⟨t, ht⟩ :=
    (InvariantLocalization.affineInvariantQuotientMap_mem_range_app_iff_actApp
      (j ⁻¹ᵁ U) (cf.hom s)).mpr hs'
  obtain ⟨a, ha⟩ := (ConcreteCategory.bijective_of_isIso (j.app U)).surjective t
  refine ⟨a, (ConcreteCategory.bijective_of_isIso cf).injective ?_⟩
  exact (congrArg (fun f => f.hom a) hsq).trans
    ((congrArg (r.app (j ⁻¹ᵁ U)).hom ha).trans ht)

/-- Over every quotient open, pullback has precisely the fixed sections as its
image.  The reverse implication glues the unique lifts on quotient charts. -/
theorem finiteStableCanonicalQuotientProjection_mem_range_app_iff_actApp
    (U : (finiteStableQuotientGlueData act p hact h).glued.Opens)
    (s : Γ(X, finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ U)) :
    s ∈ Set.range
      ((finiteStableCanonicalQuotientProjection act p hact h).app U).hom ↔
      ∀ g : G, (actApp act
        (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
          g).hom s = s := by
  classical
  let D := finiteStableQuotientGlueData act p hact h
  let Y := D.glued
  let q := finiteStableCanonicalQuotientProjection act p hact h
  have hn (V W : Y.Opens) (hWV : W ≤ V) (t : Γ(Y, V)) :
      (q.app W).hom ((Y.presheaf.map (homOfLE hWV).op).hom t) =
        (X.presheaf.map ((Opens.map q.base).map (homOfLE hWV)).op).hom
          ((q.app V).hom t) :=
    congrArg (fun f => f.hom t) (q.naturality (homOfLE hWV).op)
  constructor
  · rintro ⟨t, rfl⟩ g
    exact congrArg (fun f => f.hom t)
      (app_actApp_of_invariant act q
        (act_hom_comp_finiteStableCanonicalQuotientProjection act p hact h) U g)
  · intro hs
    let V : D.J → Y.Opens := fun i => (D.ι i).opensRange ⊓ U
    have hcover : U ≤ ⨆ i, V i := by
      intro y hy
      obtain ⟨i, z, hz⟩ := D.ι_jointly_surjective y
      exact Opens.mem_iSup.mpr ⟨i, (Scheme.Hom.mem_opensRange.mpr ⟨z, hz⟩), hy⟩
    have hl : ∀ i : D.J, ∃ t : Γ(Y, V i), (q.app (V i)).hom t =
        (X.presheaf.map ((Opens.map q.base).map (homOfLE inf_le_right)).op).hom s := by
      intro i
      apply finiteStableCanonicalQuotientProjection_mem_range_app_of_le_chart
        act p hact h i (V i) inf_le_left
      intro g
      have hh := actApp_map act
        (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
        (finiteStableCanonicalQuotientProjection_preimage_isStableOpen
          act p hact h (V i))
        ((Opens.map q.base).monotone (show V i ≤ U from inf_le_right)) g
      exact (congrArg (fun f => f.hom s) hh).symm.trans
        (congrArg (X.presheaf.map
          ((Opens.map q.base).map (homOfLE inf_le_right)).op).hom (hs g))
    choose t ht using hl
    have hcpt : TopCat.Presheaf.IsCompatible Y.presheaf V t := by
      intro i j
      apply finiteStableCanonicalQuotientProjection_app_injective
        act p hact h (V i ⊓ V j)
      change (q.app (V i ⊓ V j)).hom
          ((Y.presheaf.map (homOfLE inf_le_left).op).hom (t i)) =
        (q.app (V i ⊓ V j)).hom
          ((Y.presheaf.map (homOfLE inf_le_right).op).hom (t j))
      rw [hn, hn, ht, ht]
      simp only [← CommRingCat.comp_apply, ← X.presheaf.map_comp]
      rfl
    obtain ⟨a, ha, _⟩ := Y.sheaf.existsUnique_gluing' V U
      (fun _ => homOfLE inf_le_right) hcover t hcpt
    refine ⟨a, ?_⟩
    apply TopCat.Presheaf.IsSheaf.section_ext X.sheaf.2
    intro x hx
    obtain ⟨i, hi⟩ := Opens.mem_iSup.mp (hcover hx)
    refine ⟨q ⁻¹ᵁ V i, (Opens.map q.base).monotone inf_le_right, hi, ?_⟩
    have hnat := hn U (V i) inf_le_right a
    exact hnat.symm.trans
      ((congrArg (q.app (V i)).hom (ha i)).trans (ht i))

/-- The image of pullback is the intrinsic fixed subring of sections on the
inverse image, with the canonical left action on sections. -/
theorem finiteStableCanonicalQuotientProjection_app_range
    (U : (finiteStableQuotientGlueData act p hact h).glued.Opens) :
    letI := sectionsMulSemiringAction act
      (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
    ((finiteStableCanonicalQuotientProjection act p hact h).app U).hom.range =
      FixedPoints.subring Γ(X,
        finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ U) G := by
  letI := sectionsMulSemiringAction act
    (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
  ext s
  change s ∈ Set.range
      ((finiteStableCanonicalQuotientProjection act p hact h).app U).hom ↔
    ∀ g : G, (actApp act
      (finiteStableCanonicalQuotientProjection_preimage_isStableOpen act p hact h U)
        g⁻¹).hom s = s
  rw [finiteStableCanonicalQuotientProjection_mem_range_app_iff_actApp]
  constructor
  · intro hs g
    exact hs g⁻¹
  · intro hs g
    simpa only [inv_inv] using hs g⁻¹

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
