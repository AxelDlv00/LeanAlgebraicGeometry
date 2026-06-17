# Reference Retriever Directive

## Slug
abelian-varieties

## What I need

The project needs the canonical source for **abelian-variety rigidity**, to settle
two questions:

1. **The rigidity lemma** (Mumford's "rigidity lemma" / via the theorem of the cube)
   and its corollary that **every morphism from `ℙ¹` (a genus-0 curve) to an abelian
   variety / smooth proper group scheme is constant** — equivalently, an abelian
   variety contains no rational curves. I need the verbatim statement AND proof so I
   can determine whether this "Mor(ℙ¹,A) constant" fact can be proved via the bare
   rigidity lemma WITHOUT invoking Serre duality (`H^0(Ω)=0`) or the Albanese/Picard
   construction.
2. The **Albanese universal property** of `Pic⁰` for a curve (Abel–Jacobi
   functoriality), to back the project's Route A positive-genus arm.

## Sources to fetch (in priority order)

1. **J.S. Milne, "Abelian Varieties" (course notes)** — freely available at
   `https://www.jmilne.org/math/CourseNotes/av.html` (PDF link on that page, typically
   `https://www.jmilne.org/math/CourseNotes/AV.pdf`). This is open-access and contains
   the rigidity theorem, "morphisms from `ℙ¹` to an abelian variety are constant", and
   the Albanese material. PRIMARY target — please fetch this.
2. **Mumford, "Abelian Varieties"** (Tata Institute / Oxford, 1970) — the canonical
   source; §4 "The Rigidity Lemma". Likely paywalled / no open copy. Best-effort only;
   if not openly available, report "not found" for this one and rely on Milne.

If Milne's AV notes are retrieved, that is sufficient for my needs. Download the real
PDF (verify it is the document, not an HTML error page), write the pointer
`references/abelian-varieties.md` with a section/contents map (note the page/section
numbers of: the rigidity lemma; the "Mor(ℙ¹,A) constant" / no-rational-curves
corollary; the Albanese universal property), and register it in `references/summary.md`.
