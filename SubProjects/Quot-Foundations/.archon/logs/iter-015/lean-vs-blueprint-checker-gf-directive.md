# Lean ↔ blueprint check — FlatteningStratification (iter-015)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

This iter the prover added a NEW helper `free_localizationAway_of_away_tower`
(descent of generic freeness across a tower of `Away` localisations) — it is itself a
`sorry` carrying a detailed proof plan, and `exists_free_localizationAway_polynomial` (L5)
now reduces to an IH+descent step that is still `sorry`. No `sorry` was closed this iter.

Report: (a) does the Lean follow the chapter — is the new `free_localizationAway_of_away_tower`
helper backed by a blueprint declaration with `\uses{}` (it currently has NO blueprint
entry — confirm), are there signature mismatches / placeholder statements; (b) is the
chapter detailed enough — does it carry the tower-descent step and the L5 IH+descent
assembly at a level that could guide formalization? Flag the missing blueprint coverage for
the new helper. List coverage. Note: a known cold-compile heartbeat fragility exists near
L1146 (builds green under `lake build`).
