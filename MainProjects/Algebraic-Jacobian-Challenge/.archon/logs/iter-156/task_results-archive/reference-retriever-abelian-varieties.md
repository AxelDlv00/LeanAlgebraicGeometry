# Reference Retriever Report

## Slug
abelian-varieties

## Status
COMPLETE
(Primary source — Milne's "Abelian Varieties" — downloaded and verified; it fully
covers both directive items. Secondary best-effort source — Mumford 1970 — has no
legitimate open copy; reported not-retrieved per the directive's explicit fallback.)

## Sources fetched

- **J.S. Milne, "Abelian Varieties" (course notes, v2.00, 2008)** —
  https://www.jmilne.org/math/CourseNotes/AV.pdf — downloaded
  `references/abelian-varieties.pdf` (PDF, 172 pp, 1.26 MB). VERIFIED: `%PDF-` header +
  `%%EOF` trailer, parses cleanly with pypdf, TOC and target theorems extracted.
  (`file`/`pdftotext`/`pdftoppm` are not installed on this host; verified by byte
  inspection + a pypdf parse instead.) No open LaTeX source exists (PDF-only). Pointer
  written: `references/abelian-varieties.md`.

- **D. Mumford, "Abelian Varieties" (Tata Institute / Oxford, 1970)** — NO legitimate
  open copy located. The only PDFs found (wstein.org course-references folder; nLab-
  hosted Part I–IV scans linked from ncatlab.org/nlab/show/abelian+variety) are
  unauthorized scans of a still-copyrighted book, not an open-access publication; TIFR's
  own archive URLs returned 301/000. Per the directive ("Best-effort only; if not
  openly available, report 'not found' … and rely on Milne") this source is treated as
  not retrieved. No separate pointer file written (single-slug pointer documents the
  retrieved Milne source; Mumford status recorded here + as a caveat).

## Index updates
- `references/summary.md` — appended 1 entry: `abelian-varieties`.

## Findings relevant to the directive's questions

**(1) Rigidity lemma & "Mor(ℙ¹,A) constant" WITHOUT Serre duality — answer: YES,
provable from the bare rigidity circle.** The verbatim chain in Milne (read the PDF for
exact statements; locations only here):
- **Theorem 1.1 (Rigidity Theorem)**, §I.1 doc p.8 / PDF p.14: for `α : V × W → U`
  with `V` complete and `V × W` geometrically irreducible, if both coordinate axes
  collapse to a point then `α` is constant. Proof is purely geometric (completeness +
  properness pushforward of `𝒪`), no `H⁰(Ω)`.
- **Theorem 3.2**, §I.3 doc p.15 / PDF p.23: a rational map from a *nonsingular* variety
  to an abelian variety is defined everywhere (via Lemma 3.3, indeterminacy is pure
  codim 1; for a curve there is no codim-1 locus, so it is a morphism). No Serre duality.
- The **dimension-1 case** (§I.3, PDF p.25): embed the smooth curve in a complete smooth
  curve, extend, and apply Rigidity Theorem 1.1 to conclude the map is constant.
- **Proposition 3.10**, §I.3 doc p.20 / PDF p.26: every rational map from a *unirational*
  variety (in particular ℙⁿ and ℙ¹) to an abelian variety is **constant** — the proof
  reduces to `ℙ¹ × ⋯ × ℙ¹ → A` and inducts from the curve case + rigidity.

So the project's "no rational curves on `A`" / `Mor(ℙ¹,A)` constant is reachable from
the theorem-of-the-cube ⟶ rigidity-lemma route alone, **independently of**
`H⁰(C,Ω_C)=0` / Serre duality. NB the relevant `genusZeroWitness`/`rigidity_over_kbar`
gap (see [[kdm-lemma-false-as-stated]]) is about producing `df=0` for a *genus-0*
target object — Milne's route gives constancy of maps *into* an AV, which is the dual
framing; the planner should check which direction the Lean obligation actually needs
before assuming this discharges the Serre-duality dependency.

**(2) Albanese universal property of Pic⁰/Jacobian — Proposition 6.1 / 6.4 + Remark
6.5**, §III.6 doc p.104 / PDF p.110–111: `f_P : C → J` is universal for maps from `C`
to abelian varieties sending `P ↦ 0`; Remark 6.5 states `(J,F)` is the Albanese variety
of `C`. Standing hypothesis there: `C` complete nonsingular of **genus g > 0** with a
k-rational point. Backs Route A's positive-genus arm.

## Notes for Dispatcher
- No pre-existing `references/` entry was wrong or stale; only appended.
- Milne (Intro NOTES, p.5) names Mumford 1970 as *the* canonical modern source but it is
  copyright-restricted with no authorized open copy — do not redispatch for it; Milne's
  proofs are complete and citable for everything this directive needs.
- Related sources the dispatcher may want next, if the genus-0 `df=0` framing turns out
  to genuinely need the dual statement: Milne §I.5 (Theorem of the Cube, p.21) is the
  upstream input to Rigidity and is already in this same PDF — no new fetch needed.

## Return
abelian-varieties: COMPLETE — 1 source downloaded (PDF), 1 pointer file written
(Mumford 1970 not openly available — relied on Milne per directive).
Report: .archon/task_results/reference-retriever-abelian-varieties.md
