# blueprint-clean directive — ts231

A single chapter was edited this iter by the plan agent (a proof-recipe correction, not a
statement change). Clean it for blueprint purity.

## Scope
- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — specifically the blocks
  `lem:dual_restrict_iso` (~L1499–1532) whose PROOF recipe was just rewritten. Ensure:
  - No Lean syntax / tactic strings / Lean identifiers-as-prose leak into the proof body (the
    recipe is mathematical prose; `\lean{...}` / `\cref{...}` are fine).
  - No project-history / iteration narrative beyond the single short "Route note (iter-230,
    settled empirically)" justification, which is a legitimate dead-end warning — keep it concise.
  - Citation discipline: the block cites Stacks 01CR (internal hom of modules); the proof is
    project-bespoke (no external proof to quote). Verify no fabricated `% SOURCE QUOTE`.
- Do a light pass over the rest of the chapter only to catch anything egregious; do not rewrite
  unrelated blocks.

Do NOT add or remove `\leanok` / `\mathlibok` markers.
