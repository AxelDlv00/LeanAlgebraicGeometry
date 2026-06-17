# progress-critic — iter-177 directive

You are dispatched after iter-176's prover phase. Routes below are the
planner's active surface. **Per descriptor: do NOT read STRATEGY.md,
blueprint, PROGRESS.md, or iter sidecars.** Reason on the signals only.

## Routes / files under consideration

### Route 1 — Genus-0 chart-bridge (`Genus0BaseObjects/GmScaling.lean`)

**Strategy current `Iters left`** = `1 (HARD STOP)` — re-estimated iter-176.
**Phase entered**: iter-165 G0BO scaffold landing; specific Step C
chart-bridge body iter-168 first attempt.

| iter | status | file sorries | helpers added | blocker phrase |
|---|---|---|---|---|
| 172 | PARTIAL-low | 8 | +0 | "chart_PLB_eq Step C Fin syntactic mismatch" |
| 173 | PARTIAL-low | 8 | +1 | "Fin syntactic mismatch unchanged" |
| 174 | PARTIAL-low | 8 | +2 | "chart_PLB_eq Step C Fin (cross cases also)" |
| 175 | INCOMPLETE  | 5 | +0 | "session-limit kill; option (a) NOT applied" |
| 176 | INCOMPLETE  | 5 | +0 | "option (a) ON FILE; second cover-vs-Proj.awayι syntactic mismatch" |

iter-176 plan armed a HARD STOP trigger: "if Lane A1 returns 0 Step C
closures with option (a) verifiably ON FILE, iter-177 SAME-ITER commits
to (a) `TO_USER.md` escalation surfacing the temporary-axiom option,
AND (b) opens a concurrent prover lane on `temporary axiom
gmScalingP1_constant`. NO 6th retry." Iter-176 returned exactly that
condition: option (a) IS on file at L309 + L341; zero closures.

Planner's iter-177 dispatch proposal for this route:
- Open a NEW concurrent prover lane that ADMITS a temporary
  `axiom gmScalingP1_constant : <statement>` (`-- TODO: replace by
  chart-bridge body when the cover-vs-Proj.awayι mismatch is resolved`)
  and uses it to close the chart-bridge.
- NO sixth helper-retry on `gmScalingP1_chart_PLB_eq` Step C.

### Route 2 — Picard scheme infrastructure (`Picard/*.lean`)

Strategy `Iters left` (per relevant phase):
- A.1.a RelativeSpec: ~3-5
- A.1.b LineBundlePullback: ~2-4
- A.1.c RelPic: ~4-8
- A.2.a/b/c (Stratification/Quot/Grass/FGAPic): per sub-phase ~12-48

| iter | status | sorry context | helpers added |
|---|---|---|---|
| 173 | PARTIAL | RelativeSpec L160 attempted; type-encoding gap surfaced | +0 |
| 174 | PARTIAL | LineBundlePullback skeleton landed; FlatteningStratification, etc. UNSTARTED | +0 |
| 175 | DAMAGED | RelativeSpec + 5 file-skeletons + FGAPicRep killed by session-limit reset | +0 |
| 176 | RESOLVED-partial | Lane B closed 5/5 with placeholder bodies (X / 𝟙 X); 5 file-skeletons (Flat/RelPic/Quot/FGAPic) landed; Lane K OCofP file-skeleton landed BUT broke build | +0 |

**Critical iter-176 outcome**: Lane B's "closure" of `RelativeSpec`
was by setting `RelativeSpec _𝒜 := X` (the base scheme itself, not the
relative spectrum). Downstream theorems discharge trivially against
the placeholder. Review flagged this as "the one-layer-deeper trap"
and added `% NOTE` annotations. The type encoding is unchanged from
iter-173.

### Route 3 — RiemannRoch divisors (`RiemannRoch/{WeilDivisor, OCofP, RRFormula}.lean`)

Strategy `Iters left`:
- RR.1 WeilDivisor: ~5-9
- RR.2 RRFormula: ~8-12
- RR.3 OCofP: ~8-12
- RR.4 RationalCurveIso: ~8-12

