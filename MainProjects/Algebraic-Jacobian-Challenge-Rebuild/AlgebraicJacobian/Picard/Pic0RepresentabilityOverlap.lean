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

Over the triple tensor product, the three actual Amitsur faces determine three maps
back to `Spec L`.  The corresponding Picard comparisons are defined independently
through a common k-side functor, and Yoneda uniqueness turns their natural-isomorphism
cocycle into the representing-scheme cocycle.  In particular, the `1,3` comparison is
not defined as the composite of the other two.
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

/-- Rebase the L-side Picard functor along an arbitrary map to `Spec L`, then identify
it with the k-side functor over the composite base map. -/
noncomputable def pic0BaseCommon {S : Scheme.{u}} (f : S ⟶ Spec (.of L)) :
    (Over.map f).op ⋙ pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (f ≫ tensorOverlapBase (k := k) (L := L))).op ⋙
        pic0TypeFunctor C :=
  Functor.isoWhiskerLeft (Over.map f).op (pic0ThetaType k L C) ≪≫
    (Functor.associator (Over.map f).op
      (Over.map (tensorOverlapBase (k := k) (L := L))).op
      (pic0TypeFunctor C)).symm ≪≫
    (Functor.isoWhiskerRight
      (NatIso.op (Over.mapComp f (tensorOverlapBase (k := k) (L := L))))
      (pic0TypeFunctor C)).symm

/-- Rebase an L-side Picard functor along one tensor coprojection, then identify it
with the fixed k-side functor through theta and the common composite to `Spec k`. -/
noncomputable def tensorOverlapCommon
    (f : Spec (.of (L ⊗[k] L)) ⟶ Spec (.of L)) :
    (Over.map f).op ⋙ pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (f ≫ tensorOverlapBase (k := k) (L := L))).op ⋙
        pic0TypeFunctor C :=
  pic0BaseCommon (C := C) f

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

/-! ## The triple tensor faces -/

/-- The `1,2` Amitsur face on the triple tensor product. -/
noncomputable def tensorTripleFace12 :
    Spec (.of (L ⊗[k] (L ⊗[k] L))) ⟶ Spec (.of (L ⊗[k] L)) :=
  Spec.map (CommRingCat.ofHom (Module.descentFace₁₂ k L).toRingHom)

/-- The `1,3` Amitsur face on the triple tensor product. -/
noncomputable def tensorTripleFace13 :
    Spec (.of (L ⊗[k] (L ⊗[k] L))) ⟶ Spec (.of (L ⊗[k] L)) :=
  Spec.map (CommRingCat.ofHom (Module.descentFace₁₃ k L).toRingHom)

/-- The `2,3` Amitsur face on the triple tensor product. -/
noncomputable def tensorTripleFace23 :
    Spec (.of (L ⊗[k] (L ⊗[k] L))) ⟶ Spec (.of (L ⊗[k] L)) :=
  Spec.map (CommRingCat.ofHom (Module.descentFace₂₃ k L).toRingHom)

/-- Projection from the triple overlap to the first copy of `Spec L`. -/
noncomputable def tensorTripleCoord1 :=
  tensorTripleFace12 (k := k) (L := L) ≫ tensorOverlapInl (k := k) (L := L)

/-- Projection from the triple overlap to the second copy of `Spec L`. -/
noncomputable def tensorTripleCoord2 :=
  tensorTripleFace12 (k := k) (L := L) ≫ tensorOverlapInr (k := k) (L := L)

/-- Projection from the triple overlap to the third copy of `Spec L`. -/
noncomputable def tensorTripleCoord3 :=
  tensorTripleFace23 (k := k) (L := L) ≫ tensorOverlapInr (k := k) (L := L)

/-- The second coordinate is also the left coordinate of the `2,3` face. -/
lemma tensorTripleCoord2_eq_face23_inl :
    tensorTripleCoord2 (k := k) (L := L) =
      tensorTripleFace23 (k := k) (L := L) ≫
        tensorOverlapInl (k := k) (L := L) := by
  simp only [tensorTripleCoord2, tensorTripleFace12, tensorTripleFace23,
    tensorOverlapInl, tensorOverlapInr]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1

