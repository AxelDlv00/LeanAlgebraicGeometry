# Lean ↔ blueprint check — FlatBaseChange (iter-015)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

This iter the prover worked the "mate seam" cascade. It added a leg-identification
scaffold inside the body of `base_change_mate_fstar_reindex` (Seam 2) but did NOT close
its `sorry`. Seams remaining as `sorry`: `base_change_mate_fstar_reindex` (Seam 2),
`base_change_mate_gstar_transpose` (Seam 3), `affineBaseChange_pushforward_iso`,
`flatBaseChange_pushforward_isIso` (FBC-B).

Report: (a) does the Lean follow the chapter — any fake/placeholder statements, signature
mismatches with `\lean{...}` pins, proof divergence; (b) is the chapter detailed enough to
have guided the seam proofs (does it actually contain the Seam 2/3 proof sketches with
correct `\uses{}`)? Flag any `\lean{...}` pin pointing at a renamed/absent declaration.
List coverage (decls in Lean vs blueprint).
