---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.h0
docstring: '**`h⁰(M)` on the cover `S`**: the `k`-dimension of the kernel of the

  difference map (junk value `0` when infinite-dimensional; finiteness for

  general coherent `M` is a later P2 wave).'
file: AlgebraicJacobian/RiemannRoch/CohomologyKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.h0
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def AffineCoverMVSquare.h0 (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) : ℕ :=
  Module.finrank k (S.H0ₗ C M)