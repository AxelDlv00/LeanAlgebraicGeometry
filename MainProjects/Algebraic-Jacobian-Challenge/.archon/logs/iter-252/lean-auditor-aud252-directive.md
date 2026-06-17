# lean-auditor — iter-252 audit

Audit these two Lean files as Lean (no strategy bias):

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

Both received prover edits this iter. Focus areas:

1. Honesty of docstrings / module headers vs the actual `sorry` state. Last iter a module header
   in DualInverse.lean mislabelled `dual_isLocallyTrivial` as "CLOSED" while it carried `sorryAx`
   transitively; the prover claims to have relabelled it to "TRANSITIVELY PARTIAL" (L25) and fixed a
   "Uses (all CLOSED)" inconsistency (~L288). Verify these are now accurate and that no other header
   or comment over-claims a closed/axiom-clean state for a decl that still has (transitive) sorry.
2. `homLocalSection` (DualInverse.lean ~L355) and `homOfLocalCompat` (~L474): confirm the scaffold is
   a real construction, not a laundered placeholder; flag any `sorry` hidden behind `\leanok`-implying
   prose.
3. TensorObjSubstrate.lean `sheafifyTensorUnitIso_hom_natural` (~L1900-1993) and
   `pullbackTensorMap_natural` (~L2010-2022): the prover reports reducing the former to an
   "instance-free element-level ModuleCat tmul residual" and gating the latter. Confirm the open
   `sorry` bodies are genuinely typed/compiling residuals and the surrounding prose matches.
4. Any `set_option backward.isDefEq.respectTransparency false`, `erw`-heavy, or other fragile-but-
   axiom-clean patterns worth flagging for a polish pass.
5. Stale comments referencing prior-iter state.

Output your standard per-file checklist + flagged-issues block with severities.
