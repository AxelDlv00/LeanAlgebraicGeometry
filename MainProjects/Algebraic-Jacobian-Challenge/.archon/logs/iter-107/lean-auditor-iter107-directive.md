# Lean Auditor Directive

## Slug

iter107

## Scope (files)

all

## Focus areas (optional)

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (received the only substantive prover work this iter; new partial-proof scaffolding ~40 LOC was inserted at L1796–L1834 inside `h_loc_exact`. Audit whether (i) the new inline `have`s are mathematically clean, (ii) the `@`-form `IsLocalization.Away` typing at L1822–L1834 is well-formed, (iii) no new excuse-comments or "temporary" wording was introduced).
- Any file with `sorry` bodies — see if the trailing comments around them remain accurate after the iter-109 partial committed at L1846.

## Known issues (do not re-report)

These are already on the review agent's plate from prior iters; please confirm whether each is still present and note any change, but do not re-litigate severity unless it shifted this iter:

- `AlgebraicJacobian/Picard/LineBundle.lean:85–86` weakened-wrong `LineBundle` definition (CRITICAL, carrying since iter-104).
- `AlgebraicJacobian/Modules/Monoidal.lean:166–173` `instIsMonoidal_W := sorry` (CRITICAL Mathlib upstream gap; off-limits to autonomous work).
- `AlgebraicJacobian/Picard/Functor.lean:190` `PicardFunctor.representable := sorry` (MAJOR, downstream of LineBundle).
- `AlgebraicJacobian/Jacobian.lean:179` `nonempty_jacobianWitness` Phase-C scaffolding sorry.
- 5 excuse-comments previously flagged: LineBundle "first approximation", Monoidal "does NOT block downstream consumers", Picard/Functor "intentionally left as sorry", Differentials "scaffold for ten more iterations", Jacobian `nonempty_jacobianWitness` deferral.

If any of these changed shape this iter, note it; otherwise list them as carryover without re-evaluating severity.
