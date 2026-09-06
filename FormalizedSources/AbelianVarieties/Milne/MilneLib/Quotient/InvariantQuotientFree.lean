/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientEtale
import MilneLib.Quotient.InvariantQuotientFiniteAtlasCanonical
import MilneLib.Quotient.InvariantQuotientStableOverlap

/-!
# Étaleness of the finite glued quotient under geometric freeness

Field-valued freeness of the scheme action is transported through each stable
affine chart to the section-ring criterion used by the affine quotient.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]

section FiniteCover

variable (p : X ⟶ Spec (CommRingCat.of k))
variable (hact : ∀ g : G, (act g).hom ≫ p = p)
variable (h : OrbitsInAffineOpen act)

omit [Finite G] [X.IsSeparated] [CompactSpace X] in
lemma chart_field_points_of_scheme_free
    {U : X.Opens} (hU : IsStableOpen act U) (hUa : IsAffineOpen U)
    (hfree : ∀ (K : Type u) [Field K]
      (x : Spec (CommRingCat.of K) ⟶ X) (g : G),
      x ≫ (act g).hom = x → g = 1)
    (g : G) (hg : g ≠ 1) :
    letI := sectionsMulSemiringAction act hU
    ∀ (K : Type u) [Field K] (x : Γ(X, U) →+* K),
      ∃ a : Γ(X, U), x (g • a) ≠ x a := by
  dsimp
  letI := sectionsMulSemiringAction act hU
  intro K _ x
  by_contra hsep
  push Not at hsep
  have hx : x.comp (MulSemiringAction.toRingHom G Γ(X, U) g) = x := by
    refine RingHom.ext fun a => ?_
    exact hsep a
  have hspec :
      Spec.map (CommRingCat.ofHom x) ≫
          (specAction G Γ(X, U) g⁻¹).hom =
        Spec.map (CommRingCat.ofHom x) := by
    rw [specAction_hom, inv_inv, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [hx]
  let y : Spec (CommRingCat.of K) ⟶ X :=
    Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫ U.ι
  have hy : y ≫ (act g⁻¹).hom = y := by
    change (Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫ U.ι) ≫
      (act g⁻¹).hom = Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫ U.ι
    calc
      (Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫ U.ι) ≫
          (act g⁻¹).hom =
        Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫
          (U.ι ≫ (act g⁻¹).hom) := by
            simp only [Category.assoc]
      _ = Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫
          (actRes act hU g⁻¹ ≫ U.ι) := by
            rw [← actRes_ι]
      _ = Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫
          actRes act hU g⁻¹ ≫ U.ι := by
            rfl
      _ =
        (Spec.map (CommRingCat.ofHom x) ≫
          (hUa.isoSpec.inv ≫ actRes act hU g⁻¹)) ≫ U.ι := by
            simp only [Category.assoc]
      _ = (Spec.map (CommRingCat.ofHom x) ≫
          ((specAction G Γ(X, U) g⁻¹).hom ≫ hUa.isoSpec.inv)) ≫ U.ι := by
            rw [specAction_hom_isoSpec_inv act hU hUa g⁻¹]
      _ = (Spec.map (CommRingCat.ofHom x) ≫
          (specAction G Γ(X, U) g⁻¹).hom) ≫ hUa.isoSpec.inv ≫ U.ι := by
            simp only [Category.assoc]
      _ = Spec.map (CommRingCat.ofHom x) ≫ hUa.isoSpec.inv ≫ U.ι := by
            rw [hspec]
  have hginv : g⁻¹ = 1 := hfree K y g⁻¹ hy
  apply hg
  exact inv_eq_one.mp hginv

theorem finiteStableCanonicalQuotientProjection_etale_of_field_points
    (hfree : ∀ (K : Type u) [Field K]
      (x : Spec (CommRingCat.of K) ⟶ X) (g : G),
      x ≫ (act g).hom = x → g = 1) :
    Etale (finiteStableCanonicalQuotientProjection act p hact h) := by
  apply finiteStableCanonicalQuotientProjection_etale_of_chart_maps act p hact h
  intro i
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  have hchart := affineInvariantQuotientMap_etale_of_field_points
    (k := k) (A := Γ(X, C.U)) (G := G)
    (chart_field_points_of_scheme_free act C.stable C.affine hfree)
  have hstable : Etale (stableAffineQuotientMap act p hact C) := by
    dsimp [stableAffineQuotientMap]
    apply MorphismProperty.comp_mem @Etale
    · infer_instance
    · exact hchart
  dsimp [finiteStableQuotientChartMap]
  letI : IsOpenImmersion
      ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) :=
    (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι_isOpenImmersion i
  have hι : Etale
      ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) := by
    infer_instance
  exact MorphismProperty.comp_mem @Etale _ _ hstable hι

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
