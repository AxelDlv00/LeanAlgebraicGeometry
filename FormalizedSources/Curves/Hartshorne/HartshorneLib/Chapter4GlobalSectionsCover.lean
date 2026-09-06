/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioCanonicalBridge

/-!
# Hartshorne IV.3.1: basic-open covers from projective coordinates

The `Proj.fromOfGlobalSections` producer stores generation as an image of the
irrelevant ideal.  This file exposes the corresponding source-side statement:
the basic opens of the chosen degree-one coordinates cover the source.  The
construction is conditional on the supplied generation certificate; it does
not manufacture a base-point-free linear system.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry
open MvPolynomial

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

attribute [local instance] MvPolynomial.gradedAlgebra

namespace GlobalSectionsProjectiveMapData

variable {n : ℕ}

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- A generating global-coordinate family has a covering family of basic opens. -/
lemma basicOpen_iSup_eq_top
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n) :
    ⨆ i : Fin (n + 1), X.left.basicOpen (data.sections i) = ⊤ := by
  letI : Algebra k Γ(X.left, ⊤) :=
    (X.left.overAlgebraMap k (⊤ : X.left.Opens)).toAlgebra
  have hspan : Ideal.span (Set.range data.sections) = (⊤ : Ideal Γ(X.left, ⊤)) := by
    have hI :
        (HomogeneousIdeal.irrelevant
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal =
        MvPolynomial.idealOfVars (Fin (n + 1)) k := by
      apply le_antisymm
      · rw [HomogeneousIdeal.toIdeal_irrelevant_le]
        intro i hi p hp
        rw [MvPolynomial.idealOfVars_eq_restrictSupportIdeal]
        change p ∈ MvPolynomial.restrictSupport k
          (Finsupp.degree ⁻¹' Set.Ici 1)
        rw [MvPolynomial.mem_restrictSupport_iff]
        intro m hm
        change 1 ≤ Finsupp.degree m
        have hweight : (Finsupp.weight (fun _ : Fin (n + 1) => 1)) m = i :=
          (MvPolynomial.mem_homogeneousSubmodule i p).mp hp
            (MvPolynomial.mem_support_iff.mp hm)
        have hdeg : Finsupp.degree m = i := by
          simpa only [Finsupp.degree_eq_weight_one] using hweight
        omega
      · rw [MvPolynomial.idealOfVars]
        refine Ideal.span_le.mpr ?_
        intro x hx
        rcases hx with ⟨i, rfl⟩
        exact HomogeneousIdeal.mem_irrelevant_of_mem
          (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (i := 1) (x := (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) k))
          (show 0 < (1 : ℕ) from one_pos)
          ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
            (MvPolynomial.isHomogeneous_X k i))
    have hmap :
      Ideal.map (MvPolynomial.aeval data.sections).toRingHom
            (MvPolynomial.idealOfVars (Fin (n + 1)) k) =
          Ideal.span (Set.range data.sections) := by
      rw [MvPolynomial.idealOfVars, Ideal.map_span]
      congr 1
      ext y
      constructor
      · rintro ⟨p, ⟨i, rfl⟩, rfl⟩
        exact ⟨i, by simp⟩
      · rintro ⟨i, rfl⟩
        exact ⟨MvPolynomial.X i, ⟨i, rfl⟩, by simp⟩
    rw [← hmap, ← hI]
    exact data.irrelevant_span
  have hcover := iSup_basicOpen_of_span_eq_top
    (X := X.left) (⊤ : X.left.Opens) (Set.range data.sections) hspan
  simpa only [iSup_range] using hcover

/-- The coordinate basic opens packaged as a scheme open cover. -/
noncomputable def coordinateOpenCover
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n) :
    X.left.OpenCover :=
  X.left.openCoverOfIsOpenCover
    (fun i : Fin (n + 1) => X.left.basicOpen (data.sections i))
    data.basicOpen_iSup_eq_top

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
@[simp]
lemma coordinateOpenCover_f
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (i : Fin (n + 1)) :
    (data.coordinateOpenCover).f i =
      (X.left.basicOpen (data.sections i)).ι := by
  rfl

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The restriction of the canonical map to a coordinate chart lands in the
corresponding standard projective chart. -/
lemma coordinateOpenCover_restricted_map_preimage_basicOpen
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    ((data.coordinateOpenCover).f j ≫ data.map) ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) = ⊤ := by
  rw [coordinateOpenCover_f, Scheme.Hom.comp_preimage,
    data.map_preimage_basicOpen]
  change (X.left.basicOpen (data.sections j)).ι ⁻¹ᵁ
    X.left.basicOpen (data.sections j) = ⊤
  simp

