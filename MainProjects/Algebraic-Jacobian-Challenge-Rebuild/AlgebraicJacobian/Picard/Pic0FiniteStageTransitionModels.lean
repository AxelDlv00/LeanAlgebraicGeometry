/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionOpenImmersions

/-!
# Pair-transition maps in the finite-stage Picard atlas

The ordered overlaps `U ∩ V` and `V ∩ U` in the exact separably closed Picard atlas are
canonically identified by restriction along `inf_comm`.  This file adds those transition
maps to the already descended restriction legs and spreads the entire finite family out over
one common finite subextension.  At that stage the restriction legs are open immersions and
the two transition directions are inverse.

This is not yet a `Scheme.GlueData`.  Its triple-overlap objects are pullbacks of restriction
legs, and constructing their `t'` maps and cyclic cocycle is the next boundary.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-! ## Exact pair transitions -/

/-- The finite family of ordered pairs indexing overlap-transition maps. -/
abbrev Pic0FiniteStageTransitionIndex :=
  Pic0FiniteStageChartIndex C × Pic0FiniteStageChartIndex C

/-- The source ring of the transition indexed by `(U, V)` is the reversed overlap ring. -/
def Pic0FiniteStageTransitionSource (p : Pic0FiniteStageTransitionIndex C) :
    Pic0FiniteStageRingIndex C :=
  Sum.inr (p.2, p.1)

/-- The target ring of the transition indexed by `(U, V)` is the forward overlap ring. -/
def Pic0FiniteStageTransitionTarget (p : Pic0FiniteStageTransitionIndex C) :
    Pic0FiniteStageRingIndex C :=
  Sum.inr p

/-- The algebra map underlying the canonical transition from the reversed ordered overlap
to the forward ordered overlap.  On schemes, `Spec.map` reverses this direction. -/
noncomputable def pic0FiniteStageTransition
    (p : Pic0FiniteStageTransitionIndex C) :
    Pic0FiniteStageRing C (Pic0FiniteStageTransitionSource C p) →ₐ[k]
      Pic0FiniteStageRing C (Pic0FiniteStageTransitionTarget C p) := by
  rcases p with ⟨U, V⟩
  let J := (pic0_sepClosed_representableBy (C := C)).1
  letI : J.left.Over (Spec (.of k)) := ⟨J.hom⟩
  have hUVVU : U.1.1 ⊓ V.1.1 ≤ V.1.1 ⊓ U.1.1 := by
    rw [inf_comm]
  exact
    { J.left.resHom hUVVU with
      commutes' := fun r =>
        J.left.overAlgebraMap_apply_res k (homOfLE hUVVU).op r }

/-- Reversing an exact pair transition gives its inverse. -/
theorem pic0FiniteStageTransition_inverse
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageTransition C (V, U)).comp
        (pic0FiniteStageTransition C (U, V)) =
      AlgHom.id k (Pic0FiniteStageOverlapRing C V U) := by
  apply DFunLike.ext _ _
  intro x
  change
    ((pic0_sepClosed_representableBy (C := C)).1.left.resHom
      (show V.1.1 ⊓ U.1.1 ≤ U.1.1 ⊓ V.1.1 by rw [inf_comm]))
      (((pic0_sepClosed_representableBy (C := C)).1.left.resHom
        (show U.1.1 ⊓ V.1.1 ≤ V.1.1 ⊓ U.1.1 by rw [inf_comm])) x) = x
  rw [Scheme.resHom_resHom, Scheme.resHom_self]

/-! ## One finite family of restrictions and transitions -/

/-- A finite index type containing every restriction leg and every pair transition. -/
abbrev Pic0FiniteStageMapIndex :=
  Pic0FiniteStageRestrictionIndex C ⊕ Pic0FiniteStageTransitionIndex C

/-- Source-ring tag for the combined finite family. -/
def Pic0FiniteStageMapSource :
    Pic0FiniteStageMapIndex C → Pic0FiniteStageRingIndex C
  | Sum.inl i => Pic0FiniteStageRestrictionSource C i
  | Sum.inr p => Pic0FiniteStageTransitionSource C p

/-- Target-ring tag for the combined finite family. -/
def Pic0FiniteStageMapTarget :
    Pic0FiniteStageMapIndex C → Pic0FiniteStageRingIndex C
  | Sum.inl i => Pic0FiniteStageRestrictionTarget C i
  | Sum.inr p => Pic0FiniteStageTransitionTarget C p

