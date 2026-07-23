---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.specSemilinearGalAction_act
file: AlgebraicJacobian/Picard/FiniteGaloisQuotientAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.specSemilinearGalAction_act
type: lean
updated: '2026-07-24T03:02:10'
---
@[simp] lemma specSemilinearGalAction_act (γ : L ≃ₐ[K] L) :
    (specSemilinearGalAction K L A).act γ = toSpecAut (L ≃ₐ[K] L) A γ := rfl