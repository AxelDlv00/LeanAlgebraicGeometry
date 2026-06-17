# Refactor Report

## Slug
piece-i-scaffold-iter128

## Status
COMPLETE

## Directive

### Problem (summary)
Iter-128 must land a prover lane on a fresh target or the meta-pattern flips
to STUCK + user escalation. The staged iter-128 prover target is piece (i.a)
of the shared cotangent-vanishing pile: scaffold the Lean declaration
`AlgebraicGeometry.GrpObj.lieAlgebra` in a new file
`AlgebraicJacobian/Cotangent/GrpObj.lean`. The rank lemma is deferred to
iter-129+ per `strategy-critic-iter128` + `progress-critic-iter128`.

### Changes (summary)
- NEW file: `AlgebraicJacobian/Cotangent/GrpObj.lean` (new subdirectory `Cotangent/`).
- MODIFIED: `AlgebraicJacobian.lean` — add 1 import line.
- No other files touched.

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean` (NEW)
- **What:** Created a new Lean file scaffolding `AlgebraicGeometry.GrpObj.lieAlgebra`
  as a `noncomputable def` returning `ModuleCat k`, with body `sorry`.
  Signature uses the binder shape pinned by the directive:
  `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] [SmoothOfRelativeDimension 1 G.hom]
   [IsProper G.hom] [GeometricallyIrreducible G.hom]`.
- **Why:** Per directive Mathematical Justification, this is the Lie algebra at
  the identity of `G`, scaffolded as `ModuleCat k` so the iter-129+ rank lemma can
  consume `Module.finrank`/`Module.Free`/`Module.Finite` typeclasses. Iter-128
  prover lane attempts the body construction (routing through the project's existing
  `relativeDifferentialsPresheaf` infrastructure).
- **Cascading:** None. The declaration is a fresh leaf; no existing consumer exists.

#### Header-import deviation (minor, documented)
The directive's reference file body imported only `AlgebraicJacobian.Differentials`.
That import chain does not transitively bring `IsProper`, `GeometricallyIrreducible`,
or `GrpObj` into scope (the `RigidityKbar.lean` file gets them transitively through
`AlgebraicJacobian.Rigidity → AlgebraicJacobian.Jacobian → AlgebraicJacobian.Genus`,
which does a top-level `import Mathlib`). To keep `Cotangent/GrpObj.lean` lean
(no monolithic `import Mathlib`) and have it actually compile, I added three
targeted Mathlib imports the directive itself names in the References section:

```
import Mathlib.AlgebraicGeometry.Group.Smooth        -- pulls in GrpObj, Smooth, SmoothOfRelativeDimension
import Mathlib.AlgebraicGeometry.Morphisms.Proper    -- IsProper
import Mathlib.AlgebraicGeometry.Geometrically.Irreducible  -- GeometricallyIrreducible
```

This is a purely additive change (no signature deviation; the declaration
matches the directive's source block character-for-character apart from these
three import lines). Documented here for the plan agent's awareness; it is
not a re-scope.

### File: `AlgebraicJacobian.lean`
- **What:** Added `import AlgebraicJacobian.Cotangent.GrpObj` between the
  `Cohomology/MayerVietorisCover` and `Differentials` imports (alphabetical
  insertion as directed).
- **Why:** Top-level aggregator must reference the new file so it is part of
  the build.
- **Cascading:** None.

### Files NOT modified (per directive)
- `AlgebraicJacobian/Jacobian.lean` — unchanged.
- `AlgebraicJacobian/RigidityKbar.lean` — unchanged.
- `AlgebraicJacobian/Differentials.lean` — unchanged.
- `archon-protected.yaml` — unchanged (no protected declarations touched).
- `blueprint/src/chapters/*.tex` — unchanged.

## New Sorries Introduced
- `AlgebraicJacobian/Cotangent/GrpObj.lean:67` — body of
  `AlgebraicGeometry.GrpObj.lieAlgebra`. The iter-128 prover lane attempts the
  construction; iter-129+ resolves any fallback per the plan-agent iter-129
  rule.

## Compilation Status
- `lake build` (`AlgebraicJacobian/AlgebraicJacobian:default`): **success** (8330/8330 jobs).
- `AlgebraicJacobian/Cotangent/GrpObj.lean`: compiles with one `sorry`-uses
  warning (line 67) — the expected scaffold warning.
- `AlgebraicJacobian.lean`: compiles cleanly.
- All other previously-compiling files: unchanged status.

### Sorry distribution at refactor close
- `Jacobian.lean`: 2 sorries (L174 `genusZeroWitness` iter-127 scaffold +
  L194 `nonempty_jacobianWitness` off-limits) — matches expected.
- `RigidityKbar.lean`: 1 sorry (L75-pointing warning for the iter-126
  `rigidity_over_kbar` scaffold whose `:= sorry` body sits at L87) —
  matches expected.
- `Cotangent/GrpObj.lean`: 1 sorry (NEW, L67 `lieAlgebra` scaffold).
- All others: 0.
- **Total: 4 sorries** (3 → 4, matches directive Expected Outcome).

### Axiom hygiene
`lean_verify AlgebraicGeometry.GrpObj.lieAlgebra` reports:
```
axioms = [propext, sorryAx, Classical.choice, Quot.sound]
warnings = []
```
Clean — only the expected `sorryAx` (because the body is `sorry`) plus the
three universal Mathlib axioms. **No new custom axioms.**

## Notes for Plan Agent

1. **Header imports note (above)** — directive's reference file body would not
   have compiled as-is because `IsProper`, `GeometricallyIrreducible`, and
   `GrpObj` are not in scope through `AlgebraicJacobian.Differentials` alone.
   Adding the three Mathlib-target imports the directive itself referenced in
   its "Mathlib `GrpObj` API" line is the minimal additive fix. If the plan
   agent prefers a heavier `import Mathlib` (as `Genus.lean` does), that's a
   stylistic choice that can be made in a later cleanup pass.

2. **Signature flexibility flag** — the directive's "fixed-dim-1 framing is
   preliminary" note still applies. The signature uses
   `[SmoothOfRelativeDimension 1 G.hom]`. If the iter-128 prover finds the
   construction is more natural at general `n` (or no fixed dim), the directive
   explicitly permits relaxing this binder. The refactor agent did NOT relax it
   pre-emptively — the directive said this was the prover's call.

3. **Variable name** — the file uses `k` (not `kbar`) for the base field
   variable, matching the directive's signature block and the iter-127 over-k
   commitment. The legacy `kbar` name in `RigidityKbar.lean` is flagged in
   the blueprint as a low-priority cleanup rename for iter-128+; not touched
   by this refactor (out of scope).

4. **Sorry hygiene** — the body of `lieAlgebra` is a plain `sorry` (no axiom,
   no extern). `lean_verify` confirms no new custom axioms entered the kernel.
   The iter-128 prover has a clean target.

5. **Suggested follow-up refactors** (NOT done, just flagged):
   - iter-129+: scaffold `lieAlgebra_finrank_eq_dim` once the blueprint pins
     the RHS encoding `Module.finrank k (lieAlgebra G) = n` with explicit
     `[SmoothOfRelativeDimension n G.hom]`. The current `lieAlgebra` signature
     uses fixed dim 1; the rank lemma will likely need the generalized form,
     which may motivate relaxing `lieAlgebra`'s binder to general `n` at the
     same time.
   - iter-129+: rename `rigidity_over_kbar → rigidity_over_k` in
     `RigidityKbar.lean` (out of scope here, per directive).
   - iter-129+: orphan-chapter cleanup (`Modules_Monoidal.tex`,
     `Picard_*.tex`) per blueprint-reviewer's "soon" recommendation.
