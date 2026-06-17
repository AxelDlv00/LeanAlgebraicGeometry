# Lean audit — iter-234 prover-touched files

Audit the following Lean files as Lean (no strategy context, no "what we're trying to prove"):

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean` (4 new declarations landed this iter)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (attempted work; 2 documented sorries)

Focus areas:
- In `StalkTensor.lean`: are the new `lemma`/`def` statements (`stalkTensorDescU_smul`, `stalkTensorDesc_germ`, `stalkTensorLinearMap`, `stalkTensorLinearMap_germ_tmul`) genuine and non-vacuous? Any `erw`/defeq abuse that could mask a wrong statement? Any decl that is trivially true or has a suspicious signature? Note any `sorry`-free-but-circular constructions.
- In `FlatBaseChange.lean`: the two `sorry` sites at lines ~237 and ~259 — are they honestly scoped, and are the surrounding statements well-formed? Any dead-end or misleading comments.
- Outdated comments, bad Lean practices, suspect definitions in either file.

Report a per-file checklist plus a flagged-issues block with severities.