noncomputable local instance coordinateGlobalSectionsAlgebra :
    Algebra k Γ(X.left, ⊤) :=
  (X.left.overAlgebraMap k (⊤ : X.left.Opens)).toAlgebra

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The explicit map from a coordinate principal open to the corresponding
standard affine chart of projective space. -/
noncomputable def coordinateChartMap
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    (data.coordinateOpenCover).X j ⟶
      Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j) :=
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(X.left, ⊤) :=
    (MvPolynomial.aeval data.sections).toRingHom
  let hcoordinate :
      X.left.basicOpen (data.sections j) =
        X.left.basicOpen (f (MvPolynomial.X j)) := by
    simp [f]
  (X.left.isoOfEq hcoordinate).hom ≫
    Proj.toBasicOpenOfGlobalSections
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f rfl
      Nat.zero_lt_one
      ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
        (MvPolynomial.isHomogeneous_X k j))

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The explicit coordinate-chart map followed by the standard-open inclusion
is the restriction of the canonical map to that member of the source cover. -/
@[reassoc]
theorem coordinateChartMap_ι
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    data.coordinateChartMap j ≫
        (Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j)).ι =
      (data.coordinateOpenCover).f j ≫ data.map := by
  rw [coordinateChartMap, coordinateOpenCover_f]
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(X.left, ⊤) :=
    (MvPolynomial.aeval data.sections).toRingHom
  have hf :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map f = ⊤ :=
    data.irrelevant_span
  have hdeg : MvPolynomial.X j ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 1 :=
    (MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k j)
  have hpre :=
    Proj.fromOfGlobalSections_preimage_basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf
      Nat.zero_lt_one hdeg
  have hrestrict :=
    Proj.fromOfGlobalSections_morphismRestrict
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf
      Nat.zero_lt_one hdeg
  have hraw :
      Proj.toBasicOpenOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f rfl
          Nat.zero_lt_one hdeg ≫
        (Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j)).ι =
      (X.left.basicOpen (f (MvPolynomial.X j))).ι ≫
        Proj.fromOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf := by
    apply (cancel_epi (X.left.isoOfEq hpre).hom).mp
    rw [← Category.assoc, ← hrestrict, morphismRestrict_ι,
      Scheme.isoOfEq_hom_ι_assoc]
  change
    (X.left.isoOfEq (show
      X.left.basicOpen (data.sections j) =
        X.left.basicOpen (f (MvPolynomial.X j)) by simp [f])).hom ≫
      (Proj.toBasicOpenOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f rfl
          Nat.zero_lt_one hdeg ≫
        (Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j)).ι) =
    (X.left.basicOpen (data.sections j)).ι ≫
      Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf
  rw [hraw, Scheme.isoOfEq_hom_ι_assoc]