/-- The exact combined family: restrictions on the left summand and pair transitions on the
right summand. -/
noncomputable def pic0FiniteStageMap
    (q : Pic0FiniteStageMapIndex C) :
    Pic0FiniteStageRing C (Pic0FiniteStageMapSource C q) →ₐ[k]
      Pic0FiniteStageRing C (Pic0FiniteStageMapTarget C q) := by
  rcases q with i | p
  · exact pic0FiniteStageRestriction C i
  · exact pic0FiniteStageTransition C p

set_option synthInstance.maxHeartbeats 200000 in
-- The quotient presentation creates a dependent module instance for every ring tag.
/-- The chosen finite-presentation model ring at a further finite subextension. -/
abbrev Pic0FiniteStageModelRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → ℕ)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) : Type u :=
  M.1 ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
    (n j) (m j) (relation j)

set_option synthInstance.maxHeartbeats 200000 in
-- Both dependent tensor-product instances must elaborate before the conjugated map.
/-- The exact combined-family map transported to the ambient tensor-product models. -/
noncomputable def pic0FiniteStageTransportedMap
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → ℕ)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (e : ∀ j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (q : Pic0FiniteStageMapIndex C) :
    k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapSource C q))
        (m (Pic0FiniteStageMapSource C q))
        (relation (Pic0FiniteStageMapSource C q)) →ₐ[k]
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
        (n (Pic0FiniteStageMapTarget C q))
        (m (Pic0FiniteStageMapTarget C q))
        (relation (Pic0FiniteStageMapTarget C q)) :=
  (e (Pic0FiniteStageMapTarget C q)).symm.toAlgHom.comp
    ((pic0FiniteStageMap C q).comp
      (e (Pic0FiniteStageMapSource C q)).toAlgHom)

