---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.mem_invariantsSubalgebra
file: AlgebraicJacobian/Picard/GaloisDescent/SemilinearAlgebras.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.mem_invariantsSubalgebra
type: lean
updated: '2026-07-16T21:14:26'
---
@[simp] lemma mem_invariantsSubalgebra {a : A} :
    a ∈ invariantsSubalgebra K L A ↔ ∀ σ : L ≃ₐ[K] L, σ • a = a := Iff.rfl