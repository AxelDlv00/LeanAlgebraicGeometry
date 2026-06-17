# Lean ↔ Blueprint Checker Directive

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(This is the CONSOLIDATED chapter; it carries `% archon:covers` for several
files including OpenImmersionPushforward.lean. Focus your review on the
open-immersion acyclicity / Need#1 `hqc` material: `slice_reverse_ring_map`,
`pushforward_slice_adjunction_h1/h2`, `pushforward_slice_two_adjunction`,
`pushforward_slice_pullback_iso`, `pushforward_iso_preserves_qcoh`.)

## What to check
- Bidirectional: (a) Lean follows blueprint, (b) blueprint detailed enough.
- This iter the prover decomposed the monolithic `case hqc` sorry of
  `higherDirectImage_openImmersion_acyclic` into named sub-lemmas. CLOSED
  (body sorry-free, modulo leaves): `pushforwardSliceTwoAdjunction`,
  `pushforward_iso_preserves_qcoh`, and `case hqc` itself (now
  `exact pushforward_iso_preserves_qcoh U.isoSpec H hH`). The `leftAdjointUniq`
  half of `pushforwardSlicePullbackIso` is built.
- OPEN sorries (verify each is honest, correctly-typed, and the blueprint
  describes the residual accurately): `sliceReverseRingMap` (φ'', the keystone —
  body `sliceStructureSheafHom φ.symm (φ.inv⁻¹ᵁ Ui) ≫ sorry`, residual = 2-part
  codomain bridge), `pushforwardSliceAdjunctionH1`, `pushforwardSliceAdjunctionH2`
  (statements extracted, bodies sorry, blocked on φ''),
  `pushforwardSlicePullbackIso` (`≪≫ sorry` section identity), and the unchanged
  `higherDirectImage_openImmersion_comp` (`_comp`).
- CRITICAL: confirm the blueprint statement of `lem:slice_reverse_ring_map` (φ'')
  matches the prover's pinned first-factor + 2-part codomain bridge, and that
  H₁/H₂ blueprint proofs do not over-claim (they reduce to eqToHom squares only
  once φ'' is concrete).
- Flag broken `\lean{}`, missing coverage, or any blueprint proof that is
  mathematically wrong/under-specified for the open leaves.

## Output
Bidirectional report to your task_results.
