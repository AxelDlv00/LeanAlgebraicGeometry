# Progress critic directive — iter-199 (slug: `route199`)

## Active routes the planner is considering for prover dispatch this iter

The Archon project is operating under the USER 2026-05-28 standing
directive (ROUTE C PAUSE permanent; Route A bottom-up execution).
iter-198 baseline 83 sorries → iter-198 exiting 78 sorries (−5; all
attributable to Lane RPF placeholder closures).

The planner is considering **4 Route A prover lanes for iter-199**:
- Lane WD-A4a (`WeilDivisor.lean`) — substrate-build under
  [IsNoetherian X]; public sorry stays. New private helper.
- Lane AB-gap1 (`AuslanderBuchsbaum.lean`) — substrate-build for
  Stacks `lemma-add-trivial-complex` (minimal-resolution carving;
  independent of gaps 2 and 3 per iter-198 prover report).
- Lane COE-stage6-iiA (`CodimOneExtension.lean`) — Stacks 02JK
  cotangent ↔ Kähler iso (closed-point case, ~100-200 LOC).
- Lane FGA-sorry4 (`FGAPicRepresentability.lean`) — `smoothProperQuotient`
  body, L354 (Rank 2 per iter-198 fga-sorry-order blueprint chapter).

**Held this iter:** Lane RPF (no more placeholder closures — pending
upstream `Scheme.Modules` monoidal-structure gap), Lane T32 (Lane COE
derivative — re-routed per iter-198 review), Lane RCI (USER
directive HOLD).

## Per-route signals (last 5 iters: iter-194, 195, 196, 197, 198)

For each route, the critic should compare the strategy's CURRENT
`Iters left` estimate against the elapsed iters since the route
entered its current phase.

### Lane WD-A4a — `WeilDivisor.lean` L325 / non-zero branch

- **Sorry trajectory (file-level)**: 4 → 4 → 4 → 3 → 3.
  L325 specifically (the A.4.a non-zero branch): unchanged at 1
  sorry throughout all 5 iters.
- **Helpers added this iter**: 6 axiom-clean (order_zero,
  order_mul_of_ne_zero, order_inv, order_units_inv, degree_neg,
  degree_sub). Iter-198 helper-budget = 2; the prover landed 6
  axiom-clean substrate.
- **Prover dispatch pattern**: 0 → 0 → 0 → 0 → 1 (iter-198 only).
- **Recurring blocker**: typeclass-strength gap
  `[IsLocallyNoetherian X]` vs `[IsNoetherian X]` — the iter-198
  prover documented this as an *honest* structural blocker with a
  counter-example (non-quasi-compact integral locally Noetherian
  scheme with infinitely many disjoint codim-1 components). Cannot
  close under the current public signature.
- **Strategy estimate**: ~3-6 iters / ~150-400 LOC remaining.
- **Phase entered**: iter-198 (first iter under Route A bottom-up
  framing). Elapsed: 1 iter (this is iter-199).
- **Planned iter-199 corrective**: substrate-build under stronger
  hypothesis as a new private helper `rationalMap_order_finite_support_of_isNoetherian`;
  public sorry stays. The signature strengthening to the public
  declaration would require Route C consumer propagation (L538,
  L1108) which is USER-directive-blocked.

### Lane AB — `AuslanderBuchsbaum.lean` L1299 / n=k+1 inductive step

- **Sorry trajectory (file-level)**: 1 → 1 → 1 → 1 → 1.
  L1299 specifically: unchanged across all 5 iters.
