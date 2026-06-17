# Lean Auditor Directive

## Slug

review135

## Iteration

135

## Scope (files)

all `.lean` files under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`
and the top-level
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`.
Do NOT audit `.lake/packages/**` (those are upstream Mathlib / Batteries).

## Focus areas (optional)

Pay extra attention to the two files that were touched by the iter-135
plan-phase refactor lane (NO prover lane this iter):

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — 3 theorem signatures
  refactored from `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` to
  `noncomputable def ... := sorry` with intended sheaf-level RHS using
  `PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom <morphism>).hom`.
  Plus a 27-line section docstring rewritten to ~17 lines; 1 new import.
- `AlgebraicJacobian/Jacobian.lean` — `nonempty_jacobianWitness` body
  restructured from inline `:= sorry` to `by_cases h : genus C = 0`
  delegating to `genusZeroWitness` and `positiveGenusWitness` via
  `Nat.pos_of_ne_zero`. Plus 3 docstring status updates.

Bias toward thoroughness — do not skip the rest of the project just
because focus is named.

## Known issues (skip re-reporting)

- `AlgebraicJacobian/Cotangent/GrpObj.lean` lines 50/53/204 contain the
  word "opaque" in docstring text discussing the iter-131 body refactor;
  these are NOT actual `opaque` declarations. `lean_verify` reports them
  as source-scan source-text matches only. Skip.
- Pre-existing long-line linter warning at `Jacobian.lean:275`
  (`Jacobian` definition exceeds 100 chars) is a protected signature and
  must NOT be re-formatted. Skip.
- In-docstring "line N below" references inside the
  `cotangentSpaceAtIdentity` docstring (~4 sites at `Cotangent/GrpObj.lean`
  lines ~106-160) are documentation-rot; the iter-135 refactor only
  de-pinned the file-header docstring per its directive. Flag as MINOR
  cleanup if you wish, but do not classify as must-fix.

## Authoritative paths

- Project root: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/`
- Lean source: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`
- Aggregator: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean`
