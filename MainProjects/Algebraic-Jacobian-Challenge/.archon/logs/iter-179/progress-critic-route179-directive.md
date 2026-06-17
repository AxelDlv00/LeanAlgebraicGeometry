# Progress critic — `route179` directive

## Scope

Per-route convergence audit at iter-179 plan-phase. Active routes considered
this iter; signals extracted from the last K=5 iters (174–178) by the planner.

`Iters left` cells and `phase entered at iter` are lifted verbatim from
`.archon/STRATEGY.md` `## Phases & estimations`.

## Active routes

### Route 1 — Genus-0 chart-bridge body (TEMP axiom retirement)

- **Strategy row**: "Genus-0 rigidity — chart-bridge body"
- **STRATEGY Iters left**: 1 (axiom-laundered; iter-181 RETIRE-OR-ESCALATE)
- **Phase entered at**: iter-175 (when option (a) recipe came on file)
- **Current `.lean` file(s)**: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
  (2 TEMP project axioms + 2 honest scaffold sorries off-target)
- **Last K=5 signals**:
  - iter-174: helpers churn, no closure
  - iter-175: prover bypassed empirically-verified analogist option (a) recipe
  - iter-176: option (a) verifiably ON FILE at L309/L341 but 2nd structural mismatch surfaced
  - iter-177: HARD STOP fired → 2 TEMP project axioms admitted; 3 sorries retired
  - iter-178: NO body lane (HARD STOP rule). `gmscaling-cover-bridge` analogist
    consult dispatched plan-phase; persistent findings at
    `analogies/gmscaling-cover-bridge.md`. 3-step recipe (hoist `f_deg`/`hm` in
    `BareScheme.lean` → uniform-in-`i` refactor of `gmScalingP1_cover_X_iso` →
    Step 3 retires 2 temp axioms via 3 body lemmas).
  - **Sorry-counts (file)**: 5 → 5 → 5 → 2 + 2 TEMP axioms → 2 + 2 TEMP axioms
  - **Recurring blocker phrase**: cover-vs-`Proj.awayι` syntactic mismatch
    (Matrix.cons defeq blocked when index is `⟨0, _⟩` not canonical `(0 : Fin 2)`)

### Route 2 — A.1.a `RelativeSpec` encoding

- **Strategy row**: "A.1.a — `RelativeSpec`"
- **STRATEGY Iters left**: ~6–10
- **Phase entered at**: iter-173 (file landed) → iter-175 (placeholder body iter-176)
- **Current `.lean` file**: `AlgebraicJacobian/Picard/RelativeSpec.lean`
  (0 sorries — but `:= X` placeholder body laundering)
- **Last K=5 signals**:
  - iter-174: file-skeleton landed
  - iter-175: hit session-limit reset (1-turn / $0)
  - iter-176: closed 5 sorries with `RelativeSpec _𝒜 := X` and `structureMorphism _ := 𝟙 X`
    placeholder bodies (auditor CRITICAL "weakened-wrong")
  - iter-177: no body work (no consult finding yet)
  - iter-178: `relative-spec-encoding` analogist consult dispatched plan-phase;
    persistent findings at `analogies/relative-spec-encoding.md`. The Mathlib
    construction is shipped (`AffineZariskiSite.relativeGluingData`); 3 blocks
    (A=carrier+core ~25 LOC, B=downstream rewrites ~60 LOC, C=representable ~40 LOC).
  - **Sorry-counts (file)**: 5 → 5 → 0 (placeholder) → 0 → 0
  - **Recurring blocker phrase**: type-encoding gap; placeholder body laundering

### Route 3 — Albanese skeletons + body fills

- **Strategy rows**: A.4.a (`CodimOneExtension.lean`), A.4.b (`AuslanderBuchsbaum.lean`),
  A.4.c (`Thm32RationalMapExtension.lean`), A.4.d.ii (`AlbaneseUP.lean`)
- **STRATEGY Iters left**: A.4.a ~40–80, A.4.b ~12–20, A.4.c ~12–18, A.4.d.ii ~6–10
- **Phase entered at**: A.4.a iter-177, A.4.b iter-175, A.4.c iter-175, A.4.d.ii iter-177
- **Last K=5 signals**:
  - iter-174–175: file-skeletons landed (AB, Thm32)
  - iter-176: no Albanese work
  - iter-177: A.4.a + A.4.d.ii skeletons landed (CodimOne 4 sorries; AlbaneseUP 7 sorries)
  - iter-178: A.4.a CodimOne −1 (Lane 4 closed `extend_iff_order_nonneg` kernel-clean;
    `localRing_dvr_of_codim_one` real body + 1 helper sorry). A.4.b AB −1 (Lane 7
    closed `projectiveDimension` kernel-clean). Auditor 178B (CodimOne shallow body
    + unused KrullDimLE binder) and 178C (AB stale docstring) flagged must-fix-this-iter.
  - **Sorry-counts**: 4 → 3 (CodimOne); 6 → 5 (AB); 1 (Thm32 untouched); 7 (AlbaneseUP untouched)

