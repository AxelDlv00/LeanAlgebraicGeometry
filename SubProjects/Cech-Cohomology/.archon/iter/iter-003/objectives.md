# Iter-003 objectives (detail)

## Lane 1 (only) — P4: `AcyclicResolution.lean` [prover-mode: mathlib-build]

Goal: build the abstract acyclic-resolution comparison (Stacks 015E) bottom-up, axiom-clean.
File scaffolded this iter and compiling; `Functor.IsRightAcyclic` + injective instance done.

Targets in dependency order:
1. `InjectiveResolution.ofShortExact` (horseshoe) — `lem:injective_resolution_of_ses`.
   Hard core: twisted differential `τ` via `Injective.factorThru`; model on
   `InjectiveResolution.ofCocomplex`/`exact_f_d`/`ofCocomplex_exactAt_succ`. Standalone chain.
   Output: degreewise-split `ShortComplex (CochainComplex C ℕ)` that is `.ShortExact`.
2. `Functor.rightDerivedShiftIsoOfAcyclic` — `lem:acyclic_dimension_shift`.
   Apply `G` to the split SES → `homology_exact₁/₂/₃`+`δ` → transport via `isoRightDerivedObj`
   → kill acyclic terms. Yields `(R^k G)(Z)≅(R^{k+1}G)(A)` (k≥1) and `(R^1G)(A)≅coker(GJ→GZ)`.
3. `Functor.rightDerivedIsoOfAcyclicResolution` — `lem:acyclic_resolution_computes_derived`.
   Staircase induction over cosyzygy SESs; base via `rightDerivedZeroIsoSelf`.

mathlib-build invariant: no sorry pins — fully prove what you can, hand off a precise
decomposition for the rest. Recipe: `analogies/p4-derived-les.md` + in-file strategy block.
Blueprint: `chapters/Cohomology_AcyclicResolution.tex`.

## Not dispatched this iter (with reason)
- P3 (`CechAcyclic.affine`) — gated by the standard-cover-vs-general-cover statement gap;
  resolve (narrow signature OR upgrade blueprint) before effort-break/prover.
- P5 (`cech_computes_higherDirectImage`, protected) — needs P3 + P4.
