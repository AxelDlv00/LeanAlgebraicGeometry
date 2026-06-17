# Strategy Critic Report

## Slug

iter136

## Iteration

136

## Routes audited

### Route: M1 — presheaf-bridge

- **Goal-alignment**: PASS — excised iter-126; M1 is no longer load-bearing for any protected declaration. The M1.d Mathlib-PR candidate (`kaehler_quotient_localization_iso`) remains in-tree as a standalone utility but is off the critical path.
- **Mathematical soundness**: n/a — route is excised.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: n/a (route closed).
- **Verdict**: SOUND.

### Route: M2.a — rigidity over `k` (`rigidity_over_kbar` → `rigidity_over_k`)

- **Goal-alignment**: PASS — the genus-0 universal property follows from rigidity + vacuity (on `C(k) = ∅`). The strategy correctly anchors `IsAlbanese C P J` as vacuously true when the type `𝟙_ _ ⟶ C` is empty in `Over (Spec k)`, which is the Lean encoding of `C(k) = ∅`.
- **Mathematical soundness**: PASS — the cotangent-vanishing rigidity argument (df = 0 ⇒ factors through `Spec k`, with absolute Frobenius iteration on the char-`p` branch) is the standard route. Mumford § 4's classical form is recovered by the difference-morphism reduction baked into Rigidity.tex.
- **Sunk-cost reasoning detected**: PARTIAL — see "Over-k re-defense" challenge below.
- **Phantom prerequisites**: scheme-level absolute Frobenius is genuinely absent from Mathlib `b80f227` (verified via `lean_leansearch "absolute Frobenius scheme"` — no hits beyond unrelated `FrobeniusNumber`). Strategy acknowledges this as part of piece (iii).
- **Effort honesty**: reasonable — the iter-128 honest-LOC revision (300–600 → 800–1500 for piece (iii)) is a corrective from optimism. Final 1850–3600 LOC / 9–20 iter pile cost is in the right order of magnitude for the work named.
- **Verdict**: SOUND, with CHALLENGE on over-k defense framing (see "Direct over-k rigidity" route below).

### Route: M2.b — `genusZeroWitness`

- **Goal-alignment**: PASS — the scaffold has landed (`Jacobian.lean:174–178`), the body's substantive content is `rigidity_over_k` on the `C(k) ≠ ∅` branch + vacuity on `C(k) = ∅`. The four-instance cluster on `Spec k` (`GrpObj`, `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible`) is named in the iter-153 row with the honest 200–500 LOC / 2–3 iter sub-cost.
- **Mathematical soundness**: PASS — vacuity branch is correct at the type level. The `Classical.byCases` + `IsEmpty.elim` encoding of the empty case is standard.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: terminal-object instance cluster on `Spec k` for the four typeclasses. The `IsProper` instance on the structure morphism `Spec k → Spec k` is the identity, but the `GeometricallyIrreducible` and `SmoothOfRelativeDimension 0` instances need explicit construction; the strategy budgets this honestly.
- **Effort honesty**: revised from "1 iter / 100–200 LOC" to "2–4 iter / 320–750 LOC" iter-130. Reasonable.
- **Verdict**: SOUND.

### Route: M2.body-pile decomposition — (i.a) + (i.b) + (i.c) + (ii) + (iii)

