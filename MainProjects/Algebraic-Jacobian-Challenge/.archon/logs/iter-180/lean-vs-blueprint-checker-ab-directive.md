# lean-vs-blueprint-checker — AuslanderBuchsbaum.lean ↔ Albanese_AuslanderBuchsbaum.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## What changed this iter (Lane H — iter-180)

- `Module.depth` body closed kernel-clean via Stacks 00LF supremum form using `RingTheory.Sequence.IsRegular`. Body is `if I • ⊤ = ⊤ then ⊤ else sSup { n | ∃ rs, length rs = n ∧ rs ⊂ I ∧ IsRegular M rs }`.
- File 5 → 4 sorries (depth body retired; the 4 depth-dependent lemmas remain off-target per Lane H).
- 0 helpers introduced; 0 new axioms; 0 signature mutations.

## Report bidirectionally

1. **Lean → blueprint**: does the chapter's `def:depth` block match the new body's form? Verify the chapter mentions the Stacks 00LF supremum form OR the equivalent "if `IM = M` then ∞ else sSup" framing.
2. **Blueprint → Lean**: is the chapter detailed enough on the 4 depth-dependent lemmas (`depth_eq_smallest_ext_index`, `depth_of_short_exact`, `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`) for iter-181+ work? Per task_result, these are unblocked structurally now that depth has a body.

Output to `task_results/lean-vs-blueprint-checker-ab.md`.
