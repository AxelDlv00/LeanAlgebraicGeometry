---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.openSectionsEquiv
docstring: 'The section ring of an open and the global sections of its open subscheme

  are canonically isomorphic.'
file: AlgebraicJacobian/Picard/FiniteMapProjectiveImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.openSectionsEquiv
type: lean
updated: '2026-07-31T02:29:39'
---
def openSectionsEquiv (U : C.left.Opens) :
    Γ(C.left, U) ≃+* Γ(U.toScheme, ⊤) :=
  (asIso (U.ι.appLE U ⊤ U.ι_preimage_self.ge)).commRingCatIsoToRingEquiv