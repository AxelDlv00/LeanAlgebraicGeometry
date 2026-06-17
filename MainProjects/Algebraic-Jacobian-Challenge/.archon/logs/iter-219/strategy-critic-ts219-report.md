# Strategy Critic Report

## Slug
ts219

## Iteration
219

## Routes audited

### Route: A.1.c.SubT — ⊗-group law (and the new A.1.c.SubT.dual sheaf internal-hom block)

- **Goal-alignment**: PASS — Route A is USER-mandated (PRIMARY GOAL = `Pic_{C/k}` representability, bottom-up, RR paused). The relative Picard functor must be group-valued on *arbitrary* test schemes `T`, so a line-bundle inverse is genuinely required somewhere on this route.
- **Mathematical soundness**: PASS — the dual `L⁻¹ = ℋom(L,𝒪_X)` is the correct inverse object; the analyst's contravariance / slice-end observation is right, and I verified the absence of `SheafOfModules.internalHom`.
- **Sunk-cost reasoning detected**: no — the commitment is justified on "Route A needs this construction," not on "we already built the substrate."
- **Infrastructure-deferral detected**: no — and this is the important PASS. The dual block is a **committed** multi-iter build with (a) a concrete first sub-step (the presheaf internal-hom object via `ℋom(M,N)(U)=M|_U⟶N|_U`), (b) an iter estimate (6–12), and (c) a one-step-per-iter gradient plan. That is decomposition + a started sub-step, which is exactly what the anti-deferral rubric demands, *not* a "too hard, defer to upstream" punt.
- **Phantom prerequisites**: none — verified `SheafOfModules.internalHom` MISSING, `Scheme.Pic` MISSING, `Module.Invertible`/`CommRing.Pic` present (fixed-ring), `MonoidalClosed (ModuleCat R)` is the fixed-ring idiom only. The gap is real, not phantom.
- **Effort honesty**: reasonable — 300–500 LOC / 6–12 iters for a from-scratch sheaf internal-hom-of-modules construction is credible (it is comparable to the abandoned d.2 block, as stated). One caution below on the *comparative* "5×" claim, which is a different number.
- **Parallelism under-exploited**: no — the dual block is genuinely sequential (object → eval counit → sheaf condition → downstream reuse of the closed `tensorObj_restrict_iso`); there is no independent lane being serialized.
- **Verdict**: SOUND — within the USER-mandated Route A, *some* construction of the line-bundle inverse is unavoidable, Decision 2 (line-bundle-specific) provably collapses into Decision 1 or 3, and Decision 1 is the smaller of the two principled builds. Committing to it, gradient-style, is the correct execution. **The one item the planner must fix is the framing of the USER escalation (see Must-fix), not the build decision itself.**

### Route: A.2.c — representability + Quot fork
- **Verdict**: SOUND — held correctly behind A.1.c.SubT→A.1.c; fork is honestly stated.

### Route: Albanese UP — Route 2
- **Verdict**: SOUND — retained reversibly; the autoduality-RR-freeness risk is flagged as an open question, which is the right posture.

### Route: Route C — Riemann–Roch (PAUSED)
- **Verdict**: SOUND as a *posture* (USER owns the pause), but see the Must-fix on how its cost is represented in the escalation.

## Format compliance

- **Size**: 137 lines / ~11 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. e.g. `"Linchpin CLOSED (iter-217): the restriction-compatibility tensorObj_restrict_iso is now proved"`, `"NEW (split out iter-219)"`, `"the whiskering/stalk monoidal-localizer apparatus (vestigial, deleted iter-218)"`, plus many `iter-217/218/219` and `mathlib-analogist ts219` tags throughout the Routes section. This is exactly the iter-by-iter history the skeleton bans from STRATEGY.md.
- **Accumulation detected**: yes — long "Dead (do NOT revisit)" / "Dead-end (do NOT re-attempt)" enumerations are history-tracking that belongs in iter sidecars, not the live strategy.
- **Table discipline**: PARTIAL/FAIL — columns are correct and LOC cells carry both figures, but several `Status` cells are multi-clause paragraphs (the A.1.c.SubT and A.1.c.SubT.dual rows especially), violating "one short line per cell."
- **Format verdict**: NON-COMPLIANT — the per-iter narrative is pervasive (a listed material violation) and the table cells carry prose. Restructure in-place this iter: strip `iter-NNN`/`ts###` tags, move dead-end lists and "CLOSED at iter-X" history to `iter/iter-219/plan.md`, and compress table cells to one line each.

## Alternative routes (suggested)

