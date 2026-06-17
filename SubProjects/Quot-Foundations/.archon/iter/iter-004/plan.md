# Iter 004 — Plan (Quot-Foundations)

## TL;DR

Pick-up + finalize iter. A prior iter-004 plan turn (before a context reset) had already processed
the iter-003 prover results and run the four blueprint-side subagents (effort-breaker `fbc-l4`,
blueprint-writer `gf-chain`, blueprint-clean `iter004`, blueprint-reviewer `iter004`) — all reports
on disk, but the sidecar/PROGRESS/task_pending were unwritten and the mandatory progress-critic was
written-but-never-dispatched. This turn finalized: dispatched the progress-critic (**both lanes
CONVERGING**), advanced the QUOT long-pole in parallel (mathlib-analogist decided the two predicate
shapes → blueprint-writer encoded them → blueprint-clean purified), and set the two live prover
lanes (FBC-A close L4 chain; GF-alg close L3 chain + re-sign L4 + attempt L5). No mechanical gate —
both lanes dispatch. Build was green entering (iter-003 prover left both files compiling, sorry=12).

## State at entry

- iter-003 prover landed: FBC L1/L2/L3 axiom-clean + mate lemma assembled modulo L4; GF L1 (torsion)
  axiom-clean + L5 base case (d=0). Both files compile, total project sorry = 12.
- The prior iter-004 turn's blueprint subagents had already: effort-broken FBC L4 into a 3-sub-lemma
  chain (`base_change_mate_regroupEquiv`, `…_generator_trace_eq`, `…_generator_trace` corollary);
  re-encoded GF L4 to an explicit AlgHom target + broken GF L3 into L3a/L3b/L3c + corrected L5 prose;
  added blueprint entries for the two iter-003 FBC helper defs; run blueprint-clean; and the
  blueprint-reviewer `iter004` returned both active chapters complete+correct (HARD GATE CLEARS).

## Critic dispositions

- **blueprint-reviewer (`iter004`, ran prior turn):** FBC + GF chapters **clear the HARD GATE**
  (`complete: true + correct: true`, no must-fix touching either). One non-blocking must-fix:
  `Picard_QuotScheme.tex` `complete: partial` — (a) `thm:grassmannian_representable` RepresentableBy
  closing argument missing; (b) `def:quot_functor` predicate encoding absent. Two "soon": FBC
  proof-level `\uses{}` consistency (cosmetic, DAG edge already exists via statement-level) and the
  FBC-B `LinearMap.tensorEqLocusEquiv` spelling (queued, not this iter). Acted on (b) this turn;
  (a) explicitly deferred (see Decision). FBC/GF dispatch unaffected.
