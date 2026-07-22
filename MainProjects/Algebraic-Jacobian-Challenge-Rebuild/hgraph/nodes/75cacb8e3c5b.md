---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.overSpecSectionsAlgebraA
docstring: '`specSectionsAlgebra`, re-keyed on the `overSpec`-spelling of `Spec A`
  (scoped).'
file: AlgebraicJacobian/Picard/DescentSectionEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.overSpecSectionsAlgebraA
type: lean
updated: '2026-07-16T21:33:28'
---
@[reducible] noncomputable def overSpecSectionsAlgebraA (U : (SA).Opens) :
    Algebra A Γ(SA, U) :=
  specSectionsAlgebra A U

attribute [local instance] overSpecSectionsAlgebraA