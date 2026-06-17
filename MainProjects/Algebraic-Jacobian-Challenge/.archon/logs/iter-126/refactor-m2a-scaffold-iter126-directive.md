# Refactor Directive

## Slug
m2a-scaffold-iter126

## Problem

The M2.a sub-step of the genus-0 Albanese-witness argument requires a
named project Lean declaration `AlgebraicGeometry.rigidity_over_kbar`
that, when finally closed (iter-149+), gives: "every morphism from
$\mathbb P^1_{\bar k}$ to a smooth proper geometrically irreducible
group scheme $A_{\bar k}$ over the algebraic closure $\bar k$ that hits
the identity at a $\bar k$-rational point is the constant morphism at
the identity".

Iter-126 is the M2.a SCAFFOLD step (per STRATEGY.md § Sequencing): the
plan agent has rewritten STRATEGY.md per the iter-125 strategy-critic's
CHALLENGE — the iter-126 deliverable is to introduce the named
declaration with a `sorry` body, NOT to close the body. The body closure
is gated on the shared cotangent-vanishing Mathlib pile (10–20 iter /
800–1500 LOC of work upstream), targeted iter-129+ after the iter-126
mathlib-analogist consult lands its scoping.

The blueprint chapter `RigidityKbar.tex` (new iter-126, plan-agent
inline) documents the named declaration's statement, proof
decomposition, and the four-piece shared cotangent-vanishing pile that
gates the body closure.

## Mathematical Justification

The named declaration's statement (per `RigidityKbar.tex` § Statement,
labeled `thm:rigidity_over_kbar`):

> Let $\bar k$ be a field. Let $A : \mathrm{Over}\,(\Spec \bar k)$ be
> a smooth proper geometrically irreducible group scheme over $\bar
> k$. Let $f \colon \mathbb P^1_{\bar k} \to A$ be a morphism over
> $\Spec \bar k$, and let $p \in \mathbb P^1_{\bar k}(\bar k)$ be a
> $\bar k$-rational point such that $f(p) = \eta_A$. Then $f$ equals
> the constant morphism at $\eta_A$.

This is Mumford's Chapter~II~§4 classical rigidity result. The proof
decomposition (per `RigidityKbar.tex` § Proof decomposition):

- **(C.2.b)** Reduction to `Scheme.Over.ext_of_eqOnOpen` (the project's
  iter-125-refactored scheme-level rigidity).
- **(C.2.c)** Image-dimension dichotomy: image is a point (trivial) or
  image is one-dimensional (ruled out by C.2.d).
- **(C.2.d)** Keystone: proper rational curves on an abelian variety
  are constant. Mathlib gap; gated on the shared cotangent-vanishing
  pile.
- **(C.2.e)** Promote set-level equality to scheme-morphism equality.
  Integrated into the C.2.b application.

The iter-126 refactor lands ONLY the scaffold:

- A new file `AlgebraicJacobian/RigidityKbar.lean`.
- The named declaration `AlgebraicGeometry.rigidity_over_kbar` with the
  signature below and a single `sorry` body.

The body closure (C.2.b + C.2.c + C.2.d application) is iter-149+ work
after the shared cotangent-vanishing pile lands.

## Changes Requested

### Change 1: New file `AlgebraicJacobian/RigidityKbar.lean`

Create the new file with the following exact content:

```lean
/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Rigidity

/-!
# Rigidity over `k̄`: morphisms `ℙ¹_{k̄} → A_{k̄}` are constant

The keystone classical input for the M2.a sub-step of the genus-0
Albanese-witness argument (Jacobian.tex § C.2): morphisms from the
projective line `ℙ¹_{k̄}` to a smooth proper geometrically irreducible
group scheme `A_{k̄}` over an algebraically closed field `k̄` that hit
the identity at a `k̄`-rational point are the constant morphism at the
identity. Mumford, *Abelian Varieties*, Chapter~II~§4.

See `blueprint/src/chapters/RigidityKbar.tex`.

## Status (iter-126 scaffold)

The named declaration `rigidity_over_kbar` is scaffolded with a single
`sorry` body. The body closure is gated on the shared cotangent-
vanishing Mathlib pile (`analogies/cotangent-vanishing-pile.md`,
iter-129+) per STRATEGY.md § M2.a + § M2.d-alt. The proof decomposition
into sub-steps C.2.b (reduction to `Scheme.Over.ext_of_eqOnOpen`),
C.2.c (image-dimension dichotomy), C.2.d (the cotangent-vanishing
keystone), and C.2.e (set-to-scheme promotion) is documented in
`RigidityKbar.tex` § "Proof decomposition".
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

variable {kbar : Type u} [Field kbar]

/-- Rigidity for morphisms `ℙ¹_{k̄} → A_{k̄}`: every morphism from the
projective line over an algebraically closed field `k̄` to a smooth
proper geometrically irreducible group scheme `A` over `k̄` that hits
the identity at a `k̄`-rational point is the constant morphism at the
identity.

This is the keystone classical input for the M2.a sub-step of the
genus-0 Albanese-witness argument. Mumford, *Abelian Varieties*,
Chapter~II~§4.

**Status**: iter-126 scaffold — body is a single `sorry`. The closure
(C.2.b reduction via `Scheme.Over.ext_of_eqOnOpen` + C.2.c image-
dimension dichotomy + C.2.d cotangent-vanishing keystone) is gated on
the shared cotangent-vanishing Mathlib pile (iter-129+). See
`blueprint/src/chapters/RigidityKbar.tex`. -/
theorem rigidity_over_kbar
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : (Over.mk (Spec.map (CommRingCat.ofHom (MvPolynomial.C (R := kbar))))
            : Over (Spec (.of kbar))) ⟶ A)
    (p : 𝟙_ (Over (Spec (.of kbar))) ⟶
          (Over.mk (Spec.map (CommRingCat.ofHom (MvPolynomial.C (R := kbar))))
            : Over (Spec (.of kbar))))
    (_hf : p ≫ f = η[A]) :
    f = (CartesianMonoidalCategory.toUnit _ ≫ η[A]) :=
  sorry

end AlgebraicGeometry
```

