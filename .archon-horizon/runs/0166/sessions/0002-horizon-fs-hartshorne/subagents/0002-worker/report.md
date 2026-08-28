Implemented `HartshorneLib/Chapter1Ideals.lean` with four sorry-free affine ideal laws:

- `vanishingIdeal_empty`
- `vanishingIdeal_inter_sup`
- `subset_vanishingIdeal_commonZeroSet`
- `subset_commonZeroSet_vanishingIdeal`

The module passes LSP diagnostics, `"$HORIZON_BIN" check --lean HartshorneLib/Chapter1Ideals.lean`, and direct `lake env lean` checking. No other files were modified.
