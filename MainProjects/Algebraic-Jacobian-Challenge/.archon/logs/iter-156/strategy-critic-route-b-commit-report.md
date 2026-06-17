# Strategy Critic Report

## Slug
route-b-commit

## Iteration
156

## Routes audited

### Route: Route A (COMMITTED, both arms) — Picard scheme / Albanese via FGA

- **Goal-alignment**: PARTIAL — for the **positive-genus object** this is the standard and essentially unavoidable construction (`J := Pic⁰_{C/k}`, dim-`g` abelian variety), and it produces a real witness as the goal demands. For the **genus-0 arm**, the route over-commits: the witness object there is trivial and does not require the FGA engine at all (see below).
- **Mathematical soundness**: PASS for the FGA construction itself; the `Pic⁰`/Albanese-UP plan is mathematically standard. The genus-0 specialization `Alb(genus-0)=0` is correct.
- **Sunk-cost reasoning detected**: no — the commitment is forward-looking ("engine mandatory anyway"), not "we already built it." But the *amortization* argument that motivates the route is flawed (see Must-fix).
- **Phantom prerequisites**: none asserted as existing — the strategy correctly classifies Hilbert/Quot representability, FGA `Pic`, `Pic⁰`, and Serre duality as **absent from Mathlib / to-build**. `Flat.epi_of_flat_of_surjective` is cited only to say it gives the *wrong* (right-cancellation) direction, which is the correct read.
- **Effort honesty**: reasonable-but-high-variance — `~5100+ · 0/it` over `~40–70` iters is honest about zero realized velocity, and the row is correctly flagged "project-fatal if it stalls." Quot/Hilbert representability is genuinely one of the largest unbuilt gaps in AG formalization; the estimate does not undersell it. The `~500–2000` genus-0 row is a 4× range, honestly wide.
- **Verdict**: CHALLENGE

### Route: Fallback (route a) — differential route via Serre duality

- **Goal-alignment**: PASS — `df=0 ⟹ constant` (chart envelope, closed) plus `df=0` (Serre duality) would close the genus-0 arm.
- **Mathematical soundness**: PASS, with the **known char-`p` defect** the strategy itself records (`df=0` does not imply constant under Frobenius). Serre duality (`h^0(Ω)=h^1(O)`) is the bridge from the protected `genus := h^1(O_C)` to `h^0(Ω)=0`.
- **Verdict**: SOUND as a kept fallback. Keeping the closed, axiom-clean chart envelope in-tree costs nothing and is correctly **not** deleted. No sunk-cost trap here: the chart work was always necessary-but-insufficient (it supplies only the converse), so route (b) is not "discarding work that would have closed the goal."

## Format compliance

- **Size**: ~125 lines / ~8.7 KB — within budget.
- **Headings**: PASS — the five canonical headings are present and in order. (`**Soundness rules (operational):**` is a bold inline label inside `## Mathlib gaps & new material`, not a top-level heading — borderline but not a heading violation.)
- **Per-iter narrative detected**: yes — "`**The route-(b) decision (iter-156).**`", "skeleton already built iter-155 (6/7 fields closed…)", and "analogist `df-zero-production-iter155`". These are exactly the iter-NNN references the skeleton forbids; per-iter narrative belongs in `iter/iter-156/plan.md`.
- **Accumulation detected**: no — the historical Route B and excised routes are not occupying space; the fallback is kept tersely.
- **Table discipline**: PASS — correct six-column table; cells short. The `? · 0` (char-`p`) and `gated` velocity entries are honest non-progress markers.
- **Format verdict**: DRIFTED — core skeleton intact, but the iter-NNN references must be stripped this iter (the prior-iter "format drifted" finding was marked addressed and has already re-drifted; harden against recurrence by phrasing the decision atemporally, e.g. "Routing genus-0 through the engine because…").

## Alternative routes (suggested)

### Alternative: Targeted char-free abelian-variety rigidity (`Mor(ℙ¹, A)` constant) for the genus-0 arm

