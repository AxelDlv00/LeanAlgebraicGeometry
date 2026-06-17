# Scaffold `CechSectionIdentification.lean` — Sub-brick A section-identification chain

## Goal
Create a NEW Lean file `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` containing
**six declaration stubs with `sorry` bodies** plus correct imports, namespace boilerplate, and a
rich `/- Planner strategy: ... -/` block above EACH stub. Do NOT attempt any proofs. Wire the new
file's import into the build root `AlgebraicJacobian.lean`. Verify the file compiles (only the
expected `declaration uses sorry` warnings).

This file is the shared "Sub-brick A" chain that identifies the evaluated augmented Čech section
complex with a concrete product-of-sections cochain complex and supplies its contracting homotopy.
It is consumed next iter by `CechAugmentedResolution.lean` to close the residual `hSec`.

## Import topology (CRITICAL — do not create a cycle)
The new file is **UPSTREAM** of `CechAugmentedResolution.lean`. It MUST NOT import
`CechAugmentedResolution.lean`. Import exactly what the stubs need:
```
import AlgebraicJacobian.Cohomology.CechHigherDirectImage   -- object layer: pushPullObj, coverCechNerveOver, cechAugmentedComplex
import AlgebraicJacobian.Cohomology.CechAcyclic             -- sectionCech_objD_apply, sectionCechProductEquiv, CombinatorialCech.Dependent engine (de-privatized iter-055)
import AlgebraicJacobian.Cohomology.FreePresheafComplex     -- coverOpen, coverInterOpen, le_coverInterOpen_iff
```
Add `import AlgebraicJacobian.Cohomology.CechSectionIdentification` to `AlgebraicJacobian.lean`
placed AFTER the `CechAcyclic`/`FreePresheafComplex`/`CechHigherDirectImage` lines and BEFORE the
`CechAugmentedResolution` line (so import order respects the dependency).

Note: `isZero_homology_of_homotopy_id_zero` already EXISTS in `CechAugmentedResolution.lean:76`
(general `Homotopy (𝟙 D) 0 → IsZero (D.homology p)`, axiom-clean). Do NOT duplicate it here, and do
NOT add the `cechSection_isZero_homology` decl here — that one stays in `CechAugmentedResolution.lean`
(it combines this file's outputs with the local `isZero_homology_of_homotopy_id_zero`).

## Source of truth
The exact statements + informal proofs are in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(the consolidated chapter, declared `% archon:covers ... CechSectionIdentification.lean`). The relevant
blocks are the Sub-brick A `\uses`-chain. The design rationale + Mathlib decl paths are in
`analogies/subbrickA.md`. READ BOTH before scaffolding.

## The six stubs to create (in `namespace AlgebraicGeometry`, in this order — each `\uses` the previous)

Use the blueprint statements verbatim in mathematical content; pick faithful Lean signatures matching
the existing project conventions (`F : X.Modules`, `𝒰 : X.OpenCover` finite, `V : Opens X`,
`pushPullObj`, `coverInterOpen 𝒰 σ`, `coverOpen 𝒰 i`). For each, the `\lean{}` pin in the blueprint
already names the EXACT Lean name to use:

1. `cechBackbone_left_sigma` (`lem:cech_backbone_left_sigma`) — geometric bookkeeping: the degree-`p`
   cover-nerve object `Y_p` (`(coverCechNerveOver 𝒰).obj [p]`) is the coproduct `∐_σ U_σ` over
   `σ : Fin (p+1) → ι`, with structure map `Sigma.desc (σ ↦ j_σ)`, `U_σ = coverInterOpen 𝒰 σ`.
   Strategy note: fibre-power distributes over coproduct; fibre product of open immersions = intersection.

2. `pushPull_sigma_iso` (`lem:pushPull_sigma_iso`) — **THE ONE NEW-INFRA LEAF.**
   `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)` (i.e. `(q_p)_*(q_p)^*F ≅ ∏_σ (j_σ)_*(j_σ)^*F`).
   Strategy note: build the comparison map, check it on `Scheme.Modules.toPresheaf` (faithful, reflects
   isos, preserves limits — `Sheaf.lean:75–78`) + `M.presheaf.IsSheaf`; the indexed disjoint-union
   decomposition iterates the binary Mathlib anchors `Scheme.coprodPresheafObjIso` /
   `TopCat.Sheaf.isProductOfDisjoint`. This is genuine new sheaf infra — flag it as the hard leaf.

3. `pushPull_leg_sections` (`lem:pushPull_leg_sections`) — per-leg:
   `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`.
   Strategy note: three off-the-shelf identifications — `Scheme.Modules.pushforward_obj_obj` (`rfl`,
   Sheaf.lean:155), `Scheme.Modules.restrictFunctorIsoPullback` (Sheaf.lean:371, already used in
   `QcohRestrictBasicOpen.lean:113–114,248`), `Scheme.Modules.restrict_obj` (`rfl`, Sheaf.lean:328) +
   opensRange/image-preimage bookkeeping. `q_p` is the coproduct map (NOT an open immersion); the open
   immersions are the legs `j_σ`, so this applies per-leg AFTER the #2 split.

4. `pushPull_eval_prod_iso` (`lem:pushPull_eval_prod_iso`) — degreewise:
   `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`.
   Strategy note: assemble #2 + `SheafOfModules.evaluationPreservesLimitsOfShape` (Limits.lean:85,
   `Γ(V, ∏_σ N_σ) ≅ ∏_σ Γ(V, N_σ)`) + #3.

