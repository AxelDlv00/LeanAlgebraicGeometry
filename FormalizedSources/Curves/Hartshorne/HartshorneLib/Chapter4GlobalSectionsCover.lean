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

end GlobalSectionsProjectiveMapData

end
end Hartshorne
