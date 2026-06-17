# Lean Auditor Directive

## Slug
iter159

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — received prover work this iter. Pay
  particular attention to:
  - the newly-introduced top-level helper `rigidity_eqOn_saturated_open_to_affine` (its body
    is `sorry`): is its STATEMENT honestly formed and non-vacuous, or is it a stand-in whose
    hypotheses are dropped/unused so that a true headline is laundered through an unsatisfiable
    or trivially-false obligation? Check whether each hypothesis is load-bearing for the
    conclusion to be true.
  - `rigidity_eqOn_dense_open`: confirm its body contains no literal `sorry` and that it
    genuinely consumes the collapse hypothesis `_hf` (vs. ignoring it).
  - the three instance arguments `[IsAlgClosed kbar]` added this iter to
    `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`: are they a legitimate
    strengthening of antecedents, or do they hide a gap?

## Known issues
- The four `sorry`s in `AbelianVarietyRigidity.lean` (one bridge-2 helper + three deferred
  scaffolds `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
  `rigidity_genus0_curve_to_grpScheme`) are KNOWN, DISCLOSED gaps — do not re-report them as
  surprises. What IS in scope: whether any of them is a *false-as-stated* or laundering sorry
  (the iter-157 failure mode) rather than an honest deferred obligation.
- The `sorry`s in `Jacobian.lean` (L265, L303) and `RigidityKbar.lean` (L88) are likewise
  known named gaps.

## Absolute paths to read
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/
