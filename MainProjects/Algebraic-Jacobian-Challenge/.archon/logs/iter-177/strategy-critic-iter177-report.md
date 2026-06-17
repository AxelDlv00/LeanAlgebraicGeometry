# Strategy Critic Report

## Slug
iter177

## Iteration
177

## Routes audited

### Route: A — Picard scheme via FGA (positive-genus arm)

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` realizes the Albanese UP for positive-genus curves; matches `nonempty_jacobianWitness` for the `genus C ≠ 0` branch.
- **Mathematical soundness**: PASS — Kleiman §4–5 + Nitsure §5 + Milne III §6 is the canonical pipeline; dependency graph in `## Routes` is correct.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — every unowned substrate item (Stacks 052H, Quot, Grassmannian, FGA Pic, `IdentityComponent`, `Sym^g`) has an in-tree owner file and an explicit sub-phase row; nothing is parked on "future Mathlib upstream PR" without a project-side plan.
- **Phantom prerequisites**: none flagged. The strategy itself states "No `AbelianVariety` / no general Riemann–Roch in Mathlib (both verified absent)"; the verifiable in-Mathlib pieces it leans on (qcoh-algebras, étale sheafification, depth fragments, valuative criterion) are realistic to consume even when partial.
- **Effort honesty**: under-counted — the 185–340-iter band derives from the A.1.a realized rate (~50 LOC/it), which is the EASIEST sub-phase (well-documented `RelativeSpec`). Deeper substrate (Stacks 052H, Quot, Grassmannian, codim-1 indeterminacy) plausibly runs at 10–25 LOC/it because each iter needs to first invent missing Mathlib API. A more honest band is ~250–500 iters. The strategy's mitigant is the axiomatise-staging path at ~25–35, which is fine as a fallback but should not be implicitly relied on.
- **Parallelism under-exploited**: no — A.1.a/b/c, A.4.b are explicitly parallel-startable; the rest are dependency-forced.
- **Verdict**: CHALLENGE — sub-phase shape is right, but effort band is anchored on the most favourable sub-phase. Widen Route A in-tree iter band or document why deeper substrate will not slow per-iter velocity.

### Route: C — genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — `J = Spec k` discharges the UP both when `C(k) = ∅` (vacuous) and when `C(k) ≠ ∅` (Cor 1.5 collapses morphisms ℙ¹ → A). Char-general.
- **Mathematical soundness**: PASS — Rigidity Lemma + Cor 1.5 + Cor 1.2 already axiom-clean per `Mathlib gaps` framing. 𝔾_m-scaling shortcut + density of 𝔾_m in ℙ¹ + `ext_of_isDominant` is sound. RR.1→RR.4 chain realizes "genus-0 + k̄-point ⟹ ℙ¹".
- **Sunk-cost reasoning detected**: no — the HARD STOP rule explicitly retires the chart-bridge after the next single attempt; the strategy is actively trying to escape its prior 5-iter spend, not double down on it.
- **Infrastructure-deferral detected**: no — RR.1–RR.4 each have file paths and concrete iter estimates; no Mathlib-upstream parking.
- **Phantom prerequisites**: none verified missing here.
- **Effort honesty**: reasonable — RR.1 active at ~30/it, others gated; ~30–50 iter band is in line with realized rates plus the still-pending chart-bridge.
- **Parallelism under-exploited**: no — RR.1 active concurrently with Lane A1; downstream RR.2/3/4 are sequential by mathematical dependency.
- **Verdict**: CHALLENGE — the Lane A1 HARD STOP "next iter SAME-ITER commits to (a) `TO_USER.md` escalation [...] AND (b) opens a concurrent prover lane on the `temporary axiom gmScalingP1_constant` path" auto-fires the axiom lane in the same iter that surfaces it to the user. Under the project rule "No new axioms", the axiom lane should be GATED on user signoff in TO_USER.md, not concurrent with the escalation. Re-order to: (a) write TO_USER.md and HALT the Route-C arm; (b) open the axiom lane only after user acks.

## Format compliance

- **Size**: 183 lines / 13210 bytes — over budget (~250 lines / ~12 KB byte budget; +1.2 KB over).
- **Headings**: PASS — exact canonical order `Goal / Phases & estimations / Routes / Open strategic questions / Mathlib gaps & new material`.
- **Per-iter narrative detected**: yes — `Mathlib gaps & new material` contains `(not yet scaffolded — owed iter-177+)` twice (`IdentityComponent.lean` row and `SymmetricPower.lean` row). Per-iter references belong in `iter/iter-NNN/plan.md`, not STRATEGY.md. Reword to `(skeleton owed)` or `(not yet scaffolded)`.
- **Accumulation detected**: no — no completed phases or excised routes still occupying space; the prose body of `Open strategic questions` carries a `REJECTED alternatives` bullet that names rejections without re-litigating each one, which is the canonical compact form.
- **Table discipline**: PASS — one short line per cell, LOC cells carry both remaining-LOC and realized/it figures.
- **Format verdict**: DRIFTED — minor: size +1.2 KB over budget AND two `iter-177+` per-iter references. Trim Mathlib-gaps section and excise the `iter-177+` markers; that recovers compliance.

## Alternative routes (suggested)

