Implemented and committed a sorry-free coherent-sheaf adjunction API in [Sheaf.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/Sheaf.lean).

Commit: `ade933ac2c feat(milne): expose sheaf adjunction identities`

Added evaluation/coevaluation naturality and both adjunction triangle identities. `horizon check --lean MilneLib/Sheaf.lean` passed; axiom checks found only standard Lean axioms. The concurrent `LinearAlgebra.lean` edit was left untouched.
