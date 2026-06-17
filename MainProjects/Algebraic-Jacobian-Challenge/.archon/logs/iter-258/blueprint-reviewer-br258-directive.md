# blueprint-reviewer br258

Whole-blueprint audit (your standard per-chapter checklist + completeness/correctness verdicts +
unstarted-phase proposals). Read the entire chapter tree under `blueprint/src/chapters/`.

## Focus for the HARD GATE this iter
The plan agent intends to dispatch provers to these files this iter — confirm their backing chapters
are `complete: true` AND `correct: true` with no must-fix:

1. **NEW file `Picard/SheafOverEquivalence.lean`** — backed by a NEW chapter the writer will author
   THIS iter (`Picard_SheafOverEquivalence.tex`) for the construction
   `SheafOfModules.overEquivalence` (modules-level lift of `Opens.overEquivalence`, ring-sheaf
   transported). The chapter does NOT exist yet at the time you run — flag it as missing-coverage so
   the writer/fast-path re-review sequence is triggered. (This is the iter's primary lane.)
2. **`Picard/TensorObjSubstrate.lean`** — backed by `Picard_TensorObjSubstrate.tex`
   (`lem:pullback_tensor_map_basechange`, D3′). iter-257 found the genuine Sq2 content ("Sq2b" =
   monoidality of `pullbackComp`) is Mathlib-absent, and that `toRingCatSheafHom_comp_hom_reconcile`
   (which the chapter framed as "non-trivial transport") is actually `rfl`. Check the D3′ chapter for
   (a) whether the Sq2b mate-calculus step is stated at the right level of difficulty/honesty, and
   (b) the stale "non-trivial transport" framing.

## Also flag
- The recurring `\uses{\leanok …}` corruption (blueprint-doctor keeps catching one in
  `Picard_RelPicFunctor.tex`).
- Any chapter whose Lean target is mis-formulated.
- Unstarted-phase proposals (your standard section).

Do NOT scope yourself to these — audit the whole blueprint; the cross-chapter view is the point.
Write the per-chapter checklist + verdicts to your task_results report.
