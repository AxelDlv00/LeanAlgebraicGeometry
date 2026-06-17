# blueprint-reviewer directive — ts231

Whole-blueprint audit (your standard scope — read every chapter).

## Two specific things this iter

1. **Gate confirmation for the active prover chapter.** `Picard_TensorObjSubstrate.tex` had its
   `lem:dual_restrict_iso` PROOF recipe corrected this iter (the prior recipe routed through the
   sheaf-site root `overSliceSheafEquiv`, which iter-230 empirically falsified for this bridge; the
   new recipe is the minimal objectwise `V⊆U` route). The STATEMENT is unchanged. Confirm the
   chapter remains `complete: true` + `correct: true` for the file `Picard/TensorObjSubstrate.lean`,
   or flag any must-fix.

2. **Unstarted-phase proposals — PRIORITY this iter.** The strategy notes the A.2.c representability
   ENGINE (Quot/Hilbert/Cartier, Nitsure §5 + Kleiman §4; deepest root `R^i f_*` for i≥1) is the
   real cost on the critical path to the PRIMARY GOAL (Pic_{C/k} representability), and it currently
   has thin / missing blueprint coverage. Per your `## Unstarted-phase blueprint proposals` job:
   give a concrete chapter outline for the engine's FIRST ungated foundational pieces so future
   iters can fan out parallel provers onto them (the USER has a standing parallelism-via-file-split
   directive). Name which engine pieces are genuinely ungated roots (buildable now from Mathlib +
   existing project infra) vs. which are gated behind the substrate/RelPic. Relevant references:
   `nitsure-hilbert-quot`, `kleiman-picard`, `fga-explained`, `stacks-coherent` (02KH, `R^i f_*`
   base change), `stacks-constructions` (relative Spec/Proj).

Report your per-chapter checklist + the unstarted-phase proposals.
