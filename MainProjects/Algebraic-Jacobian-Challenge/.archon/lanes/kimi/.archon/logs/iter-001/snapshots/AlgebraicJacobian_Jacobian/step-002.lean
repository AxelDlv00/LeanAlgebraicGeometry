/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus

/-!
# The Jacobian of a smooth proper curve

The Jacobian of a smooth, proper, geometrically irreducible curve over a field, equipped with
its structure as an abelian variety.

## Status (iteration 001 — discovery)

Mathlib b80f227 has **no Picard scheme, Picard functor, or `Pic⁰` construction
for schemes**: only `CommRing.Pic R` (Picard group of a commutative ring,
`Mathlib/RingTheory/PicardGroup.lean`) and the abstract `GrpObj` API exist.
There is also no formal `AbelianVariety` typeclass — abelian varieties are
encoded ad hoc by combining `[GrpObj] [IsProper] [GeometricallyIrreducible]`.

All five `sorry`s below (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`,
`instIsProper`, `instGeometricallyIrreducible`) are corollaries of a **single**
representability theorem that is missing from Mathlib:

> *(Pic-representable.)* For a smooth, proper, geometrically irreducible curve
> `C` over a field `k`, the étale-sheafified Picard functor of `C/k` is
> representable by a `k`-group scheme `Pic_{C/k}` whose connected component of
> the identity `Pic⁰_{C/k}` is a smooth, proper, geometrically irreducible
> abelian variety of relative dimension `genus C` over `Spec k`.

This is Phase C of `STRATEGY.md`. See `.archon/task_results/Jacobian.md` for
the per-`sorry` gap analysis, the proposed helper lemmas (with full Lean
signatures), and the search trail that confirms the absence of the API.

### Forbidden shortcut (sanity check)

Defining `Jacobian C := 𝟙_ (Over (Spec (.of k)))` (the terminal object,
i.e. `Spec k`) compiles and discharges three of the four instances for free:

* `instGrpObj` via `instTensorUnit : GrpObj (𝟙_ _)`,
* `instIsProper` since `𝟙 (Spec k)` is proper,
* `instGeometricallyIrreducible` since `Spec k` is geometrically irreducible.

But the fourth instance,
`SmoothOfRelativeDimension (genus C) (𝟙_ _).hom`, becomes
`SmoothOfRelativeDimension (genus C) (𝟙 (Spec (.of k)))`. The identity is smooth
of relative dimension `0`, so the only honest proof would force `genus C = 0`,
which is mathematically wrong for any curve of genus `≥ 1`. The terminal-object
definition is therefore forbidden by the plan-agent rules and not used here.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

-- data
/-- The Jacobian of a smooth, proper curve over a field `k`. -/
def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : Over (Spec (.of k)) :=
  -- Honest definition is `Pic⁰_{C/k}`, the connected component of the identity
  -- of the Picard scheme of `C` over `k`. Mathlib b80f227 has neither Picard
  -- scheme nor connected-component-of-identity API for group schemes; see
  -- `.archon/task_results/Jacobian.md` for helper-lemma proposals and Phase C
  -- of `STRATEGY.md` for the construction route. Discovery iteration 001
  -- leaves the sorry intentionally per `.archon/PROGRESS.md` (no constant
  -- placeholder, no axiom).
  sorry

namespace Jacobian

/-! ## The Jacobian of `C` is an abelian variety. -/

-- data
/-- The group scheme structure on the Jacobian of the curve `C`. -/
instance instGrpObj : GrpObj (Jacobian C) :=
  sorry

/-- The Jacobian of `C` is smooth of relative dimension `g` over `k`, where `g` is the
genus of `C`. -/
instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom :=
  sorry

/-- The Jacobian of `C` is proper over `k`. -/
instance instIsProper : IsProper (Jacobian C).hom :=
  sorry

/-- The Jacobian of `C` is geometrically irreducible over `k`. -/
instance instGeometricallyIrreducible : GeometricallyIrreducible (Jacobian C).hom :=
  sorry

end Jacobian

end AlgebraicGeometry
