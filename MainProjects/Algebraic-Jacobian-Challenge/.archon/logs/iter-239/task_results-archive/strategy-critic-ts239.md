# Strategy Critic Report

## Slug
ts239

## Iteration
239

## Routes audited

### Route: A.1.c — RelPic functor re-base onto `IsInvertible` (Route Y)

- **Goal-alignment**: PASS — the relative Picard functor on the `IsInvertible` carrier is the same object class as the line-bundle functor (Stacks 01CR equivalence), so re-basing does not change what `Pic⁰` parametrizes.
- **Mathematical soundness**: PASS — `IsInvertible.pullback` is genuinely dual-free: given a witness `M⊗N≅𝒪`, strong-monoidal pullback transports it to `f*M ⊗ f*N ≅ f*(M⊗N) ≅ f*𝒪 ≅ 𝒪`, so `f*N` is the new witness. No inverse object is constructed. This is a real reduction, not a renamed dual.
- **Sunk-cost reasoning detected**: no — the strategy explicitly *retracts* its own earlier "re-base is cheap" claim and discards the dishonest `PicSharp := const PUnit` / `functorial := 0` stubs. That is the opposite of sunk cost.
- **Infrastructure-deferral detected**: yes — see "Infrastructure-deferral findings" below. The `IsInvertible ⟺ IsLocallyTrivial` bridge is labeled "deferred / off critical path," but A.2.c representability plausibly requires it.
- **Phantom prerequisites**: none — both named backbone lemmas verified (see Prerequisite verification).
- **Effort honesty**: reasonable (mildly conservative). `~250–400 LOC` covers sub-steps (i)–(v), not just the pullback. The pullback substrate itself may be *under* this if it only needs the two component isos (`f*(M⊗N)≅f*M⊗f*N`, `f*𝒪≅𝒪`) rather than a full `Monoidal` typeclass instance on the sheaf-pullback composite. `~0/it` velocity is the just-reopened figure, not stagnation (an active lane exists this iter); planner should refresh it next iter.
- **Parallelism under-exploited**: no — engine foundations correctly de-gated to run alongside the substrate.
- **Verdict**: SOUND (the Route Y vs X decision is correct) — but carries a format CHALLENGE and an infrastructure-deferral CHALLENGE recorded below.

**On the directive's "third option":** carrying the relative functor directly on `IsInvertible` from A.1.b and never introducing `IsLocallyTrivial` as the `OnProduct` carrier is *not a distinct third route* — it is Route Y in its honest form. Since `OnProduct`/RPF are still unbuilt stubs, there is nothing to "re-base"; the cleanest framing is **author them directly on `IsInvertible`**. The strategy's "re-base" wording overstates the work (implying existing honest code must be migrated) when in fact the stubs are dishonest placeholders to be written fresh. Recommend the planner reframe sub-step (ii) as "author OnProduct/RPF on `IsInvertible`" — same work, more honest, and it dissolves the "re-base is not cheap" hand-wringing into ordinary first-build cost.

**On the backbone:** composing `(extendScalars f).Monoidal` with `sheafificationCompPullback` is the right route; Mathlib exposes `SheafOfModules.pullback` as a left adjoint (`pullbackPushforwardAdjunction`) and `pullbackObjUnitToUnit` for the `f*𝒪→𝒪` leg, but does **not** ship a packaged `Monoidal` instance on the sheaf pullback. There is no cleaner pre-packaged abstract route; the compose-it-yourself plan is correct.

### Route: A.1.c.SubT — ⊗-group law (`picCommGroup`)

- **Verdict**: SOUND — group law landed axiom-clean; the carrier pivot is now fully realized and the inverse-as-witness reduction is genuine. Only issue is documentary: this completed phase still occupies large prose blocks (see Format).

### Route: A.2.c — representability + Quot engine

