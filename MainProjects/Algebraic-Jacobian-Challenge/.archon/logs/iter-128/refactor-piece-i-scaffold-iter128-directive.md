# Refactor Directive

## Slug
piece-i-scaffold-iter128

## Problem

The iter-128 META-PATTERN TRIPWIRE fires: per `progress-critic-iter127` and `progress-critic-iter128`, the project has had 3 consecutive plan-phase-only iters (iter-125 Rigidity refactor + iter-126 M1 excise + M2.a scaffold + iter-127 M2.b scaffold + over-k commitment) and iter-128 MUST land a prover lane on a fresh target or the meta-pattern flips to STUCK + user escalation.

The staged iter-128 prover target is piece (i.a) of the shared cotangent-vanishing pile per STRATEGY.md § M2.body-pile + `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i): sub-lemma decomposition for iter-128+ build" (iter-127 NEW). The blueprint's first lemma block is `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` (lines 90–116 of `RigidityKbar.tex` after iter-128 edits) — "the pullback along the identity section `η_G` of the relative cotangent presheaf is a finitely-generated free `k`-module".

**Per `strategy-critic-iter128` CHALLENGE and `progress-critic-iter128` Q2 verdict (borderline-too-ambitious)**, the iter-128 refactor must scaffold ONLY this one declaration `AlgebraicGeometry.GrpObj.lieAlgebra` in a new file. The rank lemma `AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim` is **deferred to iter-129+** for two reasons:
- The rank-lemma RHS Lean encoding needs explicit `n` parameterised by `[SmoothOfRelativeDimension n G.hom]` (the bare `dim G` has no canonical Lean function on `Over (Spec k)`); the iter-128 blueprint edits pin this encoding for iter-129's writer.
- Bundling definition + rank into a single iter-128 prover round is borderline-too-ambitious.

## Mathematical Justification

Let `k` be a field and `G : Over (Spec (.of k))` be a smooth proper geometrically irreducible group scheme over `k`, with identity section `η_G : 𝟙_ ⟶ G` (the `GrpObj.one` morphism in Mathlib's `GrpObj` API, pre-composed with the canonical isomorphism between `𝟙_ (Over (Spec (.of k)))` and the monoidal unit).

The Lie algebra of `G` (as a `k`-vector space; bracket structure not packaged this iter) is the `k`-linear dual of the cotangent at the identity:

  𝔤 := (𝔤^∨)^*  where  𝔤^∨ := η_G^* Ω_{G/k}

`Ω_{G/k}` is the relative cotangent — in this project, supplied via the existing utility `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf G.hom : G.left.PresheafOfModules` in `AlgebraicJacobian/Differentials.lean`. The pullback along `η_G` is, after evaluation at the global open of `Spec k`, a `k`-module.

Mathematical key fact (iter-129+ rank lemma; not in scope for the iter-128 refactor): for a smooth scheme of relative dimension `n` at a `k`-rational point, the cotangent space is a finitely-generated free `k`-module of rank `n`. The `k`-linear dual then has the same rank.

**The iter-128 refactor's scope is the definition only.** The body is `:= sorry` — the prover then constructs the actual `k`-module. The refactor MUST NOT attempt to write the construction itself.

## Changes Requested

### Create new file: `AlgebraicJacobian/Cotangent/GrpObj.lean`

(New file at this path. Note this is a NEW subdirectory `AlgebraicJacobian/Cotangent/`; create it as needed. `AlgebraicJacobian.lean` (the top-level aggregator) must be updated to `import AlgebraicJacobian.Cotangent.GrpObj` so the file is part of the build.)

File header:
```lean
/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Differentials

/-!
# Lie algebra of a group scheme at the identity

The Lie algebra of a smooth proper geometrically irreducible group scheme
`G` over a base field `k`, defined as a `k`-vector space, via the pullback
of the relative cotangent presheaf `Ω_{G/k}` along the identity section
`η_G : 𝟙_ ⟶ G`.

