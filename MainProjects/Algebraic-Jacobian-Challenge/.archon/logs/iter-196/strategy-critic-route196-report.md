# Strategy Critic Report

## Slug
route196

## Iteration
196

## Routes audited

### Route: A — Picard scheme via FGA

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` produces an Albanese/Jacobian for the positive-genus arm of the protected statement.
- **Mathematical soundness**: PARTIAL — the FGA construction is standard, but the strategy quietly assumes the identity-component / connected-component formalism (A.3.i) is available even though Stacks 04KU/04KV is acknowledged as a *Mathlib upstream PR* with no project-side fallback plan. That is the same hard prerequisite that has blocked the lane for ≥1 iter; the strategy renames the deferral as "USER escalation" without resolving the math.
- **Sunk-cost reasoning detected**: no — the strategy explicitly side-steps A.2.b via the Cartier route, which is the correct anti-sunk-cost move.
- **Infrastructure-deferral detected**: yes — see "Infrastructure-deferral findings" below for A.3.i (Stacks 04KU/04KV), Lane M↓ (Stacks 00TT), A.2.a (Stacks 052H), and A.2.b (Quot/Plücker).
- **Phantom prerequisites**: none — `Functor.IsRepresentable` and `Functor.reprX` are verified in `Mathlib.CategoryTheory.Yoneda`; the analogist's Option A is on solid Mathlib footing.
- **Effort honesty**: under-counted — multiple rows list multi-iter budgets against `~0/it (recent)` or `~0/it (regressive)` velocity (A.2.a `~60–110 iters · ~0/it`, A.2.b `~75–150 iters · ~0/it`, A.3.i `~20–28 iters · ~0/it (regressive 5→9)`, Lane M↓ `~6–12 iters · ~0/it`). A row reading "0/it for 4+ iters" with a positive iter-left projection is implicitly forecasting that work will resume — that is not a velocity estimate, that is an aspiration.
- **Parallelism under-exploited**: no — the "Bottom-up execution priority" lists 5+ active lanes in parallel and the dependency graph permits it.
- **Verdict**: CHALLENGE

### Route: C — genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k` with Milne §I.3 rigidity covers the genus-0 arm of the protected statement.
- **Mathematical soundness**: PASS — the path genus 0 ⟹ ℙ¹ over k̄ ⟹ rigidity-via-𝔾_m-scaling is standard.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: partial — RR.4 row carries "OVER_BUDGET (16 elapsed); Pin 3 carving" and "USER escalation candidate iter-196" while still listing `~20–26 iters` ahead. If RR.4 is genuinely an over-budget escalation candidate, the in-loop iter count is dishonest; if the in-loop count is real, the "USER escalation" label is. Pick one.
- **Phantom prerequisites**: `Hartshorne I.6.12 Hom.ofFunctionFieldEmbedding` — referenced as a "Mathlib gap"; the strategy commits the body project-side without an iter budget, just `~150–300 LOC`. Not phantom, but unmeasured.
- **Effort honesty**: under-counted on RR.4 (see above) and RR.2.H¹ (Lane H "CHURNING; one more PARTIAL = STUCK" — three signals that the lane is at the edge but the row still lists `~6–10 iters`).
- **Parallelism under-exploited**: no — RR.1–RR.4, chart-bridge, BareScheme, Lane I are correctly fanned out.
- **Verdict**: SOUND (with the RR.4 escalation framing flagged for cleanup)

## Format compliance

