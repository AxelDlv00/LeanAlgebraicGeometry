# Blueprint-clean directive — iter-216

Post-writer purity pass on `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, which received
three writer rounds this iter (ts216/b/c): the associator `lem:tensorobj_assoc_iso` was re-routed to
a direct gluing construction; `lem:tensorobj_restrict_iso` Step 3 reduced to an H1-only residual with
a free-cover make-or-break; seven route-(e) blocks marked superseded; `lem:tensorobj_isoclass_commgroup`
reframed as a by-hand CommGroup (NOT `Skeleton`); a new `lem:restrictscalars_ringiso_tensorequiv` block
pinned.

Tasks:
- Strip any Lean tactic syntax / code leakage that crept into the rewritten prose.
- Remove project-history / per-iter verbosity ("iter-NNN", attempt narrative) from the chapter prose.
- Verify every `% SOURCE:`/`% SOURCE QUOTE:` block is intact and matches its claim; the
  `Mathlib/RingTheory/PicardGroup.lean` quote added by ts216c should be verbatim from that file.
- Ensure LaTeX environments are balanced and `\cref`/`\uses` targets resolve within the chapter.
- Do NOT touch `\leanok`/`\mathlibok`. Do NOT alter mathematical content.
