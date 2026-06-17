# Iter-056 plan — caught the change-of-scheme Serre WALL; corrected Route 2 to a sound no-gap split; dispatched both lanes

## Note on resumption
This plan phase was resumed after an interruption. A prior attempt had already dispatched the three
read-only critics (progress-critic `iter056`, strategy-critic `iter056`, blueprint-reviewer `iter056`)
and the refactor `fix-csi-build` (which made `CechSectionIdentification.lean` compile → project build
GREEN). I picked up from those reports and completed the phase.

## Entering state (verified)
- iter-055 ran both lanes PARTIAL + a structural round. Lane 1's shared Sub-brick A file
  `CechSectionIdentification.lean` (6 stubs) shipped RED (namespace/`∏ᶜ` typos) but was fixed this iter
  by refactor `fix-csi-build`; `lake build` GREEN (8335 jobs).
- Inline sorry: 6 (CSI Sub-brick A stubs) + 2 frozen (P5b protected, dead `affine`) + 1 (`hSec`) +
  2 (OpenImmersionPushforward `_acyclic`/`_comp`).

## What I did this phase
1. Processed both iter-055 prover results (CechAugmentedResolution +1 glue; OpenImmersionPushforward +5
   corepresentability helpers, `_acyclic` leaf reshaped geometry-free) → cleared the two prover result files.
2. Read the three already-run iter056 critics + the refactor report.
3. **Dispatched blueprint-writer `openimm-transport` (round 1)** to fix the blueprint-reviewer must-fix
   (the change-of-scheme Serre transport had no Lean anchor) — concurrently with **mathlib-analogist
   `change-of-scheme-cohomology`** to de-risk that transport.
4. **The analogist returned a WALL finding** (see Decision below). **Re-dispatched blueprint-writer
   `openimm-correct` (round 2)** to REPLACE the round-1 (wall) route with the sound two-need split.
5. blueprint-clean `iter056` (purity) → scoped blueprint-reviewer `iter056-recheck` →
   `Cohomology_CechHigherDirectImage.tex` **complete:true / correct:true, 0 must-fix**; HARD GATE CLEARS
   for both `CechSectionIdentification.lean` and `AffineSerreVanishing.lean` (fast path).
6. Updated STRATEGY (compressed the two drifted active-table cells + trimmed "ACTIVE this iter" per the
   strategy-critic format finding; rewrote the consumer row/route to the two-need split; widened estimates
   ~2–3 → ~3–5 per both critics' OVER_BUDGET/optimistic flags). Updated PROGRESS (2 lanes) + this sidecar.

## Decision made

### D1 — Route 2 (open-immersion acyclicity): adopt the analogist's SOUND two-need split; REJECT both the naive isoSpec transport AND the strategy-critic's Q2 avoidance.
- **Chosen:** general-affine-open Serre vanishing via **Need#2** (enlarge `affineCoverSystem` basis B from
  `{D f}` to all affine opens — `cech_eq_cohomology_of_basis` gives the vanishing with NO restriction
  functor; only `surj_of_vanishing`/`standard_cover_cofinal` need `isCompact_basicOpen→IsAffineOpen.isCompact`,
  ~40–80 LOC) + **Need#1** (whole-scheme `U≅SpecΓU` Ext transport via `Scheme.isoSpec`+`Ext.mapExactFunctor`,
  ~60–120 LOC). This iter's prover lane = Need#2 (cheapest, no new gap, foundational).
- **Why:** mathlib-analogist `change-of-scheme-cohomology` proved the naive route the blueprint had been
  carrying (transport `Ext^q(jShriekOU(j⁻¹V),H)` along the OPEN-SUBSCHEME iso `j⁻¹V≅SpecΓ(j⁻¹V)`) FORCES
  `U.Modules→V.Modules` restriction, i.e. restriction-preserves-injectives — the 200–500 LOC `j_!` gap the
  project deliberately pivoted away from in iter-026 (Form B). `V↪U` is an open immersion, not an iso, so
  there is no `U.Modules≌V.Modules`. The whole-affine `U≅SpecΓU` IS a genuine equivalence but sends the
  proper open `V⊆U` to a general (non-distinguished) affine open of `SpecΓU` — so the ⊤-only
  `affine_serre_vanishing` still doesn't apply; the general-affine-open vanishing is genuinely unavoidable.
  The sound discharge stays AMBIENT (Need#2) — no restriction functor anywhere.
- **LOC/risk:** ~100–200 LOC total, low–medium, NO new Mathlib gap. Reversal signal: if Need#2's
  basis enlargement breaks the existing ⊤-case `affine_serre_vanishing` or `affineCoverSystem` consumers
  (it shouldn't — ⊤ is an affine open, strict generalization), revert to a separate
  `affineCoverSystemGeneral` rather than mutating the existing one.

### Rebuttals (required by the critics' guidance)
- **strategy-critic Q2 (CHALLENGE, "general-affine-open vanishing is avoidable via the affine-morphism
  reduction") — REBUTTED.** The analogist's fresh reading proves it is NOT avoidable: boundary-straddling
  affine opens `W⊆X` force `j⁻¹W` to be a general (non-distinguished) affine open; the affine-morphism
  reduction still lands on a general affine open, not `⊤`. The cheap discharge is not "avoid the
  generalization" but "do the generalization AMBIENT via basis enlargement" (no restriction, no new gap).
  Recorded; strategy-critic's spirit (don't build heavy restriction infra) is honored — we build ~40–80 LOC
  of basis enlargement, not the 200–500 LOC `j_!` route.
- **progress-critic Route 2 (CHURNING; corrective = "blueprint-writer + effort-breaker on the wall
  THIS iter") — addressed by a STRONGER move.** I dispatched blueprint-writer (route correction) +
  mathlib-analogist (which both de-risked AND reframed the wall). I did NOT dispatch effort-breaker: it
  would have decomposed the OLD (wall) framing, which is now deleted. The analogist's reframe collapses the
  "wall" into two bounded no-gap needs; dispatching a prover on the cheapest (Need#2) this iter is the
  concrete corrective. Recorded as the rebuttal to the effort-breaker recommendation specifically.
- **progress-critic Route 1 (CHURNING; corrective = prover EXECUTION on the stubs, min close Stub3+Stub1) —
  adopted verbatim.** Lane 1 dispatches the prover on the now-compiling Sub-brick A stubs; min-success
  Stub3+Stub1 recorded in the objective. No further structural round.

## Subagent log (this phase + the resumed-from prior attempt)
- progress-critic `iter056` (prior) — both routes CHURNING; correctives above.
- strategy-critic `iter056` (prior) — SOUND + Q2 CHALLENGE (rebutted) + format DRIFTED (fixed).
- blueprint-reviewer `iter056` (prior) — chapter complete:partial, 1 must-fix (change-of-scheme transport).
- refactor `fix-csi-build` (prior) — fixed CSI build; project GREEN.
- mathlib-analogist `change-of-scheme-cohomology` (this phase) — **WALL finding**; the pivotal input.
- blueprint-writer `openimm-transport` (round 1) → superseded by `openimm-correct` (round 2).
- blueprint-clean `iter056`; blueprint-reviewer `iter056-recheck` → **gate CLEARS both lanes**.

## Subagent skips
- strategy-auditor / dag-walker / effort-breaker / lean-scaffolder: not needed. The analogist already did
  the deep reference-grounded reduction; effort-breaker would decompose a deleted framing; the two TODO
  targets are small and fully recipe-backed in the blueprint + `analogies/change-of-scheme-cohomology.md`,
  so a scaffolder adds little over the rich PROGRESS recipe.
