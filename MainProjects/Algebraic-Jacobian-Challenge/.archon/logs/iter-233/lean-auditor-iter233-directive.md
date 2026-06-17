# Lean audit — iter-233 newly created / modified files

Audit the following `.lean` files as Lean code (no strategy bias). For each, run the
per-file checklist: outdated/misleading comments, suspect definitions, dead-end or
vacuous proofs, bad Lean practices, hypotheses that quietly weaken a statement,
`sorry` placement, and whether any declaration is stated in a way that makes it
trivially true or non-reusable.

Files (absolute paths):
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean

Focus areas:
- In `HigherDirectImage.lean`: the def `higherDirectImage` carries an extra
  `[HasInjectiveResolutions X.Modules]` instance hypothesis. Is the statement still
  honest/meaningful, or does the hypothesis make downstream lemmas vacuous? Are the
  three `sorry`-bodied lemmas stated with correct hypotheses (e.g. quasi-coherence,
  `1 ≤ i`)?
- In `StalkTensor.lean`: the file builds a forward comparison map `stalkTensorDesc`
  (colimit.desc) plus germ-characterisation lemmas. Verify none of the lemmas is
  vacuous and that the cocone-naturality proof actually proves the intended equality
  (not a defeq-collapsed triviality). Check `import Mathlib` blanket-import and any
  `erw`/`rfl`-heavy proofs for fragility.
- In `FlatBaseChange.lean`: 3 new locality criteria for `Scheme.Modules` morphisms
  (`isIso_iff_isIso_stalkFunctor_map`, `isIso_of_isIso_app_of_isBasis`,
  `isIso_iff_isIso_app_affineOpens`). Confirm they are genuine (not circular) and the
  two engine theorems' `sorry`s are honestly scoped.

Write your report to your task_results file.
