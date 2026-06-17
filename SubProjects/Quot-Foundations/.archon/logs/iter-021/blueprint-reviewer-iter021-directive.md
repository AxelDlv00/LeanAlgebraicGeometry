# Blueprint-reviewer directive — iter-021

Whole-blueprint audit (all chapters). This iter dispatches two prover lanes — GF
(`Picard_FlatteningStratification.tex`) and FBC (`Cohomology_FlatBaseChange.tex`) — plus a
QUOT structural refactor. Give per-chapter `complete:`/`correct:` verdicts and confirm the HARD GATE
for the two prover-bound chapters.

## Gate-critical focus
1. **Picard_FlatteningStratification.tex (GF)** — prover target this iter: close the L4 finiteness leaf
   `lem:gf_noether_clear_denominators` Step 3c (`exists_localizationAway_finite_mvPolynomial` @754) and
   let it cascade to the `genericFlatnessAlgebraic` B/𝔭 obligation @1810. Your iter-020 verdict marked
   this chapter `complete:false`. Please state EXPLICITLY whether that was a PROSE-completeness finding
   (a sketch is missing/too thin to formalize) or a `\leanok`-completeness observation (proofs not yet
   formalized — which is exactly what the prover fills). The per-file lean-vs-blueprint checker (iter-020)
   judged the Step-3c denominator-clearing prose "adequate." Confirm whether the L4-finiteness + B/𝔭
   cascade prose is complete+correct enough to dispatch a prover (the precise Lean-lemma choice for
   denominator-clearing is a tactic-level hint, not blueprint math). If you find a genuine prose gap,
   name it as must-fix.
2. **Cohomology_FlatBaseChange.tex (FBC)** — prover target: `lem:base_change_mate_gstar_transpose`
   @1525 (your iter-020 verdict: complete+correct, HARD GATE PASSED — the 3-step counit-factorization
   recipe). Re-confirm it is still gate-ready for a first prove attempt at the crux. (The superseded
   Seam-2 `fstar_reindex` dead-code blocks are knowingly retained this iter; flag them FYI only — their
   physical removal is deferred to an FBC-no-prover iter.)

## Other changes this iter (confirm coherence, not gate-critical)
3. **Picard_QuotScheme.tex** — I added two coverage-debt helper blocks:
   `lem:graded_finrank_comap_subtype` (after `lem:graded_subquotient_degreewise_diff`) and
   `lem:graded_iSupIndep_map_of_mem_ker_sup` (before `lem:graded_subquotient_base_eventuallyZero`, and
   wired into its `\uses{}`). I also updated the `% archon:covers` line to add the new Lean file
   `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` (a refactor this iter splits the graded
   Hilbert–Serre machinery out of QuotScheme.lean and de-privates the IsRatHilb toolkit; the qualified
   Lean names are unchanged). Confirm the two new blocks are well-formed (statement/label/lean/uses) and
   that the covers split introduces no orphan/double-cover. The QUOT keystone chain landed axiom-clean
   iter-020.

Report per-chapter checklist + a HARD-GATE table (PASSED/DEFERRED per prover-bound chapter) and any
must-fix-this-iter findings.
