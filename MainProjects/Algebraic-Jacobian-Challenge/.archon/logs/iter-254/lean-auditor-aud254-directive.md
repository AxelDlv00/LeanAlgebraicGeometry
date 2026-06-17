# lean-auditor directive (iter-254)

Audit the two Lean files that received prover edits this iteration. Read them as Lean,
with no bias toward what any strategy or blueprint claims should be true.

## Files (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Focus areas
- New/changed declarations this iter:
  - `sheafifyTensorUnitIso_hom_natural` and its new private helper `sheafifyTensorUnitIso_hom_eq'`
    in TensorObjSubstrate.lean (closed this iter; check the proof is honest — no hidden
    `sorry`/`admit`, no axiom leak, no vacuous statement).
  - `pullbackTensorMap_natural` in TensorObjSubstrate.lean (still `sorry`; check the in-file
    comments accurately describe what is and isn't proved — flag any "CLOSED"/"DONE" label that
    contradicts a live `sorry`).
  - `homOfLocalCompat` in DualInverse.lean: its `hf` hypothesis was RE-SIGNED this iter from an
    `HEq` form to a sectionwise-equation form. Verify the new signature is not trivially
    satisfiable / vacuous, that the surrounding docstring matches the actual `hf`, and that the
    remaining single `sorry` (open-immersion ring-bridge) is honestly labelled.
  - new helper `image_preimage_of_le` in DualInverse.lean.
- General: outdated comments, decls labelled closed/CLOSED while a `sorry` is reachable,
  fragile `set_option ... respectTransparency false`, deprecated `Sheaf.val` usage, dead code.

## Output
Per-file checklist + a flagged-issues block with severities. Name any must-fix-this-iter item
explicitly.
