# Progress critic directive — iter-200 slug route200

## Active routes / files (planner's iter-200 prover-objective composition)

The planner is considering these 6 routes for iter-200 prover assignment.
For each route, the planner is considering ACTION (dispatch / hold / re-route).

### Route: Lane WD-A4a — `WeilDivisor.lean` L325 (`rationalMap_order_finite_support`)
- planner action this iter: DISPATCH (Sub-build 1 = open-immersion stalk-bridge for prime divisors)
- file path: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- blueprint chapter: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
- STRATEGY phase row: A.4.a, `Iters left: ~3–6`, phase entered iter-198 (Route A bottom-up framing) → elapsed 2 iters

### Route: Lane AB — `AuslanderBuchsbaum.lean` L1432 (`auslander_buchsbaum_formula_succ_pd`)
- planner action this iter: DISPATCH (gap (1) Nat-recursive iterated minimal-free-resolution on the iter-199 axiom-clean per-syzygy substrate)
- file path: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- blueprint chapter: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
- STRATEGY phase row: A.4.b, `Iters left: ~3–8` (refreshed iter-200), phase entered iter-195 → elapsed 5 iters
- iter-199 progress-critic verdict: STUCK (blueprint expansion corrective DONE iter-200 via new `\subsec:ab_gap1_first_step` section + per-gap effort table refresh)

### Route: Lane COE — `CodimOneExtension.lean` L1101 (`isRegularLocalRing_stalk_of_smooth`)
- planner action this iter: DISPATCH (Stage 6 sub-gap (ii.B) Stacks 00OE Krull-dim formula)
- file path: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- blueprint chapter: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- STRATEGY phase row: A.4.c.0, `Iters left: ~6–10`, phase entered iter-193 → elapsed 7 iters
- iter-199 progress-critic verdict: CHURNING (blueprint expansion corrective: already done iter-198 with explicit (ii.A)/(ii.B) per-step LOC; STRATEGY estimate widening DONE iter-200 via velocity refresh ~30/it → ~50/it)

### Route: Lane FGA — `FGAPicRepresentability.lean`
- planner action this iter: HOLD
- file path: `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
- blueprint chapter: `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- STRATEGY phase row: A.2.c, `Iters left: ~12–16`, phase entered iter-196 (carrier-soundness probe) → elapsed 4 iters
- iter-199 progress-critic verdict: STUCK (plan-phase-only meta-pattern); iter-199 prover dispatch closed Sorry 4 via carrier-soundness refactor (theorem body axiom-clean); remaining 7 ⟨sorry⟩ instances split rank-1 (A.1.c-gated, HELD) and rank-3 (Route C blocked); HOLD justification: no plausible single-iter closure without re-introducing placeholder-body headline-laundering

### Route: Lane RPF — `RelPicFunctor.lean` L235 (`addCommGroup`)
- planner action this iter: HOLD (no prover); DISPATCH blueprint-writer for new `Picard_TensorObjSubstrate.tex` chapter; iter-201+ prover lane committed in STRATEGY
- file path: `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- blueprint chapter: `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- STRATEGY phase row: A.1.c (+ A.1.c.SubT), `Iters left: ~3–5 (post-SubT)`, phase entered iter-188 → elapsed 12 iters
- iter-199 progress-critic verdict: STUCK + OVER BUDGET (Lane RPF L235; primary corrective DONE iter-200 via explicit A.1.c.SubT row commitment + blueprint-writer dispatch this iter)

### Route: Lane T32 — `Thm32RationalMapExtension.lean` L155 (`isReduced_of_smooth_over_field`)
- planner action this iter: HOLD (per iter-198 5-approach exhaustion; binding trigger: `COE Stage 6.B Krull-dim formula closed`)
- file path: `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
- blueprint chapter: `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
- STRATEGY phase row: A.4.c.1, `Iters left: ~8–14`, phase entered iter-196 → elapsed 4 iters
- iter-199 progress-critic verdict: UNCLEAR (re-routed as Lane COE derivative iter-199; binding trigger condition explicit)

