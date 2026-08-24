---
author: sync
content_type: lemma
created: '2026-08-12T15:42:08'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.mem_invariantsSubalgebra
file: AlgebraicJacobian/Descent/SemilinearAlgebras.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.mem_invariantsSubalgebra
type: lean
updated: '2026-08-18T20:50:54'
---
@[simp] lemma mem_invariantsSubalgebra {a : A} :
    a ∈ invariantsSubalgebra K L A ↔ ∀ σ : L ≃ₐ[K] L, σ • a = a := Iff.rfl