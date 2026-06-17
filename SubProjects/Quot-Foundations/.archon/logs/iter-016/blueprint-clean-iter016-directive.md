# Blueprint-clean directive — iter-016 (post-writer purity pass)

## Chapters edited this iter (clean these)
1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — Seam 2/3 proof prose enriched +
   `% RECIPE (iter-015, LSP-validated):` comments added.
2. `blueprint/src/chapters/Picard_FlatteningStratification.tex` — new `lem:gf_away_tower_descent`
   block + 2 Mathlib `\mathlibok` anchors + Step-4 repointed in `lem:gf_polynomial_core`.
3. `blueprint/src/chapters/Picard_QuotScheme.tex` — MAJOR re-skeleton of the graded-rationality
   machinery to Route 2 (ambient subquotient induction): G1 split into two blocks, G2/G3/G4 blocks
   + `quotSMulTop` anchor removed, 5 new `AlgebraicGeometry.GradedModule.*` blocks added, proof of
   `lem:gradedHilbertSerre_rational` rewritten.

## What to do
Standard purity pass: strip Lean *tactic* syntax / Lean-name leakage from RENDERED prose, fix or
insert missing `% SOURCE QUOTE` verbatim quotes, remove project-history verbosity and any per-iter
narrative that crept into the prose. Validate LaTeX environment balance and cross-references.

## IMPORTANT — do NOT strip these (intentional)
- `% RECIPE:` and `% LEAN DEPS:` LaTeX comments hold Mathlib lemma names as formalization hints for
  the prover. They are COMMENTS (do not render in the PDF) and are deliberate. Keep them. Only ensure
  no Mathlib lemma name leaked into the *rendered* (non-comment) prose.
- The `\mathlibok` anchors (FBC/GF/QUOT) — these are genuine Mathlib dependency anchors; keep.
- `\lean{...}` pins on the new Route 2 QUOT blocks point at decls the prover will create next iter
  (tex precedes Lean) — this is correct; do not remove.
- Existing `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` (Stacks 00K1, 02KH, Nitsure,
  Hartshorne) — preserve verbatim; do not re-fabricate.

## Do NOT
- Add or remove `\leanok` (deterministic sync owns it).
- Change any statement, `\label`, `\lean{}` pin, or `\uses{}` set — purity edits only.
