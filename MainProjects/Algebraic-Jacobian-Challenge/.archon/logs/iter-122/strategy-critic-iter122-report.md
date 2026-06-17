# Strategy Critic Report

## Slug
iter122

## Iteration
122

## Routes audited

### Route: M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart

- **Goal-alignment**: FAIL — the strategy never establishes how M1 contributes to closing `nonempty_jacobianWitness` (the project's single live sorry). M1 builds differentials infrastructure; neither M2's decomposition (rigidity + base change + descent + Riemann-Roch) nor M3's decomposition (Picard scheme or symmetric-powers route) lists M1's bridge as a prerequisite. Strategy claims "closure of the new bridge declaration … reduces the project's sorry count by 1", but introducing a fresh declaration with a `sorry` body and then closing it is **net zero** on the sorry count. The only currently inhabited sorry is `Jacobian.lean:179`; nothing in M1 closes that.
- **Mathematical soundness**: PASS — the bridge claim itself (presheaf section ≃ₗ algebra-Kähler module on an affine chart) is mathematically reasonable, and the M1.a-M1.e decomposition is internally coherent.
- **Sunk-cost reasoning detected**: yes — M1 is justified entirely as "upstream Mathlib infrastructure investment" with a Mathlib-contribution-candidate framing (`KaehlerDifferential.equivOfFormallyUnramified`). The strategy does not justify M1 in terms of the project goal. Given that `Differentials.lean` has been actively developed across many prior iterations, this looks like momentum-following rather than route-on-merits.
- **Phantom prerequisites**: none — all named lemmas resolve in Mathlib (see Prerequisite verification below).
- **Effort honesty**: under-counted on M1.b — "2-3 iter / 100-250 LOC" for proving `IsLocalization M A_colim` via a bidirectional `IsLocalization.of_le` argument plus colim-cocone universal property is optimistic given that you also need to construct the cocone, verify `A_M → A_colim` definitionally, and discharge `IsScalarTower` instances. Realistically 3-5 iter / 200-400 LOC.
- **Verdict**: CHALLENGE
  - **What the planner must address**: either (a) state explicitly which existing sorry in the project chain M1 closes (path: file + line) and show the dependency in M2 or M3's decomposition, or (b) acknowledge that M1 is exploratory Mathlib infrastructure with no direct contribution to closing `nonempty_jacobianWitness`, and justify why scheduling it now (before any progress on M2/M3) is the right opportunity cost.

### Route: M2 — Genus-0 witness sub-theorem `genusZeroWitness`

- **Goal-alignment**: PASS — closing `genusZeroWitness` plus M3 via genus-stratified body restructure of `nonempty_jacobianWitness` discharges the protected chain. The `JacobianWitness` field `isAlbaneseFor : ∀ P, IsAlbanese C P J` makes the `C(k) = ∅` case vacuous as the strategy notes — verified against `Jacobian.lean:160`.
- **Mathematical soundness**: PARTIAL — the case split on `C(k) ≠ ∅` vs `C(k) = ∅` is the right framing. But the M2 plan does not verify that when `J = Spec k`, the protected instance `SmoothOfRelativeDimension (genus C) J.hom` is discharged (the witness records `smoothGenus : SmoothOfRelativeDimension (genus C) J.hom`; with `genus C = 0` and `J = Spec k`, this is `SmoothOfRelativeDimension 0 (𝟙 Spec k)`, which should follow but is not named as a step). Minor but worth flagging.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: M2.d depends on Riemann-Roch over `k̄` for the identification `C_{k̄} ≅ ℙ¹_{k̄}`. No Riemann-Roch infrastructure currently exists in Mathlib for curves (divisors, ℓ(D), Serre duality, the RR theorem itself). M2 names it as "Mathlib gap" but does not decompose it. Sub-step "5-10 iter / 250-500 LOC" is **off by an order of magnitude** versus the actual scope of Riemann-Roch for curves (divisors module, degree map, RR space dimension, Serre duality with `Ω¹_{C/k}`, the RR statement and proof — realistically 1500-3000+ LOC).
- **Effort honesty**: under-counted — M2 total "5-10 iter / 250-600 LOC" is grossly inconsistent with M2.d alone needing 5-10 iter / 250-500 LOC. The arithmetic at face value gives 5-10 iter / 250-600 LOC ≈ M2.d alone, leaving zero budget for M2.a, M2.b, M2.c. Realistic total: 15-30 iter / 1000-2500 LOC.
- **Verdict**: CHALLENGE
  - **What the planner must address**: (i) refactor M2.d into sub-steps (divisor module, degree, RR space, Serre duality, RR statement, RR-implies-`ℙ¹` corollary), each with honest LOC estimates; (ii) re-aggregate M2 total to reflect M2.d's true cost; (iii) verify that `J = Spec k`-as-witness discharges the `smoothGenus` field when `genus C = 0` (or add it as a named sub-step). (iv) Consider whether the `C(k) ≠ ∅` arm even needs full Riemann-Roch: rigidity of `C → A` killing `P` to a constant map is *weaker* than `C ≅ ℙ¹`, and might be provable via H¹ vanishing of pullbacks plus the cotangent exact sequence — name this as an alternative and rule it out explicitly if pursuing the RR path.

### Route: M3 — Positive-genus witness sub-theorem `positiveGenusWitness`

- **Goal-alignment**: PASS in principle — closing `positiveGenusWitness` discharges the positive-genus arm.
- **Mathematical soundness**: PASS — both Route A (Picard scheme via FGA) and Route B (Symmetric powers + Stein) are mathematically correct routes to constructing the Albanese variety for a smooth proper geom-irred curve.
- **Sunk-cost reasoning detected**: no, but the route framing avoids the hard question.
- **Phantom prerequisites** (both routes):
  - Route A: Hilbert scheme representability, Quot scheme representability, identity-component `G^0 ⊆ G` — none exist in Mathlib (confirmed by Mathlib namespace scan: no `AlgebraicGeometry.HilbertScheme`, no `AlgebraicGeometry.QuotScheme`, no `IdentityComponent`). Each is a multi-thousand-LOC undertaking.
  - Route B: scheme-level `Sym^n`, finite-group-scheme quotients, Stein factorisation, Brill-Noether-Riemann-Roch — none exist.
- **Effort honesty**: under-counted — "many tens of iters / thousands of LOC" is a placeholder. The actual scope of Hilbert + Quot + Picard representability (Route A) is plausibly 10000+ LOC; Riemann-Roch + symmetric-powers-with-quotients (Route B) similarly. The strategy says "hard fallback: if both routes exceed 5000 LOC of upstream-Mathlib work, escalate to user" — the *honest answer* is that both routes will exceed 5000 LOC by a large margin, so the escalation should be **triggered now**, not after the M1-closes Mathlib-coverage audit.
- **Verdict**: CHALLENGE
  - **What the planner must address**: (i) execute the route-pick Mathlib coverage audit **this iter** rather than gating it on M1 closure — the audit is an offline LOC estimate that doesn't depend on M1's bridge; (ii) once both routes are honestly costed, trigger the "escalate to user" fallback the strategy already promises, because both routes exceed 5000 LOC of Mathlib gap; (iii) the per-iter "on-track" signal allows infinite scaffolding-with-`sorry` without anything closing, which is not a real progress signal — define a closure milestone (e.g. at least one gating piece's body fully closes with `lean_verify` to kernel-only axioms by iter N).

## Alternative routes (suggested)

### Alternative: Genus-0 rigidity *without* Riemann-Roch — direct cotangent-vanishing argument

- **What it looks like**: For the `C(k) ≠ ∅` genus-0 case, instead of proving `C ≅ ℙ¹` over `k̄` and then descending, prove rigidity directly: any morphism `f : C → A` killing `P` is constant. The argument uses (a) `f` is determined by its action on `Pic⁰(C) = 0` for genus-0, or (b) the pullback `f*(Ω¹_{A/k})` vanishes because `H⁰(C, Ω¹_{C/k}) = 0` for genus-0 (this is the dual statement of `H¹(C, O_C) = 0`, which is the *definition* of `genus C = 0` in this project). Combined with `A` being abelian (so `Ω¹_{A/k}` is trivial of rank `dim A`), the pullback factor through `0` and `f` is constant.
- **Why it might be cheaper or sounder**: avoids constructing `C ≅ ℙ¹` entirely, which is where the Riemann-Roch cost sits. The cotangent-vanishing argument uses (a) `H⁰(C, Ω¹) = 0` (Serre dual of `H¹(C, O_C) = 0`, definable via `Genus.lean`'s existing machinery once Serre duality lands), (b) abelian variety structure (which the witness already provides via `GrpObj`), (c) zero-cotangent-pullback ⇒ constant (a general scheme-morphism lemma). Cheaper because Serre duality on a smooth proper curve is much smaller than full Riemann-Roch.
- **What the current strategy may have rejected**: unclear; the strategy commits to RR without naming this alternative. The current cohomology/HModule infrastructure suggests Serre duality may be within reach with M2-scale effort.
- **Severity of the omission**: major — if this route works, M2.d's 1500-3000+ LOC estimate may collapse to 300-800 LOC.

### Alternative: Pivot the user pivot — keep `nonempty_jacobianWitness` as a project axiom and ship the protected chain

- **What it looks like**: Iter-121 pivoted from "ship with one inline `sorry`" to "Mathlib-contributor, zero sorry, multi-month." The alternative reads: re-engage the user on whether this trade is right, given the actual scope of M2+M3 (probably 5000-15000 LOC, multi-year). Concretely: introduce `nonempty_jacobianWitness` as an `axiom` (rather than `theorem … := sorry`), so the protected chain `lean_verify`s to a single named project axiom + kernel axioms — clean, auditable, doesn't pretend to be theorem-statementsmall.
- **Why it might be cheaper or sounder**: the strategy's "zero inline sorry" end-state and the protected chain shipping with `lean_verify` to clean axioms can be reconciled by promoting the one remaining sorry to an axiom (signature unchanged). The protected chain then ships unconditionally. The Mathlib-contributor work continues, but as a *separate track* (M1, M2, M3) whose closure date is not on the critical path for shipping the protected nine declarations.
- **What the current strategy may have rejected**: the iter-121 user directive explicitly forbids "deferred" framing. But an `axiom` is **not** a deferred sorry — it is an explicit, named, auditable assumption (matching the mathematical content of "Albanese variety exists for smooth proper geom-irred curves over a field"). The user directive may permit this framing if asked.
- **Severity of the omission**: critical — the planner should at minimum *name* this alternative and explain why the user pivot rules it out, rather than silently committing to a multi-year roadmap.

### Alternative: Parallelise M3 route-pick instead of gating on M1

- **What it looks like**: The Mathlib-coverage audit for Route A vs Route B does not require any Lean proving — it is a Mathlib namespace scan + LOC estimation. Execute it in iter-122, alongside M1.a/M1.b, rather than waiting for M1 to close.
- **Why it might be cheaper or sounder**: M1 may stall (e.g. M1.b's `IsLocalization`-of-colim construction is non-trivial). The route-pick decision is the most important strategic choice in M3, and deferring it indefinitely is bad project management. Running it in parallel costs ~1 iter of analyst work and de-risks the M3 entry.
- **What the current strategy may have rejected**: the strategy says "Trigger: first iter after M1 closes" — this gating is unjustified.
- **Severity of the omission**: minor (process improvement, not a strategic flaw).

## Sunk-cost flags

- `"M1 is upstream Mathlib infrastructure investment. The closure of the new bridge declaration relativeDifferentialsPresheaf_equiv_kaehler_appLE reduces the project's sorry count by 1 once introduced and closed."` — Why this is sunk-cost: M1 introduces a *new* sorry then closes it (net zero), and no downstream step in M2 or M3 references M1's output as a prerequisite. The justification reduces to "we've built Differentials.lean so far, let's keep building it." Recommendation: reframe M1 either as a downstream prerequisite of a specific M2/M3 step (with explicit dependency), or as an exploratory Mathlib contribution explicitly off the critical path for shipping the protected chain.

- `"Iter-122 schedules M1.a or M1.b as the first concrete sub-step, contingent on the iter-122 blueprint-reviewer clearing the HARD GATE on Differentials.tex"` — Why this is sunk-cost-adjacent: the iter-122 sequencing prioritises M1 because it is mid-stream, not because it is the highest-value next step. M2.a (rigidity over `k̄`) or M3 route-pick audit are at least as good candidates for the next concrete step and have clearer goal-alignment. Recommendation: re-justify the iter-122 first-step choice on merits, not on Differentials chapter momentum.

## Prerequisite verification

- `Algebra.FormallyUnramified.of_isLocalization`: VERIFIED (`Mathlib.RingTheory.Unramified.Basic`)
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`: VERIFIED (`Mathlib.AlgebraicGeometry.AffineScheme`)
- `KaehlerDifferential.exact_mapBaseChange_map`: VERIFIED (`Mathlib.RingTheory.Kaehler.Basic`)
- `KaehlerDifferential.map_surjective`: VERIFIED (`Mathlib.RingTheory.Kaehler.Basic`)
- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`: VERIFIED (`Mathlib.RingTheory.Etale.Kaehler`)
- `IsLocalization.of_le`: VERIFIED (`Mathlib.RingTheory.Localization.Defs`)
- `IsLocalization.lift`: VERIFIED (lift family present, e.g. `IsLocalization.lift_algebraMap_eq_algebraMap`; the constructor itself is standard `IsLocalization` API)
- `IsLocalization.ringHom_ext`: NEEDS VERIFICATION — exact name not found via local search; almost certainly exists under a variant (Mathlib has `IsLocalization.ext` and uniqueness-of-localisation-lift machinery), but the planner should pin the exact lemma name before committing to M1.b's "via `IsLocalization.ringHom_ext`" proof.
- `relativeDifferentialsPresheaf_obj_kaehler` (project-local): VERIFIED at `AlgebraicJacobian/Differentials.lean:54-64`.
- `Hilbert scheme representability` / `Quot scheme representability` / `Identity component construction` (M3 Route A): MISSING in Mathlib — strategy correctly flags as gaps.
- `Symmetric powers Sym^n X` / `Stein factorisation` / `Brill-Noether-Riemann-Roch` (M3 Route B): MISSING in Mathlib — strategy correctly flags as gaps.
- `Riemann-Roch over k̄` (M2.d): MISSING in Mathlib — strategy correctly flags as gap, but under-counts the LOC by an order of magnitude.

## Must-fix-this-iter

- **Route M1: CHALLENGE** — planner must either name the dependency M1 → M2/M3 → `nonempty_jacobianWitness` closure (file/line specific), or acknowledge M1 is off the critical path and justify the iter-122 first-step prioritisation on opportunity-cost grounds. Without this, M1 is sunk-cost momentum.
- **Route M2: CHALLENGE** — M2.d under-counted by ~5-10×; M2 total LOC inconsistent with M2.d alone; cotangent-vanishing alternative to full Riemann-Roch not considered. Planner must (i) refactor M2.d into honest sub-steps, (ii) re-aggregate M2 total, (iii) explicitly rule in or out the Serre-duality / `H¹(O_C) = 0`-based cotangent-vanishing alternative.
- **Route M3: CHALLENGE** — route-pick gated on M1 closure unnecessarily; "hard fallback" 5000-LOC threshold will trigger on both routes once honestly costed. Planner must run the Mathlib-coverage audit this iter and escalate to the user with the resulting LOC estimates.
- **Alternative "Cotangent-vanishing rigidity without RR"**: major — strategy ignored a potentially-cheaper path to the genus-0 universal property. Planner must address.
- **Alternative "Keep `nonempty_jacobianWitness` as a named axiom"**: critical — the strategy commits to a multi-year roadmap without explicitly weighing the alternative of promoting one sorry to an axiom (consistent with `lean_verify`-to-kernel-axioms-plus-one-named-axiom shipping). The user directive forbids "deferred" framing but does not, on its face, forbid an explicit `axiom`. Planner must engage the user on this trade or document why it is ruled out.
- **Phantom prerequisite `IsLocalization.ringHom_ext`**: planner must pin the exact lemma name in Mathlib before M1.b begins.

## Overall verdict

A fresh mathematician would not approve this strategy as-is. The M2 and M3 LOC estimates are off by 5-10× and 10× respectively against the actual scope of Riemann-Roch + Picard/symmetric-powers machinery in Mathlib (which is essentially absent). M1 is presented as the iter-122 first concrete step but its causal contribution to closing `nonempty_jacobianWitness` is never articulated — the strategy reads as "continue building Differentials.lean because we've been building Differentials.lean," with the bridge declaration framed as a contribution candidate rather than as a project prerequisite. The genus-0 sub-strategy commits to full Riemann-Roch when a Serre-duality-based cotangent-vanishing argument may suffice (cheaper and more direct given the project's existing cohomology infrastructure). And the iter-121 pivot to "zero inline sorry, Mathlib-contributor mode" turns this into a multi-year project without first considering the natural alternative of promoting the single remaining sorry to a named `axiom` so the protected chain can ship while the M1/M2/M3 roadmap proceeds on a non-critical-path track. The strategy is salvageable, but the planner must (a) explicitly defend M1's place on the critical path or move it off, (b) re-cost M2.d and M3 honestly, (c) execute the M3 route-pick audit this iter and likely trigger the user-escalation fallback, and (d) name and address the cotangent-vanishing-rigidity and named-axiom alternatives.
