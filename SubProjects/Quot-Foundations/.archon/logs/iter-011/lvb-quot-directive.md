# Lean ↔ Blueprint check — QuotScheme (iter-011)

Verify one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

This iter landed 5 new axiom-clean decls: the annihilator ideal sheaf `Scheme.Modules.annihilator`
(def:modules_annihilator), the `ofIdeals`-inclusion lemma `Scheme.Modules.annihilator_ideal_le`,
the schematic support `Scheme.Modules.schematicSupport` (def:schematic_support) + its closed
immersion `schematicSupportι`, and `Scheme.Modules.HasProperSupport` (def:has_proper_support).
Four skeleton `sorry`s remain (the QCoh→IsLocalizedModule bridge and representability stubs).

A review-added `% NOTE` on def:modules_annihilator now records that the DEFINITION is closed (via
`ofIdeals`) and only the FORWARD characterization remains bridge-gated on
lem:qcoh_section_localization_basicOpen.

Report:
1. **Lean → blueprint**: do the new defs/predicates match their blueprint blocks (non-vacuous,
   `\lean{}` pins resolve)? Are `annihilator_ideal_le` and `schematicSupportι` (which have no
   blueprint block — coverage debt) faithful helper lemmas?
2. **Blueprint → Lean**: is the chapter accurate now, or are there stale claims about what is
   formalized vs bridge-gated? Confirm the 4 remaining `sorry`s correspond to genuinely
   blocked/out-of-scope blueprint nodes, not silently dropped obligations.
3. Any must-fix-this-iter findings.
