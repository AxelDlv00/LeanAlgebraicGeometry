# Iter-002 plan — blueprint correctness fixes + P1 gate cleared + first prover lane

## Context

Second iter. iter-001 pivoted to Route A (acyclic resolution) and rewrote the blueprint but
ran no prover phase and never re-validated the rewritten strategy/blueprint. Start state: 3
inline sorries (`CechNerve` L91, `CechAcyclic.affine` L544, `cech_computes_higherDirectImage`
L581); leandag frontier = 4 ready nodes; doctor flagged `Cohomology_AcyclicResolution.tex`
covers a not-yet-existing `AcyclicResolution.lean`.

## What I did

1. Read state. Pre-flagged a likely P4 blueprint↔route mismatch (the AcyclicResolution proofs
   were written via a `rightDerived`-level δ-functor LES that Mathlib does not provide, while
   the chosen Lean route is comparison-of-resolutions).
2. Dispatched both mandatory read-only critics in parallel: **blueprint-reviewer** (whole
   blueprint, HARD GATE) and **strategy-critic** (Route A never re-validated post-rewrite).
   Both independently confirmed the P4 mismatch.
3. Verified the relevant Mathlib infra myself (existence checks only): the complex-level
   homology LES `ShortComplex.ShortExact.homology_exact₃` / `.δ` EXISTS
   (`Mathlib.Algebra.Homology.HomologySequence`); no horseshoe-for-injective-resolutions found.
4. Updated **STRATEGY.md** for both strategy-critic CHALLENGEs (P4 honest reframing, P5 re-estimate).
5. Dispatched two **blueprint-writers** in parallel (different chapters): AcyclicResolution
   (rewrite P4 proofs onto the comparison-of-resolutions kernel; isolate the LES fragment + the
   to-build horseshoe) and CechHigherDirectImage (scoped P3/P5 citation+wire-up fixes; retrieve
   Stacks cohomology.tex). Then **blueprint-clean** on both.
6. **Fast-path scoped re-review** → P1 HARD GATE clears for `Cohomology_CechHigherDirectImage.tex`.
7. **Validated the P1 frontier node before dispatch** (per plan-prompt mandate): found the
   mate lemmas already PROVED and `pushPullMap_comp` ABSENT as a Lean decl. Reclassified the P1
   objective from "fill sorry" to "build-and-prove". Confirmed the recipe file's real path
   (`.archon/analogies/pushpull-functoriality.md`, not the project-root `analogies/`).
8. Wrote the single ready prover lane (P1) to PROGRESS.md.

## Decisions made

### D1 — P4 reframed honestly; the LES is not avoidable, it is buildable.
Both critics confirmed the comparison-of-resolutions route still needs an SES-acyclicity-
propagation (LES) fragment for `rightDerived` — the same kernel the "fallback" needs. So the
iter-001 "NOT a hand-built LES" framing was dropped. The kernel is buildable from Mathlib's
complex-level homology sequence (`homology_exact₁/₂/₃` + `.δ`, verified present) + a to-build
horseshoe lift of a SES to injective resolutions (`InjectiveResolution.ofShortExact`, absent —
the one genuinely-novel P4 construction, now an explicit blueprint block). STRATEGY P4 row +
Open-questions + Mathlib-gaps updated; blueprint rewritten accordingly. Reversal signal: if the
horseshoe proves a wall in Lean, reconsider proving the kernel directly via a single fixed
injective resolution + cone exactness, avoiding the full horseshoe.

### D2 — Pursue the same-iter fast-path to unblock the P1 lane THIS iter.
The CechHigherDirectImage `correct: partial` was driven only by P3/P5 nodes, not the P1
sub-graph. Rather than defer P1 a whole iter, I fixed those two nodes (genuinely-needed work,
not throwaway) + clean + scoped re-review → gate cleared → P1 dispatched now. The first real
proof progress of the project lands this iter instead of iter-003.

### D3 — Single prover lane this iter (P1 only); P3/P4/P5 are genuinely blocked, NOT under-parallelized.
P4: file unscaffolded + chapter `correct: partial` on its new anchor (must-fix below). P3:
needs from-scratch localisation infra + decomposition (effort-breaker) before any prover — a
blind "prove" dispatch would waste the iter. P5: needs P2–P4. So one honest ready lane. The
parallelism directive is served by the iter-003 file-split plan (push–pull + P3 into own files)
once P1 closes.

### D4 — Defer the P4 anchor must-fix + AcyclicResolution scaffolding to iter-003.
The scoped re-review found the new `lem:homology_long_exact_sequence` `\mathlibok` anchor names
only `homology_exact₃` (one exactness position) but states the full LES — unfaithful, must-fix.
It is OFF this iter's critical path (P4 not dispatched). Fixing it needs a writer (`\mathlibok`
is the writer's/review's marker, not the plan agent's to edit) + a re-review, ~15 min for a node
not proved this iter. Deferred with a precise recipe in PROGRESS.md (name all three
`homology_exact₁/₂/₃`). iter-003: fix anchor → re-review → scaffold `AcyclicResolution.lean` →
mathlib-build the horseshoe + kernel.

## Rebuttals to subagent findings
None withheld. Every must-fix acted on or explicitly deferred with rationale (D4). strategy-critic
both CHALLENGEs → STRATEGY.md updated (D1 + P5 re-estimate). blueprint-reviewer P4 must-fix →
chapter rewritten (D1); P1-gate path → fast-path (D2); P4-anchor must-fix → deferred off-critical-
path (D4). The two strategy-critic "minor" alternatives (build the LES fragment from
HomologySequence.lean; check Mathlib `Sites/SheafCohomology/Cech` before hand-rolling) — the
first is now the adopted P4 plan; the second I note for iter-003 P2/P3 (likely a genuine
topos-vs-relative mismatch, worth one check, not a route change).

## Subagent skips
- progress-critic: prior iter (iter-001) ran no prover phase — no trajectory data to assess.
  Skip condition met per its dispatcher_notes (first of the ANY-of conditions).

## Carry-forward for iter-003
- Fix the `lem:homology_long_exact_sequence` anchor (name `homology_exact₁/₂/₃`) + re-review →
  scaffold `AcyclicResolution.lean` → `[prover-mode: mathlib-build]` horseshoe + kernel.
- Add `% SOURCE QUOTE PROOF:` to `lem:higher_direct_image_presheaf` (stacks-cohomology.tex L605–616).
- If `pushPullMap_comp` closed: blueprint entries for the 4 `lean_aux` push–pull helpers;
  file-split refactor (push–pull + P3 → own files) for parallel P3/P4 lanes.
- Decompose P3 (`CechAcyclic.affine`) with effort-breaker before any P3 prover.