- **Goal-alignment**: PASS — the chain is exactly the standard cotangent-vanishing rigidity argument: trivialise the cotangent sheaf of the group scheme `A` via shear-iso (i.a/b/c); deduce `f : C → A` has `df = 0` because `Ω_{C/k}` has degree `-2` and `Ω_{A/k}` is trivial of finite rank, so any sheaf map between them is forced into trivial sections; then `df = 0 ⇒ f` factors through `Spec k` via (ii) [+ (iii) in char-`p`].
- **Mathematical soundness**: PASS overall.
- **Sunk-cost reasoning detected**: no — the iter-130 strike on iter-128 evidence + iter-132 strike on iter-131 evidence (only content-bearing closures count) is anti-sunk-cost discipline, applied correctly.
- **Phantom prerequisites**:
  - **`Differential.ContainConstants` alignment claim** — verified the typeclass exists in `Mathlib.RingTheory.Derivation.DifferentialRing`. **CHALLENGE**: Mathlib's `Differential.ContainConstants A B` is keyed on `Differential B`, i.e., a derivation `B → B` (valued *in* `B`), with `mem_range_of_deriv_eq_zero` consuming `x′ = 0`. The strategy's piece-(ii) framing wants `df = 0` where `d : Γ(C, V) → Ω_{Γ(C, V) / Γ(Spec k, U)}` (Kähler form, *not* an abstract `Differential` instance). To use `mem_range_of_deriv_eq_zero` directly, the project would need to either install a `Differential` typeclass instance on the chart algebra (selecting a derivation `B → B` from the universal one `B → Ω_{B/A}`, which requires a splitting) or route through `KaehlerDifferential.range`-style lemmas. The "ring-level half aligns" framing is loose; the planner should pin down the alignment before scaffolding piece (ii) at iter-141+, or be explicit that the alignment is morally not literally lemma-for-lemma.
  - **`AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim`** PHANTOM is correctly flagged.
  - **Scheme-level absolute Frobenius** PHANTOM is correctly flagged.
  - **Scheme-level relative cotangent sheaf base change** PHANTOM (`Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}`) is correctly flagged.
