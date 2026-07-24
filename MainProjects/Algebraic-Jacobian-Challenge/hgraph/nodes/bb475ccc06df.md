---
author: sync
content_type: structure
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Adelic.at
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.at
type: lean
updated: '2026-07-24T17:02:57'
---
structure at `P` identifies the latter with the residue field `κ(P)` (one
uniformizer step ⇒ one copy of `κ(P) = 𝒪_P/𝔪_P`), whose `k`-dimension is
`deg P = [κ(P) : k]`; hence `dim_k (Γ(U, 𝒪(D')) ⧸ Γ(U, 𝒪(D))) ≤ deg P`.  This
file supplies the **elementary (residue-field-free) core**: the single-point
subgroups, the local identity `Γ(U, 𝒪(D)) = Γ(U, 𝒪(D')) ⊓ orderGe P (-n)`, and
the resulting injection.  The residue-field identification of the target and the
numerical `[κ(P):k]` count is the DVR step layered on top. -/

section LocalStep

variable {X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X]