# Lean-vs-blueprint — OpenImmersionPushforward (iter-065)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; this file is one of its `% archon:covers` targets)

This iter the prover CLOSED the entire `case hqc` cascade: `sliceReverseRingMap` (φ''),
`pushforwardSliceAdjunctionH1`, `pushforwardSliceAdjunctionH2`, `pushforwardSlicePullbackIso`,
so `higherDirectImage_openImmersion_acyclic` (Need#1) is now FULLY sorry-free and axiom-clean.
KEY: the φ'' codomain bridge turned out DEFINITIONAL (`exact 𝟙 _`), not the anticipated
object-relabel iso — the blueprint may still describe a non-trivial bridge.

Remaining open: `higherDirectImage_openImmersion_comp` (STRETCH goal, ~line 950) decomposed into 4
honest cohomological gaps (`hacyc` = f_*-acyclicity of j_* Iⁿ; `eRes`; `hexact`; `transport`).

Report bidirectionally:
- Lean → blueprint: does the now-closed acyclic chain match the blueprint? Is the blueprint's φ''
  description (`lem:slice_structureSheaf_hom` / `lem:pushforward_slice_two_adjunction` /
  `lem:pushforward_slice_pullback_iso`) now stale/over-complicated given the bridge was definitional?
- Blueprint → Lean: does `lem:open_immersion_pushforward_comp` give enough detail for the 4 gaps,
  especially the NEW f_*-acyclicity vanishing result (residual b)?
- Flag any must-fix-this-iter items.
