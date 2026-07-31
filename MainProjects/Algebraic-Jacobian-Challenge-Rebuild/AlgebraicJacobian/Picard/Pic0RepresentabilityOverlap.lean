/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.EtaleSeparatedness
import AlgebraicJacobian.Picard.Pic0ThetaCocycle
import AlgebraicJacobian.Picard.RepresentableByCocycle

/-!
# The tensor-overlap comparison for Picard representability

For a field extension `k → L`, the two coprojections
`L → L ⊗[k] L` induce two pullbacks of an L-side representation.  This file
constructs the comparison between those two representing schemes.  Each pullback
is obtained from `Over.mapPullbackAdj`; the presheaf comparison is assembled from
the landed theta isomorphism and the equality of the two composites back to `k`.

The construction deliberately stops before the triple-tensor face equation.  That
remaining equation is the genuine effectivity/coherence consumer of this module and
must use the three tensor-face maps, rather than a definitional shortcut.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

variable {k L : Type u} [Field k] [Field L] [Algebra k L]
variable {C : Over (Spec (.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-! ## The two tensor coprojections and their common base map -/

/-- The first map `Spec (L ⊗[k] L) ⟶ Spec L`. -/
noncomputable def tensorOverlapInl :
    Spec (.of (L ⊗[k] L)) ⟶ Spec (.of L) :=
  Spec.map (CommRingCat.ofHom
    (tensorInl (k := k) (A := k) (B := L)).toRingHom)

/-- The second map `Spec (L ⊗[k] L) ⟶ Spec L`. -/
noncomputable def tensorOverlapInr :
    Spec (.of (L ⊗[k] L)) ⟶ Spec (.of L) :=
  Spec.map (CommRingCat.ofHom
    (tensorInr (k := k) (A := k) (B := L)).toRingHom)

/-- The common map to `Spec k` obtained from either tensor coprojection. -/
noncomputable def tensorOverlapBase :
    Spec (.of L) ⟶ Spec (.of k) :=
  Spec.map (CommRingCat.ofHom (algebraMap k L))

/-- The two tensor coprojections have the same composite to the challenge base. -/
lemma tensorOverlapInl_comp_base :
    tensorOverlapInl (k := k) (L := L) ≫ tensorOverlapBase (k := k) (L := L) =
      tensorOverlapInr (k := k) (L := L) ≫ tensorOverlapBase (k := k) (L := L) := by
  simp only [tensorOverlapInl, tensorOverlapInr, tensorOverlapBase]
  rw [← Spec.map_comp, ← Spec.map_comp]
  have h := tensorInl_comp_ofId (k := k) (A := k) (B := L)
  congr 1
  ext x
  exact DFunLike.congr_fun h x

/-! ## The presheaf comparison -/

/-- Rebase an L-side Picard functor along one tensor coprojection, then identify it
with the fixed k-side functor through theta and the common composite to `Spec k`. -/
noncomputable def tensorOverlapCommon
    (f : Spec (.of (L ⊗[k] L)) ⟶ Spec (.of L)) :
    (Over.map f).op ⋙ pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (f ≫ tensorOverlapBase (k := k) (L := L))).op ⋙
        pic0TypeFunctor C :=
  Functor.isoWhiskerLeft (Over.map f).op (pic0ThetaType k L C) ≪≫
    (Functor.associator (Over.map f).op (Over.map (tensorOverlapBase (k := k) (L := L))).op
      (pic0TypeFunctor C)).symm ≪≫
    (Functor.isoWhiskerRight
      (NatIso.op (Over.mapComp f (tensorOverlapBase (k := k) (L := L))))
      (pic0TypeFunctor C)).symm

/-- The canonical natural isomorphism between the two tensor-coprojection pullback
presheaves. -/
noncomputable def tensorOverlapTheta :
    (Over.map (tensorOverlapInl (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (tensorOverlapInr (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) :=
  tensorOverlapCommon (C := C) (tensorOverlapInl (k := k) (L := L)) ≪≫
    eqToIso (congrArg
      (fun g => (Over.map g).op ⋙ pic0TypeFunctor C)
      (tensorOverlapInl_comp_base (k := k) (L := L))) ≪≫
    (tensorOverlapCommon (C := C) (tensorOverlapInr (k := k) (L := L))).symm

/-! ## Pullback representations and the canonical scheme isomorphism -/

variable {J : Over (Spec (.of L))}

/-- The representation pulled back along the first tensor coprojection. -/
noncomputable def tensorOverlapRepInl
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    ((Over.map (tensorOverlapInl (k := k) (L := L))).op ⋙
      pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy
        ((Over.pullback (tensorOverlapInl (k := k) (L := L))).obj J) :=
  Functor.RepresentableBy.ofLeftAdjoint
    (Over.mapPullbackAdj (tensorOverlapInl (k := k) (L := L))) rep

/-- The representation pulled back along the second tensor coprojection. -/
noncomputable def tensorOverlapRepInr
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    ((Over.map (tensorOverlapInr (k := k) (L := L))).op ⋙
      pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy
        ((Over.pullback (tensorOverlapInr (k := k) (L := L))).obj J) :=
  Functor.RepresentableBy.ofLeftAdjoint
    (Over.mapPullbackAdj (tensorOverlapInr (k := k) (L := L))) rep

/-- The canonical representing-scheme isomorphism on the double tensor overlap. -/
noncomputable def tensorOverlapIso
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    (Over.pullback (tensorOverlapInl (k := k) (L := L))).obj J ≅
      (Over.pullback (tensorOverlapInr (k := k) (L := L))).obj J :=
  Functor.RepresentableBy.uniqueUpToIsoOfIso
    (tensorOverlapRepInl rep) (tensorOverlapRepInr rep)
    (tensorOverlapTheta (C := C))

set_option maxHeartbeats 800000 in
-- The expanded Over pullback comparison crosses several categorical
-- functors; its definitional check exceeds Lean's default heartbeat budget.
/-- Universal-element characterization of the tensor-overlap comparison. -/
theorem tensorOverlapIso_homEquiv
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J)
    {T : Over (Spec (.of (L ⊗[k] L)))}
    (f : T ⟶ (Over.pullback (tensorOverlapInl (k := k) (L := L))).obj J) :
    (tensorOverlapRepInr rep).homEquiv
        (f ≫ (tensorOverlapIso rep).hom) =
      (tensorOverlapTheta (C := C)).hom.app (Opposite.op T)
        ((tensorOverlapRepInl rep).homEquiv f) :=
  Functor.RepresentableBy.homEquiv_uniqueUpToIsoOfIso_hom
    (tensorOverlapRepInl rep) (tensorOverlapRepInr rep)
    (tensorOverlapTheta (C := C)) f

end AlgebraicGeometry
