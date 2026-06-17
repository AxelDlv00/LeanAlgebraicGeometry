# blueprint-clean directive — iter-042

Two chapters were edited this iter by blueprint-writers. Clean them for purity
(strip any Lean *syntax* leakage, project-history/iter-narrative verbosity, and
ensure every external statement carries its `% SOURCE` / `% SOURCE QUOTE`; validate
and insert missing source quotes if needed).

## Chapters to clean
- `blueprint/src/chapters/Picard_QuotScheme.tex` — reconciliation round: 3 pin fixes,
  4 new helper blocks (`image_basicOpen_of_affine`,
  `compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`,
  `section_localization_hfr_aux`), G1-core + gap2 made prover-ready.
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — new lemma
  `lem:pushforward_base_change_mate_sections_direct` + revised proof of
  `lem:pushforward_base_change_mate_cancelBaseChange` (tilde-transport pivot).

## Keep (do NOT strip)
- `\lean{...}` pins, `\uses{...}`, `\label{...}` — structural, required.
- `% LEAN HINT` / `% NOTE` comments that record a Lean-side proof approach or an
  absorbed-inline status — these are intentional planner/prover guidance, not leakage.
- `% SOURCE` / `% SOURCE QUOTE` citation comments.

## Strip
- Any actual Lean *tactic blocks* or executable Lean syntax pasted into prose.
- Iter-by-iter narrative ("iter-041 the prover did X"), if any leaked in.

Do NOT add or remove `\leanok`. Do NOT touch other chapters.
References (`references/**`) authorized for inserting a missing verbatim source quote.
