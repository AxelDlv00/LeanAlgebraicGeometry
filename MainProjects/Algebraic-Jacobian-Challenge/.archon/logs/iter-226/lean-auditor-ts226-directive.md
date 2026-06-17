# lean-auditor directive — iter-226

Audit the following Lean file as Lean (no strategy bias):

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus areas

1. The newly added lemma `AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict`
   (around lines 1938–1975): is the statement well-formed and non-vacuous? Are the
   hypotheses (`U : X → X.Opens`, `∀ x, x ∈ U x`, the per-point restriction-iso) the
   natural ones, or is the signature subtly weaker/stronger than a "locally-iso ⇒ iso"
   statement should be? Any dead-end or no-op tactic in the proof body.
2. Comment accuracy across the file. This iter heavily edited two comment blocks: the
   `exists_tensorObj_inverse` body comment (around lines 2009–2027) and the file header.
   Flag any comment that overstates progress, names a non-existent declaration, or
   describes a route that the code does not actually take.
3. Any remaining `sorry` bodies (expected at L641, L2027, L2073) — confirm each carries an
   honest explanatory comment and is not silently masked.

Report a per-file checklist plus a flagged-issues block with severities. Do not read
PROGRESS.md / STRATEGY.md.
