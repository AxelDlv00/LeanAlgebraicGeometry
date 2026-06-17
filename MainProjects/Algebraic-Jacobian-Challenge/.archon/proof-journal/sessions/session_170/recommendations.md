# Recommendations for iter-171 plan agent

## TL;DR

**Re-dispatch the iter-170 Lane A verbatim in iter-171.** The iter-170 prover lane died at session start to `API Error: 500 Internal server error` (Anthropic API outage) after 251s / 22 turns, with **zero file edits**. The plan was sound, the objectives were precise, the analogies (`tensoraway-instance.md` + `gmscaling-deep.md`) are on disk, the recipe was probe-verified at the snippet level. iter-170 was a lost iter to external infrastructure, not a route falsification.

## HIGH — re-dispatch Lane A verbatim, do NOT fire the option-(a) reversal trigger

The iter-170 plan committed:

> **Reversal signal**: if iter-170's body-first attempt fails to produce a `Scheme.Cover.glueMorphisms` skeleton (i.e. the prover cannot even WRITE the body shape with internal sorries — not just fails to close them axiom-clean), the route reverses to escalation option (a) Mathlib upstream PR in iter-171.

**The trigger DID NOT FIRE.** "Cannot write the body shape" means a falsifying test produced a negative result. An API-500 outage means the test never ran. iter-171 must **re-attempt** the body-first test, not skip to escalation. Concretely:

- iter-171 PRIMARY = same as iter-170 PRIMARY: land the 3-line `Algebra.compHom` instance + Step A chart ring maps + `gmScalingP1` body skeleton via `Scheme.Cover.glueMorphisms` (≤3 named top-level internal sorries acceptable for PARTIAL).
- iter-171 SECONDARY = same as iter-170 SECONDARY: `aux_left` via cancel-surjective.
- The 3-iter horizon committed in iter-170 plan (iter-170 → iter-172) **shifts by one iter** to iter-171 → iter-173.
- The iter-172 milestone in the iter-170 decomposition table (cocycle + irrelevant-ideal-condition + `collapse_at_zero`) moves to iter-173; the iter-173 milestone (`gm_grpObj` + Lane B `iotaGm_isDominant`) moves to iter-174.

If iter-171 PARTIAL-no-body-shape after a clean run (no API error), THEN the reversal fires and iter-172 opens option (a). The reversal predicate must be **falsified**, not **untested**.

## HIGH — when re-dispatching, prefer in-file landing over `lean_run_code` re-verification

The iter-170 prover spent 251s of its 22-turn budget on two `lean_run_code` probes that surfaced a `noncomputable` propagation issue — a snippet-only artifact. The in-file `projectiveLineBarGrading` at L78 of `Genus0BaseObjects.lean` already sits inside `noncomputable section` (L65), so the `Algebra.compHom` instance lands directly:

```lean
-- after `projectiveLineBarGrading_gradedRing` (L82–84):
/-- `kbar`-algebra structure on `HomogeneousLocalization.Away 𝒜 f` via the
composition `kbar →+* ↥(𝒜 0) →+* Away 𝒜 f`. -/
instance algebraKbarAway (kbar : Type u) [Field kbar]
    (f : MvPolynomial (Fin 2) kbar) :
    Algebra kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f) :=
  Algebra.compHom _ (algebraMap kbar ((projectiveLineBarGrading kbar) 0))
```

(Note: no per-decl `noncomputable` keyword required — the section L65 covers it.)

Recommend the iter-171 plan/objectives explicitly tell the prover: **skip standalone `lean_run_code` verification of the recipe**; land the instance, then verify via `lake build` + `lean_diagnostic_messages` on the file.

## HIGH — preserve the iter-170 plan's 5-task TODO scaffold

The iter-170 prover left a clean TODO scaffold (5 tasks: instance, chart ring maps, body skeleton, aux_left SECONDARY, build verify). iter-171 plan/objectives can paste this verbatim. The decomposition is already correct; re-doing the decomposition wastes plan-agent budget.

## MEDIUM — STRATEGY.md `Iters left` for genus-0 row

The iter-170 plan revised genus-0 to `Iters left ~3-5`. The lost iter shifts this to `Iters left ~3-5` still (no progress was made AND no progress was disproven). Strategy-critic may flag that the estimate is unchanged after 1 iter of zero advance — this is honest because the iter was lost to infrastructure, not to the route. Recommend a single-line `% NOTE` on the STRATEGY.md row 2: "iter-170 lost to API-500; estimate carries forward unchanged."

## MEDIUM — iter-171 plan agent should NOT re-dispatch the same critics

The iter-170 plan-phase critics (progress-critic `routec170`, strategy-critic `routefork170`, mathlib-analogist `tensoraway`) all returned verdicts that **still apply** in iter-171 — the route + decomposition + 3-line bridge are all unchanged. Re-dispatching would produce identical reports.

- **progress-critic**: dispatcher_notes skip-condition met ("the prior iter ran no prover phase that produced new trajectory data" — the prover lane died with zero edits, no new signals). Skip with rationale.
- **strategy-critic**: STRATEGY.md SHA is unchanged since iter-170 (no `.lean` work, no strategy edits). Skip-condition met. Skip with rationale.
- **mathlib-analogist**: the `tensoraway` recipe is on disk at `analogies/tensoraway-instance.md`; do not re-dispatch.

The iter-171 plan should be a thin re-dispatch of iter-170's lane with one `% NOTE` on the API-500 shift. Allocate budget to the prover, not to critics.

## MEDIUM — knowledge base entry: `lean_run_code` + `noncomputable section`

Add to PROJECT_STATUS.md Knowledge Base (Proof Patterns): standalone `lean_run_code` snippets that mirror noncomputable-section-wrapped declarations from the actual file MUST annotate `noncomputable abbrev` / `noncomputable instance` per-decl. The section blanket does NOT translate. Sub-test recipes inside an in-file context (`lean_multi_attempt` at a specific source position) avoid this trap.

## DO-NOT-RETRY targets (unchanged from iter-170)

- AVR `iotaGm_isDominant` L934 — gated on Lane A's `gmScalingP1` body landing.
- AVR `genusZero_curve_iso_P1` L1141 — RR bridge, deferred upstream Mathlib.
- G0BO `projectiveLineBar_geomIrred` L177, `projectiveLineBar_smoothOfRelDim` L184, `gm_geomIrred` L791, `projGm_isReduced` L823 — genuine Mathlib gaps per iter-169 lean-auditor.
- G0BO `gm_grpObj` L593 — 3rd-iter deferral, schedule iter-173+ post-body-landing.

## Closest-to-completion targets (re-prioritised for iter-171)

1. **`algebraKbarAway` instance** (~3 LOC, recipe verified): trivial in-file landing.
2. **`gmScalingP1_chart{0,1}_ringMap`** (~10–20 LOC each, recipe in `analogies/gmscaling-deep.md` Q3): mechanical `MvPolynomial.eval₂RingHom` build.
3. **`gmScalingP1` body skeleton via `Scheme.Cover.glueMorphisms`** (~60–120 LOC, internal sorries OK per the iter-170 PARTIAL criterion).
4. **`aux_left` SECONDARY** (~30–60 LOC, recipe in `analogies/gmscaling-deep.md` Q2).

## Promising approaches needing more work

None new — the iter-170 plan's approach is the one iter-171 should re-attempt.

## Reusable proof patterns discovered

- **`lean_run_code` snippet noncomputable propagation gotcha** (see MEDIUM above).
