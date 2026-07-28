---
author: sync
content_type: theorem
created: '2026-07-28T15:48:27'
decl: is
file: AlgebraicJacobian/Albanese/AlbaneseJacobian.lean
generated: lean
lean_status: sorry
title: is
type: lean
updated: '2026-07-28T15:48:27'
---
theorem is **not** a closed result about the actual Jacobian, and must not be reported
as one. What it does establish is sharp and worth stating precisely:

> the Albanese *argument* is complete. Given the symmetric power, Milne III.6.1 holds
> for `Pic⁰_{C/k̄}` with no further input from this leg.

That is a different claim from `albanese_universal_property` in
`Albanese/AlbaneseUP.lean`, which quantifies over a `sorry`-bodied `abelJacobi` and a
`sorry`-bodied `SymmetricPower` and therefore asserts nothing about either.

## References

Milne, *Abelian Varieties*, §III.6 Proposition 6.1, p. 104; §I.1 Corollaries 1.2 and
1.4. Blueprint `thm:albanese_universal_property`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open scoped CategoryTheory.MonObj

namespace AlgebraicGeometry

namespace Pic0

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]

variable (C : Over (Spec (.of kbar)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]