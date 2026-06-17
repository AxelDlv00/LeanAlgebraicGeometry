# Strategy Critic Report

## Slug
sc258

## Iteration
258

## Routes audited

### Route: SHARED ROOT — `SheafOfModules.overEquivalence`

- **Goal-alignment**: PASS — building it discharges the engine `chartOverIso` (→ `IsLocallyTrivial⟹IsFinitePresentation`, A.2.c) and the dual `sliceDualTransport` (→ `exists_tensorObj_inverse`, RPF inverse); both are on-path.
- **Mathematical soundness**: PASS — the modules-level lift of `Opens.overEquivalence` with the structure-ring-sheaf transported is a real, well-posed construction. The base equivalence `TopologicalSpace.Opens.overEquivalence : Over U ≌ Opens ↥U` exists, and the module-sheaf pullback/pushforward + site-over machinery (`SheafOfModules.pullback`, `CategoryTheory.Sheaf.over`, `J.over`, `Scheme.Modules.restrictAdjunction`) all exist to lift it.
- **Infrastructure-deferral detected**: no — this is the opposite of deferral. The "open-immersion ↔ slice sheaf equivalence" is a wall the project has circled repeatedly (a Sheaf-of-Ab, fixed-value-category cousin `overSliceSheafEquiv` was built earlier but is inapplicable because the structure ring varies). The current strategy finally COMMITS to building the correct modules-level construction rather than deferring it to "upstream Mathlib." That is the right move.
- **Effort honesty**: reasonable — ~200–350 LOC, own file, velocity n/a (new lane). Iters-left ~3–6 is consistent (≈50–60 LOC/it on a focused new-file build).
- **Verdict**: SOUND

### Route: A.1.c.sub — comparison iso on line bundles (loc-triv)

- **Goal-alignment**: PASS — `IsInvertible.pullback` reduces to the pullback–tensor comparison iso on loc-triv pairs, the strictly-easier sufficient case RPF needs.
- **Mathematical soundness**: PASS — δ (`pullbackTensorMap`) is an iso on all objects because `f^*` is strong monoidal; proving it only on loc-triv pairs via `isIso_of_isIso_restrict` over the trivialising cover, reducing each chart to the unit pair, is sound.
- **Sunk-cost reasoning detected**: no — the "by-hand, not generic Mathlib sheaf-monoidal machinery" choice is justified on merits (`Sheaf.monoidalCategory` requires a FIXED `MonoidalCategory A`; the varying-ring module tensor has no fixed-`A` instance), not on prior investment.
- **Phantom prerequisites**: none load-bearing. D3′ depends on `comp_δ`/`isMonoidal_comp` mate-calculus the strategy itself labels "Mathlib-absent monoidality" — correctly classified as new material to build, not assumed-present infra.
- **Effort honesty**: reasonable — `~80–200 · ~20/it`, Iters left ~6–11; 200÷20≈10 is internally consistent.
- **Verdict**: SOUND

### Route: A.1.c.fun — relative Picard functor on `IsLocallyTrivial`

- **Goal-alignment**: PASS — RPF intrinsically classifies loc-triv line bundles; the carrier choice matches the consumer.
- **Mathematical soundness**: PASS — `map_add` ← comparison iso, `map_zero` ← `pullbackUnitIso`, inverse ← `exists_tensorObj_inverse` returning a loc-triv witness keeps group closure inside the carrier. Modeled field-for-field on `CommRing.Pic.mapAlgebra`.
- **Parallelism under-exploited**: no — authored in parallel against a typed-sorry bridge; explicitly de-gated by D2′.
- **Effort honesty**: reasonable — `~350–600 · 0/it` with `0/it` acceptable for a just-opening lane.
- **Verdict**: SOUND

### Route: A.2.c + A.2.c-engine — representability + Quot/Cartier (RR-free)

- **Goal-alignment**: PASS — RR-free general Quot/Hilbert engine discharges the `⟨sorry⟩` representability typeclasses without RR; this is the architectural reason RR can stay paused.
- **Mathematical soundness**: PASS — the FGA route (Nitsure §5 + Kleiman §4) is the canonical RR-free path to Picard representability; `Rⁱf_*` (i≥1) via project Čech is the right deepest root.
- **Infrastructure-deferral detected**: partially — `Rⁱf_*` (i≥1) is the dominant pole, on the critical path, currently with NO active lane and NO blueprint chapter ("blueprint chapter scheduled next iter"). This borders on deferral-by-inaction. It is NOT a hard reject because the strategy gives a concrete route (project Čech, ~800–1200 LOC) and a defensible reason for the delay (cannot author two deep engine chapters at once; the loc-triv entry is the cheaper first step). Treat as a watch-item: the blueprint must actually land next iter, not slip again.
- **Effort honesty**: under-counted (aggregate). `~3400–5500 LOC ÷ ~40/it ≈ 85–140 it` is internally consistent arithmetically, BUT the constituent builds (general Quot representability, flattening stratification, CM-regularity, relative Proj, semicontinuity, Grassmannian) are each individually major formalization projects with no Mathlib base. The aggregate 85–140 iters is plausibly optimistic; this row is the project's single largest existential risk and should be re-estimated as constituent blueprints land. The strategy does flag it as "largest pole."
- **Verdict**: SOUND (with the `Rⁱf_*` blueprint watch-item)