## Last K=5 iters signals (iter-195 to iter-199)

| Iter | WD sorries | AB sorries | COE sorries | FGA sorries | RPF sorries | T32 sorries |
|------|------------|------------|-------------|-------------|-------------|-------------|
| 195  | 4          | 1          | 3           | 7           | 6           | 2           |
| 196  | 4          | 1          | 3           | 7           | 6           | 2           |
| 197  | 4          | 1          | 3           | 7           | 6           | 2           |
| 198  | 3          | 1          | 3           | 7           | 1           | 2           |
| 199  | 3          | 1          | 3           | 7           | 1           | 2           |

| Iter | WD helpers | AB helpers | COE helpers | FGA helpers | RPF helpers | T32 helpers |
|------|------------|------------|-------------|-------------|-------------|-------------|
| 195  | 0          | 2          | 0           | 0           | 0           | 0           |
| 196  | 0          | 0          | 0           | 0           | 0           | 0           |
| 197  | 0          | 0          | 0           | 0           | 0           | 0           |
| 198  | 6          | 2          | 3           | 0           | 0           | 0           |
| 199  | 2          | 1          | 4           | 0 (refactor)| 0           | 0           |

| Iter | WD prover status | AB prover status | COE prover status | FGA prover status | RPF prover status | T32 prover status |
|------|-------------------|-------------------|--------------------|--------------------|--------------------|--------------------|
| 195  | N/A               | PARTIAL          | N/A                | N/A                | N/A                | N/A                |
| 196  | N/A               | N/A              | N/A                | N/A                | N/A                | N/A                |
| 197  | N/A               | N/A              | N/A                | N/A                | N/A                | N/A                |
| 198  | PARTIAL           | PARTIAL          | PARTIAL            | N/A                | PARTIAL (placeholder)| INCOMPLETE         |
| 199  | INCOMPLETE        | PARTIAL          | PARTIAL            | PARTIAL (refactor) | N/A (held)         | N/A (held)         |

Recurring blocker phrases:
- WD: "open-immersion stalk-bridge for prime divisors (Stacks 02IZ/005X) missing in Mathlib" (iter-199 first occurrence; new this iter)
- AB: "3-gap structure (gaps 1/2/3) substrate-build" (iter-195 onwards; gap 1 per-syzygy step closed iter-199 reducing to (1-Nat-recursive / 2 / 3))
- COE: "Stage 6 sub-gap (ii.B) Stacks 00OE Krull-dim formula" (iter-198 onwards; (ii.A) closed iter-199)
- FGA: "no concrete sorry-closure plan / plan-phase-only stall" (iter-194 onwards; structurally addressed iter-199 via carrier-soundness refactor)
- RPF: "Scheme.Modules.tensorObj upstream Mathlib gap" (iter-188 onwards; iter-200 STRATEGY commits explicit project-side build path)
- T32: "no Smooth → IsReduced bridge in Mathlib" (iter-198 first surfaced; Lane COE derivative re-routing)

## PROGRESS.md proposal this iter

`## Current Objectives`: 3 lanes — WD (Sub-build 1), AB (gap (1) Nat-recursive), COE (sub-gap (ii.B)).
Held: RPF, FGA, T32, RCI — each with explicit rationale in PROGRESS.md and iter sidecar.

## Your task

Per your dispatcher_notes: verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR);
dispatch-sanity check on the 3-lane composition (under-dispatch given 6 routes? File-count check);
must-fix-this-iter items if CHURNING or STUCK.

Do NOT receive STRATEGY.md, blueprint chapters, iter sidecars' full content, or PROGRESS.md beyond the proposal above. Your value is the fresh narrow trajectory view, not strategic re-evaluation.

Report to `task_results/progress-critic-route200.md`.
