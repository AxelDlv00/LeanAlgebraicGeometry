# Blueprint Clean Report — Cohomology_CechHigherDirectImage.tex (iter-009, slug p5a)

## What was stripped / fixed

### Source-quote drops (proof-strategy mismatch)

1. **`lem:cech_to_cohomology_on_basis` — 01EO embed-into-injective `% SOURCE QUOTE PROOF:` removed.**
   The writer placed the 60-line Stacks-01EO proof (stacks-cohomology.tex L1716–1776),
   which argues by embedding F into an injective I and dimension-shifting via the long
   exact sequence. The proof body uses the acyclic-resolution route
   (Lemmas `cech_augmented_resolution`, `cech_acyclic_affine`,
   `acyclic_resolution_computes_derived`). These are qualitatively different strategies;
   per the directive, the non-mirroring proof quote was dropped.
   The statement `% SOURCE:` + `% SOURCE QUOTE:` (inside the statement block, untouched)
   are retained.

2. **`lem:cech_computes_cohomology` — spectral-sequence `% SOURCE QUOTE PROOF:` removed.**
   A pre-existing 4-line quote ("this is a special case of
   `cohomology-lemma-cech-spectral-sequence-application`") also did not mirror the
   acyclic-resolution proof body. Dropped by the same citation discipline: a source
   proof quote must match the argument it sits above.

### Lean-name leakage stripped from section text

- **Paragraph (2) of the three-part construction** (between `\paragraph{(2)...}` and
  `\paragraph{(3)...}`): removed the sentence "This functoriality is not coupled to the
  project's tensor--pullback substrate; it consumes only Mathlib's pseudofunctor packaging
  of pullback and pushforward." Replaced the three-name list
  `\texttt{conjugateEquiv_pullbackComp_inv}`, `\texttt{conjugateEquiv_pullbackId_hom}`,
  `\texttt{pseudofunctor_left_unitality}`, `\texttt{pseudofunctor_right_unitality}`,
  `\texttt{pseudofunctor_associativity}` with descriptive mathematical phrases.
  Removed "All of these are already available off the shelf", "consumer of Mathlib's
  coherence", "project-local sheafification/pullback machinery of the tensor--pullback
  substrate", and the Lean term `\mathrm{eqToHom}`.

- **End of paragraph (3)**: removed "supplied by Mathlib" and "not any project-local
  ingredient".

### Lean-name leakage stripped from proof blocks

- **`lem:push_pull_id` proof**: removed `\texttt{conjugateEquiv_pullbackComp_inv}`,
  `\texttt{conjugateEquiv_pullbackId_hom}`, `\texttt{pseudofunctor_right_unitality}`,
  and `\mathrm{eqToHom}`; replaced with descriptive text.

- **`lem:push_pull_unit_mate` proof**: replaced "Proved directly in Lean." with a
  brief mathematical description (mate-calculus computation).

- **`lem:push_pull_transport_cancel` proof**: replaced "Proved directly in Lean." with
  a brief mathematical description (transport substitution + direct calculation).

### Process narrative stripped from proof blocks

- **Motivation section**: removed "which in a formalisation requires … that property
  is not currently available for sheaves of modules over a sheaf of rings whose value
  category varies over the site." Rephrased to timeless mathematical statement.

- **Three-part construction intro**: removed "not yet available off the shelf",
  rephrased to "the sole non-trivial mathematical content".

- **`lem:cech_to_cohomology_on_basis` proof**: removed "We argue the instance actually
  consumed downstream", "The source proves the general criterion 01EO by the
  embed-into-injective dimension shift quoted above; we reorganise it …", and "The
  general 01EO bootstrap from the abstract conditions (1)--(3) is not formalised."

- **`lem:cech_computes_cohomology` proof**: removed "The source proves the statement by
  exhibiting it … as a special case of the Čech-to-cohomology spectral-sequence
  criterion. We organise the same fact as …" Replaced with a single clean sentence
  opening the acyclic-resolution argument directly.

---

## Source-quote validation — the two new quotes

### Quote 1: 01EO proof from `references/stacks-cohomology.tex` L1716–1776
**Status: verbatim-faithful, but DROPPED.**
Validation confirmed the blueprint's `% SOURCE QUOTE PROOF:` was a faithful
transcription of stacks-cohomology.tex L1717–1775 (the `\begin{proof}` body of
`lemma-cech-vanish-basis`, omitting only the `\medskip\noindent` separator between
paragraphs). However, per the directive's judgement call, this proof quote was
removed because the proof body uses the acyclic-resolution route, not the
embed-into-injective argument quoted.

### Quote 2: `lemma-relative-affine-vanishing` proof from `references/stacks-coherent.tex` L187–198
**Status: verbatim-faithful, RETAINED.**
Validation confirmed the blueprint's `% SOURCE QUOTE PROOF:` for
`lem:open_immersion_pushforward_comp` is a faithful transcription of
stacks-coherent.tex L188–198 (the `\begin{proof}` body of
`lemma-relative-affine-vanishing`, starting "According to …"). The cited file
`references/stacks-coherent.tex` exists. The proof body's part (1) closely follows
the same argument (presheaf description + affine preimage + Serre vanishing); the
additional part (2) is a project extension not in the source, so the partial match
is acceptable. Quote retained.

---

## Decision on `lem:cech_to_cohomology_on_basis` proof-quote

**Dropped the `% SOURCE QUOTE PROOF:` (lines 699–756 of the original file).**

The Stacks 01EO proof (embed-into-injective, dimension-shift via long exact sequence)
is a fundamentally different argument from the proof body (acyclic-resolution via
`cech_augmented_resolution` + `acyclic_resolution_computes_derived`). Leaving a
proof quote that argues a different route would mislead readers about the proof
strategy. The statement-level `% SOURCE:` and `% SOURCE QUOTE:` (inside the statement
block, preserving the Stacks 01EO attribution for the statement) are kept untouched.

The second `% SOURCE QUOTE PROOF:` inside the statement block (lines 665–680, the
application context from stacks-coherent.tex, quoting how `lemma-quasi-coherent-
affine-cohomology-zero` invokes 01EO) was not touched per the "Do NOT touch any
STATEMENT" rule.

---

## Files modified

- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (proof prose and
  section text only; no statement, `\lean{}`, `\leanok`, or `\mathlibok` was touched)

No retriever spawn was needed (no missing reference files).
