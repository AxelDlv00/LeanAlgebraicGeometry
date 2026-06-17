# lean-vs-blueprint-checker directive (iter-254) — TS-cmp

Bidirectional verification of ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(this is a consolidated chapter; it declares `% archon:covers` for several files — focus only on
the blocks corresponding to TensorObjSubstrate.lean).

## What changed this iter (focus)
- `sheafifyTensorUnitIso_hom_natural` was CLOSED this iter (the D1′ comparison helper). Confirm the
  blueprint statement it formalizes matches the Lean signature, and that the chapter's proof sketch
  no longer prescribes the (disproven, iter-252) whisker-exchange route.
- `pullbackTensorMap_natural` (D1′, `lem:pullback_tensor_map_natural`) is still `sorry`. The prover
  reports a structural blocker requiring a "spelling-pin" restatement of `pullbackTensorMap` (the
  `δ_natural` MonoidalCategory instance is registered only on the `X.presheaf ⋙ forget₂ CommRingCat
  RingCat` spelling, not on `X.ringCatSheaf.obj`). Report whether the blueprint adequately guides
  this (does the chapter explain the carrier-spelling requirement, or is it too thin?).

## Report
Bidirectional: (a) Lean follows blueprint (fake/placeholder/signature-mismatch with `\lean{}`
pins?); (b) blueprint adequate to guide formalization. Flag must-fix-this-iter items.
