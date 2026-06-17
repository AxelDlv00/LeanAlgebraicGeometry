# Recommendations — for the iter-157 plan agent

## CRITICAL — loop-infrastructure: stop dispatching provers onto off-limits files

For the **second consecutive iter** a prover lane fired on a file PROGRESS.md
explicitly marked off-limits / "no prover dispatch this iter" (iter-155:
`Jacobian.lean`; iter-156: `Jacobian.lean` again, despite a stated mechanical
HARD GATE). The prover behaved correctly both times (no scaffold, no laundering,
honest gate documentation), but the dispatch itself contradicts the plan's
`## Current Objectives` ("no prover dispatch this iter") and `## Off-limits`
list. **Action for the plan agent**: when the mechanical gate fires and there is
no prover-ready target, ensure the objectives file actually yields an empty
prover-lane set — investigate whether `planValidate` is deriving a lane from a
stale objective. (Logged to debug-feedback for the Archon developer.)

## HIGH — genus-0 keystone is PLAN-gated, not prover-gated: do NOT dispatch a prover on `genusZeroWitness.key`

The sole gap `key : f = toUnit C ≫ η[A]` is `rigidity_over_kbar`'s conclusion,
and is blocked by THREE verified out-of-file obstructions (do not retry any of
these from inside `Jacobian.lean`):

1. **Import cycle** `RigidityKbar → Rigidity → Jacobian` — `Jacobian.lean`
   cannot import `rigidity_over_kbar`. **Plan-level corrective**: relocate the
   AV rigidity-lemma stack (route (c): `theorem_of_the_cube`,
   `rigidity_theorem`, `rational_map_to_AV_extends`,
   `unirational_to_AV_constant`, `rigidity_genus0_curve_to_AV`,
   `rigidity_over_kbar`) into a file **upstream** of `Jacobian.lean`, OR restate
   genus-0 rigidity in an importable location. This MUST precede any prover
   dispatch on `key`.
2. **Char-`p` gap** — `rigidity_over_kbar` carries `[CharZero kbar]`,
   unsynthesizable from `[Field k]`. Route (c) (Milne, char-free) drops it; until
   then `key` is only closable in char 0, insufficient for the protected
   signature.
3. **Base-change functor missing** — `Over (Spec k) → Over (Spec k̄)` + 7-instance
   transfer + genus stability is a multi-iter sub-build (only the final
   epi-cancellation, `Flat.epi_of_flat_of_surjective`, is in Mathlib).

**Forward path (plan-level, this is the committed route (c) per STRATEGY.md):**
blueprint the AV rigidity-lemma stack (Milne *Abelian Varieties* §I, already
fetched at `references/abelian-varieties.pdf`; the chapter `sec:av_rigidity_route_c`
exists in `Jacobian.tex` with the Milne block skeletons) to prover-ready detail —
this is the next concrete forward unit. Only after that stack lands (and the
import relocation is decided) does a prover lane on the rigidity declarations
become dispatchable. The blueprint-reviewer HARD GATE applies: the new
rigidity-stack chapter must be `complete + correct` before any prover runs.

## HIGH — blueprint-writer needed on `Jacobian.tex` (2 majors from lean-vs-blueprint-checker)

`lean-vs-blueprint-checker jacobian-iter156` confirmed two **major** blueprint
under-statements (Lean side is honest; chapter is the defect). I added a `% NOTE:`
recording both at `def:genusZeroWitness`; a blueprint-writer should land prose fixes:

1. **Disclose the import-cycle obstruction** in `def:genusZeroWitness` + C.2.g:
   the chapter presents `genusZeroWitness` as directly consuming
   `rigidity_over_kbar`, which is impossible given the import topology; note the
   relocation/restatement prerequisite.
2. **Re-cost C.2.f**: the chapter bills the k̄→k descent as "∼2 lines"; separate
   the cheap epi-cancellation from the expensive, currently-missing base-change
   functor + instance/genus-stability infrastructure.
   Plus the two still-pending iter-155 `% NOTE:` items (loose uniqueness prose;
   `[CharZero kbar]` omitted in infrastructure-(γ) opening + Layer I).

## MEDIUM — blueprint-doctor: fix the `% archon:covers` path convention in `RigidityKbar.tex`

The doctor reports `RigidityKbar.tex` covers `RigidityKbar.lean` and
`Cotangent/ChartAlgebra.lean` "which do not exist." Both files exist under
`AlgebraicJacobian/`; the `covers` paths are written relative to the
`AlgebraicJacobian/` source root but the doctor resolves relative to repo root.
Align the declaration (prepend `AlgebraicJacobian/`) so the prover-dispatch gate
routes the right chapter to the right file. Low-risk one-line fix.

## Blocked targets — do NOT re-assign

- `genusZeroWitness.key` — plan-gated (import cycle + char-`p` + base-change
  functor). See HIGH above.
- `positiveGenusWitness` — Route A FGA representability engine (~6500 LOC),
  off-critical-path per STRATEGY.md §M3. Body is an honest term sorry; no
  in-file scaffold is possible without the engine.
- `rigidity_over_kbar` — committed to route (c); not prover-dispatchable until
  the AV rigidity-lemma stack is blueprinted to prover-ready detail.

## Reusable pattern (already in PROJECT_STATUS KB)

- When a critical-path lemma lives downstream in the import graph, a prover
  cannot wire it; the corrective is a plan-level file relocation, not a prover
  edit. Verify import topology (`grep '^import'`) before assuming a lemma is
  consumable.
