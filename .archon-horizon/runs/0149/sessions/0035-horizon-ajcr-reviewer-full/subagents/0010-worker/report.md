Composite overlap route rejected and saved as Horizon attempt `0004-composite-source-overlap-package-is-lsp-clean-bu`.

Standalone Lean failed after about 25 minutes on dependent `CommRing`/`Algebra P.N.1` reconstruction for the chart base-change alias, then hit the 12.8M heartbeat limit. I restored the generic-only module.

Verified restored state:

- LSP diagnostics: clean
- `lake env lean ...Pic0FiniteStageOverlapBaseChange.lean`: exit 0
- `nestedPullbackFlatteningIso` axioms: `[propext, Classical.choice, Quot.sound]`
- Source warnings: none
