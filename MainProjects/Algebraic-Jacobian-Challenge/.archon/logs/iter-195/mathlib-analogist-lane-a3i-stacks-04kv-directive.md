# Directive — mathlib-analogist `lane-a3i-stacks-04kv`

## Mode

`api-alignment` (with `cross-domain-inspiration` if no direct
Mathlib alignment exists).

## Question

Lane A.3.i (`AlgebraicJacobian/Picard/IdentityComponent.lean`) needs
to close `geometricallyConnected_of_connected_of_section` — the
iter-194 plan-phase elevated this to a first-class blueprint lemma
under `chapters/Picard_IdentityComponent.tex`:

> **Stacks 037Q iff-direction**: a scheme `X` is geometrically
> connected over a field `k` iff `X` is connected AND the algebraic
> closure of `k` in `Γ(X, O_X)` equals `k`.

Iter-194 prover restructured the body of
`geometricallyConnected_of_connected_of_section` to expose a precise
gap: `ConnectedSpace ↥(pullback ...)`. The progress-critic iter-195
labels Lane A.3.i CHURNING-regressive (sorry count 5 → 7 → 8 → 9; net
+4 over the 4-iter window; helpers added each iter without any
sorry-elimination). The verdict explicitly names Stacks 04KV +
field-tensor-product Mathlib gaps.

## What I want from you

1. **Does Mathlib have the iff-direction of Stacks 037Q?** Search for:
   - `Algebra.IsAlgClosure.closure_eq_iff_geometricallyConnected`
     (hypothetical name).
   - `GeometricallyConnected.of_connected_of_section`.
   - `IsGeometricallyConnected.of_connected_isAlgClosed_eq_bot`.
   - Patterns around `Algebra.IsAlgClosed.equalIfClosure` etc.
   - `lean_loogle` for `GeometricallyConnected` / `IsAlgClosed` /
     `Γ(X, O_X)` interactions.

2. **If Mathlib has it**: write the `\lean{<mathlib name>}` pin the
   blueprint should use, and the corresponding consumer-site usage
   in `IdentityComponent.lean`. Estimated LOC: ~0-10 (re-export
   shim).

3. **If Mathlib does NOT have it directly but has the Stacks 04KV
   substrate** (`X` connected + `Γ(X, O_X) = k` ⟹ geometrically
   connected, special-case): identify the substrate + the missing
   gap. Provide a project-side build estimate (LOC + iter cost).

4. **If neither (a) nor (b)**: cross-domain-inspiration — find the
   structurally analogous result in Mathlib (e.g.
   `IsConnected ↔ all sections are constant` in topology; or
   `IsIrreducible ↔ ...` in commutative algebra). Suggest a port.

## Iter-194 task result context (verbatim quote)

The iter-194 prover task result for IdentityComponent.lean said
(paraphrased for brevity):

> Body restructure of `geometricallyConnected_of_connected_of_section`
> reducing to precise Stacks 04KV gap surface. Specifically the
> remaining surface is `ConnectedSpace ↥(pullback ...)` for the
> base-change pullback of `X` to `Spec K̄` along the algebraic
> closure injection `k ↪ K̄`. Plus a field-tensor-product criterion:
> the algebraic closure of `k` in `Γ(X, O_X)` equals `k` iff some
> tensor-product-criterion-flavored statement holds.

The iter-194 plan-phase chapter elevation landed the iff-direction
as `lem:geometricallyConnected_of_connected_of_section` in
`chapters/Picard_IdentityComponent.tex`. The proof obligation is
documented but the project-side build is the gap.

## Project file path

`AlgebraicJacobian/Picard/IdentityComponent.lean` — read the
`geometricallyConnected_of_connected_of_section` declaration body
(plan agent will run `grep -n "geometricallyConnected_of_connected_of_section"
AlgebraicJacobian/Picard/IdentityComponent.lean` for the line range
if needed). The chapter at
`blueprint/src/chapters/Picard_IdentityComponent.tex` documents the
exact lemma signature.

## Search guidance

Use `lean_local_search` + `lean_leansearch` + `lean_loogle` in
parallel. Try queries like:

- `GeometricallyConnected`
- `IsAlgClosed_eq_bot_iff_geometricallyConnected`
- `ConnectedSpace iff section`
- `IsClosed.subalgebra_eq_bot_iff`

Also check the existing project file
`AlgebraicJacobian/Picard/IdentityComponent.lean` for any
pre-existing partial substrate (the iter-194 prover added 4-6
helpers).

## What you should NOT do

- Do NOT try to close the project sorry yourself.
- Do NOT recommend the iter-200 sweep as the corrective — this
  consult IS the iter-200 sweep's purpose, just dispatched 5 iters
  early.

## Output

Standard `analogies/lane-a3i-stacks-04kv.md` plus task_results
report. The plan agent will use the analogies file to either
(a) re-dispatch Lane A.3.i iter-196 with a concrete project-side
build directive, or (b) park Lane A.3.i pending a Mathlib upstream
contribution, or (c) USER-escalate.
