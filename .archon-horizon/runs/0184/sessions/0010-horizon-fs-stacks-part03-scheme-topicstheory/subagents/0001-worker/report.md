Implemented and committed `StacksPart03Lib/PeriodicExact.lean` in commit `efed0fef3d`.

The module provides:

- `TwoPeriodicComplex.Hom` with component maps, compatibility, identity, composition, and extensionality.
- `TwoPeriodicComplex.ShortExact` with injectivity, surjectivity, and exactness for both components.
- Finite ambient-length propagation from outer complexes to the middle complex.
- `ShortExact.multiplicity_eq_add`, proving additive integer periodic multiplicity for finite-ambient short exact sequences.

Verification passed:

- LSP diagnostics: clean.
- `lake env lean StacksPart03Lib/PeriodicExact.lean`: passed.
- `horizon check --lean .../PeriodicExact.lean --json`: passed.
- Axiom/source audit: only standard `propext`, `Classical.choice`, and `Quot.sound`; no warnings.