- **Goal-alignment**: PASS — representability of the relative Picard functor is required by `J := Pic⁰`.
- **Mathematical soundness**: PARTIAL — see the deferral finding: the engine parametrizes coherent quotient sheaves with fixed Hilbert data; recognizing the Picard locus classically uses the locally-free-rank-1 (i.e. `IsLocallyTrivial`) characterization, which `IsInvertible` (`∃N, M⊗N≅𝒪`) does not directly supply (no coherence / Hilbert polynomial out of the box).
- **Infrastructure-deferral detected**: yes — `R^i f_*` (i≥1) and the `IsInvertible⟺IsLocallyTrivial` bridge (below).
- **Effort honesty**: reasonable — `~3400–5500 LOC` for an RR-free Quot/Hilbert engine is a large but plausibly honest estimate; the strategy flags it as the dominant cost and entirely pause-driven, which is candid.
- **Verdict**: SOUND for now (held behind A.1.c), with the deferral CHALLENGE on the bridge.

### Route: A.4 — Albanese UP (Route 2 autoduality / Route 1 RR-free fallback)

- **Goal-alignment**: PASS — `isAlbaneseFor` is reachable *either* way: Route 1 (Weil/rigidity, RR-free, already substrated in-tree) guarantees reachability under the permanent RR pause regardless of Route 2's autoduality RR-status.
- **Mathematical soundness**: PASS — the autoduality `J^∨≅J` is classically theta-divisor/RR-dependent; the strategy correctly treats this as unverified and keeps the RR-free fallback primary-eligible.
- **Verdict**: SOUND — deferring the autoduality literature check to "when A.2.c nears" is acceptable *because the RR-free fallback already guarantees the goal is reachable*; the check only decides which route is primary, not whether the goal holds. Minor: it is a cheap (Milne §III.6) check that gates ~600–1000 LOC of Route-2 work, so doing it earlier is low-cost insurance — but not a blocker.

## Format compliance

- **Size**: 155 lines / ~11 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Representative verbatim: "**DONE iter-238**", "the d.2 ingredient (`stalkTensorIso`...) landed iter-236", "was WIRED + closed iter-237", "`IsInvertible.pullback` [iter-239 lane]", "(iter-236/237)". The skeleton forbids `iter-NNN` references in STRATEGY.md; this is the most material violation.
- **Accumulation detected**: yes — the completed A.1.c.SubT phase still carries a full DONE table row plus a multi-paragraph `## Routes` block including "Rejected associator routes (a)/(b)", "Dead ends", and "Deferred (off critical path)" enumerations — historical detail that belongs in iter sidecars. The "Total Route A" paragraph still names the now-done associator/by-hand-CommGroup as "the ungated bottleneck" (stale).
- **Table discipline**: PASS — structurally a proper table with both LOC figures.
- **Internal contradiction**: the `## Routes` "Other remaining work" line calls the consumer re-base "cheap — unbuilt stubs", directly contradicting the table row and `## Open strategic questions` which (correctly) state the re-base is NOT cheap. One of these is stale and misleads the planner.
- **Format verdict**: DRIFTED — headings/table are clean, but pervasive `iter-NNN` narrative + completed-phase accumulation + the cheap/not-cheap self-contradiction are material and must be resolved this iter via in-place trim (push the dead-ends / rejected-routes / iter tags into iter sidecars).

## Infrastructure-deferral findings

### Deferred: `IsInvertible ⟺ IsLocallyTrivial` bridge (and the dual / `exists_tensorObj_inverse` it would use)

- **Required by goal**: partially / likely-yes-at-A.2.c — for the A.1.c group law it is genuinely not needed (the carrier pivot deleted it, correctly). But A.2.c representability is classically a statement about line bundles = coherent locally-free-rank-1 sheaves parametrized through the Quot/Hilbert engine; identifying the `IsInvertible`-carried functor with that classical locus needs the equivalence (Stacks 01CR). `IsInvertible` alone yields no coherence / Hilbert polynomial.
- **Current plan for building it**: none — labeled "deferred bridge" and "off critical path" with no project-side construction or timeline. Route X (the reverse direction via dual-gluing) is explicitly rejected/deferred.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — not REJECT, because the equivalence is a standard buildable result (Stacks 01CR/0B8K), the goal is not made unprovable, and Route 1/the engine may still be phraseable to need only one direction. But "off critical path" is the wrong label if A.2.c forces it. Planner must either (a) confirm A.2.c representability can be carried purely on `IsInvertible` without ever identifying it with locally-free-rank-1, or (b) reclassify the bridge as on-critical-path-at-A.2.c with an iter estimate.