set_option synthInstance.maxHeartbeats 200000 in
-- The source and target quotient algebras depend on the ordered chart pair.
/-- The transported ambient transitions in opposite directions are inverse. -/
theorem pic0FiniteStageTransportedTransition_inverse
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C → ℕ)
    (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
    (e : ∀ j,
      k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
        Pic0FiniteStageRing C j)
    (U V : Pic0FiniteStageChartIndex C) :
    (pic0FiniteStageTransportedMap C L n m relation e (Sum.inr (V, U))).comp
        (pic0FiniteStageTransportedMap C L n m relation e (Sum.inr (U, V))) =
      AlgHom.id k
        (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
          (n (Sum.inr (V, U))) (m (Sum.inr (V, U)))
          (relation (Sum.inr (V, U)))) := by
  change
    ((e (Sum.inr (V, U))).symm.toAlgHom.comp
        ((pic0FiniteStageTransition C (V, U)).comp
          (e (Sum.inr (U, V))).toAlgHom)).comp
        ((e (Sum.inr (U, V))).symm.toAlgHom.comp
          ((pic0FiniteStageTransition C (U, V)).comp
            (e (Sum.inr (V, U))).toAlgHom)) = _
  apply DFunLike.ext _ _
  intro x
  change
    (e (Sum.inr (V, U))).symm
      (pic0FiniteStageTransition C (V, U)
        ((e (Sum.inr (U, V)))
          ((e (Sum.inr (U, V))).symm
            (pic0FiniteStageTransition C (U, V)
              ((e (Sum.inr (V, U))) x))))) = x
  rw [(e (Sum.inr (U, V))).apply_symm_apply]
  have htransition :=
    DFunLike.congr_fun (pic0FiniteStageTransition_inverse C U V)
      ((e (Sum.inr (V, U))) x)
  calc
    _ = (e (Sum.inr (V, U))).symm ((e (Sum.inr (V, U))) x) := by
      exact congrArg (e (Sum.inr (V, U))).symm htransition
    _ = x := (e (Sum.inr (V, U))).symm_apply_apply x

set_option synthInstance.maxHeartbeats 200000 in
-- The conclusion contains one dependent quotient-algebra instance for every finite tag.
set_option maxHeartbeats 1600000 in
-- The simultaneous descent and equation reflection require a larger elaboration budget.
/-- All exact restriction and pair-transition maps have simultaneous models over one finite
subextension.  The restriction legs remain open immersions, and opposite transition maps
are inverse at that same finite stage. -/
theorem exists_finSubext_pic0FiniteStageTransition_models
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] :
    ∃ (L : DatG0.FinSubext F k)
      (n m : Pic0FiniteStageRingIndex C → ℕ)
      (relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1)
      (e : ∀ j,
        k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
          Pic0FiniteStageRing C j),
      ∃ (M : DatG0.FinSubext L.1 k)
        (mapM : ∀ q : Pic0FiniteStageMapIndex C,
          Pic0FiniteStageModelRing C L n m relation M
              (Pic0FiniteStageMapSource C q) →ₐ[M.1]
            Pic0FiniteStageModelRing C L n m relation M
              (Pic0FiniteStageMapTarget C q)),
        (∀ q,
          (Algebra.TensorProduct.map M.1.val
              (AlgHom.id L.1
                (DatG0.FiniteRelationAlgebra L.1
                  (n (Pic0FiniteStageMapTarget C q))
                  (m (Pic0FiniteStageMapTarget C q))
                  (relation (Pic0FiniteStageMapTarget C q))))).comp
              ((mapM q).restrictScalars L.1) =
            ((pic0FiniteStageTransportedMap C L n m relation e q).restrictScalars
              L.1).comp
              (Algebra.TensorProduct.map M.1.val
                (AlgHom.id L.1
                  (DatG0.FiniteRelationAlgebra L.1
                    (n (Pic0FiniteStageMapSource C q))
                    (m (Pic0FiniteStageMapSource C q))
                    (relation (Pic0FiniteStageMapSource C q)))))) ∧
        (∀ i : Pic0FiniteStageRestrictionIndex C,
          IsOpenImmersion
            (Spec.map (CommRingCat.ofHom (mapM (Sum.inl i)).toRingHom))) ∧
        (∀ U V : Pic0FiniteStageChartIndex C,
          (mapM (Sum.inr (V, U))).comp (mapM (Sum.inr (U, V))) =
            AlgHom.id M.1
              (Pic0FiniteStageModelRing C L n m relation M (Sum.inr (V, U)))) := by
  classical
  obtain ⟨L, n, m, relation, e, _, _⟩ :=
    exists_finSubext_pic0FiniteStageRestriction_openImmersion_models
      (C := C) (F := F)
  obtain ⟨M, hM⟩ :=
    DatG0.exists_finSubext_tensorProduct_algHom_finite_of_models
      (F := L.1) (K := k)
      (fun q : Pic0FiniteStageMapIndex C =>
        DatG0.FiniteRelationAlgebra L.1
          (n (Pic0FiniteStageMapSource C q))
          (m (Pic0FiniteStageMapSource C q))
          (relation (Pic0FiniteStageMapSource C q)))
      (fun q : Pic0FiniteStageMapIndex C =>
        DatG0.FiniteRelationAlgebra L.1
          (n (Pic0FiniteStageMapTarget C q))
          (m (Pic0FiniteStageMapTarget C q))
          (relation (Pic0FiniteStageMapTarget C q)))
      (fun q : Pic0FiniteStageMapIndex C =>
        Pic0FiniteStageRing C (Pic0FiniteStageMapSource C q))
      (fun q : Pic0FiniteStageMapIndex C =>
        Pic0FiniteStageRing C (Pic0FiniteStageMapTarget C q))
      (fun q => e (Pic0FiniteStageMapSource C q))
      (fun q => e (Pic0FiniteStageMapTarget C q))
      (pic0FiniteStageMap C)
  choose mapM hmapM using hM
  refine ⟨L, n, m, relation, e, M, mapM, hmapM, ?_, ?_⟩
  · intro i
    let psi := pic0FiniteStageTransportedMap C L n m relation e (Sum.inl i)
    apply isOpenImmersion_of_fieldTower_tensorProducts
      (F := L.1) (L := M.1) (K := k) (mapM (Sum.inl i)) psi
    · have hval : M.1.val = IsScalarTower.toAlgHom L.1 M.1 k := by
        ext x
        rfl
      rw [← hval]
      exact hmapM (Sum.inl i)
    · apply isOpenImmersion_specMap_conjugate
        (e (Pic0FiniteStageRestrictionSource C i)).toRingEquiv
        (e (Pic0FiniteStageRestrictionTarget C i)).toRingEquiv
        (pic0FiniteStageRestriction C i).toRingHom
      exact isOpenImmersion_pic0FiniteStageRestriction C i
  · intro U V
    apply DatG0.tensorProduct_algHom_comp_eq_of_baseChange M
      (mapM (Sum.inr (U, V)))
      (mapM (Sum.inr (V, U)))
      (AlgHom.id M.1
        (Pic0FiniteStageModelRing C L n m relation M (Sum.inr (V, U))))
      (pic0FiniteStageTransportedMap C L n m relation e (Sum.inr (U, V)))
      (pic0FiniteStageTransportedMap C L n m relation e (Sum.inr (V, U)))
      (AlgHom.id k
        (k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1
          (n (Sum.inr (V, U))) (m (Sum.inr (V, U)))
          (relation (Sum.inr (V, U)))))
    · exact hmapM (Sum.inr (U, V))
    · exact hmapM (Sum.inr (V, U))
    · ext x
      rfl
    · exact pic0FiniteStageTransportedTransition_inverse C L n m relation e U V

end

end AlgebraicGeometry
