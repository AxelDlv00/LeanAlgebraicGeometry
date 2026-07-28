---
author: sync
content_type: theorem
created: '2026-07-28T23:30:58'
decl: AlgebraicGeometry.Scheme.topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
docstring: '**A scheme all of whose stalks have Krull dimension `d` has dimension
  `d`.**


  The specialisation of `topologicalKrullDim_eq_iSup_ringKrullDim_stalk` to a

  *constant* stalk dimension. `Nonempty X` is genuinely needed: over an empty

  scheme the supremum is `⊥`, not `d`.


  **READ THE SCOPE WARNING BEFORE REACHING FOR THIS.** It is nearly vacuous, and

  saying so is the point of stating the two bounds below instead. Stalks of a

  scheme are *not* all of the same dimension: the stalk at a generic point of an

  irreducible component is a localisation at a minimal prime, so it has dimension

  `0`, while the stalk at a closed point of a `d`-dimensional variety has dimension

  `d`. So the hypothesis `∀ z, ringKrullDim (stalk z) = d` forces `d = 0` on any

  nonempty scheme with a generic point — in particular this lemma says nothing

  about `Pic⁰` beyond `d = 0`, and the "translation makes all stalks isomorphic"

  reading of homogeneity is **false**: translation is transitive on *closed* points

  of a group scheme over an algebraically closed field, not on all points.


  The useful forms are `topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le`

  (the ≤ half, quantified over all points) and

  `ringKrullDim_stalk_le_topologicalKrullDim` (the ≥ half, at one point), combined

  in `topologicalKrullDim_eq_of_le_of_exists_ge`.'
file: AlgebraicJacobian/Picard/SchemeKrullDimStalk.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
type: lean
updated: '2026-07-29T06:43:22'
---
theorem topologicalKrullDim_eq_of_forall_ringKrullDim_stalk_eq
    (X : Scheme.{u}) [Nonempty X] (d : WithBot ℕ∞)
    (h : ∀ z : X, ringKrullDim (X.presheaf.stalk z) = d) :
    topologicalKrullDim X = d := by
  rw [topologicalKrullDim_eq_iSup_ringKrullDim_stalk X]
  simp [h]