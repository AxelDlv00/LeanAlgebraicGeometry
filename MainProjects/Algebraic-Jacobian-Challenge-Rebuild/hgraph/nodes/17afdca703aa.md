---
author: sync
content_type: theorem
created: '2026-07-20T02:31:15'
decl: AlgebraicGeometry.ThetaGeneratorSeed.hcolFin_of_forall_closure_subset
docstring: '**The ambient colength finiteness `hcolFin` from an empty leak** (the
  `hcolFin`

  hypothesis of `isGenerator_of_fibrewise_ker_span_of_field_vanishing`, reduced to
  the

  topological closed-trace): if on every piece the closure of the trace

  `piece z \ D(eqn z)` of the vanishing locus of the seed equation stays inside the
  piece,

  then each ambient colength `Γ(D(h z)) ⧸ (eqn z)` is a finite `R`-module.  Uses the
  abstract

  engine directly (the piece is affine, the structure morphism is universally closed
  and

  locally of finite type), so it consumes no `DivisorAdaptation` — the route stays

  anti-circular.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivColFin.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.hcolFin_of_forall_closure_subset
type: lean
updated: '2026-07-31T20:14:40'
---
theorem hcolFin_of_forall_closure_subset
    (hnoleak : ∀ z : relCurve C R,
      closure ((D.piece z : Set (relCurve C R)) \
          ((relCurve C R).basicOpen (D.eqn z) : Set (relCurve C R)))
        ⊆ (D.piece z : Set (relCurve C R))) :
    ∀ z : relCurve C R,
      Module.Finite R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}) :=
  fun z => (D.isAffineOpen_piece z).finite_quotient_span_singleton_of_closure_subset
    (D.eqn z) (hnoleak z)