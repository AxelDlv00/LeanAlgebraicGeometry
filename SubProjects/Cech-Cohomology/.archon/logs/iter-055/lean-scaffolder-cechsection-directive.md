# Lean-scaffolder directive — create `CechSectionIdentification.lean`

## Goal
Create the NEW file `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` holding the shared
Sub-brick A section-identification chain, with `sorry` bodies, and wire it into the build. The file must
COMPILE (`lake env lean` exit 0) with only `sorry` warnings. Do NOT prove anything.

## Source of truth
The blueprint chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, blocks (read them for
the precise mathematical statements + informal proofs):
`lem:cech_backbone_left_sigma`, `lem:pushPull_sigma_iso`, `lem:pushPull_leg_sections`,
`lem:pushPull_eval_prod_iso`, `lem:cechSection_complex_iso`, `lem:cechSection_contractible`,
`lem:cechSection_isZero_homology`. Also `analogies/subbrickA.md` (exact Mathlib decl names + lines).

## Declarations to create (namespace `AlgebraicGeometry`, these EXACT names — they match the blueprint `\lean{}`)
Create a `sorry`-bodied stub for each. Determine the precise Lean signature from the project defs via LSP
(`pushPullObj`, `coverCechNerveOver`, `cechAugmentedComplex` in `CechHigherDirectImage.lean`;
`coverInterOpen`, `coverOpen` in `FreePresheafComplex.lean`; `sectionCech_objD_apply`,
`sectionCechProductEquiv`, and the now-PUBLIC `CombinatorialCech.Dependent.*` engine in `CechAcyclic.lean`):

1. `cechBackbone_left_sigma` — degree-`p` object of `coverCechNerveOver 𝒰` ≅ `∐_σ U_σ` (each leg the open
   immersion `j_σ : coverInterOpen 𝒰 σ ↪ X`). If this is definitional/`rfl` in the project's cover-nerve
   construction, state it in whatever form is provable and note it; otherwise an `Iso`.
2. `pushPull_sigma_iso` — `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)` in `X.Modules`. (THE one
   new-infra leaf.)
3. `pushPull_leg_sections` — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(coverInterOpen 𝒰 σ ⊓ V, F)` (an
   AddCommGrp / module iso of sections).
4. `pushPull_eval_prod_iso` — `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`.
5. `cechSection_complex_iso` — the homological-complex iso between the evaluated-at-`V` augmented Čech
   complex `D` (built from `cechAugmentedComplex 𝒰 F` via `toPresheaf ⋙ eval(op V)` after
   `forget ⋙ restrictScalars`) and the concrete section Čech complex `D'` over `(coverInterOpen 𝒰 · ⊓ V)`.
6. `cechSection_contractible` — `Homotopy (𝟙 D') 0`, given `hVi : V ≤ coverOpen 𝒰 i` (cone-point prepend).
7. `cechSection_isZero_homology` — TOP: for `hVi : V ≤ coverOpen 𝒰 i`, `∀ p, IsZero (D.homology p)` where
   `D` is the evaluated augmented complex. **Its statement MUST match the residual goal that
   `cechAugmented_exact` needs** — read the current sorry goal at `CechAugmentedResolution.lean:205`
   (`Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) 0`) and shape #7 so the consumer can discharge
   that residual by it (either produce that `Homotopy` directly, or `IsZero (D.homology p)` that the
   consumer feeds through `isZero_homology_of_homotopy_id_zero`). Pick whichever is cleaner; prioritize a
   form the consumer can call.

Add a leading `/- Planner strategy: ... -/` comment capturing the chain recipe (the 5 off-the-shelf
Mathlib decls from `analogies/subbrickA.md`: `pushforward_obj_obj` rfl, `restrictFunctorIsoPullback`,
`restrict_obj` rfl, `SheafOfModules.evaluationPreservesLimitsOfShape`, the binary
`Scheme.coprodPresheafObjIso`/`TopCat.Sheaf.isProductOfDisjoint` to iterate — note `isProductOfDisjoint`
returns `IsLimit (BinaryFan …)`, extract the iso via `IsLimit.conePointUniqueUpToIso`; differential via
`sectionCech_objD_apply`; contractibility via the public `CombinatorialCech.Dependent` engine).

## Imports
`import AlgebraicJacobian.Cohomology.CechHigherDirectImage` and
`import AlgebraicJacobian.Cohomology.CechAcyclic` (gives the public Dependent engine + sectionCech machinery
+ `coverInterOpen`/`coverOpen`). Add others only if LSP shows they're needed. Do NOT import
`CechAugmentedResolution.lean` (that file is the downstream CONSUMER — importing it would create a cycle).

## Build wiring
Add `import AlgebraicJacobian.Cohomology.CechSectionIdentification` to the top-level aggregator
`AlgebraicJacobian.lean` (alongside the other `AlgebraicJacobian.Cohomology.*` imports) so `lake build`
compiles it. Do NOT modify `CechAugmentedResolution.lean` (consumer wiring is a later prover step).

## Verify
`lake env lean AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` exits 0 with only `sorry`
warnings. If a precise signature for an intermediate lemma is genuinely hard to pin down, prefer the most
useful provable shape and leave a `-- TODO signature` note rather than an uncompilable stub — but the file
MUST compile. Report the final signatures you chose for each of the 7 decls.