- **progress-critic (`iter004`, dispatched this turn): both lanes CONVERGING**, 0 CHURNING/STUCK,
  dispatch=OK. Confirmed: (i) FBC-A 2 iters of genuine structural progress (monolith atomized, 3/4
  sub-lemmas proved); the L4 3-sub-lemma plan is a real advance, not a re-dispatch. (ii) GF-alg
  genuine sorry-elimination (L1 + L5-base proved); rising sorry count is scaffolding, not churn.
  (iii) **No serial bottleneck demonstrated → keep GF as a single lane this iter; do NOT split files**
  (directly answers the standing parallelism directive's file-split question). Two forward flags:
  FBC affine-reduction is the undiscounted next residue (effort-break before next FBC iter if left
  partial); GF L4 "re-sign ≠ sorry-elimination" when scoring iter-004.
- **strategy-critic: SKIPPED** (see `## Subagent skips`).

## Decision made

### Keep two single-file lanes; do NOT split GenericFreeness (this iter)
- **Option chosen:** one prover per active file (FBC-A, GF-alg), `prove` mode, leaves-first.
- **Why:** the standing PARALLELISM directive favors file-splitting, but the progress-critic
  (fresh-context) found NO serial bottleneck after 2 GF iters — L3a/b/c and L4 are graph-independent
  but a single prover sequentially clears them faster than paying a refactor-iter to split, and
  iter-003 already showed the GF lane closing leaves each iter. Splitting now adds a refactor agent +
  a deferred prover iter for zero parallelism gain (FBC and GF are *already* parallel, one each).
- **Trade-off:** if iter-004 returns the GF lane PARTIAL on L3 (cannot clear its independent leaves
  in one session), THAT is the demonstrated bottleneck — next iter split `GenericFreeness.*` into a
  dedicated file (leaves) + keep the assembly in `FlatteningStratification.lean`. Cheapest reversing
  signal: GF prover INCOMPLETE/PARTIAL on the L3 chain.

### Advance the QUOT long-pole in parallel (predicate shapes)
- **Option chosen:** spend this turn's spare subagent budget deciding + blueprinting the two QUOT
  predicates now, rather than waiting until FBC/GF finish.
- **Why:** QUOT is the project's long pole (Iters left 4–12); the predicate-shape design was the
  blueprint-reviewer's only non-blocking must-fix and a known QUOT-defs prerequisite. mathlib-analogist
  (api-alignment) returned concrete idiom-aligned shapes: (P1) schematic support = a project-built
  `Modules.annihilator` ideal sheaf (mirror `Scheme.Hom.ker`) → `def:schematic_support`, with
  proper-over-S = `IsProper((annihilator F).subschemeι ≫ f)` **aligning with Mathlib `IsProper`**
  (its `IsStableUnderBaseChange` gives Nitsure's base-change clause for free); (P2) rank-`d` local
  freeness = a single `Prop` `IsLocallyFreeOfRank M r` witnessed by `Nonempty` local trivialization
  vs `SheafOfModules.free (Fin r)`, mirroring `IsQuasicoherent` (correcting the directive's premise:
  `IsLocallyFree` does NOT exist in Mathlib at all). Blueprint-writer encoded all of it into
  `Picard_QuotScheme.tex`; blueprint-clean purified. Rationale persisted to
  `analogies/quot-predicates.md`.
- **Reversing signal:** if FBC/GF slip badly, deprioritize QUOT — but the design work is now banked
  and cheap to resume.

### Defer the QUOT representability must-fix (a)
- **Deferred, not skipped.** `thm:grassmannian_representable`'s RepresentableBy closing argument
  depends on the still-open RelativeSpec `RepresentableBy`-strengthening question AND on
  GR-cells/glue/quot being built first (none exist in Lean yet). It is many iters out; addressing it
  now would be speculative. Revisit when QUOT-repr activates. Recorded in PROGRESS ramp.

## Actions taken this turn

1. Processed iter-003 prover results (FBC-A, GF-alg) → updated PROGRESS objectives, task_pending.
2. Dispatched **progress-critic** `iter004` → both lanes CONVERGING; single-lane structure confirmed.
3. Dispatched **mathlib-analogist** `quot-predicates` (api-alignment) → predicate shapes decided.
4. Dispatched **blueprint-writer** `quot-predicates` → encoded P1/P2 blocks into QuotScheme; wired
   `def:quot_functor` + `def:grassmannian_scheme`.
5. Dispatched **blueprint-clean** `quot` → purified the new QuotScheme blocks (8 Lean-leakage fixes).
6. Set iter-004 `## Current Objectives`: FBC-A (L4-a/b/c chain + attempt affine iso), GF-alg (L3a/b/c
   + assemble + re-sign L4 + attempt L5). Both `prove`, leaves-first, reference-anchored (Stacks
   "Affine base change"; Nitsure §4).

## Subagent skips

- strategy-critic: STRATEGY.md SHA unchanged from iter-003 (the QUOT predicate shapes landed in the
  blueprint + `analogies/`, not STRATEGY, which only names gaps — no route/decomposition change), and
  the prior iter-003 strategy-critic verdict was SOUND with its QUOT CHALLENGE addressed (graded-
  encoding pivot, recorded iter-003). All three skip conditions met.
- blueprint-reviewer: already dispatched this iter (`iter004`, prior turn) — both active chapters
  cleared the HARD GATE; not re-run.

## Tool substitutions

- None. All named tools executed.
