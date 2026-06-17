# Reference Retriever Directive

## Slug
homological-acyclic

## Topic
Classical homological algebra: the **acyclic-resolution comparison theorem** for
right-derived functors. Precisely: if `0 → A → J⁰ → J¹ → ⋯` is a resolution of an
object `A` in an abelian category by objects `Jⁿ` that are **right-`F`-acyclic** for an
additive (left-exact) functor `F` (i.e. the higher right-derived functors
`(R^k F)(Jⁿ)` vanish for all `k ≥ 1`), then the derived functor of `F` is computed by the
resolution: `(R^n F)(A) ≅ Hⁿ(F(J•))`. Also want the **definition of an `F`-acyclic
object** and the standard **dimension-shifting** proof (truncate the resolution into short
exact sequences `0 → A → J⁰ → Z¹ → 0`, use the long exact sequence of derived functors,
and induct).

## What the dispatcher will use this for
I am the blueprint-writer for a new chapter `Cohomology_AcyclicResolution.tex` that states
this abstract theorem (it is the homological-algebra heart of an acyclic-cover / Cartan–Leray
route to computing higher direct images). I need a real, openly-available source to quote
**verbatim** for: (a) the definition of an `F`-acyclic object, and (b) the statement +
proof of "an `F`-acyclic resolution computes the derived functor". I will paste the
verbatim text into `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` comments, so I need the exact
original wording, notation, and the section/tag/theorem number.

## Seeds
- **Primary (open-access, most reliable):** Stacks Project, **Homological Algebra** chapter
  (`homology.tex` on GitHub: https://github.com/stacks/stacks-project/blob/master/homology.tex),
  the section on **right derived functors / Cohomological delta-functors and acyclic objects**.
  Relevant tags likely include the lemma "computing right derived functors via acyclic
  resolutions" and the definition of "right acyclic object" / "F-acyclic". Search the
  downloaded TeX for `acyclic`, `right derived functor`, `\delta`-functor.
  - Tarball of all TeX: https://github.com/stacks/stacks-project/archive/refs/heads/master.tar.gz
    (or fetch `homology.tex` and `derived.tex` directly via raw.githubusercontent.com).
- **Secondary (textbook):** Weibel, *An Introduction to Homological Algebra* (CUP 1994),
  §2.4 "Left Derived Functors" and its dual for right derived functors — the notion of an
  `F`-acyclic object and the corollary that `F`-acyclic resolutions compute `L_*F` / `R^*F`.
  If an openly-available PDF exists, fetch it; if it is paywalled, do NOT fabricate — rely on
  the Stacks source instead and report Weibel as not openly available.

## Out of scope
- Scheme-specific cohomology (the project already has `references/stacks-coherent.*` for the
  "Cohomology of Schemes" chapter — that is NOT what I need here).
- No need for spectral-sequence constructions; the abstract dimension-shifting statement is
  what matters.

## Contents-map depth expected
deep — please locate and flag the **exact tag(s)/section(s)** in the downloaded Stacks TeX
for: (1) the definition of a right-acyclic / `F`-acyclic object, and (2) the lemma that an
acyclic resolution computes the right derived functor, with their tag numbers and the line
ranges in the downloaded file, so I can open the file and copy the verbatim statement and
proof. (No paraphrase — just point me at the exact locations.)
