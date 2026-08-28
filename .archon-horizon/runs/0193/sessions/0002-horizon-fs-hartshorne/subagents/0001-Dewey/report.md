Implemented and committed the Chapter II ringed-space unit.

- Commit: `0632de85825a28966e1e8abf18a5074aa2cd946d`
- File: `HartshorneLib/Chapter2Sheaves.lean`
- Added ringed/local-ringed space aliases, structure-sheaf morphisms, continuity, local stalk and stalk-map results, and identity/composition laws.
- `horizon check --lean HartshorneLib/Chapter2Sheaves.lean` passed.
- Axiom scans report only `propext`, `Classical.choice`, and `Quot.sound`.
- No `sorry`, `admit`, or project axioms.
- Blueprint untouched; unrelated concurrent Hartshorne edits preserved.
