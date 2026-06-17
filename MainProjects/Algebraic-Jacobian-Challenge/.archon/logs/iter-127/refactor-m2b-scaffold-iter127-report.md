# Refactor Report

## Slug
m2b-scaffold-iter127

## Status
COMPLETE

## Directive

### Problem (paraphrased)
The genus-stratified body of `nonempty_jacobianWitness` (per STRATEGY.md § Decomposition + § M2) requires a named `genusZeroWitness` builder. Iter-127 was committed to scaffold this builder as a project declaration in `Jacobian.lean`, with a `sorry` body whose closure is gated on the iter-129+ shared cotangent-vanishing pile (specifically, the `isAlbaneseFor` field's substantive content via `rigidity_over_kbar`). Pure scaffold refactor; no prover work.

### Changes Requested (paraphrased)
- Option A (preferred): add a single `noncomputable def genusZeroWitness ... : JacobianWitness C := sorry` declaration to `AlgebraicJacobian/Jacobian.lean` between the `JacobianWitness` structure and `nonempty_jacobianWitness`.
- Option B (granular field-level scaffold) only if it lands in <30 min.
- File: extend `Jacobian.lean` (no new file).
- No import additions needed for Option A.
- No protected-file updates needed (new declaration is non-protected).

## Changes Made

### File: `AlgebraicJacobian/Jacobian.lean`
- **What:** Inserted the `genusZeroWitness` noncomputable definition with `sorry` body between the `JacobianWitness` structure (ends pre-edit line 160) and the `nonempty_jacobianWitness` theorem (pre-edit line 176). Added a doc-string covering: the underlying scheme is `Spec k` (terminal), the trivial group structure, smoothness of relative dimension `0` (matched by `h : genus C = 0`), properness, geometric irreducibility, and the role of `rigidity_over_kbar` (M2.a) in the `isAlbaneseFor` field. Status note flags the scaffold as iter-127 work with closure gated on iter-138+ (pieces (i)+(ii)+(iii) of the shared cotangent-vanishing pile).
- **Why:** Provides the named API anchor required by the M2 decomposition of `nonempty_jacobianWitness`, so downstream M2 closure work (iter-129+) has a fixed target.
- **Cascading:** None. The declaration is a pure ADD; no existing declarations renamed, deleted, or re-signed. Downstream files (`AbelJacobi.lean`, `AlgebraicJacobian.lean` root module) compile unchanged.

Chose **Option A** (single `sorry` body) — preferred per directive; granular field-level scaffolding (Option B) would have required a typeclass-instance search for `GrpObj (𝟙_ _)` / `IsProper (𝟙 _)` / `Smooth (𝟙 _)` on the terminal of `Over (Spec (.of k))` that the directive itself flagged as uncertain, and the directive explicitly says not to over-invest.

### Files NOT changed
- `archon-protected.yaml`: unchanged (declaration is new and non-protected).
- Blueprint chapters: per directive, plan agent handles the informal cross-reference inline; refactor agent does not edit blueprint.
- `AlgebraicJacobian/RigidityKbar.lean`: not referenced (no import added; Option A does not need it).

## New Sorries Introduced
- `AlgebraicJacobian/Jacobian.lean:174` — `genusZeroWitness` body. Scaffold deliberately deferred; closure depends on the shared cotangent-vanishing pile (iter-129+) and `rigidity_over_kbar` (`AlgebraicJacobian/RigidityKbar.lean`).

Net sorry change: +1 (project total 2 → 3, as predicted in directive's Expected Outcome).

## Compilation Status

- `AlgebraicJacobian/Jacobian.lean`: compiles. Warnings (under `lake env lean`):
  - `Jacobian.lean:174:18: warning: declaration uses 'sorry'` — new `genusZeroWitness` (expected).
  - `Jacobian.lean:194:8: warning: declaration uses 'sorry'` — pre-existing `nonempty_jacobianWitness` (untouched).
- `AlgebraicJacobian/AbelJacobi.lean`: compiles, no output.
- `AlgebraicJacobian.lean` (root module): compiles, no output.

## Verification
- `lean_verify AlgebraicGeometry.genusZeroWitness` → axioms `[propext, sorryAx, Classical.choice, Quot.sound]` (expected: kernel-only + `sorryAx`).
- `lean_verify AlgebraicGeometry.Jacobian` → axioms `[propext, sorryAx, Classical.choice, Quot.sound]` (unchanged from pre-edit).
- `lean_verify AlgebraicGeometry.IsAlbanese.unique` → axioms `[propext, Classical.choice, Quot.sound]` (no regression — fully proven, kernel-only).

No new axioms introduced.

## Notes for Plan Agent

- **Smooth landing.** No surprises; this was a textbook scaffold ADD.
- **`Spec k` interpretation note** (for the iter-138+ prover): the underlying scheme `J` of the witness must be the terminal object `𝟙_ (Over (Spec (.of k)))`. The directive's mathematical justification mentions that `geometricallyIrreducible_id_Spec` (already in `Jacobian.lean:120-126`) gives the `geomIrred` field after a terminal-characterization rewrite, but the actual definitional content `(𝟙_ _).hom = 𝟙 (Spec (.of k))` may need explicit translation; the prover should check whether the `CartesianMonoidalCategory` instance on `Over (Spec (.of k))` exposes this directly or requires a `Over.mk (𝟙 ...)` reconstruction.
- **No follow-up refactor needed.** The body-restructure of `nonempty_jacobianWitness` (to use `genusZeroWitness` in the `by_cases h : genus C = 0` branch) was explicitly excluded from this directive ("the body restructure (iter-150+) can reference it cleanly"); the named API is in place to receive that restructure when scheduled.
- **Pre-existing long-line warning** at `Jacobian.lean:217:101` (project-internal linter, surfaced by `lean_diagnostic_messages` but not by `lake env lean`) is on the `Jacobian` definition signature, untouched by this refactor. Not in scope.
- **Mathematical justification was sufficient** to guide the scaffold; no ambiguity required external lookup.
