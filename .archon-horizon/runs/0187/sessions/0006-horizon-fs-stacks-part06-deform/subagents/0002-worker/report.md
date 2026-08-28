Implemented and committed `da28a894b0`.

Added [TangentModule.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part06_DeformationTheory/StacksPart06Lib/TangentModule.lean), defining:

- `ProductPreservingTestFunctor`
- `TangentModuleData`
- `TangentModuleData.smul_add`, `.add_smul`, `.one_smul`
- `TangentModuleMorphism`
- `TangentModuleMorphism.tangentLinear_apply`, `.map_add`, `.map_smul`

Also imported it through `StacksPart06Lib.lean`. LSP diagnostics are clean, and `horizon check --lean StacksPart06Lib/TangentModule.lean` passed. No blueprint files were changed.
