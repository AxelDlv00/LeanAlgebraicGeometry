---
author: sync
content_type: lemma
created: '2026-07-21T23:32:10'
decl: Module.MatrixPresentation.relMatrix_mem_entryIdeal
file: AlgebraicJacobian/Picard/EntryIdeal.lean
generated: lean
lean_status: lean_ok
title: Module.MatrixPresentation.relMatrix_mem_entryIdeal
type: lean
updated: '2026-07-21T23:32:10'
---
lemma relMatrix_mem_entryIdeal (P : MatrixPresentation R M e m)
    (i : Fin e) (j : Fin m) : P.relMatrix i j ∈ P.entryIdeal :=
  entryIdeal_le_iff.mp le_rfl i j

section BaseChange

variable (A : Type u') [CommRing A] [Algebra R A]