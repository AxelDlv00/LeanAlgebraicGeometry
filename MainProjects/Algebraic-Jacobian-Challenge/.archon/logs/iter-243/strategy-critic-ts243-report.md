# Strategy Critic Report

## Slug
ts243

## Iteration
243

## Routes audited

### Route: A.1.c — relative Picard functor on `IsInvertible` (the live pivot)

- **Goal-alignment**: PASS — the relative Picard functor only ever pulls back invertible modules (line bundles); the invertible-only `IsInvertible.pullback` is exactly what `OnProduct`/functoriality consume.
- **Mathematical soundness**: PASS — the local-trivialization argument is correct. On a trivialising cover `{V_i}` of the base where `M|_{V_i}≅𝒪` and `N|_{V_i}≅𝒪`, `f^*` of each factor restricts (via `f^*𝒪≅𝒪`, the landed `pullbackUnitIso`) to `𝒪` on `f^{-1}(V_i)`, so `δ_sheaf` restricts to the canonical `𝒪⊗𝒪≅𝒪` comparison and is iso; `isIso_of_isIso_restrict` globalises. The witness `f^*N` with `δ_sheaf⁻¹ ≫ (f^*)e ≫ pullbackUnitIso` is well-formed.
- **Sunk-cost reasoning detected**: no — the pivot explicitly ABANDONS the concrete-`P` route (sunk cost from iter-242) on its merits, which is the correct anti-sunk-cost move.
- **Infrastructure-deferral detected**: no — see the dedicated analysis below. The hardest prerequisite genuinely changes from an *absent construction* (concrete inverse image + `extendScalars`) to a *provable lemma* (`IsInvertible⇒IsLocallyTrivial`) over existing stalk/restriction machinery.
- **Phantom prerequisites**: none. All named in-tree decls verified present (see Prerequisite verification).
- **Effort honesty**: mildly under-counted on iters — `~350–600 LOC · ~25/it` ÷ `~25/it` ⇒ 14–24 iters, not the stated `7–11`. The `(bursty)` qualifier implies burst velocity well above 25/it; it loosely reconciles but the row's two figures are not internally consistent with the 25/it nominal rate. Minor.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND

### Route: A.1.c.SubT — group law via tensor-invertibility carrier (DONE)

- **Verdict**: SOUND — `picCommGroup` axiom-clean; carrier choice makes the inverse a free witness. (Minor accumulation note: this DONE sub-route still occupies a full paragraph; see Format.)

### Route: A.2.c — representability + Quot fork (held)

- **Goal-alignment**: PASS — scaffolds representability under `⟨sorry⟩` typeclasses; goal requires it.
- **Mathematical soundness**: PASS.
- **Infrastructure-deferral detected**: no (the engine has a concrete decomposition + an active sub-lane; see below).
- **Effort honesty**: reasonable — `~3400–5500 LOC` at focused `~60–90/it` ⇒ ~38–92 iters, consistent with stated `~30–60`.
- **Parallelism under-exploited**: PARTIAL throughput risk — the engine currently advances at the `side-lane ~5/it` trickle, at which `3400–5500 LOC` is ~680–1100 iters. The `~30–60` figure is only reachable under a dedicated focused phase. The strategy is honest about this but the engine is effectively near-stalled while A.1.c is the focus; a focused engine phase must be scheduled, not left as a trickle.
- **Verdict**: SOUND (with the throughput caveat noted, not blocking this iter).

### Route: Albanese UP — two-route fork

- **Goal-alignment**: PASS — both routes reach `isAlbaneseFor`.
- **Mathematical soundness**: PASS — Route 2 autoduality landing (theta-divisor) is correctly flagged as classically RR-dependent and UNVERIFIED; the RR-free Route 1 (Weil/rigidity, Milne 3.2/3.10) is named as fallback and is already substrated in-tree.
- **Verdict**: SOUND — the second-verify-before-committing posture is correct; do not let it slip past A.2.c-near as the strategy itself warns.

### Route: Route C (Riemann–Roch) — PAUSED (USER)

- **Verdict**: SOUND — USER-imposed pause; the strategy honestly records that the entire RR-free engine + autoduality risk exist solely to route around it. Not a strategy-critic-actionable item.

## Format compliance

- **Size**: 175 lines / 15.5 KB — **over budget** (~12 KB ceiling; under on lines, ~29% over on bytes).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — repeated `iter-242` references, e.g. `` "(`presheafPullbackOplaxMonoidal`, iter-242)" `` and `"the iter-242 concrete-`P` / PR #36599 plan"`. Per-iter tags belong in the iter sidecar, not STRATEGY.md.
- **Accumulation detected**: yes (minor) — `A.1.c.SubT (DONE)` retains a full paragraph; could compress to one line now that the group law is closed.
- **Table discipline**: PASS — correct columns; LOC cells carry both `rem · /it` figures.
- **Appendix sections**: none.
- **Format verdict**: DRIFTED

