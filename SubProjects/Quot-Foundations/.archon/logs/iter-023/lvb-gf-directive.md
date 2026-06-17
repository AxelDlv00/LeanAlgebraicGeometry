# lean-vs-blueprint-checker — FlatteningStratification (iter-023)

Verify one Lean file against its blueprint chapter, bidirectionally.

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

CRITICAL focus this iter: a SIGNATURE CORRECTNESS issue. The prover determined that
`genericFlatness` (~line 2264) was mathematically FALSE as previously stated (only
`[LocallyOfFiniteType p]`, no quasi-compactness — a counterexample exists: an infinite disjoint
union over Spec ℤ). The prover added `[QuasiCompact p]` to the Lean signature. Check:
- Does the blueprint `thm:generic_flatness` statement/LEAN SIGNATURE comment now reflect the
  `[QuasiCompact p]` hypothesis, or is it stale (still claiming the false weaker hypothesis)?
- Is the `% NOTE` in the blueprint that justified "locally of finite type ⟹ quasi-compact"
  (the original error) still present and now wrong?
- The prover flagged two genuine missing-Mathlib bridges as candidate blueprint lemmas: G1
  (quasicoherent + finite-type ⇒ finite section module over affine) and G3 (flat-locality
  assembly). Is the blueprint proof of `thm:generic_flatness` hand-waving these, or are they
  blueprinted? Report whether the chapter is adequate to guide closing the remaining `sorry`.
