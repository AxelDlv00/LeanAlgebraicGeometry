Implemented and committed the line-bundle substrate in `HartshorneLib/Chapter2LineBundles.lean`.

Commit: `06c599bec38c8e7938b8ff1b2ec49bcb38e7176f`

Declarations:
- `Hartshorne.IsLineBundle`
- `Hartshorne.IsLineBundle.of_iso`
- `Hartshorne.isLineBundle_iff_of_iso`

Verification:
- `lake env lean HartshorneLib/Chapter2LineBundles.lean` passed.
- `lean_verify Hartshorne.IsLineBundle` found only standard axioms (`propext`, `Classical.choice`, `Quot.sound`).
- No `sorry`, `admit`, or project axioms.
- Root `HartshorneLib.lean` was intentionally left untouched for the parent to import.
