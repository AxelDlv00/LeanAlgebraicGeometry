Read-only API survey completed. Main reusable declarations are in mathlib and Stacks Part 02:

- Affine spectrum wrappers already in Hartshorne:
  - [`Chapter1Spectrum.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1Spectrum.lean:20)
  - `Hartshorne.AffineSpectrum R := PrimeSpectrum R`
  - `spectrumZeroLocus`, `spectrumBasicOpen`, membership/complement lemmas, `spectrumBasicOpen_mul`, basis and continuity wrappers.
  - `coordinateRingSpectrumMap`, `coordinateRingSpectrumMap_range`, `coordinateRingSpectrumMap_isClosedEmbedding`.

- Stacks wrappers:
  - [`AffineBasics.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/AffineBasics.lean:20)
  - `mem_standardOpen_iff`, `standardOpen_*`, `standardOpen_isTopologicalBasis`, `continuous_spectrum_comap`, `spectrum_comap_preimage_standardOpen`, composition lemmas.
  - [`AffineOpens.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/AffineOpens.lean:22)
  - `scheme_affine_opens_is_basis`, `scheme_affine_opens_iSup_eq_top`, `scheme_standardOpen_isAffineOpen`.
  - [`Schemes.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/Schemes.lean:20)
  - `scheme_exists_local_affine`, `openSubscheme`, `openSubschemeι`, range/preimage lemmas, stalk-locality and stalk-map composition.

Core mathlib APIs:

- `AlgebraicGeometry.Spec R : Scheme`, `Spec.map`, `Scheme.Spec : CommRingCatᵒᵖ ⥤ Scheme`; see `Mathlib/AlgebraicGeometry/Scheme.lean` lines 482 onward.
- Global sections notation is `Γ(X, U)`. For `f : X ⟶ Y`:
  - `f.app U : Γ(Y,U) ⟶ Γ(X, f ⁻¹ᵁ U)`
  - `f.appTop`
  - `f.appLE U V (e : V ≤ f ⁻¹ᵁ U)`
  - `f.stalkMap x`
  - `Scheme.Hom.naturality`, `appLE_map`, `map_appLE`, `app_eq_appLE`, `Scheme.comp_app`, `Scheme.appLE_comp_appLE`.
- Scheme/stalk identities:
  - `Scheme.germ_stalkMap`, `Scheme.germ_stalkMap_apply`
  - `Scheme.stalkMap_id`, `Scheme.stalkMap_comp`
  - `Scheme.SpecMap_stalkMap_fromSpecStalk`, `Scheme.Spec_stalkClosedPointTo_fromSpecStalk`
  - [`GammaSpecAdjunction.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/GammaSpecAdjunction.lean:402)
  - `Scheme.toSpecΓ`, `Scheme.toSpecΓ_naturality`, `Scheme.toSpecΓ_preimage_basicOpen`, `Scheme.ΓSpecIso`, `Spec.map_injective`.

Structure sheaf/localization APIs:

- [`StructureSheaf.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/StructureSheaf.lean)
  - `StructureSheaf.structureSheafInType`
  - `StructureSheaf.structurePresheafInCommRingCat`
  - `StructureSheaf.const`, `const_apply`, `exists_const`, `res_apply`
  - `StructureSheaf.toOpenₗ`
  - `StructureSheaf.toBasicOpenₗ`, `toBasicOpenₗ_mk`, `toBasicOpenₗ_injective`, `toBasicOpenₗ_surjective`
  - `StructureSheaf.isUnit_basicOpen`
  - `StructureSheaf.stalkIso` / `stalkIsoₗ`
  - `StructureSheaf.localizationtoStalkₗ`, `stalkToLocalizationₗ`
  - `StructureSheaf.germ_stalkToLocalizationₗ`
  - `StructureSheaf.stalkToFiberRingHom_localizationToStalk`
  - `StructureSheaf.localizationToStalk_stalkToFiberRingHom`
  - instance `IsLocalization.Away f Γ(R, basicOpen f)`
  - `StructureSheaf.commRingCatStalkEquivModuleStalk`.

The most useful exact localization theorem for Hartshorne II.2 is:

```lean
instance (f : R) : IsLocalization.Away f Γ(R, PrimeSpectrum.basicOpen f)
```

and for stalks:

```lean
StructureSheaf.stalkIso R R x :
  (structurePresheafInModuleCat R R).stalk x ≅
    ModuleCat.of R (LocalizedModule x.asIdeal.primeCompl R)
```

Compatibility caveats:

- Mathlib’s canonical affine object is `Spec (CommRingCat.of R)` for a ring `R`; avoid confusing it with `PrimeSpectrum R`.
- `Scheme` morphisms are contravariant on sections: `f.app U` maps target sections to source sections.
- `Scheme.stalkMap x` similarly maps `𝒪_{Y,f(x)} → 𝒪_{X,x}`.
- Stacks Part 02 wrappers are not currently imported by Hartshorne and appear project-local; Hartshorne can directly use the underlying mathlib APIs or duplicate only tiny source-facing wrappers in its own library.
- The AJCR rebuild has a useful higher-level example in [`TangentStalkAlgebra.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Tangent/TangentStalkAlgebra.lean:65): `stalkStructureHom`, `fromSpecStalk_comp_eq`, and `comp_eq_spec_iff_of_base_eq`, but importing MainProjects into Hartshorne would violate project boundaries; use it as an API-shape reference only.
