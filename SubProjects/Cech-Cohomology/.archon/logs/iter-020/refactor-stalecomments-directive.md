# Refactor directive — purge stale/misleading status comments (comment-only, iter-020)

This is a COMMENT-ONLY cleanup. Do NOT change any declaration, signature, proof body, or import.
Do NOT insert any `sorry`. Touch only comment text in the two files below. The lean-auditor (iter-019)
flagged these as actively-misleading status comments that contradict the proven code.

## File 1: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- **Lines ~347–387** — a block comment stating the composition law `pushPullMap_comp` is "reduced to an
  explicit clean pentagon, **not yet closed**" and enumerating "next-prover dead-ends, all hit this
  iter". This is FALSE: `pushPullMap_comp` is fully proved at line ~564 (via `rawPushPullMap_comp` at
  ~473), and the accurate comment at lines ~161–170 already says "Both laws are proved axiom-clean
  below". Replace the stale block with a one-line accurate note, e.g.
  `-- Composition law `pushPullMap_comp` is proved axiom-clean below (see `rawPushPullMap_comp`).`
  Preserve any genuinely useful technical content (e.g. the `conjugateEquiv`/`whnf` heartbeat-blowup
  warning, if present) as a short retained note, since it documents a real dead-end to avoid.

## File 2: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **Lines ~26–35** (module docstring) — says the named declarations `InjectiveResolution.ofShortExact`,
  `Functor.rightDerivedShiftIsoOfAcyclic`, `Functor.rightDerivedIsoOfAcyclicResolution` "will be
  constructed by the prover", but all three ARE constructed and proved in this file. Update the
  docstring to reflect that P4 is complete (these are proved), consistent with the accurate marker at
  line ~924 ("P4 complete — rightDerivedIsoOfAcyclicResolution is proved axiom-clean above").

## Verification
After editing, the two files must still compile exactly as before (comment-only change). Confirm no
declaration text was altered.