### Alternative: Albanese UP without Sym^g — direct Yoneda factorization via `Pic⁰`-functor of points

- **What it looks like**: Define the universal divisor class on `C ×_k Pic⁰` (A.1 outputs already give the Poincaré line bundle), then prove the UP by checking morphisms `C → A` factor through `Pic⁰` directly via functor-of-points on `T`-valued points (`T`-families of degree-0 line bundles), skipping `Sym^g C` entirely.
- **Why it might be cheaper or sounder**: A.4.d.i is currently 8–14 iters of *new project material* for `S_g`-quotient + smoothness of `Sym^g C`. The functor-of-points Albanese formulation bypasses `Sym^g` at the cost of strengthening A.2.c outputs (already needed). Net saving plausibly 6–12 iters.
- **What the current strategy may have rejected**: The strategy lists `"Pic⁰-functor-of-points Albanese-UP (shifts codim-1 content rather than eliminates)"` as REJECTED — the rejection grounds are real (the codim-1 extension still has to happen to lift `C → A` through `Pic⁰`), but it does *not* obviate the savings on `Sym^g`. The two reductions are independent.
- **Severity of the omission**: minor — re-litigate only if A.4.d.i body starts and hits unowned-substrate walls.

### Alternative: Genus-0 base case via separated-locus universal extension instead of 𝔾_m-scaling

- **What it looks like**: Prove `ℙ¹ → A const` directly by extending the rational map from the affine chart `𝔸¹ ⊂ ℙ¹` to all of ℙ¹ via the valuative criterion of properness on `A`, then arguing constancy from a single closed-fibre collapse.
- **Why it might be cheaper or sounder**: Eliminates the chart-bridge `σ_×:ℙ¹×𝔾_m→ℙ¹` body that has been the Lane A1 blocker for 5 iters; the valuative criterion is already in Mathlib, and "morphism into proper variety extends from open dense" is locally provable.
- **What the current strategy may have rejected**: Not visible in `## Open strategic questions`. Strategy commits to 𝔾_m-scaling via the analogist's empirical recipe; this alternative would replace the recipe entirely.
- **Severity of the omission**: major — if Lane A1 HARD STOP fires this iter, this is a stronger fallback than `temporary axiom gmScalingP1_constant` because it stays sorry-free *and* axiom-free.

## Sunk-cost flags

- `Chart-bridge has been at ~0/it × 5 iters. This iter dispatches one final STRICT one-shot of analogist option (a)` — Why this is sunk-cost: a 6th attempt on the same tactical fragment after 5 zero-velocity iters is the textbook signal to switch strategy, not retry once more. The HARD STOP rule mitigates by capping the retry, but the choice to retry at all (vs. immediately route around to the separated-locus extension or temporary-axiom) is sunk-cost-adjacent. Recommendation: keep the HARD STOP, but pre-commit (in `## Open strategic questions`) to which alternative replaces the chart-bridge if the one-shot fails — don't decide at the failure moment.

## Must-fix-this-iter

- Route A: CHALLENGE — widen the 185–340-iter band, or document why deeper substrate (Stacks 052H, Quot, Grassmannian, A.4.a codim-1) will sustain the A.1.a realized ~50 LOC/it.
- Route C: CHALLENGE — re-order Lane A1 HARD STOP so the temporary-axiom prover lane is GATED on user signoff in `TO_USER.md`, not concurrent with the escalation. The project's "No new axioms" rule means the user is the gate, not the planner.
- Sym^g "REJECTED alternatives" framing: CHALLENGE — `Sym^g`/theta-divisor was rejected as a Jacobian construction, but A.4.d.i still uses `Sym^g C` for the Albanese UP wiring. Either clarify the rejection scope (i.e. "rejected *as the Jacobian object*") or drop the bullet, because as written it contradicts the table.
- Format: DRIFTED — trim Mathlib-gaps section to recover under 12 KB, AND replace the two `(... owed iter-177+)` markers with `(skeleton owed)` / `(not yet scaffolded)`. Restructure in-place this iter.
- Alternative `separated-locus universal extension` for genus-0 base: major omission — if Lane A1 HARD STOP fires, this alternative should be evaluated against the temporary-axiom fallback before any axiom lands.

## Overall verdict

The strategy is structurally correct and the sub-phase decomposition is honest: every unowned-substrate item has an in-tree owner file and a concrete iter band, so nothing is masquerading as "future Mathlib upstream PR". The genus-0 / positive-genus split on `genus C = 0` is the right shape, and both arms' end-states discharge `nonempty_jacobianWitness`. Issues are concentrated in three places: (i) the Route A in-tree iter band is anchored on the A.1.a-realized rate (the easiest sub-phase) and likely under-counts deeper substrate by 1.5–2×; (ii) the Lane A1 HARD STOP next-iter behaviour auto-fires a `temporary axiom gmScalingP1_constant` prover lane *concurrent* with the user escalation, which conflicts with the "No new axioms" project rule — the user should be the gate; (iii) format DRIFTED by ~1.2 KB and contains two `iter-177+` per-iter references in `## Mathlib gaps & new material` that need scrubbing. Net verdict: **CHALLENGE** — proceed with iter-177 prover dispatch only after STRATEGY.md is trimmed and the Lane A1 HARD STOP axiom-lane gating is corrected; the routes themselves remain sound.
