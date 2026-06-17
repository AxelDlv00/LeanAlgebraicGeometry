# refactor directive — slug wire-stalktensor

## Goal
Wire the new (currently un-imported) file `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
into the canonical dependency cone so its axiom-clean declarations are available to downstream
consumers and consistent with the `% archon:covers` annotation. This is a one-line import addition.

## Exact change
Add the import line
`import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor`
to the aggregator `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, alongside its existing imports
(`...TensorObjSubstrate.Vestigial`, `...TensorObjSubstrate.PresheafInternalHom`, `...Picard.RelPicFunctor`).
Place it adjacent to the other `TensorObjSubstrate.*` sub-file imports.

## Critical constraint — no import cycle
`StalkTensor.lean` currently imports only `Mathlib` and is INDEPENDENT of `Vestigial.lean`. Do NOT add
any import of `Vestigial` (or any other project file) INTO `StalkTensor.lean`. The future consumer
`isLocallyInjective_whiskerLeft_of_W` lives in `Vestigial.lean`; when it later needs d.2, `Vestigial`
will import `StalkTensor` (one direction only). Keep `StalkTensor.lean` import-minimal so that
direction stays acyclic. If adding the aggregator import would create any cycle, STOP and report
instead of forcing it.

## Verification
After the edit, run `lake env lean` (or `lake build` for the affected module) and confirm the build is
green with no NEW errors and no new `sorry` (StalkTensor has 0 sorries). Report the before/after build
status. Do NOT fill or insert any proof; this is purely an import-wiring change.

## Out of scope
- Do NOT move `stalkLinearMap` or `isLocallyInjective_whiskerLeft_of_W` between files this iter (that
  structural decision is deferred to the consumer-wiring iter when d.2's iso lands).
- Do NOT edit `StalkTensor.lean` itself (a prover lane is editing it this iter).
