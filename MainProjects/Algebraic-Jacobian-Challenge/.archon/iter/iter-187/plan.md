# Iter-187 plan-agent run

## Headline outcome

**The "act on iter-186 semaphore-deadlock debt: priority-dispatch 2
critics; address 7 of 9 CHURNING/STUCK verdicts + 2 must-fix blueprint
findings via 4 plan-phase subagent dispatches + 2 chapter direct edits;
defer 3 prover lanes (B / E / H) per HARD GATE and dispatch 8 lanes;
reorder Lane I per iter-186 CRITICAL circular-dep finding; commit Lane G
strategy decision (project-side Stacks 00NQ formalisation, Option 2 of
3 from `analogies/isregularlocalring-isdomain.md`)" iter.**

iter-186 returned `lake build` GREEN with **76 sorries / 0 axioms**
(7th consecutive zero-axiom build). Net trajectory 82 → 76 (−6). Best-case
band landing. iter-186 plan-phase suffered semaphore deadlock
(`loop.max_parallel=1` + ~33-min refactor monopolised slot; 2
[HIGHLY RECOMMENDED] critics never started). iter-187 plan-phase:
clear that audit debt + act on all surfaced verdicts.

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route187` | **7 of 9 CHURNING/STUCK** — 5 routes flat sorry counts across full 4-iter audit window; 2 routes OVER_BUDGET (Lane H 13/8-12 elapsed; Lane B 5/2-4); 3 must-fix substrate / structural / pivot correctives; planner over-dispatch sanity OK (9/10) but OcOfD ready-but-not-dispatched 3rd iter — flag for must-fix in iter-188 if absent. |
| blueprint-reviewer | `iter187` | **2 MUST-FIX-THIS-ITER items**: MF-1 `RiemannRoch_RRFormula.tex` missing 3 sub-helper `\lean{...}` pins (HARD GATE FAIL for Lane H); MF-2 `AbelianVarietyRigidity.tex` (III.c) not labeled as iter-187 mandatory pivot (HARD GATE PARTIAL for Lane B + Lane E). 6 PASS / 3 PARTIAL / 1 FAIL of 10 dispatched files; 7 soft findings; 2 unstarted-phase gaps (A.2.a / A.2.c file skeletons). |
| strategy-critic | — | SKIPPED (see `## Subagent skips`). |

## Acting on critic findings

The progress-critic returned 7 CHURNING/STUCK verdicts. The
blueprint-reviewer returned 2 must-fix items. Each addressed via
either subagent dispatch this iter, plan-phase direct edit, or
explicit deferral of the affected prover lane per HARD GATE.

