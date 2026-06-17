# Directive: blueprint-reviewer — whole-blueprint audit (iter-041)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter checklist.
Do not limit scope — the cross-chapter view is the point.

## This iter's context (for your HARD-GATE verdict, not a scope limiter)
The plan agent is about to dispatch a prover at the **Route B keystone**
`lem:qcoh_section_isLocalizedModule` (in chapter `Cohomology_CechHigherDirectImage.tex`, the
consolidated chapter that `% archon:covers` all Cohomology/*.lean files — its verdict gates ALL of
them, including `QcohTildeSections.lean`). I need a current complete+correct verdict on that chapter
to clear the HARD GATE for the keystone dispatch.

Two things changed in that chapter this iter (planner edits):
- `lem:restrict_over_compat` (B3b): statement + proof prose rewritten to match the actual Lean decl
  `overBasicOpenIsoRestrict` (the B3b intermediate iso `engine.inverse.obj(F.over D(g)) ≅ F.restrict ι`),
  fixing a prose/signature mismatch the lean-vs-blueprint checker flagged at iter-040. The stale
  `% NOTE: SCOPE MISMATCH` was removed.
- `lem:presentation_modulesRestrictBasicOpen` (B4): `\lean{}` now bundles the helpers
  `restrictBasicOpenUnitIso`, `pullbackObjUnitToUnit_isIso_basicOpen`; `\uses` gained
  `def:modules_over_basicOpen_equivalence`; proof prose rewritten for the B3c affine transport.

## Specific things to check
1. **Keystone block `lem:qcoh_section_isLocalizedModule`** — is its proof sketch complete + correct
   at textbook level? In particular, scrutinize the descent step "under the section comparison this is
   exactly the statement that the gⱼ-localized section map …" — the planner suspects this step hides a
   sheaf-gluing/Čech-H⁰ obligation (`Γ(D(gⱼ),F)≅Γ(X,F)_{gⱼ}`) that the listed `\uses` may not cover.
   If you agree the proof under-specifies that step, flag it (must-fix: the `\uses` is incomplete or a
   gluing sub-lemma is missing) — this is exactly the kind of thin proof the HARD GATE should catch.
2. The two edited blocks (B3b, B4) — complete + correct, `\uses` accurate?
3. Standard whole-blueprint checks: orphan chapters, broken `\uses`/`\ref`, coverage debt, thin proofs.

Report your per-chapter checklist and, prominently, the verdict (complete?/correct?/must-fix?) for
`Cohomology_CechHigherDirectImage.tex`, since the keystone dispatch gates on it.
