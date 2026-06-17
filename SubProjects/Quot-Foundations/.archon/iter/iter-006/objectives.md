# Iter 006 — Objectives (per-lane attempt detail)

## FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

| Target | Line | Status entering | This-iter action |
|---|---|---|---|
| `base_change_mate_regroupEquiv` `map_smul'` | ~913 | PARTIAL (instance wall) | CLOSE via `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` — helper now in imported `RegroupHelper.lean` (refactor `split-regroup`) |
| `base_change_mate_generator_trace_eq` | ~945 | typed-sorry, no attempt | FIRST real attempt: 3-step adjoint-mate trace (unit / `f_*` reindex / `g^*⊣g_*` transpose); honest partial if stalls |
| `affineBaseChange_pushforward_iso` | ~1076 | deferred-sorry | Attempt if budget: assembly via `base_change_map_affine_local` + mate lemma + tilde dictionaries; partial OK |
| `flatBaseChange_pushforward_isIso` | ~1098 | deferred | DO NOT churn (FBC-B) |

Closing `map_smul'` + `generator_trace_eq` finishes `pushforward_base_change_mate_cancelBaseChange`
(already assembled to consume the `generator_trace` leaf).

## GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

| Target | Line | Status entering | This-iter action |
|---|---|---|---|
| `exists_free_localizationAway_polynomial` (L5) | ~495 | PARTIAL, non-viable skeleton | **PRIMARY**: rewrite to strong induction on d (`Nat.strongRecOn`, N universally quantified); keep d=0 + torsion sub-case; then attempt generic-rank SES dévissage (`0→A_g[X]^m→N_g→T→0`, IH on T, splice via L3). Skeleton MUST land |
| `exists_localizationAway_finite_mvPolynomial` (L4) | ~445 | PARTIAL (Step-1 done) | Budget-permitting: Step-2 denominator-clearing descent; partial OK |
| `genericFlatnessAlgebraic` | ~562 | deferred | DO NOT churn (assembly; wire after L4/L5) |
| `genericFlatness` | ~629 | deferred | DO NOT churn (geo wrapper) |

## Dispatch-sanity
- 2 files in `## Current Objectives`, within the ~10 cap. Both import-parallel
  (RegroupHelper→FlatBaseChange chain compiles; GF independent). progress-critic dispatch=OK.
