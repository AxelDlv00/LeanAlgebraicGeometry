# Progress critic directive — iter-141

## Strict context discipline

Do NOT read `STRATEGY.md`, blueprint chapters, `iter/iter-NNN/{plan,review}.md`,
`PROJECT_STATUS.md`, `task_pending.md`, or `task_done.md`. You read ONLY this
directive (and any signal sources it names — currently none beyond what's
inlined).

## Active route under consideration this iter

**Route**: piece (i.b) Step 2 of the M2.body-pile (`Cotangent/GrpObj.lean`).
The planner is weighing whether to dispatch a prover lane on this route
again for the **fourth consecutive iter** (iter-138 → iter-139 [plan-only,
intentional deferral via blueprint-reviewer HARD GATE] → iter-140 →
iter-141 [planning now]).

The 3 sub-sorries that have been the prover target are:
- `d_app` of `basechange_along_proj_two_inv_derivation` (Cotangent/GrpObj.lean L624 iter-141 entry, was L581 iter-138 entry).
- `d_map` of same (L643 iter-141 entry, was L585 iter-138 entry).
- `IsIso` of `relativeDifferentialsPresheaf_basechange_along_proj_two` (L689 iter-141 entry, was L624 iter-138 entry; iter-140 refactored from "whole iso" to "per-open iso" via private helper `isIso_of_app_iso_module`).

There is one further sorry in the same file at L817 (`mulRight_globalises_cotangent`
Main composition; downstream of these 3; not a prover target this iter
per iter-140 plan).

## Signals (K=5: iter-136 through iter-140)

### Sorry counts (per-file)

| Iter | `Cotangent/GrpObj.lean` decls / inline | Project total decls / inline | Source |
|---|---|---|---|
| iter-136 end | 1 / 1 (Main only; Step 3 closed) | 4 / 4 | iter-136 sidecar |
| iter-137 end | 1 / 1 (Main; iter-137 plan-only docstring expansion + analogist consult, no Lean changes) | 4 / 4 | iter-137 sidecar |
| iter-138 end | 3 / 4 (Main L752 + helper inner L581 d_app + helper inner L585 d_map + main inner L624 IsIso) | 6 / 7 | iter-138 sidecar review |
| iter-139 end | 3 / 4 (unchanged; iter-139 plan-only, intentional HARD GATE deferral; blueprint-writer expansion on `RigidityKbar.tex` only) | 6 / 7 | iter-139 sidecar |
| iter-140 end | 3 / 4 (unchanged in strict count; iter-140 prover lane added private helper `isIso_of_app_iso_module` + IsIso scaffold narrowing from "whole iso" `letI := sorry` to "per-open iso" `letI := isIso_of_app_iso_module ... (fun _ => sorry)`; d_app `change`-tactic scaffolding added; d_map closure-recipe docstring added) | 6 / 7 | iter-140 task_results/Cotangent_GrpObj.lean.md |

### Helpers added per iter (in `Cotangent/GrpObj.lean`)

| Iter | New declaration(s) | LOC | Status |
|---|---|---|---|
| iter-138 | `basechange_along_proj_two_inv_derivation` (~38 LOC + 11 LOC doc); `basechange_along_proj_two_inv` (~15 LOC) | ~64 LOC + docs | New helpers; d_app + d_map carry sorries; d_add + d_mul closed honestly |
| iter-139 | — (plan-only) | 0 | No Lean changes; +468 LOC blueprint expansion on `RigidityKbar.tex` |
| iter-140 | `isIso_of_app_iso_module` (~5 LOC body + 7 LOC doc; private) + d_app `change` scaffolding (~17 LOC) + d_map docstring (~18 LOC) + `import Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced` | ~47 LOC | Helper closes its own goal; IsIso sub-sorry narrowed to per-open variant; d_app/d_map sub-sorry bodies unchanged |

### Prover statuses

