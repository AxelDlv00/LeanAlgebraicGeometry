# Reference Retriever Directive

## Slug
stacks-cohomology

## Topic
Algebraic geometry / sheaf cohomology. I need the Stacks Project "Cohomology" chapter
LaTeX source (`cohomology.tex`) — the general topological/abstract-sheaf cohomology
chapter (NOT "Cohomology of Schemes", which is already local as
`references/stacks-coherent.tex`). Two specific results are needed verbatim:
- the **Čech-to-cohomology comparison on a basis** lemma, tagged in the source as
  `cohomology-lemma-cech-vanish-basis` — the basis-comparison criterion with its three
  conditions (closure under finite intersection of the basis, cofinality of the chosen
  covers, Čech vanishing on the basis ⇒ the Čech-to-cohomology comparison is an
  isomorphism / cohomology vanishes);
- the **presheaf description of higher direct images**, tagged
  `cohomology-lemma-describe-higher-direct-images` — $R^if_*\mathcal{F}$ is the sheaf
  associated to the presheaf $V \mapsto H^i(f^{-1}(V), \mathcal{F}|_{f^{-1}(V)})$.

## What the dispatcher will use this for
I am the blueprint-writer for the Čech-higher-direct-image chapter. Two declaration
blocks cite results that live in the Stacks "Cohomology" chapter, which is not yet in
`references/`. I will open the downloaded `cohomology.tex` and copy the verbatim
statements of `cohomology-lemma-cech-vanish-basis` (for the Čech-to-cohomology
comparison on a basis) and `cohomology-lemma-describe-higher-direct-images` (for the
presheaf description of $R^k f_*$) into the chapter's `% SOURCE QUOTE:` blocks. Exact
lemma statements and tags matter — these are anti-hallucination citation anchors.

## Seeds
- Stacks Project GitHub raw TeX:
  https://raw.githubusercontent.com/stacks/stacks-project/master/cohomology.tex
- Online tags (for cross-checking the label ↔ tag mapping):
  https://stacks.math.columbia.edu/tag/01EO (Čech-to-cohomology on a basis, likely)
  https://stacks.math.columbia.edu/tag/01XJ (describe higher direct images, likely)

## Out of scope
- Do NOT re-fetch "Cohomology of Schemes" (`coherent.tex`) — it is already local.
- No paraphrase. Download the real `cohomology.tex`.

## Contents-map depth expected
deep — locate the two named lemmas (`cohomology-lemma-cech-vanish-basis` and
`cohomology-lemma-describe-higher-direct-images`) by line number inside the downloaded
`cohomology.tex` so I can jump straight to them. No paraphrase of their content.
