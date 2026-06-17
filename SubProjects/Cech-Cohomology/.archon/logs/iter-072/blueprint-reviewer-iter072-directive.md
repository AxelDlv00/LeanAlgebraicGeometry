# blueprint-reviewer directive — slug iter072

Standard whole-blueprint audit (read every chapter under `blueprint/src/chapters/`).

Context for the gate: the active prover lane is
`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`, covered by the consolidated
chapter `Cohomology_CechHigherDirectImage.tex`. That chapter received: (a) an effort-breaker
decomposition of `lem:coreIso_comm` into `lem:coreIso_comm_leg` → `lem:coreIso_comm_coface` →
`lem:coreIso_comm_sum` (this iter), and (b) `sectionCechAugV` blocks from a blueprint-writer
(iter-070). Check in particular that the new chain's statements/proofs/`\uses{}` are complete,
correctly wired (statement-level `\uses` carry the proof deps), and that
`lem:cechSection_contractible` remains adequate. Also confirm `lem:cech_acyclic_affine` no
longer references the deleted Lean decl `AlgebraicGeometry.CechAcyclic.affine` in its `\lean{}`.

Report per-chapter checklist + must-fix findings as usual.
