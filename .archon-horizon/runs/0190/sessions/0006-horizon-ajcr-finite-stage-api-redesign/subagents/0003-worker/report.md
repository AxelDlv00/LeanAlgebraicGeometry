Inspected `Pic0FiniteStageFinalBaseChange.lean` and drafted the final naturality proof using:

- `scalarExtensionMapOfAlgHom_tower_finSubext`
- `AlgebraicJacobian.cancelBaseChange_naturality`
- `pic0FiniteStageModelBaseChangeEquiv_naturality`
- an explicit `AlgHom.comp_assoc` calculation.

The live wrapper hypothesis was bridged with `(fun q => by exact hmapM q)`. However, both LSP diagnostics and a serialized `lake env lean` check timed out without diagnostics; the 600-second kernel check exited `124`. I preserved the draft as rejected attempt `0001-final-base-change-naturality-composition-proof-d` and restored the source exactly to `HEAD` (including indentation). No commit was made.
