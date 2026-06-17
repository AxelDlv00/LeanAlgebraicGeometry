# Blueprint-clean directive — iter-027

## Scope
One chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

## What changed this iter (purity-check these regions)
1. An effort-breaker split `lem:cech_to_cohomology_on_basis` (Stacks 01EO) into a four-link
   `\uses` chain. New sub-lemma blocks (search by label): `lem:cech_ses_of_basis`,
   `lem:quotient_vanishing_cech`, `lem:absolute_cohomology_one_vanishing`,
   `lem:absolute_cohomology_pos_vanishing`. The top lemma's proof was rewritten as a short
   assembly.
2. The planner added a `\subsection{Project wrappers around the Ext realization}` with five blocks:
   `lem:absolute_cohomology_zero`, `lem:absolute_cohomology_zero_natural` (a new to-build
   naturality obligation), `lem:absolute_cohomology_injective_vanishing`,
   `lem:absolute_cohomology_covariant_les`, and bundled `sheafificationHomAddEquiv` into
   `lem:jshriek_corepr`'s `\lean{}`.

## Task
Standard purity pass over the chapter, focused on the regions above but covering the whole file:
- Strip any Lean syntax / tactic strings that leaked into prose or proof bodies (the math must read
  as mathematics, not Lean). NOTE: `\lean{...}` and `\uses{...}` directives and `% SOURCE`/
  `% SOURCE QUOTE`/`% SOURCE QUOTE PROOF` LaTeX comments are REQUIRED metadata — keep them.
- Verify every `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` is genuine verbatim source text (the 01EO
  fragments derive from `references/stacks-cohomology.tex` L1695–1776; confirm against that file if
  any fragment looks paraphrased). The new project-wrapper blocks and the naturality block are
  project-bespoke specializations of already-cited Mathlib anchors — they legitimately carry NO
  `% SOURCE` lines (they are not external-source results); do not invent citations for them.
- Remove project-history / iter-narrative verbosity if any crept in.
- Do NOT add or remove `\leanok` or `\mathlibok`. Do NOT change any mathematical statement,
  `\lean{}` pin, or `\uses{}` set — those were just set deliberately by the planner and
  effort-breaker. Purity/leakage only.

## Report
- What you stripped (if anything), and confirmation the `% SOURCE QUOTE` fragments are verbatim.
- Confirm no `\lean{}`/`\uses{}`/marker changes were made.
