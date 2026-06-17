# Blueprint-clean directive — FBC chapter (post-writer)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (ONLY this chapter).

## Context
A blueprint-writer round (`fbc-seams2`) just expanded the Seam-2 / Seam-3 proof sketches and pinned
`lem:pullbackPushforward_unit_comp` + 3 Mathlib `\mathlibok` anchors. Ensure blueprint purity:
- Strip any leaked Lean tactic syntax / Lean-name-as-prose from the new prose (Lean names belong only
  inside `\lean{...}` pins and `% comments`, not in rendered math prose).
- Confirm the 3 Mathlib anchors carry `\mathlibok` + `\lean{}` and no spurious `% SOURCE`.
- Verify all `% SOURCE QUOTE` material that already exists is preserved verbatim (do not touch the
  Stacks/02KH quotes elsewhere in the chapter).
- Keep `\leanok` markers untouched (deterministic sync owns them).
- Do NOT alter mathematical content; this is a purity/hygiene pass only.
