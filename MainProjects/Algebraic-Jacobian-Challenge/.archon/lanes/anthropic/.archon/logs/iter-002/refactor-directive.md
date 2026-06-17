<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-06T03:51:11Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iter 002

## Motivation

Iteration 001 (discovery) produced a verified Mathlib gap report (see `task_pending.md`). All nine protected sorries are blocked behind missing Mathlib infrastructure (Phases A, C, E of `STRATEGY.md`). The plan is to scaffold two new files holding **infrastructure helper declarations** that future prover iterations can attempt:

- **`AlgebraicJacobian/Rigidity.lean`** — Helper H1, the rigidity theorem for morphisms of group schemes (Mumford §4). It is the only sorry-blocking helper provable from current Mathlib alone, and unlocks the uniqueness half of `exists_unique_ofCurve_comp`.
- **`AlgebraicJacobian/Picard/LineBundle.lean`** — Phase B/C step 1: `Scheme.LineBundle`, the `CommGroup` instance, and the pull-back homomorphism. Smallest self-contained Phase C step; seeds Steps 2–6 of the Jacobian construction.

These files are **scaffold only**: every declaration is `sorry`. The refactor agent must not attempt proofs (per its prompt). Subsequent iterations of the prover agent will fill the sorries.

The plan agent has already added the corresponding blueprint chapters (`blueprint/src/chapters/Rigidity.tex` and `blueprint/src/chapters/Picard_LineBundle.tex`) and updated `blueprint/src/content.tex` with their `\input` directives.

## Justification (mathematical)

- **Rigidity.lean.** The blueprint's Theorem `thm:exists_unique_ofCurve_comp` (Albanese property) decomposes into existence (needs Phase B/C) and uniqueness (needs Phase E rigidity). Rigidity is a stand-alone abelian-variety lemma proved in any standard reference (Mumford, *Abelian Varieties*, §4 Theorem 1; or Stacks 0BFD as a proximate ingredient). Mathlib has the geometric pieces (smoothness, properness, separatedness, geometric irreducibility, group-object structure, and Stacks 0BFD itself) but not the assembled rigidity statement. Putting it in its own file keeps it independent of `Jacobian C` (which is itself blocked).
- **Picard/LineBundle.lean.** The blueprint's `def:Pic_functor` and `thm:Pic_representable` rest on the existence of the relative Picard group, which in turn rests on the absolute Picard group $\Pic(X)$ of a scheme. Mathlib has `CommRing.Pic R` (rings only) and `AlgebraicGeometry.Scheme.Modules` (sheaves of $\mathcal O_X$-modules). What is absent is the type of *invertible* such sheaves, the $\Pic(X)$ commutative-group structure under tensor product, and the pull-back homomorphism $f^* \colon \Pic(Y) \to \Pic(X)$. These three items are the smallest unit of progress on Phase C.

## Concrete refactor instructions

### 1. Create `AlgebraicJacobian/Rigidity.lean`

Path: `AlgebraicJacobian/Rigidity.lean`. Contents (illustrative; the refactor agent should adjust imports / namespaces / typeclass placeholders to whatever compiles cleanly with `sorry` bodies):

```lean
/-
Copyright (c) 2026 ... All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ...
-/
import AlgebraicJacobian.Jacobian

/-!
# Rigidity for morphisms of group schemes (Mumford §4)

A self-contained Phase E helper: a morphism between proper smooth geometrically
irreducible group schemes that agrees with another on a non-empty open subscheme
of the source agrees everywhere. Independent of `AlgebraicGeometry.Jacobian C`
and provable from current Mathlib alone (Stacks 0BFD plus standard
properness/separatedness/irreducibility lemmas).

See `blueprint/src/chapters/Rigidity.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {k : Type u} [Field k]

/-- Rigidity for morphisms of group schemes (Mumford §4 Theorem 1, symmetric form):
two morphisms between proper smooth geometrically irreducible group schemes that
agree on a non-empty open subset of the source agree everywhere.