### Alternative: divisor-class carrier where the inverse is `𝒪(−D)` (free)
- **What it looks like**: represent `Pic` iso-classes via Weil/Cartier divisor classes `Cl(X)=Div(X)/principal`. The group is the *free* abelian group on prime divisors modulo principal; the inverse of `[𝒪(D)]` is `[𝒪(−D)]`, built directly from `−D` via the **existing** `OcOfD`, with `𝒪(D)⊗𝒪(−D)≅𝒪_X` from additivity of `OcOfD`. No sheaf internal-hom is ever constructed. The project already has `WeilDivisor` and `OcOfD`.
- **Why it might be cheaper or sounder**: it eliminates the entire 300–500 LOC dual block — the inverse object is handed to you by negation in a free group.
- **What the current strategy may have rejected**: correctly, for the *full* relative functor. The divisor route requires the base to be integral/locally-factorial so that Weil=Cartier and every bundle is `𝒪(D)`. The relative Picard functor must be group-valued on **non-reduced** test schemes `T` (e.g. `Spec k[ε]/ε²`, essential for the tangent space / AV structure), where Weil divisors fail. So within Route A this alternative cannot replace the abstract dual. **It is a genuine alternative only as the separate Kleiman §5 / Abel–Jacobi route** (build `J` directly as an AV with a geometric group law, never forming abstract `CommGroup(Pic X)`) — which is the divisor route the planner is escalating to the USER. The planner's claim that this route would *moot* the entire substrate is therefore CORRECT, and the substrate-is-route-A-specific framing is sound.
- **Severity of the omission**: minor — the planner already escalates this route; the gap is only in *how honestly its cost is stated* (Must-fix), not in having missed it.

### Alternative: tensor-invertibility carrier (Stacks 01CS / 0B8K), inverse as data
- **What it looks like**: define `Pic X` on objects satisfying `∃N, L⊗N≅𝒪` (Stacks Def 01CS) rather than the geometric "locally-trivial" predicate; then `exists_tensorObj_inverse` is immediate because `N` is part of the carrier.
- **Why it might be cheaper**: it appears to make the inverse free.
- **What the current strategy may have rejected**: validly — this just relocates the gap. Connecting geometrically-given line bundles (locally-trivial, the objects representability actually produces) into this carrier requires proving `locally-trivial ⇒ ∃N`, which is the *same* inverse-construction/gluing problem. Not a free lunch.
- **Severity of the omission**: minor.

## Must-fix-this-iter

- **Escalation framing — CHALLENGE (the actual decision lever).** The strategy tells the USER the divisor route is "~5× lower cost." That figure compares the RR-free Quot engine (~3400–5500 LOC) against the cheap curve route (~600–1000 LOC) but **omits the cost of completing the paused Riemann–Roch chain on the divisor side** (`RRFormula`, `H1Vanishing`, `RationalCurveIso` are not done; only `WeilDivisor`/`OcOfD` exist). The "5×" is therefore *net of an unfinished, unestimated RR build*. For the USER's RR-fork decision to be honest, restate it as: "divisor route ≈ (Kleiman §5 ~600–1000 LOC) **+ completion of the paused RR chain**, vs the RR-free engine ~3400–5500 LOC; the asymmetry is large but is contingent on RR completion being cheap, which the existing `WeilDivisor`/`OcOfD` support but the missing `RRFormula`/`H1Vanishing` do not yet confirm." Without this caveat the escalation overstates the asymmetry.
- **Format — NON-COMPLIANT.** Strip pervasive `iter-NNN`/`ts###` narrative from the `## Routes` section, move the "Dead (do NOT revisit)" enumerations and "CLOSED at iter-X" history into `iter/iter-219/plan.md`, and compress the prose-heavy `Status` table cells to one line each. Restructure in-place this iter.

## Overall verdict

The committed decision is **SOUND**: under the standing USER constraints (Route A mandated, RR paused), the line-bundle inverse must be constructed somewhere on this route, the line-bundle-specific shortcut provably collapses into the same gap, and Decision 1 (presheaf internal-hom object → sheafify) is the smaller of the two principled builds — so committing to it as a decomposed, one-step-per-iter gradient build is correct, and it is **not** an infrastructure-deferral (it has a concrete first sub-step, an iter estimate, and a per-iter plan). I verified the underlying Mathlib gap is real (`SheafOfModules.internalHom` and `Scheme.Pic` both absent; only the fixed-ring `Module.Invertible`/`MonoidalClosed (ModuleCat R)` idiom exists). The planner's claim that the divisor route would *moot* the entire substrate is also correct — the divisor route is a distinct geometric construction of `J`, and the ⊗-substrate genuinely cannot be replaced by divisors *within* Route A because the relative functor needs the group on `Pic(C×T)` for non-reduced `T`. Two things must be fixed this iter, neither touching the build decision: (1) the USER escalation must stop quoting a "~5× cheaper" divisor route as if the paused-RR completion cost were zero — restate the asymmetry net of finishing the RR chain; and (2) STRATEGY.md is NON-COMPLIANT on format (pervasive per-iter narrative + prose-bloated table cells) and must be restructured in place.
