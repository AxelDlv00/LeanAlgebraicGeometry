# lean-auditor iter-201 directive

## Scope

Whole-project read-only audit of `.lean` files under
`AlgebraicJacobian/`. No strategic context. Pay extra attention to
the 3 files that received prover edits this iter:

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane WD-A4a Sub-build 2)
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane AB-Stacks-00MF Path B)
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (Lane COE-Stage6.B-Jacobian)

For these three, inspect every new declaration (per `git diff HEAD~1`)
for outdated comments, suspect typeclass juggling, dead-end proofs,
headline-laundering patterns (placeholder bodies that pretend to close
mathematical content), bad Lean practices, and silent `sorryAx`
propagation via instance synthesis.

For all other files: per-file checklist style — flag stale comments
referencing closed sorries, suspect definitions, accumulated `private`
helpers that should be promoted/removed, and any drift from project
hygiene.

## Conditions / Constraints

- I have NOT been given STRATEGY.md, PROGRESS.md, or any iter sidecar.
  Do not infer "this is what the strategy wants"; audit the Lean as
  Lean.
- The deterministic `sync_leanok` ran this iter (5 markers added,
  0 removed, `RiemannRoch_WeilDivisor.tex` touched). Markers reflect
  current sorry state; do not flag missing markers as audit findings.
- Project axioms streak: 21st consecutive iter at zero project axioms.
  Any new `axiom`, `noncomputable def := sorry` on a carrier, or
  `instance` whose body transitively invokes `sorryAx` is CRITICAL.

## Output

Per-file checklist + flagged-issues block per the descriptor's
standard format. Write to `task_results/lean-auditor-iter201.md`.
