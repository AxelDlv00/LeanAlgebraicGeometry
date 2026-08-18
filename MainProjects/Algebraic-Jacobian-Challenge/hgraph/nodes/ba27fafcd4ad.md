---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.orbit
docstring: The `Γ`-orbit of a point of `X` under a semilinear action.
file: AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.orbit
type: lean
updated: '2026-08-18T20:52:04'
---
def orbit (ρ : SemilinearGalAction K L X f) (x : X) : Set X :=
  Set.range fun γ : L ≃ₐ[K] L => (ρ.act γ).hom.base x