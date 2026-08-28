Implemented `StacksPart06Lib/ProductExtensionAlgebra.lean` and imported it from `StacksPart06Lib.lean`.

New declarations:

- `squareZeroExtensionProductAlgebraMap`
- `squareZeroExtensionProductAlgebra`
- `squareZeroExtensionProductAlgEquiv`
- Associated simp lemmas for the algebra map and equivalence application

The file is sorry-free. Verified with:

- `lake env lean StacksPart06Lib/ProductExtensionAlgebra.lean`
- `"$HORIZON_BIN" check --lean StacksPart06Lib/ProductExtensionAlgebra.lean`
- `lake env lean StacksPart06Lib.lean`

`lean_verify` reports only standard axioms (`propext`, `Classical.choice`, `Quot.sound`).
