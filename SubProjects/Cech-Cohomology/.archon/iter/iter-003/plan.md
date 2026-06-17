# Iter-003 plan — P4 unblocked, scaffolded, and dispatched

## Context

iter-002 closed P1 (`pushPullMap_comp`) and P2 (`CechNerve`); 3→2 sorries. Remaining:
`CechAcyclic.affine` (P3) and the protected `cech_computes_higherDirectImage` (P5). Frontier
nodes spanned `Cohomology_AcyclicResolution.tex` (P4) and `Cohomology_CechHigherDirectImage.tex`.
Carry-forward must-fix: the P4 `lem:homology_long_exact_sequence` anchor (unfaithful `\mathlibok`).

## What I did (this plan phase)

1. Verified the P4 Mathlib infrastructure myself by grepping the Mathlib source (existence
   checks only): `isoRightDerivedObj`, `rightDerivedZeroIsoSelf`,
   `isZero_rightDerived_obj_injective_succ`, `homology_exact₁/₂/₃`, `δ` all **present**; any
   horseshoe (`InjectiveResolution.ofShortExact`) and any derived-functor LES **absent**.
2. **Round 1 (read-only):** blueprint-reviewer (whole) + mathlib-analogist (P4 route, api-alignment).
3. **Round 2 (writers, different files):** fixed the P4 anchor; rewrote the misleading
   `lem:push_pull_comp` body + added `def:push_pull_functor`/`def:cech_nerve_cosimplicial`.
4. **Round 3:** blueprint-clean (both) → scoped re-review → **P4 HARD GATE CLEARS**.
5. **Round 4:** lean-scaffolder created `AcyclicResolution.lean` (compiles; `IsRightAcyclic` +
   injective instance no-sorry; three hard targets in the strategy block; wired into build).
6. Set the single ready prover lane (P4, `[prover-mode: mathlib-build]`); moved P1/P2 to
   STRATEGY `## Completed`; recorded the P3 statement gap.

## Decisions made

### D1 — Make P4 the single active lane this iter; defer P3.
- **Why**: P4 is self-contained homological algebra, fully blueprinted, infra verified — the
  cleanest path to forward progress. P3 surfaced a genuine soundness issue this iter
  (standard-cover blueprint vs general-cover Lean signature) that must be resolved (signature
  refactor + blueprint alignment) before its effort-breaker can run; doing that properly
  competes with the P4 scaffold+build for budget. One strong lane beats two rushed ones.
- **Not under-parallelization**: P3 is genuinely gated (statement gap), P5 needs P3+P4, and P4
  is a single bottom-up dependency chain in one new file (not splittable across provers).
- **Reversal signal**: if the mathlib-build prover stalls on the horseshoe with a clean
  decomposition AND the P3 statement gap is resolved cheaply next iter, run P3 in parallel then.

### D2 — Build the P4 SES→LES via the horseshoe `InjectiveResolution.ofShortExact` (route re-confirmed).
- **Why**: mathlib-analogist independently confirmed (api-alignment, high-stakes,
  NEEDS_MATHLIB_GAP_FILL) that the horseshoe is the cheapest, necessary gap. The two
  alternatives are strictly worse: the Ext LES is derived-Hom-specific (cannot see a general
  `G = f_*`); the derived-category triangulated route needs the `rightDerivedFunctorPlus`
  bridge, an **open Mathlib TODO** (RightDerived.lean:40–47) that dwarfs the horseshoe; a snake
  on a single resolution only handles injective-middle SESs, not the acyclic-middle cosyzygy SESs.
- **LOC/risk**: horseshoe ≈ self-contained; dominant Lean risk is the twisted differential `τ`
  (dependent ℕ-recursion via `Injective.factorThru`), to be built as a standalone lemma chain
  modeled on `InjectiveResolution.ofCocomplex`. Rationale persisted: `analogies/p4-derived-les.md`.
- **Reversal signal**: if the horseshoe `τ`-recursion proves a multi-iter wall in Lean,
  reconsider whether the injective-middle special case + a bespoke cokernel argument can cover
  enough of the dimension shift for the project's degree range (analogist's warm-up note).

### D3 — `IsRightAcyclic` as a `class … : Prop` matching `isZero_…_succ`'s quantifier.
- mathlib-analogist (PROCEED, identical to Mathlib idiom): `class IsRightAcyclic (G) (J) : Prop`
  = `∀ k, IsZero ((G.rightDerived (k+1)).obj J)`, with a free `[Injective J]` instance from
  `isZero_rightDerived_obj_injective_succ`. Landed by the scaffolder (no sorry).

## Disproof / soundness pass
- P3 statement: the blueprint-reviewer found the real soundness issue (standard-cover proof vs
  general-cover Lean signature) — recorded, P3 deferred until resolved. No prover budget spent on
  the mismatched statement.
- P4 targets: each has a detailed, source-cited blueprint proof (Stacks 015C/D/E); the route was
  re-validated against Mathlib this iter. No disproof concern.

## Subagent skips

- strategy-critic: STRATEGY.md changed this iter only for bookkeeping (move completed P1/P2 to
  `## Completed`; P4 NEXT→ACTIVE) and to record the P3 statement gap as an open question — NO
  route swap or decomposition change. The active route (Route A / horseshoe) was independently
  RE-VALIDATED this iter by mathlib-analogist (NEEDS_MATHLIB_GAP_FILL; both alternatives
  rejected), and iter-002's strategy-critic CHALLENGEs remain addressed. A fresh dispatch would
  be hollow (the failure mode the descriptor warns against).
- progress-critic: the only route with prover trajectory (P1/P2) COMPLETED in iter-002 (its
  sorries went to zero); the remaining routes (P3/P4/P5) have ZERO prover iterations, so there is
  no trajectory to extrapolate and no CHURNING/STUCK route to catch. Matches the documented skip
  condition ("the only active route just completed in the prior iter").
