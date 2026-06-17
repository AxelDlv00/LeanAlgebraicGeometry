# Lean audit — iter-002

Audit the following Lean files as Lean (no strategy bias). Report per-file: outdated
comments, suspect/placeholder definitions, dead-end proofs, type-weakening dodges, bad
Lean practices, and any statement that looks faked to avoid real content.

Files (absolute paths):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

Focus areas:
- Newly added declarations this iter: `base_change_map_affine_local`,
  `pushforward_base_change_mate_cancelBaseChange`, `affineBaseChange_pushforward_iso`
  (rerouted) in FlatBaseChange.lean; `genericFlatnessAlgebraic`, `genericFlatness`
  (re-signed) in FlatteningStratification.lean.
- Pay extra attention to whether `pushforward_base_change_mate_cancelBaseChange`'s
  `IsIso (Γ(α))` statement is genuine content or a vacuous/tautological dodge.
- Whether the `by_cases Module.Finite A M` split in `genericFlatnessAlgebraic` is honest
  (primary branch actually closed; residue is a real sorry, not a hidden cheat).
- Whether the in-code comments accurately describe the remaining obligations or overstate
  progress.
