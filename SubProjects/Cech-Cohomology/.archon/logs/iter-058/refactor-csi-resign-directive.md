# Refactor directive — re-sign CechSectionIdentification Stubs 5/6 to the AUGMENTED target

## File (only)

`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`

## Problem (must-fix, from lean-auditor + lean-vs-blueprint-checker, iter-057)

The two declarations
- `cechSection_complex_iso` (currently line ~410, conclusion `D ≅ D'`)
- `cechSection_contractible` (currently line ~475, conclusion `Homotopy (𝟙 D') 0`)

carry **provably-false** type signatures. `D` is the evaluated *augmented* Čech section complex
(`D.X 0 = Γ(V,F)`), but `D' = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp` is the
*non-augmented* complex (`D'.X 0 = ∏_i Fp(coverOpen 𝒰 i ⊓ V) ≠ Γ(V,F)`). So `D ≅ D'` is false, and
`Homotopy (𝟙 D') 0` is false (a one-member cover gives `H⁰(D') = Fp(V) ≠ 0`). The blueprint was
already corrected (iter-056) to the AUGMENTED target `D'_aug := D'.augment ε hε`; the Lean was not.
An excuse-comment block at lines ~332–366 documents the falseness and leaves the stubs in place.

Neither declaration is consumed in code anywhere (CechSectionIdentification is imported by no file;
`CechAugmentedResolution` references the two names only inside comments). So this is a pure re-sign,
no downstream build to keep green beyond this file.

## Required change

Re-sign both declarations to the **augmented** target, parametrizing the augmentation so no proof
obligation (`hε`) is introduced as a sorry:

1. Introduce, in scope above the two declarations, a helper for the non-augmented complex so its
   degree-0 object and first differential can be named, e.g.
   ```
   /-- The concrete (non-augmented) section Čech complex over `V` for the restricted cover. -/
   noncomputable abbrev sectionCechComplexV (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
       (F : X.Modules) (V : TopologicalSpace.Opens X) : CochainComplex AddCommGrpCat ℕ :=
     sectionCechComplex (fun i : 𝒰.I₀ => coverOpen 𝒰 i ⊓ V)
       ((SheafOfModules.forget X.ringCatSheaf).obj F)
   ```
   (Match the exact `Fp`/`D'` expression already used in the current stub bodies — copy it verbatim
   from the existing `let D' := …` so the abbreviation is definitionally the same complex.)

2. **`cechSection_complex_iso`** — add two parameters
   `(ε : <Γ(V,F)> ⟶ (sectionCechComplexV 𝒰 F V).X 0)`
   `(hε : ε ≫ (sectionCechComplexV 𝒰 F V).d 0 1 = 0)`
   where `<Γ(V,F)>` is the same degree-0 object as the evaluated augmented complex `D.X 0`
   (i.e. `((SheafOfModules.forget X.ringCatSheaf).obj F).obj (op V)` / the `Fp(V)` already implicit
   in `D`). Change the conclusion from `D ≅ D'` to
   `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`. Keep the body `:= sorry`.

3. **`cechSection_contractible`** — add the same two parameters `(ε …) (hε …)`. Change the conclusion
   from `Homotopy (𝟙 D') 0` to `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`. Keep
   `:= sorry`.

   Use `CochainComplex.augment` (the prepend constructor; check its exact argument order/namespace in
   Mathlib — it is the same `augment` used by `cechAugmentedComplex` in
   `CechHigherDirectImage.lean:741`). If `augment`'s signature differs (e.g. needs the map into `X 0`
   in a specific direction), adapt the parameter type of `ε` to match what `augment` consumes, and
   adjust `hε` to the corresponding cochain condition; the goal is simply that the augmented complex
   is well-formed with `ε` as the degree-(-1→0) augmentation.

4. **Remove the excuse-comment block** at lines ~332–366 (the `⚠ PROVER FINDING … Stubs 5 and 6 are
   MIS-SPECIFIED …` `/-! … -/` section). **Preserve** the two `/- Planner strategy: … -/` blocks above
   each declaration — they remain the correct route — but update any line inside them that still says
   the target is `D ≅ D'` / `Homotopy (𝟙 D') 0` to the augmented form, and update the goal restatement
   at the top of each strategy block accordingly.

5. The file must still compile (`lake env lean`) with exactly the same set of honest sorries it had
   before plus none new: the only sorries remain the five stub bodies (Stubs 1,2,4 unchanged; Stubs
   5,6 now at the augmented type). Do NOT touch Stubs 1/2/4 or any of the proved helper declarations.

## If Option A is infeasible

If parametrizing `ε`/`hε` cannot be made to type-check cleanly in a structural pass (e.g. the
`augment` API forces data you cannot supply without a proof), then FALL BACK to: delete the two
`def cechSection_complex_iso … := sorry` and `def cechSection_contractible … := sorry` declarations
entirely along with the excuse block, leaving the `/- Planner strategy -/` comments as a
forward-reference note that they are deferred to re-formalization at the augmented type after Stub 1.
**Report clearly which option you took** so the planner can adjust the blueprint `\lean{}` pins.

Insert `sorry` only where a proof body is required; never fill a proof. Report the final signatures
of both declarations verbatim in your task result.
