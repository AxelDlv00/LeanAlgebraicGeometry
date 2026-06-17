# Strategy Critic Report

## Slug
iter188

## Iteration
188

## Routes audited

### Route: A — Picard scheme via FGA (positive-genus arm)

- **Goal-alignment**: PARTIAL — Route A produces `Pic⁰_{C/k}` as a scheme, but the protected `Jacobian` signature demands `GrpObj`, `IsProper`, `SmoothOfRelativeDimension (genus C)`, and `GeometricallyIrreducible` as instances. The phase table covers representability (A.2.c) and identity-component carving (A.3) but never names explicit phases for (a) smoothness of relative dimension g of Pic⁰, (b) properness of Pic⁰, (c) geometric irreducibility of Pic⁰. These are non-trivial inputs (local-criterion smoothness via H¹(O_C), Pic^d-translate-of-Pic⁰ properness, geom-connectedness of Pic⁰). They are required by the goal.
- **Mathematical soundness**: PASS — Kleiman §4–5 / Nitsure §5 is the standard route; nothing in the listed sub-phases is mathematically incoherent.
- **Sunk-cost reasoning detected**: yes — A.1.a row reads "5-helper structured proof landed iter-183 … STUCK + OVER_BUDGET: 15 elapsed vs ~3-6 estimated; iter-183 added 5 helpers with net +1 sorry". The row remains active with an estimate of "~20–30 (revised)" more iters at "~0/it" realized velocity. The strategy itself states "iter-185 HARD BAR test mandatory; failure → blueprint expansion of 3-iso chain factorisation" — but the HARD BAR is referenced as a future event, not a triggered pivot, despite the row being multiple iters past it.
- **Infrastructure-deferral detected**: yes — see findings below for `GroupScheme.IdentityComponent`, Pic⁰ smoothness-and-dimension substrate, `Sym^g`/`S_g`-quotient, and the "axiomatise-then-replace" suspended decision.
- **Phantom prerequisites**: none confirmed — `Proj.fromOfGlobalSections` verified present in Mathlib; `GroupScheme.IdentityComponent` correctly flagged as new project material (only `Subgroup.connectedComponentOfOne` exists for topological groups, not for group schemes).
- **Effort honesty**: under-counted — "Total positive-genus arm (Route A, in-tree build): ~280–500 iters / ~9000–16000 LOC" is the headline, but several rows show realized velocity at `~0/it` and the row totals exclude the unowned-substrate construction effort for `GroupScheme.IdentityComponent`, `S_g`-quotient, Pic⁰ smoothness-of-relative-dim-g, and H¹ flasque vanishing. A more honest estimate including substrate-build would push past 500 iters.
- **Parallelism under-exploited**: no — A.4.a / A.4.b / A.4.d are correctly listed as parallel-startable; A.2.b sub-phases are sequenced honestly.
- **Verdict**: CHALLENGE — Route A is the right route in principle but (i) hides three goal-required Pic⁰ properties as unphased substrate, (ii) carries a stuck row past its own HARD BAR without pivot, and (iii) keeps an "axiomatise" alternative permanently parenthetical instead of committing or rejecting it.

### Route: C — Milne §I.3 rigidity (genus-0 arm)

