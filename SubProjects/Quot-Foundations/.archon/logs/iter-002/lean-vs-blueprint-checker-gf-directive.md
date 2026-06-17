# Lean ↔ blueprint check — FlatteningStratification.lean (iter-002)

Verify bidirectionally one Lean file against its blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

Report (a) whether the Lean follows the blueprint — fake/placeholder statements,
signature mismatches with `\lean{...}` pins, missing declarations; and (b) whether the
blueprint is adequate to guide the formalization.

Specific points to check:
- `genericFlatnessAlgebraic` vs `thm:generic_flatness_algebraic`: does the Lean signature
  match the blueprint's `% INTENDED LEAN SIGNATURE` block verbatim? Is the `by_cases`
  split (primary finite-A branch closed via `exists_free_localizationAway_of_finite`,
  finite-type dévissage residue sorry) faithful to the blueprint's decomposition?
- `genericFlatness` vs its block: the Lean decl was re-signed to add
  `[F.IsQuasicoherent] [F.IsFiniteType]`; the chapter carries a `% NOTE:` describing this
  corrected signature. Confirm the Lean signature matches the note, and that the wrapper's
  sorry corresponds to the geometric globalization step the blueprint describes.
- Whether the blueprint gives enough detail on the dévissage / globalization for a prover
  to make progress, or whether it needs expansion (effort-breaker / blueprint-writer).
