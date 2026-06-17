# lean-vs-blueprint-checker directive — iter-215

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Its blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter

A new fully-proved helper `restrictScalarsRingIsoTensorEquiv` was added: for a
ring iso `e : R ≃+* S`, base change along `e` commutes with `⊗` (the canonical
map `a ⊗ₜ[R] b ↦ a ⊗ₜ[S] b` is an `R`-linear equivalence). The prover reports
this realises the "H2 strong-monoidal bottom gap" referenced in the proof of
`lem:tensorobj_restrict_iso` (Step 3) and in `sec:tensorobj_route_e`. The
blueprint currently lists "strong-monoidal `restrictScalars` along a ring iso"
as Mathlib-absent; it is now project-side but may not yet have its own
`\lean{...}`-pinned block.

## Report bidirectionally

- Lean → blueprint: is `restrictScalarsRingIsoTensorEquiv` covered anywhere in
  the chapter? Does it need its own statement block / `\lean{...}` pin (so the
  next plan/writer round can add it)? Are the four open sorries' blueprint
  statements faithful to the Lean signatures?
- Blueprint → Lean: is the chapter detailed enough to guide the four still-open
  sorries (`isLocallyInjective_whiskerLeft_of_W`, `tensorObj_restrict_iso`,
  `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`)? Any signature
  mismatch, fake/placeholder statement, or stale `\uses{}`?

Flag any must-fix-this-iter findings explicitly.