## Prerequisite verification

- `IsLocallyTrivial.pullback`: VERIFIED (LineBundlePullback.lean:156)
- `tensorObj_isLocallyTrivial`: VERIFIED (TensorObjSubstrate.lean:536)
- `isIso_of_isIso_restrict`: VERIFIED (TensorObjSubstrate.lean:567)
- `presheafPullbackOplaxMonoidal` / `presheafPushforwardLaxMonoidal`: VERIFIED (TensorObjSubstrate.lean:1159)
- `sheafifyTensorUnitIso`: VERIFIED (TensorObjSubstrate.lean:1084)
- `SheafOfModules.sheafificationCompPullback`: VERIFIED — exists and is already *used* in-tree (TensorObjSubstrate.lean:463); not phantom.
- `pullbackUnitIso`: VERIFIED (referenced/landed).

## Alternative routes (suggested)

### Alternative: stalkwise δ-iso instead of cover-restriction

- **What it looks like**: prove `δ_sheaf` iso by showing it is iso on every stalk (`isIso_of_stalkFunctor_map_iso`), using that an invertible module has free-rank-1 stalks and `δ` localises to the canonical `R_x`-module comparison.
- **Why it might be cheaper or sounder**: avoids constructing/handling a trivialising cover explicitly.
- **What the current strategy may have rejected**: the stalkwise route needs the varying-ring **stalk-tensor** `(A⊗B)_x≅A_x⊗_{R_x}B_x` — this is precisely the abandoned **d.2** build (Stacks `lemma-stalk-tensor-product`), historically the project's worst sink. The cover route reuses the already-proven `isIso_of_isIso_restrict` + `IsLocallyTrivial.pullback` and avoids d.2 entirely.
- **Severity of the omission**: minor — the strategy's chosen cover route is the *better* of the two; this entry documents *why* (so the route is not later "simplified" into reviving d.2). Treat as a guardrail, not a gap.

## Must-fix-this-iter

- Format: DRIFTED — (1) trim STRATEGY.md back under ~12 KB (currently 15.5 KB; the A.1.c route paragraph + Open-questions duplicate much of the phase-table cell and the Mathlib-gaps bullet — collapse the triple statement of the local-trivialization recipe to one canonical place); (2) strip all `iter-242` per-iter references (move to the iter sidecar); (3) compress the `A.1.c.SubT (DONE)` paragraph to one line. None of these block the math, but they must be done in-place this iter.

## Overall verdict

The iter-243 pivot is **SOUND and is a genuine reduction, not infrastructure-deferral**. The hardest prerequisite changes substantively: the abandoned concrete-`P` route required *absent Mathlib constructions* (`PresheafOfModules.extendScalars` + a topological inverse-image via left Kan extension), whereas the local-trivialization route requires a *provable lemma* (`IsInvertible⇒IsLocallyTrivial`, Stacks 01CV/0B8M) discharged over already-present stalk/restriction infrastructure, plus a sheafification-transport of an already-landed presheaf `δ` — every named support decl (`IsLocallyTrivial.pullback`, `tensorObj_isLocallyTrivial`, `isIso_of_isIso_restrict`, `sheafifyTensorUnitIso`, `sheafificationCompPullback`, `presheafPullbackOplaxMonoidal`, `pullbackUnitIso`) is verified in-tree. **Q1**: descoping the general `pullbackTensorIso` to the invertible case is sound — nothing on A.1.c→A.2.c→A.3→A.4 needs `f^*` to commute with `⊗` for non-invertible modules; the Picard functor, the Quot embedding, the tangent-space/`Spec k[ε]` computation, and the Albanese UP all pull back only invertible (or unit) modules. **Q2**: the forward-bridge dependency is a real difficulty reduction, not a relocated obstacle, because it does NOT re-summon the absent inverse-image construction. **Q3**: pulling `IsInvertible⇒locally-free-rank-1` forward from A.2.c to A.1.c is a legitimate free double-serve — A.1.c precedes A.2.c, the two consumers want the same lemma, and there is no ordering hazard. The only must-fix is **format DRIFT** (15.5 KB over the 12 KB budget + `iter-242` per-iter references), to be restructured in-place this iter; the secondary watch-item is the A.2.c-engine throughput — at the current `~5/it` side-lane trickle the `~30–60`-iter estimate presupposes a future focused phase that must be scheduled rather than assumed.
