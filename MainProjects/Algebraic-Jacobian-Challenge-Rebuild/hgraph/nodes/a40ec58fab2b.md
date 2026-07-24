---
author: sync
content_type: class
created: '2026-07-24T17:02:46'
decl: is
file: AlgebraicJacobian/Picard/EffectivityOverlap.lean
generated: lean
lean_status: lean_ok
title: is
type: lean
updated: '2026-07-24T19:32:26'
---
  class is trivial, some trivialization has comparison unit `1` on the nose —
  `picClass_eq_one_iff` produces the cobounding unit, the seams of
  `AlgebraicJacobian.Picard.EffectivityTwist` pull it back to a geometric unit `e`, and
  twisting by `e⁻¹` kills the comparison;
* `Over.exists_flat_pieceTrivialization_of_le` — the **localize-and-flatten** step: any
  trivialized piece `V₁ ∋ x` contains a basic affine `V ∋ x` on which the restricted
  descended class is trivial (the avoidance brick at the germ prime of `x`, through the
  restriction canonicity `pieceDescentClass_res`), so `V` carries a **flat**
  trivialization.  These flat pieces are what the refinement-splice glues.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite
  TopologicalSpace CategoryTheory.PresheafOfGroups

open scoped TensorProduct

namespace AlgebraicGeometry

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
  [Algebra A B] [IsScalarTower k A B]
variable (C : Over (Spec (.of k)))

set_option quotPrecheck false in
local notation "XA" => (C ⊗ overSpec k A).left
set_option quotPrecheck false in
local notation "XB" => (C ⊗ overSpec k B).left
set_option quotPrecheck false in
local notation "Xq" => (C ⊗ overSpec k (B ⊗[A] B)).left
set_option quotPrecheck false in
local notation "u₁" => (C ◁ Over.overSpecMap (tensorInl (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "u₂" => (C ◁ Over.overSpecMap (tensorInr (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "cg" => (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left
set_option quotPrecheck false in
local notation "cgq" =>
  (C ◁ Over.overSpecMap ((Algebra.ofId A (B ⊗[A] B)).restrictScalars k)).left

namespace Over

-- The base-piece `A`-algebra structure and the cover-piece `Γ(V)`-algebra structure.
attribute [local instance] Over.sectionsAlgebraA Over.pieceCoverAlgebra