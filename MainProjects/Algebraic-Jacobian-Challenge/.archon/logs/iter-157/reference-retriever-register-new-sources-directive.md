# Reference Retriever Directive

## Slug
register-new-sources

## Topic
Three canonical algebraic-geometry source PDFs that the project user has **already
downloaded** into `references/` and asked to be registered. They back two live
strategy threads: the characteristic-free abelian-variety rigidity stack (route (c)
for the genus-0 Jacobian arm) and the FGA Picard/Quot/Hilbert representability engine
(Route A for the positive-genus object).

## IMPORTANT — files are already on disk; do NOT re-download
The three source files already exist in `references/` (added by the user this iter):

- `references/mumford-abelian-varieties.pdf`  (Mumford, *Abelian Varieties*, 1970 / TIFR)
- `references/hartshorne-algebraic-geometry.pdf`  (Hartshorne, *Algebraic Geometry*, GTM 52)
- `references/fga-explained.pdf`  (Fantechi–Göttsche–Illusie–Kleiman–Nitsure–Vistoli,
  *Fundamental Algebraic Geometry: Grothendieck's FGA Explained*, AMS Math. Surveys 123)

Your job is NOT to fetch them. Your job is to:
1. **Verify** each is a real PDF (`file references/<name>.pdf`; if `file` is absent,
   inspect the `%PDF-` header / `%%EOF` trailer and page count via any available means,
   exactly as the existing `references/abelian-varieties.md` card documents for this host).
2. **Write a pointer card** `references/<slug>.md` for each (slugs below — keep the
   existing filenames, they are already correct, so the slug = the filename stem).
3. **Register** each in `references/summary.md` (append rows; do not delete/rewrite
   existing entries).
4. Build a **DEEP contents map** for each (depth = deep): map the specific
   theorems/sections named below to their exact section + page (document page AND, if
   the PDF is offset, the PDF/reader page — record the offset like the Milne card does).

The slugs to use (= existing filename stems):
- `mumford-abelian-varieties`
- `hartshorne-algebraic-geometry`
- `fga-explained`

## Deep-map targets (the locations the blueprint-writer will quote verbatim)

### `mumford-abelian-varieties` (THE canonical source for route (c))
Map exact section + page for:
- **The Theorem of the Cube** (Mumford §6, "The theorem of the cube"; statement + the
  proof structure — seesaw, etc.).
- **The Rigidity Lemma / Rigidity Theorem** (Mumford §4 / the corollary circle around
  the cube theorem: "a morphism V×W → A trivial on V×{w0} ∪ {v0}×W is trivial").
- **"An abelian variety contains no rational curves" / every morphism ℙ¹ → A is
  constant** (whichever Mumford section states this — likely a corollary of rigidity in
  §4, and/or the rational-maps discussion).
- The standing **conventions / hypotheses** Mumford uses (completeness, base field,
  what "abelian variety" means there).
Note any place Mumford's statement differs in hypotheses from Milne's notes
(`references/abelian-varieties.pdf`, already in tree) — the planner needs to know which
hypotheses are load-bearing.

### `hartshorne-algebraic-geometry` (genus-0 ⟹ ℙ¹ and ℙ¹ differentials)
Map exact section + page for:
- **A complete nonsingular curve of genus 0 over an algebraically closed field with a
  rational point is isomorphic to ℙ¹** (Hartshorne Chapter IV; the genus-0 classification
  — e.g. IV.1.3.5 / IV Example 1.3.5 or the curves §1 discussion).
- **Ω_{ℙ¹} ≅ O(−2) and H⁰(ℙ¹, Ω) = 0** (Chapter II §8 differentials + the cohomology of
  the twisting sheaf in III §5 — H⁰(ℙ¹, O(−2)) = 0).
- The **genus / arithmetic genus** definition and the genus-0 ⟺ H¹(O)=0 connection
  (II §8, III §5, IV §1).

### `fga-explained` (Route A — collected FGA chapters)
Map exact chapter + page for:
- **Kleiman, "The Picard scheme"** (which chapter number in the book; §4 existence,
  §5 Pic⁰).
- **Nitsure, "Construction of Hilbert and Quot schemes"** (chapter number; §representability).
- Any chapter on **Grothendieck's existence / descent / representable functors** the
  Route A engine would lean on.
Note: the project already has the standalone arXiv versions
(`references/kleiman-picard.pdf`, `references/nitsure-hilbert-quot.pdf`); the book may
have different page/section numbering — record the book's own numbering so the planner
can cite either.

## Out of scope
- Re-downloading any of the three files (they are present).
- Touching the existing `references/abelian-varieties.{md,pdf}`,
  `references/kleiman-picard.*`, `references/nitsure-hilbert-quot.*` cards.
- Any paraphrase of mathematical content in the pointer cards (locations only).

## Contents-map depth expected
deep
