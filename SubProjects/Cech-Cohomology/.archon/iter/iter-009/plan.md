# Iter-009 plan — close P4 (last 2 leaves dispatched); P5a blueprint de-spectral-sequenced in parallel

## Context entering the iter

iter-007 (the last prover iter) closed 3 of the 5 TARGET-3 leaves (the cosyzygy / applied-cohomology
layer) and declined the last 2 at a clean cut with a precise, indexing-checked recipe. iter-008 was a
deterministic DAG re-sync (no prover). So iter-009's job: process the iter-007 prover output, confirm
P4 is converging, clear the gate, and dispatch the prover to close P4 — while investing in P5a's
blueprint so it becomes a parallel lane next iter (parallelism + autonomous standing directives).

The leandag frontier injected this iter: `lem:acyclic_one_iso_coker` (P4) + three P5 nodes
(`lem:cech_to_cohomology_on_basis`, `lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`).

## Subagents dispatched (all 3 mandatory critics + 2 writers)

1. **strategy-critic** (`iter009`) → **CHALLENGE** (one must-fix). The headline is a *positive*
   verification: Route A is genuinely SS-free — the critic traced the rewrite for ALL THREE suspect
   P5 lemmas with exact Stacks line refs (basis lemma 01EO = injective-embed/dimension-shift, not an
   SS; termwise acyclicity + open-immersion pushforward reduce to affine Serre vanishing). The
   P3↔basis bridge is load-bearing and NOT circular. The one challenge: P5a is under-scoped — the
   basis lemma is treated as atomic when its general 01EO proof rests on an unenumerated
   Čech-to-derived-H¹ sub-theory, and Mathlib's site cohomology is the wrong category
   (`Sheaf J AddCommGrpCat`, not `O_X`-modules). → addressed (see Decision D3).
2. **progress-critic** (`iter009`) → **CONVERGING**. P4 residual 5→3→2 across prover iters; helpers
   have measurable named-target payoff; the two "recurring phrases" are calibration/discipline, not a
   wall; remaining 2 leaves carry precise recipes. Mild throughput slip (informational): if P4 does
   NOT close this iter, revise the estimate and consider blueprint-expanding the `R⁰G≅G` sub-step.
   Dispatch sanity: OK (1 file, within cap, sole active route).
3. **blueprint-reviewer** (`iter009`, whole blueprint) → `Cohomology_AcyclicResolution.tex`
   **HARD GATE CLEARS** for both remaining P4 leaves (complete, sourced, directly-formalizable
   sketches — detailed per-leaf verdict). `Cohomology_CechHigherDirectImage.tex` `partial/partial`:
   3 SS-contaminated blocks (must-fix), with concrete Route-A rewrites supplied.
   `Cohomology_HigherDirectImage.tex` complete+correct (live thin pointer). 0 unstarted-phase
   proposals.
4. **blueprint-writer** (`p5a-deSS`) → COMPLETE. De-spectral-sequenced the 3 contaminated blocks to
   Route-A (recipes from both reports). DAG clean (`unknown_uses: []`, no isolated). No
   strategy-modifying findings (no step secretly needed an SS). One note for the planner: the
   *statement* of `lem:cech_to_cohomology_on_basis` is still the general criterion while the rewritten
   *proof* argues only the affine/standard-cover instance — statement↔proof parity item for a future
   phase (see Open items).
5. **blueprint-clean** (`p5a`) → dispatched on the edited chapter (post-write purity + source-quote
   validation; judgement call on the 01EO proof-quote mirroring). [report folded into review]

## Decisions made

