# Blueprint-reviewer directive — iter-256

Whole-blueprint audit (per your standard cross-chapter checklist). No scope limit — read the
whole blueprint as usual.

This iter the plan agent will dispatch provers to THREE Lean files; report the HARD-GATE status
(complete? correct? any must-fix-this-iter?) for each backing chapter specifically:

1. `Picard/TensorObjSubstrate/DualInverse.lean` and `Picard/TensorObjSubstrate.lean`
   — both covered by the consolidated chapter `Picard_TensorObjSubstrate.tex`. This chapter was
   edited THIS iter (blueprint-writer bw256 + blueprint-clean bc256): two proof-sketch refinements
   — `lem:sheafofmodules_hom_of_local_compat` sub-step (c) (smul-bridge expansion) and
   `lem:dual_restrict_iso` Step-4 (H1 + Leg(A)/(B) restructure). The active prover targets are
   D3' `lem:pullback_tensor_map_basechange` (TensorObjSubstrate.lean) and
   `lem:sheafofmodules_hom_of_local_compat` (DualInverse.lean). Confirm these blocks are
   complete+correct and the two refinements are sound.

2. `Picard/LineBundleCoherence.lean` — covered by `Picard_LineBundleCoherence.tex` (authored
   iter-255, you cleared it complete+correct last iter). This file is being scaffolded (file-skeleton)
   this iter from that chapter's declarations. Re-confirm the chapter is complete+correct so the
   scaffold gate clears.

Also: report your usual unstarted-phase blueprint proposals and any broken-cross-ref / orphan
findings (note: the planner removed six stray `\leanok`-inside-`\uses{}` corruptions in
`Picard_TensorObjSubstrate.tex` and `Picard_RelPicFunctor.tex` this iter).
