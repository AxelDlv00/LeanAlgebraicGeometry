# lean-vs-blueprint-checker directive — iter-217

## The one Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Its blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What changed this iter
The lemma `lem:tensorobj_restrict_iso`
(`AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso`) was just CLOSED
axiom-clean. Five new presheaf-level helper declarations were added to the Lean file
(`PresheafOfModules.pushforwardNatTrans`, `pushforwardCongr`,
`pushforwardPushforwardAdj`, `isIso_of_isIso_app`, `restrictScalarsMonoidalOfBijective`).

## Report bidirectionally
- Lean → blueprint: does the closed proof match the blueprint's claimed 4-step route
  (restrictFunctorIsoPullback → sheafificationCompPullback → sheafification.mapIso →
  H1 pushforward≅pullback + H2 strong-monoidal tensorator)? Are the 5 new helper decls
  reflected anywhere in the chapter, or do they need `\lean{...}` pins added?
- Blueprint → Lean: is the chapter still adequate / accurate for this file, or does it
  describe routes/lemmas that no longer match the Lean (e.g. the vestigial route-(e)
  `isLocallyInjective_whiskerLeft_of_W` at L600)?
- NOTE a known issue to confirm: the blueprint-doctor reports `\leanok` was inserted
  INSIDE two multi-line `\uses{...}` blocks (around tex L1377-1379 and L2044-2046),
  breaking the `lem:whisker_of_W` and `lem:pullback_compatible_with_tensorobj`
  dependency edges. Confirm and report.

## Output
Bidirectional findings with severities; flag any must-fix-this-iter.