### Route 4 — Genus-0 RR bridge (RR.1–RR.4)

- **Strategy rows**: RR.1, RR.2, RR.3, RR.4
- **STRATEGY Iters left**: RR.1 ~4–8; RR.2 ~8–12; RR.3 ~8–12; RR.4 ~8–12
- **Phase entered at**: iter-172 (RR.1 file landed)
- **Last K=5 signals**:
  - iter-174–176: file-skeletons landed
  - iter-177: WeilDivisor (RR.1) `principal` family axiom-clean (−1 sorry)
  - iter-178: WD (RR.1) `principal_degree_zero` constant branch axiom-clean; non-constant
    branch deferred to Lane 5 progress. RatCurveIso (RR.4) Part A signature mutation
    (Pin 3 `≅` → `≃+*`) and Part B `morphismToP1OfGlobalSections` body partial. Auditor
    178A flagged the RatCurveIso body as CRITICAL weakened-wrong-by-missing-hypothesis
    (the body `sorry` would silently accept inputs for which no morphism exists);
    iter-178 review confirms recurrence of iter-175 "chart-bridge prover bypass" pattern.
  - **Sorry-counts**: WD 2 → 2; RatCurveIso (NEW iter-177) 3 → 3; OCofP 5 → 5; RRFormula 3 → 3

### Route 5 — `QuotScheme.canonicalBaseChangeMap_isIso` (Stacks 02KH)

- **Strategy row**: A.2.b.iii Quot assembly
- **STRATEGY Iters left**: ~36–72 (file-skeleton)
- **Phase entered at**: iter-178 (Lane 6 attempted; structural advance)
- **Last K=5 signals**:
  - iter-178: Lane 6 STRETCH PARTIAL. `canonicalBaseChangeMap_isIso` body now structural
    one-liner via `Scheme.Modules.Hom.isIso_iff_isIso_app`; substantive content factored
    into 1 new named helper sorry carrying Stacks 02KH(ii) IsIso claim. File 6 → 6
    (−1 sorry from main, +1 in helper).
  - **Recurring blocker phrase**: helper carrying substantive Mathlib-gap content;
    structural-only advance, content-deferred

## Planner's `## Current Objectives` proposal for iter-179 (file basenames)

8 lanes proposed (all WITHIN dispatch cap):

1. `refactor` subagent → cover-bridge Steps 1–2 (cross-file
   `BareScheme.lean` + `GmScaling.lean` uniform-in-`i` refactor)
2. `refactor` subagent → RelativeSpec Block A (~25 LOC carrier upgrade)
3. `GmScaling.lean` → cover-bridge Step 3 prover (3 lemma bodies retire 2 TEMP axioms)
4. `RelativeSpec.lean` → Block B prover (~60 LOC downstream rewrites)
5. `RationalCurveIso.lean` → auditor 178A signature tightening + Pin 1 body retry
6. `CodimOneExtension.lean` → auditor 178B signature fix + helper body
7. `AbelianVarietyRigidity.lean` → AVR-IOTAGM resumed via `DenseRange` route +
   `IsOpenMap.denseRange_of_isPreirreducibleSpace` chain
8. `AuslanderBuchsbaum.lean` → AB depth body (Mathlib `Module.depth` re-export)
   + auditor 178C docstring fix

Lanes 1 + 2 are `refactor` subagents (write-domain cross-file); they
land BEFORE lanes 3 + 4 within the same iter (refactors are
synchronous-blocking — provers dispatched after).

## What you check

1. Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR.
2. Whether the planner's dispatch list matches the corrective named by your verdict.
3. For each STUCK / CHURNING route: name the corrective TYPE (blueprint expansion,
   Mathlib idiom consult, structural refactor, route pivot).
4. Whether the auditor's 178A / 178B / 178C must-fix-this-iter findings are
   adequately addressed in the dispatch (lanes 5, 6, 8).
5. Whether the 8-lane proposal is too thick / too thin for the per-route
   trajectory.
6. The 5-iter `gm_grpObj` deferral on `Points.lean:251` (load-bearing instance
   sorry; was 3-iter-deferred at iter-167 per memory; now ~11 iters stale): does
   this trigger STUCK on its sub-route?

## Hard ask

If you see ratification rather than convergence on any route — name it.
Silent helper-multiplication is the failure mode.
