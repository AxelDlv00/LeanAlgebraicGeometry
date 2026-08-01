---
author: sync
content_type: theorem
created: '2026-08-01T12:39:19'
decl: AlgebraicGeometry.Scheme.LocallyFreeQuotient.candidateQuotient_epi
docstring: The reconstructed Grassmannian quotient is epimorphic by construction.
file: AlgebraicJacobian/Picard/DivLocallyClosed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocallyFreeQuotient.candidateQuotient_epi
type: lean
updated: '2026-08-01T12:39:19'
---
theorem candidateQuotient_epi (L : X.Modules) {d : ℕ}
    (q : LocallyFreeQuotient ((Modules.pushforward π).obj L) d T) :
    Epi (candidateQuotient L q) := by
  dsimp only [candidateQuotient]
  infer_instance