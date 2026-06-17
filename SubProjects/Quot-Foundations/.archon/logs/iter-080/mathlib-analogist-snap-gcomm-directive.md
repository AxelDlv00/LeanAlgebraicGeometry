## Mode: api-alignment

## Question
How should `sectionsMul_assoc_unit` (and the surrounding graded-ring assembly) be STATED so that `sectionGradedRing` can be packaged as a graded commutative semiring / graded module? A prior `lean-scaffolder` (`snap-coherent`) DIED unable to state `sectionsMul_assoc_unit` — the obstacle was the signature shape against `DirectSum.GCommSemiring` fields, NOT a proof difficulty.

## Context
- File: `AlgebraicJacobian/Picard/QuotScheme.lean` (the assembly target `sectionGradedRing_gcommSemiring`/`sectionGradedRing_gmodule`) + `AlgebraicJacobian/Picard/SectionGradedRing.lean` (the degreewise tensor-power machinery).
- The degreewise multiplication is `sheafTensorObj`; associativity `tensorObjAssoc` and the degree-addition iso `tensorPowAdd` are BOTH DONE (0-sorry, SectionGradedRing.lean). `unitModule X` is PUBLIC.
- Goal: assemble a `DirectSum.GCommSemiring`-style graded structure on the section graded ring from these degreewise isos.

## What to find
1. Mathlib's canonical idiom for building a graded (comm)semiring / `DirectSum.Gmodule` from a degreewise multiplication with associativity + unit + degree-addition coherences. Which typeclass (`DirectSum.GSemiring`, `GCommSemiring`, `Gmodule`, or `GradedMonoid.GMul`/`GOne`), and the EXACT field shapes (`mul`, `one`, `mul_assoc`, `one_mul`, `mul_one`, `mul_comm`, `gnpow`?) — especially how `mul_assoc` is typed when the degree indices add (`GradedMonoid.mk` heq vs the `tensorPowAdd`-mediated equation).
2. Specifically: what is the correct Lean type for the coherence currently named `sectionsMul_assoc_unit` — the shape that makes `mul_assoc`/unit laws typecheck given the degree-shift isos. Is a `GradedMonoid`-level `Eq`/`HEq`, a `cast`, or an `Eq` mediated by `tensorPowAdd` the right encoding?
3. Whether the project should instead mirror a specific Mathlib construction (e.g. `DirectSum.toSemiring`, `GradedAlgebra`, tensor-algebra graded structure, or `HomogeneousLocalization`-style assembly) rather than building the typeclass fields by hand.

## Output
A concrete signature for `sectionsMul_assoc_unit` + the GCommSemiring/Gmodule field-by-field mapping (with the Mathlib citation for each), written to `analogies/snap-gcomm.md`, so the next iter can scaffold with a definite signature.
