# Reference Retriever Directive

## Slug
stacks-schemes

## Topic
Stacks Project chapter "Schemes" (chapter tag 020J, file `schemes.tex`). The specific
target is the lemma computing the pullback (inverse image) `f^* widetilde(M)` of a
quasi-coherent sheaf along a morphism of affine schemes as a base change of modules —
the lemma referenced elsewhere in the Stacks Project as
`schemes-lemma-widetilde-pullback`. It states (for `f : Spec(S) -> Spec(R)` induced by
a ring map `R -> S`, and an `R`-module `M`) that the pullback of the quasi-coherent
sheaf `M~` is canonically `(S ⊗_R M)~`, the tilde of the base-changed module. The
companion pushforward statement (`f_* (M~) = (M restricted to R)~` / `(_R M)~`) in the
same lemma/section is also of interest.

## What the dispatcher will use this for
A blueprint-writer is adding a lemma block `lem:pullback_spec_tilde_iso` to
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — the affine pullback companion
of an already-present pushforward lemma. The block needs a verbatim `% SOURCE QUOTE:`
copied from the Stacks Schemes `.tex` source (the exact lemma statement, with the
internal label `schemes-lemma-widetilde-pullback` and its tag number), to satisfy
citation discipline. The same lemma is already cited by tag-name inside this chapter's
existing affine-base-change proof quote, so having the real source on disk also fixes a
dangling cross-reference.

## Seeds
- Stacks Project Schemes chapter TeX source (GitHub raw):
  https://raw.githubusercontent.com/stacks/stacks-project/master/schemes.tex
- Internal label to locate: `schemes-lemma-widetilde-pullback`
- The lemma is in the section on quasi-coherent sheaves on affine/relative schemes.

## Out of scope
- Do not fetch other Stacks chapters (Coherent, Modules, Constructions are already present).
- No need to map the entire chapter in depth — only flag the section/line of the
  `widetilde`-pullback lemma and the surrounding quasi-coherent-pullback material.

## Contents-map depth expected
deep — record the exact location (section + line number in the fetched `.tex`) of
`schemes-lemma-widetilde-pullback` (and its tag number), plus the quasi-coherent-sheaf
section it lives in. No paraphrase of the statement; just its location so I can open the
file and copy it verbatim.
