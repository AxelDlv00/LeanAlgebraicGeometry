# Reference Retriever Directive

## Slug
stacks-pic-invertible

## Topic
Two Stacks Project tags needed verbatim for an algebraic-geometry blueprint
chapter on the Picard group:
- **Tag 01CR** — "Picard groups of schemes" (the section in the Stacks
  "Divisors" chapter establishing that the isomorphism classes of invertible
  $\mathcal{O}_X$-modules form an abelian group $\Pic(X)$ under $\otimes$, with
  unit $\mathcal{O}_X$ and inverse the dual).
- **Tag 01HK** — "Invertible modules" (the Stacks "Modules on Sites" / "Modules"
  material characterising an invertible module: $L$ is invertible iff there
  exists $N$ with $L \otimes N \cong \mathcal{O}$; an invertible module is
  finite locally free of rank 1).

I need the EXACT statements (definition of invertible module via
$\exists N,\ L\otimes N\cong\mathcal O$, and the abelian-group structure on
$\Pic(X)$) to quote character-by-character.

## What the dispatcher will use this for
A blueprint chapter (`Picard_TensorObjSubstrate.tex`) is being rewritten so the
relative Picard group law rests on a $\otimes$-invertibility predicate
`IsInvertible M := ∃ N, M ⊗ N ≅ 𝒪` (the Mathlib `Module.Invertible` analogue),
with the abelian group being the units of the commutative monoid of
$\otimes$-isomorphism-classes. I need verbatim source text for (a) the
invertible-module characterisation (tag 01HK) backing the `IsInvertible`
predicate, and (b) the Picard-group-is-an-abelian-group statement (tag 01CR)
backing the group-law theorem.

## Seeds
- Stacks "Divisors" chapter TeX (contains tag 01CR):
  https://raw.githubusercontent.com/stacks/stacks-project/master/divisors.tex
- Stacks "Modules on Sites" chapter TeX (contains tag 01HK — invertible modules):
  https://raw.githubusercontent.com/stacks/stacks-project/master/modules-on-sites.tex
  (If 01HK is not there, it is in the "Modules" chapter:
   https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex)
- Tag lookup pages (to confirm which chapter each tag lives in):
  https://stacks.math.columbia.edu/tag/01CR
  https://stacks.math.columbia.edu/tag/01HK

## Out of scope
- No need for the full Cartier-divisor theory; only the Picard-group section
  (01CR) and the invertible-module characterisation (01HK).
- No paraphrase — fetch the real `.tex` so the tags can be quoted exactly.

## Contents-map depth expected
deep — locate tags 01CR and 01HK inside the fetched `.tex` file(s) and record
their exact line ranges (and the surrounding lemma/definition numbers), so the
quote can be copied verbatim. Save the files under names like
`references/stacks-divisors.tex` and `references/stacks-modules-on-sites.tex`
(plus pointer `.md`). NO content paraphrase in the pointer file.
