---
author: sync
content_type: theorem
created: '2026-07-28T15:35:17'
decl: AlgebraicGeometry.relPicMulEquivCechPic_relPicMap
docstring: '**The equivalence intertwines restriction along `g` with pullback of Čech
  classes.**


  Without this, `relPicMulEquivCechPic` would identify the two *groups* at each end
  of the

  `ε`-restriction while saying nothing about the *map* between them — and it is the
  kernel of

  that map that Wave 5 computes. With it, the statement

  `ker(relPic(k[ε]) → relPic(k)) ≃ ker(CechPic(C_ε) → CechPic(C))` is immediate.


  The proof is `relPicMap_mk`: the relative restriction is *defined* as `CechPic.map
  (C ◁ g)`

  descended to the quotients, so once the quotient is trivial there is nothing left
  to check.

  Recorded explicitly because "the groups agree" and "the maps agree" are different
  claims and

  only the second one is usable.'
file: AlgebraicJacobian/Tangent/RelPicPointTest.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relPicMulEquivCechPic_relPicMap
type: lean
updated: '2026-07-29T15:26:23'
---
theorem relPicMulEquivCechPic_relPicMap (T T' : Over (Spec (.of k)))
    [Subsingleton T.left] [Subsingleton T'.left] (g : T' ⟶ T) (x : relPic C T) :
    relPicMulEquivCechPic C T' (relPicMap C g x)
      = Scheme.CechPic.map (C ◁ g).left (relPicMulEquivCechPic C T x) := by
  induction x using relPic.ind with
  | mk L => rw [relPicMap_mk, relPicMulEquivCechPic_relPicMk, relPicMulEquivCechPic_relPicMk]