| Verdict | Lane | Action this iter |
|---|---|---|
| **Lane A OCofP — CHURNING** | OCofP.lean | **Refactor** dispatched (`refactor ocofp-steps3to5`); Steps 3+4+5 of the recipe from `analogies/ocofp-carrierset-submodule-api.md`. **Plus** prover lane on OCofP with HARD BAR ≥1 pre-existing sorry closure. **Plus** OCofP chapter plan-phase direct edit landing 2 new `\lean{...}` pins for the refactor's Step 3+4 declarations. |
| **Lane A.1.b LineBundlePullback — CONVERGING** | LineBundlePullback.lean | Open NEW IsInvertible follow-up lane (UNCLEAR pending first body attempt) — wrap the 5 axiom-clean iter-186 declarations with `IsInvertible` predicate refinement. ~50-100 LOC. |
| **Lane F QuotScheme — CHURNING** | QuotScheme.lean | `mathlib-analogist quotscheme-isbasechange-tilde` dispatched. **HARD GATE on prover dispatch**: lane fires post-analogist-verdict only. If verdict returns before prover phase ends, prover dispatches per recipe; otherwise defer to iter-188. |
| **Lane H RRFormula — CHURNING + OVER_BUDGET** | RRFormula.lean | `blueprint-writer rrformula-h0h1split` dispatched. Addresses MF-1 (3 `\lean{...}` pins) + H⁰/H¹ split. **STRATEGY.md edit**: Iters left revision. **Lane H prover DEFERRED** to iter-188 per HARD GATE. |
| **Lane I RationalCurveIso — STUCK** | RationalCurveIso.lean | REORDER per iter-186 CRITICAL: `Hom.poleDivisor` body L290 is **SOLE** iter-187 target (per critic: "do NOT dispatch the helper scaffold or the degree helper until the body lands"). ~80-150 LOC. |
| **Lane B GmScaling — STUCK + OVER_BUDGET** | GmScaling.lean | `blueprint-writer avr-iiic-pivot-label` dispatched. Addresses MF-2 + path III.c expansion recipe. **STRATEGY.md edit**: Iters left revision. **Lane B prover DEFERRED** to iter-188 per HARD GATE (chapter PARTIAL). Pivot to III.c IS the chapter-level move iter-187; prover work iter-188. |
| **Lane G AuslanderBuchsbaum — CHURNING** | AuslanderBuchsbaum.lean | **STRATEGY.md decision committed**: Option 2 from `analogies/isregularlocalring-isdomain.md` (project-side Stacks 00NQ formalisation; ~300 LOC across 2-3 iters). iter-187 prover starts **sub-lane G1**: cotangent-space dim drop helper (~80 LOC standalone). Sub-lane G2 (joint induction) iter-188+. |
| **Lane E AVR — CHURNING** | AbelianVarietyRigidity.lean | **DEFERRED** per HARD GATE (chapter PARTIAL on MF-2; blueprint-writer fix lands this iter, iter-188 mandatory reviewer re-confirms, Lane E resumes). The deferral is conservative — Lane E's appTop work is in a sub-section unrelated to (III.c). The fast-path (scoped re-review after writer returns) is not attempted this iter due to iter-186 semaphore-deadlock risk pattern with 4 subagents already queued. |
| **NEW Lane IdentityComponent — UNCLEAR (informational)** | IdentityComponent.lean | File-skeleton extension scaffolding the 5 new chapter pins added iter-186 plan-phase Path B split: `isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`, `baseChangeIso`, `Pic0Scheme.finrank_eq_genus`, `Pic0Scheme.kPoints_iff_kerDegree`. Plus carry forward `identityComponentCarrier` body + `isOpenSubgroupScheme` closed-half closure. |
| **NEW Lane M↓ CodimOneExtension — re-opened** | CodimOneExtension.lean | Chapter PASS (Stacks 00TT block correctly missing `\leanok`; iter-185 writer audit cleared). Lane M↓ re-dispatches on `IsRegularLocalRing` half of `hreg_dim` (~30-80 LOC; gated on `lem:smooth_to_regular_local_ring` Mathlib gap — accept narrow typed sorry if not resolvable). |
| **NEW Lane J OcOfD — under-dispatch correction** | OcOfD.lean | Per critic's "ready but not dispatched" finding (3rd consecutive iter). Target: `sheafOf_zero` body L150 (~30-60 LOC) — `0`-divisor carrier equals structure sheaf via `Sheaf.ext`. |

## Plan-phase direct edits

- `blueprint/src/chapters/RiemannRoch_OCofP.tex` — 2 new pre-existing-block
  insertions before `def:lineBundleAtClosedPoint` (L99-onward) pinning
  the 2 substrate sub-helper declarations the iter-187 refactor will
  produce: `def:lineBundleAtClosedPoint_carrierPresheaf` (`\lean{
  ...carrierPresheaf}`) and `lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf`
  (`\lean{...carrierPresheaf_isSheaf}`). Addresses blueprint-reviewer
  PARTIAL note on `OCofP.lean`. The OCofP chapter is now forward-aligned
  with the iter-187 refactor's expected output.

## Subagent dispatches this plan-phase

| Subagent | Slug | Purpose | Status |
|---|---|---|---|
| `progress-critic` | `route187` | Trajectory verdicts for 9 routes (K=4). | **COMPLETE** — 22.4 KB report; 7 CHURNING/STUCK; 2 OVER_BUDGET; 1 underdispatch flag (OcOfD). |
| `blueprint-reviewer` | `iter187` | Whole-blueprint audit; 3 unaudited chapter touches; HARD GATE for 10 dispatched files. | **COMPLETE** — 25.2 KB report; 2 must-fix; 6 PASS / 3 PARTIAL / 1 FAIL of 10; 2 unstarted-phase gaps. |
| `mathlib-analogist` | `quotscheme-isbasechange-tilde` | `IsBaseChange` + `IsQuasiCoherent` + `Tilde` idiom consult for Lane F Step 4. Reactive (per progress-critic CHURNING corrective). | DISPATCHED (in flight). |
| `blueprint-writer` | `rrformula-h0h1split` | MF-1 (3 sub-helper `\lean{...}` pins) + progress-critic CHURNING corrective (H⁰/H¹ split with `% NOTE` annotation). Single chapter `RiemannRoch_RRFormula.tex`. | DISPATCHED (queued behind analogist). |
| `blueprint-writer` | `avr-iiic-pivot-label` | MF-2 ((III.a) BLOCKED label, (III.b) DESCOPED label, (III.c) MANDATORY PIVOT label + expanded recipe sketch). Single chapter `AbelianVarietyRigidity.tex`. | DISPATCHED (queued). |
| `refactor` | `ocofp-steps3to5` | Lane A CHURNING corrective. Steps 3+4+5 of the OCofP recipe — `carrierPresheaf` functor + `carrierPresheaf_isSheaf` sheaf property + replace `lineBundleAtClosedPoint` body L397. HARD BAR (refactor): land Step 5 (which closes the L397 pre-existing sorry — net −1 at minimum). | DISPATCHED (queued). |

