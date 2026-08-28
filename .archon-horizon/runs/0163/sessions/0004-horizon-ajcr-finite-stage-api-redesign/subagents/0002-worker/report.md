Implemented and verified the bounded tensor-equality API.

- Added `FiniteStageTensorEqualityFamilyData` with pinned `stage`, `inclusion`, `map`, `map_spec`, and transported equality.
- Added `of_raw`, `equality_apply`, and `exists_raw` adapters.
- Commits:
  - `52ecd50d9bae1beb3e60deaeb9c8d27b7e67324c`
  - `7c61668482bafda2edb5fb0ee143a77966cff51d`
- Checks passed:
  - `lake env lean AlgebraicJacobian/Picard/TensorFiniteSubextension.lean`
  - `lake env lean AlgebraicJacobian/Picard/Pic0FiniteStageDatum.lean`

The pre-existing staged deletions were preserved and kept out of these commits.
