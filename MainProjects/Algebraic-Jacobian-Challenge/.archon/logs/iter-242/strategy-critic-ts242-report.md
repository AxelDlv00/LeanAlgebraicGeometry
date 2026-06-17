# Strategy Critic Report

## Slug
ts242

## Iteration
242

## Routes audited

### Route: A.1.c.SubT — group law via tensor-invertibility carrier (DONE)

- **Verdict**: SOUND — closed and axiom-clean; carried as completed-but-summarized, not as an active claim. No re-litigation needed.

### Route: A.1.c — relative Picard functor on `IsInvertible` (the Phase 2 route change under review)

- **Goal-alignment**: PASS — `IsInvertible.pullback` is genuinely required (base-change of the RelPic functor needs pullback to preserve tensor-invertibility); it is on the critical path and the strategy builds it with a concrete timeline.
- **Mathematical soundness**: PASS — see the detailed analysis below; the revised Phase 2 route is sound and, in fact, slightly over-specified (it asks for more than `pullbackTensorIso` strictly needs).
- **Sunk-cost reasoning detected**: no — the pivot explicitly *retracts* the prior plan ("the earlier 'sectionwise-`extendScalars` recipe is dead' reading is RETRACTED") rather than defending it; this is the opposite of sunk cost.
- **Infrastructure-deferral detected**: no — see analysis. The pivot moves toward *available* Mathlib infrastructure, not away from a hard prerequisite.
- **Phantom prerequisites**: none — both `TensorProduct.AlgebraTensorModule.distribBaseChange` and the PR #36599 monoidal-`extendScalars` machinery (`ModuleCat.extendScalars_μ`/`_δ`) and `Adjunction.leftAdjointUniq` are VERIFIED present at the pin (see Prerequisite verification).
- **Effort honesty**: reasonable, with one quibble — the `~0/it` velocity in the LOC cell sits oddly against an ACTIVE phase, but Phase 1 just landed in a single discrete chunk, so the substrate genuinely progresses in bursts rather than per-iter trickle. Not dishonest; the `~0/it` figure is just stale and slightly misleading.
- **Parallelism under-exploited**: no — the engine (A.2.c-engine) is correctly de-gated and runs in parallel; A.1.c's three phases are genuinely sequential (Phase 2 consumes Phase 1's iso; Phase 3 composes both), so the serialization is real, not a planning miss.
- **Verdict**: SOUND

