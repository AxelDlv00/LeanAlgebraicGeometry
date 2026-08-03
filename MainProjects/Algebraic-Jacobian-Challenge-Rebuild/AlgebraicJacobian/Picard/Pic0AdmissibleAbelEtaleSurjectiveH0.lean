/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.GluedSheafH0BaseChange
import AlgebraicJacobian.Picard.DivisorFamilyPullbackMap

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

namespace BasicOpenCoverData

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
  [IsScalarTower k B B']
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]
variable (D : BasicOpenCoverData C B pi)

/-- The comparison of sections on a datum piece with sections on its base change. -/
noncomputable def piecesMap : ∀ j : D.index,
    Γ(relCurve C B, D.pieces j) →+*
      Γ(relCurve C B', (D.baseChange B').pieces j)
  | .inl j => pieceSectionsMap B' (fiberChart₀ pi) (D.h₀ j)
  | .inr j => pieceSectionsMap B' (fiberChart₁ pi) (D.h₁ j)

/-- Base change commutes with the basic-open localization defining each datum piece. -/
noncomputable def pieceTermBaseChange : ∀ j : D.index,
    B' ⊗[B] Γ(relCurve C B, D.pieces j) ≃ₐ[B']
      Γ(relCurve C B', (D.baseChange B').pieces j)
  | .inl j =>
      pieceTermBaseChangeAlg B' (fiberChart₀ pi)
        (fiberTwoCover pi).isAffineOpen₀.isCompact
        (fiberTwoCover pi).isAffineOpen₀.isQuasiSeparated
        (relCover_isAffineOpen₀ C B (fiberTwoCover pi))
        (relCover_isAffineOpen₀ C B' (fiberTwoCover pi)) (D.h₀ j)
  | .inr j =>
      pieceTermBaseChangeAlg B' (fiberChart₁ pi)
        (fiberTwoCover pi).isAffineOpen₁.isCompact
        (fiberTwoCover pi).isAffineOpen₁.isQuasiSeparated
        (relCover_isAffineOpen₁ C B (fiberTwoCover pi))
        (relCover_isAffineOpen₁ C B' (fiberTwoCover pi)) (D.h₁ j)

/-- The datum-piece base-change equivalence sends `1 ⊗ t` to the compared section. -/
theorem pieceTermBaseChange_one_tmul (j : D.index)
    (t : Γ(relCurve C B, D.pieces j)) :
    D.pieceTermBaseChange B' j ((1 : B') ⊗ₜ[B] t) = D.piecesMap B' j t := by
  cases j with
  | inl j =>
      exact pieceTermBaseChangeAlg_one_tmul B' (fiberChart₀ pi)
        (fiberTwoCover pi).isAffineOpen₀.isCompact
        (fiberTwoCover pi).isAffineOpen₀.isQuasiSeparated
        (relCover_isAffineOpen₀ C B (fiberTwoCover pi))
        (relCover_isAffineOpen₀ C B' (fiberTwoCover pi)) (D.h₀ j) t
  | inr j =>
      exact pieceTermBaseChangeAlg_one_tmul B' (fiberChart₁ pi)
        (fiberTwoCover pi).isAffineOpen₁.isCompact
        (fiberTwoCover pi).isAffineOpen₁.isQuasiSeparated
        (relCover_isAffineOpen₁ C B (fiberTwoCover pi))
        (relCover_isAffineOpen₁ C B' (fiberTwoCover pi)) (D.h₁ j) t

end BasicOpenCoverData

namespace BasicOpenCocycleDatum

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

set_option synthInstance.maxHeartbeats 800000 in
-- The glued trivialization carries a large dependent family of section rings.
-- A nonzero global section of a cocycle-glued line bundle on an integral scheme is
-- nonzero in every nonempty trivializing piece.
theorem component_ne_zero_of_global_ne_zero
    [IsIntegral (relCurve C K)] (D : BasicOpenCocycleDatum C K pi)
    (s : ↥(gluedSubmodule K D.pieces D.unit ⊤)) (hs : s ≠ 0)
    (j : D.index) (hj : D.pieces j ≠ ⊥) : D.component s j ≠ 0 := by
  intro hcomponent
  apply hs
  have hUj : ((D.pieces j : Set (relCurve C K))).Nonempty := by
    rcases Set.eq_empty_or_nonempty (D.pieces j : Set (relCurve C K)) with h | h
    · exact (hj (by ext x; rw [h]; simp)).elim
    · exact h
  have hres : gluedRes K D.pieces D.unit (le_top : D.pieces j ≤ ⊤) s = 0 := by
    apply (gluedTriv K D.isGluingCocycle j le_rfl).injective
    rw [map_zero, gluedTriv_apply, gluedRes_coe]
    simpa only [component, Scheme.resHom_resHom] using hcomponent
  apply Subtype.ext
  funext i
  by_cases hi : D.pieces i = ⊥
  · have hopen : ⊤ ⊓ D.pieces i = ⊥ := by rw [hi]; simp
    letI : Subsingleton Γ(relCurve C K, ⊤ ⊓ D.pieces i) := hopen ▸ inferInstance
    exact Subsingleton.elim _ _
  · have hUi : ((D.pieces i : Set (relCurve C K))).Nonempty := by
      rcases Set.eq_empty_or_nonempty (D.pieces i : Set (relCurve C K)) with h | h
      · exact (hi (by ext x; rw [h]; simp)).elim
      · exact h
    have hUji : (((D.pieces j ⊓ D.pieces i : (relCurve C K).Opens) :
        Set (relCurve C K))).Nonempty := by
      simpa only [Opens.coe_inf] using
        nonempty_preirreducible_inter (D.pieces j).isOpen (D.pieces i).isOpen hUj hUi
    letI : Nonempty ↥((D.pieces j ⊓ D.pieces i : (relCurve C K).Opens) :
        Set (relCurve C K)) := by
      obtain ⟨x, hx⟩ := hUji
      exact ⟨⟨x, hx⟩⟩
    have hinj : Function.Injective ((relCurve C K).resHom
        (show D.pieces j ⊓ D.pieces i ≤ ⊤ ⊓ D.pieces i by simp)) :=
      map_injective_of_isIntegral (H := this) (relCurve C K)
        (homOfLE (show D.pieces j ⊓ D.pieces i ≤ ⊤ ⊓ D.pieces i by simp))
    apply hinj
    have hval := congrArg (fun t => t.val i) hres
    simpa only [gluedRes_coe, Pi.zero_apply, Submodule.coe_zero, map_zero] using hval

end BasicOpenCocycleDatum

end AlgebraicGeometry
