# lean-vs-blueprint-checker — SectionGradedRing iter-063

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

Verify bidirectionally. This iter closed `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`,
2 embedded sorries → 0) and added helper `relTensorActL_proj_eq`. Check: (a) `\lean{}` pins resolve;
(b) `\leanok` honest — file is now 0-sorry; (c) `relTensorActL_proj_eq` has no `\lean{}` pin (internal
helper) — report as coverage debt; (d) the 22-name multi-`\lean{}` pin on
`lem:relativeTensor_objectwise_coequalizer` — note the review manually re-applied `\leanok` (sync strips
it every iter because it cannot evaluate the multi-name field). Report to your task_results file.