/-- The left coordinate of the `1,3` face is the first triple coordinate. -/
lemma tensorTripleFace13_inl :
    tensorTripleFace13 (k := k) (L := L) ≫
        tensorOverlapInl (k := k) (L := L) =
      tensorTripleCoord1 (k := k) (L := L) := by
  simp only [tensorTripleCoord1, tensorTripleFace12, tensorTripleFace13,
    tensorOverlapInl]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1

/-- The right coordinate of the `1,3` face is the third triple coordinate. -/
lemma tensorTripleFace13_inr :
    tensorTripleFace13 (k := k) (L := L) ≫
        tensorOverlapInr (k := k) (L := L) =
      tensorTripleCoord3 (k := k) (L := L) := by
  simp only [tensorTripleCoord3, tensorTripleFace13, tensorTripleFace23,
    tensorOverlapInr]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1

/-- The common map from the triple overlap to `Spec k`. -/
noncomputable def tensorTripleBase :=
  tensorTripleCoord1 (k := k) (L := L) ≫ tensorOverlapBase (k := k) (L := L)

lemma tensorTripleCoord1_comp_base :
    tensorTripleCoord1 (k := k) (L := L) ≫
        tensorOverlapBase (k := k) (L := L) =
      tensorTripleBase (k := k) (L := L) := rfl

lemma tensorTripleCoord2_comp_base :
    tensorTripleCoord2 (k := k) (L := L) ≫
        tensorOverlapBase (k := k) (L := L) =
      tensorTripleBase (k := k) (L := L) := by
  unfold tensorTripleCoord2 tensorTripleBase tensorTripleCoord1
  rw [Category.assoc, Category.assoc,
    tensorOverlapInl_comp_base (k := k) (L := L)]

lemma tensorTripleCoord3_comp_base :
    tensorTripleCoord3 (k := k) (L := L) ≫
        tensorOverlapBase (k := k) (L := L) =
      tensorTripleBase (k := k) (L := L) := by
  rw [tensorTripleCoord3, Category.assoc,
    ← tensorOverlapInl_comp_base (k := k) (L := L)]
  rw [← Category.assoc, ← tensorTripleCoord2_eq_face23_inl]
  exact tensorTripleCoord2_comp_base (k := k) (L := L)

/-! ## The presheaf cocycle on the triple overlap -/

/-- Identify a coordinate pullback with the common k-side Picard functor on the triple
overlap. -/
noncomputable def tensorTripleCommon
    (f : Spec (.of (L ⊗[k] (L ⊗[k] L))) ⟶ Spec (.of L))
    (hf : f ≫ tensorOverlapBase (k := k) (L := L) =
      tensorTripleBase (k := k) (L := L)) :
    (Over.map f).op ⋙ pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (tensorTripleBase (k := k) (L := L))).op ⋙ pic0TypeFunctor C :=
  pic0BaseCommon (C := C) f ≪≫
    eqToIso (congrArg (fun g => (Over.map g).op ⋙ pic0TypeFunctor C) hf)

/-- The independently defined Picard comparison between two triple-overlap coordinates. -/
noncomputable def tensorTripleTheta
    (f g : Spec (.of (L ⊗[k] (L ⊗[k] L))) ⟶ Spec (.of L))
    (hf : f ≫ tensorOverlapBase (k := k) (L := L) =
      tensorTripleBase (k := k) (L := L))
    (hg : g ≫ tensorOverlapBase (k := k) (L := L) =
      tensorTripleBase (k := k) (L := L)) :
    (Over.map f).op ⋙ pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map g).op ⋙ pic0TypeFunctor ((baseChange k L).obj C) :=
  tensorTripleCommon (C := C) f hf ≪≫ (tensorTripleCommon (C := C) g hg).symm

