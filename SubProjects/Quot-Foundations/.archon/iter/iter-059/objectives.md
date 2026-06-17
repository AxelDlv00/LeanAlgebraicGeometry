# Iter 059 — Objectives

## Lane 1 — GF close (prove)
- File: `AlgebraicJacobian/Picard/FlatteningStratification.lean`, sorry @ L3585.
- Goal: `l (c • x) = c • l x` (STEP-3 transport semilinearity) → ρ-agreement, both sides
  `= p.appLE (S.basicOpen f) (X.basicOpen g) hg_pre c` via the compiling `hsquare` `map_appLE`/`appLE_map`.
- ~40–60 LOC, NO Mathlib gap. MUST close (progress-critic throughput: last grace).
- Hygiene: delete stale L1957 "(sorry this iter)".

## Lane 2 — GR scaffold + C1 (prove)
- File: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`.
- Scaffold: `bundleTransition` (def), `bundleTransition_self` (C1), `bundleTransition_cocycle` (C2),
  `glueRestrictionIso`, `glue_unique`, `glueHom` (sorry stubs from blueprint §GL_d).
- Fill: `bundleTransition` def (GL_d matrix automorphism, mirror `chartQuotientMap`) + C1.
- Defer: C2 (hard) + downstream + 3 riders (L393/L404/L898).

## Deferred — SNAP (iter-060)
- `relTensorProj.naturality` (1 sorry, ~L658) via ModuleCat-presheaf route. Blueprint prepped this iter.

## Gate decisions
- GF: CONDITIONAL PASS (close route complete+correct §3.2; coverage debt remediated by writer).
- GR: PASS (§3.1 SCAFFOLD YES).
- SNAP: FAIL → deferred (writer this iter; mandatory review clears for iter-060).
