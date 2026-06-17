# Progress Critic Directive

## Slug
route189

## Active routes / files (signals from K=4 iters: iter-185 → iter-188)

### Route Lane A — `RiemannRoch/OCofP.lean` (RR.3)

- **Strategy phase**: Genus-0 RR.3 — `O_C(P)` global sections (carrierSubmodule cascade closures).
- **Strategy `Iters left`**: ~10-20.
- **Phase entry iter**: iter-185 (carrierSubmodule API rebuild lane).

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 10 | 0 (refactor scoped) | PARTIAL | "carrierSubmodule analogist recipe" |
| 186 | 7 | +3 (refactor Steps 1+2) | SUCCESS (refactor) | "carrierSubmodule body skeleton" |
| 187 | 4 (−3 cascade closures) | +3 helpers (refactor Steps 3+4+5) | SUCCESS | "carrierPresheaf + isSheaf + bundle" |
| 188 | 4 (0 net; Case A closed; Case B failed) | +1 (`carrierSubmoduleSheaf` ⊓ trivAtBot fix) | PARTIAL structural | "discovered carrierPresheaf sheaf-axiom violation at ⊥", "Subfunctor refactor iter-189" |

### Route Lane A.3.i — `Picard/IdentityComponent.lean` (group-scheme identity component)

- **Strategy phase**: A.3.i `GroupScheme.IdentityComponent`.
- **Strategy `Iters left`**: ~4-8.
- **Phase entry iter**: iter-185 (chapter split Path B).

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | (chapter pending) | — | (chapter only) | — |
| 186 | 5 (Path B split landed) | +5 pinned scaffolds | PARTIAL | "Path B chapter split", "isOpenSubgroupScheme open-half" |
| 187 | 9 (+4 directive-licensed) | +5 (4 scaffolds + 1 helper) | PARTIAL substantive | "EGA I 6.1.9 relocated to focused private helper" |
| 188 | 8 (−1 EGA closure) | +3 (2 topology helpers + 1 wrapper) | SUCCESS | "EGA I 6.1.9 closed axiom-clean ~50 LOC", "Path B + helper relocation validated" |

### Route Lane I — `RiemannRoch/RationalCurveIso.lean` (RR.4 rational ⟹ ℙ¹)

- **Strategy phase**: Genus-0 RR.4.
- **Strategy `Iters left`**: ~6-10.
- **Phase entry iter**: iter-183.

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 3 | 0 | PARTIAL (STUCK) | "circular dep: poleDivisor body vs degree helper" |
| 186 | 3 | 0 | BLOCKED (STUCK) | "circular dep iter-186 CRITICAL finding" |
| 187 | 3 | +4 typeclasses | SUCCESS (4-iter route broken) | "Hom.poleDivisor body via [Algebra K(ℙ¹) K(C)] binder" |
| 188 | 2 (−1) | 0 | SUCCESS | "localParameterAtInfty closed axiom-clean via 4-step recipe" |

### Route Lane G — `Albanese/AuslanderBuchsbaum.lean` (A.4.b)

- **Strategy phase**: A.4.b Auslander–Buchsbaum.
- **Strategy `Iters left`**: ~10-18.
- **Phase entry iter**: iter-186.

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 3 | 0 | (not active) | — |
| 186 | 3 (R⧸(x) bridge axiom-clean) | +1 | SUCCESS bridge | "regularLocal_inductive_step R⧸(x) bridge" |
| 187 | 3 (+1 from scaffold) | +2 (cotangent dim-drop helpers per analogies/) | PARTIAL G1 | "Helper 1.5 toCotangent_ne_zero_of_not_mem_sq", "Helper 2.0 spanFinrank-dim-drop" |
| 188 | 2 (−1 G1 closure) | 0 | SUCCESS (G1) | "finrank_cotangentSpace_quot_span_singleton_succ closed kernel-only ~150 LOC", "G2 unblocked" |

### Route Lane F — `Picard/QuotScheme.lean` (A.2.b.iii Quot)

- **Strategy phase**: A.2.b.iii Quot assembly.
- **Strategy `Iters left`**: ~36-72.
- **Phase entry iter**: iter-176.

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 9 | +2 | PARTIAL | "baseMap axiom-clean; IsBaseChange Prop deferred" |
| 186 | 9 (0 net) | +1 helper | PARTIAL substantive | "Step 2 axiom-clean; Step 4 deferred" |
| 187 | 11 (+2 directive-licensed) | +2 (Stacks 01HQ + 01XJ named typed sorries) | PARTIAL substantive | "analogist-licensed refactor: Module.Flat.isBaseChange category mistake dropped", "threaded [IsQuasicoherent] through 9 sigs" |
| 188 | 11 (0 net; 1 closed + 1 added in localized helper) | +1 (`_sectionLinearEquiv` Σ-pair) | PARTIAL substantive (HARD BAR technically met) | "`baseMap_isBaseChange` body axiom-clean via IsBaseChange.of_equiv", "substantive content fully localized" |

### Route Lane H — `RiemannRoch/RRFormula.lean` (RR.2)

