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
updated: '2026-07-29T05:40:32'
---
structure is nearly free, and exhibiting *some* `SymPowData` proves nothing.

What the downstream theorems actually quantify over is the **pair**
`(D, hproj)`, where `hproj : ∀ σ, permAut C σ ≫ D.proj = D.proj` says the projection
is genuinely symmetric. The `proj := 𝟙` trick fails that whenever `permAut C σ ≠ 𝟙`, which
for `n ≥ 2` holds as soon as `C` has two distinct global points — the case of interest, and
proved in `Albanese/SymPowColimit.lean` (`permAut_swap_ne_id_of_points`). It is *not*
automatic from `n ≥ 2` alone: at a **terminal** `C` the trivial datum does satisfy `hproj`
at every `n` (`permAut_eq_id_of_isTerminal`), so an unqualified "fails for `n ≥ 2`" is
false. So the pair is the meaningful object away from that degenerate case, and this file
witnesses it for `n = 1`: `symPowDataOne` plus `symPowDataOne_proj_perm`.

Two honest caveats about that witness:

* `n = 1` is the case where the *interesting* step degenerates. The forward direction
  of the connector (`Albanese/AlbaneseFromData.lean`) uses that `ψ` is a homomorphism
  to move it through a `g`-fold product; a 1-fold product has one factor, so at
  `n = 1` that step is mere associativity. The general-`n` theorem is the real one —
  do not cite `n = 1` as evidence that the group law is exercised.
* Consequently, "the interface is inhabited" should be read as *the hypotheses are
  consistent and the statements are not about nothing*, not as *the hard case is
  covered*.

## What is *not* here — but see `Albanese/SymPowColimit.lean` first

**This section is superseded in part (2026-07-28).** It said `SymPowData C n` for `n ≥ 2`
is "the missing quotient", the honest boundary of the leg. That reading was tied to one
presentation of the object — Milne's affine-and-glue construction — and
`Albanese/SymPowColimit.lean` replaces it:

* the pair `(D, hproj)` **is** a colimit of the `S_n`-action on `C^n`, in both directions
  (`symPowOfColimit`, `SymPowData.isColimit`, and `hasColimit_permDiagram_iff` for the
  equivalence, so the identification loses nothing);
* consequently `hproj` — the half that only `n = 1` witnessed here — is `colimit.w`, free
  at every `n`;
* and the **affine algebra** case is *inhabited* at every `n`
  (`symPowData_affineAlgebra`, in `(Under k)ᵒᵖ`), with no construction written. Note the
  careful wording: that is the inhabitation statement, not a formalisation of Milne III.3
  Proposition 3.1's affine half — identifying the carrier as `Spec (A^{⊗n})^{S_n}` is
  expected but **not proved**. See that file's §5 header.

What is genuinely still missing is the **gluing**, as `HasColimit (permDiagram C n)` for the
curve at hand. So the boundary moved from a construction subproject to one instance about
one named diagram. (State it per-diagram, not as `HasColimitsOfShape … Scheme`: the
quantified form is strictly stronger and believed false at this pin.)

Also note the warning above is now *checked* rather than asserted: `permAut_swap_ne_id`
exhibits `permAut ≠ 𝟙` at a transposition (in `Type`, at `Bool`, `n = 2`), so
`symPowDataTrivial` demonstrably fails `hproj`. Nothing in this tree had verified that.

See `Albanese/AlbaneseFromData.lean` for the Albanese universal property proved over this
interface, `Albanese/AlbaneseFromColimit.lean` for the same statement with no `SymPowData`
argument at all, and the header of `Albanese/AlbaneseUP.lean` for the pinned statements.

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