## STRATEGY.md edits this iter

The progress-critic explicitly recommended row-level edits for 2
OVER_BUDGET rows + 1 Open Q resolution. I am applying:

1. **Genus-0 RR.2 row** (`RRFormula.lean` / Lane H): "Iters left ~8–12"
   → "~6–14 (revised; H¹ flasque-vanishing half gated on Mathlib upstream
   or ~150-300 LOC project formalisation off critical path; H⁰ half
   ~30-60 LOC iter-187+)". Reason: 13 elapsed exceeds 8-12; the H¹
   flasque-cohomology gap surfaced iter-186 is a hard substrate that
   wasn't priced into the original estimate.

2. **Genus-0 rigidity chart-bridge cross-case body row** (`GmScaling.lean`
   / Lane B): "Iters left ~2–4" → "~3–5 (revised; III.a/III.b descoped
   per iter-187 progress-critic STUCK; III.c separated-locus alternative
   committed; estimate covers III.c body landing)". Reason: 5 elapsed
   exceeds 2-4; the (III.a)/(III.b) paths are confirmed blocked at
   Mathlib `b80f227` and III.c is now the committed path.

3. **A.4.b row** (`AuslanderBuchsbaum.lean` / Lane G): "Iters left
   ~12–20" → "~10–18 (revised; project-side Stacks 00NQ formalisation
   committed per analogies/isregularlocalring-isdomain.md Option 2;
   iter-187 starts sub-lane G1 cotangent-space dim drop ~80 LOC;
   sub-lane G2 joint induction ~200 LOC iter-188+)". Reason: critic
   demanded the deferral-decision be written; Option 2 is the only
   feasible Mathlib-gap-fill path (Option 3 Mathlib-upstream PR is
   parallel multi-week and outside the loop's control).

4. **Open Q "Axiomatise-then-replace — Route A"** — no change; trigger
   condition (Route A velocity stays ~0/it on file-skeleton lanes for
   two consec iters) NOT met (LineBundlePullback iter-186 closed 5 → 0
   axiom-clean; QuotScheme has substantive structural progress despite
   flat sorry count).

These are row-level estimate refreshes per progress-critic findings;
they are NOT strategic re-thinks. Strategy-critic dispatch unnecessary
per its skip conditions.

## Subagent skips

- **strategy-critic**: STRATEGY.md SHA was unchanged from iter-185 entering
  iter-187 (iter-186 plan-phase did not edit STRATEGY.md); the iter-187
  edits above are row-level estimate refreshes per progress-critic
  findings, NOT strategic re-thinks. Prior iter-185 strategy-critic
  verdict was SOUND with no live CHALLENGE/REJECT. Skip conditions met.

## Decision made

### Decision 1 — Lane G commit to Option 2 (Stacks 00NQ project formalisation)

Per progress-critic's CHURNING corrective on Lane G ("commit to Koszul
bypass OR start Stacks 00NQ formalisation; write decision into
STRATEGY.md"), I commit to **Option 2 from
`analogies/isregularlocalring-isdomain.md`**: project-side formalisation
of Stacks 00NQ across 2-3 iters via sub-lanes G1 + G2.

- **Why**: the analogist explicitly verified that the joint induction
  shared between `IsRegularLocalRing → IsDomain` and
  `exists_isRegular_of_regularLocal` cannot be cheaply isolated
  (NO_USEFUL_ALTERNATIVE verdict). Option 1 (pivot to off-target depth
  lemmas) is exhausted — both `depth_eq_smallest_ext_index` and
  `depth_of_short_exact` closed iter-184. Option 3 (Mathlib upstream PR)
  is parallel multi-week and outside the loop's control. Option 2 is the
  only feasible critical-path move.

- **LOC/risk trade-off**: ~300 LOC across 2-3 iters; 1 substantial
  sub-helper (cotangent-space dim drop ~80 LOC, standalone reusable).
  The first sub-lane G1 is iter-187 work; sub-lane G2 (joint induction
  ~200 LOC) is iter-188+. Risk: induction step requires fine ring-theory
  manipulation (prime avoidance, Krull intersection, Nakayama) but
  all Mathlib substrate is present at b80f227.

- **Cheapest signal to reverse**: if iter-187 sub-lane G1 takes more
  than ~3 iters with helper accumulation pattern (CHURNING signature),
  revisit Option 3 (Mathlib upstream PR) by surfacing the gap to the
  user via `TO_USER.md` and accepting a multi-week wait.

### Decision 2 — Lane I REORDER per iter-186 CRITICAL finding

Per iter-186 review's `recommendations.md` critical item −1 and the
iter-187 progress-critic STUCK verdict: `Hom.poleDivisor` body (L290)
must be the **SOLE** iter-187 target for Lane I, not the helper scaffold.
The iter-186 directive misread the dep order ("close helper iter-186,
def body iter-187+") — actually `Hom.poleDivisor φ = sorry` definitionally
means the helper body cannot progress past `unfold Hom.poleDivisor`
which leaves literal `sorry` in the goal. iter-187 dispatches Lane I
exclusively on `Hom.poleDivisor` body via direct Finsupp construction
on `φ⁻¹(∞)` or Weil-divisor pullback infrastructure.

### Decision 3 — Lane B/E/H prover work DEFERRED (HARD GATE per blueprint-reviewer)

3 lanes are deferred to iter-188 pending the blueprint-writer fixes
landing iter-187 plan-phase + iter-188 mandatory blueprint-reviewer
re-confirmation. The fast-path (scoped re-review THIS iter) is not
attempted because the iter-186 semaphore-deadlock pattern with 4
subagents already queued risks recreating that failure. The 1-iter
latency cost is acceptable. Lane B's path-III.c pivot IS happening as
a chapter-level move this iter; only the prover work is deferred.

### Decision 4 — Lane A OCofP refactor + concurrent prover dispatch

Per progress-critic CHURNING corrective + HARD BAR ≥1 pre-existing
sorry closure: I dispatch BOTH the refactor (for Steps 3+4+5) AND a
prover lane on OCofP.lean. The refactor lands the structural changes
(Step 5 mechanically closes the L397 pre-existing sorry); the prover
then attacks the cascade — `toFunctionField` L418,
`globalSections_iff_{mp,mpr}` L480/L526 — to attempt deeper closures.
This is the same parallel pattern that landed iter-186's best-case
LineBundlePullback closures.

## Iter-186 outcomes ingested

Processed all 9 iter-186 prover task_results; moved closures to
`task_done.md` (10 new entries including all 5 LineBundlePullback decls
+ R⧸(x) bridge + 3 carrierSubmodule closures + 2 instance helpers +
`eulerCharacteristic_iso`); updated `task_pending.md` with iter-186
states + iter-187 directives. Task_results cleared.

## Quota envelope

`max_account` weekly quota: resets **2026-05-28T07:00:00Z** (~57 hours
out from iter-187 start at 2026-05-25T23:48:00Z). iter-186 returned 0
NOT_DISPATCHED so quota is HEALTHY. iter-187 cadence: 8 prover lanes +
4 plan-phase subagents. With `loop.max_parallel=1`, the 4 plan-phase
subagents serialise (~60-120 min total). Prover phase will benefit
from the post-reset full cadence.

## Tool substitutions

None this iter.

## Next iter (iter-188) preliminary commitments

1. **Mandatory blueprint-reviewer iter188** re-confirms the iter-187
   writer fixes on `RiemannRoch_RRFormula.tex` (MF-1) and
   `AbelianVarietyRigidity.tex` (MF-2). On clearance, Lane B + Lane E +
   Lane H prover work resumes iter-188.
2. **Mandatory progress-critic iter188** verifies that iter-187's
   correctives moved the needle (especially: Lane A pre-existing
   sorry closes; Lane I `Hom.poleDivisor` body; Lane F if analogist
   verdict arrives).
3. **Lane B prover** iter-188 dispatches with III.c separated-locus
   recipe (per iter-187 blueprint-writer's expansion).
4. **Lane G sub-lane G2** (joint induction, ~200 LOC) iter-188+ once
   sub-lane G1 cotangent dim drop lands.
5. **Lane H prover** iter-188 closes H⁰ half of skyscraper-χ (~30-60
   LOC axiom-clean via the constantSheafGammaHom chain).
6. **Lane E AVR** iter-188 executes the 6-step appTop recipe (per
   iter-187 progress-critic corrective).
7. **Lane I follow-up** iter-188 (if `Hom.poleDivisor` body lands
   iter-187): instantiate the helper's 5-step
   `Ideal.sum_ramification_inertia` scaffold; close Pin 3 `iso_of_degree_one`
   in parallel.
8. **Lane A OCofP cascade** iter-188 cascades remaining `toFunctionField`
   / `globalSections_iff_{mp,mpr}` post Step-5 body land.
