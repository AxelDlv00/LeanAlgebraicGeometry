# Reference Retriever Report

## Slug
register-new-sources

## Status
COMPLETE

All three user-supplied PDFs verified, deep-mapped, carded, and registered in
`summary.md`. No re-download was performed (files were already on disk, per directive).

## Sources fetched (verified + mapped — not downloaded)

- **Mumford, "Abelian Varieties" (TIFR 1970)** — `references/mumford-abelian-varieties.pdf`
  VERIFIED (`%PDF-1.5`, `%%EOF`, 290 pages). **Scanned image — no text layer**; mapped by
  rendering page images (pypdf→PIL) and reading them. Pointer `references/mumford-abelian-varieties.md`.
  Deep map: **Rigidity Lemma (Form I)** + Cor.1 §4 book p.43 (PDF p.54); abelian-variety
  **definition/conventions** §4 p.39 (PDF p.50); **Theorem of the Cube** §6 p.55 (PDF p.66),
  scheme version §10 p.89. Offset = book + 11.

- **Hartshorne, "Algebraic Geometry" (GTM 52, 1977)** — `references/hartshorne-algebraic-geometry.pdf`
  VERIFIED (`%PDF-1.3`, `%%EOF`, 514 pages). **Scanned image — no text layer**; mapped by
  rendering. Pointer `references/hartshorne-algebraic-geometry.md`. Deep map: **genus-0 ≅ ℙ¹**
  Example IV.1.3.5 doc p.297 (PDF p.314) + Exercise IV.1.3; **genus = dim H¹(O_X)** Prop IV.1.1
  doc p.294 (PDF p.311); **Ω_{ℙ¹}≅O(−2)** Euler seq Thm II.8.13 (doc p.176) + Ex.II.8.20.1
  ω_{ℙⁿ}≅O(−n−1) (doc p.182); **H⁰(ℙ¹,O(−2))=0** Thm III.5.1(a) (doc p.225). Offset = doc + 17 (body).

- **"FGA Explained" (AMS MSM 123, 2005)** — `references/fga-explained.pdf`
  VERIFIED (`%PDF-1.5`, `%%EOF`, 352 pages). **Has text layer** (cross-checked extraction).
  Pointer `references/fga-explained.md`. Deep map: **Kleiman Picard** = Ch.9 book p.237 (PDF p.247),
  §9.4 existence p.262, §9.5 Pic⁰ p.275, §9.6 Pic^τ p.291; **Nitsure Hilbert/Quot** = Ch.5 p.107,
  §5.5 Quot construction p.126; **Vistoli descent/Yoneda** Ch.2 §2.1 p.13 + Ch.4 stacks p.67;
  **Illusie Grothendieck existence** Ch.8 §8.4 p.204. Offset = book + 10.

## Index updates
- `references/summary.md` — appended 3 rows: `mumford-abelian-varieties`,
  `hartshorne-algebraic-geometry`, `fga-explained`. Existing rows untouched.

## Notes for Dispatcher

1. **No `file` binary on this host** (exit 127), exactly as `abelian-varieties.md`
   documents. Verified via `%PDF-` header + `%%EOF` trailer + `pypdf` page count.
   `pdftotext`/`pdftoppm`/`mutool`/`pymupdf` also absent — only `pypdf` 6.11.0 + PIL.
   For the two **scanned** PDFs (Mumford, Hartshorne) I rendered `page.images[0]`
   through PIL to read them; **neither has a text layer**, so any future agent quoting
   them must read the rendered image, not copy/paste. FGA does have a text layer.

2. **"Mor(ℙ¹,A) is constant" / "no rational curves on an AV" is NOT a separately
   labeled result in Mumford §4.** Mumford gives the **Rigidity Lemma (Form I, p.43)**
   and Corollaries 1–3, but leaves ℙ¹-constancy as a consequence. The explicit packaged
   statement the project wants to quote verbatim lives in **Milne, Prop 3.10**
   (`references/abelian-varieties.md`). For route (c), pair Mumford's rigidity-lemma
   primitive with Milne's ℙ¹-constancy corollary. Mumford's "(Form I.)" tag implies a
   scheme-theoretic **Form II** later (cube-theorem circle, Ch.III §10 area); I did not
   pin its exact page (Form I at p.43 is the load-bearing one for char-free rigidity).

3. **Hypothesis comparison Mumford vs Milne** (recorded in the Mumford card): both pin
   **completeness of the first factor** as load-bearing. Mumford bakes in
   irreducibility + algebraically-closed `k` via global conventions ("variety" =
   irreducible, p.39 footnote); Milne states `V×W` **geometrically irreducible**
   explicitly and allows non-closed fields. The planner should decide which framing the
   Lean object adopts.

4. **FGA book numbering ≠ arXiv numbering.** The volume numbers Kleiman as Ch.9 §9.4/§9.5
   and Nitsure as Ch.5 §5.5; the standalone arXiv preprints already in `references/`
   (`kleiman-picard.md` §4/§5, `nitsure-hilbert-quot.md`) use the arXiv numbering. Both
   cards now cross-reference each other so either citation resolves.

5. The Hartshorne genus-0 classification (Example IV.1.3.5) is over `k=k̄`, where the
   "rational point" hypothesis is automatic; the explicit rational-point form is
   **Exercise IV.1.3** (same page, doc p.297).

## Report path
`.archon/task_results/reference-retriever-register-new-sources.md`
