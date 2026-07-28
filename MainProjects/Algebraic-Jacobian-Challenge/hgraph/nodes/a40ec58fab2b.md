---
author: sync
content_type: structure
created: '2026-07-28T15:48:27'
decl: is
file: AlgebraicJacobian/Albanese/SymPowInterface.lean
generated: lean
lean_status: lean_ok
title: is
type: lean
updated: '2026-07-28T16:32:59'
---
structure is nearly free, and exhibiting *some* `SymPowData` proves nothing.

What the downstream theorems actually quantify over is the **pair**
`(D, hproj)`, where `hproj : ∀ σ, permAut C σ ≫ D.proj = D.proj` says the projection
is genuinely symmetric. The `proj := 𝟙` trick fails that for `n ≥ 2` (it would need
`permAut C σ = 𝟙`). So the pair is the meaningful object, and this file witnesses it
for `n = 1`: `symPowDataOne` plus `symPowDataOne_proj_perm`.

Two honest caveats about that witness:

* `n = 1` is the case where the *interesting* step degenerates. The forward direction
  of the connector (`Albanese/AlbaneseFromData.lean`) uses that `ψ` is a homomorphism
  to move it through a `g`-fold product; a 1-fold product has one factor, so at
  `n = 1` that step is mere associativity. The general-`n` theorem is the real one —
  do not cite `n = 1` as evidence that the group law is exercised.
* Consequently, "the interface is inhabited" should be read as *the hypotheses are
  consistent and the statements are not about nothing*, not as *the hard case is
  covered*.

## What is *not* here

`SymPowData C n` for `n ≥ 2`. That is the missing quotient, and it is the honest
boundary of this leg. See `Albanese/AlbaneseFromData.lean` for the Albanese
universal property proved over this interface, and the header of
`Albanese/AlbaneseUP.lean` for the pinned statements.

## References

Milne, *Abelian Varieties*, §III.3 Proposition 3.1 (the symmetric power) and §III.6
Proposition 6.1, p. 104; blueprint `def:symmetric_power_curve` and
`lem:symmetric_product_av_map` in `blueprint/src/chapters/Albanese_AlbaneseUP.tex`.
-/

set_option autoImplicit false

universe v u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace CategoryTheory

variable {K : Type u} [Category.{v} K] [CartesianMonoidalCategory K] [HasFiniteProducts K]

/-! ## §1. The interface

`SymPowData C n` is exactly the data Milne's proof uses: a scheme, a symmetrisation
projection from `C^n`, and the universal property for `S_n`-symmetric morphisms. The
symmetry hypothesis is phrased with `MonObj.permAut` (`Albanese/GrpObjFoldSum.lean`),
the factor-permuting automorphism of `C^n`. -/