# Lean Auditor Directive

## Slug
iter157

## Files to audit
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean` (primary — received prover work this iter; a newly-created file)

## Focus areas
- This file was created this iteration and one declaration (`rigidity_lemma`) was filled by a prover, with two new helper lemmas (`rigidity_snd_lift`, `rigidity_core`) and one isolated geometric `sorry` (`rigidity_eqOn_dense_open`). Three sibling declarations (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`) are bare `:= sorry` scaffolds.
- Verify: is `rigidity_lemma` genuinely proven (modulo the single named geometric `sorry`), or is its proof vacuous / circular / laundering? Does `rigidity_core`'s inlined replication of the scheme-level rigidity argument actually type-check and apply the cited Mathlib lemmas (`GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `Scheme.PartialMap.Opens.isDominant_ι`, `Over.OverMorphism.ext`, `ext_of_isDominant_of_isSeparated'`) correctly, or does it lean on unjustified instance assumptions?
- Check the helper lemma `rigidity_snd_lift` (`ext1 <;> simp`) for soundness.
- Check the docstrings for overclaims: do the comments accurately describe what is proven vs deferred? Flag any comment that explains away a gap or overstates Mathlib availability.
- Note any dead/unused hypotheses on the proven declarations.

## Read these absolute paths
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean

Report per-file checklist + flagged issues block. Do not assume anything about project strategy.
