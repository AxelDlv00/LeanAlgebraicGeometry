---
author: sync
content_type: definition
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.DivUniversalHighWindowFibreImage_at
docstring: 'At a carve-killing field point, the degree-`g` relative relation has the

  canonical divisor window for curve parameter `gamma ≤ g` as its image.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivUniversalHighWindowFibreImage_at
type: lean
updated: '2026-08-03T08:02:46'
---
def DivUniversalHighWindowFibreImage_at {gamma : Nat}
    (hgamma : gamma ≤ g)
    (hchiGamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (hkerGamma : divCarveIdeal k
        (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi)
        g r1 r2 b1 b2 i j ≤
          RingHom.ker (algebraMap (PairChartRing k g r1 g r2 i j) K))
    (n : Nat) : Prop :=
  Submodule.map
      (divUniversalHighWindowClosedAmbientFibreEquiv
        (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K n).toLinearMap
      (Kr[n].baseChange K) =
    divUniversalFibreHighWindowInAmbient_at
      C hpi g r1 r2 b1 b2 i j K hgamma hchiGamma hkerGamma n