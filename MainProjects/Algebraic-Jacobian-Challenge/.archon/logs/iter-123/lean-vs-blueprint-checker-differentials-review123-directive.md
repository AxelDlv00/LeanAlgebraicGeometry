# lean-vs-blueprint-checker — Differentials.lean vs Differentials.tex (iter-123 review)

## Scope

Single-file bidirectional check:

- **Lean file**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`
- **Blueprint chapter**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex`

## Why this file

This is the only `.lean` file that received prover edits this iter (the iter-123 M1.b prover lane on `appLE_isLocalization`). The prover landed Steps 1 and 4 of the blueprint's 4-step `IsLocalization.of_le` plan inside the body of `appLE_isLocalization` and packaged Steps 2-3 into a single residual `sorry` on an `AlgEquiv` between `Localization M` and `A_colim` (suffices block at L328-L362).

## What to check

Bidirectional:

1. **Lean → blueprint**: does every fully-proved Lean declaration in `Differentials.lean` correspond to a `\lean{...}`-tagged statement block in `Differentials.tex`? Specifically:
   - `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (L282; body L304-L362; still 1 sorry residual)
   - `AlgebraicGeometry.IsAffineOpen.isUnit_appLE_unitSubmonoid_in_colim` (Step 0 helper, fully proved iter-122)
   - `AlgebraicGeometry.Scheme.kaehler_localization_subsingleton`
   - `AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso`
   - `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
   - `AlgebraicGeometry.Scheme.smooth_locally_free_omega` (closed iter-120)

2. **Blueprint → Lean**: does the `\lean{...}` macro on each lemma in the chapter point at an existing Lean declaration in the file? Are the prose proofs in the chapter (Steps 0-4 of `lem:appLE_isLocalization`) accurate to the Lean body — in particular Step 4 specifically uses `IsLocalization.isLocalization_of_algEquiv` (the planner verified that an `AlgEquiv` is required, not a `RingEquiv` — make sure the chapter's "or via `IsLocalization.of_le` ... or `IsLocalization.of_ringEquiv`" hedge at L175 is not misleading).

3. **Statement-level signature alignment**: the chapter's M1.b proof prose (§ sec:bridge, Lemma lem:appLE_isLocalization Step 0) writes "first observe that each $g \in M$ is a unit in $A_{\mathrm{colim}}$." This is now broken out as a named helper `isUnit_appLE_unitSubmonoid_in_colim` (top-level theorem; iter-122 closure). Is this naming mismatch flagged in the chapter, or does the chapter still read as if Step 0 were inlined? If the latter, this is a documentation-drift finding — recommend adding a `\lean{...isUnit_appLE_unitSubmonoid_in_colim}` sub-block.

4. **Open questions for the planner**: the residual sorry at L362 is the `AlgEquiv` packaging Step 2 + Step 3 + the algebra-map compatibility. The blueprint's Step 2 prose at L171 describes the cofinality argument via a basic-open refinement; the blueprint's Step 3 prose at L173 describes the inverse-identity verification. Are these adequately specified for the next prover iter, or does the blueprint need expansion on the `IsLocalization.map` / `IsColimit.desc` plumbing? Flag must-fix-this-iter only if the chapter is genuinely thin enough to mislead the iter-124 prover.

## Output

Report at `task_results/lean-vs-blueprint-checker-differentials-review123.md`. Use the standard bidirectional-check format: per-axis findings (Lean→blueprint, blueprint→Lean, signature alignment), per-finding severity (must-fix / major / minor / cosmetic), suggested action per finding.
