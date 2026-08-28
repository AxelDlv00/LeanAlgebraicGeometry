Pinned Mathlib/Milne audit is complete. `lake env lean MilneLib/Tensor.lean` and the workspace build pass.

The concrete affine unit is the stalk naturality theorem:

```lean
((TopCat.Presheaf.stalkFunctor AddCommGrpCat x).map
  ((AlgebraicGeometry.tilde.functor R).map f).mapPresheaf)
  ((AlgebraicGeometry.tilde.toStalk M x).hom m)
=
(AlgebraicGeometry.tilde.toStalk N x).hom (f.hom m)
```

for `f : M ⟶ N`, `x : PrimeSpectrum.Top R`, `m : M`. It compiles using `change` to `StructureSheaf.toOpenₗ`/`germ`, `erw [TopCat.Presheaf.stalkFunctor_map_germ_apply]`, and `congrArg` applied to `AlgebraicGeometry.tilde.toOpen_map_app`. `erw` plus explicit `change` is required because `PrimeSpectrum.Top R` and the `Spec` presheafed-space wrapper are not definitionally identical enough for ordinary `rw`.

The finite affine target API is already usable:

- `MilneLib.moduleFinite_tilde_stalk` (`MilneLib/Affine.lean:59`)
- `schemeModuleStalkModule`, `schemeModuleStalkResidueTensorEquiv`, and `_mk_tmul` (`MilneLib/Tensor.lean:122`)
- `LinearMap.surjective_lTensor_residueField_iff_surjective_residue` and finite-target `..._iff_surjective` (`Tensor.lean:240`, `292`)
- `MilneLib.LinearMap.surjective_iff_surjective_residue_at_maximal` (`Localization.lean:54`)
- `schemeModule_epi_of_surjective_on_stalks` and stalkwise iso criteria (`Sheaf.lean:25`, `42`)

For a theorem stated with `F := affineModuleSheaf R M` and `x : Spec R`, include a dependent `letI := schemeModuleStalkModule F x`; otherwise elaboration fails before the proof with “failed to synthesize `Module` on the scheme stalk.”

The bounded proof path is therefore: identify the affine stalk map via the naturality theorem, use the residue tensor/quotient equivalence, apply finite-target Nakayama locally, then invoke `schemeModule_epi_of_surjective_on_stalks`. However, pinned Mathlib has no theorem turning an arbitrary coherent sheaf into finite stalk modules, and no direct theorem identifying a user-facing scheme-module residue fibre with the tensor quotient. Consequently I.5.11 should remain partial beyond finite affine modules plus generic stalkwise epi/isomorphism criteria. Remote-search names such as `ModuleCat.Tilde.stalkIso`, `stalkToFiberLinearMap`, and `localizationToStalk` are absent from the pinned version.
