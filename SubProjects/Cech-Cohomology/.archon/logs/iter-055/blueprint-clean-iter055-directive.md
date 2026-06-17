# Blueprint-clean directive — iter-055

A blueprint-writer round just edited `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`,
adding the Sub-brick A `\uses`-chain (7 blocks + `lem:isZero_homology_of_homotopy_id_zero`), 5 new
`\mathlibok` Mathlib anchors, and 4 coverage-debt helper blocks for OpenImmersionPushforward.

Purify this chapter: strip any leaked Lean tactic syntax, project/iteration history, or verbosity from
the prose of the NEW/EDITED blocks; ensure every external citation has its verbatim `% SOURCE QUOTE` (the
new sub-lemmas are Archon-original project infra and need NO source — do not fabricate one); confirm the
informal proofs read as mathematics, not Lean. Do NOT touch `\leanok`/`\mathlibok` markers. Do NOT change
any `\lean{}`/`\label{}`/`\uses{}` wiring (the leandag graph is already consistent: `unknown_uses = 0`).
Validate LaTeX balance.
