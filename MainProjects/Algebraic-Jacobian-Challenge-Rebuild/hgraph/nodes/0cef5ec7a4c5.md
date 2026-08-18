---
author: sync
content_type: definition
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.DivRepAffinePullbackAff.equiv
docstring: The affine equivalence supplied by a widened affine package.
file: AlgebraicJacobian/Picard/DivRepGlobalClassifyAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivRepAffinePullbackAff.equiv
type: lean
updated: '2026-08-18T20:50:56'
---
noncomputable def equiv
    (D : DivRepAffinePullbackAff hpi g r1 r2 b1 b2)
    (S : Type u) [CommRing S] [Algebra k S] :
    (overSpec k S ⟶ DivOver) ≃ DivFamZarAff C S g where
  toFun := D.pull S
  invFun := divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 S
  left_inv := classify_pull hpi g hO hchi r1 r2 b1 b2 D S
  right_inv := pull_classify hpi g hO hchi r1 r2 b1 b2 D S

/-! ## The widened general-test pullback -/