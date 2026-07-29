---
author: sync
content_type: instance
created: '2026-07-21T21:31:58'
decl: Submodule.directedSystem_directedQuotientMap
file: AlgebraicJacobian/Algebra/DirectLimitQuotient.lean
generated: lean
lean_status: lean_ok
stale: true
title: Submodule.directedSystem_directedQuotientMap
type: lean
updated: '2026-07-29T15:26:13'
---
noncomputable instance directedSystem_directedQuotientMap
    (N : ι → Submodule R M) (hN : Monotone N) :
    DirectedSystem (fun i ↦ M ⧸ N i) (directedQuotientMap N hN · · ·) where
  map_self _ x := by
    induction x using Submodule.Quotient.induction_on with
    | _ x => exact directedQuotientMap_mk N hN _ _ _ x
  map_map _ _ _ hij hjk x := by
    induction x using Submodule.Quotient.induction_on with
    | _ x =>
      rw [directedQuotientMap_mk, directedQuotientMap_mk,
        directedQuotientMap_mk]

section Directed

variable [DecidableEq ι] [Nonempty ι] [IsDirectedOrder ι]