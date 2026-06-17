# Blueprint Writer Report

## Slug
barescheme-pins

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:projectiveLineBar_smoothOfRelDim}`/
  `\lean{AlgebraicGeometry.projectiveLineBar_smoothOfRelDim}` — declares
  the smoothness-of-relative-dimension-1 instance for the structure morphism
  \(\mathbb P^1_{\bar k} \to \Spec \bar k\); prose covers the 2-chart cover +
  standard-smooth chart argument as directed.
- **Added lemma** `\lemma`/`\label{lem:projectiveLineBar_geomIrred}`/
  `\lean{AlgebraicGeometry.projectiveLineBar_geomIrred}` — declares the
  geometric-irreducibility instance for the same structure morphism; prose
  covers integrality of \(\bar k[X_0, X_1]\) and stability of irreducibility
  under base change as directed.

Both new lemma blocks are placed immediately after `def:gm_one` (closing
at L950) and immediately before `def:gm_grpObj` (opening at L994), as
specified in the directive.

### Final chapter line numbers of the 2 new blocks

- `lem:projectiveLineBar_smoothOfRelDim`: L951–L971 (label at L953,
  `\lean{...}` at L954, `\uses{def:genus0_base_objects}` at L955).
- `lem:projectiveLineBar_geomIrred`: L972–L993 (label at L974,
  `\lean{...}` at L975, `\uses{def:genus0_base_objects}` at L976).

### The two `\lean{...}` declaration names used

Both names match `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean:151-163`
verbatim. The file declares `namespace AlgebraicGeometry` at L35 and
`end AlgebraicGeometry` at L243, so the fully-qualified names are:

- `AlgebraicGeometry.projectiveLineBar_smoothOfRelDim`
  — `instance ... : SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom := sorry`
  (BareScheme.lean L161–L163).
- `AlgebraicGeometry.projectiveLineBar_geomIrred`
  — `instance ... : GeometricallyIrreducible (ProjectiveLineBar kbar).hom := sorry`
  (BareScheme.lean L154–L156).

No name adjustment was needed; both `\lean{...}` lines were used as
specified in the directive.

### Wording adjustments to the prose

None — both lemma bodies use the directive's wording character-for-character
(quotation marks, paragraph break, `\texttt`, `\char`_atOpens` escape, etc.).
The only addition beyond the directive's literal block was `\uses{def:genus0_base_objects}`,
which the directive explicitly authorised as optional (\"Both new lemmas can
optionally `\uses{def:genus0_base_objects}`\"). I added it on both blocks
to keep the dependency graph accurate — the two new lemmas characterize
the structure morphism that `def:genus0_base_objects` provides informally.

### Build status

LaTeX is well-formed:
- `\begin{lemma}` count = `\end{lemma}` count = 29 (was 27 before; +2 for
  the two new blocks).
- `\begin{definition}` count = `\end{definition}` count = 13 (unchanged —
  we did not add or remove any definition).
- All `\label{...}`, `\lean{...}`, `\uses{...}` braces balance.
- No new macro names were introduced; `\Proj`, `\Spec`, `\mathbb`,
  `\mathtt`, `\cref`, `\texttt`, `\char` are all already used elsewhere
  in this chapter.

I did not attempt a `pdflatex` build (the project uses `leanblueprint`
and the typesetting pipeline is managed downstream); spot-checking the
file confirms the LaTeX is syntactically well-formed.

## Cross-references introduced

- `\uses{def:genus0_base_objects}` added in both new lemma blocks —
  verified `def:genus0_base_objects` is the existing label for the
  `Definition: \(\mathbb P^1_{\bar k}\) and \(\mathbb G_m\) base objects`
  block in this same chapter (the directive references it as the
  informal source of the bundle properties these two lemmas now make
  precise).

## References consulted

None — both new blocks are explicitly Archon-original per the directive
(\"Archon-original instance; the mathematics is textbook ... No external
SOURCE QUOTE needed.\"). No `references/<file>.md` was opened.

## Macros needed (if any)

None — all macros used (`\Proj`, `\Spec`, `\mathbb`, `\mathtt`, `\cref`,
`\texttt`, `\char`) already appear elsewhere in the chapter and are
defined in `blueprint/src/macros/common.tex` or supplied by
`leanblueprint`'s default preamble.

## Reference-retriever dispatches (if any)

None.

## Notes for Plan Agent

- The two new lemma blocks intentionally do NOT carry `\leanok` / `\mathlibok`
  markers — the writer descriptor forbids me from adding them, and they
  are managed by the deterministic `sync_leanok` phase and the review
  agent respectively. After this iter's `sync_leanok` runs, both lemmas
  will remain unmarked because the Lean instances still have `sorry` at
  `BareScheme.lean:156` and `BareScheme.lean:163`; once those sorrys are
  closed, `sync_leanok` will mark them.
- The directive's instruction \"INSERT IMMEDIATELY AFTER ... currently
  ending around L950 with `def:gm_one`\" matched the on-disk state
  exactly: L950 was `\end{definition}` for `def:gm_one` and L951 was
  `\begin{definition}` for `def:gm_grpObj`. Insertion was clean — no
  surrounding prose needed adjustment.

## Strategy-modifying findings

None — the two new lemma blocks fill an existing scaffold gap, they do
not surface any strategy-level issue.
