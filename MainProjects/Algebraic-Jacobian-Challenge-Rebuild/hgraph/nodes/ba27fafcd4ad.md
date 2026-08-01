---
author: sync
content_type: definition
created: '2026-08-01T13:18:07'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.orbit
docstring: The orbit of a point under a semilinear action.
file: AlgebraicJacobian/Descent/SemilinearAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.orbit
type: lean
updated: '2026-08-01T13:18:07'
---
def orbit (rho : SemilinearGalAction K L X f) (x : X) : Set X :=
  Set.range fun gamma : L ≃ₐ[K] L => (rho.act gamma).hom.base x