---
author: sync
content_type: theorem
created: '2026-07-21T21:31:58'
decl: Submodule.directLimitQuotientEquivISup_apply_of_mk
file: AlgebraicJacobian/Algebra/DirectLimitQuotient.lean
generated: lean
lean_status: lean_ok
stale: true
title: Submodule.directLimitQuotientEquivISup_apply_of_mk
type: lean
updated: '2026-07-30T15:28:04'
---
theorem directLimitQuotientEquivISup_apply_of_mk
    (N : ι → Submodule R M) (hN : Monotone N) (i : ι) (x : M) :
    directLimitQuotientEquivISup N hN
        (Module.DirectLimit.of R ι _ (directedQuotientMap N hN) i
          (Submodule.Quotient.mk x)) =
      Submodule.Quotient.mk x :=
  directLimitQuotientToISup_of_mk N hN i x

end Directed

section FlatDirected

variable [Nonempty ι] [IsDirectedOrder ι]