# Lean ↔ blueprint check — iter-005

## The one Lean file

`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

## Its blueprint chapter

`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## Context for this check

The prover added ≈27 new declarations this iter implementing the dual Horseshoe Lemma core. The
file compiles with 0 sorries. Verify bidirectionally:

### Lean → blueprint
- The prover reports a **name mismatch**: the blueprint block `lem:horseshoe_twist` carries
  `\lean{CategoryTheory.InjectiveResolution.ofShortExact_twist}`, but no such declaration exists.
  The mathematical content (the twist family + cocycle) was realized under different names:
  `horseshoeτ`, `horseshoeτ_cocycle`, `twistPair`, `horseshoeβ`, `horseshoeβ₁`, `horseshoeH`,
  `horseshoeτZero`. Similarly the blueprint's `_dComp` / `_chainMap` sub-lemma names do not match
  the realized `twistedBiprodD_comp` / `twistedBiprodInl` / `twistedBiprodSnd`. Report every
  `\lean{...}` in the chapter whose named declaration does NOT exist in the Lean file, and state
  the actual declaration name that realizes the same content (so the review agent can apply a
  `\lean{...}` correction or flag it for the planner to split the block).
- Check no chapter block claims a Lean declaration that is fake/placeholder.

### blueprint → Lean
- Is the chapter detailed enough to have guided this formalization? Several large new Lean
  declarations (`twistedBiprodSplitting`, `horseshoeSES_shortExact`, `horseshoeMid`) — does the
  chapter's "horseshoe construction, step by step" section actually describe them, or is the
  blueprint thinner than the Lean it was supposed to guide?
- The sole remaining gap is `resolvesMiddle` / `ofShortExact` (that `I_B` is a *resolution* of
  `B`), which needs a middle-term quasi-iso transfer `quasiIso_τ₂` that is ABSENT from Mathlib.
  Check whether the chapter's `lem:injective_resolution_of_ses` sketch acknowledges this
  middle-term quasi-iso obligation, or whether it hand-waves the resolution claim.

## What I do NOT need

No global strategy snapshot, no other files. Just this file vs this chapter. Report must-fix /
major / minor with severities, and explicitly say which `\lean{...}` names are stale.
