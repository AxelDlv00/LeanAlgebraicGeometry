---
author: sync
content_type: definition
created: '2026-07-30T10:29:03'
decl: AlgebraicGeometry.ProbeP4R6c.probeRepBy
docstring: An iso onto the Sigma-functor IS a RepresentableBy datum.
file: scratch_p4r6/probe7.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ProbeP4R6c.probeRepBy
type: lean
updated: '2026-07-31T20:31:22'
---
noncomputable def probeRepBy {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    [IsIso f] : (pic0SigmaFunctor C).RepresentableBy X where
  homEquiv {T} := (Iso.toEquiv ((asIso f).app (op T))).trans (Equiv.refl _)
  homEquiv_comp {T T'} g x :=
    NatTrans.naturality_apply f g.op x