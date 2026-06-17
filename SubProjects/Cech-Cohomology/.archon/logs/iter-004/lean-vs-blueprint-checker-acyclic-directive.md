# lean-vs-blueprint-checker directive (iter-004)

## The one Lean file

`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

## Its blueprint chapter

`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_AcyclicResolution.tex`
(declares `% archon:covers AlgebraicJacobian/Cohomology/AcyclicResolution.lean`)

## What to verify (bidirectional)

This file received prover work this iteration in `mathlib-build` mode: 5 new sorry-free
declarations were added. Check both directions carefully:

1. **Blueprint → Lean.** The chapter has three named target blocks whose `\lean{...}` points at:
   - `lem:injective_resolution_of_ses` → `CategoryTheory.InjectiveResolution.ofShortExact`
   - `lem:acyclic_dimension_shift` → `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`
   - `lem:acyclic_resolution_computes_derived` → `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`
   For EACH, confirm whether a real Lean declaration of that exact name exists in the file (a
   `def`/`lemma`/`theorem`/`noncomputable def` at top level — NOT a signature appearing inside a
   `/-! ... -/` comment or a ``` ``` code fence). Report any block whose `\lean{}` target does
   not exist as a real declaration, and whether that block nonetheless carries `\leanok`
   (a false "done" marker).
2. **Lean → blueprint.** The 5 new declarations actually present
   (`Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic`,
   `shortExact_of_degreewise_splitting`,
   `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`,
   `Functor.rightDerivedShiftIsoOfSplitResolutionSES`,
   `mono_biprod_lift_factorThru_of_exact`) have NO blueprint block of their own. Report whether
   the chapter adequately covers them (e.g. as sub-lemmas of the named targets) or whether the
   blueprint is too thin / out of sync with what was actually formalized.
3. Signature/statement faithfulness: does the chapter's informal statement of each target match
   the intended Lean signature, and is the blueprint detailed enough to guide formalizing the
   still-missing pieces (the horseshoe)?

## Output

Bidirectional report (Lean → blueprint AND blueprint → Lean) with must-fix-this-iter findings
called out. Write to your `task_results` file.
