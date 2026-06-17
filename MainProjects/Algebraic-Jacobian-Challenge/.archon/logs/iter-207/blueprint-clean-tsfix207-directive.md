# blueprint-clean — tsfix207

Post-writer purity + consistency gate on ONE chapter:
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (just rewritten by
blueprint-writer tsfix207: F1 proof rewrite of `lem:tensorobj_restrict_iso`,
new `lem:restrictscalars_laxmonoidal`, M2–M4 scope fixes).

## Standard pass
- Strip any Lean tactic syntax / code leakage, project-history verbosity, and
  any non-mathematical narration that crept in.
- Validate environments balanced and cross-refs resolve in-chapter.
- Insert any missing source quotes only where a `% SOURCE:` exists without a
  `% SOURCE QUOTE:` (do not invent citations).
- Do NOT touch `\leanok`/`\mathlibok` markers.

## Targeted consistency fix (writer-flagged)
The corrected route makes flatness only UPGRADE an abstractly-constructed
comparison map `δ` (from `leftAdjointOplaxMonoidal`) to an iso — it is NOT a
standalone "elementary flat-exactness" closure. Two out-of-scope spots still
carry the OLD framing and now contradict the proof of `lem:tensorobj_restrict_iso`;
align them (concise edits, preserve the section's purpose):
1. Motivation section (`sec:tensorobj_motivation`): the sentence ending
   "...for line bundles, which are flat, that compatibility is elementary
   flat-exactness, not internal-hom machinery."
2. API survey (`sec:tensorobj_api_survey`): "...and for line bundles it is
   elementary flat-exactness already available in Mathlib." AND the LOC-estimate
   Piece 2 bullet describing `tensorObj_restrict_iso` as purely "elementary
   flat-exactness".
For each: reframe to "the comparison map is the oplax `δ` of the left adjoint
(`leftAdjointOplaxMonoidal`, present in Mathlib) applied to the pullback–pushforward
adjunction, with the sole project-side ingredient the sectionwise
`(restrictScalars φ).LaxMonoidal` instance; flatness of line bundles then makes `δ`
an isomorphism." Keep it brief — one or two sentences each.

You may spawn a reference-retriever if a missing source quote needs fetching
(write-domain authorizes `references/**`); otherwise no new sources.
