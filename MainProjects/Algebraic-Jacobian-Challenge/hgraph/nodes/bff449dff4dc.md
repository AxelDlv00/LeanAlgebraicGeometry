---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.CechLocalized.sprod
docstring: '`s_σ = ∏ₖ s (σ k)`, the localising element for the multi-index `σ`.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.CechLocalized.sprod
type: lean
updated: '2026-07-24T03:02:09'
---
def sprod {m : ℕ} (σ : Fin m → ι) : R := ∏ k, s (σ k)