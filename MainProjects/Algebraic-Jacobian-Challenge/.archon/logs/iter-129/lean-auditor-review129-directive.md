# Lean Auditor Directive

## Slug
review129

## Scope (files)
all

## Focus areas (optional)

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — this iter the refactor lane renamed the only declaration (`lieAlgebra` → `cotangentSpaceAtIdentity`), relaxed its instance binder from a hardcoded `[SmoothOfRelativeDimension 1 G.hom]` to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`, and rewrote the docstring to drop the dualisation convention. Body is unchanged from iter-128. Audit for: docstring/body coherence; whether the body is mathematically what the docstring now claims; the file-level header's status block.
- `AlgebraicJacobian/Jacobian.lean` — header block rewritten this iter to enumerate the file's two `sorry`-bodied declarations. Verify the header is now accurate against the file contents and that no other stale prose remains.
- `AlgebraicJacobian/RigidityKbar.lean` — untouched this iter but holds an active scaffolded `sorry`. Re-audit for any drift since the iter-126 scaffold.
- `AlgebraicJacobian/Differentials.lean` — untouched this iter; spot-check for residue of the iter-126 excise pass.
- `AlgebraicJacobian/AbelJacobi.lean` — untouched; spot-check.
- `AlgebraicJacobian.lean` (top-level aggregator) — verify the `import` list is coherent with the files actually under `AlgebraicJacobian/`.

## Known issues

- The three `sorry`-bodied declarations are intentional and tracked:
  `Cotangent/GrpObj.lean` no longer has a `sorry` (it was closed iter-128); the three remaining live at
  `AlgebraicJacobian/Jacobian.lean:188` (`genusZeroWitness`, iter-127 scaffold),
  `AlgebraicJacobian/Jacobian.lean:208` (`nonempty_jacobianWitness`, Phase-C OFF-LIMITS), and
  `AlgebraicJacobian/RigidityKbar.lean:75` (`rigidity_over_kbar`, iter-126 scaffold). Do not re-flag the *existence* of these `sorry`s; do flag any signature drift or docstring inconsistency.
- Pre-existing long-line linter warnings at `Jacobian.lean:231` and `AbelJacobi.lean:22` are known; do not re-flag.
- A separate critical finding (out-of-scope for this auditor) was returned by the iter-129 `mathlib-analogist`: the iter-128 body of `cotangentSpaceAtIdentity` is mathematically degenerate (computes the zero `k`-module for the target class). The iter-130 prover lane is staged to swap the body via Replacement (B). You do NOT need to re-derive this finding; if anything in the file's docstring or comments still claims the body computes a non-zero or canonical rank-`n` module, flag it as a stale/excuse-comment so it gets refreshed before the iter-130 swap.

## Output

Per-file checklist + flagged-issues block grouped by severity (critical / major / minor / informational). Write to `task_results/lean-auditor-review129.md`.
