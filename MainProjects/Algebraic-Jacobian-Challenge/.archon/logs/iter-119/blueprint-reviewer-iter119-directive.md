# Blueprint Reviewer Directive

## Slug
iter119

## Iter
119

## Project goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge (`references/challenge.lean`); the project ships
with exactly one inline `sorry` (`Jacobian.lean:179`
`nonempty_jacobianWitness`, the single explicit foundational
hypothesis). All other declarations close.

Active blueprint chapters (per `blueprint/src/content.tex`):

```
chapters/Cohomology_SheafCompose
chapters/Cohomology_StructureSheafAb
chapters/Cohomology_StructureSheafModuleK
chapters/Cohomology_MayerVietoris
chapters/Differentials
chapters/Genus
chapters/Jacobian
chapters/Rigidity
chapters/AbelJacobi
```

Audit ALL nine. Orphan chapters on disk
(`Modules_Monoidal.tex`, `Picard_*.tex`) are NOT in `content.tex` —
ignore them.

## Strategy snapshot (excerpt — full text in STRATEGY.md)

- **Phase C (this iter's prover lane)**: close
  `AlgebraicJacobian/Differentials.lean:87`
  `smooth_locally_free_omega` (forward-only direction) via a
  pre-verified 5-step Mathlib chain. The signature was refactored
  iter-118 from a mathematically-false iff to a forward-only
  implication.
- **End-state**: 1 inline `sorry` (`Jacobian.lean:179`
  `nonempty_jacobianWitness`) declared as the project's single
  foundational hypothesis. All routes to close it require Mathlib
  infrastructure (Hilbert/Quot, symmetric powers, or genus-0
  rigidity) absent from `b80f227`.

## Prior reviewer status (iter-118)

You returned the following per-chapter checklist iter-118:

- `Cohomology_SheafCompose` / `Cohomology_StructureSheafAb` /
  `Cohomology_StructureSheafModuleK` / `Genus` / `Rigidity`:
  `complete: true, correct: true`. No must-fix.
- `Cohomology_MayerVietoris`: `complete: partial, correct: true`.
- `Differentials`: `complete: partial, correct: false`. HARD-GATED
  the iter-118 prover lane until the writer pass landed. **Iter-118
  blueprint-writer rewrote the chapter** (`thm:smooth_locally_free_omega`
  is forward-only; 5-step Mathlib chain with `[verified]` tags;
  new `\sec{Converse direction --- out of autonomous-loop scope}`).
  iter-118 lean-vs-blueprint-checker `differentials-review118`
  reports the rewritten chapter as in mutual agreement with the
  refactored Lean (0 must-fix / 0 major / 0 minor).
- `Jacobian`: `complete: partial, correct: partial`. Three must-fix
  items (`IsAlbanese_unique` prose drift; missing `\structure
  JacobianWitness`; missing `\lean{...}` refs for `IsAlbanese.*`
  projection trio). **Iter-118 blueprint-writer addressed all three**;
  iter-118 lean-vs-blueprint-checker `jacobian-review118` returns
  the rewritten chapter as in agreement.
- `AbelJacobi`: `complete: partial, correct: true` (cascading from
  Jacobian gap; the gap is now closed).

This iter's question: are the iter-118 chapter rewrites in
`Differentials.tex` and `Jacobian.tex` complete + correct, and is
`Differentials.tex` ready to support the scheduled iter-119 prover
lane on `smooth_locally_free_omega`?

Specifically (from the recommendations of `proof-journal/sessions/session_118/recommendations.md`):

1. Verify that the 5 closing pieces named in `Differentials.tex`
   (`AlgebraicGeometry.smoothOfRelativeDimension_iff`,
   `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`,
   `Algebra.IsStandardSmooth.free_kaehlerDifferential`,
   `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
   project-local `relativeDifferentialsPresheaf_obj_kaehler`) are
   correctly named (we ran lean_run_code spot-checks and all 5
   plus the `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`
   bridge resolve in Mathlib `b80f227`). Fresh-eyes check that the
   chapter's prose maps cleanly to a tactic plan a prover can
   execute.

2. Verify Jacobian.tex's chapter-side `\structure JacobianWitness`
   block enumerates the same seven fields the iter-118
   refactor preserved on `AlgebraicGeometry.JacobianWitness`.

3. Any other chapter on the active list that has acquired drift
   since iter-118.

## Read-only access

Read `blueprint/src/chapters/{Differentials,Jacobian,AbelJacobi,Genus,Rigidity,Cohomology_*}.tex`
and the corresponding `.lean` files for cross-reference. Do NOT read
`iter/iter-NNN/{plan,review}.md` or `task_results/`.

## Directive

Return the per-chapter checklist as documented in your
`.archon/subagents/blueprint-reviewer.md` § "Report format".
Particular attention to: is `Differentials.tex` ready to gate the
iter-119 prover lane (HARD GATE)?
