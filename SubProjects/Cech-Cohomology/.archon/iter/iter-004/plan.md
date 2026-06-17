# Iter-004 plan — P4 lane re-dispatched (a mechanical noop, not a strategy iter)

## Context

iter-003 fully prepared the P4 lane (abstract acyclic-resolution comparison, Stacks 015E):
- `Cohomology_AcyclicResolution.tex` cleared the HARD GATE (scoped re-review: complete+correct,
  anchor `lem:homology_long_exact_sequence` fixed to name all four `homology_exact₁/₂/₃`+`δ`).
- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` scaffolded and compiling
  (`Functor.IsRightAcyclic` class + injective instance, no sorry; three targets documented).
- Route re-confirmed by mathlib-analogist (horseshoe = cheapest necessary gap).
- The single ready lane (P4, `[prover-mode: mathlib-build]`) was written to PROGRESS.md.

## What actually happened in iter-003's prover phase

**Nothing — the lane never launched.** `logs/iter-003/meta.json`:
`planValidate.status = "failed_all_noop"`, `objectivesProposed: 1`, `objectivesDispatched: 0`,
`objectivesNoop: ["AlgebraicJacobian/Cohomology/AcyclicResolution.lean"]`.

Root cause (confirmed by reading `commands/loop/sorry_count.py`): `filter_noop_objectives`
drops any objective file that *exists on disk with zero open sorries*, UNLESS the objective
text matches `_SCAFFOLD_RE` (`scaffold | skeleton | leave bodies as | declarations? for |
does not (yet) exist | stub out | add the import`). The iter-003 objective said *"Build the
three remaining blueprint targets"* — no exempt keyword — so the zero-sorry file was treated as
already-done and dropped. A `mathlib-build` dispatch legitimately targets a zero-sorry file (it
adds *new* declarations), but the filter can't tell that from the verb "Build" alone.

So the entire iter-003→004 gap is a phrasing/tooling mismatch, not a mathematical or strategic
problem. The prepared work is sound and unchanged.

## Decision made

### D1 — Re-dispatch P4 unchanged, with corrected build/scaffold phrasing. Single lane.
- **What**: PROGRESS.md `## Current Objectives` now reads *"Scaffold and build the P4 …
  comparison theorem … The three target declarations below do not yet exist as Lean
  declarations — create each one and prove it; this is a build/scaffold dispatch."* This matches
  `_SCAFFOLD_RE` on both `scaffold` and `do not yet exist`, so plan-validate will dispatch it,
  and it is *truthful* (the three targets genuinely are not yet declarations; `mathlib-build`
  creates + proves them bottom-up).
- **Why single lane**: P4 is the rate-limiter and is a single bottom-up dependency chain in one
  file (horseshoe → dimension-shift → staircase), not splittable across provers (established
  iter-003 D1). It has now lost a full iter to a mechanical noop; getting it to actually run is
  the highest-value action available.
- **Cheapest reversal signal**: none needed — this is a re-issue of validated work. The route's
  own reversal signals (horseshoe `τ`-recursion a multi-iter wall ⇒ reconsider injective-middle
  special case) remain as recorded in STRATEGY.md / iter-003 D2.

### D2 — Do NOT force a second parallel lane this iter (parallelism standing directive considered).
- The standing directive pushes parallelism via file-splitting. I checked the live frontier (5
  ready nodes) against reality:
  - `lem:injective_resolution_of_ses`, `lem:acyclic_dimension_shift` → the P4 lane (same file,
    same chain).
  - `lem:cech_to_cohomology_on_basis` (`cech_eq_cohomology_of_basis`),
    `lem:cech_augmented_resolution` (`cechAugmented_exact`),
    `lem:higher_direct_image_presheaf` (`higherDirectImage_isSheafify_presheafCohomology`) →
    **no Lean declaration exists** (verified by grep); they are P5 geometric-infra scaffold
    targets (Serre vanishing / Čech-on-basis), hard to-build and off this iter's critical path.
  - The only real sorries are `CechAcyclic.affine` (P3 — blocked by the live standard-cover
    statement gap) and the protected `cech_computes_higherDirectImage` (P5 — needs P3+P4).
- Conclusion: there is **no second gate-cleared, statement-sound, ready lane.** Forcing one
  (rushed scaffold of hard geometric infra, or a P3 lane that is statement-gap-blocked) would be
  exactly the low-value churn the progress-critic exists to prevent. Honest serialization is the
  correct call; recorded in PROGRESS.md `## Current Objectives` closing paragraph.

### D3 — P3 statement-gap decision: NARROW the Lean signature to standard covers (decision made, refactor teed up — NOT executed this iter).
- The blueprint `lem:cech_acyclic_affine` already proves the **standard-cover** case
  (`U = ⋃ D(f_i)`); the mismatch is purely that `CechAcyclic.affine`'s Lean signature takes a
  general `X.OpenCover`. So the fix is a **Lean-only signature narrowing** — the blueprint needs
  no change. `CechAcyclic.affine` is NOT protected, and the iter-003 reviewer confirmed the sole
  downstream consumer (`lem:cech_augmented_resolution`) only ever applies it to standard covers,
  so narrowing is downstream-safe.
- **Why not execute the refactor this iter**: the narrowing needs a concrete "standard affine
  cover" representation (what type replaces `(𝒰 : X.OpenCover)` — a cover by basic opens `D(fᵢ)`
  with the `fᵢ` generating the unit ideal). That is a real design choice deserving a focused
  mathlib-analogist check + refactor, and doing it well competes with giving P4 a clean launch
  after it already lost an iter. Teed up as the first action once the P4 horseshoe is underway;
  it converts P3 into a genuine parallel lane (and unlocks the deferred file-split).

## Subagent skips

- strategy-critic: STRATEGY.md is unchanged since iter-003 (no prover ran; no edit this iter),
  the active route (Route A / horseshoe) is unchanged and was independently re-validated by
  mathlib-analogist in iter-003, and iter-002's strategy-critic verdict was SOUND with its
  CHALLENGEs addressed and no live challenge. A fresh dispatch would be hollow.
- progress-critic: the prior iter (iter-003) ran NO prover phase — `plan-validate` failed
  all-noop, 0 objectives dispatched (`logs/iter-003/meta.json`). Documented skip condition: "the
  prior iter ran no prover phase … there is no new trajectory data to assess." Exactly this case.
- blueprint-reviewer: no chapter under `blueprint/src/chapters/` was edited since the prior
  dispatch (no prover/writer ran in iter-004); the prior scoped re-review cleared the HARD GATE
  (complete+correct, no must-fix) for `Cohomology_AcyclicResolution.tex`, the chapter for the
  only file under active prover work this iter (`AcyclicResolution.lean`). All skip conditions
  met. (The CechHDI chapter's still-live P3 standard-cover gap is NOT under prover work this
  iter, so it does not force a dispatch — it is tracked as a deferred decision, D3.)

## Disproof / soundness pass

No new target to disprove: P4's three targets each carry a detailed, source-cited blueprint
proof (Stacks 015C/D/E) that the iter-003 scoped re-review confirmed correct and sufficiently
detailed. The route was re-validated against Mathlib iter-003. The objective is a re-issue of
already-vetted work, so no fresh soundness pass is owed.
