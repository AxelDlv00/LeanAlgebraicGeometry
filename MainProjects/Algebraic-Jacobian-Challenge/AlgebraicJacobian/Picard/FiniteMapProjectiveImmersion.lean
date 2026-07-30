/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiniteMapProjectiveGluing
import AlgebraicJacobian.Picard.ProjectiveCoordinateRelativeChart

/-!
# The projective immersion attached to a finite two-chart map

The two distinguished homogeneous coordinates cut out target charts whose
inverse images are exactly the two pulled-back Laurent charts.  On each chart,
the global relative coordinate morphism is the closed immersion supplied by
the algebra-generating coordinate family.  Target-locality then makes the
global morphism an immersion.
-/

set_option autoImplicit false

noncomputable section

universe u

open CategoryTheory Limits MvPolynomial HomogeneousLocalization
  TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Adelic
namespace LaurentChartData.FiniteMapGenerators

variable {k : Type u} [Field k]
variable {Y C : Over (Spec (CommRingCat.of k))}
variable {D : LaurentChartData Y} {pi : C ⟶ Y}
variable (G : D.FiniteMapGenerators pi)

/-- The coordinate normalized to one on the first source chart. -/
abbrev firstIndex : G.ProjectiveIndex :=
  Sum.inl ⟨0, Nat.zero_lt_succ G.d⟩

/-- The coordinate normalized to one on the second source chart. -/
abbrev secondIndex : G.ProjectiveIndex :=
  Sum.inl ⟨G.d, Nat.lt_succ_self G.d⟩

/-- The target chart selected by the first distinguished coordinate. -/
def targetOpen0 : (ℙ(G.ProjectiveIndex; Spec (.of k))).Opens :=
  ProjectiveSpace.toProjInt G.ProjectiveIndex (Spec (.of k)) ⁻¹ᵁ
    Proj.basicOpen
      (homogeneousSubmodule G.ProjectiveIndex (ULift.{u} ℤ)) (X G.firstIndex)

/-- The target chart selected by the second distinguished coordinate. -/
def targetOpen1 : (ℙ(G.ProjectiveIndex; Spec (.of k))).Opens :=
  ProjectiveSpace.toProjInt G.ProjectiveIndex (Spec (.of k)) ⁻¹ᵁ
    Proj.basicOpen
      (homogeneousSubmodule G.ProjectiveIndex (ULift.{u} ℤ)) (X G.secondIndex)

/-- The first target open is the corresponding relative affine chart. -/
def targetOpen0IsoAffineChartAt :
    G.targetOpen0.toScheme ≅
      ProjectiveSpace.affineChartAt G.ProjectiveIndex G.firstIndex (Spec (.of k)) := by
  apply IsOpenImmersion.isoOfRangeEq G.targetOpen0.ι
    (ProjectiveSpace.affineChartAt.incl
      G.ProjectiveIndex G.firstIndex (Spec (.of k)))
  rw [Scheme.Opens.range_ι, ← Scheme.Hom.coe_opensRange,
    ProjectiveSpace.affineChartAt.opensRange_incl, targetOpen0]

/-- The second target open is the corresponding relative affine chart. -/
def targetOpen1IsoAffineChartAt :
    G.targetOpen1.toScheme ≅
      ProjectiveSpace.affineChartAt G.ProjectiveIndex G.secondIndex (Spec (.of k)) := by
  apply IsOpenImmersion.isoOfRangeEq G.targetOpen1.ι
    (ProjectiveSpace.affineChartAt.incl
      G.ProjectiveIndex G.secondIndex (Spec (.of k)))
  rw [Scheme.Opens.range_ι, ← Scheme.Hom.coe_opensRange,
    ProjectiveSpace.affineChartAt.opensRange_incl, targetOpen1]

@[reassoc]
theorem targetOpen0IsoAffineChartAt_hom_incl :
    G.targetOpen0IsoAffineChartAt.hom ≫
        ProjectiveSpace.affineChartAt.incl
          G.ProjectiveIndex G.firstIndex (Spec (.of k)) =
      G.targetOpen0.ι :=
  IsOpenImmersion.isoOfRangeEq_hom_fac _ _ _

@[reassoc]
theorem targetOpen1IsoAffineChartAt_hom_incl :
    G.targetOpen1IsoAffineChartAt.hom ≫
        ProjectiveSpace.affineChartAt.incl
          G.ProjectiveIndex G.secondIndex (Spec (.of k)) =
      G.targetOpen1.ι :=
  IsOpenImmersion.isoOfRangeEq_hom_fac _ _ _