noncomputable def tensorTripleTheta12 :
    (Over.map (tensorTripleCoord1 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (tensorTripleCoord2 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) :=
  tensorTripleTheta (k := k) (L := L) (C := C)
    (tensorTripleCoord1 (k := k) (L := L))
    (tensorTripleCoord2 (k := k) (L := L))
    (tensorTripleCoord1_comp_base (k := k) (L := L))
    (tensorTripleCoord2_comp_base (k := k) (L := L))

noncomputable def tensorTripleTheta23 :
    (Over.map (tensorTripleCoord2 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (tensorTripleCoord3 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) :=
  tensorTripleTheta (k := k) (L := L) (C := C)
    (tensorTripleCoord2 (k := k) (L := L))
    (tensorTripleCoord3 (k := k) (L := L))
    (tensorTripleCoord2_comp_base (k := k) (L := L))
    (tensorTripleCoord3_comp_base (k := k) (L := L))

/-- The direct `1,3` comparison, defined through the common k-side functor rather than
as the composite of the `1,2` and `2,3` comparisons. -/
noncomputable def tensorTripleTheta13 :
    (Over.map (tensorTripleCoord1 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) ≅
      (Over.map (tensorTripleCoord3 (k := k) (L := L))).op ⋙
        pic0TypeFunctor ((baseChange k L).obj C) :=
  tensorTripleTheta (k := k) (L := L) (C := C)
    (tensorTripleCoord1 (k := k) (L := L))
    (tensorTripleCoord3 (k := k) (L := L))
    (tensorTripleCoord1_comp_base (k := k) (L := L))
    (tensorTripleCoord3_comp_base (k := k) (L := L))

/-- The three independently defined Picard comparisons satisfy the Amitsur cocycle. -/
theorem tensorTripleTheta_cocycle :
    tensorTripleTheta13 (k := k) (L := L) (C := C) =
      tensorTripleTheta12 (k := k) (L := L) (C := C) ≪≫
        tensorTripleTheta23 (k := k) (L := L) (C := C) := by
  apply Iso.ext
  simp [tensorTripleTheta13, tensorTripleTheta12, tensorTripleTheta23,
    tensorTripleTheta]

/-! ## The representing-scheme cocycle -/

/-- Pull an L-side representation directly to one coordinate of the triple overlap. -/
noncomputable def tensorTripleRep
    (f : Spec (.of (L ⊗[k] (L ⊗[k] L))) ⟶ Spec (.of L))
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    ((Over.map f).op ⋙ pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy
      ((Over.pullback f).obj J) :=
  Functor.RepresentableBy.ofLeftAdjoint (Over.mapPullbackAdj f) rep

noncomputable def tensorTripleRep1
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :=
  tensorTripleRep (C := C) (tensorTripleCoord1 (k := k) (L := L)) rep

noncomputable def tensorTripleRep2
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :=
  tensorTripleRep (C := C) (tensorTripleCoord2 (k := k) (L := L)) rep

noncomputable def tensorTripleRep3
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :=
  tensorTripleRep (C := C) (tensorTripleCoord3 (k := k) (L := L)) rep

noncomputable def tensorTripleIso12
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    (Over.pullback (tensorTripleCoord1 (k := k) (L := L))).obj J ≅
      (Over.pullback (tensorTripleCoord2 (k := k) (L := L))).obj J :=
  Functor.RepresentableBy.uniqueUpToIsoOfIso
    (tensorTripleRep1 rep) (tensorTripleRep2 rep) (tensorTripleTheta12 (C := C))

noncomputable def tensorTripleIso23
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    (Over.pullback (tensorTripleCoord2 (k := k) (L := L))).obj J ≅
      (Over.pullback (tensorTripleCoord3 (k := k) (L := L))).obj J :=
  Functor.RepresentableBy.uniqueUpToIsoOfIso
    (tensorTripleRep2 rep) (tensorTripleRep3 rep) (tensorTripleTheta23 (C := C))

/-- The direct `1,3` representing-scheme comparison. -/
noncomputable def tensorTripleIso13
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    (Over.pullback (tensorTripleCoord1 (k := k) (L := L))).obj J ≅
      (Over.pullback (tensorTripleCoord3 (k := k) (L := L))).obj J :=
  Functor.RepresentableBy.uniqueUpToIsoOfIso
    (tensorTripleRep1 rep) (tensorTripleRep3 rep) (tensorTripleTheta13 (C := C))

/-- The three canonical representing-scheme comparisons satisfy the triple-face cocycle. -/
theorem tensorTripleIso_cocycle
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    tensorTripleIso13 rep = tensorTripleIso12 rep ≪≫ tensorTripleIso23 rep := by
  exact Functor.RepresentableBy.uniqueUpToIsoOfIso_trans
    (tensorTripleRep1 rep) (tensorTripleRep2 rep) (tensorTripleRep3 rep)
    (tensorTripleTheta12 (C := C)) (tensorTripleTheta23 (C := C))
    (tensorTripleTheta13 (C := C)) (tensorTripleTheta_cocycle (C := C))

end AlgebraicGeometry
