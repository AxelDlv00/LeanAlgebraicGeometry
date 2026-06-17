# Strategy Critic Report

## Slug
sc261

## Iteration
261

## Routes audited

### Route: A.1.c.sub — comparison iso on line bundles (+ dual route-2)

- **Goal-alignment**: PASS — the comparison iso on loc-triv pairs is exactly what RPF `map_add` and `IsInvertible.pullback` consume.
- **Mathematical soundness**: PASS — `f^*` strong monoidal ⟹ δ iso on all objects; proving only the loc-triv case via `isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}` is a sound sufficient restriction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the route-1→route-2 pivot is NOT avoidance: the hardest prerequisite genuinely changed (route-1 root = sheaf-level `overEquivalence`, which carries no dual content; route-2 root = slice-site Hom base-change). Different gap, real pivot.
- **Phantom prerequisites**: none — I confirmed Mathlib has **no** `MonoidalClosed (SheafOfModules _)` (loogle: no results), which validates the "build `sliceDualTransport` by hand" justification: the generic `Sheaf.monoidalCategory`/internal-Hom path genuinely does not type-check for the varying-ring module tensor.
- **Effort honesty**: reasonable — 250 LOC ÷ 25/it ≈ 10 iters, inside the stated 8–14; the "elapsed 25 vs orig 6–11" admission is honest.
- **Parallelism under-exploited**: no — D3′-outer, D4′, and the dual workstream are correctly flagged independent/parallel.
- **Verdict**: CHALLENGE — see the dual-route note below; the comparison-iso half is SOUND.

**Dual route-2 challenge.** Route-2 (`sliceDualTransport` = leg-A slice-site Hom base-change via Beck–Chevalley across `f.opensFunctor` ∘ leg-B `restrictScalarsRingIsoDualEquiv`) is *plausible and the by-hand necessity is confirmed*, but it is not obviously the **cheapest** by-hand path to the RPF inverse `exists_tensorObj_inverse`. Two reductions the strategy does not consider:

1. **Loc-triviality of the inverse is nearly free and need not be carried by `sliceDualTransport`.** The goal is `∃ Linv, IsLocallyTrivial Linv ∧ (L⊗Linv≅𝒪)`. Once *any* global `Linv` with `L⊗Linv≅𝒪` exists, loc-triviality of `Linv` follows on the SAME trivialising cover with no dual-transport: on each `U`, `Linv|U ≅ (𝒪⊗Linv)|U ≅ L|U⊗Linv|U ≅ (L⊗Linv)|U ≅ 𝒪|U`, using only the comparison-iso-restricted (already being built in this same phase) + the loc-triv hypothesis `L|U≅𝒪` + the unit. So `sliceDualTransport` should only have to deliver the **evaluation iso** `L⊗L^∨≅𝒪`, not the loc-triviality — scope it down accordingly.

