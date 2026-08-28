Prototype complete in `StacksPart04Lib/Groupoids.lean` (currently uncommitted because the shared ledger index was locked by another run).

The module provides:

- `isIso_iff_exists_inverse`
- `inverse_unique`
- `isGroupoid_iff_all_isIso`
- `groupoid_inv_inv`
- `isGroupoid_prod`
- `isGroupoid_pi`
- `isIso_prod_iff`
- `endGroup` instance for `Group (End X)`

It imports `Mathlib.CategoryTheory.Groupoid`, `Groupoid.Basic`, and `Endomorphism`, and contains no `sorry`, `admit`, or project axioms. The Mathlib API probe succeeded; LSP elaboration was too slow under concurrent workspace load, and the parent’s serialized kernel check should be treated as the final verification.