### Deferred: `R^i f_*` (i≥1)

- **Required by goal**: yes — gates the RR-free Quot/Hilbert engine that discharges A.2.c representability.
- **Current plan for building it**: three named options (Mathlib PR / project Čech build ~800–1200 LOC / typed-sorry pin), decision pinned to "when the engine de-gates."
- **Timeline**: deferred-with-decision-point (acceptable) — options + LOC are named, so this is a planned dependency, not an open gap. Flagging as the single dominant technical risk of the whole engine, not as a violation.
- **Verdict**: CHALLENGE-lite (informational) — acceptable as planned, but it is the deepest root; the engine's entire ~3400–5500 LOC estimate is hostage to which of the three options is taken. Resolve the decision before committing heavy engine LOC.

## Prerequisite verification

- `(extendScalars f).Monoidal`: VERIFIED — `Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean:42`.
- `SheafOfModules.sheafificationCompPullback`: VERIFIED — `Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:117`.
- `SheafOfModules.pullback` (+ `pullbackPushforwardAdjunction`, `pullbackObjUnitToUnit`): VERIFIED — `.../Sheaf/PullbackContinuous.lean:53,60` and `.../Sheaf/PullbackFree.lean:90` (the latter gives the `f*𝒪→𝒪` unit leg).
- Packaged `Monoidal` instance on `SheafOfModules.pullback`: MISSING — must be assembled from the two pieces above (as the strategy already plans).

## Must-fix-this-iter

- Route A.1.c / A.2.c: infrastructure-deferral CHALLENGE — the `IsInvertible⟺IsLocallyTrivial` bridge is labeled "off critical path" but A.2.c representability likely requires it. Planner must either confirm A.2.c is carryable purely on `IsInvertible`, or reclassify the bridge as on-critical-path with an iter estimate (rebuttal in plan.md acceptable).
- Format: DRIFTED → restructure in-place this iter. Three deviations: (1) strip pervasive `iter-NNN` narrative; (2) shrink/remove completed-phase A.1.c.SubT prose + dead-ends/rejected-routes enumerations into iter sidecars; (3) resolve the "re-base is cheap" vs "NOT cheap" self-contradiction (the table/open-questions version is correct).

## Overall verdict

The Route Y vs Route X decision is **sound**: `IsInvertible.pullback` transports the tensor-inverse existence witness through a strong-monoidal pullback and is genuinely dual-free, both backbone Mathlib lemmas are verified to exist, and Route X (locally-trivial ⟹ invertible) correctly stays the harder dual-gluing path. The carrier pivot is now fully realized — the group law is real, the inverse-as-witness reduction is honest, and the strategy creditably retracts its own earlier "cheap re-base" error. There is no live sunk-cost reasoning. However, **the strategy defers the `IsInvertible ⟺ IsLocallyTrivial` bridge, which is required for the stated goal** at A.2.c representability (where the Quot/Hilbert engine parametrizes coherent locally-free-rank-1 sheaves and the bare `IsInvertible` predicate supplies neither coherence nor a Hilbert polynomial); "off critical path" is the wrong label and must be re-examined now that the carrier pivot is complete and A.1.c is the active frontier. Separately, the document has drifted from the skeleton (pervasive iter-NNN narrative, completed-phase accumulation, and an internal cheap/not-cheap contradiction) and should be trimmed in place this iter. The A.4 autoduality deferral is acceptable because the in-tree RR-free Route 1 already guarantees `isAlbaneseFor` is reachable under the permanent RR pause.
