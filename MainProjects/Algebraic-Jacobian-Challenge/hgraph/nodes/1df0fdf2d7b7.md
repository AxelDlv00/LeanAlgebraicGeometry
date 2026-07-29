---
author: sync
content_type: theorem
created: '2026-07-28T12:23:40'
decl: AlgebraicGeometry.Scheme.one_le_coheight_of_ne_genericPoint
docstring: '**A non-generic point has coheight at least one.** The elementary half
  of the converse of

  `Scheme.PrimeDivisor.point_ne_genericPoint`: a point that is not the generic point
  is not

  maximal in the specialisation order (the generic point strictly dominates it), and
  coheight

  `0` is equivalent to maximality.


  The *other* half — `coheight ≤ 1`, which is what upgrades this to `coheight = 1`
  and so

  produces a `Scheme.PrimeDivisor` — is genuinely about curves and is not available
  at this

  point in the import graph; see `Adelic.coheight_le_one_of_curve`.'
file: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.one_le_coheight_of_ne_genericPoint
type: lean
updated: '2026-07-29T18:21:39'
---
theorem Scheme.one_le_coheight_of_ne_genericPoint {X : Scheme.{u}} [IrreducibleSpace X]
    {x : X} (hx : x ≠ genericPoint X) : 1 ≤ Order.coheight x := by
  have hnotmax : ¬ IsMax x := fun hmax =>
    hx ((genericPoint_specializes x).antisymm (hmax (genericPoint_specializes x))).symm.eq
  exact Order.one_le_iff_ne_zero.mpr fun h => hnotmax (Order.coheight_eq_zero.mp h)

/-! ## Prime divisors and open immersions

The project-local lemma `Order.coheight_eq_of_isOpenEmbedding` lets us package
the following standard operations:
- `Scheme.PrimeDivisor.restrictToOpen` — given a prime divisor `Y` of `X` and
  `Y.point ∈ U`, the corresponding prime divisor of the open subscheme `U`.
- `Scheme.PrimeDivisor.ofOpen` — push a prime divisor of an open subscheme `U`
  back to a prime divisor of the ambient scheme `X`.
- `Scheme.PrimeDivisor.equivOpen` — the bijection
  `{ Y : X.PrimeDivisor // Y.point ∈ U } ≃ U.toScheme.PrimeDivisor`.
- `Scheme.PrimeDivisor.stalkIso` — the stalk identification along the
  open immersion `U.ι : U.toScheme ⟶ X`, a thin wrapper around Mathlib's
  `AlgebraicGeometry.Scheme.Opens.stalkIso`.

References: Stacks 02IZ (open-immersion stalks) and Stacks 005X (coheight and
Krull dimension on Noetherian schemes).
-/

namespace Scheme.PrimeDivisor

variable {X : Scheme.{u}}

/-- **Extensionality for `Scheme.PrimeDivisor`.** Two prime divisors with
the same underlying point are equal (the coheight witness is a `Prop`-valued
field, so it carries no data). Useful for the round-trip lemmas of the
`equivOpen` bijection below. -/
@[ext]