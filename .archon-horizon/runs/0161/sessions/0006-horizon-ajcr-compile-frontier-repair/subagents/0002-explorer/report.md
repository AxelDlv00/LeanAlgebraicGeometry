Read-only sibling audit complete. The sibling AJC project has no finite-stage Pic0 gluing package/diagram analogue; its closest reusable declarations are:

- `FiniteGaloisQuotientAffine.specMap_algHom_comp`, `pullbackBaseChange_comp/congr`, and `pullbackSpecLIso` projection/naturality lemmas.
- `RigidPushforwardChartBaseChange.exists_chartTensorEquiv`, which explicitly names all `Algebra` and `IsScalarTower` instances before tensor construction.
- `Cohomology/FlatBaseChange.baseChangeCancelModuleIso`, with fully explicit `@IsScalarTower` and `@Algebra.IsPushout` instance arguments.
- `Albanese/TensorPowerCofan.algHomOfMkUnderHom`, documenting and solving the `CommRingCat.toAlgHom` versus ambient `Algebra` instance mismatch.
- `GlueDescent.pullbackBaseChangeTransport` and `GaloisQuotientOverlap`’s staged triple-to-pair projection helpers.

I sent the parent concrete file/line references and recommended extracting the C,U,V-only atlas projection into a generic private helper, following the sibling naturality patterns.
