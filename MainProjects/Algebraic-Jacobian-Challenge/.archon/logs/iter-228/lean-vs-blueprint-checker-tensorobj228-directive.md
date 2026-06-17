# Directive — lean-vs-blueprint-checker (slug: tensorobj228)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Files
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Context (factual, no strategy bias)
This iter (228) the prover added three new axiom-clean declarations to the Lean file:
- `PresheafOfModules.dualPrecompEquiv` (~L1558)
- `PresheafOfModules.dualIsoOfIso` (~L1603)
- `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` (~L1698)

## What to report
1. For each of the three new decls: is there a corresponding blueprint block with a
   matching `\lean{...}` pin? If NOT, flag the missing-pin (Lean→blueprint gap) so the
   plan agent can add a prose block.
2. The blueprint lemma `lem:dual_isLocallyTrivial` (~L2779) carries a `\lean{...}` pin to
   `AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial`, but that Lean declaration does
   NOT exist in the file (the C-bridge did not land). Confirm this fake/placeholder-pin
   status and report it. (A `% NOTE:` was added this iter documenting that the proof sketch
   is incorrect past H1 — confirm the note is present.)
3. Any other signature mismatch, fake/placeholder Lean statement, or blueprint block whose
   detail level is inadequate for formalization, in either direction.

Report bidirectionally (Lean→blueprint AND blueprint→Lean). Mark each finding
must-fix-this-iter / major / minor.