5. `cechSection_complex_iso` (`lem:cechSection_complex_iso`) — complex-level iso `D ≅ D'`, where
   `D = (GV.mapHomologicalComplex cc).obj Kp` (the evaluated augmented Čech section complex,
   `GV = toPresheaf ⋙ eval(op V)`) and `D'` is the concrete section Čech complex
   `∏_σ Γ(coverInterOpen 𝒰 · ⊓ V, F)`. Differential match REUSES `sectionCech_objD_apply` (CechAcyclic)
   read through `sectionCechProductEquiv` — do NOT rebuild the differential.
   Strategy note: assemble #4 degreewise into a `HomologicalComplex` iso.

6. `cechSection_contractible` (`lem:cechSection_contractible`) — Sub-brick B: `Homotopy (𝟙 D') 0`.
   Strategy note: because `V ≤ coverOpen 𝒰 i_fix`, the restricted family `U'_σ = coverInterOpen 𝒰 σ ⊓ V`
   has maximum `U'_{i_fix} = V` (every `U'_σ ≤ V`), so the prepend-`i_fix` map is the IDENTITY on each
   coefficient; the de-privatized `CombinatorialCech.Dependent` engine (`depDiff`, `depHomotopy`,
   `depHomotopy_spec`, `depDiff_exact`, all PUBLIC as of the iter-055 refactor) supplies the contracting
   homotopy `h` with `d∘h + h∘d = id`. PURELY combinatorial — invoke NO affine vanishing, NO qcoh, NO
   tilde (the `\uses{lem:cech_acyclic_affine}` edge is only the Lean home of the `Dependent` engine, NOT
   a math dependency — read it as "import the dependent engine").

## Verification before returning
- `lake build` green (only `declaration uses sorry` warnings on the 6 new stubs + the pre-existing ones).
- Report the exact final signatures you chose for each stub (the planner needs them for the prover objective).
- If a faithful signature for any stub is genuinely unclear from the blueprint (especially #5's `D`/`D'`
  HomologicalComplex types), state the ambiguity in your report rather than guessing a type that won't
  match — the mathlib-build prover can refine it, but flag it.

## Out of scope
- Do NOT prove anything. Bodies are `sorry`.
- Do NOT touch `CechAugmentedResolution.lean`, `CechAcyclic.lean`, or any other existing file except
  adding the one import line to `AlgebraicJacobian.lean`.
- Do NOT edit blueprint chapters or add `\leanok`.