The standard Mumford statement (a morphism vanishing on a non-empty open is zero)
is interderivable using the group law on the target. -/
theorem GrpObj.eq_of_eqOnOpen
    {n m : ℕ}
    {X Y : Over (Spec (.of k))}
    [SmoothOfRelativeDimension n X.hom] [IsProper X.hom]
    [GeometricallyIrreducible X.hom] [GrpObj X]
    [SmoothOfRelativeDimension m Y.hom] [IsProper Y.hom]
    [GeometricallyIrreducible Y.hom] [GrpObj Y]
    (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (h : ∀ x ∈ (U : Set X.left), g₁.left.base x = g₂.left.base x) :
    g₁ = g₂ :=
  sorry

end AlgebraicGeometry
```

Notes for the refactor agent:
- Adjust the `import` line to whatever transitively pulls in `Over (Spec (.of k))`, `SmoothOfRelativeDimension`, `IsProper`, `GeometricallyIrreducible`, `GrpObj`, `Scheme.Opens`, etc. Importing `AlgebraicJacobian.Jacobian` works because that file imports `AlgebraicJacobian.Genus` which imports `Mathlib`. If the refactor agent prefers a smaller import surface, `import Mathlib` is also acceptable; minimise only if the build time visibly improves.
- The exact form of the underlying-points hypothesis (`g₁.left.base x = g₂.left.base x`) may need to be tweaked once the actual `Scheme.Hom.base` API is consulted. Choose whatever spelling type-checks; record any deviations from the blueprint in `task_results/refactor.md`.
- Keep the namespace `AlgebraicGeometry`, then either nest under `GrpObj` (as above) or pick a new sub-namespace, but ensure the **fully qualified Lean name matches the `\lean{...}` macro in `Rigidity.tex`** (`AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`). If the name needs to change for any reason, also update the `\lean{...}` macro in the blueprint chapter.
- This declaration is **not** in `archon-protected.yaml` (it is a helper introduced by this iteration). The refactor agent has freedom to revise the signature if Mathlib idioms demand it; record any such revision in the refactor task result so the plan agent can update the blueprint accordingly.

### 2. Create `AlgebraicJacobian/Picard/LineBundle.lean`

Path: `AlgebraicJacobian/Picard/LineBundle.lean`. Create the directory `AlgebraicJacobian/Picard/` if it does not exist. Contents (illustrative):

```lean
/-
Copyright (c) 2026 ... All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ...
-/
import Mathlib

/-!
# Line bundles and the Picard group of a scheme

Phase B/C step 1 (per `STRATEGY.md`): the type of invertible quasi-coherent
sheaves on a scheme, the commutative-group structure under tensor product,
and pull-back functoriality.

See `blueprint/src/chapters/Picard_LineBundle.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry.Scheme

/-- A line bundle on a scheme: an invertible quasi-coherent `O_X`-module. -/
def LineBundle (X : Scheme.{u}) : Type _ := sorry

/-- Tensor product makes the type of line bundles a commutative group. -/
noncomputable instance instCommGroupLineBundle (X : Scheme.{u}) :
    CommGroup (LineBundle X) :=
  sorry

/-- The Picard group of a scheme: line bundles up to isomorphism. -/
def Pic (X : Scheme.{u}) : Type _ := LineBundle X

/-- Pull-back of line bundles along a scheme morphism, as a group homomorphism. -/
noncomputable def Pic.pullback {X Y : Scheme.{u}} (f : X ⟶ Y) :
    Pic Y →* Pic X :=
  sorry

end AlgebraicGeometry.Scheme
```

Notes for the refactor agent:
- The `LineBundle X` type might more naturally be a `Subtype` of `X.Modules` plus a quasi-coherence + invertibility predicate, but for the iter 002 scaffold, leaving it as `sorry` (an opaque type) is acceptable. Subsequent iterations will provide a concrete definition.
- The `CommGroup` instance is genuinely intricate (tensor unit / inverse via dual / functoriality). Leave the instance body as `sorry`; the prover will decompose into sub-lemmas in iter 003+.
- These declarations are **not** in `archon-protected.yaml`. Their names and signatures can be revised by future iterations if the Mathlib idiom demands.

### 3. Wire both new files into the umbrella import

Edit `AlgebraicJacobian.lean` to add:

```lean
import AlgebraicJacobian.Picard.LineBundle
import AlgebraicJacobian.Rigidity
```

Order: keep imports in dependency order. `Picard.LineBundle` does not depend on `Genus`/`Jacobian`/`AbelJacobi`, so it can come first. `Rigidity` depends only on `Jacobian` (for the typeclass surface on `Over (Spec (.of k))`), so place it after `Jacobian`. A clean ordering:

```lean
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Picard.LineBundle
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.Rigidity
import AlgebraicJacobian.AbelJacobi
```

### 4. Compilation requirement

After the refactor, `lake build` (or the per-file `lean_diagnostic_messages` check) must succeed on **every file in the project**, with only `sorry` warnings (no errors). The protected files (`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`) must continue to compile unchanged — the refactor must not modify the protected declarations or their signatures.

### 5. Constraints (recap)

- **Do not** modify the signatures listed in `archon-protected.yaml` (`AlgebraicGeometry.genus`, `AlgebraicGeometry.Jacobian`, `AlgebraicGeometry.Jacobian.instGrpObj`, `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus`, `AlgebraicGeometry.Jacobian.instIsProper`, `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible`, `AlgebraicGeometry.Jacobian.ofCurve`, `AlgebraicGeometry.Jacobian.comp_ofCurve`, `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp`).
- **Do not** introduce any `axiom` declaration.
- **Do not** fill any sorry — that is the prover's job.
- **Do not** delete the in-file documentation that iter 001 added to `Genus.lean` and `Jacobian.lean` (the discovery docstrings and per-sorry comments are reference material for future provers).
- **Do not** modify the existing blueprint chapters (`Genus.tex`, `Jacobian.tex`, `AbelJacobi.tex`); the plan agent has already updated `content.tex` and added the two new chapters.

## Reporting

Write `task_results/refactor.md` with:
1. The two new files actually created, with full path and any deviations from the templates above (e.g.\ different import set, different Lean signature for `eq_of_eqOnOpen`).
2. The result of `lean_diagnostic_messages` on each new file and on `AlgebraicJacobian.lean`.
3. Confirmation that no protected signature was touched.
4. Confirmation that no `axiom` was introduced.
5. If any name had to deviate from the blueprint `\lean{...}` macro, list it explicitly so the plan agent can update the chapter.
