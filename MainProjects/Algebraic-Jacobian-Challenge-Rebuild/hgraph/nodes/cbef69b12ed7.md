---
author: sync
content_type: definition
created: '2026-07-29T04:41:52'
decl: TruncExpCech.quotientSpanEpsRingEquiv
docstring: '**`A[ε] ⧸ (ε) ≃+* A`** — the first isomorphism theorem applied to `ε ↦
  0`, with the kernel

  identified by `ker_fstRingHom`.


  This is the form a consumer feeds to `QuotSMulTop.equivQuotTensor`: reducing an
  `A[ε]`-module

  modulo `ε` **is** tensoring with `A` over `A[ε]`.'
file: AlgebraicJacobian/Tangent/DualNumberFstKernel.lean
generated: lean
lean_status: lean_ok
title: TruncExpCech.quotientSpanEpsRingEquiv
type: lean
updated: '2026-07-29T15:31:50'
---
noncomputable def quotientSpanEpsRingEquiv :
    (DualNumber A ⧸ Ideal.span {(ε : DualNumber A)}) ≃+* A :=
  (Ideal.quotEquivOfEq ker_fstRingHom.symm).trans
    (RingHom.quotientKerEquivOfSurjective fstRingHom_surjective)