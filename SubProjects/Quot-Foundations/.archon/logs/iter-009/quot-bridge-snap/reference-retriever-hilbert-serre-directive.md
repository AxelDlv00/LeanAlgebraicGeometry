# Reference Retriever Directive

## Slug
hilbert-serre

## Topic
The Hilbert–Serre theorem: rationality of the Hilbert (Poincaré) series of a
finitely generated graded module over a Noetherian graded ring generated in
degree 1 over a field (Artinian degree-0 part). Specifically the statement that
for such a module \(M = \bigoplus_n M_n\) with finite-length components, the
generating function \(\sum_n \ell(M_n)\, t^n\) is a rational function of the form
\(f(t)\cdot(1-t)^{-d}\) with \(f \in \mathbb{Z}[t]\), proved by induction via the
short exact sequence from multiplication by a degree-1 generator.

## What the dispatcher will use this for
This is the verbatim `% SOURCE QUOTE:` for the blueprint block
`lem:gradedHilbertSerre_rational` in chapter `Picard_QuotScheme.tex` (the graded
Hilbert–Serre rationality bridge that feeds the Hilbert polynomial of a coherent
sheaf). The local Hartshorne PDF has no text layer and the local Stacks files
(`stacks-schemes`, `stacks-coherent`, `stacks-constructions`) do not contain the
graded-module Hilbert-series rationality statement, so I need a fetchable source
with an exact statement of the theorem AND its inductive proof to quote
character-by-character.

## Seeds
- **Primary (preferred, exact TeX):** Stacks Project "Algebra" chapter, the
  section on **Hilbert functions / Hilbert polynomial** (tags around 00JW —
  "Hilbert function and Hilbert polynomial", and the additivity / numerical
  polynomial lemmas around 00P4). Fetch the raw TeX:
  `https://raw.githubusercontent.com/stacks/stacks-project/master/algebra.tex`
  Map the location of the Hilbert-function section and the rationality / numerical
  polynomial lemma(s) by tag and line number.
- **Acceptable alternative / supplement:** Atiyah–Macdonald, *Introduction to
  Commutative Algebra*, Chapter 11, **Theorem 11.1 (Hilbert–Serre)** and the
  Poincaré-series corollary — if an openly available copy exists.
- Search query: `Stacks project Hilbert function graded module Poincare series rational`

## Out of scope
No need for the dimension-theory consequences (Krull dimension = degree of
Hilbert polynomial) beyond what sits adjacent to the rationality statement. No
historical surveys.

## Contents-map depth expected
deep — pin the exact tag(s) and line numbers in the fetched `algebra.tex` for
(a) the Hilbert-function/Poincaré-series rationality statement and (b) its
inductive proof via the degree-1 multiplication short exact sequence, so I can
quote them verbatim without re-scanning the whole chapter.
