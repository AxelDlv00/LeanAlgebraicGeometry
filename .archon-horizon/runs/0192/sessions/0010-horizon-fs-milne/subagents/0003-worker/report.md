Implemented and committed `isIntegral_of_retract` in `MilneLib/GroupScheme.lean` after `eq_comp_of_isAffine_of_properIntegral`.

The proof follows the sibling Mumford API: retraction surjectivity on points, irreducibility transfer, injectivity of stalk maps, reducedness of `S`, and final integrality. LSP diagnostics, `lake env lean MilneLib/GroupScheme.lean`, and focused Horizon checking all pass.

Commit: `27da3b89c388df9f2bf42bfd475fb9cd68f25fb0`
