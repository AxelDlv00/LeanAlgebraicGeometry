# Lean-vs-blueprint — FlatteningStratification (iter-054)

File: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean`
Chapter: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex`

Bidirectional check. Focus on the new B2 chain: `gf_crossChart_basicOpen_eq` (B2.1),
`gf_section_localization_twoleg` (B2.2), `gf_base_localization_comparison` (B2.3),
`gf_crossChart_spanning_cover` (B2.4), helper `gf_common_basicOpen_basis` (sorry), and
`genericFlatness` (sorry). Known issue to confirm: the prover reports the blueprint's
"restriction-matched pair (g|_O = ḡ|_O)" invariant for `lem:gf_crossChart_spanning_cover` /
`lem:gf_section_localization_twoleg` is NOT what the Lean proves — Lean uses basic-open equality
`X.basicOpen g = X.basicOpen ḡ`. Verify and report the mismatch direction. Also report any
unblueprinted new helper.
