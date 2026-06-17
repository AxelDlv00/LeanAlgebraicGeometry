# Blueprint-clean directive — iter-035

## Scope
Three chapters edited this iter (coverage-debt blocks + FBC-A conjugate atomization + a retired dead
subsection). Run the standard purity pass on each:
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — 17 new coverage blocks (15 FBCGlobal eqLocus
  + 2 conj-0), the new conj-1a..conj-2e atomization chain (8 nodes), a retired "FBC-B build-ahead"
  subsection (now a `% NOTE` pointer), and stale `_link_*` block cleanup.
- `blueprint/src/chapters/Picard_QuotScheme.tex` — 6 new gap1 P1 coverage blocks.
- `blueprint/src/chapters/Picard_GrassmannianCells.tex` — 6 new separatedness-machinery coverage blocks.

## What to enforce
- Strip any Lean tactic syntax / Lean-identifier leakage from PROSE (math-only prose; `\lean{}` pins and
  `\mathlibok` anchors are fine and must stay).
- Remove project-history / iter-narrative verbosity that crept into block prose (e.g. "iter-034 landed",
  "the prover should", route-comparison editorializing). Keep `% NOTE:` review markers and `% SOURCE` /
  `% SOURCE QUOTE` citation comments.
- Validate that every block deriving from an external source carries a `% SOURCE:` + verbatim
  `% SOURCE QUOTE:` (the new coverage blocks are project-bespoke and need none; do NOT fabricate quotes).
  The two source-backed targets already present (`lem:section_localization_descent` →
  Stacks `lemma-invert-f-sections`; `lem:gr_proper` → Nitsure §1) already have verbatim quotes — confirm
  they are intact, do not rewrite them.
- Confirm no `\leanok` was hand-added (it is the sync phase's job); if any block has a hand-added
  `\leanok`, remove it.
- Keep `\mathlibok` anchors (they are legitimate Mathlib-dependency markers).

## Out of scope
Do NOT touch the other chapters (RegroupHelper, FlatteningStratification, RelativeSpec). Do NOT alter
mathematical content of the source-verified blocks.
