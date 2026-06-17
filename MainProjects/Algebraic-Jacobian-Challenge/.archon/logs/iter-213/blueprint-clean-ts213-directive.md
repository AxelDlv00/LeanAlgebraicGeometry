# Blueprint Clean Directive

## Chapter to clean
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Context
This chapter was just rewritten by blueprint-writer ts-routec213: the proof of
`lem:tensorobj_assoc_iso` was changed from the (false) flat-whiskering route to "route (c)"
(local-on-cover injectivity of the whiskered sheafification unit, scoped to `IsLocallyTrivial`);
a new bridge lemma `lem:isiso_sheafification_map_of_W` was added; `lem:flat_whisker_localizer`
was annotated off-critical-path with the `W_whiskerRight_of_flat` pin added; a forward note was
added to `lem:tensorobj_isoclass_commgroup`; and several motivation/survey/consistency sections
were realigned to the route-(c) narrative.

## Task
Standard post-writer purity pass on THIS chapter only:
- Strip any Lean tactic syntax / code leakage that crept into prose (the math must be
  textbook-level prose, not Lean).
- Remove project-history / iteration-narrative verbosity (e.g. "iter-212", "the prover found",
  task-result references inside prose) — these belong in sidecars, not the blueprint.
- Verify the chapter has no dangling references to the now-deleted "Flatness is free" step or the
  stale iter-212 `% NOTE:` block (the writer reports deleting them; confirm none remain).
- Validate citation discipline: any `% SOURCE QUOTE:` must be verbatim from a real local file. The
  route-(c) argument is project-bespoke (no external quote needed); do NOT fabricate one. If you
  find a `% SOURCE:` line whose quote is missing or not verbatim, either fix it from the named
  local file or flag it.
- Do NOT change the mathematical content of the route-(c) proof or the new bridge lemma.
- Do NOT add or remove `\leanok` / `\mathlibok` markers.

## Out of scope
- Any other chapter.
- The Lean files.