**IMPORTANT NOTE FOR THE REFACTOR AGENT**: the exact signature of
`rigidity_over_kbar` above is a SCAFFOLD. The plan-agent recognises
that the `ℙ¹_{k̄}` source object encoded as `Over.mk (Spec.map …)` may
not be the cleanest way to encode the projective line over `k̄` in
Mathlib b80f227. The refactor agent SHOULD search for the canonical
Mathlib name for `ℙ¹` (e.g. `Projectivization`, `ProjectiveSpace`,
`AlgebraicGeometry.ProjectiveSpace`, etc.) and substitute the correct
Lean encoding. If no canonical name is found:

- Option A: use a placeholder `def ℙ¹ : Over (Spec (.of kbar)) := sorry`
  at the top of the file with a separate scaffold sorry. This makes the
  `rigidity_over_kbar` body sorry compose with the placeholder, but
  still scaffolds the M2.a target.
- Option B: state the theorem more abstractly: replace `ℙ¹_{k̄}` with
  "a smooth proper geometrically integral $k$-scheme of dimension 1
  with $H^1(\cdot, \mathcal O) = 0$". This is more general but
  matches what C.2.c–C.2.d actually need.

PICK ONE OPTION; favor Option B if Mathlib's `ProjectiveSpace` API is
not directly applicable. Document the choice in the file's docstring
and in your refactor report so the plan-agent can update
`RigidityKbar.tex` accordingly.

ALSO: the `η[A]` notation (the identity of the group object) may or
may not need explicit imports. Use `MonObj.η` if `η[A]` doesn't elab.
Verify with `lean_diagnostic_messages` after the file is created.

### Change 2: Update `AlgebraicJacobian.lean` (the umbrella module)

If `AlgebraicJacobian.lean` currently imports `AlgebraicJacobian.Rigidity`,
add a new import line for `AlgebraicJacobian.RigidityKbar` so the
umbrella picks up the new file:

```lean
import AlgebraicJacobian.RigidityKbar
```

If the umbrella does NOT have explicit per-module imports (e.g. uses
glob-style imports or import-all conventions), no umbrella edit is
needed.

## Affected Files

- `AlgebraicJacobian/RigidityKbar.lean` — NEW file
- `AlgebraicJacobian.lean` — POTENTIALLY (check + update if needed)

No other Lean file should require modification; the new declaration
is self-contained and not consumed by any existing declaration this
iter. The downstream consumer is iter-127's M2.b scaffold; that lands
next iter.

## Expected Outcome

After the refactor:

- Project sorry count: 2 → 3 (one new scaffold sorry on
  `rigidity_over_kbar`).
- New file `AlgebraicJacobian/RigidityKbar.lean` compiles cleanly with
  exactly one `sorry` (in the body of `rigidity_over_kbar`).
- No new axioms introduced (the file ships with kernel-only axioms +
  one `sorryAx` on the new declaration).
- `lean_diagnostic_messages` on `AlgebraicJacobian/RigidityKbar.lean`
  returns only the expected "declaration uses sorry" warning, no
  errors.
- Blueprint chapter `RigidityKbar.tex` and the `\lean{...}` reference
  to `AlgebraicGeometry.rigidity_over_kbar` are now matched in the
  Lean tree (the chapter was landed iter-126 plan-phase).

Verify: `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/ --format=summary`
should report 3 total sorries (was 2).

`archon-protected.yaml` is unchanged.

## Notes for Plan Agent

Anything you find that the plan agent should know:
- If the `ℙ¹_{k̄}` encoding is non-trivial, document the choice (Option
  A or B above or another approach you took); the plan agent will
  update `RigidityKbar.tex` to match next iter.
- If `MonObj.η` / `η[A]` notation requires additional imports beyond
  `AlgebraicJacobian.Rigidity`, list them so the plan agent can
  cross-check with `Jacobian.lean`'s imports (which already use this
  notation).
- If you find the existing `Jacobian.lean` already exports a useful
  encoding of `ℙ¹_{k̄}` (e.g. inside the proof of `IsAlbanese.unique`
  or similar), reuse it.
