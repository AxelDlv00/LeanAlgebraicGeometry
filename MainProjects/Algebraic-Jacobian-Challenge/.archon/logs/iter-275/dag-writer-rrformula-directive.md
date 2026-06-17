# Blueprint Writer Directive

## Slug
cov275-rrformula

## Target chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex

## Strategy context
This chapter covers `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (a Route-C /
Riemann–Roch chapter, PAUSED for proving but in scope for blueprint
completeness). The project keeps a strict 1-to-1 Lean ↔ blueprint correspondence.
The declarations below currently have NO blueprint entry. Add one additive,
faithful 1-to-1 coverage block per declaration. Purely additive — do not
restructure the existing chapter.

## Required content
Read each Lean signature/docstring from RRFormula.lean, then add a block for:

- `AlgebraicGeometry.Scheme.eulerCharacteristic_sheafOf_zero` — Euler
  characteristic base case (the `0`-th step / zero sheaf).
- `AlgebraicGeometry.Scheme.eulerCharacteristic_sheafOf_succ` — the successor /
  inductive step of the Euler characteristic of a `sheafOf` family.
- `AlgebraicGeometry.Scheme.eulerCharacteristic_sheafOf_single_add` — the
  single-step additivity contribution.
- `AlgebraicGeometry.Scheme.eulerCharacteristic_of_shortExact_skyscraper` —
  additivity of the Euler characteristic across a short exact sequence whose
  cokernel/quotient is a skyscraper sheaf.
- `AlgebraicGeometry.Scheme.finrank_H0_toModuleKSheaf_eq_one` — H⁰ of the
  residue-field structure sheaf has k-rank one.

## Proof notes
- For decls proved sorry-free in Lean: one-line `\begin{proof} Proved directly in
  Lean. \end{proof}`.
- For any `sorry`-bodied decl (check the Lean source): a brief honest informal
  sketch, not a "proved directly in Lean" note.

## Wiring (critical — leandag quirk)
leandag builds edges ONLY from **statement-level** `\uses{}`. Each new block must
carry a statement-level `\uses{}` tying it into the chapter cone (the Euler-
characteristic blocks naturally `\uses{}` each other and the RR-formula consumer).
After writing, run `leandag build --json` and
`leandag query --isolated --chapter RiemannRoch_RRFormula`; ensure none of your
new blocks is isolated.

## Out of scope
- Do NOT touch existing blocks. Do NOT add `\leanok`. Do NOT cover TensorObj/Modules helpers.

## References
- `references/summary.md` — only if you cite an external RR statement; these are
  project-internal Euler-characteristic plumbing lemmas, so a "proved directly in
  Lean" note with no external citation is acceptable. Do NOT fabricate a citation.

## Expected outcome
Five additive 1-to-1 coverage blocks, statement-level-wired, no new isolated
nodes, no broken `\uses{}`.
