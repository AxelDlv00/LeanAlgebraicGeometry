# Blueprint Clean Report — cech-bridge

**Target:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Iteration:** 010
**Outcome:** PASS — two Lean-leakage prose paragraphs stripped; all verbatim quotes validated.

---

## 1. Verbatim-quote validation

All four `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks that the directive flagged were
compared line-by-line against `references/stacks-cohomology.tex`.

| Block | Source lemma | Lines | Verdict |
|---|---|---|---|
| `lem:injective_cech_acyclic` — statement QUOTE | `lemma-injective-trivial-cech` | L1407–1422 | ✓ verbatim |
| `lem:injective_cech_acyclic` — supporting QUOTE | `lemma-cech-cohomology-derived-presheaves` | L1287–1298 | ✓ verbatim |
| `lem:injective_cech_acyclic` — PROOF QUOTE 1 | `lemma-injective-trivial-cech` proof | L1424–1431 | ✓ verbatim |
| `lem:injective_cech_acyclic` — PROOF QUOTE 2 | `lemma-cech-cohomology-derived-presheaves` proof | L1327–1342 | ✓ verbatim |
| `lem:ses_cech_h1` — statement QUOTE | `lemma-ses-cech-h1` | L1593–1605 | ✓ verbatim |
| `lem:ses_cech_h1` — PROOF QUOTE | `lemma-ses-cech-h1` proof | L1607–1628 | ✓ verbatim |
| `lem:cech_to_cohomology_on_basis` — PROOF QUOTE | `lemma-cech-vanish-basis` proof | L1716–1776 | ✓ verbatim |

Note: source line differences (e.g., a `\medskip\noindent` separator omitted from the quote)
are formatting-only and do not affect the text content.

---

## 2. Lean / implementation leakage removed

**Edit 1 — proof of `lem:injective_cech_acyclic`** (was lines 700–703):

Removed:
> "is not available off the shelf and is built from scratch at the formalisation level."

Replaced with:
> "is developed as part of the chapter's foundational content."

**Edit 2 — proof of `lem:higher_direct_image_presheaf`** (was lines 1122–1131):

Removed the paragraph:
> "…is a from-scratch build for X.Modules: Mathlib supplies such a comparison only for
> Sheaf J AddCommGrpCat (a value category that is not the project's category of
> O_X-modules), so the formalisation must construct the comparison directly… rather than
> invoking an existing Mathlib lemma."

Replaced with:
> "…is constructed directly from injective resolutions in X.Modules; the presheaf-level
> Čech δ-functor formalism over O_X-modules is developed as part of the chapter's content."

Both replacements preserve the mathematical point (this machinery is built here, not imported) while dropping Mathlib-state and prover-facing framing.

---

## 3. Preserved items (untouched)

- `\mathlibok` anchor `def:standard_affine_cover` and its `\lean{AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop}` hint.
- Every other `\lean{...}` hint throughout the chapter.
- All `\uses{...}` and `\label{...}` cross-references.
- Both new bridge lemma environments (`lem:injective_cech_acyclic`, `lem:ses_cech_h1`) and their proof sketches.
- The existing contracting-homotopy `% SOURCE QUOTE PROOF` of `lem:cech_acyclic_affine`.
- All `\leanok` and `\mathlibok` markers.

---

## 4. LaTeX hygiene

No LaTeX syntax errors introduced. Both edits replace prose within existing paragraph bodies; no LaTeX environments were opened, closed, or restructured.

---

## Summary

Two Lean/Mathlib-facing sentences in proof bodies were rephrased as timeless mathematical prose. All seven verbatim quote blocks validated as exact matches against the source. No other changes made.
