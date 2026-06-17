# Progress-critic directive — iter-223

Assess convergence of the ONE active prover route. Fresh-context: you get only
extracted signals below — no STRATEGY.md, no blueprint, no full sidecars.

## Route: Lane TS.dual (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

Funded multi-iter `mathlib-build` block: a sheaf internal-hom / dual of 𝒪_X-modules,
decomposed into 5 named sub-steps. Convergence is tracked by **sub-step retirement**
against the estimate, NOT by the project sorry-count (the target sorry
`exists_tensorObj_inverse` only closes at sub-step 5).

- **Strategy estimate (verbatim from the phase row):** Iters left `~6–12`; phase
  entered at **iter-219**. Elapsed: **4** (iters 219, 220, 221, 222).
- **Sub-step ledger:** sub-step 1 (value module) RETIRED iter-219; sub-step 2
  (restriction maps + assembled presheaf internal-hom) RETIRED iter-220; sub-step 3
  (the `dual` object + the full evaluation morphism `internalHomEval`) IN PROGRESS,
  spanning iters 221→222→(223).

### Last 4 iters — signals

| iter | status | project sorry | decls added | blocker phrase |
|---|---|---|---|---|
| 219 | PARTIAL | 80→80 | 11 (value module `homModule`/`internalHomObjModule` + helpers) | none — sub-step 1 retired |
| 220 | PARTIAL | 80→80 | 12 (restriction maps + assembled presheaf `internalHom`) | none — sub-step 2 retired |
| 221 | PARTIAL | 80→80 | 6 (`dual` + `internalHomEvalApp` + 5 eval helpers) | "blocked on `Over.map` pseudofunctor coherence" (eval naturality) |
| 222 | PARTIAL | 80→**81** | 2 (`internalHomEvalApp_tmul`, `restr_map_homMk`) | `Over.map` coherence **SOLVED**; NEW blocker = "`whnf` heartbeat bomb at the `𝟙_` unit instantiation" |

### Key facts for your read

- iter-222 **solved** the iter-221 blocker (`Over.map` coherence), axiom-clean
  (`restr_map_homMk`, `dual_map_app_terminal` worked out). The naturality reduction
  is **fully worked out and verified in pieces**; it reaches `naturality_apply`.
- The morphism `internalHomEval` is assembled but its naturality field is a typed
  `sorry` → project sorry 80→**81** (first upward move of the build). Honestly flagged
  (Lean docstring + blueprint `% NOTE:`), NOT load-bearing downstream yet.
- The ONLY remaining obstacle is an **elaboration-cost** `whnf` heartbeat bomb
  (>3.2M heartbeats, not budget-bound) localized to instantiating a `rfl`-bridge at
  the concrete unit `𝟙_`. **Three concrete whnf-free fixes** are recorded by the
  prover: (1) generalize the unit (work abstract, specialize at end); (2) use Mathlib's
  `pushforward_obj_map_apply'` / `pushforward_map_app_apply'` so matching is syntactic;
  (3) close the section-level goal elementwise without `exact key.symm`.

### Planner's proposed iter-223 objective (1 file ≤ cap)

Re-dispatch the SAME lane to apply ONE of the three whnf-free fixes and **close the
naturality `sorry`** (project sorry 81→80), retiring sub-step 3 with `internalHomEval`
axiom-clean. Plus a comment-only ride-along: fix the stale file-header sorry count
(3→4, now 4→back-to-3 once closed).

### Specific question for you

1. Is re-dispatching this lane CONVERGING, CHURNING, or STUCK? Note the prior STUCK
   watch was "if iter-222 reports the `Over.map` coherence blocker AGAIN" — it did NOT
   (it solved it); the new blocker is a different, precisely-localized elaboration-cost
   issue with three concrete fixes. Does that reset the STUCK clock, or do you read the
   net-zero-then-+1 sorry trajectory as churn?
2. Is the proposed objective the right corrective TYPE, or do you recommend a different
   one (e.g. mathlib-analogist consult on whnf-free `PresheafOfModules.Hom` naturality)?
