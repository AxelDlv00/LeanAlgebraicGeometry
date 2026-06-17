# Blueprint Clean Directive

## Slug
iter036

## Chapters to clean (edited this iter by blueprint-writers)
Clean each of the following in turn — strip Lean leakage (tactic names, typeclass/`set_option` notes,
Lean implementation strategy), remove any project-history / iteration references ("iter-035",
"superseded this iter", "the prior pass", "trip-wire", "abandoned"), trim verbosity, and verify citation
discipline (`% SOURCE` + verbatim `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` on every externally-sourced
block; open the actual reference `.tex`/`.pdf` to insert any missing verbatim quote):

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — FBC. The obligation-2 discharge is the
   conjugate-counit route closing `lem:base_change_mate_gstar_transpose` from the master identity (a)/(b)/(c)
   remainder; remove any residual "explicit-inverse"/"superseded"/iteration narrative the writer passes may
   have left. The 02KH affine-base-change and regroup quotes already present should be retained/verified.
2. `blueprint/src/chapters/Picard_QuotScheme.tex` — QUOT. New blocks: cover-form keystone
   `lem:section_localization_descent_of_cover` (verify the Stacks `lemma-invert-f-sections` verbatim quote
   is present and faithful) and the `Hfr` section-transport block `lem:pullback_gamma_top_iso`.
3. `blueprint/src/chapters/Picard_GrassmannianCells.tex` — GR. New blocks: 7 properness-scaffold helpers +
   the E1–E4 + existence decomposition under `sec:gr_proper` (verify the Nitsure §1 "Properness" verbatim
   quotes are present and faithful; the E1–E4 blocks should each carry / reference the §1 source quote).

## References (for quote validation / insertion)
- `references/stacks-coherent.tex` (02KH), `references/stacks-schemes.tex` (01I9) — FBC.
- `references/stacks-properties.tex` (`lemma-invert-f-sections`, ~line 2150), `references/hartshorne-algebraic-geometry.pdf` (II.5.3) — QUOT.
- `references/nitsure-hilbert-quot.pdf` / `-src/*.tex` (§1 Properness) — GR.

## Out of scope
Do NOT change mathematical content, statements, `\lean{}` pins, or `\uses{}` edges (those were just set by
the writers). Do NOT add/remove `\leanok`. Purity + citation validation only.
