# Lean-vs-blueprint — OpenImmersionPushforward.lean (iter-059)

Verify this one Lean file against its blueprint chapter, bidirectionally.

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; OpenImmersionPushforward is declared via `% archon:covers`.)

This iter the prover added 5 decls (preadditiveCoyoneda_mapHomologicalComplex_d_apply, isZero_coyoneda_rightDerived_of_forall_ext_eq_zero, enoughInjectives_of_hasInjectiveResolutions, subsingleton_ext_of_iso_fst, ext_jShriekOU_eq_zero_of_specIso) and factored the `higherDirectImage_openImmersion_acyclic` leaf's Ext-vanishing sorry into two named geometric hypotheses `hjt` (lem:jshriek_transport_along_iso) and `hqc` (lem:pushforward_iso_preserves_qcoh), both still `sorry`.

Check:
- Do the new decls match their blueprint labels (signature, statement)?
- Are the two new sorries (hjt/hqc) correctly typed against the blueprint lemmas they claim to be?
- Are there fake/placeholder/vacuous statements?
- Is the blueprint adequate to guide formalizing hjt/hqc, or is it too thin (e.g. the natural-iso construction / qcoh-along-iso transport)?

Report bidirectionally with must-fix flags. Write under task_results/.
