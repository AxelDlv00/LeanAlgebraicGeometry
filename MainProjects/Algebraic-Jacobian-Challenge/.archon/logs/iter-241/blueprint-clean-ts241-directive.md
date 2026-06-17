# blueprint-clean directive — iter-241

## Chapters edited this iter (clean these two)
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — writer `tensorobj-pins` added two pinned
   coherence sub-lemmas (`lem:unitToPushforwardObjUnit_comp`, `lem:pullbackObjUnitToUnit_comp`) before
   `lem:pullback_unit_iso` and revised that lemma's proof sketch.
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — writer `fbc-natiso` added an UNPINNED
   naturality block (`lem:gammaPushforwardIsoAt_naturality`) and rewrote the
   `lem:pushforward_spec_tilde_iso` proof sketch (movements 1–3) + updated the `% NOTE`.

## What to enforce
- **Math-only purity**: strip any Lean tactic syntax, `infer_instance`/instance-synthesis plumbing
  talk, iter/attempt history, or "the prover should…" meta-prose that leaked into the new/edited
  blocks. Prose must read as textbook mathematics.
- **Source-quote integrity**: the two chapters carry existing Stacks/EGA `% SOURCE QUOTE` comments —
  verify they are byte-intact and were not disturbed. The new blocks are Archon-original (no source
  lines expected); confirm none was fabricated.
- **No dangling refs / no cycles**: confirm every `\uses{}`/`\cref{}`/`\ref{}` introduced this iter
  resolves to a label that exists (the new labels `lem:unitToPushforwardObjUnit_comp`,
  `lem:pullbackObjUnitToUnit_comp`, `lem:gammaPushforwardIsoAt_naturality` are all defined in their
  own chapters). Check no `\uses` cycle was created.
- **Do NOT add/remove `\leanok` or `\mathlibok`.** Leave `lem:gammaPushforwardIsoAt_naturality`
  unpinned (no `\lean{...}`) — that is intentional.
- Trim verbosity only where it does not remove mathematical content.

Write-domain: the two chapter files above + `references/**` (in case a missing source quote must be
retrieved — not expected this iter).