- **Strategy phase**: Genus-0 RR.2.H⁰ + RR.2.H¹.
- **Strategy `Iters left`**: RR.2.H⁰ = DONE; RR.2.H¹ = ~8-12.
- **Phase entry iter (Lane H)**: iter-180.

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 2 | 0 | PARTIAL | "structural watch: OcOfD value-pinning" (unrelated) |
| 186 | 1 → 2 (+1 structural) | +3 sub-helpers | PARTIAL substantive | "eulerCharacteristic_iso Tier-1 axiom-clean", "decomposed into 3 sub-helpers" |
| 187 | (DEFERRED HARD GATE; chapter MF-1 fix `rrformula-h0h1split` landed) | — | — | "blueprint H⁰/H¹ split + 3 substrate pins" |
| 188 | 2 (0 net; H⁰ closed axiom-clean; H¹ → typed sorry) | +1 (`H0_skyscraperSheaf_finrank_eq_one` axiom-clean; `H1_skyscraperSheaf_finrank_eq_zero` Tier-3 sorry) | PARTIAL substantive (HARD BAR met) | "RR.2.H⁰ closed", "H¹ STRATEGY sub-phase confirmed off path" |

### Route Lane B — `Genus0BaseObjects/GmScaling.lean` (Genus-0 chart-bridge cross01)

- **Strategy phase**: Genus-0 rigidity chart-bridge (III.c).
- **Strategy `Iters left`**: USER ESCALATION committed Option B substrate.
- **Phase entry iter (Lane B cross01)**: iter-182.

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 4 | +5 path III.a refactor | PARTIAL | "5-iter CHURNING confirmed; path III.a Mathlib gap" |
| 186 | 4 (0 net) | 0 | PARTIAL | "Recipe 2/3 BLOCKED on Mathlib simp coverage gap; iter-187 separated-locus pivot" |
| 187 | (DEFERRED HARD GATE; chapter MF-2 fix `avr-iiic-pivot-label` landed) | — | — | "III.c MANDATORY PIVOT chapter relabel; III.a BLOCKED + III.b DESCOPED" |
| 188 | 4 (0 net; HARD BAR FIRES) | +0 (Steps 1-3 structural; Step 4 BLOCKED) | BLOCKED | "`IsClosedImmersion.lift_iff_range_subset` NOT in Mathlib at b80f227 — FALSIFIED blueprint substrate", "Options A/B/C; USER ESCALATION" |

### Route Lane E — `AbelianVarietyRigidity.lean` (genus-0 ℙ¹ → AV constant via 𝔾_m chart bridge)

- **Strategy phase**: Genus-0 rigidity chart-bridge (III.c) substrate hooks.
- **Strategy `Iters left`**: Mathlib analogist consult iter-189 committed.
- **Phase entry iter (Lane E iotaGm)**: iter-170 (originally `iotaGm_chart1_composition_isOpenImmersion`).

| Iter | Sorries | Helpers added | Prover status | Recurring phrases |
|---|---|---|---|---|
| 185 | 2 | 0 | PARTIAL | "appTop residual refined; iter-187 closure recipe inline" |
| 186 | 2 (0 net) | 0 | PARTIAL | "appTop residual refined into 6-step iter-187 closure recipe" |
| 187 | (DEFERRED HARD GATE pending Lane B chapter fix) | — | — | "Lane E shared chapter with Lane B (AVR.tex); MF-2 fix landed" |
| 188 | 2 (0 net; HARD BAR FIRES) | 0 (3 attempts: simp default + cancel_mono + MvPolynomial.ringHom_ext all failed) | BLOCKED | "`r_1.appTop` from `h_r_1` alone STRUCTURALLY IMPOSSIBLE — image-mismatch on `(Proj.awayι).appTop`", "Mathlib analogist consult iter-189" |

## PROGRESS.md `## Current Objectives` proposal for iter-189 (planner's draft)

8-9 lanes contemplated:

1. `OCofP.lean` — Lane A iter-189: refactor via `CategoryTheory.Subfunctor.isSheaf_iff` (~80-120 LOC). Pre-refactor agent dispatch + prover.
2. `AuslanderBuchsbaum.lean` — Lane G2 joint induction (~200 LOC; unblocked by iter-188 G1 closure).
3. `RationalCurveIso.lean` — Lane I `Hom.poleDivisor_degree_eq_finrank` body via 5-step `Ideal.sum_ramification_inertia` scaffold (unblocked by iter-188 localParameterAtInfty closure).
4. `QuotScheme.lean` — Lane F `_sectionLinearEquiv` body closure (~30-50 LOC route-stitching; OR fall back to project-side `affineOpen_tilde_iso` ~50-80 LOC).
5. `IdentityComponent.lean` — Lane A.3.i continuation: 8 remaining sorries (Pic0Scheme.isAbelianVariety + scaffolds + `IdentityComponent` body).
6. `RRFormula.lean` — Lane H assembly cleanup (eulerCharacteristic_skyscraperSheaf body now sorry-free modulo H¹ helper).
7. `AbelianVarietyRigidity.lean` — Lane E: dispatch mathlib-analogist BEFORE prover; deferred prover this iter (HARD BAR escalation per iter-188).
8. `GmScaling.lean` — Lane B: planner-committed Option B project-side substrate; dispatch mathlib-analogist OR refactor for `IsClosedImmersion.lift_iff_range_subset` build.

(Lanes 7 + 8 may be PLAN-PHASE consults; prover dispatch contingent on consult returns.)

Off-limits iter-189: `CodimOneExtension.lean` (Lane M↓ COMPLETE-EXCEPT-UPSTREAM-GAP); `OcOfD.lean` (Lane J BLOCKED structurally); `BareScheme.lean` (Mathlib gaps off-target).

## Question

Audit each route's K=4 trajectory. Render CONVERGING / CHURNING / STUCK / UNCLEAR verdicts. Surface dispatch-sanity concerns about the 8-9 lane proposal. For Lane B + Lane E (BLOCKED iter-188), assess whether the planner's commits (Lane B Option B + Lane E analogist consult) are the right correctives or whether something more substantive is required (e.g. route pivot / strategy split).
