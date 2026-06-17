# lean-vs-blueprint-checker wd-iter201 directive

## Scope

Bidirectional verification for **one** Lean file and its blueprint
chapter:

- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## What to check

1. **Lean → blueprint**: every theorem/lemma/definition in the Lean
   file that is referenced from another file (i.e. `private` aside,
   anything reachable) should be pinned in the chapter via
   `\lean{...}`. Iter-201 added 6 new declarations
   (`Ring.ord_ringEquiv`, `Ring.nonZeroDivisors_ringEquiv`,
   `Ring.ordMonoidWithZeroHom_ringEquiv`, `Ring.ordFrac_ringEquiv`,
   `AlgebraicGeometry.Scheme.Opens.functionFieldIso`,
   `AlgebraicGeometry.Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`);
   the chapter §"Open-immersion descent for prime divisors" has an
   "End-to-end map: Sub-builds 1--3" paragraph but no explicit
   `\lean{...}` pins for the Sub-build 2 / 3 substrate decls. Flag
   whether each should be pinned.

2. **Blueprint → Lean**: every `\lean{...}` pin should resolve to an
   existing project declaration. The deterministic `sync_leanok`
   added 5 markers this iter — verify all 5 land on the correct
   block.

3. **Statement fidelity**: any blueprint statement labelled
   `\leanok` (now or after this iter's sync) should match the Lean
   statement (signature shape, hypotheses, conclusion). Flag drift.

4. **Severity tags**: `must-fix-this-iter` (downstream blocked), or
   `soon` (minor drift, not yet blocking).

## Output

Per-file report with the bidirectional sections. Write to
`task_results/lean-vs-blueprint-checker-wd-iter201.md`.
