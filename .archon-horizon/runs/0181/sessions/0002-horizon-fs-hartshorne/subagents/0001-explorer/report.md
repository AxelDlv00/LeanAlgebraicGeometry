## Audit

- Hartshorne currently has 12 Lean modules (~1,020 LOC); the import graph is acyclic and build-oriented.
- Proof-hole scan over `HartshorneLib/**/*.lean`: zero `sorry`, `admit`, `axiom`, or `unsafe` occurrences.
- Hgraph has 100 generated Lean nodes, all `lean_ok`; 499 frozen blueprint nodes remain `empty`/unlinked.
- Full `lake build HartshorneLib` and project-scoped `horizon check HartshorneLib --json` passed (`2075 jobs`, no warnings) before the latest Spectrum working-tree edits.
- `#print axioms` scan of the existing declarations, plus verification of the new prime-characterization theorem, found only standard Lean axioms: `propext`, `Classical.choice`, `Quot.sound`.
- Current HORIZON_GIT status has only the parent’s `Chapter1Prime.lean` and `Chapter1Spectrum.lean` edits; I made no source changes.

## Independent Target

`HartshorneLib/Chapter1CoordinateRing.lean`, immediately after `coordinateRingMk_ker` (around lines 103–116):

```lean
theorem coordinateRingMk_surjective (Y : Set (AffinePoint k n)) :
    Function.Surjective (coordinateRingMk k n Y).toRingHom := by
  simpa [coordinateRingMk] using
    (Ideal.Quotient.mkₐ_surjective k (vanishingIdeal k n Y))
```

The standalone MCP check compiles this theorem and reports only the standard axioms. It directly removes duplicated surjectivity proofs in `Chapter1Spectrum.lean:135–137` and `:143–145`, and does not conflict with the current Spectrum/Prime edits.

Current graph metadata is behind the source by five declarations (`commonZeroSet_vanishingIdeal_eq_self` and the four new Spectrum wrappers); run graph sync after those edits are committed.