- **Helpers added this iter**: 2 axiom-clean
  (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` for
  Stacks `lemma-depth-drops-by-one`; `exists_isSMulRegular_of_one_le_depth`).
  Iter-198 closed gap (4) of the 4-piece slice.
- **Prover dispatch pattern**: 0 → 1 → 0 → 0 → 1 (iter-195 carved
  substrate; iter-198 dispatched).
- **Recurring blocker**: gaps (1) `lemma-add-trivial-complex`
  (minimal-resolution carving), (2) Stacks 00MF "what is exact"
  criterion, (3) snake-lemma-on-minimal-resolution. All multi-iter
  substrate work; gap (1) is independent ~80-120 LOC.
- **Strategy estimate**: ~6-12 iters / ~200-300 LOC remaining.
- **Phase entered**: iter-195 (carved). Elapsed: 4 iters.
- **Planned iter-199 corrective**: dispatch gap (1) substrate
  (`lemma-add-trivial-complex`).

### Lane RPF — `RelPicFunctor.lean` L235 (only L235 remains)

- **Sorry trajectory (file-level)**: 6 → 6 → 6 → 6 → 1
  (iter-198 closed 5 of 6 via placeholder bodies — headline-laundering
  concern flagged in lean-auditor iter-198 + lean-vs-blueprint-checker
  rpf-iter198).
- **Helpers added this iter**: none (5 closures all placeholder).
- **Prover dispatch pattern**: 0 → 0 → 0 → 0 → 1 (iter-198 first
  dispatch in 9+ iters; gate annotation was 10-iter stale).
- **Recurring blocker**: `addCommGroup` body (L235) gated on Mathlib
  `Scheme.Modules` monoidal-structure gap. This is a genuine
  upstream Mathlib gap; project-side build is not trivial.
- **Strategy estimate**: ~6-10 iters / ~300-500 LOC remaining (now
  effectively ~5 iters / ~250-400 LOC since 5/6 closed).
- **Phase entered**: iter-188 (gate became actionable). Elapsed: 10 iters.
- **Planned iter-199 status**: HELD this iter (no more placeholder
  closures; the upstream `Scheme.Modules.tensorObj` build is itself
  a separate ~200-400 LOC mathlib-build target for iter-200+).

### Lane COE — `CodimOneExtension.lean` L526 / Stage 6 gap

- **Sorry trajectory (file-level)**: 3 → 3 → 3 → 3 → 3.
  L526 specifically: unchanged across all 5 iters.
- **Helpers added this iter**: 3 axiom-clean (Stage 6 sub-gap (i)
  discharger; 6.B-RHS substrate hypothesis-form +
  IsStandardSmoothOfRelativeDimension-form). Body extended to
  consume substrate; trailing sorry narrowed to (ii.A) Stacks 02JK
  + (ii.B) Stacks 00OE.
- **Prover dispatch pattern**: 1 → 0 → 0 → 0 → 1 (iter-193
  Stages 5a/5b; iter-198 re-engaged per USER directive).
- **Recurring blocker**: (ii.A) Stacks 02JK closed-point iso
  `m/m² ≃ κ ⊗ Ω[Sₘ/R]` (~100-200 LOC) and (ii.B) Stacks 00OE
  Krull-dim formula for smooth (~200-300 LOC).
- **Strategy estimate**: ~4-8 iters / ~300-500 LOC remaining
  (widened iter-198 STRATEGY rewrite).
- **Phase entered**: iter-193 (Stage 5 work). Elapsed: 6 iters.
- **Planned iter-199 corrective**: tackle (ii.A) Stacks 02JK
  closed-point case via mathlib-build, helped by a
  `mathlib-analogist` cross-domain-inspiration dispatch.

### Lane FGA — `FGAPicRepresentability.lean` (7 sorries)

- **Sorry trajectory (file-level)**: 7 → 7 → 7 → 7 → 7 (5 iters
  zero closure; iter-196 carrier-soundness refactor was plan-phase
  structural action, no prover dispatch).
- **Helpers added this iter**: none (no prover dispatch iter-198).
- **Prover dispatch pattern**: 0 → 0 → 0 → 0 → 0 (5 consecutive
  zero-dispatch iters — CHURNING by plan-phase-only meta-pattern;
  iter-198 review CRIT-3 flagged this).
- **Recurring blocker**: ambiguous abort criterion for the
  carrier-soundness probe; no concrete sorry-closure plan.
  Iter-198 blueprint-writer `fga-sorry-order` LANDED a chapter
  expansion with rank-1/2/3 partition; Sorry 4 (smoothProperQuotient
  body, L354, Rank 2) is the recommended first target.
- **Strategy estimate**: ~12-16 iters / ~600-800 LOC remaining
  (substrate-blocked on Route C RR for the Pic representability
  itself; the iter-loop runs under typeclass abstraction via the
  probe).
- **Phase entered**: iter-194 (file creation). Elapsed: 5 iters.
- **Planned iter-199 corrective**: dispatch Sorry 4 prover with
  Altman-Kleiman effective-equivalence-relation descent + Stacks 09Y
  reference; carrier-soundness probe verdict CONFIRM per iter-198
  review.

### Lane T32 — `Thm32RationalMapExtension.lean` L155

- **Sorry trajectory (file-level)**: 2 → 2 → 2 → 2 → 2.
  L155 specifically: unchanged.
- **Helpers added this iter**: 0 code changes (iter-198 prover
  exhausted 5 approaches).
- **Prover dispatch pattern**: 0 → 0 → 0 → 0 → 1 (iter-198 only;
  0 code changes landed).
- **Recurring blocker**: no Smooth → IsReduced bridge in Mathlib at
  any granularity. PROGRESS.md iter-198 recipe (30-80 LOC)
  underestimated by an order of magnitude. Natural path: as Lane
  COE derivative once Stage 6.B Krull-dim formula lands.
- **Strategy estimate**: priority-3 stretch — was 1 iter / ~30-80 LOC;
  re-estimated to "Lane COE derivative" (~60 LOC after COE Stage 6).
- **Phase entered**: iter-196 (carved). Elapsed: 3 iters.
- **Planned iter-199 status**: HELD (Lane COE derivative; do NOT
  dispatch in isolation per iter-198 review).

## PROGRESS.md `## Current Objectives` proposal for iter-199

```
1. WeilDivisor.lean — Lane WD-A4a-Noeth (mathlib-build); new private
   helper under [IsNoetherian X].
2. AuslanderBuchsbaum.lean — Lane AB-gap1 (mathlib-build); gap (1)
   minimal-resolution carving + in-passing docstring fix.
3. CodimOneExtension.lean — Lane COE-stage6-iiA (mathlib-build);
   Stacks 02JK closed-point case.
4. FGAPicRepresentability.lean — Lane FGA-sorry4 (mathlib-build);
   `smoothProperQuotient` body L354.
```

File count: 4. Cap: 10. Held lanes (Lane RPF, Lane T32, Lane RCI):
explicit rationale in plan.md.

## Question to answer

For each of the 6 routes above (4 active + 2 held), give a CONVERGING /
CHURNING / STUCK / UNCLEAR verdict. Pay special attention to:

1. Lane RPF — is the iter-198 placeholder-closure pattern progress,
   metric gaming, or both? Does HOLDING this iter address the
   headline-laundering concern, or does it perpetuate it?
2. Lane WD-A4a — is the "substrate-build under stronger hypothesis;
   public sorry stays" path a legitimate corrective, or is it
   helper-churn that doesn't advance the file?
3. Lane FGA — is dispatching Sorry 4 (Rank 2 from the iter-198
   fga-sorry-order chapter) actually executable in a single iter, or
   is it gated on more substrate that the chapter understates?
4. Lane T32 — does the "Lane COE derivative" re-routing eliminate
   the CHURNING, or is the lane still expected to consume planner
   attention every iter as a held lane?
5. Lane COE — at ~6 iters elapsed vs ~4-8 iters estimated, is the
   estimate still credible, or should it widen further given the
   (ii.A)+(ii.B) split was iter-198-discovered?

Cross-check the dispatch-sanity: 4 lanes scheduled, none dropped.
RPF / T32 / RCI explicitly held with stated rationale. Is this the
right composition for the iter, or are there lanes that should be
added or swapped?
