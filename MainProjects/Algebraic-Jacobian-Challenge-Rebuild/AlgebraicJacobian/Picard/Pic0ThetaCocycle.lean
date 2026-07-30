/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ThetaCocycleIdentity

/-!
# The tower cocycle for the degree-zero Picard base-change comparison

This file contains the composition coherence for `pic0Theta` over a tower of field
extensions.  The identity coherence is proved in `Pic0ThetaCocycleIdentity`; separating the
two units keeps each large natural-isomorphism calculation independently kernel-checkable.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

section Cocycle

variable (k L M : Type u) [Field k] [Field L] [Field M]
  [Algebra k L] [Algebra L M] [Algebra k M] [IsScalarTower k L M]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- The iso-grade curve transport at the tower composite: `pic0PullbackNat` of the frozen
`baseChange.compIso`. -/
noncomputable def eCurve :
    pic0Functor ((baseChange k M).obj C)
      ≅ pic0Functor ((baseChange k L ⋙ baseChange L M).obj C) where
  hom := pic0PullbackNat ((baseChange.compIso k L M).app C).inv
  inv := pic0PullbackNat ((baseChange.compIso k L M).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]

/-- The `Over.mapComp` reassociation of the covariant base-change maps. -/
noncomputable def σMapCompIso :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))
      ≅ Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))
          ⋙ Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k M))
      = Spec.map (CommRingCat.ofHom (algebraMap L M))
          ≫ Spec.map (CommRingCat.ofHom (algebraMap k L)) by
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, ← IsScalarTower.algebraMap_eq]]) ≪≅≫
    Over.mapComp _ _

/-- The opposite-side bridge from the iterated pushforward to the composite pushforward. -/
noncomputable def αOp :
    (Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))).op
        ⋙ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).op
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))).op :=
  eqToIso rfl ≪≅≫ NatIso.op (σMapCompIso k L M)

/-- The iterated right-hand side of the theta tower coherence. -/
noncomputable def cocycleRHS :
    pic0Functor ((baseChange k M).obj C)
      ≅ (Over.map (Spec.map (CommRingCat.ofHom (algebraMap k M)))).op ⋙
          pic0Functor C :=
  eCurve k L M C
    ≪≅≫ pic0Theta L M ((baseChange k L).obj C)
    ≪≅≫ Functor.isoWhiskerLeft
        (Over.map (Spec.map (CommRingCat.ofHom (algebraMap L M)))).op (pic0Theta k L C)
    ≪≅≫ (Functor.associator _ _ _).symm
    ≪≅≫ Functor.isoWhiskerRight (αOp k L M) (pic0Functor C)

/-- The theta comparison for `k → M` is the composite of the comparisons for
`k → L` and `L → M`, transported across the canonical pullback reassociation. -/
theorem pic0Theta_comp : pic0Theta k M C = cocycleRHS k L M C := by
  sorry

end Cocycle

end AlgebraicGeometry
