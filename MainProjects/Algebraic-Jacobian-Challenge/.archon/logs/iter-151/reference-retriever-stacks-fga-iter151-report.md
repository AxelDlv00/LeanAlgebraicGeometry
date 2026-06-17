# Reference Retriever Report

## Slug
stacks-fga-iter151

## Status
COMPLETE — all 8 directive items (6 Stacks tags across 4 chapters + 2 arXiv
papers) downloaded, verified, and pointed. Every Stacks tag statement was read
and confirmed against the fetched `.tex`; PDFs verified by magic bytes (`%PDF-1`
… `%%EOF`); arXiv e-prints decompressed to LaTeX source.

## Sources fetched

### Group A — Stacks Project (verbatim chapter `.tex` from GitHub master)
Tag↔label correspondence resolved authoritatively via the repo's `tags/tags`
file, then each label located in-file and its statement read.

- **`varieties.tex`** (ch.33) → `references/stacks-varieties.tex` (447 KB, verified)
  — pointer `references/stacks-varieties.md`. Covers:
  - **035U** = `section-geometrically-reduced` (§33.6), L323
  - **04QM** = `section-smooth` (§33.25), L4525
  - **056T** = `lemma-smooth-geometrically-normal` (Lemma 33.25.4), L4617
  - **0BUG** = `lemma-proper-geometrically-reduced-global-sections` (Lemma 33.9.3),
    L1933 — confirmed 8-part list; **part (4)** = geom-reduced ⇒ `k_i/k` finite
    separable, at L1944.
- **`fields.tex`** (ch.9) → `references/stacks-fields.tex` (144 KB, verified)
  — pointer `references/stacks-fields.md`. Covers:
  - **09HD** = `section-purely-inseparable` (§9.14), L1573
  - **030K** = `lemma-separable-first` (Lemma 9.14.6), L1704 — unique
    separable-then-purely-inseparable factorisation.
- **`algebra.tex`** (ch.10) → `references/stacks-algebra.tex` (1.77 MB, verified)
  — pointer `references/stacks-algebra.md`. Covers:
  - **00T7** = `lemma-standard-smooth` (Lemma 10.137.6), **L37259** — 7-part list;
    **part (2)** = `Ω_{S/R}` free on `dx_{c+1},…,dx_n`.
- **`coherent.tex`** (ch.30) → `references/stacks-coherent.tex` (313 KB, verified)
  — pointer `references/stacks-coherent.md`. Covers:
  - **02KH** = `lemma-flat-base-change-cohomology` (Lemma 30.5.2), L948 —
    `[Flat base change]`; **part (2)** = the `H^0`-with-base-change form (S3.pi.1).

### Group B — arXiv (PDF + LaTeX e-print, both verified)
- **Kleiman, "The Picard scheme"** (arXiv:math/0504020) →
  `references/kleiman-picard.pdf` (974 KB, 83 pp.) +
  `references/kleiman-picard.tar.gz` +
  `references/kleiman-picard-src/kleiman-picard.tex` (6613 lines) — pointer
  `references/kleiman-picard.md` (**deep map**). Section→page map taken from the
  document's own TOC (PDF p.1) and corroborated by per-page ghostscript text
  extraction; printed page = physical page (offset 0). Flagged for re-scoping
  Route A: §4 existence (`th:main` L2155), **§5 `Pic⁰`/Jacobian pp.36–51**
  (`rmk:Jac` L3990, `rmk:Ablsch` L3920, `cor:sm` L3421, `th:qpp&p` L2935,
  `thm:tgtsp` L3265), §6 `Pic^τ` finiteness (`th:Ptaufin` L4519, `rmk:curves`
  L4682). Keyword→page index for "Jacobian"/"abelian variety"/"smooth curve"
  included.
- **Nitsure, "Construction of Hilbert and Quot Schemes"** (arXiv:math/0504590) →
  `references/nitsure-hilbert-quot.pdf` (380 KB, 36 pp.) +
  `references/nitsure-hilbert-quot.tar.gz` +
  `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (3390 lines) —
  pointer `references/nitsure-hilbert-quot.md` (medium map). 6 sections; core =
  §4 flattening stratification (p.18), §5 Quot construction (p.23).

## Index updates
- `references/summary.md` — appended 6 entries: `stacks-varieties`,
  `stacks-fields`, `stacks-algebra`, `stacks-coherent`, `kleiman-picard`,
  `nitsure-hilbert-quot`. (No existing entries deleted/modified.)

## Notes for Dispatcher
- **All directive tag numbers were correct this round.** Every tag→label→decimal
  mapping the directive stated matched the live `tags/tags` database and the
  fetched chapters (035U §33.6, 04QM §33.25 / 056T Lemma 33.25.4, 0BUG Lemma
  33.9.3, 09HD §9.14 / 030K Lemma 9.14.6, 00T7 Lemma 10.137.6, 02KH Lemma
  30.5.2). The prior round's wrong tag numbers are not reproduced here.
- **Cite by Stacks tag + label, not by decimal number.** Tags are permanent;
  the decimal section/lemma numbers are auto-generated and can drift between
  snapshots. Pointer files give exact **line numbers** for the fetched copies
  (master as of 2026-05-20) plus the permanent tag/label.
- **arXiv e-prints are single gzipped `.tex` files**, not tar archives (the
  internal gzip filename says `.tar`, but the bytes are plain LaTeX). They are
  decompressed under `<slug>-src/`. The `.tar.gz` names are kept as the directive
  specified, but treat them as `.tex.gz`.
- **PDF page numbers are the arXiv self-pagination** (Kleiman 1–81, Nitsure
  1–35/36), which differs from the AMS *FGA Explained* book pagination (Kleiman
  pp.235–321, Nitsure pp.105–137). The plan agent should use the arXiv PDF pages
  when reading these local files.
- For the **Route A re-scope**: Kleiman §5 "The connected component of the
  identity" is the section that establishes `Pic⁰` and, for a smooth proper
  curve, that it is an abelian variety (the Jacobian) — pp.36–51, with the
  explicit Jacobian remarks at pp.49–51. §4 (existence) and §6 (`Pic^τ`
  finiteness, `Pic⁰=Pic^τ` for curves) are the supporting load-bearing pieces;
  the full functor-representability apparatus of §§2–3 + Nitsure is the heavier
  machinery a re-scope would aim to trim.

## Report path
`.archon/task_results/reference-retriever-stacks-fga-iter151.md`