| Iter | Prover lane status | Specific outcome |
|---|---|---|
| iter-138 | PARTIAL with substantive body cut | Route (b) skeleton landed end-to-end; d_add + d_mul of pointwise derivation closed honestly; d_app + d_map + IsIso sub-sorries decomposed from 1 hollow → 3 narrow well-typed sub-sorries |
| iter-139 | n/a (plan-only, HARD GATE deferral) | Intentional skip; blueprint expansion only |
| iter-140 | PARTIAL with structural advance on IsIso path | 0 of 3 sub-sorries closed by strict sorry count; private helper `isIso_of_app_iso_module` added (5 LOC bridge mirroring `Scheme.Modules.Hom.isIso_iff_isIso_app`); IsIso sub-sorry restructured from "whole iso" to "per-open iso"; d_app `change`-tactic scaffolding committed (validated standalone via `lean_run_code`); d_map `change`-tactic attempted but reverted due to deterministic `whnf` timeout at `maxHeartbeats=200000` on `(pushforward ψ).obj LHS).map f` opacity |

### Recurring blocker phrases (across the K-window)

- iter-137: "PresheafOfModules.pullback chart-opacity" (Mathlib's `PresheafOfModules.pullback` is defined as `(pushforward φ).leftAdjoint` — opaque on `.obj`/`.map`). RESOLVED iter-138 via helper-pair refactor (the project introduced `basechange_along_proj_two_inv_derivation` + `basechange_along_proj_two_inv` to side-step the opacity via inverse-direction-via-adjunction-transpose; the helper-pair refactor did not re-encounter this blocker).
- iter-138: "well-definedness of d_app + cross-open d_map naturality + IsIso check" — three narrow sub-sorries.
- iter-140: NEW blocker phrase: "deterministic `whnf` timeout at `maxHeartbeats=200000` on `(pushforward ψ).obj.map` opacity" for the d_map `change`-based approach (iter-140 reverted the `change`; only docstring committed).
- iter-140 also identified an explicit factoring-lemma recipe for d_app (`have h : ... ; rw [heq]; exact ...map_algebraMap`) validated standalone via `lean_run_code`.

### Cumulative (i.b)-side build (LOC, post-iter-140 close)

Approx. ~485 LOC of (i.b)-side build (iter-134 shearMulRight ~50 LOC + iter-136 Step 3 ~27 LOC + iter-138 helpers ~63 LOC + iter-140 helper + scaffolds ~47 LOC + iter-138/iter-140 docstring expansions ~298 LOC). Below the iter-138-renormalised 1000 LOC arm of trigger (a')/(c) by ~515 LOC.

## Acceptance criteria the iter-140 plan agent pre-committed (verbatim)

- **PASS** (CONVERGING-confirmed for iter-141): ≥2 of 3 sub-sorries closed substantively. Sorry count 6 decls → ≤4 decls. — **NOT MET**
- **PARTIAL** (CHURNING-trigger for iter-141): 0 or 1 sub-sorries closed. — **MET (0 of 3 closed strictly)**
- **FAIL** (STUCK for iter-141): 0 sub-sorries closed AND `PresheafOfModules.pullback` chart-opacity blocker phrase resurfaces. — **NOT MET** (the iter-137 blocker phrase did not resurface; iter-140's blocker is the NEW `(pushforward ψ).obj.map whnf timeout`).

## Your task

Per route, render:

- **Verdict**: CONVERGING / CHURNING / STUCK / UNCLEAR.
- **Reasoning**: which signals you weighted and how.
- **Corrective recommendation** (if CHURNING or STUCK): name the specific
  action (blueprint expansion, mathlib-analogist consult, refactor, route
  pivot, user escalation).

Specifically, weigh:

1. The iter-140 acceptance criterion strictly maps the outcome to
   CHURNING. Does the structural IsIso narrowing + factoring-lemma
   discovery for d_app count as "structural advance" enough to flip
   to UNCLEAR (the new blocker is different from iter-137's)?
2. The 4-consecutive-iter pattern on the same 3 sub-sorries — what's
   the appropriate corrective?
3. Is the planner about to ratify its own iter-140 pre-commitment too
   strictly, or is the strict-count criterion the right call?

## Off-route signals you do NOT need to weigh in on

You do NOT need to render a verdict on the M2.a body, M2.b body, M3
positiveGenusWitness, M1.d off-loop PR lane, piece (iii) scheme-Frobenius
build (iter-144+), or any other route. Your sole focus is piece (i.b)
Step 2 in `Cotangent/GrpObj.lean`.
