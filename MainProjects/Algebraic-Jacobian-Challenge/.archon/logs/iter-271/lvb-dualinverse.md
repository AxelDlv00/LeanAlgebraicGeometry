# lean-vs-blueprint-checker directive — DualInverse (iter-271)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

Lean file:
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

Blueprint chapter (consolidated, `% archon:covers` this file):
  /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
Relevant environment: `lem:slice_dual_transport`
  (`\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}`).

Specific points to check:
- This iter extracted a new top-level def `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv`
  (the `invFun` of `sliceDualTransport`). It TYPECHECKS but its `app`/`naturality` fields still
  contain `sorry`. Confirm the blueprint's "Inverse." paragraph of `lem:slice_dual_transport`
  accurately describes this reverse map, and report whether `sliceDualTransportInv` needs its own
  `\lean{}` entry (1-to-1 coverage debt) — it currently has no dedicated blueprint environment.
- The blueprint prose for the inverse direction was reportedly corrected this phase (ε-direction).
  Check it matches the actual Lean construction (conjugation by `dualUnitRingSwapHom` along
  `f.appIso`, with the codomain transport across the open-equality `he`).
- `dual_restrict_iso` (`lem:dual_restrict_iso`?) assembly still carries a `sorry`. Confirm no
  over-claim in the chapter.

Report bidirectionally with any must-fix-this-iter findings.