### D1 — Close P4 this iter: single mathlib-build prover lane on `AcyclicResolution.lean`.
Build the 2 NEW declarations (`rightDerivedOneIsoCokerOfAcyclic` then the TARGET-3 assembly
`rightDerivedIsoOfAcyclicResolution`). Both are `lean_verify`-confirmed absent, so the objective is
phrased as "build NEW declarations" (not "fill sorry") to avoid the zero-sorry-file no-op guard that
dropped this file's objective in a prior iter. Gate cleared by the iter-009 blueprint-reviewer. The
iter-007 prover handoff recipe + input-type design decision are carried verbatim into the PROGRESS
objective so the prover does not re-derive them. Reversal signal: if leaf 1's `R⁰G≅G` naturality
sub-step blocks, the prover leaves a real partial (named compiling sub-goals) and the next iter
effort-breaks JUST that square — do NOT re-dispatch the monolith.

### D2 — Invest in P5a blueprint NOW (parallel), not after P4 closes.
The strategy previously said "first action once P4 closes." Both critics this iter confirm the de-SS
rewrite needs only the P4 theorem *statement* (stable, frozen), not P4 *compiled* — so it is
independent and can run now. Per the parallelism + autonomous standing directives, I pulled it forward:
dispatched the blueprint-writer this iter so P5a opens as a parallel prover lane next iter (re-review
the chapter → scaffold + prove the frontier leaves). This removes a serialization stall without any
dependency risk. P5a is NOT a prover lane this iter (its chapter was `partial/partial` at dispatch
time and the gate requires a fresh complete+correct verdict; I did not take the same-iter fast path
because the P4 lane is the priority and a clean P5a re-review + scaffold is a next-iter unit).

### D3 — Address the strategy-critic must-fix (P5a effort honesty) by REDUCING scope, not just
re-estimating. The blueprint-reviewer found that the project only ever applies the basis lemma to
affine opens with standard covers, where it reduces directly to `lem:cech_acyclic_affine` + the P4
theorem (with `G = Γ(B,-)`) — bypassing the heavy general-01EO Čech-to-derived-H¹ sub-theory the
strategy-critic worried about. STRATEGY.md updated: P5a row + Open Qs + Mathlib gaps now enumerate the
basis lemma's sub-prerequisites, commit the reduced-scope route, confirm the P3↔basis bridge is
non-circular (basis lemma consumes narrowed-P3 standard-cover Čech vanishing, produces general affine
vanishing), and corrected the false "each independent of P3" claim (the basis lemma is P3-dependent;
the other two P5a leaves are not). P5a re-estimated ~3–6 iters / ~250–550 LOC.

## Prior critique status

- iter-007 strategy-critic CHALLENGE (P5a/P5b split + basis-lemma scoping + format) — was addressed in
  iter-007's STRATEGY.md edit; the iter-009 strategy-critic re-challenged the basis-lemma *effort
  honesty* specifically (a sharper version of the same scoping concern), now addressed in D3.
- iter-007 lean-vs-blueprint-checker "frontier-leaf blueprints under-specified" — these were Lean-level
  (input-type encoding, LES mechanism), NOT math-content gaps. Resolved by carrying the prover's own
  input-type design decision + recipe into the PROGRESS hints (the math-only blueprint correctly does
  not encode Lean type choices). The iter-009 blueprint-reviewer independently confirmed both blocks
  HARD-GATE-clear.

## Open items (tracked, not blocking)

- **Statement↔proof parity on `lem:cech_to_cohomology_on_basis`** (blueprint-writer note): statement is
  the general criterion; rewritten proof argues only the affine/standard-cover instance. When P5a's
  Lean target (`cech_eq_cohomology_of_basis`) is scaffolded, narrow the blueprint statement to the
  affine/standard case to restore parity (the Lean consumer only needs that case). Deferred to the P5a
  scaffold step.
- Throughput: P4 has run 5 iters in-phase vs an original tighter estimate. If iter-009 does not close
  P4, the next planner re-estimates and considers an effort-break on the `R⁰G≅G` sub-step.

## Subagent skips

- (none) — all three mandatory critics (strategy-critic, progress-critic, blueprint-reviewer) were
  dispatched this iter; each had genuine new input (iter-007 prover output + intervening iter-008 DAG
  re-sync).
