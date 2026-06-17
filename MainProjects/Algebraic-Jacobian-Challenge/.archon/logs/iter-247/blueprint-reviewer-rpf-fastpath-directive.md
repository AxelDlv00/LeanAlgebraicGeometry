# blueprint-reviewer directive — SCOPED fast-path on Picard_RelPicFunctor.tex (iter-247)

This is a HARD-GATE same-iter fast-path re-review, scoped to ONE chapter:
`blueprint/src/chapters/Picard_RelPicFunctor.tex`.

## Context
- This chapter cleared the HARD GATE last iter (blueprint-reviewer ts246: complete + correct, 0 must-fix
  on the math; RPF prover dispatch approved).
- Two non-math issues were then flagged and have just been fixed THIS iter by the plan agent:
  1. A stray `\leanok` token inside the proof's `\uses{...}` list (blueprint-doctor "broken cross-ref"
     `\uses{\leanok thm:relative_pic_quotient_well_defined}`) — REMOVED.
  2. The iter-246 `% NOTE` that declared the recipe "INFEASIBLE (import cycle)" — REWRITTEN: the
     import cycle was resolved this iter by a refactor (dependency now flows
     LineBundlePullback → TensorObjSubstrate → RelPicFunctor), so RelPicFunctor now imports the tensor
     substrate and can cite its real upstream decls. The carrier-setoid caveat (iso-class group =
     additive mirror of picCommGroup) was preserved.
- The relevant Lean file `Picard/RelPicFunctor.lean` builds clean (4 pre-existing typed-sorry bridges
  to be rewired by the prover to the now-upstream substrate decls).

## What to verify (scoped to this chapter only)
- The chapter is complete + correct: the `lem:rel_pic_sharp_groupoid` statement + the 4-step
  `addCommGroup` proof sketch (Steps 1–4) are mathematically sound and detailed enough to formalize.
- No broken `\uses{}` / `\ref{}` remain in this chapter.
- The rewritten `% NOTE` is accurate and not misleading to a prover (it should guide the prover to cite
  the upstream substrate decls and collapse the 4 local bridges).
- The source quotes (Kleiman §2 df:aPf/df:Pfs) are intact and verbatim.

## Verdict needed
Return for THIS chapter ONLY: `complete: true|false`, `correct: true|false`, and any
must-fix-this-iter finding. If complete + correct with no must-fix, the gate clears for
`Picard/RelPicFunctor.lean` and the RPF prover is dispatched this iter.