/-- Removing the normalized coordinate does not change algebra generation on
the first chart. -/
theorem adjoin_projectiveCoordinates0_ne :
    Algebra.adjoin k
      (Set.range fun j : {j : G.ProjectiveIndex // j ≠ G.firstIndex} ↦
        G.projectiveCoordinates0 j.1) = ⊤ := by
  have hfull := G.adjoin_chart0 D pi
  apply top_unique
  rw [← hfull]
  apply Algebra.adjoin_le
  rintro z ⟨j, rfl⟩
  by_cases hj : j = G.firstIndex
  · subst j
    change G.projectiveCoordinates0 G.firstIndex ∈ _
    rw [G.projectiveCoordinates0_zero]
    exact Subalgebra.one_mem _
  · exact Algebra.subset_adjoin ⟨⟨j, hj⟩, rfl⟩

/-- Removing the normalized coordinate does not change algebra generation on
the second chart. -/
theorem adjoin_projectiveCoordinates1_ne :
    Algebra.adjoin k
      (Set.range fun j : {j : G.ProjectiveIndex // j ≠ G.secondIndex} ↦
        G.projectiveCoordinates1 j.1) = ⊤ := by
  have hfull := G.adjoin_chart1 D pi
  apply top_unique
  rw [← hfull]
  apply Algebra.adjoin_le
  rintro z ⟨j, rfl⟩
  by_cases hj : j = G.secondIndex
  · subst j
    change G.projectiveCoordinates1 G.secondIndex ∈ _
    rw [G.projectiveCoordinates1_last]
    exact Subalgebra.one_mem _
  · exact Algebra.subset_adjoin ⟨⟨j, hj⟩, rfl⟩

/-- The section ring of an open and the global sections of its open subscheme
are canonically isomorphic. -/
def openSectionsEquiv (U : C.left.Opens) :
    Γ(C.left, U) ≃+* Γ(U.toScheme, ⊤) :=
  (asIso (U.ι.appLE U ⊤ U.ι_preimage_self.ge)).commRingCatIsoToRingEquiv

/-- The section-ring equivalence respects the structural `k`-algebra map. -/
theorem openSectionsEquiv_algebraMap (U : C.left.Opens) (c : k) :
    openSectionsEquiv U (algebraMap k Γ(C.left, U) c) =
      (U.ι ≫ C.hom).appTop.hom
        ((Scheme.ΓSpecIso (.of k)).inv.hom c) := by
  change (U.ι.appLE U ⊤ U.ι_preimage_self.ge).hom
      (algebraMap k Γ(C.left, U) c) = _
  have hL : algebraMap k Γ(C.left, U) c =
      (C.left.presheaf.map (homOfLE (le_top : U ≤ ⊤)).op).hom
        (C.hom.appTop.hom ((Scheme.ΓSpecIso (.of k)).inv.hom c)) := rfl
  rw [hL]
  change (C.left.presheaf.map (homOfLE (le_top : U ≤ ⊤)).op ≫
      U.ι.appLE U ⊤ U.ι_preimage_self.ge).hom
        (C.hom.appTop.hom ((Scheme.ΓSpecIso (.of k)).inv.hom c)) = _
  rw [Scheme.Hom.map_appLE, Scheme.Hom.comp_appTop]
  simp only [Scheme.Hom.appLE, Scheme.Hom.preimage_top, homOfLE_refl,
    op_id, CommRingCat.comp_apply]
  have hid := congrArg
    (fun q : Γ(U.toScheme, ⊤) ⟶ Γ(U.toScheme, ⊤) ↦ q.hom
      (U.ι.appTop.hom (C.hom.appTop.hom
        ((Scheme.ΓSpecIso (.of k)).inv.hom c))))
    (U.toScheme.presheaf.map_id (Opposite.op (⊤ : U.toScheme.Opens)))
  simpa using hid

/-- The section-ring equivalence is the inverse of the canonical top-sections
isomorphism used in `Opens.toSpecΓ`. -/
theorem topIso_inv_eq_appLE (U : C.left.Opens) :
    U.topIso.inv = U.ι.appLE U ⊤ U.ι_preimage_self.ge := by
  rw [Scheme.Opens.topIso_inv, Scheme.Opens.ι_appLE]
  rfl

/-- The affine spectrum structural map defined by the canonical section-ring
algebra is the structural map of the open subscheme. -/
theorem toSpecΓ_specToBase (U : C.left.Opens) :
    U.toSpecΓ ≫
        ProjectiveSpace.Coordinates.specToBase
          (k := k) (B := Γ(C.left, U)) =
      U.ι ≫ C.hom := by
  apply ext_to_Spec
  ext c
  change (U.toSpecΓ ≫
      ProjectiveSpace.Coordinates.specToBase
        (k := k) (B := Γ(C.left, U))).appTop.hom
          ((Scheme.ΓSpecIso (.of k)).inv.hom c) =
    (U.ι ≫ C.hom).appTop.hom
      ((Scheme.ΓSpecIso (.of k)).inv.hom c)
  rw [Scheme.Hom.comp_appTop]
  change U.toSpecΓ.appTop.hom
      ((ProjectiveSpace.Coordinates.specToBase
        (k := k) (B := Γ(C.left, U))).appTop.hom
          ((Scheme.ΓSpecIso (.of k)).inv.hom c)) = _
  have hbase :
      (ProjectiveSpace.Coordinates.specToBase
        (k := k) (B := Γ(C.left, U))).appTop.hom
          ((Scheme.ΓSpecIso (.of k)).inv.hom c) =
        (Scheme.ΓSpecIso Γ(C.left, U)).inv.hom
          (algebraMap k Γ(C.left, U) c) := by
    rw [ProjectiveSpace.Coordinates.specToBase,
      ← CommRingCat.comp_apply, ← Scheme.ΓSpecIso_inv_naturality,
      CommRingCat.comp_apply, ConcreteCategory.hom_ofHom]
    rw [Scheme.ΓSpecIso_inv, Scheme.ΓSpecIso_inv]
  rw [hbase, Scheme.Opens.toSpecΓ_appTop]
  rw [topIso_inv_eq_appLE U]
  simp only [CommRingCat.comp_apply, Iso.inv_hom_id_apply]
  change openSectionsEquiv U (algebraMap k Γ(C.left, U) c) = _
  exact openSectionsEquiv_algebraMap U c

/-- The factor of the global coordinate morphism through the first relative
affine chart. -/
def chartFactor0 :
    (pi.left ⁻¹ᵁ D.V₀).toScheme ⟶
      ProjectiveSpace.affineChartAt
        G.ProjectiveIndex G.firstIndex (Spec (.of k)) :=
  (pi.left ⁻¹ᵁ D.V₀).toSpecΓ ≫
    ProjectiveSpace.Coordinates.toAffineChartAt G.firstIndex
      G.projectiveCoordinates0 G.projectiveCoordinates0_zero

/-- The factor of the global coordinate morphism through the second relative
affine chart. -/
def chartFactor1 :
    (pi.left ⁻¹ᵁ D.V₁).toScheme ⟶
      ProjectiveSpace.affineChartAt
        G.ProjectiveIndex G.secondIndex (Spec (.of k)) :=
  (pi.left ⁻¹ᵁ D.V₁).toSpecΓ ≫
    ProjectiveSpace.Coordinates.toAffineChartAt G.secondIndex
      G.projectiveCoordinates1 G.projectiveCoordinates1_last

@[reassoc]
theorem chartFactor0_incl :
    G.chartFactor0 ≫
        ProjectiveSpace.affineChartAt.incl
          G.ProjectiveIndex G.firstIndex (Spec (.of k)) =
      (pi.left ⁻¹ᵁ D.V₀).ι ≫ G.toProjectiveSpace := by
  rw [chartFactor0, Category.assoc,
    ProjectiveSpace.Coordinates.toAffineChartAt_incl]
  apply pullback.hom_ext
  · change ((pi.left ⁻¹ᵁ D.V₀).toSpecΓ ≫
        ProjectiveSpace.Coordinates.relativeFromSpec G.firstIndex
          G.projectiveCoordinates0 G.projectiveCoordinates0_zero) ≫
        (ℙ(G.ProjectiveIndex; Spec (.of k)) ↘ Spec (.of k)) =
      ((pi.left ⁻¹ᵁ D.V₀).ι ≫ G.toProjectiveSpace) ≫
        (ℙ(G.ProjectiveIndex; Spec (.of k)) ↘ Spec (.of k))
    rw [Category.assoc, ProjectiveSpace.Coordinates.relativeFromSpec_over,
      toSpecΓ_specToBase (k := k) (C := C), Category.assoc,
      G.toProjectiveSpace_over]
  · change ((pi.left ⁻¹ᵁ D.V₀).toSpecΓ ≫
        ProjectiveSpace.Coordinates.relativeFromSpec G.firstIndex
          G.projectiveCoordinates0 G.projectiveCoordinates0_zero) ≫
        ProjectiveSpace.toProjInt G.ProjectiveIndex (Spec (.of k)) =
      ((pi.left ⁻¹ᵁ D.V₀).ι ≫ G.toProjectiveSpace) ≫
        ProjectiveSpace.toProjInt G.ProjectiveIndex (Spec (.of k))
    rw [Category.assoc,
      ProjectiveSpace.Coordinates.relativeFromSpec_toProjInt,
      Category.assoc, G.toProjectiveSpace_toProjInt, G.open0_toProjInt]
    rfl

@[reassoc]
theorem chartFactor1_incl :
    G.chartFactor1 ≫
        ProjectiveSpace.affineChartAt.incl
          G.ProjectiveIndex G.secondIndex (Spec (.of k)) =
      (pi.left ⁻¹ᵁ D.V₁).ι ≫ G.toProjectiveSpace := by
  rw [chartFactor1, Category.assoc,
    ProjectiveSpace.Coordinates.toAffineChartAt_incl]
  apply pullback.hom_ext
  · change ((pi.left ⁻¹ᵁ D.V₁).toSpecΓ ≫
        ProjectiveSpace.Coordinates.relativeFromSpec G.secondIndex
          G.projectiveCoordinates1 G.projectiveCoordinates1_last) ≫
        (ℙ(G.ProjectiveIndex; Spec (.of k)) ↘ Spec (.of k)) =
      ((pi.left ⁻¹ᵁ D.V₁).ι ≫ G.toProjectiveSpace) ≫
        (ℙ(G.ProjectiveIndex; Spec (.of k)) ↘ Spec (.of k))
    rw [Category.assoc, ProjectiveSpace.Coordinates.relativeFromSpec_over,
      toSpecΓ_specToBase (k := k) (C := C), Category.assoc,
      G.toProjectiveSpace_over]
  · change ((pi.left ⁻¹ᵁ D.V₁).toSpecΓ ≫
        ProjectiveSpace.Coordinates.relativeFromSpec G.secondIndex
          G.projectiveCoordinates1 G.projectiveCoordinates1_last) ≫
        ProjectiveSpace.toProjInt G.ProjectiveIndex (Spec (.of k)) =
      ((pi.left ⁻¹ᵁ D.V₁).ι ≫ G.toProjectiveSpace) ≫
        ProjectiveSpace.toProjInt G.ProjectiveIndex (Spec (.of k))
    rw [Category.assoc,
      ProjectiveSpace.Coordinates.relativeFromSpec_toProjInt,
      Category.assoc, G.toProjectiveSpace_toProjInt, G.open1_toProjInt]
    rfl

/-- The first local chart factor is a closed immersion whenever the original
two-chart morphism is finite. -/
theorem isClosedImmersion_chartFactor0 [IsFinite pi.left] :
    IsClosedImmersion G.chartFactor0 := by
  letI : IsAffine (pi.left ⁻¹ᵁ D.V₀).toScheme :=
    D.isAffineOpen_V₀.preimage pi.left
  letI : IsIso (pi.left ⁻¹ᵁ D.V₀).toSpecΓ := by
    dsimp [Scheme.Opens.toSpecΓ]
    infer_instance
  apply MorphismProperty.comp_mem @IsClosedImmersion
  · infer_instance
  · exact ProjectiveSpace.Coordinates.isClosedImmersion_toAffineChartAt
      G.firstIndex G.projectiveCoordinates0
        G.projectiveCoordinates0_zero G.adjoin_projectiveCoordinates0_ne

/-- The second local chart factor is a closed immersion whenever the original
two-chart morphism is finite. -/
theorem isClosedImmersion_chartFactor1 [IsFinite pi.left] :
    IsClosedImmersion G.chartFactor1 := by
  letI : IsAffine (pi.left ⁻¹ᵁ D.V₁).toScheme :=
    D.isAffineOpen_V₁.preimage pi.left
  letI : IsIso (pi.left ⁻¹ᵁ D.V₁).toSpecΓ := by
    dsimp [Scheme.Opens.toSpecΓ]
    infer_instance
  apply MorphismProperty.comp_mem @IsClosedImmersion
  · infer_instance
  · exact ProjectiveSpace.Coordinates.isClosedImmersion_toAffineChartAt
      G.secondIndex G.projectiveCoordinates1
        G.projectiveCoordinates1_last G.adjoin_projectiveCoordinates1_ne

end LaurentChartData.FiniteMapGenerators
end AlgebraicGeometry.Adelic
