/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamily
import AlgebraicJacobian.Picard.FlatCokernel
import AlgebraicJacobian.Cohomology.GluedSheafDatumBaseChange
import AlgebraicJacobian.Cohomology.RelativeH1BaseChange

/-!
# Base change of certified divisor families (the DD-1 stage (c) pullback,
`informal/spec-dd-1.md` §3 stage (c))

Along a test-ring change `R → R'` (a `k`-algebra map, packaged as `[Algebra R R']`
`[IsScalarTower k R R']`), a certified divisor family over `R` pulls back to one over
`R'` through the relative-curve comparison morphism `relCurveMap C R R'`. This file builds
the geometric half of that pullback — the cover data and adaptation push forward through
the sections comparison `relSectionsMap` (`Scheme.Hom.appLE`), pieces to pieces
(`relSectionsMap_basicOpen`), partitions by `map_sum`/`map_mul`/`map_one` — and prepares
the certificate transport that turns it into `DivFam.mapAlg`.

* `AlgebraicGeometry.FinCoverData.baseChange` — the `Fin`-indexed cover data pushes
  forward: generators/partition coefficients go through `relSectionsMap`, the partition
  witnesses by ring-hom functoriality (the `Fin`-indexed mirror of
  `BasicOpenCoverData.baseChange`).
* `AlgebraicGeometry.FinCoverData.pieces_baseChange` — pieces base-change to pieces
  (`relSectionsMap_basicOpen`): `(D.baseChange R').pieces j = relCurveMap ⁻¹ᵁ D.pieces j`.

The module structures are the local instances of the DD-1 carrier (`Scheme.overModule`,
`Scheme.overSectionsAlgebra`, house rule); the mixed `relCurve`/product spellings force
`backward.isDefEq.respectTransparency false`, as in `RelativeSectionsLinear`.
-/

set_option autoImplicit false
/- Statements mix `Γ(relCurve C R, ·)` with opens produced on the product spelling
`(C ⊗ overSpec k R).left`; see `AlgebraicJacobian.Cohomology.RelativeSectionsLinear`. -/
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory TopologicalSpace
open Opposite TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
variable {π : C.left ⟶ P1 k} [IsAffineHom π]

/-! ## The cover data base change -/

namespace FinCoverData

variable (D : FinCoverData C R π)

/-- **Base change of the `Fin`-indexed cover data** along `R → R'`: the generators and
partition coefficients push forward through the sections comparison `relSectionsMap`; the
partition witnesses are carried by `map_sum`/`map_mul`/`map_one` (the `Fin`-indexed mirror
of `BasicOpenCoverData.baseChange`). -/
noncomputable def baseChange : FinCoverData C R' π where
  m₀ := D.m₀
  m₁ := D.m₁
  h₀ j := relSectionsMap C R R' (fiberChart₀ π) (D.h₀ j)
  h₁ j := relSectionsMap C R R' (fiberChart₁ π) (D.h₁ j)
  a₀ j := relSectionsMap C R R' (fiberChart₀ π) (D.a₀ j)
  a₁ j := relSectionsMap C R R' (fiberChart₁ π) (D.a₁ j)
  partition₀ := by
    have h := congrArg (relSectionsMap C R R' (fiberChart₀ π)) D.partition₀
    rw [map_sum, map_one] at h
    rw [← h]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm
  partition₁ := by
    have h := congrArg (relSectionsMap C R R' (fiberChart₁ π)) D.partition₁
    rw [map_sum, map_one] at h
    rw [← h]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm

@[simp]
lemma baseChange_h₀ (j : Fin D.m₀) :
    (D.baseChange R').h₀ j = relSectionsMap C R R' (fiberChart₀ π) (D.h₀ j) := rfl

@[simp]
lemma baseChange_h₁ (j : Fin D.m₁) :
    (D.baseChange R').h₁ j = relSectionsMap C R R' (fiberChart₁ π) (D.h₁ j) := rfl

/-- **Pieces base-change to pieces**: the pieces of the base-changed cover data are the
`relCurveMap`-preimages of the pieces (`relSectionsMap_basicOpen`). -/
theorem pieces_baseChange (j : D.index) :
    (D.baseChange R').pieces j = relCurveMap C R R' ⁻¹ᵁ D.pieces j := by
  cases j with
  | inl j => exact relSectionsMap_basicOpen C R R' (fiberChart₀ π) (D.h₀ j)
  | inr j => exact relSectionsMap_basicOpen C R R' (fiberChart₁ π) (D.h₁ j)

/-- The base-changed pieces are below the preimages of the pieces (the `≤`-form of
`pieces_baseChange` consumed by `appLE`). -/
lemma baseChange_pieces_le_preimage (j : D.index) :
    (D.baseChange R').pieces j ≤ relCurveMap C R R' ⁻¹ᵁ D.pieces j :=
  (D.pieces_baseChange R' j).le

/-- Double overlaps of base-changed pieces are below the preimages of the double
overlaps. -/
lemma baseChange_inf_le_preimage (i j : D.index) :
    (D.baseChange R').pieces i ⊓ (D.baseChange R').pieces j ≤
      relCurveMap C R R' ⁻¹ᵁ (D.pieces i ⊓ D.pieces j) := by
  rw [Scheme.Hom.preimage_inf]
  exact inf_le_inf (D.baseChange_pieces_le_preimage R' i)
    (D.baseChange_pieces_le_preimage R' j)

end FinCoverData

end AlgebraicGeometry
