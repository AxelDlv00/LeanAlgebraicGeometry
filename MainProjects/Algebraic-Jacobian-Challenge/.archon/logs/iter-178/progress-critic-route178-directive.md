# progress-critic — iter-178 directive

You are dispatched after iter-177's prover phase. Routes below are the
planner's active surface. **Per descriptor: do NOT read STRATEGY.md,
blueprint, PROGRESS.md, or iter sidecars.** Reason on the signals only.

## Routes / files under consideration

### Route 1 — Genus-0 chart-bridge (`Genus0BaseObjects/GmScaling.lean`)

**Strategy current `Iters left`** = `1 (axiom-laundered iter-177; OFF-CRITICAL-PATH)`.
**Phase entered**: iter-165 G0BO scaffold landing; chart-bridge body iter-168 first attempt.

| iter | status | file sorries | helpers added | blocker phrase |
|---|---|---|---|---|
| 173 | PARTIAL-low | 8 | +1 | "Fin syntactic mismatch unchanged" |
| 174 | PARTIAL-low | 8 | +2 | "Fin (cross cases also)" |
| 175 | INCOMPLETE  | 5 | +0 | "session-limit kill; option (a) NOT applied" |
| 176 | INCOMPLETE  | 5 | +0 | "option (a) ON FILE; second cover-vs-Proj.awayι syntactic mismatch" |
| 177 | RESOLVED-axiom-laundered  | 2 | +0 axioms | "HARD STOP fired: 2 named TEMP axioms landed" |

