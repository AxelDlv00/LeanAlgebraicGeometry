# Blueprint-clean directive — iter-235

## Scope
One chapter was edited this iter by the blueprint-writer `d2-linmap`:
- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

A single new statement-only lemma block `lem:stalk_tensor_linear_map`
(`\lean{PresheafOfModules.stalkTensorLinearMap}`) was inserted between
`lem:stalk_tensor_desc_forward` and `lem:islocallyinjective_whiskerleft_via_stalk`
(~line 2036). It is an Archon-original partial-construction pin (correctly carries no
`% SOURCE` citation, modelled on the sibling forward-map block).

## Task
Validate blueprint purity of the edited chapter, focused on the new block:
- Strip any Lean tactic syntax / Lean-leakage if present (prose should be math, project notation).
- Confirm the new block carries NO `\leanok`/`\mathlibok` (the writer flagged it removed an
  accidental `\leanok`; verify none remains — markers are sync_leanok/review-owned).
- Confirm the existing verbatim Stacks `% SOURCE QUOTE` on `lem:stalk_tensor_commutation` remains
  byte-intact (do not let any reflow touch it).
- Remove project-history verbosity only if newly introduced; do NOT delete the pre-existing
  `% NOTE:` annotations on the `stalkTensorIso` pin (they are correct build-state documentation).
- You MAY spawn a reference-retriever only if you find a citation needing a source not in references/
  (not expected — the new block is uncited Archon-original).

Out of scope: the dead duplicate whisker lemma and route-(e) apparatus (deferred structural cleanup,
not this iter's concern).
