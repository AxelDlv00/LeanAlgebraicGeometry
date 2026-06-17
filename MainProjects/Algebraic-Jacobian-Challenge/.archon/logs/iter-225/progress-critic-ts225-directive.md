# progress-critic ts225 — convergence audit, route A.1.c.SubT.dual

Assess ONE active route. Fresh-context convergence check only (NOT strategy soundness,
NOT math correctness).

## Route: A.1.c.SubT.dual — sheaf internal-hom / dual of 𝒪_X-modules

Single file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`. Funded multi-iter infra
build (the `Hom(L,𝒪_X)` dual + evaluation that discharges `exists_tensorObj_inverse`).
Decomposed into 5 sub-steps; convergence is by **sub-step retirement**, not raw sorry count
(the build is no-sorry infra — new axiom-clean decls land without touching the project sorry
counter until the final consumer closes).

- Sub-step 1 (per-object VALUE module) — RETIRED iter-219.
- Sub-step 2 (presheaf `internalHom` + restriction maps) — RETIRED iter-220.
- Sub-step 3 (`dual` object + evaluation morphism `internalHomEval`) — RETIRED iter-224.
- Sub-step 4 (sheaf-level dual `Scheme.Modules.dual`; the sheaf condition / descent to
  `SheafOfModules`) — NEXT, proposed for iter-225.
- Sub-step 5 (`exists_tensorObj_inverse`, the consumer) — final.

### Last 5 iters — extracted signals

| iter | prover status | project sorry | helpers/decls added | blocker phrase |
|---|---|---|---|---|
| 220 | DONE (sub-step 2) | 80 (flat) | ~12 (internalHom assembly) | — |
| 221 | PARTIAL (sub-step 3 start) | 80 (flat) | 6 (dual + internalHomEvalApp + evalLin×4) | `Over.map` coherence |
| 222 | PARTIAL | 80→81 (+1) | 2 (internalHomEvalApp_tmul, restr_map_homMk) | whnf heartbeat bomb |
| 223 | PARTIAL / BLOCKED | 81 (flat) | 0 (reverted own edits) | whnf bomb "goal-wide" |
| 224 | SOLVED | 81→80 (−1) | 0 (verified already-closed) | — (bomb was STALE) |

Note on iter-224: the iter-222/223 "whnf bomb" was a STALE Lean-tactical diagnosis (a
Mathlib bump silently removed it); the plain six-step reduction compiles. `internalHomEval`
is now axiom-clean (`{propext, Classical.choice, Quot.sound}`), sub-step 3 RETIRED, project
sorry 81→80 — the first downward move since iter-217.

### Proposed iter-225 objective (dispatch-sanity check this)

1 file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — `[prover-mode: mathlib-build]`,
build the NEW decl `AlgebraicGeometry.Scheme.Modules.dual` (sub-step 4) by sheafifying the
presheaf dual, following the EXISTING in-file `Scheme.Modules.tensorObj` precedent (which
lands a `SheafOfModules` object via `PresheafOfModules.sheafification`). No new project sorry
expected; success = one new axiom-clean decl + sub-step 4 retired (or a precise hand-off
decomposition if blocked).

### Strategy estimate (verbatim from STRATEGY.md `## Phases & estimations`)

- Phase "A.1.c.SubT.dual": **Iters left ~6–12**; entered its current phase at **iter-219**;
  elapsed at iter-225 = **6**.

### What to return

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + the named corrective TYPE if
not CONVERGING. Specifically weigh: is sub-step retirement genuine convergence, or is the
build churning (each sub-step costs more iters than the last)? Is the proposed sub-step-4
dispatch the right next move, or a helper-churn continuation? Dispatch-sanity: 1 file, in
scope, not a forbidden target.
