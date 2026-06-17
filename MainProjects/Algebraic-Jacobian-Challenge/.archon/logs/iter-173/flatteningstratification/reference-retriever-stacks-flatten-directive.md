# Reference Retriever Directive

## Slug
stacks-flatten

## Topic
Stacks Project chapter(s) containing the **flattening stratification of a
coherent sheaf** and the **(scheme-theoretic) flat locus of a morphism / sheaf**.
Specifically the verbatim text of tags **0532**, **052H**, **0533**, plus any
adjacent lemmas they reference for the existence proof (Stacks "More on
Morphisms" / "More on Flatness").

Tag-to-content map I expect (per the public Stacks tag DB; please verify against
the actual `.tex`):
- `0532` — definition / lemma on the flat locus (open subset of S over which
  a coherent sheaf is flat over `f : X → S`).
- `052H` — flattening stratification theorem (locally-closed stratification
  with a universal property for flatness of the pullback).
- `0533` — related lemma on the flat locus (likely "openness of the flat
  locus" at the scheme level, or "flat locus = complement of supports of
  Tor's").

## What the dispatcher will use this for

I am the `blueprint-writer` drafting
`blueprint/src/chapters/Picard_FGA_FlatteningStratification.tex` (Route A.2.a,
new chapter). Each of the 4 declarations in that chapter needs a verbatim
`% SOURCE QUOTE:` from the Stacks Project chapter. The dispatcher's directive
incorrectly claimed these tags live in `references/stacks-coherent.tex`, but
that file only contains tag 02KH (Chapter 30 = "Cohomology of Schemes"); tags
0532 / 052H / 0533 live in a different chapter (most likely
`more-morphisms.tex` or `flat.tex`). Without the verbatim text I cannot
satisfy the project's citation discipline rule.

I also need an exact tag→`\label`→chapter map so my `% SOURCE:` parentheticals
point to the correct local `.tex` file with correct line numbers.

## Seeds

- Stacks tag URL pattern: `https://stacks.math.columbia.edu/tag/<TAG>`
- GitHub source mirror: `https://github.com/stacks/stacks-project`
- Tag map (raw): `https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags`
- Candidate chapter files:
  - `https://raw.githubusercontent.com/stacks/stacks-project/master/more-morphisms.tex`
  - `https://raw.githubusercontent.com/stacks/stacks-project/master/flat.tex`
  - `https://raw.githubusercontent.com/stacks/stacks-project/master/morphisms.tex`

Please resolve the actual chapter(s) for tags 0532, 052H, 0533 via the tag
map (download `tags/tags`, grep for the tag, read the `<tag>,<label>` row,
locate the `\label{...}` in the relevant chapter source).

## Out of scope

- No need to retrieve full Stacks-Project clone — only the chapter file(s)
  actually containing 0532 / 052H / 0533 (likely 1–2 chapters).
- No need for the Quot-scheme construction tags (those are downstream of
  A.2.a and are covered by Nitsure §5, already present locally).
- No paraphrase / summary — just download the chapter `.tex` files verbatim,
  verify the tag's `\label{…}` is present, and write the pointer card with
  line numbers.

## Contents-map depth expected

**deep** — for each of tags 0532, 052H, 0533, locate the `\label{…}` line in
the downloaded `.tex`, record the chapter file, line range of the
declaration block (statement only; proof too if it's short), and the
Stacks-side `\label` (e.g. `lemma-flat-locus` or `lemma-flattening`). I will
quote from the downloaded `.tex` myself; the pointer card is the index.