**Detailed soundness analysis of the Phase 2 route (the directive's core question).**

The directive asks: does `leftAdjointUniq` transport a *monoidal* structure, or only the bare functor iso — and if the latter, must the project then check the comparison is monoidal/iso by hand?

Verified answer: `CategoryTheory.Adjunction.leftAdjointUniq` has type `(F ⊣ G) → (F' ⊣ G) → (F ≅ F')`. It produces **only the bare natural iso of functors**, carrying no monoidal data.

This does **not** create a gap, because `pullbackTensorIso : pullback(M⊗N) ≅ pullback M ⊗ pullback N` is obtainable as a *composite of three isos* without ever transporting a monoidal-structure typeclass to the abstract adjoint:

1. `pullback(M⊗N) ≅ P(M⊗N)` — the `leftAdjointUniq` bare iso, evaluated at `M⊗N`;
2. `P(M⊗N) ≅ P M ⊗ P N` — the tensorator of the concrete `P`, which is an iso *because `P` is strong monoidal* (its inverse is `distribBaseChange` / `distribBaseChange.symm` lifted through sheafification, already an iso by construction);
3. `P M ⊗ P N ≅ pullback M ⊗ pullback N` — the same `leftAdjointUniq` bare iso whiskered on each tensor factor.

Each leg is an iso; the composite is an iso *automatically* (no hand-checking of iso-ness, no hand-checking of monoidality, is required to land `pullbackTensorIso`). This is structurally identical to the iter-217 `tensorObj_restrict_iso` closure, which is the precedent the strategy cites. Both adjunctions share the *same* right adjoint `pushforward` (the abstract `Scheme.Modules.pullback` is definitionally `pushforward.leftAdjoint`, so its adjunction and `P ⊣ pushforward` feed `leftAdjointUniq` with matching `G`) — so the device applies cleanly.

Consequently the strategy's phrasing "transport `P.Monoidal` to the abstract `Scheme.Modules.pullback`" is **stronger than necessary**. Full monoidal-structure transport along a bare natural iso is a real (if standard) extra step — it would need the "monoidal structure transports along a natural iso of functors" machinery — and is only worth doing if the project wants a registered `Scheme.Modules.pullback.Monoidal` instance for downstream reuse. For `IsInvertible.pullback` itself, the three-iso composite suffices and is cheaper. This is a de-risking refinement, not a flaw — recorded under Alternative routes below.

The genuine remaining work (honestly flagged in the Risks cell) is the `P ⊣ pushforward` adjunction assembly. This is standard but non-trivial plumbing; the estimate (~250–400 LOC inside ~6–10 iters) is credible for an adjunction-construction-plus-transport build.

### Route: A.2.c — representability (scaffolding)

- **Verdict**: SOUND — `⟨sorry⟩`-constructor scaffolding under which Route A proceeds is a legitimate staging device; the sorries are discharged by the engine, which is itself on a concrete (if large) plan. Not a goal weakening because the engine that discharges them is named and lane-active.

### Route: A.2.c-engine — Quot/Cartier (RR-free)

- **Goal-alignment**: PASS — the engine discharges the representability scaffolding the goal requires; under the permanent Route C pause it is the *only* available discharge path, so it is squarely on the critical path.
- **Mathematical soundness**: PASS — Nitsure §5 / Kleiman §4 RR-free Quot/Hilbert construction is the standard route; deepest root `R^i f_*` (i≥1) is correctly identified.
- **Infrastructure-deferral detected**: no — though "HELD behind A.1.c", it is simultaneously de-gated with an *active* lane (`Cohomology_FlatBaseChange`) showing concrete blueprint + Lean progress. It is not stagnant-by-inaction.
- **Effort honesty**: reasonable — the strategy explicitly flags that "iters-left assumes focused velocity (not the current side-lane trickle)" and that this is "the largest build". 5500 LOC ÷ ~75/it (focused) ≈ 73 iters vs the stated 30–60 is internally consistent once velocity ramps; the honesty caveat is present. No under-count masquerading as a small number.
- **Verdict**: SOUND

### Route: Albanese UP — two routes

- **Goal-alignment**: PASS — `isAlbaneseFor` is the goal node; both routes target it.
- **Mathematical soundness**: PARTIAL — the PREFERRED Route 2 (autoduality `J^∨≅J`) is flagged UNVERIFIED for RR-freeness (classically RR-dependent via theta-divisor polarization). This is correctly surfaced as an open question with a NAMED, in-tree, RR-free fallback (Route 1 — Weil/rigidity). Because the fallback is genuinely RR-free and already substrated, `isAlbaneseFor` is reachable under the Route C pause *either way*; the verification only decides which is primary. This is sound risk management, not a deferral.
- **Verdict**: SOUND

### Route: Route C — Riemann–Roch (PAUSED, USER)

- **Verdict**: SOUND — a USER-imposed pause, correctly recorded as the reason the RR-free engine exists. The cost asymmetry is honestly noted ("closer than '~5× cheaper' once RR is numbered"). Not a strategy choice the critic can override.

### Route: Genus-0 arm

- **Verdict**: SOUND — both sub-arms (Pic⁰-via-AV-wrap; direct `Spec k`) named; (b) PAUSED per USER. No issue.

## Format compliance

- **Size**: 174 lines / ~13.0 KB — lines within budget; bytes marginally over the ~12 KB soft cap.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive `iter-NNN` references that the skeleton explicitly classifies as per-iter narrative belonging in `iter/iter-NNN/plan.md`. Representative verbatim: "`pullbackUnitIso`) — **DONE (iter-241), axiom-clean.**`" (line 53); "REPLACING the iter-240 'pointwise finality chart-chase' plan" (line 114); "the iter-217 `tensorObj_restrict_iso` technique" (lines 65, 112). At least eight such `iter-NNN` mentions (lines 53, 56, 64–66, 112–114, 149, 151).
- **Accumulation detected**: no — completed routes (A.1.c.SubT, `picCommGroup`) are summarized to a line, not occupying live space; dead-ends are pushed to sidecars by reference.
- **Table discipline**: PARTIAL — the table carries both LOC figures (remaining · realized/it) correctly, but the A.1.c "Key Mathlib needs" cell is a full multi-sentence paragraph rather than "one short line per cell"; ditto the A.2.c-engine cell. This is prose-in-cells drift.
- **Format verdict**: DRIFTED

## Alternative routes (suggested)

### Alternative: skip full `P.Monoidal` transport — build `pullbackTensorIso` as a three-iso composite

- **What it looks like**: Do not aim to install a `MonoidalCategory`/`Functor.Monoidal` instance on the abstract `Scheme.Modules.pullback`. Instead build only (a) the concrete `P` with its tensorator iso (from `distribBaseChange` + `sheafifyTensorUnitIso`), (b) the bare `leftAdjointUniq` iso `P ≅ pullback`, then define `pullbackTensorIso` directly as `(leftAdjointUniq).app(M⊗N) ≪≫ P.tensorator M N ≪≫ (whisker the leftAdjointUniq iso on both factors)`.
- **Why it might be cheaper or sounder**: it drops the "monoidal-structure-transports-along-a-natural-iso" plumbing entirely; only the bare functor iso (which `leftAdjointUniq` already gives) plus P's tensorator are needed, and iso-ness is automatic from composition. This is exactly the iter-217 shape that already succeeded, so it carries the least novel risk.
- **What the current strategy may have rejected**: the strategy says "transport `P.Monoidal`", which suggests it intends the heavier full-structure transport. It may want the registered instance for later RPF reuse — but `IsInvertible.pullback` (the stated Phase 2/3 target) does not require it.
- **Severity of the omission**: minor — the route as written is sound; this is a scope-trim that de-risks, and the planner may legitimately prefer the registered instance if downstream consumers need it.

## Prerequisite verification

- `CategoryTheory.Adjunction.leftAdjointUniq`: VERIFIED — type `(F ⊣ G) → (F' ⊣ G) → (F ≅ F')` (bare functor iso, NOT monoidal; see analysis).
- `TensorProduct.AlgebraTensorModule.distribBaseChange`: VERIFIED — `Mathlib.LinearAlgebra.TensorProduct.Tower`.
- PR #36599 monoidal `extendScalars` machinery: VERIFIED — `ModuleCat.extendScalars_μ` / `ModuleCat.extendScalars_δ` present in `Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`, with tensorator = `distribBaseChange`. The strategy's retraction of the "absent" claim is correct.

## Must-fix-this-iter

- Format: DRIFTED — strip the `iter-NNN` per-iter references (≥8 occurrences; lines 53, 56, 64–66, 112–114, 149, 151) and compress the two paragraph-length table cells (A.1.c and A.2.c-engine "Key Mathlib needs") to one short line, pushing the recipe detail into the `## Routes` prose where it already lives. In-place edit; no content loss. (Light CHALLENGE — the strategic content is sound; this is document hygiene that bleeds into every plan-agent context.)

## Overall verdict

The revised A.1.c Phase 2 route is **SOUND**. `Adjunction.leftAdjointUniq` transports only a bare functor iso, not a monoidal structure — but this is not a gap: `pullbackTensorIso` is obtained as a composite of the bare adjoint-uniqueness iso with the concrete `P`'s tensorator iso, all isos, so iso-ness is automatic and no by-hand monoidality check is needed (the iter-217 `tensorObj_restrict_iso` precedent is exactly this shape). All three named prerequisites — `leftAdjointUniq`, `distribBaseChange`, and the PR #36599 `extendScalars` monoidal machinery — are VERIFIED present at the pin, so the retraction of the prior "absent" reading is correct and the pivot moves toward available infrastructure rather than renaming a hard problem (no infrastructure-deferral). The only substantive over-specification is "transport `P.Monoidal`", which is stronger than `IsInvertible.pullback` requires; the three-iso composite is a cheaper, lower-risk path the planner may adopt. The overall destination ordering (A.1.c.SubT done → A.1.c → A.2.c, engine in parallel) is the right path for the PRIMARY representability goal under the permanent Route C pause, and the Albanese-UP fallback keeps `isAlbaneseFor` reachable RR-free either way. The strategy defers no construction that the stated goal requires. The one actionable item is format DRIFT: pervasive `iter-NNN` narrative and two paragraph-length table cells should be cleaned in-place this iter.