- **Size**: ≈218 lines / ≈10 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Counted in the table alone: `iter-194 closed` (A.4.b), `iter-194 instance #1 closed` (RR.1), `iter-195 NEEDS_MATHLIB_GAP_FILL; PARKED body close` (A.3.i), `iter-195 ANALOGUE_FOUND (...); ANALOGUE-DRIVEN iter-195 dispatch` (chart-bridge), `iter-195 mathlib-analogist verdict ALIGN_WITH_MATHLIB on Option A` (carrier-soundness), `pulled forward from iter-200`, `STUCK (flat 4 iters); iter-200 sweep candidate` (Lane M↓), `iter-196+ candidate USER escalation`, `OVER_BUDGET (16 elapsed)` (RR.4), `~30-50/it (post-pivot)`. The "Open strategic questions" and "Mathlib gaps" sections repeat the iter-NNN refs. Per the canonical skeleton, iter-NNN never appears in STRATEGY.md; this is the most material drift.
- **Accumulation detected**: minor — A.2.a / A.2.b are kept as stalled rows with 0/it velocity for an indeterminate number of iters; the strategy text notes "Genus-0 + Route-A-via-Cartier avoid blocking on these" but the rows are still consuming table space. If A.2.b is bypassed by the Cartier route, why is it still a Route A phase with a 75–150 iter budget? Either it is on the critical path (Cartier route is contingent, not committed) or it is not (rows should compress to a single "deferred via Cartier" note).
- **Table discipline**: PASS — Markdown table with the canonical columns; cells are short. Minor exception: the carrier-soundness row's `~600–950 · iter-196 dispatch` substitutes a planning note for the realized/it figure, which is a per-iter contamination of the velocity slot.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: A.3.i — Pic⁰ IdentityComponent via Stacks 04KU/04KV

- **Required by goal**: yes — Pic⁰ as the identity component of Pic is the construction the strategy commits to in `## Routes`. Without 04KU/04KV (or an equivalent Pic⁰ characterization) the route does not close.
- **Current plan for building it**: "iter-196+ candidate: Mathlib upstream PR (Route B per analogist, ~350 LOC) OR USER escalation." Both options are non-project-side: Mathlib PRs take months to land, and "USER escalation" is not a plan.
- **Timeline**: vague — the row carries `Iters left: ~20–28 (gap-fill)` with `~0/it (regressive 5→9)` velocity. A regressive sorry count and a 0/it velocity inside a 20–28 iter budget is an unresolved gap, not a plan.
- **Verdict**: CHALLENGE — also see the alternative below (define Pic⁰ as `ker(deg : Pic → ℤ)` to bypass 04KU/04KV entirely).

### Deferred: A.2.a — Flattening (Stacks 052H, ~2000–3500 LOC)

- **Required by goal**: yes — A.2.c (FGA Pic_{C/k}) wires A.2.b + A.1.c, and A.2.b chains into A.2.a. Even under the Cartier route, A.2.c (and thus A.2.a) is the substrate of the *unconditional* Pic^d component when no Mathlib path exists. The strategy needs to argue that the Cartier route bypasses A.2.a *and* A.2.b together; today it only argues bypass for A.2.b.
- **Current plan for building it**: "stalled, unowned" — no project-side plan.
- **Timeline**: absent (`~0/it` velocity, 60–110 iter budget).
- **Verdict**: CHALLENGE — needs an explicit "A.2.a is NOT required if Cartier route + degree-map Pic⁰ are adopted" disclaimer, or a project-side commitment.

### Deferred: A.2.b — Quot + Grassmannian (Nitsure §5, ~2600–5000 LOC)

- **Required by goal**: partially — the strategy explicitly proposes the Cartier route to avoid A.2.b. If the bypass is committed, A.2.b should be excised, not kept as a 75–150 iter "stalled" row.
- **Current plan for building it**: none — flagged "absent; A.4.d.0 may avoid".
- **Timeline**: absent.
- **Verdict**: CHALLENGE — `A.4.d.0 may avoid` is a hedge. If iter-196+ commits to the Cartier route, drop the row; if not, name the criterion that forces a return to A.2.b.

### Deferred: Lane M↓ — `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT)

