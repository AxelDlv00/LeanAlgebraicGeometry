# Reference Retriever Directive

## Slug
stacks-modules

## Topic
Stacks Project chapter "Sheaves of Modules" (chapter 17, file `modules.tex`). I need verbatim tag bodies for:
- **01HG** — Pullback of an invertible sheaf is invertible (functoriality / composition of pullback).
- **01HH** — Tensor product of two invertible modules is invertible (and/or related preservation lemma; tag 01HH neighbours 01HG and is part of the same set on invertible modules).
- **01HK** — Local triviality criterion / line-bundle structure (alongside 01HG and 01HH).

These three Stacks tags back the Route A.1.b chapter `blueprint/src/chapters/Picard_LineBundlePullback.tex` (line-bundle pullback on a product `C ×_k T`), which my parent blueprint-writer is composing right now.

## What the dispatcher will use this for
Citation-discipline `% SOURCE QUOTE:` blocks in three Lean-target declarations of the chapter:
- `def:line_bundle_on_product` (invertible `O_{C×T}`-module)
- `def:pullback_along_projection` (pullback functor `π_T^* : Pic(T) → Pic(C ×_k T)`)
- `lem:pullback_compose` (composition `π_T^* ∘ π_{T'}^* = (π_T ∘ π_{T'})^*`)

The other two declarations (`thm:relative_pic_quotient_well_defined`, `thm:pullback_natural`) are already grounded in `references/kleiman-picard-src/kleiman-picard.tex` §2 (`df:Pfs`, L1311–1318); only the three Stacks tags above are missing locally.

## Seeds
- Stacks Project chapter: `https://stacks.math.columbia.edu/tag/01CW` (chapter tag for "Sheaves of Modules") — its LaTeX source is on GitHub at:
  `https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex`
- Specific tags: 01HG, 01HH, 01HK — search inside `modules.tex` after fetching.

## Out of scope
- Do NOT re-fetch chapter 27 ("Constructions of schemes" — already present as `stacks-constructions.tex`) or any other already-on-disk Stacks chapter.
- Do NOT paraphrase or "summarise" the tag bodies in the `.md` pointer file. The parent will quote verbatim from the fetched `.tex`.

## Contents-map depth expected
**deep** — locate each of 01HG, 01HH, 01HK by exact line number in the downloaded `modules.tex`, and record the surrounding `\begin{lemma}` … `\end{lemma}` (or `\begin{definition}`) line ranges so the parent can quote them with confidence.

## Slug + filenames
- Save raw LaTeX as `references/stacks-modules.tex`.
- Pointer file: `references/stacks-modules.md`.
- Register entry in `references/summary.md`.