- **Effort honesty**: 1850–3600 LOC over 9–20 iter is honest given the absent Mathlib infrastructure (verified: no `Scheme.frobenius`, no `Scheme.absoluteFrobenius`, no scheme-level relative cotangent sheaf). The iter-134 LOC-arm watchpoint on (i.b) (`> 600 LOC` triggers (a')) and the iter-143+ `> 1200 LOC` trigger on piece (iii) are well-shaped guardrails against silent absorption.
- **Verdict**: SOUND, with CHALLENGE on the piece-(ii) `Differential.ContainConstants` alignment (above).

### Route: Direct over-k rigidity (the commitment itself)

- **Goal-alignment**: PASS — over-k rigidity directly produces the universal-property factorisation on the `C(k) ≠ ∅` branch of `genusZeroWitness` (with vacuity covering `C(k) = ∅`), matching the protected signature.
- **Mathematical soundness**: PASS — pieces (i)+(ii)+(iii) build over an arbitrary base field per the iter-127 over-k analogist; absolute Frobenius is intrinsic to `X`, no perfectness needed.
- **Sunk-cost reasoning detected**: **PARTIAL** — see CHALLENGE below.
- **Phantom prerequisites**: none beyond those flagged under M2.body-pile.
- **Effort honesty**: under-counted in spirit. The iter-128 honest revision moved the net savings from "7–13 iter / 500–900 LOC" to "2–6 iter / 0–500 LOC" with lower bound zero. The strategy is upfront about this.
- **Verdict**: CHALLENGE.

**Challenge detail.** With the quantitative case marginal (lower-bound-zero savings), the over-k commit is now carried by three qualitative grounds:

- (ii) cleaner single-chapter blueprint — strategy self-flags this as partially switching-cost.
- (iii) revert-trigger wiring exists — this is a *risk mitigation*, not a *positive defense*. "We have an escape hatch" does not argue that the route is the right one; it argues only that the cost of being wrong is bounded.
- (iv) piece (i.a) close is content-bearing — scope-narrow per iter-133 discipline; only tells us (i.a) is tractable, not that the route is over-`k̄`-superior.

The substantive ground reduces to (iv) alone — and (iv) does not differentiate over-k from over-`k̄`, because the same `cotangentSpaceAtIdentity_finrank_eq` proof would have worked over `k̄`. The planner should:

1. Re-state the over-k commit's defense without listing (iii) as positive evidence (it is mitigation, not justification).
2. Acknowledge that (iv) is route-validation evidence (the route works) but not route-*comparison* evidence (over-k vs over-`k̄`).
3. Either accept that the over-k commit is now defended primarily by (ii) blueprint cleanliness + the practical observation that the iter-128 → iter-132 work already lives over `[Field k]` (which IS a switching-cost ground, named honestly), or revisit at the next route-pivot trigger.

This is a framing tightening, not a route rejection. The over-k commitment remains operationally correct.

### Route: M3 — `positiveGenusWitness`

- **Goal-alignment**: PASS — scaffold landed iter-134; body is multi-year.
- **Mathematical soundness**: PASS for the two route candidates (Picard via FGA / Symmetric powers + Stein); both produce the genus-`g` Albanese variety. Per the iter-123 route-audit: Route A ~6500 LOC, Route B ~9000 LOC, both exceed the 5000-LOC hard-fallback threshold.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: vast Mathlib gaps named honestly (Hilbert/Quot representability, symmetric powers of schemes, Stein factorisation, Brill–Noether–RR).
- **Effort honesty**: 100+ iter / 10000+ LOC for the full route. Honest.
- **Verdict**: SOUND with feasibility flag (below).

**Feasibility flag (not strategy-blocking, not CHALLENGE-level)**. The full M3 arc is a multi-year endeavour for autonomous-loop dispatch. The iter-126 user hint resolved the named-axiom alternative in favor of "do the work" within the specific M3 user-escalation context. A fresh mathematician would still ask whether autonomous-loop tooling is the right scope for an arc of 10000+ LOC across both Route A and Route B's top-3 gating Mathlib pieces — but the strategy has already escalated this to the user and the user has decided. Flagging only to ensure the planner is aware that the route's feasibility commitment is user-driven, not strategy-driven; if the loop produces zero net `\leanok` progress on M3 for many iter, the route-pivot question may return.

### Route: Genus-stratified body of `nonempty_jacobianWitness`

- **Goal-alignment**: PASS — the `by_cases h : genus C = 0` decomposition is well-formed (`genus C : ℕ` is decidable-equality), produces a `JacobianWitness C` from either arm, and the protected signature is preserved.
- **Mathematical soundness**: PASS — genus 0 ⊔ positive genus is exhaustive on `ℕ`.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: depends on `genusZeroWitness` (M2 output) and `positiveGenusWitness` (M3 output) being scaffolded; both have landed.
- **Effort honesty**: 2–4 iter for the restructure itself, gated on M2.b body close + M3 scaffold. Reasonable.
- **Verdict**: SOUND.

## Alternative routes (suggested)

### Alternative: piece-(ii) via `KaehlerDifferential` exactness instead of `Differential.ContainConstants`

- **What it looks like**: Instead of routing piece (ii) through Mathlib's abstract `Differential.ContainConstants` typeclass, route through the explicit exactness statement `KaehlerDifferential.exact_mapBaseChange_map` plus a kernel-of-derivation argument. Mathlib has `mem_range_of_deriv_eq_zero` for the abstract case; the analogue for Kähler differentials goes through `KaehlerDifferential.range_eq_top_iff` or similar exactness lemmas.
- **Why it might be cheaper or sounder**: avoids the typeclass bridge (installing `Differential` on chart algebras) and works directly with the Kähler form the scheme-level argument already uses. Saves the typeclass-instance-construction LOC and removes the "alignment" looseness.
- **What the current strategy may have rejected**: the strategy's framing "ring-level half aligns with Mathlib `Differential.ContainConstants`" is plausibly a default reading of the most-named Mathlib lemma; the planner may not have considered the alternative route through `KaehlerDifferential` exactness directly. Unclear, planner should clarify whether the alignment claim is a true plan or a placeholder.
- **Severity of the omission**: minor — does not block the route; just a sub-step framing the planner should pin before iter-141+ scaffolding.

### Alternative: Pre-`leanok`-with-named-sorry on the M2.b body before M2.a closes

- **What it looks like**: scaffold the full `genusZeroWitness` body using `rigidity_over_k` as if its body were already closed (the named declaration exists with `sorry` already), then proceed to land the M2-side `JacobianWitness` builder + four-instance cluster on `Spec k` + vacuity-branch encoding *in parallel* with the iter-134+ piece-(i.b) prover lane. This decouples M2.b's "builder/instance/vacuity" sub-cost (320–750 LOC) from the piece (i)+(ii)+(iii) closure of M2.a, allowing the two lanes to ship in parallel iter-134+ instead of sequentially iter-151+ → iter-153+.
- **Why it might be cheaper or sounder**: the iter-131 sequencing puts M2.b body closure at iter-153+ (after M2.a body iter-151+). But the M2.b body's *Lean shape* (instance cluster + builder + vacuity branch) does NOT depend on M2.a's body closing, only on its named declaration existing (it already does). Parallelising the M2.b shape work into iter-134+ would shave 2–3 iter off M2 closure without disturbing the piece-by-piece pile build.
- **What the current strategy may have rejected**: the strategy mentions "M2.b body close" as a single iter-153+ step gated on M2.a body. If the planner has implicit pipeline reasoning ("don't write the M2.b body until you know what `rigidity_over_k` actually exports"), that pipeline reasoning may have foreclosed the parallel option. Unclear, planner should clarify.
- **Severity of the omission**: minor — schedule optimisation, not a route change.

### Alternative: Partial-result shipping (genus-0 only, sorry on positive genus)

- **What it looks like**: ship the entire 9-protected-declaration package with `nonempty_jacobianWitness` proved for `genus C = 0` only, with a single inline `sorry` for `0 < genus C`. The genus-stratified body produces a witness from the `genus = 0` arm via `genusZeroWitness`, and admits the positive-genus arm by `sorry`. M3 is then off the loop's critical path forever — the project ships an M2-complete artefact with one parameter-restricted `sorry`.
- **Why it might be cheaper or sounder**: would deliver a verifiable end-state in (estimated) iter-160 instead of iter-260+, with the positive-genus case framed as honest future work. The iter-121 pivot dropped this framing explicitly, but the framing dropped was "ship with one inline sorry **as the end-state**", not "ship with one inline sorry **as a milestone**" — a halfway shipping point may still be valuable.
- **What the current strategy may have rejected**: the iter-126 user hint explicitly rejected the named-axiom alternative on M3, and the iter-121 pivot rejected the inline-sorry end-state. The strategy treats these as equivalent prohibitions of partial shipping. **The user hint cited explicitly applies to the M3 user-escalation decision (Route A vs axiomatising `nonempty_jacobianWitness`); the strategy itself flags that the hint should not be cited as a blanket** (`§ Soundness rules ▸ User-hint citation discipline`). A halfway-shipping milestone is arguably a distinct decision the user has not been asked about.
- **Severity of the omission**: minor → moderate, depending on user intent. Probably worth surfacing to the user at the next plan-phase TO_USER opportunity: "ship M2 + sorry-on-M3 as a milestone artefact?" The current strategy treats this as foreclosed; the user-hint citation discipline section suggests it may not actually be.

## Sunk-cost flags

- "The over-k commitment (iter-133) is now defended on cleanliness (ii) + active revert option (iii) + piece (i.a) tractability (iv, scope-narrow)." — Why this is sunk-cost-adjacent: ground (iii) "active revert option" is a risk mitigation, not positive evidence; ground (ii) is self-flagged as switching-cost; ground (iv) does not differentiate over-k from over-`k̄`. The defense as stated collapses to "we've been building over k for several iter and the build hasn't yet failed". **Recommendation**: tighten the framing so that the over-k commit is honestly defended by (a) the iter-128 → iter-132 work already exists over `[Field k]` (a switching cost, named honestly as such) + (b) blueprint cleanliness, with revert wiring acknowledged as mitigation rather than ground. This is a framing fix, not a route pivot.

(All other sunk-cost watchpoints the strategy already names — the iter-128 close strike, the iter-131 close strike, the iter-126 user-hint scope-narrowing, the iter-134 fibre-free axis-3/4 self-flag — appear correctly applied. The strategy's anti-sunk-cost discipline is generally strong.)

## Prerequisite verification

- `IsLocalRing.CotangentSpace` — VERIFIED (exists in `Mathlib.RingTheory.Ideal.Cotangent`; iter-135 rename from phantom `IsRegularLocalRing.cotangentSpace` was correct).
- `Differential.ContainConstants` — VERIFIED (exists in `Mathlib.RingTheory.Derivation.DifferentialRing`), **but** see CHALLENGE: the typeclass is shaped for `Differential B` (a derivation `B → B`), not for the Kähler form `B → Ω_{B/A}` the scheme-level argument uses. The "alignment" the strategy claims is loose; planner should pin the bridge before iter-141+.
- `AlgebraicGeometry.Scheme.absoluteFrobenius` — VERIFIED MISSING from Mathlib `b80f227` (`lean_loogle "absoluteFrobenius"` returns nothing; `lean_leansearch "absolute Frobenius scheme"` returns no scheme-level hits). Strategy correctly flags this as piece (iii) build, 800–1500 LOC.
- `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` — phantom (strategy flags correctly as piece (i.c) build).
- `KaehlerDifferential.tensorKaehlerEquiv` — strategy's iter-133 mathlib-analogist verdict references this; I did not re-verify the exact Mathlib name, but the family `KaehlerDifferential.exact_mapBaseChange_map` is in Mathlib (referenced under M1.d as part of the standalone-utility build), so the named bridge is plausible.

## Must-fix-this-iter

- Route **Direct over-k rigidity**: CHALLENGE — tighten the qualitative defense framing. Either restate (iii) as "risk mitigation, not positive defense" and concede that the substantive ground reduces to (ii) blueprint cleanliness + iter-128→iter-132 switching cost; OR re-open the over-k vs over-`k̄` decision with the honesty that the quantitative case is lower-bound zero. The current iter-133 framing of (iii) as a defensive ground reads like procedural reassurance rather than substantive evidence.

- Route **M2.body-pile piece (ii)**: CHALLENGE — pin the `Differential.ContainConstants` alignment before iter-141+ piece-(ii) scaffolding. Either (a) name the typeclass-instance-construction bridge (`Differential` instance on chart algebra from `KaehlerDifferential`) with an LOC estimate, or (b) pivot piece (ii) to route through `KaehlerDifferential.exact_mapBaseChange_map`-style exactness lemmas directly. The "ring-level half aligns" framing is loose.

- Alternative **Partial-result shipping (genus-0 + sorry on positive genus)**: minor → moderate omission. The strategy treats the iter-126 user-hint as foreclosing this alternative, but the strategy itself flags (under `§ Soundness rules ▸ User-hint citation discipline`) that the user-hint scope is M3 user-escalation, not blanket. Planner should consider whether a milestone-shipping decision warrants its own TO_USER consultation rather than being absorbed under the existing decision.

## Overall verdict

A fresh mathematician would approve this strategy as **substantively sound** with framing tightenings required on two points (the over-k qualitative defense, and the piece-(ii) `Differential.ContainConstants` alignment). The mathematical content is correct, the decomposition is the right shape, the M2.body-pile sub-step structure (i.a → i.b → i.c → ii → iii) tracks the standard cotangent-vanishing rigidity argument, and the M3 user-escalation is honestly framed. The strategy's anti-sunk-cost discipline (iter-130 strike on iter-128 evidence, iter-132 strike on iter-131 evidence, iter-133 scope-narrowing of ground (iv), iter-134 forward-merit vs switching-cost flagging on the fibre-free scorecard) is unusually strong and worth preserving. The most fragile point is the over-k commit's qualitative defense: with the quantitative case collapsed to lower-bound zero, the load-bearing ground is now blueprint cleanliness + a switching-cost reading of "the work already exists over `[Field k]`", and the strategy should name that honestly rather than wrap it in revert-trigger framing. No route rejections; the planner should proceed iter-136 on the existing plan, with the two CHALLENGE items folded into the iter-136 plan rebuttal or absorbed into STRATEGY.md.

---

iter136: SOUND — 7 routes audited, 2 CHALLENGE verdicts (over-k defense framing; piece (ii) `Differential.ContainConstants` alignment), 1 minor-to-moderate alternative (partial-result shipping milestone).
