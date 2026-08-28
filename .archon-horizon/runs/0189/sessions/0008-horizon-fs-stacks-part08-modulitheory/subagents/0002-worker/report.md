Implemented `StacksPart08Lib/ModuliDiagonals.lean` with the exact tested categorical interface:

- `ModuliPresheaf`
- pairwise and relative diagonal properties
- pairwise-to-relative theorem
- map-pair criterion and `prod.lift` conversion
- coherent affine finite-presentation diagonal interface
- closed and closed finite-presentation Quot diagonal interfaces

Added the module import to `Basic.lean`.

Verification passed:

- `horizon check --lean ... --json`
- `lake env lean StacksPart08Lib/ModuliDiagonals.lean`
- `lake build StacksPart08Lib`