- **Required by goal**: unclear — STRATEGY does not name a consumer. "smooth ⟹ regular at stalks" is foundational, but the protected signatures take `[Field k]` and the genus-0 arm uses ℙ¹ directly; Route A's smoothness use cases live behind several other lanes. If no current lane depends on it, the row is dead weight.
- **Current plan for building it**: "iter-200 sweep candidate" — a wait-state, not a plan.
- **Timeline**: vague (`~6–12 iters · ~0/it (recent)`, STUCK 4 iters).
- **Verdict**: CHALLENGE — either name the consumer of `isRegularLocalRing_stalk_of_smooth` (which protected decl or named lemma forces it on the critical path) or excise the row until a consumer materializes.

## Alternative routes (suggested)

### Alternative: Define Pic⁰ as `ker(deg : Pic_{C/k} → ℤ_{C/k})` instead of "identity component"

- **What it looks like**: For a smooth proper geometrically irreducible curve, `Pic⁰_{C/k}` agrees with the kernel of the degree map (degree is constant on connected components and zero on the identity component). The strategy already plans A.3.vii (degree map, `~2–4 iters / ~80–200 LOC`). If Pic⁰ is *defined* as the kernel of A.3.vii, then A.3.i's dependence on Stacks 04KU/04KV (connected-component / identity-component formalism) disappears.
- **Why it might be cheaper or sounder**: bypasses the unowned Mathlib gap that has stalled A.3.i for ≥1 iter at 0/it velocity. Equivalence "identity component = ker(deg)" can be proved later (when 04KU/04KV land) without blocking the rest of Route A. This is the same anti-deferral move the strategy already uses for A.2.b via the Cartier route.
- **What the current strategy may have rejected**: unclear — the strategy text never evaluates this alternative. The mathlib-analogist consult was scoped to "how do we build the identity-component formalism", not "is the identity-component formalism the only way to define Pic⁰".
- **Severity of the omission**: critical — A.3.i is on the Route A critical path, currently parked, and the strategy's only escape is "USER escalation OR Mathlib upstream PR (~350 LOC)". A definition-level pivot would unblock the lane without external dependencies.

### Alternative: Tight abort criterion on the carrier-soundness refactor

- **What it looks like**: Commit to the FGAPicRepresentability slice as a 2–3 iter probe. If `lean_verify` shows the slice converging (zero sorryAx propagation through the touched protected decls) at iter-198, continue the cross-file blast. If it is not converging (silent-sorryAx still present, or new soundness issues uncovered), revert the slice and re-evaluate.
- **Why it might be cheaper or sounder**: the current "6–10 iter / ~600–950 LOC across 5+ files" pin is open-ended; cross-file refactors of `:= sorry` carriers under representability re-encoding typically blast wider than projected once consumer signatures shift. Without an abort criterion, the pin can eat the genus-0 budget. A 2–3 iter probe gives the planner a checkpoint *before* the full blast.
- **What the current strategy may have rejected**: unclear — the strategy commits to "FGAPicRepresentability slice first" but does not name a checkpoint or revert condition.
- **Severity of the omission**: major — genus-0 is the only complete-able milestone in 1–2 months per STRATEGY's own claim; an uncapped carrier refactor risk-shifts that milestone.

## Sunk-cost flags

(none material)

## Prerequisite verification

- `CategoryTheory.Functor.IsRepresentable`: VERIFIED (`Mathlib.CategoryTheory.Yoneda`)
- `CategoryTheory.Functor.reprX`: VERIFIED (`Mathlib.CategoryTheory.Yoneda`)
- `IsAffineOpen.fromSpec_app_self`: assumed verified (analogist consult already named it as confirmed)
- `Stacks 04KU` / `Stacks 04KV` (identity-component formalism): MISSING in Mathlib (per A.3.i status)
- `Stacks 00TT` (smooth ⟹ regular at stalk): MISSING in Mathlib (per Lane M↓ status)
- `Stacks 052H` (flattening stratification): MISSING in Mathlib (per A.2.a status)
- `Stacks 00NQ` (`isDomain_of_regularLocal`): MISSING in Mathlib (per A.4.b status)
- `Hartshorne I.6.12 Hom.ofFunctionFieldEmbedding`: MISSING in Mathlib (per RR.1 status)

