# Blueprint Writer Report

## Slug
ts216b

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
All four directed edits are prose demotions/redirections only. No declaration
blocks, `\lean{...}` hints, `\uses{...}` sets, `\leanok`, or `\mathlibok` markers
were altered, and the four load-bearing lemma blocks
(`lem:tensorobj_assoc_iso`, `lem:tensorobj_restrict_iso`,
`lem:tensorobj_isoclass_commgroup`, `lem:restrictscalars_ringiso_tensorequiv`) were
left untouched. No external-source-derived content was added, so no new `% SOURCE`
citations were written; the existing Kleiman/Mathlib source quotes were left intact.

- **Revised** `sec:tensorobj_motivation` — the two paragraphs that presented
  "the entire monoidal scaffolding ... task is to instantiate it" and "the
  monoidal structure ... is free from this API once `J.W.IsMonoidal` is supplied"
  are reframed: the full-monoidal-category / `LocalizedMonoidal` route is stated as
  *conceivable but not the goal and not pursued*. The goal is now stated as the
  commutative GROUP on locally-trivial iso-classes (à la `CommRing.Pic`), needing
  only existence of the three coherence isos, which are produced directly
  (associator by gluing via `lem:tensorobj_restrict_iso`; unitors/braiding by
  `mapIso`). Closes with: the whole `LocalizedMonoidal` / `J.W.IsMonoidal` / stalk
  apparatus is vestigial and off the critical path.
- **Revised** `sec:tensorobj_api_survey` (three sub-edits):
  - Section opener: relabels route~(e) as the *original* route, now *superseded*;
    the survey is retained as a Mathlib-API reference documenting why the route is
    vestigial.
  - "The gap and route~(e)" paragraph → "The gap and route~(e), superseded":
    removes the "sole genuinely-new obligation" framing; states the group law is
    realized through the direct-gluing associator and never invokes
    `J.W.IsMonoidal` / a coherent monoidal category / the whiskering apparatus.
  - Stalk-infrastructure paragraph: reframed as "recorded here for reference only,
    since that route is superseded"; the "must still be built project-side" /
    "Once `J.W.IsMonoidal` lands ... free from (ii)" promotion is replaced by an
    explicit off-critical-path statement. The `\cref{lem:stalk_linear_map}`
    cross-reference is preserved.
- **Revised** `rem:scheme_modules_monoidal_off_path`:
  - Title changed from "The full monoidal category is cheap via route~(e); ..." to
    "The full monoidal category on all of `Scheme.Modules X` is off-path; the group
    law consumes only propositions".
  - Paragraph 1: "Under route~(e) this is cheap, not expensive" → "explicitly
    off-path and not pursued"; `LocalizedMonoidal` kept only as an in-principle
    possibility that is "superseded and not carried out".
  - Paragraph 2: rephrased conditionally ("Were that superseded route pursued ...")
    and closed with "this apparatus is not on the critical path at all".
  - Paragraph 3: "all now supplied by the route~(e) monoidal structure" → "supplied
    directly" (associator by gluing via `lem:tensorobj_restrict_iso`,
    unitors/braiding by `mapIso`); the closing "here over the sheafification
    localizer via `LocalizedMonoidal`" → "here over iso-classes of the substrate
    tensor `⊗_X`". The `CommRing.Pic` mirror sentence is retained.
- **Revised** proof of `lem:tensorobj_unit_iso` — dropped the alternative clause
  "equivalently they are the left/right unitor components of the route~(e) monoidal
  structure `\cref{lem:jw_ismonoidal}`. Either way ...", keeping the primary
  `mapIso` route ("This route is the cheap `mapIso` pattern and uses no abstract
  pullback").

## Cross-references introduced
No new `\uses{...}` entries were added. The `\cref{...}` targets used in the rewritten
prose all already exist in this chapter:
`lem:tensorobj_assoc_iso`, `lem:tensorobj_restrict_iso`, `lem:tensorobj_unit_iso`,
`lem:tensorobj_comm_iso`, `lem:tensorobj_isoclass_commgroup`,
`def:scheme_modules_isinvertible`, `lem:whisker_of_W`,
`lem:islocallyinjective_whisker_of_W`, `lem:stalk_linear_map`,
`lem:flat_whisker_localizer`, `lem:scheme_modules_tensorobj_functoriality`.

## References consulted
None — this round was a pure prose-consistency demotion of internal narrative.
No declaration block derived from external reference material was added or
re-sourced, so no `references/<file>.md` files were opened and no `% SOURCE`/
`% SOURCE QUOTE` lines were written.

## Macros needed (if any)
None.

## Notes for Plan Agent
- **Residual route~(e) promotions OUTSIDE the four directed sections.** The directive
  scoped me to exactly four blocks, but several later passages still present
  route~(e) / `lem:jw_ismonoidal` as a live (not merely fallback) source of the
  coherence isos, and now read as mildly inconsistent with the supersession:
  - `sec:tensorobj_onproduct_lift` intro (~L427): "under route~(e) these are read
    off the `MonoidalCategory` structure of `\cref{lem:jw_ismonoidal}`".
  - The `lem:jw_ismonoidal` lemma block itself and its surrounding prose
    (~L1144–1180) still describe building the full `(J.W).IsMonoidal` instance.
  - The `lem:tensorobj_isoclass_commgroup` neighbourhood (~L1700–1755) and the
    chapter-closing summary (~L1960–2010) phrase the coherence isos as "components
    of the route~(e) monoidal structure" with route~(e) as a retained fallback.
  These are not contradictions per se (route~(e) is framed as fallback in most),
  but if the intent is a full supersession sweep, a follow-up writer pass over
  these passages would complete the consistency demotion. I did not touch them, per
  the directive's explicit "these sections ONLY" / "do NOT alter the load-bearing
  lemma blocks" scoping.

## Strategy-modifying findings
None. The edits align the narrative with the already-adopted direct-gluing /
existence-of-iso strategy; no strategy-level issue surfaced.
