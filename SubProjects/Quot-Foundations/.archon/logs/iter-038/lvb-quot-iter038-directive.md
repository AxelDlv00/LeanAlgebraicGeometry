# Lean-vs-Blueprint Checker — QuotScheme (iter-038)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

## This iter's new declarations to check
- `gammaImageRingEquiv` ↔ `def:gamma_image_ring_equiv` (blueprint ~line 3829). KNOWN ISSUE:
  the prover built the iso in direction `Γ(X,V) ≃+* Γ(Y, j ''ᵁ V)` (source→image), which is the
  OPPOSITE of the blueprint's stated `Γ(Y, j''ᵁV) ≃+* Γ(U,V)`. The review agent has corrected the
  `% LEAN TYPE` pin comment and added a `% NOTE:` flagging the prose direction for the planner.
  Confirm whether the prose `\[\sigma_V : ...\]` still needs flipping and whether downstream
  `\uses` consumers depend on the old direction.
- `gammaPullbackImageIso_hom_semilinear` ↔ `lem:gamma_pullback_image_iso_hom_semilinear`
  (blueprint ~line 3848). Statement `hom (a • x) = σ_V a • hom x`.

Report bidirectionally with severity. Flag any must-fix-this-iter items.
