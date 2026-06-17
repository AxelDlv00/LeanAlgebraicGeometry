# progress-critic directive — slug `route201`

## Iter context

iter-201 plan-agent decision: dispatch 3 Route A prover lanes
(WD-A4a-Sub-build-2, AB-Stacks-00MF, COE-Stage6.B-Jacobian) under
mathlib-build mode, USER 2026-05-28 standing directive.

Verdict your goal: per-route convergence assessment. Use the
extracted signals below; do not read STRATEGY.md, blueprint chapters,
or other agents' iter-by-iter narrative — your value is the narrow
trajectory view.

## Routes under consideration

### Lane WD-A4a (`RiemannRoch/WeilDivisor.lean`)

Phase: A.4.a — codim-1 + Weil-divisor substrate (`priority-1 root`).
STRATEGY.md current Iters left: `~3-6`. Phase entered iter-186
(post-LineBundlePullback iter-188 done + iter-183 CoheightBridge
substrate).

Last 5 iters' signals:

| Iter | Sorries | Helpers added | Status | Blocker phrases |
|---|---|---|---|---|
| 196 | 3 | +1 (`positivePart` simp helper) | done | none |
| 197 | 3 | +0 (no edits) | done | (RR.1 file frozen, scope fence in place) |
| 198 | 3 | +0 (no edits) | done | RR.1 scope fence; PUSH-BEYOND not attempted (carrier-soundness lane on FGA) |
| 199 | 3 | +2 (`order_neg`, `order_pow_of_ne_zero` §2 helpers axiom-clean) | done (PARTIAL) | 3 Mathlib-pending sub-builds (Sub-build 1 / 2 / 3) named |
| 200 | 3 | +8 (PrimeDivisor.ext, restrictToOpen, ofOpen, +2 simp, equivOpen, stalkIso, IsRegularInCodimensionOne.instOpen) +120 LOC | done (HARD BAR MET) | "out-of-scope per analogist Decision 5 = iter-201+ Sub-build 2" |

Proposed iter-201 directive: Sub-build 2 — `Ring.ordFrac` transport
across the iter-200 `Scheme.PrimeDivisor.stalkIso` ring iso. Per the
iter-200 prover handoff: budget ~30-50 LOC project-side; Mathlib gap
candidate signature in the task report. The prior 5 iters of substrate
work have produced exactly one HARD BAR landing (iter-200); prior to
that, 4 iters of varied substrate / RR.1 scope fence with sorry count
held at 3.

### Lane AB (`Albanese/AuslanderBuchsbaum.lean`)

Phase: A.4.b — Auslander–Buchsbaum (n=k+1) (`priority-1 root`).
STRATEGY.md current Iters left: `~3-6`. Phase entered iter-167.

Last 5 iters' signals:

| Iter | Sorries | Helpers added | Status | Blocker phrases |
|---|---|---|---|---|
| 196 | 1 | +0 | done | (gap (4) closed iter-194; gaps (1)-(3) remain) |
| 197 | 1 | +2 (substrate iter-178 helpers reviewed clean) | done | gap (1) "Nat-recursive" framing |
| 198 | 1 | +2 (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` + `exists_isSMulRegular_of_one_le_depth`) axiom-clean | done (gap (4) CLOSED) | gap (1) "Nat-recursive" |
| 199 | 1 | +1 (`exists_minimalSurjection_finite_localRing` axiom-clean per-syzygy step) | done | "Nat-recursive iterated resolution iter-200" |
| 200 | 1 | +4 (`hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`, `hasProjectiveDimensionLT_ker_of_surjection`, `…_succ_of_…_ker`, `depth_ker_ge_min_…`) axiom-clean ALIGN_WITH_MATHLIB pivot | done (HARD BAR NOT MET) | "blocked on Stacks 00MF base case + ℕ∞ arithmetic" |

Proposed iter-201 directive: continue AB-gap1 chain — close
`auslander_buchsbaum_formula_succ_pd` body either via (Path A) Stacks
00MF substrate build (~150-200 LOC; blueprint chapter 00MF recipe
added iter-201) or (Path B) LES connecting-map injectivity sidestep
obviating 00MF (analogist `ab-stacks00mf` dispatched iter-201 to
pick between).

### Lane COE (`Albanese/CodimOneExtension.lean`)

Phase: A.4.c.0 — codim-≥2 conclusion (`priority-2`). STRATEGY.md
current Iters left: `~5-9`. Phase entered iter-181.

Last 5 iters' signals:

| Iter | Sorries | Helpers added | Status | Blocker phrases |
|---|---|---|---|---|
| 196 | 3 | +0 | done | (Stages 1-5b substrate iter-191-193 reviewed) |
| 197 | 3 | +0 | done | "Stage 6 sub-decomposition iter-198" planning iter |
| 198 | 3 | +3 (Stage 6 sub-gap (i) discharger + 6.B-RHS substrate + bundled wrapper axiom-clean) | done (sub-gap (i) DISCHARGED) | "(ii.A) + (ii.B) remain" |
| 199 | 3 | +4 (4 Stage 6.B closed-point cotangent↔Kähler helpers axiom-clean Stacks 02JK) | done (sub-gap (ii.A) CLOSED) | "trailing sorry narrowed to (ii.B)" |
| 200 | 3 | +7 (Step 1+2 fully + Step 3 additive form) | done (HARD BAR MET) | "Step 3 = Jacobian-regular-sequence witness iter-201+" |

Proposed iter-201 directive: continue COE-Stage 6.B — build the
Jacobian-regular-sequence witness substrate (Stacks 00SW/00OW) and
attempt L1061 inline closure. The 4 most recent iters have all met
HARD BAR via substantive substrate landings; iter-200 lands +7
axiom-clean decls in this lane alone (~165 LOC); iter-201 closure
recipe ~30-60 LOC witness + ~30-50 LOC scheme-to-algebra bridge.

## Strategy estimates vs. realized

- **WD**: STRATEGY says 3-6 iters / 60 LOC per iter substrate. iter-200
  realized 120 LOC (above velocity). 5 iters elapsed since phase enter
  (iter-186); 0 of the 3 sorries closed; substrate forward-compatible.
- **AB**: STRATEGY says 3-6 iters / 50 LOC per iter. iter-200 realized
  ~45 LOC. 33 iters elapsed since phase enter (iter-167); 0 sorries
  closed under current decomposition (gap (4) closure iter-194 was an
  obviation rather than a sorry closure). 4 axiom-clean helpers landed
  iter-200; the body sorry remains.
- **COE**: STRATEGY says 5-9 iters / 55 LOC per iter. iter-200
  realized ~165 LOC. 19 iters elapsed since phase enter (iter-181);
  0 sorries closed; substantive 18+ axiom-clean substrate decls landed
  across Stages 1-5b + 6.A + 6.B-iiA + 6.B-iiB across iter-191-200.

## What I check

1. CONVERGING / CHURNING / STUCK / UNCLEAR for each lane.
2. iter-201 directive evaluates (Sub-build 2 for WD; close-or-substrate
   for AB; Jacobian witness + L1061 for COE).
3. Any dispatch-sanity check on the iter-201 PROGRESS.md `## Current
   Objectives` list (3 files: WeilDivisor, AuslanderBuchsbaum,
   CodimOneExtension).

## Output format

Verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR) + named
corrective TYPE for CHURNING/STUCK. Must-fix-this-iter items only
for CHURNING/STUCK. Suggest mode if a route should switch from
mathlib-build to something else.
