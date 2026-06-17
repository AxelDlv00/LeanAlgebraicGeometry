# Iter-233 objectives (prover lanes)

3 lanes (all NEW-file or continue; within dispatch cap):

1. **`Picard/TensorObjSubstrate/StalkTensor.lean`** [mathlib-build] — CRITICAL PATH.
   Build d.2: `PresheafOfModules.stalkTensorIso` (`lem:stalk_tensor_commutation`),
   `(A⊗ᵖB).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x` over the varying ring on `Opens X`.
   Uses d.1 `stalkLinearMap` (built iter-214). Blueprint §`sec:tensorobj_stalk_tensor`.
   Source: Stacks `lemma-stalk-tensor-product`. Closes (next iter) `isLocallyInjective_whiskerLeft_of_W`
   ⟹ unconditional associator ⟹ `thm:pic_commgroup`.

2. **`Cohomology/HigherDirectImage.lean`** [prove] — scaffold the 4 chapter decls
   (`def:higher_direct_image`, `lem:higher_direct_image_quasi_coherent`,
   `lem:higher_direct_image_affine_vanishing`, `thm:flat_base_change_higher`); prove the
   frontier-ready ones; deep base-change theorem stays sorry. Resolves blueprint-doctor coverage flag.

3. **`Cohomology/FlatBaseChange.lean`** [mathlib-build] — continue: build the affine Spec/tilde
   dictionary for `affineBaseChange_pushforward_iso` (heart = `cancelBaseChange`); gap in
   `informal/affineBaseChange_pushforward_iso.md`. `flatBaseChange_pushforward_isIso` stays sorry.

Deferred this iter: `thm:pic_commgroup` group-law assembly (waits on d.2 + the associator-narration
blueprint cleanup, Flags A/C/D). RPF/FGA held. CMRegularity/SemiContinuity chapters deferred (depend on
HigherDirectImage).