This is piece (i.a) of the shared cotangent-vanishing pile (see
`blueprint/src/chapters/RigidityKbar.tex` § "Piece (i): sub-lemma
decomposition for iter-128+ build" and STRATEGY.md § M2.body-pile).

The companion rank lemma `lieAlgebra_finrank_eq_dim` (rank = relative
dimension `n` from `[SmoothOfRelativeDimension n G.hom]`) is deferred
to iter-129+ for blueprint-RHS-pinning work; not in this file.

## Status (iter-128 scaffold)

The declaration `AlgebraicGeometry.GrpObj.lieAlgebra` is scaffolded with
a single `sorry` body. The iter-128 prover lane attempts the body
construction; iter-129+ resolves any fallback per the iter-129 fallback
rule in `.archon/iter/iter-128/plan.md`.

## References

- Blueprint chapter: `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i)".
- Project infrastructure consumed: `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf` (in `AlgebraicJacobian.Differentials`).
- Mathlib `GrpObj` API: `Mathlib.CategoryTheory.Monoidal.Grp_`,
  `Mathlib.AlgebraicGeometry.Group.Smooth`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry.GrpObj

variable {k : Type u} [Field k]

/-- The Lie algebra of a smooth proper geometrically irreducible group scheme
`G` over `k`, as a `k`-vector space (returned as `ModuleCat k`).

Mathematically: the `k`-linear dual of `η_G^* Ω_{G/k}`, the cotangent space
at the identity section. By smoothness of `G` at `η_G`, the cotangent space
is a finitely-generated free `k`-module; the dual inherits the same
structure.

The bracket / Lie-algebra structure on `lieAlgebra G` is NOT packaged here
— only the underlying `k`-module is needed for the rigidity argument.

**Status**: iter-128 scaffold — body is `sorry`. The iter-128 prover lane
attempts the construction. See `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i)". -/
noncomputable def lieAlgebra (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] [SmoothOfRelativeDimension 1 G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  sorry

end AlgebraicGeometry.GrpObj
```

Notes on the signature choices:
- `noncomputable def` because the construction routes through `Classical`/category-theoretic limits.
- Return type `ModuleCat k` (not a bare type-level `Module k _`) because the iter-129+ rank lemma will use Mathlib's `Module.finrank` API on the underlying type — `ModuleCat k` is the cleanest container that supplies the `Module.Free k _` / `Module.Finite k _` typeclasses automatically via `LinearEquiv` to the underlying additive group.
- `[CategoryTheory.GrpObj G]` is the categorical group structure on `G` (the namespace `CategoryTheory.GrpObj` exists in Mathlib `b80f227`'s `Mathlib.CategoryTheory.Monoidal.Grp_`). Plus the smooth/proper/irreducible bundle that matches the iter-126 `rigidity_over_kbar` scaffold's binder shape on `A`.
- The typeclass binder uses `SmoothOfRelativeDimension 1 G.hom` to fix the dimension (relative dim 1 group scheme = elliptic-curve-like; matches the iter-126 scaffold's expectation that `A` is the "abelian variety side" of the rigidity argument). **However, this fixed-dim-1 framing is preliminary; the actual blueprint encoding may need a generic `n` parameter in iter-129+.** For iter-128, dim 1 is the simplest concrete instance and gives the prover a focused target. If the prover finds dim-1 too restrictive (e.g. the construction is naturally dim-agnostic), it may relax to `[Smooth G.hom]` (no fixed dimension) in its own pass — this is a minor signature flexibility, NOT a re-scope.

### Update `AlgebraicJacobian.lean` (top-level aggregator)

Add the line:
```lean
import AlgebraicJacobian.Cotangent.GrpObj
```
in the existing import block (alphabetical-import-order if the file follows that convention; the existing imports are: AbelJacobi, Cohomology/*, Differentials, Genus, Jacobian, Rigidity, RigidityKbar — insert "Cotangent.GrpObj" alphabetically between "Cohomology/*" and "Differentials").

### NO changes to:
- `AlgebraicJacobian/Jacobian.lean` (the `genusZeroWitness` scaffold + `nonempty_jacobianWitness` stay sorry; not closed by this iter's refactor).
- `AlgebraicJacobian/RigidityKbar.lean` (the `rigidity_over_kbar` scaffold stays as is; rename to `rigidity_over_k` is deferred to iter-129+).
- `AlgebraicJacobian/Differentials.lean` (the existing `relativeDifferentialsPresheaf` is consumed; no modifications needed).
- `archon-protected.yaml` (no protected declarations are touched by this refactor; the new `lieAlgebra` is a non-protected leaf scaffold).

## Affected Files

- **NEW**: `AlgebraicJacobian/Cotangent/GrpObj.lean` (new file)
- **MODIFIED**: `AlgebraicJacobian.lean` (1 new import line)

No cascading breakage expected. The new declaration is added with `sorry` body; the existing project compiles unchanged (no consumer of `lieAlgebra` yet).

## Expected Outcome

After this refactor:
- Project sorry count: 3 → 4 (`+1` for `lieAlgebra` body).
- Project compiles with `lake build`.
- `lean_verify AlgebraicGeometry.GrpObj.lieAlgebra` returns kernel + sorryAx (clean — no new named axioms).
- The new file is part of the build via the top-level aggregator.

Per-file sorry distribution at close of refactor:
- `Jacobian.lean`: 2 (L174 `genusZeroWitness` iter-127 scaffold + L194 `nonempty_jacobianWitness` off-limits).
- `RigidityKbar.lean`: 1 (L87 `rigidity_over_kbar` iter-126 scaffold).
- `Cotangent/GrpObj.lean`: 1 (NEW iter-128 `lieAlgebra` scaffold).
- All others: 0.

## What NOT to do

- Do NOT add `lieAlgebra_finrank_eq_dim` (the rank lemma) — it is iter-129+ work.
- Do NOT touch `RigidityKbar.lean` (the rename `rigidity_over_kbar → rigidity_over_k` is iter-129+ cleanup).
- Do NOT add any other piece-(i.b) or piece-(i.c) sub-lemmas — those are downstream of (i.a).
- Do NOT modify the blueprint chapters (`RigidityKbar.tex`, etc.) — the plan agent already updated them this iter for the Lean encoding pin.
- Do NOT delete the orphan chapters `Modules_Monoidal.tex` / `Picard_*.tex` (per blueprint-reviewer's "soon" recommendation) — deferred to iter-129+.
- Do NOT attempt to fill the `sorry` body of `lieAlgebra` — that is the iter-128 prover's job.
- Do NOT introduce any new axioms.
