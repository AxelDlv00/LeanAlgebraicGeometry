# Progress Critic Directive

## Slug
rigidity-chain

## Iter
162

## Active routes / files under review

### Route: AlgebraicJacobian/AbelianVarietyRigidity.lean — the Rigidity-Lemma chain (route (c), genus-0 keystone)

- **Started at iter**: 157 (file created; chain decomposition began)
- **Iters audited**: 158 → 161

#### Sorry counts per iter (chain-internal residual = `sorry`s reachable inside the rigidity_lemma chain, NOT counting the 3 deferred cube/RR scaffolds)
- iter-157: chain landed but UNSOUND (laundering; later repaired)
- iter-158: 2 (hfib pullback-fibre fact + bridge-2 agreement equation)
- iter-159: 1 (hfib CLOSED axiom-clean; bridge 2 extracted into named helper `rigidity_eqOn_saturated_open_to_affine`)
- iter-160: 2 (bridge 2 split: Step-2 proven, but a `JacobsonSpace U` instance sorry + a Step-1 sorry surfaced via a signature gap)
- iter-161: 1 (signature gap CLOSED by refactor; `JacobsonSpace U` instance CLOSED; deep algebraic core `eq_comp_of_isAffine_of_properIntegral` PROVEN axiom-clean; lone residual = Step-1 geometric assembly `rigidity_eqAt_closedPoint_of_proper_into_affine`)
- (Global project sorry_count has stayed 7 across this window: 1 chain residual + 3 deferred AVR scaffolds + 2 Jacobian gated + 1 RigidityKbar fallback. The signal is the chain-internal residual DEPTH, above.)

#### Helpers added (and their fate) per iter
- iter-158: `snd_left_isClosedMap` (bridge 1, closed map) — PROVEN axiom-clean
- iter-159: extracted `rigidity_eqOn_saturated_open_to_affine` (bridge 2 named); `hfib` closed in-body
- iter-160: `morphism_eq_of_eqAt_closedPoints` (Step 2, dense-closed-points⟹hom-ext) — PROVEN axiom-clean
- iter-161: `eq_comp_of_isAffine_of_properIntegral` (Step-1 algebraic core, "proper integral k̄-scheme into affine is constant on k̄-points") — PROVEN axiom-clean; `JacobsonSpace U` instance discharged
- Pattern: each iter PROVED or CLOSED a named, on-disk, axiom-clean, load-bearing piece — not accumulating unproven scaffolding.

#### Prover statuses per iter
- iter-158: PARTIAL — bridge 1 built, 2 internal sorries left
- iter-159: PARTIAL (forward) — hfib closed axiom-clean, bridge 2 isolated into named helper
- iter-160: PARTIAL — Step 2 proven axiom-clean, signature gap surfaced + honestly isolated
- iter-161: PARTIAL — lane (a) JacobsonSpace closed; Step-1 algebraic core proven axiom-clean; Step-1 reduced to one isolated geometric residual with an exact recipe

#### Recurring blocker phrases
- "relative Stein / `f_*O=O` is a confirmed Mathlib gap" — appears iter-159/160/161 reports, but as a route DELIBERATELY AVOIDED (the cohomology-free route B exists to sidestep it), NOT as a wall the prover keeps hitting. Not a stall blocker.
- New this iter (iter-161 prover report): `IsIntegral X.left` (retract of integral product) — flagged as "NOT auto-derivable; the natural next named top-level helper, ~0.3–0.5 iter sub-build." Fresh, isolated, not recurring.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim from the genus-0 row, just re-estimated this iter): "re-est ~18–32 (was ~10–18; OVER_BUDGET confirmed iter-162) — cube ~8–15 + genus-0⟹ℙ¹ RR ~5–10, both zero-Mathlib, dominate; chain ≈12 elapsed"
- **Elapsed iters in current phase**: the rigidity_lemma CHAIN specifically: iter-157 → 161 = ~5 iters on the chain; the broader genus-0 phase (route (c)) started iter-157.
- **Phase started at iter**: iter-157 (AbelianVarietyRigidity file + route (c) commitment).

#### Planner's current proposal for this iter
Fire ONE prover lane at `AbelianVarietyRigidity.lean` to CLOSE the lone Step-1 residual `rigidity_eqAt_closedPoint_of_proper_into_affine`: build the named helper `IsIntegral X.left` (retract of integral product) + the section/corestriction/two-point-identity assembly that feeds the already-proven `eq_comp_of_isAffine_of_properIntegral`. If it does not fully close, PARTIAL (a clean named sub-lemma) is acceptable. SEPARATELY, the planner is doing the binding OVER_BUDGET re-estimate (done in STRATEGY.md this iter) and asks: given the chain is one residual from closing, is "finish the chain this iter, then begin the theorem-of-the-cube blueprint next iter" the right sequencing, or should the cube blueprint kickoff begin THIS iter in parallel?

## PROGRESS.md proposal (this iter)

- **File count**: 1
- **Files**: AbelianVarietyRigidity.lean
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
- Route A (positiveGenusWitness / FGA representability) — not assigned this iter.
- Jacobian.lean / RigidityKbar.lean — gated, not assigned.
- The 3 deferred cube/RR scaffolds inside AVR.lean — not assigned (blocked on the cube + Riemann–Roch, unstarted).