/-! ### Global closed immersion from affine chart producers -/

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- If every affine coordinate chart is a closed immersion, then the
associated global `Proj.fromOfGlobalSections` map is a closed immersion.
The target-local step is explicit, and the hypothesis is retained because
the affine chart generation theorem is a separate geometric producer. -/
theorem isClosedImmersion_of_coordinateChartMap
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (hci : ∀ j : Fin (n + 1),
      IsClosedImmersion (data.coordinateChartMap j)) :
    IsClosedImmersion data.map := by
  let U : Fin (n + 1) → (projectiveSpace k n).Opens := fun j =>
    Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (MvPolynomial.X j)
  have hI :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal ≤
      MvPolynomial.idealOfVars (Fin (n + 1)) k := by
    rw [HomogeneousIdeal.toIdeal_irrelevant_le]
    intro i hi p hp
    rw [MvPolynomial.idealOfVars_eq_restrictSupportIdeal]
    change p ∈ MvPolynomial.restrictSupport k
      (Finsupp.degree ⁻¹' Set.Ici 1)
    rw [MvPolynomial.mem_restrictSupport_iff]
    intro m hm
    change 1 ≤ Finsupp.degree m
    have hweight : (Finsupp.weight (fun _ : Fin (n + 1) => 1)) m = i :=
      (MvPolynomial.mem_homogeneousSubmodule i p).mp hp
        (MvPolynomial.mem_support_iff.mp hm)
    have hdeg : Finsupp.degree m = i := by
      simpa only [Finsupp.degree_eq_weight_one] using hweight
    omega
  have hU : ⨆ j, U j = ⊤ := by
    change (⨆ j : Fin (n + 1),
      Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j)) = ⊤
    exact Proj.iSup_basicOpen_eq_top
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (fun j : Fin (n + 1) => MvPolynomial.X j) hI
  apply IsZariskiLocalAtTarget.of_iSup_eq_top U hU
  intro j
  dsimp [coordinateOpenCover] at *
  let V : X.left.Opens := X.left.basicOpen (data.sections j)
  have hpre : data.map ⁻¹ᵁ U j = V := by
    simpa only [U, V] using data.map_preimage_basicOpen j
  have hlocal : IsClosedImmersion (data.map ∣_ U j) := by
    let eV : (data.map ⁻¹ᵁ U j).toScheme ≅
        (data.coordinateOpenCover).X j := by
      dsimp [coordinateOpenCover]
      exact X.left.isoOfEq hpre
    rw [MorphismProperty.arrow_mk_iso_iff (P := @IsClosedImmersion)
      (Arrow.isoMk' (data.map ∣_ U j) (data.coordinateChartMap j)
        eV (Iso.refl _) (by
          apply (cancel_mono (U j).ι).mp
          change eV.hom ≫ data.coordinateChartMap j ≫
              (Proj.basicOpen
                (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
                (MvPolynomial.X j)).ι =
            data.map ∣_ U j ≫ (U j).ι
          rw [data.coordinateChartMap_ι, morphismRestrict_ι]
          change eV.hom ≫ (data.coordinateOpenCover).f j ≫ data.map =
            (data.map ⁻¹ᵁ U j).ι ≫ data.map
          rw [coordinateOpenCover_f]
          change (X.left.isoOfEq hpre).hom ≫
              (X.left.basicOpen (data.sections j)).ι ≫ data.map =
            (data.map ⁻¹ᵁ U j).ι ≫ data.map
          rw [Scheme.isoOfEq_hom_ι_assoc]))]
    exact hci j
  exact hlocal

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The same chart factor obtained formally by restricting the composite from
the corresponding source-cover member. -/
noncomputable def restrictedCoordinateChartMap
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    (data.coordinateOpenCover).X j ⟶
      Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j) :=
  ((data.coordinateOpenCover).X j).topIso.inv ≫
    (((data.coordinateOpenCover).X j).isoOfEq
      (data.coordinateOpenCover_restricted_map_preimage_basicOpen j)).inv ≫
    (((data.coordinateOpenCover).f j ≫ data.map) ∣_
      Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j))

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
@[reassoc]
theorem restrictedCoordinateChartMap_ι
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    data.restrictedCoordinateChartMap j ≫
        (Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j)).ι =
      (data.coordinateOpenCover).f j ≫ data.map := by
  let U : (projectiveSpace k n).Opens := Proj.basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (MvPolynomial.X j)
  let q := (data.coordinateOpenCover).f j ≫ data.map
  have htop : q ⁻¹ᵁ U = ⊤ :=
    data.coordinateOpenCover_restricted_map_preimage_basicOpen j
  rw [restrictedCoordinateChartMap]
  change
    ((data.coordinateOpenCover).X j).topIso.inv ≫
      (((data.coordinateOpenCover).X j).isoOfEq htop).inv ≫
        ((q ∣_ U) ≫ U.ι) = q
  simp only [morphismRestrict_ι, Scheme.isoOfEq_inv_ι_assoc,
    Scheme.toIso_inv_ι_assoc]

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The restriction factor through the standard projective chart is exactly
the chart map constructed from localized global sections. -/
theorem restrictedCoordinateChartMap_eq_coordinateChartMap
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    data.restrictedCoordinateChartMap j = data.coordinateChartMap j := by
  apply (cancel_mono
    (Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (MvPolynomial.X j)).ι).mp
  rw [restrictedCoordinateChartMap_ι, coordinateChartMap_ι]

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The coordinate-chart maps, regarded as maps into the common projective
target rather than into their individual standard opens. -/
noncomputable def coordinateChartFamily
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    (data.coordinateOpenCover).X j ⟶ projectiveSpace k n :=
  data.coordinateChartMap j ≫
    (Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (MvPolynomial.X j)).ι

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The coordinate-chart family agrees on every pairwise pullback, hence is
valid descent data for the coordinate open cover. -/
theorem coordinateChartFamily_compat
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n) :
    ∀ (i j : Fin (n + 1)),
      pullback.fst ((data.coordinateOpenCover).f i)
          ((data.coordinateOpenCover).f j) ≫ data.coordinateChartFamily i =
      pullback.snd ((data.coordinateOpenCover).f i)
          ((data.coordinateOpenCover).f j) ≫ data.coordinateChartFamily j := by
  dsimp [coordinateOpenCover]
  intro i j
  change pullback.fst ((data.coordinateOpenCover).f i)
      ((data.coordinateOpenCover).f j) ≫
      (data.coordinateChartMap i ≫
        (Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X i)).ι) =
    pullback.snd ((data.coordinateOpenCover).f i)
      ((data.coordinateOpenCover).f j) ≫
      (data.coordinateChartMap j ≫
        (Proj.basicOpen
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j)).ι)
  rw [coordinateChartMap_ι, coordinateChartMap_ι]
  exact pullback.condition_assoc data.map

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- Glue the explicit coordinate-chart maps along the coordinate open cover. -/
noncomputable def gluedCoordinateChartMap
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n) :
    X.left ⟶ projectiveSpace k n :=
  data.coordinateOpenCover.glueMorphisms data.coordinateChartFamily
    data.coordinateChartFamily_compat

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- Gluing the localized coordinate-chart maps reconstructs the canonical
`Proj.fromOfGlobalSections` morphism. -/
theorem gluedCoordinateChartMap_eq_map
    (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n) :
    data.gluedCoordinateChartMap = data.map := by
  apply Scheme.Cover.hom_ext
    (X.left.openCoverOfIsOpenCover
      (fun i : Fin (n + 1) => X.left.basicOpen (data.sections i))
      data.basicOpen_iSup_eq_top)
  intro (i : Fin (n + 1))
  change (data.coordinateOpenCover).f i ≫ data.gluedCoordinateChartMap =
    (data.coordinateOpenCover).f i ≫ data.map
  rw [gluedCoordinateChartMap, Scheme.Cover.ι_glueMorphisms,
    coordinateChartFamily]
  exact data.coordinateChartMap_ι i

end GlobalSectionsProjectiveMapData

end
end Hartshorne
