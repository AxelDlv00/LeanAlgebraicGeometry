# Blueprint Reviewer Directive

## Slug
ts244

## Scope
Whole-blueprint audit (per your descriptor — do NOT scope-limit; the cross-chapter view is the point).
Produce your standard per-chapter completeness+correctness checklist + any unstarted-phase proposals.

## This iter's gate-relevant focus
The chapter **`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`** was rewritten this iter
(section `sec:tensorobj_pullback_monoidality`) and is the ONLY chapter feeding a live prover lane
next: a `mathlib-build` lane on the concrete strong-monoidal pullback. The HARD GATE depends on your
verdict for this chapter. Assess specifically whether the rewritten section is complete + correct for
prover dispatch:
- `lem:pullback_tensor_iso` (un-descoped, now the committed build target) — is its proof sketch
  (D1 decomposition `pullback ≅ extendScalars ⋙ pullback₀`; D2 scalar half strong via
  `distribBaseChange`; D3 topological `pullback₀ = Lan` strong via filtered comma `(F↓V)`; D4 sheafify
  + transport via `leftAdjointUniq`) detailed enough to formalize bottom-up, and mathematically correct?
- the two new sub-lemma blocks `lem:pullback_lan_decomposition` (D1) and `lem:pullback0_tensor_iso` (D3)
  — well-formed statements, correct `\uses{}`?
- `lem:isinvertible_pullback` — re-routed to the 3-line Stacks proof (`lemma-pullback-invertible`) off
  `lem:pullback_tensor_iso` + `lem:pullback_unit_iso`; verbatim SOURCE QUOTE/PROOF present and correct?
- `lem:isinvertible_implies_locallytrivial` — demoted off-path (retained for future A.2.c, no longer an
  A.1.c dependency); is the demotion coherent (no dangling `\uses` pointing at it as a dependency)?

Flag if `lem:IsLocallyTrivial_pullback` (or any label) is now orphaned project-wide after the re-route.

## Output
Per-chapter checklist (complete / correct booleans + notes) and a clear verdict for
`Picard_TensorObjSubstrate.tex` (the gate). Plus any `## Unstarted-phase blueprint proposals`.
