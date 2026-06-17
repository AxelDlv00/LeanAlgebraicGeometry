# Refactor Report

## Slug
stalecomments

## Status
COMPLETE

## Directive
**Problem:** Two files contain stale/misleading status comments that contradict proven code.
- `CechHigherDirectImage.lean` lines ~347–387: block comment says `pushPullMap_comp` is "not yet closed", but it is fully proved axiom-clean.
- `AcyclicResolution.lean` lines ~26–35: module docstring says three named declarations "will be constructed by the prover", but all three are proved in the file.

**Changes requested:** Comment-only cleanup. No declaration, signature, proof body, or import may change.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- **What:** Replaced the 40-line stale block comment (lines 347–386, `/- **Composition law … not yet closed … -/`) with a 4-line accurate note.
- **Why:** The block falsely claimed `pushPullMap_comp` was open; it is proved axiom-clean at line ~564 via `rawPushPullMap_comp`. The accurate header comment at lines 161–169 already says "Both laws are proved axiom-clean below."
- **Retained:** The genuine dead-end warning about `erw`/`congr 1` causing `whnf` heartbeat blowup via `TwoSquare.equivNatTrans`/`mateEquiv` unfolding — this documents a real pitfall to avoid in future proofs touching `pullbackComp`.
- **Cascading:** None (comment-only).

### File: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **What:** Updated the module docstring paragraph (lines ~25–33) from "will be constructed by the prover in `mathlib-build` mode" to "are all constructed and proved axiom-clean in this file (P4 complete — see the marker at the end of the file)".
- **Why:** All three declarations (`InjectiveResolution.ofShortExact`, `Functor.rightDerivedShiftIsoOfAcyclic`, `Functor.rightDerivedIsoOfAcyclicResolution`) are proved in this file; the accurate marker at line ~924 ("P4 complete — `rightDerivedIsoOfAcyclicResolution` is proved axiom-clean above") already confirms this.
- **Cascading:** None (comment-only).

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`: comment-only change; no Lean syntax affected.
- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`: comment-only change; no Lean syntax affected.

Both files compiled exactly as before — no declaration text was altered.

## Notes for Plan Agent
No complications. Both changes were straightforward comment replacements. The `erw`/`whnf` dead-end note was preserved in File 1 as instructed; it documents a genuine failure mode for future provers working near `pullbackComp`.
