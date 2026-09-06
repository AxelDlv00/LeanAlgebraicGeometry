/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SourceComplexUniformization
import MumfordLib.LatticeTorus

/-!
# Divisibility and torsion of compact connected complex Lie groups

The intrinsic uniformization and a real basis of its full period lattice
identify the underlying additive group with a product of `2 * g` circles.
This gives division by every nonzero integer and the exact torsion group.

Reference: Mumford, *Abelian Varieties*, Chapter I, Section 1, assertion (3), p. 3.
-/

set_option autoImplicit false

noncomputable section

open scoped Topology Manifold ContDiff IsMulCommutative

namespace Mumford.Analytic

open Uniformization ComplexVectorLatticeExponentialData

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-- The underlying abstract group of a compact connected complex Lie group
is a real torus with twice as many circle factors as its complex dimension.
The coordinates come from a real basis of the actual period lattice. -/
def compactComplexLieGroupGenusTorusUniformization :
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
    GenusTorusUniformization (Additive G) (Module.finrank ℂ E) := by
  apply Classical.choice
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : CompleteSpace E := FiniteDimensional.complete ℂ E
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G := complexLieAlgebraEquiv (G := G) I
  letI : NormedAddCommGroup (GroupLieAlgebra I G) :=
    NormedAddCommGroup.induced _ _
      e.symm.toLinearMap.toAddMonoidHom e.symm.injective
  letI : NormedSpace ℂ (GroupLieAlgebra I G) :=
    NormedSpace.induced ℂ _ _ e.symm.toLinearMap
  letI : UniformSpace (GroupLieAlgebra I G) :=
    @PseudoMetricSpace.toUniformSpace (GroupLieAlgebra I G) inferInstance
  letI : TopologicalSpace (GroupLieAlgebra I G) :=
    @UniformSpace.toTopologicalSpace (GroupLieAlgebra I G) inferInstance
  obtain ⟨coordinate, _, _, _, _, _, _, _, _, _, f, _, hadd⟩ :=
    compactComplexLieGroup_uniformization (G := G) I
  let d := intrinsicComplexVectorLatticeExponentialData (G := G) I coordinate
  letI : ChartedSpace (GroupLieAlgebra I G)
      (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) := analyticQuotientChartedSpace d
  let a : (GroupLieAlgebra I G ⧸ d.ambientPeriodLattice) ≃+ Additive G :=
    { toEquiv := f.toEquiv.trans Additive.ofMul
      map_add' := hadd }
  exact ⟨⟨a.symm.trans d.quotientGenusTorusAddEquiv⟩⟩

/-- Mumford's divisibility and torsion proposition: every nonzero integer
acts surjectively, and its kernel is a product of `2 * g` cyclic groups. -/
theorem compactComplexLieGroup_divisibility_and_torsion :
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
    (∀ n : ℤ, n ≠ 0 → Function.Surjective (fun x : Additive G => n • x)) ∧
      ∀ n : ℤ, n ≠ 0 → Nonempty
        (zsmulTorsionSubgroup (Additive G) n ≃+
          (Fin (2 * Module.finrank ℂ E) → ZMod n.natAbs)) := by
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
  let u := compactComplexLieGroupGenusTorusUniformization (G := G) I
  exact ⟨fun _ hn x => exists_division_of_uniformization u x hn,
    fun _ hn => ⟨zsmulTorsion_addEquiv_of_uniformization u hn⟩⟩

/-- The torsion subgroup has `|n| ^ (2 * g)` elements for every nonzero integer. -/
theorem compactComplexLieGroup_torsion_card {n : ℤ} (hn : n ≠ 0) :
    letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
    letI : CommGroup G := inferInstance
    Nat.card (zsmulTorsionSubgroup (Additive G) n) =
      n.natAbs ^ (2 * Module.finrank ℂ E) := by
  letI : IsMulCommutative G := complexLieGroup_isMulCommutative (G := G) I
  letI : CommGroup G := inferInstance
  obtain ⟨e⟩ := (compactComplexLieGroup_divisibility_and_torsion (G := G) I).2 n hn
  rw [Nat.card_congr e.toEquiv, Nat.card_fun, Nat.card_zmod,
    Nat.card_eq_fintype_card, Fintype.card_fin]

end Mumford.Analytic