- **What it looks like**: Prove the standalone lemma "every morphism from `ℙ¹` to an abelian variety `A` is constant" (equivalently, `A` contains no rational curves), char-free, via the **rigidity lemma / theorem of the cube** — which the project must build *anyway* for the positive-genus Albanese UP. Over `k̄`, a genus-0 curve `C_k̄ ≅ ℙ¹`, so any pointed `f : C → A` killing `P` is constant; the genus-0 witness `J = Spec k` (trivial) already exists (the skeleton has 6/7 fields closed). This closes `rigidity_over_kbar` without `Pic⁰(ℙ¹)` and without Quot/Hilbert representability.
- **Why it might be cheaper or sounder**: It **decouples the genus-0 arm from A.2 representability** — the project's single riskiest, least-Mathlib-supported, "project-fatal if it stalls" dependency — while still being char-free (unlike route (a), it needs no Serre duality and has no Frobenius gap). It reuses the rigidity lemma the positive-genus arm needs regardless, so it is itself an amortization — but onto the *lower-risk* half of Route A (abelian-variety theory) rather than the *high-risk* half (Quot/Hilbert/`Pic` representability + the `Pic(ℙ¹)=ℤ` divisor computation).
- **What the current strategy may have rejected**: unclear — the strategy lists only two genus-0 options (engine via `Alb=0`, or differential via Serre duality) and never considers a targeted abelian-variety rigidity lemma. It appears simply unconsidered, not rejected.
- **Severity of the omission**: major.

## Must-fix-this-iter

- **Route A: CHALLENGE — the genus-0 amortization argument is flawed and must be reframed.** The claim "Route A's `Pic⁰` engine is mandatory anyway, so routing genus-0 rigidity through it amortises against required work" conflates two different needs. The genus-0 **witness object** is trivial (`J = Spec k`; the skeleton already has 6/7 fields closed) and needs **no** `Pic⁰` representability. What genus-0 actually needs is a **rigidity statement** ("pointed maps `C → A` are constant"). Coupling that statement to `Alb(C_k̄)=Pic⁰(ℙ¹)=0` ties the genus-0 arm to the project's riskiest dependency (A.2 representability + the `Pic(ℙ¹)=ℤ` computation, itself flagged as an open cost) for no necessity. The planner must either (a) adopt/cost the targeted char-free `Mor(ℙ¹,A)`-constant rigidity lemma above as the genus-0 path (decoupled from representability), or (b) record an explicit rebuttal in `iter/iter-156/plan.md` explaining why genus-0 rigidity genuinely requires `Pic⁰` representability rather than just the rigidity lemma.

- **Route A: CHALLENGE — drop or justify the "descent cost is unchanged by the route choice" claim.** The strategy asserts the `Spec k̄ → Spec k` faithfully-flat descent of morphism equality is route-independent. This is suspect: a `Pic⁰`-over-`k` engine yields `Alb(C)=Pic⁰(C)=Spec k` *directly over `k`* (even for a pointless conic, where `Pic⁰` is still trivial), apparently **avoiding** the descent; whereas the targeted-`ℙ¹` route needs `C_k̄≅ℙ¹` and therefore *does* incur descent. The descent direction is itself flagged "unconfirmed." The planner should not claim route-independence; the descent obligation differs across the genus-0 options and should be costed per-option.

- **Format: DRIFTED — strip per-iter narrative.** Remove the `(iter-156)`, `iter-155`, and `df-zero-production-iter155` references from STRATEGY.md (move any needed history to `iter/iter-156/plan.md`); state the routing decision atemporally.

## Overall verdict

A fresh mathematician would accept that **for the positive-genus object the FGA `Pic⁰` engine is the right and essentially unavoidable construction**, and that abandoning the differential route's Serre-duality build for the genus-0 arm is defensible (Serre duality is `~3000–8000` LOC and carries a char-`p` gap; the chart envelope was always insufficient on its own, so route (b) discards no goal-closing work). The committing logic is **not** sunk-cost-blind in either direction. **However**, the central amortization argument is materially overstated: the genus-0 arm needs a *rigidity lemma*, not `Pic⁰` *representability*, so binding it to the project's riskiest, zero-velocity, "project-fatal" dependency is an unforced coupling. A targeted char-free "`Mor(ℙ¹,A)` is constant" lemma — reusing the rigidity machinery the positive-genus arm needs anyway, but not Quot/Hilbert representability — would close genus-0 earlier, char-freely, and independently of the highest-risk piece, and is the strongest insurance the strategy currently lacks. Resolve the two Route-A challenges and strip the iter narrative; then the strategy is sound to proceed.
