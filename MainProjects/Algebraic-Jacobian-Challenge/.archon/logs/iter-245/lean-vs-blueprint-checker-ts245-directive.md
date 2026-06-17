# Lean ↔ blueprint check — iter-245

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

## Lean file (absolute path)

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Blueprint chapter (absolute path)

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (for your orientation only — verify independently)

The blueprint section `sec:tensorobj_pullback_monoidality` was rewritten this iter to
describe a locally-trivial chart-chase route (sub-lemmas D1'–D4' plus an
`IsInvertible.pullback` corollary), replacing an abandoned general strong-monoidal
build. The prover added two new Lean declarations in `section LocTrivPullbackTensor`:
`isIso_sheafify_tensorHom_pullbackValIso` (private helper) and
`isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (a reduction lemma isolating the sole
remaining content — the sheafified δ). D2'/D3'/D4' and the corollary were NOT built.

## Specific items to verify (in addition to your standard bidirectional checklist)

1. **`\lean{...}` pin integrity.** The D2' lemma block `lem:pullback_tensor_iso_unit`
   pins `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}`. Does
   that declaration actually exist in the Lean file? (The prover's task result says it
   was NOT added — replaced by a handoff comment.) Report whether this is a dangling
   `\lean{}` pin and whether it should be flagged.
2. **Coverage of the new reduction brick.** The landed
   `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` is load-bearing (the shared entry
   point for D2'–D4'), yet there appears to be no blueprint lemma block with a `\lean{}`
   pin for it. Is the chapter missing a block for this reduction lemma? Is that a
   blueprint-thinness gap the plan agent should fill?
3. **Fidelity of the D1'–D4' prose** to what the Lean actually proves vs. only asserts:
   is the chapter detailed enough to have guided the formalization that landed, and is
   any block describing as done something that is in fact still `sorry`/absent?

Report bidirectionally (Lean → blueprint AND blueprint → Lean) with severity tags.
