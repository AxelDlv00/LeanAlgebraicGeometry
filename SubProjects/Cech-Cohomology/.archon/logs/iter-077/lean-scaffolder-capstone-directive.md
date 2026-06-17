Create NEW file: AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean

Purpose: the downstream leaf hosting the Route-A capstone, built under the CORRECT hypotheses
(the frozen `cech_computes_higherDirectImage` is false as signed — escalated; this aux file is the
true theorem the mathematician will wire to). Blueprint chapter:
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (blocks at L11819, L11845, L11885, L11926).

Imports (these three project modules; add `import Mathlib` if needed for compilation):
  AlgebraicJacobian.Cohomology.CechAugmentedResolution
  AlgebraicJacobian.Cohomology.OpenImmersionPushforward
  AlgebraicJacobian.Cohomology.AcyclicResolution
Match the namespace/section/variable conventions of `CechHigherDirectImage.lean`
(`namespace AlgebraicGeometry`, `variable {X S : Scheme.{u}}`, `open …`). If the project has an
aggregate root that imports every module (e.g. `AlgebraicJacobian.lean`), add this module there too.

Generate these declarations, ALL with `sorry` bodies (NO proofs) and a rich
`/- Planner strategy: <blueprint label> · <recipe> -/` comment above each:

1. `rightAcyclic_finite_prod` (blueprint `lem:rightAcyclic_finite_prod`) — a finite product of
   right-`G`-acyclic objects is right-`G`-acyclic, for an additive `G` between abelian categories with
   enough injectives. Pick the precise Mathlib form (`Functor.IsRightAcyclic`; product `∏ᶜ`/biproduct).
   If Mathlib already provides this, still create a project alias/anchor so the `\lean{}` pin resolves.

2. `cechTerm_pushforward_acyclic` (blueprint `lem:cech_term_pushforward_acyclic`) — signature:
   `[HasInjectiveResolutions X.Modules] (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated]
   (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) (F : X.Modules)
   (hF : F.IsQuasicoherent) (p : ℕ)` concluding
   `(Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X p)`
   (equivalently `∀ k ≥ 1, IsZero (((pushforward f).rightDerived k).obj ((cechComplexOnX 𝒰 F).X p))` —
   choose the form P4 `rightDerivedIsoOfAcyclicResolution` consumes as its `[∀ n, IsRightAcyclic (K.X n)]`).

3. `pushforward_mapHomologicalComplex_cechComplexOnX` (blueprint `lem:pushforward_mapHC_cechComplexOnX`)
   — `noncomputable def`, signature `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules)` concluding
   `((Scheme.Modules.pushforward f).mapHomologicalComplex (ComplexShape.up ℕ)).obj (cechComplexOnX 𝒰 F)
   ≅ CechComplex f 𝒰 F`.

4. `cechAugmented_to_acyclicResolutionInput` (blueprint `lem:cechAugmented_to_acyclicResolutionInput`)
   — `noncomputable def` taking the same hyps as `cechAugmented_exact`
   (`(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated] (F : X.Modules)
   (hF : F.IsQuasicoherent)`) and PRODUCING the pair P4 needs:
   `(F ≅ (cechComplexOnX 𝒰 F).cycles 0) × (∀ n, (cechComplexOnX 𝒰 F).ExactAt (n+1))`
   (a product/structure is fine — one declaration carrying the pinned name).

5. `cech_computes_higherDirectImage_of_affineCover` (blueprint `lem:cech_computes_cohomology_affineCover`)
   — `theorem`, signature = the frozen `cech_computes_higherDirectImage` signature PLUS the two added
   hyps: `[HasInjectiveResolutions X.Modules] (f : X ⟶ S) [QuasiCompact f] [IsSeparated f]
   [X.IsSeparated] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) (F : X.Modules)
   (hF : F.IsQuasicoherent) (i : ℕ)` concluding
   `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`.

Verify: run `lake build AlgebraicJacobian.Cohomology.CechToHigherDirectImage`; it must compile (only
`sorry` warnings). Report the build result (this warms the olean chain). You MAY verify Mathlib names
with the Lean tools. Do NOT attempt any proof. Do NOT touch `CechHigherDirectImage.lean` or the frozen
declaration. Do NOT edit blueprint files.