| iter | status | sorry context | helpers added |
|---|---|---|---|
| 172 | RESOLVED | WeilDivisor file-skeleton landed | +0 |
| 173 | RESOLVED-partial | `ofClosedPoint` body axiom-clean | +0 |
| 175 | DAMAGED | WeilDivisor `order` body died 1-turn (session-limit) | +0 |
| 176 | RESOLVED | Lane D closed `order` body axiom-clean — and broke Lane K OCofP via parallel signature-change race (added `[IsLocallyNoetherian X]` + `[Ring.KrullDimLE 1 _]` instance binders that Lane K's `globalSections_iff` / `exists_nonconstant_genusZero` do not declare) | +0 |

**Critical iter-176 outcome**: `lake build AlgebraicJacobian` is
BROKEN at iter-end. 4 errors in `OCofP.lean` L194/195/327/328 (failed
to synthesize `IsLocallyNoetherian C.left`). Fix is mechanical: 1-3
lines per lemma to thread the missing instances.

### Route 4 — File-skeleton fan-out (5 new files this iter + 3 deferred)

Strategy `Iters left` = N/A (per-file file-skeleton ≈ 1 iter each).

| iter | status | new files | sorry change |
|---|---|---|---|
| 175 | DAMAGED | 5 lanes died 1-turn (session-limit reset at 06:14 UTC) | 0 |
| 176 | RESOLVED | E (FlatteningStratification, 471 LOC, 7 stubs); G (RelPicFunctor, 451 LOC, 6 stubs); H (QuotScheme, 6 stubs); I (FGAPicRepresentability, 7 stubs); K (OCofP, 5 stubs but BREAKS build); F + J landed iter-175. Total +25 file-skeleton stubs landed | 37→60 warnings (numerically as projected by planner) |

3 chapters STILL have `% archon:covers` declarations pointing to non-existent .lean files:
- `Albanese_AlbaneseUP.tex` → `Albanese/AlbaneseUP.lean` (deferred iter-176)
- `Albanese_CodimOneExtension.tex` → `Albanese/CodimOneExtension.lean` (deferred iter-176)
- `RiemannRoch_RationalCurveIso.tex` → `RiemannRoch/RationalCurveIso.lean` (deferred iter-176)

Planner's iter-177 proposes landing these 3 deferred file-skeletons.

## PROGRESS.md `## Current Objectives` proposal (this iter)

8 lanes:

1. **`OCofP.lean`** — BUILD-FIX lane. Thread missing `[IsLocallyNoetherian C.left]`
   instance into `globalSections_iff` and `exists_nonconstant_genusZero`.
   Mechanical (1-3 LOC per lemma).
2. **`GmScaling.lean`** — GM-AXIOM lane (HARD STOP firing). Add
   `axiom gmScalingP1_constant` (or analogous closure), wire into the
   chart-bridge so Step C / cross sorries close downstream.
3. **`WeilDivisor.lean`** — `principal_degree_zero` body (small, smallest in review's order).
4. **`RelativeSpec.lean`** — `flatBaseChangeCohomology` (i=0) body OR
   small additional structural advance (Lane B did 5/5 with placeholder
   already; reviewing whether more body to attempt).
5. **`RelPicFunctor.lean`** — `PicSharp.addCommGroup` instance body.
6. **`Albanese/CodimOneExtension.lean`** — file-skeleton (new file).
7. **`Albanese/AlbaneseUP.lean`** — file-skeleton (new file).
8. **`RiemannRoch/RationalCurveIso.lean`** — file-skeleton (new file).

## Question

Per route, return CONVERGING / CHURNING / STUCK / UNCLEAR with corrective
named per dispatcher_notes. Especially flag:

- Whether Route 1's GM-AXIOM strategy is the right corrective for the
  CHURNING that the iter-176 INCOMPLETE confirmed (vs. continued
  helper-bridging or vs. Fin.cases structural pivot).
- Whether Route 2's placeholder-body laundering on Lane B is itself a
  CHURNING pattern (the strategy/blueprint says "RelativeSpec functor",
  but the file says `RelativeSpec _𝒜 := X`). If yes, name the corrective.
- Whether Route 4's 3-file-skeleton fan-out + 4 body-fill lanes is
  legitimate iter-177 work or whether load is too thick after the
  iter-176 broken-build.

Also confirm whether the 8-lane dispatch is sound (vs. trimming).