- **Goal-alignment**: PARTIAL — `J = Spec k` is sound when `genus C = 0`. But the genus-0 ⟹ `≅ ℙ¹` bridge (RR.1–RR.4) is required to even establish that the genus-0 case reduces to `ℙ¹`, and RR.2 has its H¹ half flagged "indefinitely gated until Mathlib upstream". The very *definition* of genus is `dim_k H¹(C, O_C)`; flasque/Čech H¹ machinery is on the critical path, not off it. Marking it "off critical path" is a mislabel.
- **Mathematical soundness**: PASS — Milne §I.3 rigidity + Hartshorne IV.1.3.5 (genus-0 ⟹ ℙ¹) is a standard genus-0 argument.
- **Sunk-cost reasoning detected**: no — the III.a→III.b→III.c chart-bridge progression is described as adaptive (each path retired after measurable failure), not "we have to keep III.a because we invested in it".
- **Infrastructure-deferral detected**: yes — RR.2 H¹ flasque vanishing is named "Mathlib gap or ~150-300 LOC project formalisation off critical path; indefinitely gated until Mathlib upstream". Genus is defined via H¹; deferring H¹ defers the definition. See findings.
- **Phantom prerequisites**: none confirmed (separated-locus pieces are mostly Yoneda-style chases and the named Mathlib pieces exist at b80f227 per the strategy's own audit, which is plausible).
- **Effort honesty**: reasonable — the ~30–50 iters / ~1880–3400 LOC budget for the genus-0 arm is the right order of magnitude IF the H¹ half can be sidestepped or upstreamed.
- **Parallelism under-exploited**: yes — RR.1 (Weil divisors), RR.3 (O_C(P) sections), RR.4 (Proj.fromOfGlobalSections + degree-1 iso) have significant independent surface area but the row table sequences them as a single critical chain. RR.1 ⊳ RR.3 ⊳ RR.4 is correct as a body-dependency, but the *skeleton* and *typed-sorry* lanes of RR.3 / RR.4 can be progressed alongside RR.1 in the same iter window.
- **Verdict**: CHALLENGE — the route is sound but H¹ flasque vanishing must be either committed to as a project-side build with an iter estimate or explicitly removed from "off critical path".

## Format compliance

- **Size**: 167 lines / 14371 bytes (14.0 KB) — over budget (12 KB).
- **Headings**: PASS — the five canonical headings `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` are present in correct order.
- **Per-iter narrative detected**: yes — pervasive. Representative quotes:
  - "5-helper structured proof landed iter-183; 2 narrowly-scoped Tier-3 sorries remain — but progress-critic route185 verdict STUCK + OVER_BUDGET"
  - "iter-187 progress-critic CHURNING + OVER_BUDGET (13 elapsed vs ~8–12 est). iter-186 Hartshorne IV.1 3-piece decomposition landed (`eulerCharacteristic_iso` axiom-clean; `_shortExact_add` + `_skyscraperSheaf` typed sorries). iter-187 blueprint-writer split H⁰ half (axiom-clean closable iter-187+) from H¹ half"
  - "iter-187 progress-critic STUCK + OVER_BUDGET (5 elapsed vs ~2–4 est). (III.a) `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` route + (III.b) named-projection route both empirically blocked at Mathlib `b80f227` (iter-186 `simp made no progress`). iter-187 commits to **(III.c) separated-locus alternative**"
  - Iter references appear in roughly 12 of 24 phase-table status cells. The status column has become an iter-NNN narrative log.
- **Accumulation detected**: yes — several `Status` cells re-litigate the history of two-to-three prior iters of attempted routes (III.a/III.b/III.c chart-bridge, G1/G2 Auslander–Buchsbaum lanes, route-185 progress-critic verdicts). This is iter-sidecar content that should live in `iter/iter-NNN/plan.md`, not in STRATEGY.md.
- **Table discipline**: FAIL — multiple `Status` cells exceed one short line by 3–6x. Example: the RR.2 status cell is a 4-sentence paragraph with three iter-NNN citations.
- **Appendix sections**: `## Prior critique status` block at the end. The instructions say STRATEGY.md must follow the five-section skeleton; "Prior critique status" is appropriate for the *directive* but appears here in STRATEGY.md proper. (Minor — likely a paste error from the directive scaffolding.)
- **Format verdict**: NON-COMPLIANT — material per-iter narrative throughout the phases table, size 16% over budget, and at least one section beyond the canonical five.

## Infrastructure-deferral findings

### Deferred: `GroupScheme.IdentityComponent` (and the abelian-variety wrap on Pic⁰)

- **Required by goal**: yes — `Jacobian C` must carry `instance : GrpObj (Jacobian C)`, and Route A's witness `J := Pic⁰_{C/k}` is *defined* as the identity component of `Pic_{C/k}`. The identity-component construction for group schemes is the substrate without which the witness object cannot even be named.
- **Current plan for building it**: A.3 row claims "chapter pending; substrate unowned … (NEW PROJECT MATERIAL) … gated". No sub-phase decomposition.
- **Timeline**: vague — "~16–28 iters" estimate is unanchored to any started skeleton; the row's velocity column reads `gated`.
- **Verdict**: CHALLENGE — decompose A.3 into named sub-phases (e.g. A.3.i `IsConnectedComponent` for schemes, A.3.ii `OpenSubgroupScheme`, A.3.iii Pic⁰ ⊂ Pic identity-component instance) with concrete iter estimates per sub-phase. The current "gated" status is infrastructure-deferral by inaction.

### Deferred: Pic⁰ smoothness of relative dimension g, properness, geometric irreducibility

- **Required by goal**: yes — the protected `Jacobian` interface includes:
  - `instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom`
  - `instance : IsProper (Jacobian C).hom`
  - `instance : GeometricallyIrreducible (Jacobian C).hom`
  Without these, no `Jacobian` definition over Route A satisfies the protected signature.
- **Current plan for building it**: not present as a named phase. A.2.c claims "wires Quot + RelPic"; A.3 claims "identity + degree". Neither row mentions the deep ingredients (local-criterion smoothness via `H¹(O_C) ≅ T_0 Pic⁰`, Pic^d-translate properness, geom-connectedness of Pic⁰).
- **Timeline**: absent.
- **Verdict**: CHALLENGE — add explicit phases (e.g. A.3.iv tangent-space-of-Pic⁰, A.3.v Pic⁰ smoothness via local criterion, A.3.vi Pic⁰ properness, A.3.vii Pic⁰ geom-connected) before claiming Route A is decomposed. The current table assumes these fall out "for free" from FGA representability; they do not.

### Deferred: `Sym^g C` as a scheme (S_g-quotient)

- **Required by goal**: partially — Sym^g is used in A.4.d.i for the Albanese UP wiring (Milne's symmetric-power construction). The strategy explicitly states the witness object J is `Pic⁰`, NOT `Sym^g/Θ`, so Sym^g is required only for the UP wiring, not the witness. Removing Sym^g would require an alternative UP route (e.g. via the divisor map and Theta from RR substrate directly).
- **Current plan for building it**: A.4.d.i row claims "chapter landed; substrate unowned … `S_g`-quotient UNOWNED". No project-side construction plan.
- **Timeline**: vague — "~10–18 iters" but `gated`.
- **Verdict**: CHALLENGE — either commit a sub-decomposition of A.4.d.i (group-scheme action on schemes; geometric quotient; existence of finite-group quotients via affine charts; smoothness of the quotient) or pivot the Albanese UP wiring to a Sym^g-free route. The "Albanese UP via divisor map directly" path (Milne III §6 has multiple constructions; the one in Prop 6.4 uses the universal divisor, not symmetric powers) might cost less.

### Deferred: H¹ flasque vanishing / sheaf cohomology engine for RR.2

- **Required by goal**: yes — `genus C := dim_k H¹(C, O_C)` is the *definition* of genus, and the genus-0 arm requires showing `genus C = 0 ⟹ C ≅ ℙ¹` (Hartshorne IV.1.3.5) via Riemann–Roch. The RR formula needs `H¹` either as an explicit functor or via Euler-characteristic surrogates that themselves need `H¹` to be computed.
- **Current plan for building it**: RR.2 row reads "Mathlib gap or ~150-300 LOC project formalisation off critical path; H¹ half indefinitely gated until Mathlib upstream".
- **Timeline**: absent — "indefinitely gated".
- **Verdict**: CHALLENGE — "off critical path" is a mislabel. Either (a) prove the genus-0 arm's RR-needs can be discharged by Euler-characteristic black-box (avoiding direct H¹) with a concrete construction, or (b) commit project-side to the H¹ flasque vanishing build with a 3–5 iter estimate.

### Deferred: "Axiomatise-then-replace" path (Route A)

- **Required by goal**: not required, but the strategy admits this would collapse the critical path from ~280–500 iters to ~25–35 iters. Keeping it permanently parenthetical without committing or rejecting amounts to strategic stasis.
- **Current plan**: "TRACKED, NOT COMMITTED. Trigger: Route A velocity stays ~0/it on file-skeleton lanes for two consec iters." This trigger is silently satisfied by the current A.1.a row (15 elapsed iters at ~0/it; multiple "~0/it" rows elsewhere) but the route has not been activated.
- **Timeline**: undefined — the trigger condition is self-arming but no activation has occurred.
- **Verdict**: CHALLENGE — either (a) commit to the axiomatise route now, accepting that the end-state is "kernel-clean modulo a documented set of project-introduced axioms naming exact Mathlib gaps", or (b) remove the option from STRATEGY.md entirely and own the 280–500 iter horizon. The current Schrödinger-state is not a strategy.

## Alternative routes (suggested)

### Alternative: Black-box `Pic⁰` as an axiom-laundered substrate, prove only the universal property

- **What it looks like**: introduce one or two named project axioms (e.g. `axiom Pic0_isAbelianVariety : ...`, `axiom Pic0_universalProperty : ...`) replacing the entire A.2 + A.3 substrate; build the rest of Route A on top (A.4.a–d). End-state advertises "kernel-clean modulo `Pic0_isAbelianVariety` (Stacks 0BAY)". Project finishes in ~25–35 iters per the strategy's own estimate.
- **Why it might be cheaper or sounder**: the strategy already names this option as a 10× speedup. The contract "kernel-only axioms" is intrinsically unsatisfiable on a 280–500 iter horizon with current Archon throughput; relaxing the contract to "kernel-only + a small list of named upstream-Mathlib stand-ins" produces a finished artifact that closes the original challenge in a tractable horizon. The upstream-Mathlib team can then retire each axiom independently.
- **What the current strategy may have rejected**: the strategy lists the contract as "zero inline `sorry`, kernel-only axioms" non-negotiably. The rejection seems to be ideological rather than mathematical — the rejected version still produces a Lean-checked proof that `Pic⁰_{C/k}` has the universal property, conditioned on widely-believed substrate.
- **Severity of the omission**: critical — the strategy itself admits 10× cost differential and yet does not commit.

### Alternative: Replace A.4.d.i (Sym^g symmetric-power Albanese UP) with the divisor-map UP route

- **What it looks like**: instead of constructing Sym^g C as a scheme (requiring an unowned S_g-quotient), prove the Albanese UP directly via the universal effective divisor → Pic^d morphism, then translate by a fixed degree-g line bundle. Milne III §6 has multiple variants; the divisor-map one avoids symmetric powers.
- **Why it might be cheaper or sounder**: removes the S_g-quotient gap (an unowned, hard piece of substrate). The universal divisor over Pic is already in the Quot-scheme chain Route A is committed to building.
- **What the current strategy may have rejected**: unclear — A.4.d.i is named but not justified against alternatives.
- **Severity of the omission**: major — saves the S_g-quotient gap.

### Alternative: Build Pic⁰ smoothness/properness sub-phases inside A.3 (not an alternative route, a missing decomposition)

- **What it looks like**: split A.3 into A.3.i `IdentityComponent`, A.3.ii `tangent-space-iso-H¹`, A.3.iii `Pic⁰ smooth via local-criterion`, A.3.iv `Pic⁰ proper via Pic^d-translate`, A.3.v `Pic⁰ geom-connected`, A.3.vi `degree map`. Each with an iter estimate.
- **Why it might be cheaper or sounder**: forces honest accounting of the substrate that the protected `Jacobian` signature actually demands.
- **What the current strategy may have rejected**: nothing — it just hasn't been done.
- **Severity of the omission**: critical — without this, Route A is not actually decomposed into goal-sufficient phases.

## Sunk-cost flags

- `5-helper structured proof landed iter-183; 2 narrowly-scoped Tier-3 sorries remain — but progress-critic route185 verdict STUCK + OVER_BUDGET: 15 elapsed vs ~3-6 estimated; iter-183 added 5 helpers with net +1 sorry` — Why this is sunk-cost: the row is being kept active with a revised estimate of "~20–30 (revised)" further iters at "~0/it" realized velocity, despite the explicitly-documented HARD BAR trigger that was meant to retire it. Recommendation: trigger the documented blueprint expansion this iter; do not allow the row to drift further.

- `iter-185 dispatched mathlib-analogist ocofp-carrierset-submodule-api (verdict gates Lane A iter-186+ re-fire)` — Why this is sunk-cost: the RR.3 row's pending state depends on an analogist verdict that's been waiting "iter-186+" — the row is gated on a query that is itself ungated. Recommendation: either close the analogist query or strip the dependency and pick a concrete sub-decomposition this iter.

- `Total positive-genus arm (Route A, in-tree build): ~280–500 iters` paired with `Total positive-genus arm (axiomatise-staging path): ~25–35 iters` — Why this is sunk-cost: presenting both estimates next to each other but committing to neither is the textbook unwillingness to accept that the in-tree estimate is implicitly the project's terminal status. Recommendation: explicitly choose and document the rationale.

## Prerequisite verification

- `AlgebraicGeometry.Proj.fromOfGlobalSections`: VERIFIED (Mathlib `AlgebraicGeometry.ProjectiveSpectrum.Basic`).
- `GroupScheme.IdentityComponent`: MISSING (no Mathlib hit; only `Subgroup.connectedComponentOfOne` for topological groups exists). Strategy correctly flags as new project material.
- `S_g`-quotient of schemes (for Sym^g): MISSING — strategy correctly flags as unowned.
- H¹ flasque vanishing for sheaf cohomology of curves: MISSING — strategy correctly flags as Mathlib gap.

## Must-fix-this-iter

- **Format: NON-COMPLIANT** — strip iter-NNN narrative from all `Status` cells. Move per-iter detail to `iter/iter-NNN/plan.md`. Trim file to ≤12 KB. Remove the `## Prior critique status` block (it belongs in the strategy-critic directive, not in STRATEGY.md). Restructure status cells to one short line each (e.g. "skeleton landed; body gated on A.2.a.i" — not 4-sentence narratives).
- **Route A: CHALLENGE** — add explicit sub-phases for Pic⁰ smoothness-of-relative-dim-g, properness, geometric irreducibility. The current A.2.c + A.3 do not cover the protected `Jacobian` instances.
- **Infrastructure-deferral CHALLENGE: `GroupScheme.IdentityComponent`** — decompose A.3 into named sub-phases with concrete iter estimates, or commit to axiomatise the identity-component construction.
- **Infrastructure-deferral CHALLENGE: Pic⁰ smoothness/properness/dim=g substrate** — add named phases or commit to axiomatising the abelian-variety wrap on Pic⁰.
- **Infrastructure-deferral CHALLENGE: `Sym^g`/`S_g`-quotient** — either decompose A.4.d.i with concrete iter estimates, or pivot to the divisor-map Albanese UP route.
- **Infrastructure-deferral CHALLENGE: H¹ flasque vanishing** — "off critical path" is wrong; genus is defined via H¹. Commit to project-side build or document a black-box Euler-characteristic detour with a concrete construction.
- **Infrastructure-deferral CHALLENGE: axiomatise-then-replace path** — the trigger (~0/it for two consec iters on file-skeleton lanes) is already met; either activate or remove. Permanent parenthetical is not a plan.
- **Alternative omission: black-box Pic⁰ via project-introduced axioms** — strategy admits 10× speedup but has not committed; choose explicitly.
- **Alternative omission: Sym^g-free Albanese UP route** — major; removes one of the two unowned substrate pieces.
- **Sunk-cost: A.1.a HARD BAR not triggered despite condition met** — execute the documented blueprint expansion this iter rather than allowing further drift.

## Overall verdict

The strategy is structurally sound at the top level — Route A (Picard via FGA) + Route C (Milne §I.3 rigidity) is the right decomposition, and the math is correct. But the document materially defers four goal-required constructions (`GroupScheme.IdentityComponent`; Pic⁰ smoothness/properness/dim-g substrate; `S_g`-quotient for Sym^g; H¹ flasque vanishing for RR.2) without concrete project-side build plans. The strategy defers `GroupScheme.IdentityComponent`, which is required for the stated goal. The strategy defers Pic⁰ smoothness/properness/geometric-irreducibility substrate, which is required for the stated goal. The strategy defers H¹ flasque vanishing, which is required for the stated goal. And the strategy holds an "axiomatise-then-replace" alternative in permanent suspended-decision state despite its own activation trigger having been satisfied. Compounding this, STRATEGY.md is materially out of canonical format — pervasive per-iter narrative inside `Status` cells, ~14 KB over the 12 KB budget, and table discipline failures throughout. Per-route: Route A — CHALLENGE; Route C — CHALLENGE; Format — NON-COMPLIANT. Overall: **CHALLENGE**. The planner must either decompose the four deferred constructions into named sub-phases with concrete iter estimates *this iter*, or commit to the axiomatise-staging path and rewrite the end-state contract accordingly. Strategy in its current shape will not reach the protected `Jacobian` signature.