2. **Stalkwise evaluation iso instead of slice-site Hom base-change.** The evaluation `L⊗L^∨→𝒪` can be checked on **stalks** via the already-axiom-clean `stalkTensorIso` (project, per the strategy's own engine history) + a stalk-dual commutation `ℋom(L,𝒪)_x ≅ Hom(L_x,𝒪_x)` (L loc-triv ⟹ finitely presented ⟹ Hom commutes with stalks). This routes through `isIso_of_isIso_stalk`-style locality rather than the slice-site Beck–Chevalley Hom base-change, reusing in-tree machinery and avoiding `f.opensFunctor` Beck–Chevalley + `eqToHom`-conjugation entirely. The planner should weigh this against route-2 before committing the ~150–250 LOC of `DualInverse.lean`.

The planner must either (a) confirm `sliceDualTransport`-via-slice-Hom-base-change is genuinely cheaper than the stalkwise route and that it cannot be scoped down per (1), or (b) record a rebuttal naming why the stalk route fails (e.g. stalk-Hom commutation is itself Mathlib-absent and costlier than the slice transport).

### Route: A.1.c.fun — relative Picard functor on `IsLocallyTrivial`

- **Goal-alignment**: PASS — RPF intrinsically classifies loc-triv line bundles; carrier choice matches the consumer.
- **Mathematical soundness**: PASS — `map_add`←comparison iso, `map_zero`←`pullbackUnitIso`, inverse←`exists_tensorObj_inverse` (returns loc-triv witness) keeps group closure in-carrier. Modeled on `CommRing.Pic.mapAlgebra`.
- **Verdict**: SOUND — opening against a typed-sorry bridge whose discharge = D4′ is a clean parallelization.

### Route: A.2.c — representability + Quot engine (RR-free pole)

- **Goal-alignment**: PASS — under the permanent RR pause, the Quot/Hilbert engine is the ONLY route to Pic⁰ representability; it is correctly on the critical path, not a goal weakening.
- **Mathematical soundness**: PASS — Nitsure §5 + Kleiman §4 is the standard construction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — see the dedicated finding below. The dominant pole `Rⁱf_*` (i≥1, ~800–1200 LOC project Čech) is group-law-independent, blueprint-authored, yet shows `~0/it` velocity with **no active lane** ("opens when capacity frees").
- **Phantom prerequisites**: none claimed to exist that don't; the strategy correctly marks `Rⁱf_*`, Relative Proj, CM-regularity, flattening, Quot, relative Cartier as Mathlib-absent and to-be-built.
- **Effort honesty**: under-counted (self-admitted "likely optimistic") — 85–140 iters for the whole AG cohomology+Quot engine is plausibly low for ~3400–5500 LOC of Mathlib-absent foundations; but the honesty flag is present.
- **Parallelism under-exploited**: yes — the engine is ~100 iters (the bulk of the 120–230-iter project total) and is independent of the ~10-iter substrate finish, yet it idles behind it.
- **Verdict**: CHALLENGE — the engine's `Rⁱf_*` Čech lane should open in parallel NOW, not after A.1.c.sub.

### Route: A.4 — Albanese UP (Route 1 RR-free primary)

- **Goal-alignment**: PASS — Route 1 (Weil divisor-sum map + Milne 3.2/3.10 rigidity) delivers `isAlbaneseFor` without RR.
- **Mathematical soundness**: PARTIAL — the rigidity/well-definedness half (Mor(ℙ¹,A) constant) is genuinely RR-free, but the **divisor ↔ Pic⁰ dictionary** that the divisor-sum map presupposes (every Pic⁰ class is a divisor class; `𝒪_C(D)` construction) overlaps the paused `RiemannRoch_WeilDivisor` / `RiemannRoch_OcOfD` chapters. Verify Route 1 does not transitively pull a paused RR declaration — if it does, "Route 1 is RR-free" is false and Route 1 is not actually unblocked under the pause.
- **Verdict**: CHALLENGE — confirm the A.4 Route-1 cone is disjoint from the RR-paused divisor infrastructure, or relocate the needed divisor↔Pic decls out of the paused cone.

### Route: A.1.c.fun group-carrier / Route C (RR paused) / genus-0 arm

- Route C pause and the "RR never on the critical path" architecture is internally consistent given A.2.c engine + A.4 Route 1 discharge all three Goal nodes. **Verdict**: SOUND (contingent on the A.4 disjointness check above).
- Genus-0 arm (a) transits A.2.c; (b) paused. **Verdict**: SOUND.

## Format compliance

- **Size**: 152 lines / 13192 bytes — **over budget** (~12 KB cap; 12.9 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — `## Mathlib gaps` contains "CLOSED axiom-clean (iter-259)" and "confirmed iter-260"; these specific-iteration references belong in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no — completed group law compressed to one line; paused-RR material correctly retained as documented new material.
- **Table discipline**: PASS — proper table, both LOC figures present per row.
- **Appendix sections**: none.
- **Format verdict**: DRIFTED — strip the two `(iter-259)`/`iter-260` references (replace with "closed" / "confirmed") and trim ~1 KB to get under budget.

## Infrastructure-deferral findings

### Deferred: `Rⁱf_*` (i≥1) higher direct images + the A.2.c Quot/Hilbert engine

- **Required by goal**: yes — under the permanent RR pause, Pic⁰ representability has no other route; the goal's `J := Pic⁰_{C/k}` as a scheme/abelian variety is unreachable without it.
- **Current plan for building it**: project Čech build (~800–1200 LOC for `Rⁱf_*`; ~3400–5500 LOC engine total), blueprint chapter `Cohomology_CechHigherDirectImage` authored; Lean scaffold "opens when capacity frees."
- **Timeline**: present but deferred — `~0/it`, no active lane, gated on "capacity," not on a logical dependency (the pole is group-law-independent).
- **Verdict**: CHALLENGE — this is deferral-by-inaction of the project's largest and most critical-path pole. A concrete plan exists, so not REJECT; but the `Rⁱf_*` lane must open in parallel this iter (or the planner must record why capacity genuinely forbids it). Sequencing the ~100-iter pole strictly after the ~10-iter substrate inflates wall-clock by roughly the substrate's length for no logical reason.

## Alternative routes (suggested)

### Alternative: stalkwise evaluation iso for the tensor-inverse (replaces `sliceDualTransport`)

- **What it looks like**: produce `Linv := L^∨` (already a global decl), prove `L⊗L^∨≅𝒪` by checking the evaluation map is iso on **stalks** via the in-tree axiom-clean `stalkTensorIso` plus a stalk-dual commutation `ℋom(L,𝒪)_x≅Hom(L_x,𝒪_x)` (valid since loc-triv ⟹ finitely presented), then derive `IsLocallyTrivial L^∨` for free from `L⊗L^∨≅𝒪` + the comparison-iso-restricted (no dual transport needed for that half).
- **Why it might be cheaper or sounder**: reuses `stalkTensorIso` (already done) and the stalk-locality criteria the project already built for `Scheme.Modules` iso-locality, instead of constructing slice-site Hom base-change (Beck–Chevalley across `f.opensFunctor` with `eqToHom`-conjugation and poset-thin naturality), which is fresh ~150–250 LOC.
- **What the current strategy may have rejected**: unclear — the strategy justifies *by-hand* (correctly, no `MonoidalClosed`) but does not compare the slice-site route against the stalk route; it may simply have inherited the slice framing from the dead route-1.
- **Severity of the omission**: major.

## Prerequisite verification

- `MonoidalClosed (SheafOfModules _)`: MISSING (confirms by-hand dual is required — supports the strategy).
- `SheafOfModules.pullback` / `pullbackComp` / `pullbackPushforwardAdjunction`: VERIFIED (Mathlib, `…Sheaf.PullbackContinuous`).

## Must-fix-this-iter

- Route A.1.c.sub (dual route-2): CHALLENGE — confirm `sliceDualTransport`-via-slice-Hom-base-change is cheaper than the stalkwise evaluation-iso route AND that the transport need not also carry loc-triviality of the inverse (derivable from `L⊗Linv≅𝒪` + comparison iso); else adopt the stalk route or scope it down.
- Route A.2.c engine: infrastructure-deferral CHALLENGE — `Rⁱf_*` (i≥1) required by goal, group-law-independent, `~0/it` with no active lane. Open the Čech `Rⁱf_*` lane in parallel this iter or record why capacity forbids it.
- Route A.4: CHALLENGE — verify Route-1's divisor-sum cone is disjoint from the RR-paused `WeilDivisor`/`OcOfD` chapters; "Route 1 is RR-free" is false if it transitively pulls a paused divisor↔Pic decl.
- Format: DRIFTED — remove `(iter-259)`/"confirmed iter-260" per-iter references; trim to under 12 KB.

## Overall verdict

The RR-free Route-A arc (A.1.c.sub → A.1.c.fun → A.2.c) is mathematically sound and goal-aligned, and the comparison-iso half plus the route-1→route-2 dual pivot are genuine (not avoidance — the hardest prerequisite truly changed, and the by-hand necessity is confirmed by the absence of `MonoidalClosed (SheafOfModules _)`). Two live issues. First, **the strategy defers `Rⁱf_*` and the A.2.c Quot engine**, which is required for the stated goal under the permanent RR pause — it is group-law-independent and ~100 iters (the bulk of the project) yet idles at `~0/it` behind a ~10-iter substrate, so its lane should open in parallel now rather than "when capacity frees." Second, the dual route-2 (`sliceDualTransport`) is plausible but likely over-scoped: loc-triviality of the inverse is nearly free given `L⊗Linv≅𝒪` + the comparison iso, and the evaluation iso itself may be cheaper via the already-built `stalkTensorIso` than via slice-site Beck–Chevalley Hom base-change — the planner should compare before committing the new file. A.4 Route 1's RR-freeness must be re-checked for a hidden dependency on the paused divisor↔Pic chapters. Format is DRIFTED (slightly over 12 KB; two per-iter references to strip).
