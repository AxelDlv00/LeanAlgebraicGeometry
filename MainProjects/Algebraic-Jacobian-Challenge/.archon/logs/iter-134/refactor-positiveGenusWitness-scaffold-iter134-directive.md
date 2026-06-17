# Refactor Directive

## Slug
positiveGenusWitness-scaffold-iter134

## Problem

The strategy file (`STRATEGY.md` § M3, line 213) names a planned scaffold lane:

> **`positiveGenusWitness` scaffold — SCHEDULED iter-133+** (per `strategy-critic-iter132` minor alternative). Introduce a stub `positiveGenusWitness C (hg : 0 < genus C)` declaration in `Jacobian.lean` with a `sorry` body, parallel to the iter-127 `genusZeroWitness` scaffold. Cost ~20–30 LOC. Effect: unblocks the genus-stratified body restructure precondition (the strategy says the body restructure happens "once `genusZeroWitness` AND `positiveGenusWitness` are at least scaffolded"; both arms are then scaffolded).

This was scheduled iter-133+ but slipped iter-133. The iter-134 strategy-critic
(`strategy-critic-iter134`, see `task_results/strategy-critic-iter134.md`) raised
this as a minor alternative (line 103–109) recommending immediate scaffolding to
avoid further silent slippage iter-by-iter. Per the iter-134 plan decision,
landing the scaffold this iter in parallel with the piece (i.b) prover lane.

## Mathematical Justification

The genus-stratified body restructure of `nonempty_jacobianWitness` (per
STRATEGY.md § "Decomposition: genus-stratified body of `nonempty_jacobianWitness`",
lines 37–63) requires both branches of the `by_cases` to point at NAMED sub-
theorems:

```lean
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
  · exact ⟨genusZeroWitness C h⟩      -- closed by milestone M2
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩  -- closed by M3
```

Currently `genusZeroWitness` is in place (iter-127 scaffold) but
`positiveGenusWitness` is missing. The body restructure cannot land until
both arms are at least scaffolded with sorry bodies.

Mathematically, the positive-genus branch produces the Albanese variety of `C`
of dimension `g = genus C ≥ 1` (i.e., the connected component of the identity
of `Pic_{C/k}`, or equivalently the Stein factorisation of the Abel–Jacobi
morphism on `Sym^g(C)`). The actual construction is M3 work
(routes A / B both > 5000 LOC; user-escalation pending). For the iter-134
scaffold lane the body is just `sorry`; the only required content is the
signature, the docstring, and the registration of the new declaration in
the `task_pending.md` list of open scaffolds.

## Changes Requested

- **File**: `AlgebraicJacobian/Jacobian.lean`
  - **Add** (immediately AFTER the existing `genusZeroWitness` declaration at
    lines 188–192, i.e., between `genusZeroWitness` and the existing
    `nonempty_jacobianWitness` at line 210):

    ```lean
    /-- The Albanese witness for a smooth proper geometrically irreducible curve `C`
    of positive genus `g ≥ 1` over `k`. The underlying scheme is the Albanese
    variety of `C` — classically the connected component of the identity of
    `Pic_{C/k}`, or equivalently the Stein factorisation of the Abel–Jacobi
    morphism on `Sym^g(C)`. Both constructions require infrastructure not yet
    in Mathlib (FGA representability of the Picard functor for Route A;
    symmetric powers + finite-group quotients + Stein factorisation +
    Brill–Noether–Riemann–Roch for Route B); the iter-123 M3 route audit
    (`analogies/m3-route-audit.md`) records both at midpoint ~6500 and
    ~9000 LOC respectively.

    **Status**: iter-134 scaffold — body is `sorry`. The body closure is M3
    work, currently OFF-CRITICAL-PATH until M2 closes (per STRATEGY.md
    § M3, user-escalation-pending). The scaffold exists to unblock the
    genus-stratified body restructure of `nonempty_jacobianWitness`
    (the `by_cases h : genus C = 0` decomposition needs both arms scaffolded;
    `genusZeroWitness` is in place since iter-127). -/
    noncomputable def positiveGenusWitness (C : Over (Spec (.of k)))
        [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
        (hg : 0 < genus C) :
        JacobianWitness C :=
      sorry
    ```

  - **DO NOT** modify the existing `nonempty_jacobianWitness`,
    `jacobianWitness`, `Jacobian`, or any of the four protected instances
    (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`,
    `instGeometricallyIrreducible`). The genus-stratified body restructure
    of `nonempty_jacobianWitness` is iter-157+ work per STRATEGY.md; the
    iter-134 scaffold lane is signature-only on the new declaration.
  - **DO NOT** edit the blueprint chapter `Jacobian.tex` — that is the plan
    agent's responsibility for any blueprint update (and per the iter-134
    blueprint-reviewer the chapter is `complete: true`, the new declaration
    can be left blueprint-undocumented this iter and the plan agent will
    add a hint in iter-135+).

## Affected Files

- `AlgebraicJacobian/Jacobian.lean`: +~25 LOC for the new declaration; 1 new
  `sorry` site.

No other files should require changes — `positiveGenusWitness` has no current
in-tree consumers (the planned consumer is the genus-stratified body of
`nonempty_jacobianWitness`, which is iter-157+ work).

## Expected Outcome

- `AlgebraicJacobian/Jacobian.lean` sorry count: **2 → 3** (L188
  `genusZeroWitness` + new `positiveGenusWitness` ~L196 + L213
  `nonempty_jacobianWitness`).
- Project sorry count: **3 → 4**.
- New declaration `AlgebraicGeometry.positiveGenusWitness` registered (free
  to be named under the `AlgebraicGeometry` namespace per the namespace
  context already established for the surrounding declarations).
- Compilation: clean. No protected signatures modified. No new axioms.
- The new sorry is documented in the docstring as M3 / off-critical-path
  / user-escalation-pending; the plan agent updates `task_pending.md`
  separately after your return to register the new scaffold.

## Notes for Refactor Agent

- The protected declarations list at `archon-protected.yaml` does NOT
  include `genusZeroWitness` or `positiveGenusWitness` (only `Jacobian`,
  `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`,
  `instGeometricallyIrreducible`, plus `genus`, `Jacobian.ofCurve`,
  `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`). So
  adding a new non-protected declaration is straightforward and does
  not require any yaml edits.
- The namespace at the surrounding declaration sites (`genusZeroWitness`,
  `nonempty_jacobianWitness`, `jacobianWitness`) is the file-level
  `namespace AlgebraicGeometry` opened earlier in the file. Confirm
  by reading the file head before editing.
- Use `Nat.pos_of_ne_zero` for the positive-genus hypothesis — that's
  the name STRATEGY.md cites (line 56) for the `by_cases` decomposition.
  But the scaffold doesn't use this — it just takes `hg : 0 < genus C`
  as a hypothesis. No tactical work needed.
- Insert the new declaration BETWEEN existing `genusZeroWitness` (lines
  188–192) and `nonempty_jacobianWitness` (line 210) so the two genus-
  arm scaffolds sit adjacent in the source for readability.
- After the insertion, run `lean_diagnostic_messages` on
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
  to confirm only the expected 3 `sorry` warnings + the pre-existing
  long-line linter warning at L234 (which the iter-134 plan agent
  noted; not your problem to address this iter).

## Status (when done)

Write Status: COMPLETE in your report, list the new sorry site (file:line),
and confirm the per-file sorry count is now 3.
