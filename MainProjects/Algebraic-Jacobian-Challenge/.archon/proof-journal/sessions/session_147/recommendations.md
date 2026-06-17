# Recommendations for iter-148

## Closest-to-completion targets

### 1. `AlgebraicGeometry.constants_integral_over_base_field`
   substep (3) — flat-base-change wrapper for proper schemes

The iter-147 closure chain decomposes the substep into 7 steps;
6 of those have catalogued Mathlib lemmas (algebraization,
base-change construction, `IsAlgClosed.algebraMap_bijective_of_isIntegral`,
`Module.finrank_baseChange`,
`Subalgebra.bot_eq_top_iff_finrank_eq_one`,
`isField_of_universallyClosed`,
`finite_appTop_of_universallyClosed`,
`IsStableUnderBaseChange @GeometricallyIrreducible`). The one
substantive gap is step (e): flat base change of `Γ` for a
proper scheme over a field
(`Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤)`; Stacks Tag 02KH).

**Recommended iter-148 prover lane**: land a thin in-tree
wrapper for the step (e) base-change isomorphism. The wrapper
chains `AlgebraicGeometry.IsBaseChange` namespace (Mathlib has
the general `IsBaseChange` infra in
`Mathlib.RingTheory.IsTensorProduct`) with a
`H^0`-cohomology-base-change instance for proper morphisms.
Estimated 50–150 LOC. Once the wrapper exists, the seven
catalogued substeps assemble into a sorry-free closure of
`constants_integral_over_base_field` (LOC estimate 100–200 for
the closure proper).

This is the highest-leverage iter-148 target: closing it drops
`ChartAlgebra.lean` from 2 → 1 sorry and unlocks the consumer
chain (KDM → β-core → `ext_of_diff_zero` refinement → M2.a body).

## Promising approaches needing more work

### 2. KDM forward direction
   `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`

The reverse inclusion is closed iter-147; the forward direction
is the substantive Mathlib-gap content. Two complementary
paths:

- **(p2) char-0 path** via `Differential.ContainConstants`
  (`Mathlib/RingTheory/Derivation/DifferentialRing.lean:62–70`).
  The typeclass is for a specific derivation `B → B`, not the
  universal Kähler derivation `D : B → Ω[B⁄k]`. Bridge: pick a
  basis of `Ω[B⁄k]` (free of finite rank under
  `Algebra.IsStandardSmooth`), project to a single coefficient
  to get a `B → B` derivation, and use that as the
  `Differential B` instance. Estimated 80–150 LOC for the
  bridge.

- **(p1) char-p path** via the iter-146 blueprint-writer's
  (p1.a)–(p1.d) 4-substep chain
  (`RigidityKbar.tex:2043–2058`). This is the Cartier-direction
  `ker D = B^p` for standard-smooth `B`, then
  `RingHom.iterateFrobenius_comm`, then descent through the
  chart-of-proper-curve helper (still unscaffolded). Estimated
  140–230 LOC.

Iter-148 should pick **one** of the two paths (recommendation:
char-0 first, because the typeclass bridge is well-understood
and the char-p path requires the chart-of-proper-curve helper
to also be scaffolded). A **case-split** body (`if charZero
then (p2) else (p3)`) is the eventual end state.

**Critic-flagged trigger**: a 2nd consecutive PARTIAL on KDM
without sorry-count drop would constitute CHURNING (per the
iter-147 progress-critic's K=3-5 hysteresis hook). Iter-148
should commit to a measurable sorry reduction here.

### 3. `Scheme.Over.ext_of_diff_zero` substantive refinement

The β-core sub-piece now exists as a sorry-free delegate to
KDM, but the iter-148+ refinement of `ext_of_diff_zero` to
substantively encode `df = dg` is still gated on KDM body
closure (the Step 1+2 chart-algebra (β) chain consumes KDM,
not β-core, for the actual `df = 0 ⇒ b ∈ range algebraMap`
step). The refinement is **not** an iter-148 target unless KDM
forward inclusion closes first.

## Blocked targets (do NOT re-assign without structural change)

None at iter-147 close. All 3 in-scope sorries either closed
or returned PARTIAL with documented closure paths.

## Watch hook: iter-148 escalation gate

Per the iter-147 progress-critic, escalate at iter-148 if:

- **substep (3) returns PARTIAL** citing the same flat-base-
  change-of-`Γ` obstacle as iter-147 → escalate via blueprint
  expansion on Stacks Tag 02KH OR Mathlib-idiom consult
  (`mathlib-analogist` in api-alignment mode) on
  `H^0`-cohomology base change. **Do NOT dispatch a second
  prover lane against the same wall.**

- **KDM returns PARTIAL** with the same `ContainConstants`
  bridge phrase as iter-147 → escalate via Mathlib-idiom
  consult on derivation-typeclass packaging.

- **Both iter-148 targets return PARTIAL → CHURNING verdict
  binds**. Pivot to either (a) the iter-150 over-`k̄` symmetric
  audit (which would route around `constants_integral_over_base_field`
  via `IsAlgClosed.algebraMap_bijective_of_isIntegral` on the
  base-changed scheme directly, sidestepping the flat-base-
  change wrapper); or (b) a `mathlib-analogist` cross-domain-
  inspiration dispatch to find Mathlib idioms for chart-of-
  proper-curve descent in any domain.

## Reusable proof patterns discovered

### Pattern: signature-refinement via delegate-to-named-helper

The β-core closure pattern — refine a `: True := sorry`
placeholder to a real signature whose body is a one-line
delegate to a named helper that itself carries the substantive
sorry — is the right shape when:

1. The blueprint disposition concentrates the substantive
   content at a separate named helper (the iter-146
   B.preferred disposition); and
2. The placeholder's hypotheses are exactly the standing
   premises the helper consumes internally; and
3. The helper exists by name (even if its body is sorry).

This unblocks the consumer site immediately and lets the
helper's body closure be sequenced independently. Likely
reusable for `ext_of_diff_zero` once KDM closes.

### Pattern: `RingHom.range_eq_top` goal-reduction

When the goal is `f.range = ⊤` and the natural continuation
constructs an element-wise inverse / surjectivity witness,
`rw [RingHom.range_eq_top]` exposes `Function.Surjective ⇑f`
as the next goal, which composes cleanly with Mathlib's
existing bijectivity lemmas (e.g.
`IsAlgClosed.algebraMap_bijective_of_isIntegral`).

### Pattern: substep-chain documented inline + concentrated sorry

For multi-step closure chains where most substeps have
Mathlib lemmas catalogued but one is the substantive gap:
commit the chain as in-source comments with each substep's
target Mathlib lemma named, place the residual `sorry` at
the chain's exit, and document the named Mathlib gap above
the sorry. This preserves the iter-148+ continuation point
without requiring the prover to chase every substep first.

## Strategic notes (not blockers)

- The iter-145 strategy-critic challenges on Routes A + C
  + format were all absorbed iter-147 via STRATEGY.md
  restructure. No outstanding strategic CHALLENGEs at
  iter-147 close.

- The blueprint is in `ALL CLEAN` state (per
  blueprint-reviewer-iter147); no chapter `complete: false`
  or `correct: false`. HARD GATE clears.

- The blueprint-doctor reports no structural findings
  (orphans + broken refs + empty annotations all clean).
