# Strategy Critic Report

## Slug
iter144

## Iteration
144

## Routes audited

### Route: M1 — Presheaf-bridge (EXCISED iter-126; M1.d standalone utility retained)

- **Goal-alignment**: PASS — excision shrank the active sorry inventory; `kaehler_quotient_localization_iso` stays as a standalone Mathlib-shaped utility, not on any closure-of-protected-chain critical path.
- **Mathematical soundness**: PASS — the M1.d statement (`Ω[B⁄A] → Ω[B⁄L]` is a `B`-linear equivalence when `A → L` is a localization at a submonoid of `A`) is correct and the route through `KaehlerDifferential.exact_mapBaseChange_map` + `Algebra.FormallyUnramified.of_isLocalization` is the right Mathlib stitch.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags §1 (residual "off-loop upstream-PR work" sentence on line 158).
- **Phantom prerequisites**: none — every named Mathlib lemma in the M1.d build (`KaehlerDifferential.map`, `KaehlerDifferential.exact_mapBaseChange_map`, `Algebra.FormallyUnramified.of_isLocalization`) is in Mathlib.
- **Effort honesty**: reasonable — utility is small (under ~200 LOC by the iter-126 description).
- **Verdict**: CHALLENGE — minor wording fix needed on line 158 to make the iter-144 reframing internally consistent (see § Must-fix #1).

### Route: M2.a — `rigidity_over_k` via cotangent-vanishing pile pieces (i)+(ii)+(iii)

- **Goal-alignment**: PARTIAL — M2.a, if closed, supports M2.b which supports the genus-0 arm of the protected `nonempty_jacobianWitness` genus case-split. The chain is correct in principle.
- **Mathematical soundness**: **CHALLENGE** — the strategy never articulates **how `df = 0` is established** for `f : C → A`. Pieces (ii) and (iii) are stated as IF-`df=0`-THEN-factor implications (piece (ii) = "scheme-level `df=0 ⇒ factors-through-Spec-k`"; piece (iii) Frobenius iteration is char-p machinery for the implication, NOT for establishing `df = 0` itself). Piece (i) gives `Ω_A` free of rank `n`, so a morphism `O_C^n → Ω_C` is `n` global sections of `Ω_C`. Vanishing of those sections requires `H^0(C, Ω_C) = 0`. The project's genus definition is `dim H^1(C, O_C)` (arithmetic genus), so the bridge `H^1(C, O_C) = 0 ⇒ H^0(C, Ω_C) = 0` is **Serre duality on a smooth proper curve** — i.e. piece (iv), which the strategy DEFERS. The strategy line 232 says "Serre duality … is NOT NEEDED for M2.a body closure (the pile is (i)+(ii)+(iii) only)" but never says by what alternative chain `df = 0` is established. The iter-127 over-k analogist returned OK_OVER_K on the three pieces; the strategy should either (a) inline the alternative `df = 0` chain that bypasses Serre duality, or (b) reactivate piece (iv) and reprice. Without the chain, the strategy is one line short of mathematically grounded.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags §2 (over-k commitment grounds (ii) + (iv); the iter-138 reframing to "operationally defaulted, bounded revert cost preserved" is honest language, but the cumulative weight of these renames + the fact that quantitative LOC savings have collapsed to "0–500 LOC" lower bound zero deserves a fresh look).
- **Phantom prerequisites**: 
  - `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` — flagged as PHANTOM (under construction as piece (i)).
  - `AlgebraicGeometry.Scheme.absoluteFrobenius` — flagged as PHANTOM (~800–1500 LOC build planned for piece (iii)).
  - `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` — flagged as PHANTOM (piece (ii) build planned).
  - **NEW concern**: the lemma `genus C = 0 ⇒ no nonzero map O_C^n → Ω_C` is unnamed in the strategy and is the unstated load-bearing input for `df = 0`. Either Serre duality (piece (iv)) is needed and not deferred, or another chain (Riemann–Roch / direct cohomology / Mumford rigidity restated) needs to be named.
- **Effort honesty**: under-counted on the unaddressed `df = 0` step. The current ~1850–3600 LOC for pieces (i)+(ii)+(iii) does NOT include the cost of whatever establishes `df = 0`.
- **Verdict**: **CHALLENGE** — articulate the `df = 0` derivation in STRATEGY.md (or reactivate piece (iv) and reprice) before iter-145+ piece (iii) scaffolding commits.

### Route: M2.b — `genusZeroWitness` consuming `rigidity_over_k` + terminal-object cluster + vacuity branch

- **Goal-alignment**: PASS — body closure produces the genus-0 arm of the case-split.
- **Mathematical soundness**: PASS — the `Classical.byCases` over `Nonempty (𝟙_ _ ⟶ C)` correctly splits into (substantive use of rigidity on the `P` arm) and (vacuous `∀ P, IsAlbanese …` on the empty arm). The vacuity-branch verification in the strategy (lines 204–209) is internally consistent: `IsAlbanese` is genuinely universally quantified, so vacuity is sound.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: terminal-object instance cluster on `Spec k` (GrpObj, SmoothOfRelativeDimension 0, IsProper, GeometricallyIrreducible) — flagged in the strategy at ~200–500 LOC, plausible.
- **Effort honesty**: reasonable per the iter-130 revision (2–4 iter / 320–750 LOC).
- **Verdict**: SOUND — assuming M2.a closes mathematically.

### Route: M3 — `positiveGenusWitness` via Route A (Picard scheme via FGA, COMMITTED iter-144)

- **Goal-alignment**: PASS — Route A produces the Albanese variety as `Pic^0_{C/k}`, which structures the positive-genus arm.
- **Mathematical soundness**: PASS — Picard scheme via Hilbert / Quot representability + identity-component extraction is the canonical FGA-tradition argument. The three top-3 gating Mathlib pieces (Hilbert scheme representability, Quot representability, `G^0 ⊆ G` identity component) are the right decomposition.
- **Sunk-cost reasoning detected**: no — the user-hint commits Route A based on iter-123 audit (LOC + cross-utility), not "we've already done X". (The audit itself, however, is ~21 iters old; see Must-fix #3.)
- **Phantom prerequisites**:
  - `Mathlib.AlgebraicGeometry.Hilbert.Representability` — VERIFIED missing (leansearch returns only local Zariski representability, no projective Hilbert scheme).
  - `Mathlib.AlgebraicGeometry.RelativeSpec` — VERIFIED missing.
  - QCoh+Coh typeclass on `Scheme.SheafOfModules` — strategy says ~700–900 LOC; consistent with prior audit.
  - `IsConnectedSpace` + connected-component construction for group objects in `Scheme/k` — partial Mathlib infra exists for topological spaces but not for schemes-as-group-objects.
- **Effort honesty**: ~6500 LOC midpoint is the iter-123 audit result. The audit is 21 iters old and rests on Mathlib snapshot `b80f227`. Cross-iter Mathlib growth (especially in `AlgebraicGeometry.Sites.Representability`) may have either narrowed gaps or shifted naming. Should be refreshed before serious Route A scaffolding starts.
- **Verdict**: CHALLENGE — Route A is reasonably committed on the iter-144 user-hint, but a Route A audit refresh (~1 iter analogist consult) is warranted before iter-150+ RelativeSpec scaffolding lands. Otherwise the planner is committing 6500+ LOC against stale numbers.

## Alternative routes (suggested)

### Alternative: Direct `df = 0` chain via Mumford-style infinitesimal rigidity bypassing Serre duality

- **What it looks like**: Establish `df = 0` for `f : C → A` (C genus 0, A smooth proper geometrically irreducible group scheme) WITHOUT invoking `H^0(C, Ω_C) = 0` as a global cohomological vanishing. Use instead a chart-local + Frobenius-iteration argument: for each closed point `x ∈ C`, look at the differential `df_x : T_x C → T_{f(x)} A`; the image lives in the trivialised `Ω_A` (piece (i)); the cumulative obstruction across all jet orders is handled by piece (iii) Frobenius iteration in char p and by formal-smoothness in char 0. The conclusion `f` factors through `Spec k` follows from infinitesimal lifting + properness of `C`.
- **Why it might be cheaper or sounder**: if the strategy's actual route IS this (rather than the Serre-duality-flavored global vanishing route I sketched), then articulating it would close the soundness CHALLENGE on M2.a above. Cost: ~50 LOC of strategic prose, no new code.
- **What the current strategy may have rejected**: unclear — the strategy doesn't articulate the `df = 0` derivation at all, so this may be the intended route but never written down.
- **Severity of the omission**: critical — without naming the route, the M2.a body closure has a mathematical gap that future iters won't notice until they try to write it.

### Alternative: Refresh the M3 Route A audit (iter-145 mandatory) before iter-150+ RelativeSpec scaffolding

- **What it looks like**: Dispatch `mathlib-analogist-m3-route-a-refresh-iter145` against the current Mathlib snapshot (not `b80f227`). Re-price A1 (Hilbert / QCoh / Coh / flattening ~4150 LOC), A2 (Quot post-A1 ~1400 LOC), A3 (identity-component ~1025 LOC) on current Mathlib. Persist refreshed verdict file.
- **Why it might be cheaper or sounder**: a 21-iter-stale audit is the kind of foundation that, when wrong, costs the project ~10× the cost of refreshing it. Even if numbers don't shift, the audit refresh produces a current-Mathlib bill-of-materials that the iter-150+ scaffold can target precisely.
- **What the current strategy may have rejected**: nothing explicit; the audit refresh just isn't scheduled.
- **Severity of the omission**: major — the audit underpins a ~6500 LOC, multi-year commitment; staleness risk is non-trivial.

### Alternative: Schedule M3 Route A start in parallel with M2 even when M2 is on track

- **What it looks like**: Current strategy line 613 says the iter-150 RelativeSpec scaffold trigger fires only on M2 slowness (cumulative pile LOC > 925 OR no M2.a body close by iter-160). Alternative: start RelativeSpec scaffolding at iter-150 regardless of M2 status, on parallel-capacity grounds. RelativeSpec is independent of M2 (no cross-dependency) and is gating the entire M3 critical path. Parallel start amortises wall-clock against the 9–24 month estimate.
- **Why it might be cheaper or sounder**: wall-clock optimisation. The 9–24 month estimate assumes sequential M2-then-M3; parallel start could compress that to ~7–18 months at the same LOC/iter rate.
- **What the current strategy may have rejected**: implicitly — the strategy treats M3 scheduling as a "planner-level call each iter" but ties the only iter-150 trigger to M2 slowness. A capacity-driven trigger would be additive.
- **Severity of the omission**: minor — it's a scheduling optimisation, not a mathematical or soundness concern.

## Sunk-cost flags

1. `"Off-loop upstream-PR work proceeds from that file; the in-tree declaration is the working version for the PR."` (line 158, M1.d block) — **Why this is sunk-cost**: contradicts the iter-144 reframing on lines 116–120 that M1.d is "ordinary in-tree project material, not a 'PR lane' with off-loop infrastructure". Suggests the off-loop PR framing is still partly load-bearing in the M1 prose. **Recommendation**: rewrite line 158 to "Detailed design in `analogies/relative-differentials-presheaf-bridge.md`; upstream PR extraction is an OPTIONAL downstream lift, not a project deliverable."

2. `"the over-k commitment carries on ground (ii) blueprint cleanliness honestly named as switching cost + ground (iv) piece (i.a) tractability honestly scoped to route-validation; ground (iii) revert wiring is retained operationally but no longer load-bearing"` (line 552) — **Why this is sunk-cost-adjacent (NOT sunk-cost itself)**: the language honestly flags switching cost and scope-limited route-validation. BUT the cumulative weight is now (a) quantitative net savings collapsed to lower-bound zero, (b) ground (i) struck, (c) ground (iii) demoted to risk mitigation, leaving only switching cost + a single-piece tractability data point. The iter-138 reframing to "operationally defaulted" is the right honest language; the concern is that "operationally defaulted" can serve as a fig leaf for a route that, under a fresh-context audit today, would not be re-chosen on its merits. **Recommendation**: add a single-sentence affirmative test: "If a fresh strategy-critic in iter-N+10 audited the over-k vs over-`k̄` choice with iter-N empirical data, would the choice still be made? If not, revert." Pre-commit this as an iter-150 check, NOT as a route-pivot trigger (which would over-fire), but as a soundness re-baseline that asks the question explicitly rather than hiding behind operational-default language.

3. `"the loop commits to **Route A**. The previous '5000-LOC hard-fallback user-escalation' gate is removed"` (lines 348–352) — **NOT sunk-cost** (this is the user-hint commitment, principled on iter-123 LOC + cross-utility), but the strategy should NOT treat the iter-123 audit numbers as eternally valid. **Recommendation**: see Alternative §2 (schedule iter-145 audit refresh).

## Prerequisite verification

- `KaehlerDifferential.map` / `KaehlerDifferential.exact_mapBaseChange_map` / `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED (in Mathlib, named in the M1.d build description).
- `Mathlib.Algebra.CharP.Frobenius`: VERIFIED (in Mathlib, ring-side only).
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: MISSING (strategy correctly flags; piece (iii) builds it in-tree).
- `Mathlib.AlgebraicGeometry.Hilbert.Representability`: MISSING (verified — leansearch returns only local Zariski representability, no projective Hilbert scheme).
- `Mathlib.AlgebraicGeometry.RelativeSpec`: MISSING (verified — leansearch returns affine schemes / Spec construction infra, no relative-Spec functor).
- `Mathlib.RingTheory.Derivation.DifferentialRing` `ContainConstants` typeclass: VERIFIED (strategy correctly notes it exists but only as differential-field-extension instance; the iter-138 PIN path (b) directly via `KaehlerDifferential.D` is the right move).
- `IsLocalRing.CotangentSpace`: VERIFIED (replaces the earlier phantom `IsRegularLocalRing.cotangentSpace`; strategy correctly notes the correction).
- `Mumford rigidity / Serre duality on smooth proper curves`: NOT in Mathlib as a unified theorem (this is consistent with the strategy's piece (iv) deferral language).

## Must-fix-this-iter

1. **Route M1 — CHALLENGE**: Rewrite STRATEGY.md line 158 to drop the residual "Off-loop upstream-PR work proceeds from that file; the in-tree declaration is the working version for the PR" sentence. Replace with iter-144-consistent wording (upstream PR extraction OPTIONAL, in-tree IS the work). Otherwise the iter-144 user-hint reframing of M1.d is half-applied.

2. **Route M2.a — CHALLENGE**: Articulate in STRATEGY.md (under § M2.body-pile or a new § "Why `df = 0` for `f : C → A` with `genus C = 0`") the **explicit chain that establishes `df = 0`** for the rigidity argument. Pieces (ii) and (iii) are IF-`df=0`-THEN-factor implications; they do not produce `df = 0` from genus-0 hypothesis. Either:
   - (a) inline the alternative chain (Mumford-style infinitesimal / chart-local Frobenius-iteration that bypasses Serre duality), citing the iter-127 over-k analogist's verbatim reasoning, OR
   - (b) reactivate piece (iv) Serre duality as ACTIVE (not DEFERRED) for M2.a body closure, and reprice (this adds ~3000–8000 LOC and is multi-iter; substantial impact).
   
   This is the most material gap I see in the strategy. Without (a) or (b), the M2.a body closure is one mathematical step short of complete.

3. **Route M3 — CHALLENGE (refresh audit)**: Schedule an iter-145+ `mathlib-analogist-m3-route-a-refresh` consult against current Mathlib snapshot before iter-150+ RelativeSpec scaffolding. The iter-123 audit underpinning the ~6500 LOC commitment is 21 iters old and rests on `b80f227`. Even a one-iter refresh of the per-piece LOC + naming would protect against snapshot drift.

4. **Alternative — minor**: consider whether the iter-150 RelativeSpec trigger should ALSO have a capacity-driven arm ("M2 on track + parallel capacity available → start RelativeSpec scaffold sooner") in addition to the current slowness-driven arm. Not a must-fix; a wall-clock optimisation worth discussing.

5. **Sunk-cost guardrail (soft must-fix)**: add a single-sentence iter-150 over-k-route fresh-audit check (see Sunk-cost flags §2 recommendation). This converts the operational-default language into a falsifiable soundness re-baseline.

## Overall verdict

A fresh mathematician would approve the strategy's overall **structure** — genus case-split, over-k commitment with explicit revert wiring, Route A commitment on iter-144 user-hint, no-axiom rule — as coherent and defensible. However, **the strategy contains one material mathematical gap**: M2.a's body closure via pieces (i)+(ii)+(iii) never articulates how `df = 0` is established for `f : C → A` from the `genus C = 0` hypothesis. The standard route uses Serre duality (piece (iv)), which the strategy explicitly defers. The strategy either has an unstated alternative chain (which it must name in writing) or it has implicitly under-scoped M2.a by deferring a load-bearing piece. This is the single highest-priority fix this iter. Secondary fixes: a minor wording leftover on M1.d line 158, and a stale-audit risk on the iter-144 Route A commitment. Once these are addressed, the strategy is sound to execute against.

---

*Return line*: `iter144: CHALLENGE — 4 routes audited, 4 CHALLENGE verdicts (1 critical math soundness, 1 minor wording, 1 audit refresh, 1 scheduling alternative)`
