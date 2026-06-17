# Lean Auditor Directive

## Slug
iter109

## Scope (files)
all

## Focus areas (optional)

- `AlgebraicJacobian/Picard/LineBundle.lean` — received prover work this iteration. New
  `noncomputable def SheafOfModules.pullback_oneIso` at L96 (4 LOC, body `sorry`)
  was introduced alongside the existing `SheafOfModules.pullback_tensorObj` (L82,
  body `sorry`). Three downstream bodies were closed: `Pic.pullback` (L108),
  `Pic.pullback_id` (L131), `Pic.pullback_comp` (L147). Audit whether the new
  helper's signature and surrounding doc-comment are sound; whether the proof
  bodies introduce any new excuse-comments or suspect tactics; whether the
  file-level header doc-comment is consistent with the new state.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — no prover work this iter (all
  6 sorries off-limits), but the file-header docstring drift flagged by
  lean-auditor-iter108 (L17 sorry-count rot) remains uncorrected. Re-check whether
  it is still drifted post-iter-110.
- `AlgebraicJacobian/Differentials.lean` — the L27 stale `## Status` header
  flagged by lean-auditor-iter107/iter-108 remains uncorrected. Re-check.

## Known issues (do not re-report verbatim)

- The four critical/major carry-over findings from lean-auditor-iter108 that
  remain unaddressed:
  1. `LineBundle weakened-wrong def` — **NOW RESOLVED iter-109 (Archon)** via C1
     promotion refactor; please verify the new definition
     `def LineBundle (X : Scheme.{u}) : Type _ := (Skeleton X.Modules)ˣ` is now
     mathematically correct.
  2. `PicardFunctor.representable` off-limits sorry (`Picard/Functor.lean:181`)
     — Phase C3 deferral via JacobianWitness exit policy; off-limits this iter.
  3. `instIsMonoidal_W` off-limits sorry (`Modules/Monoidal.lean:173`) — Mathlib
     gap, load-bearing post-C1; off-limits.
  4. `Differentials.lean:27` stale status header — flagged for cosmetic cleanup.
- The two new MAJOR findings from lean-auditor-iter108:
  1. `BasicOpenCech.lean:17` sorry-count header rot (carry-over; not addressed
     iter-109).
  2. `BasicOpenCech.lean:1846` DEFERRED annotation cites invented instance
     names — known informational; addressed in PROJECT_STATUS.md Knowledge Base
     citation-precision rule.

## Absolute paths

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`
  (recurse for all `.lean` files).
