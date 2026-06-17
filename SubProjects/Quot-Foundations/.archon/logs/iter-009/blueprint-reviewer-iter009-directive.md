# Blueprint Reviewer Directive

## Slug
iter009

## Scope
Whole-blueprint audit (your standard per-chapter checklist of completeness + correctness, broken
`\uses{}`, isolated nodes, well-formed Lean targets, and unstarted-phase proposals). Do NOT
scope-limit — the cross-chapter view is the point.

## Chapters changed this iter (the prover-gating ones — give them your sharpest attention)
1. `Cohomology_FlatBaseChange.tex` + `Cohomology_RegroupHelper.tex` — **FBC route swap.** The
   adjoint-mate tower (`base_change_mate_unit_value`/`…_fstar_reindex`/`…_gstar_transpose` +
   `…_generator_trace_eq`) was DROPPED and replaced by a single section-level identity
   `lem:base_change_mate_section_identity` (`Γ(θ) = lTensor R' η_M`, with a `% LEAN SIGNATURE`
   block). `lem:base_change_mate_regroupEquiv` was reconstructed on the natively-`R'`-linear
   `Algebra.IsPushout.cancelBaseChange` (new `\mathlibok` anchor
   `lem:isPushout_cancelBaseChange_mathlib`), eliminating the `map_smul'` obstruction. Judge:
   is the new section identity well-formed and formalizable (signature pinned, proof rigorous,
   source quote verbatim)? Is the regroupEquiv reconstruction sound? Are there any dangling
   `\uses{}` or orphaned blocks from the drop?
2. `Picard_FlatteningStratification.tex` — **GF effort-break.** `lem:gf_torsion_reindex` was
   decomposed into `lem:gf_torsion_annihilator`, `lem:gf_nagata_monic_lastVar`, the shared
   engine `lem:gf_mvPolynomial_quotient_finite_monic`, plus Mathlib anchors. Judge: does each new
   sub-lemma carry a formalizable `% LEAN SIGNATURE`, an informal proof, and accurate `\uses{}`?
   Is the rewired `gf_torsion_reindex` proof a faithful short assembly of them?
3. `Picard_QuotScheme.tex` — the annihilator sub-build added iter-008 (engine lemma block +
   QCoh→IsLocalizedModule bridge `lem:qcoh_section_localization_basicOpen` +
   `def:modules_annihilator` re-wired to require quasi-coherent finite-type `F`). This chapter
   gates a prover lane THIS iter — confirm complete + correct or flag must-fix.

## Why this matters
Per the HARD GATE: a prover is dispatched at file F only if its backing chapter is
`complete: true` + `correct: true` with no must-fix. FBC + GF dispatch NEXT iter (gate must hold
into iter-010); `Picard_QuotScheme.tex` (QUOT-A) and `Picard_GrassmannianCells.tex`
(GrassmannianCells, `def:gr_transition`) gate prover lanes THIS iter — your verdict on those two
determines whether they enter iter-009 objectives.