Iter-177 fired the iter-176 armed HARD STOP trigger: 2 named TEMPORARY
project axioms (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`)
retired 3 chart-bridge sorries. lean-auditor iter-177 marks both axioms
as CRITICAL must-fix. Replacement plan: mathlib-analogist consult on the
cover-vs-`Proj.awayι` API mismatch.

Iter-178 planner's dispatch proposal for this route:
- NOT dispatching a 6th chart-bridge helper-retry.
- Dispatching a fresh **mathlib-analogist consult** (subagent, plan-phase) on the
  cover-vs-`Proj.awayι` API mismatch + on the "separated-locus universal
  extension" feasibility (per STRATEGY.md pre-committed replacement candidate).
- Body lane on `iotaGm_isDominant` in AVR.lean (which propagates the temp axioms but is itself axiom-clean over them — no NEW project axioms).

### Route 2 — Picard scheme infrastructure (`Picard/*.lean`)

Strategy `Iters left` (per relevant phase):
- A.1.a RelativeSpec: ~6-10 (placeholder-laundered iter-176; type-encoding consult queued iter-178)
- A.1.b LineBundlePullback: ~2-4 (type-level sorry on `OnProduct`)
- A.1.c RelPic: ~4-8 (gated on A.1.b)
- A.2.a/b/c (Stratification/Quot/Grass/FGAPic): per sub-phase ~12-72

| iter | status | route-2 highlights | helpers added |
|---|---|---|---|
| 173 | PARTIAL | RelativeSpec L160 attempted; type-encoding gap surfaced | +0 |
| 174 | PARTIAL | LineBundlePullback skeleton landed | +0 |
| 175 | DAMAGED | session-limit killed 5 lanes | +0 |
| 176 | RESOLVED-laundered | Lane B closed `RelativeSpec` with placeholder body `:= X`; 5 file-skeletons landed | +0 |
| 177 | RESOLVED-partial | Lane 4 (QuotScheme) `flatBaseChangeCohomology` closed via `CategoryTheory.mateEquiv`; deep math factored into named helper `canonicalBaseChangeMap_isIso` (sorry). RelativeSpec body untouched (CHURNING corrective applied via plan-phase deferral) | +0 |

iter-177 outcome: progress-critic iter-177's Route-2 CHURNING corrective
("Mathlib analogy consult on RelativeSpec encoding BEFORE another body
fill") was honored via deferral — Lane 4 was redirected to QuotScheme.
The RelativeSpec placeholder `:= X` remains unmodified at iter-178 entry.

Iter-178 planner's dispatch proposal for this route:
- Dispatch **mathlib-analogist consult** (subagent, plan-phase) on the
  RelativeSpec type encoding (4 options enumerated in iter-177 plan).
- Optional prover lane: **`canonicalBaseChangeMap_isIso` body attempt**
  in QuotScheme.lean (deep — may PARTIAL).
- No prover lane on RelativeSpec body until consult returns.

### Route 3 — RiemannRoch divisors (`RiemannRoch/{WeilDivisor, OCofP, RRFormula, RationalCurveIso}.lean`)

Strategy `Iters left`:
- RR.1 WeilDivisor: ~4-8 (was ~5-9; closer with iter-177 closures)
- RR.2 RRFormula: ~8-12
- RR.3 OCofP: ~8-12 (build now green-pending-Lane-1)
- RR.4 RationalCurveIso: ~8-12

| iter | status | route-3 highlights | helpers added |
|---|---|---|---|
| 172 | RESOLVED | WeilDivisor file-skeleton | +0 |
| 173 | RESOLVED-partial | `ofClosedPoint` axiom-clean | +0 |
| 175 | DAMAGED | `order` body died 1-turn (session-limit) | +0 |
| 176 | RESOLVED + BROKE-BUILD | Lane D closed `order` body axiom-clean; signature-race broke Lane K OCofP | +0 |
| 177 | RESOLVED + STILL-BROKEN-BUILD | Lane WD closed `principal` + `principal_hom` axiom-clean (introduced `IsRegularInCodimensionOne` class); Lane 1 FIX-BUILD threaded `[IsLocallyNoetherian]` but Lane WD's NEW class addition was not anticipated; Lane 8 landed RationalCurveIso.lean file-skeleton (3 substantive pins). `OCofP.lean` STILL FAILS to compile at L335 (failed to synthesize `IsRegularInCodimensionOne`). 2nd consecutive iter where parallel signature-race broke build. | +1 (typeclass) |

Iter-178 planner's dispatch proposal for this route:
- **Lane FIX-BUILD #2** (1 LOC): thread `[Scheme.IsRegularInCodimensionOne C.left]` into OCofP.lean variable block. PRIORITY.
- Lane WD-DEGREE: `principal_degree_zero` body STRETCH (acknowledged PARTIAL-OK).
- Lane RatCurveIso-FIX-TYPE: fix lean-auditor must-fix on `≅` (Type-iso) → `≃+*` (ring iso); try smallest body `morphismToP1OfGlobalSections`.

### Route 4 — File-skeleton fan-out (3 deferred files landed iter-177)

Strategy `Iters left` = N/A.

| iter | status | files landed | sorry change |
|---|---|---|---|
| 176 | RESOLVED | E (FlatteningStratification, 471 LOC); G (RelPicFunctor); H (QuotScheme); I (FGAPicRepresentability); K (OCofP, broke build). +25 stubs. | 37→60 |
| 177 | RESOLVED | Lane 6 (CodimOneExtension, 4 sorries+2 concrete defs); Lane 7 (AlbaneseUP, 7 stubs); Lane 8 (RationalCurveIso, 3 stubs). +14 stubs. | 60→71 |

All 3 iter-177-deferred files landed. New gaps:
- `Albanese/SymmetricPower.lean` (no file; chapter `Albanese_SymmetricPower.tex` does not exist).
- `Picard/IdentityComponent.lean` (no file; chapter `Picard_IdentityComponent.tex` does not exist).

Iter-178 planner's proposal: blueprint-writer + same-iter fast-path
blueprint-reviewer on `Albanese_SymmetricPower.tex`, then file-skeleton
prover lane on `Albanese/SymmetricPower.lean`. `IdentityComponent` is
gated on A.3 row; defer to iter-179+.

### Route 5 — Genus-0 arm closure (over k̄)

Strategy `Iters left` (after temp-axiom landing): 
- AVR `iotaGm_isDominant`: ~1-2 (closeable axiom-clean over temp axioms)
- AVR `genusZero_curve_iso_P1`: ~3-6 (RR.4 bridge — chains 3 new RationalCurveIso pins)
- Jacobian `genusZeroWitness.key` body: ~1-3 (downstream of rigidity + descent)

| iter | status | highlights |
|---|---|---|
| 177 | UNCHANGED | AVR L86 `iotaGm_isDominant`, L290 `genusZero_curve_iso_P1` remain `:= sorry`. RationalCurveIso.lean Pin 4 cross-reference resolved correctly. |

Iter-178 planner's proposal:
- Lane AVR-IOTAGM: `iotaGm_isDominant` body via `gmScalingP1` (now axiom-clean over the temp axioms). Smallest available genus-0 closure step.

## PROGRESS.md `## Current Objectives` proposal (this iter)

8 lanes (within ~10 cap):

1. **`OCofP.lean`** — Lane FIX-BUILD #2: thread `[Scheme.IsRegularInCodimensionOne C.left]` into namespace variable block. PRIORITY.
2. **`AbelianVarietyRigidity.lean`** — Lane AVR-IOTAGM: `iotaGm_isDominant` body via `gmScalingP1` (axiom-clean over temp axioms).
3. **`WeilDivisor.lean`** — Lane WD-DEGREE: `principal_degree_zero` STRETCH body (Hartshorne 6.10).
4. **`CodimOneExtension.lean`** — Lane CodimOne-BODIES: 2 ready sorries (`localRing_dvr_of_codim_one`, `extend_iff_order_nonneg`).
5. **`RationalCurveIso.lean`** — Lane RatCurveIso-FIX: fix `functionField ≅` type weakening + attempt smallest pin (`morphismToP1OfGlobalSections`).
6. **`QuotScheme.lean`** — Lane QS-IsIso: `canonicalBaseChangeMap_isIso` body attempt (deep — may PARTIAL).
7. **`Albanese/SymmetricPower.lean`** — Lane SymPower-SKEL: NEW FILE file-skeleton (after blueprint-writer dispatch + fast-path review).
8. **`AuslanderBuchsbaum.lean`** — Lane AB-PROJDIM: replace `projectiveDimension := sorry` with one-line concrete body the auditor identified.

## Question

Per route, return CONVERGING / CHURNING / STUCK / UNCLEAR with corrective
named per dispatcher_notes. Especially flag:

- Whether Route 1's temp-axiom corrective is now ON the right replacement
  path (mathlib-analogist consult on cover-vs-Proj.awayι API; separated-locus
  universal extension feasibility consult) or whether something else is owed.
- Whether Route 2's deferred mathlib-analogist consult on RelativeSpec
  encoding suffices, or whether a different corrective is needed.
- Whether Route 3's 2nd consecutive parallel-signature-change-race-broken
  build is a planner failure mode (and how to mitigate; e.g.
  serialize lanes, integration build gate, or other).
- Whether the 8-lane dispatch is sound (vs. trimming).
- Whether Lane WD-DEGREE deserves to fire again given it was STRETCH
  in iter-177 and DEFERRED there (this is its 2nd attempt iter).
