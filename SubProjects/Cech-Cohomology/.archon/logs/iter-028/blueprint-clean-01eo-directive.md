# Blueprint-clean directive — purity pass on the 01EO chapter (post blueprint-writer)

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` was just heavily edited by a
blueprint-writer (iter-028): L1/L2 prose rewritten to the cover-local presheaf form; new blocks added
for `shortExact_piMap`, `cechHomology_quotient_vanishing`, `cechCohomology`,
`sectionCechComplexShortComplex`, the section-Čech functoriality helpers, the per-face SES derivation
(`lem:face_ses_of_sheaf_ses`), and the `BasisCovSystem`/`HasVanishingHigherCech` defs + reconciled
L3/L4/top.

## Your pass
Run a purity pass over the WHOLE chapter (focus on the freshly edited 01EO section, lines ~3050–3600):
- Strip any Lean tactic syntax / Lean code leakage from prose bodies (Lean type signatures inside
  `% NOTE` comments and `\lean{}` pins are fine; raw tactic blocks in the visible prose are not).
- Remove project-history / iteration-narrative verbosity ("iter-027 review", "the prover landed", etc.)
  from the visible prose — but you MAY keep a single concise `% NOTE:` comment where it records a real
  formalization caveat (e.g. "target not yet formalized — scaffold this iter").
- Validate that every `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` block is present and its visible
  `\textit{Source: …}` line matches; do NOT alter the verbatim quotes.
- Do NOT add or remove `\leanok`. Do NOT change any `\lean{}` pin or `\uses{}` edge (the writer set
  those deliberately).

## Out of scope
- Other chapters. `.lean` files. Marker changes beyond stripping stray Lean leakage from prose.

## Write domain
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
- `references/**`
