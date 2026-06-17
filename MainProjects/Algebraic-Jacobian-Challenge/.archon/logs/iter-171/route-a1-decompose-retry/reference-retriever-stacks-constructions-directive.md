# Reference Retriever Directive

## Slug
stacks-constructions

## Topic
The Stacks Project chapter "Constructions of Schemes" (file `constructions.tex` on the Stacks GitHub master). The blueprint chapter being written (`Picard_RelativeSpec.tex`) needs the verbatim LaTeX source of five tags from this chapter:

- **01LL** — definition of a quasi-coherent sheaf of algebras (§"Relative spectrum via glueing" or §"Relative spectrum as a functor" preamble).
- **01LO** — affine base case: when `X = Spec R`, the relative spectrum `Spec_X 𝒜 ≅ Spec(Γ(X, 𝒜))`.
- **01LQ** — existence + universal property of `RelativeSpec` (Spec of a quasi-coherent sheaf of algebras).
- **01LR** — functoriality of the relative spectrum / adjunction with pushforward `π_*`.
- **01LS** — base change of the relative spectrum.

## What the dispatcher will use this for
The new blueprint chapter `Picard_RelativeSpec.tex` (iter-171 deliverable) must contain six declaration blocks, each with a verbatim `% SOURCE QUOTE:` LaTeX comment copied character-by-character from the Stacks LaTeX source for the named tag. The chapter is the foundational entry point for Route A.1 of the Jacobian project (the construction of `Spec_X 𝒜 : QCoh(X)^op → Sch/X`, underneath the relative Picard functor). The dispatcher needs the raw `.tex` lines holding each tag so they can be quoted verbatim — paraphrase is explicitly disallowed by the writer's citation discipline.

## Seeds
- GitHub raw URL (preferred — TeX source, exact statement preserved):
  `https://raw.githubusercontent.com/stacks/stacks-project/master/constructions.tex`
- Tag → label cross-check (so the writer can find each tag in the fetched file):
  `https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags`
- Web display of the chapter (for table-of-contents mapping):
  `https://stacks.math.columbia.edu/tag/01KX` (chapter "Constructions of Schemes" landing tag)

## Out of scope
- Do NOT fetch any other Stacks chapter — only `constructions.tex`.
- Do NOT paraphrase the tag statements in the pointer file; the writer will quote directly from the downloaded `.tex` (this is the whole point).
- Do NOT replace or modify the existing `stacks-coherent.tex` / `stacks-algebra.tex` / `stacks-varieties.tex` / `stacks-fields.tex` entries — only add a NEW entry for constructions.

## Contents-map depth expected
deep — for each of the five named tags, record:
- The exact `\label{...}` it uses (e.g. `lemma-relative-spec-functor`).
- The kind (definition / lemma / proposition).
- Line range in the fetched `.tex` (so the writer can `Read` it with `offset`/`limit` and copy verbatim).
- The Stacks-display number (e.g. `Lemma 27.4.6`) if visible adjacent to the tag.
