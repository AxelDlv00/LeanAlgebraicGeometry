The opaque `Prop` wrapper retry failed at the same dependent instance boundary and was preserved as Horizon attempt `0001-opaque-overlap-glued-map-prop-wrapper-still-fail`.

The file is restored to the verified generic-only state:

- LSP diagnostics clean.
- Standalone Lean exits 0.
- `nestedPullbackFlatteningIso` uses exactly `[propext, Classical.choice, Quot.sound]`.
- No commit or unrelated edits.
