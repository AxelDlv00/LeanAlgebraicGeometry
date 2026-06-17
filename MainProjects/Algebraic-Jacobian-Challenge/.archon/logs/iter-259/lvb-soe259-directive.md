# Lean ↔ blueprint check — SheafOverEquivalence

Verify bidirectionally:

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/SheafOverEquivalence.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_SheafOverEquivalence.tex`

Context: this iter closed both remaining sorries — `restrictOverIso`
(`lem:sheafofmodules_restrict_over_iso`) and `unitOverIso`
(`lem:sheafofmodules_unit_over_iso`) — axiom-clean (kernel axioms only). The file
is now sorry-free; `overEquivalence` and `chartOverIso` were already present.

Check:
1. Lean → blueprint: do the closed lemmas' Lean statements match the chapter's
   `\lean{...}` pins and informal statements? Any new private helpers
   (`psiRestrict`, `overForgetNatIso`) that the chapter should mention or that
   reveal a signature drift?
2. Blueprint → Lean: is the chapter's proof sketch for `restrictOverIso` /
   `unitOverIso` adequate (it should describe the `restrictFunctorAdjCounitIso`
   mirror + the `γ' = 𝟙` reconciliation), or was the Lean clearly under-guided?
3. Any fake/placeholder statements or mismatched signatures.

Report bidirectionally with any must-fix-this-iter findings clearly flagged.
