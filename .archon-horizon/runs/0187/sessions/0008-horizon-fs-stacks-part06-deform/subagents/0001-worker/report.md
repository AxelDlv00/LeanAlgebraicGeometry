Added [TangentModuleFunctoriality.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part06_DeformationTheory/StacksPart06Lib/TangentModuleFunctoriality.lean), providing:

- `TangentModuleMorphism.id`
- `TangentModuleMorphism.comp`
- simp lemmas for components and tangent-linear applications

Verification passed with LSP diagnostics and:

`lake env lean StacksPart06Lib/TangentModuleFunctoriality.lean`

Ledger commit was not completed because concurrent Horizon sessions held the shared commit lock and Git hook in `folio_wait`; the new file remains uncommitted but intact.