The Mathlib-side phantom prerequisite list is empty; the *unbuilt* prerequisite list is large and several of those items have no project-side plan.

## Must-fix-this-iter

- Route A: CHALLENGE — A.3.i deferral. Either (a) commit a project-side plan with a concrete iter budget for Stacks 04KU/04KV (replacing "USER escalation OR Mathlib PR"), OR (b) pivot the Pic⁰ definition to `ker(deg)` and re-write A.3.i / A.3.ii dependencies accordingly. Without (a) or (b), Route A's stated end-state is unreachable in-loop.
- Route A: infrastructure-deferral CHALLENGE — A.2.a (Stacks 052H, 2000–3500 LOC, ~0/it for ≥4 iters): name the bypass criterion (Cartier route + degree-map Pic⁰ together avoid A.2.a) or commit a project-side plan.
- Route A: infrastructure-deferral CHALLENGE — A.2.b (Quot/Plücker, 2600–5000 LOC, ~0/it): if Cartier is committed, excise the row; if not, name the trigger that forces a return.
- Route A: infrastructure-deferral CHALLENGE — Lane M↓ (Stacks 00TT): name the on-critical-path consumer of `isRegularLocalRing_stalk_of_smooth` or excise the row.
- Iter-196 dispatch CHALLENGE — the strategy text says "Priority: close genus-0 arm" while also pinning a 6–10 iter Route-A carrier refactor at *iter-196*. Either (a) re-state the priority as "soundness > genus-0 — accept ~6–10 iter genus-0 slippage", OR (b) add a tight abort criterion (2–3 iter FGAPicRepresentability probe; revert if not converging) so the priority is preserved on the downside.
- Route C: CHALLENGE — RR.4 row carries both `Iters left: ~20–26` and "USER escalation candidate iter-196". Resolve the contradiction (escalation OR in-loop budget — not both).
- Format: NON-COMPLIANT-ish (DRIFTED) — pervasive iter-NNN narrative in `## Phases & estimations`, `## Open strategic questions`, and `## Mathlib gaps` sections. Per the canonical skeleton, STRATEGY.md must not name iterations; that history belongs in iter sidecars. The single biggest cleanup is converting all "iter-194 / iter-195 / iter-196+ / iter-200" tags in the Status column to status verbs ("converging", "parked pending mathlib gap", "stuck", "analogue-driven") and moving the iter-NNN provenance to the corresponding iter sidecar.

## Overall verdict

The strategy is structurally sound on the math — Routes A and C are both plausible paths to the protected statement, and the Cartier-route side-step is a good anti-sunk-cost move. But the strategy defers A.3.i (Pic⁰ IdentityComponent via Stacks 04KU/04KV), which is required for the stated goal under the current Pic⁰ definition, to "USER escalation OR Mathlib upstream PR" with no project-side plan and no iter timeline. The strategy also defers A.2.a (Stacks 052H, ~2000–3500 LOC) without explicitly committing the Cartier-route bypass for it; A.2.a sits as a 60–110 iter "stalled" row with 0/it velocity and no plan. Lane M↓ (Stacks 00TT) has been STUCK at 0/it for 4 iters with no named consumer — that is an infrastructure-deferral by inaction. The carrier-soundness pin at iter-196 is a defensible reaction to the lean-auditor's silent-sorryAx finding, but it contradicts the strategy's stated "close genus-0 first" priority and lacks an abort criterion; the planner should either rewrite the priority statement or add a 2–3 iter probe checkpoint. Format compliance has drifted: iter-NNN references contaminate the table's Status column, the Open-strategic-questions section, and the Mathlib-gaps section — that history belongs in iter sidecars, not in STRATEGY.md.