### Route: A.4 — Albanese UP (Route 1 RR-free primary)

- **Goal-alignment**: PASS — `isAlbaneseFor` reachable via Weil's `φ:Pic⁰→A` + `Mor(ℙ¹,A)` constant (Milne 3.2/3.10) + rational-map extension, char-free and cohomology-free.
- **Mathematical soundness**: PASS — bare-rigidity well-definedness (no Serre duality) and the rational-map-into-AV regularity are the correct RR-free ingredients. Route 2 (autoduality) correctly flagged CONTINGENT and UNVERIFIED for RR-freeness, with a cheap literature check scheduled.
- **Verdict**: SOUND

### Route: Route C — Riemann–Roch (PAUSED, permanent)

- **Goal-alignment**: PARTIAL — see the must-fix below. The line "**Needed at the three Goal nodes**" directly contradicts the RR-free posture asserted everywhere else in the strategy. If RR is genuinely required at the Goal nodes and is permanently paused with inline sorries, the stated goal ("zero inline sorry in the dependency cone of each protected decl") is unreachable. The strategy must state unambiguously that the RR-free route (A.2.c engine + A.4 Route 1 + genus-0 arm (a)) discharges ALL three Goal nodes without RR, and reword the RR row so "needed" applies only to the abandoned cheap curve route.
- **Verdict**: CHALLENGE

## Format compliance

- **Size**: 149 lines / 13316 bytes — over budget (~12 KB; lines OK).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Representative: "iter-257 found the engine `chartOverIso`", "(iter-257: 5→1)", "**SHARED ROOT — ... iter-257 found that**", "being OPENED (was: held)", "(was: held)". The skeleton explicitly bans `iter-NNN` references and "was: …" history in STRATEGY.md; this belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no (table) — completed group law is summarized in one line, no DONE phase row lingers. Minor closed-sub-step detail (D2′ closed, etc.) persists in the Routes prose but is acceptable as live context.
- **Table discipline**: FAIL — several Status cells carry multi-clause paragraphs ("ACTIVE; D1′/D2′/STEP A/`homOfLocalCompat` closed. Remaining: D3′ (...), D4′ chart-chase, `dual_restrict_iso` Step-4 (...)") rather than "one short line per cell." LOC cells correctly carry both figures.
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Route C: CHALLENGE — resolve the "Needed at the three Goal nodes" contradiction. State explicitly that the RR-free route discharges all three protected Goal nodes without RR (or, if it cannot, the permanent pause blocks the goal and the strategy is broken). This one sentence is the load-bearing claim of the entire architecture and currently reads as self-contradictory.
- Format: DRIFTED — strip all `iter-NNN` references and "(was: held)" history from STRATEGY.md (move to `iter/iter-258/plan.md`); compress the prose-heavy Status cells to one short line each; trim back under ~12 KB. The iter-narrative bleed is the most impactful deviation.

## Overall verdict

The Route-A bottom-up architecture is SOUND and the shared-root pivot is the correct call, not avoidance: making `SheafOfModules.overEquivalence` the primary lane is right because it unblocks BOTH the A.2.c engine deliverable (`IsFinitePresentation`, which is one sorry from done) and the dual inverse (`exists_tensorObj_inverse`) in a single ~200–350 LOC build, and its base prerequisite (`TopologicalSpace.Opens.overEquivalence`) plus the module-sheaf pullback/pushforward and site-over machinery all exist in Mathlib. There is no cheaper consumer-by-consumer route for the engine (it has no sectionwise alternative), so consolidating is correct. Opening the A.2.c engine's loc-triv coherence entry in parallel is justified precisely because it is nearly done and shares the same root. Two things must be addressed this iter: (1) the strategy "defers" Riemann–Roch permanently while simultaneously stating RR is "needed at the three Goal nodes" — this contradiction must be resolved by affirming that the RR-free route fully discharges all Goal nodes, or the goal is unreachable; and (2) the document has drifted from the canonical skeleton through pervasive `iter-257`/"was: held" per-iter narrative and prose-heavy table cells, which must be restructured in-place. The single largest substantive risk remains the A.2.c engine's ~85–140-iter aggregate (Quot/Hilbert/flattening/`Rⁱf_*`), which is honestly flagged but likely optimistic; the `Rⁱf_*` blueprint chapter must actually land next iter rather than slip again.
