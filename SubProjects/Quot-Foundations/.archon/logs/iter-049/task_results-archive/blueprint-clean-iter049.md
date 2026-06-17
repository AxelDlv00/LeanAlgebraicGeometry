# Blueprint Clean — iter-049

**Status:** COMPLETE

## Chapters processed

### 1. `Picard_GrassmannianQuot.tex` (NEW)

**Verdict: Clean — no changes needed.**

All five `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks were verified verbatim against
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`:

| Block | Lines in source | Blueprint quote | Verified |
|---|---|---|---|
| `def:gr_chart_quotient` | L898–903 | "We next define a rank $d$ locally free sheaf $\U$…" | ✓ |
| `def:gr_universal_quotient_sheaf` | L903–907 | "Compatible with the co-cycle…" | ✓ |
| `def:tautological_quotient` | L908–910 | "This is compatible with the homomorphisms $u^I$…" | ✓ |
| `def:grassmannian_functor` | L557–564 | "represents the contravariant functor…" | ✓ |
| `thm:grassmannian_universal_property` | L546–566 | "Show that $\grass(r,d)$ together with the quotient…" | ✓ |

No Lean leakage, project history, or LaTeX errors found.

---

### 2. `Picard_FlatteningStratification.tex` (G3 block rewritten)

**Verdict: Cleaned — 6 Lean/project-history comment blocks removed.**

Removed the following `% ...` comment blocks from the LaTeX source (they are invisible
in rendered output but violate blueprint purity as source):

1. **`lem:gf_finiteType_affine_finite_cover_generated`** — removed 7-line
   `% LEAN STATUS: base-case seam, project-built (Mathlib-absent). Proposed decl…`
   block (referenced internal Lean declaration names and assembly details).

2. **`lem:gf_qcoh_finite_sections_globally_generated`** — removed 10-line
   `% LEAN STATUS: base-case assembly, project-built (Mathlib-absent). Decl…`
   block (described Lean signature details and cross-refs to other Lean declarations).

3. **`lem:gf_qcoh_sections_free_epi`** — removed 8-line
   `% LEAN STATUS: base-case specialisation, project-built (Mathlib-absent). Decl…`
   block (described tilde–Γ adjunction strategy in Lean implementation terms).

4. **`lem:gf_qcoh_fintype_finite_sections`** — removed 4-line
   `% LEAN STATUS: G1 — project-built (mathlib-build target this iter)…`
   block (contained "this iter" project-history reference and STRATEGY pointer).

5. **`lem:gf_flat_locality_assembly`** (the rewritten G3 block) — removed 14-line
   `% LEAN STATUS: G3 — project-built. Flatness of Γ(F,W)…` block (contained "prior
   error" narrative, Mathlib anchor names tagged `[verified]`, and "Built after G1"
   project-history note).

6. **`thm:generic_flatness`** — removed 30-line block comprising:
   - `% NOTE (re-signed): the Lean signature…` (project history: described prior
     signature, `archon-protected.yaml` reference, "Lean file is the source of truth")
   - `% LEAN SIGNATURE HEADER (matches the landed .lean file):…` (embedded Lean
     code snippet with typeclass binders)
   - `% NOTE (iter-023): \`[QuasiCompact p]\` is essential…` (iter-number reference;
     the mathematical content is already captured in the proof prose at Step 1 which
     cites `[QuasiCompact p]` directly)

**Source quotes verified intact** after all edits: all `% SOURCE QUOTE` blocks for the
edited lemmas (`gf_finiteType_affine_finite_cover_generated`, `gf_qcoh_finite_sections_globally_generated`,
`gf_qcoh_sections_free_epi`, `gf_qcoh_fintype_finite_sections`, `thm:generic_flatness`)
remain present and unchanged. The project-built geometric bridge `lem:gf_flat_locality_assembly`
has no external source citation (correct — it is a project-built step with no single
upstream reference).

The preserved/protected blocks (`def:sectionMul`, seam-1
`lem:gf_finiteType_affine_finite_cover_generated`,
`lem:gf_qcoh_finite_sections_globally_generated`,
`lem:gf_qcoh_sections_free_epi`) were not restructured; only their Lean-status
comment headers were stripped.

---

### 3. `Picard_SectionGradedRing.tex` (tensorPowAdd paragraph augmented)

**Verdict: Cleaned — 1 header comment block removed.**

Removed the 8-line `% This chapter blueprints the Mathlib-absent infrastructure…`
comment at the top of the file. The block:
- Named a specific Lean file path (`AlgebraicJacobian/Picard/SectionGradedRing.lean`)
- Used "(1:1 slug, to be scaffolded)" — Lean development project language
- Referenced `def:sectionGradedRing / def:sectionGradedModule` in a "not restated here"
  note that is now already implicit from the chapter introduction prose.

The `\providecommand` declarations and all mathematical content are unchanged.

No missing source quotes were found in this chapter: all cited blocks for
`def:sheafTensorObj` (Stacks Tag 01CA), `def:sheafTensorPow` (Stacks Tag 01CU),
`lem:sheafTensorPow_add` (Stacks Tag 01CU), `lem:sectionGradedRing_gcommSemiring`
(Stacks Tag 01CV), and `lem:sectionGradedModule_gmodule` (Stacks Tag 01CV) carry
verbatim source quotes.

---

## Summary

| Chapter | Changes | Source quotes |
|---|---|---|
| `Picard_GrassmannianQuot.tex` | None | All 5 verified verbatim ✓ |
| `Picard_FlatteningStratification.tex` | 6 Lean/history blocks removed | All quotes intact ✓ |
| `Picard_SectionGradedRing.tex` | 1 header comment removed | All 5 verified ✓ |

No `reference-retriever` spawn required — all cited blocks already carry verbatim quotes.
