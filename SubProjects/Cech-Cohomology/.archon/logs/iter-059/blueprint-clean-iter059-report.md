# Blueprint-clean report — iter-059

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

Four targeted edits applied to the sections added by the blueprint-writer in iter-059. No `\leanok` markers were touched. Mathematical content of all new bridge notes, universe-reduction notes, and `lem:overProd_coproduct_distrib` is preserved intact.

---

## Edits performed

### 1. Lean-strategy paragraph removed from `lem:coproduct_distrib_fibrePower_zero` statement

**Removed** the paragraph starting "In the Lean formalization the σ-component is kept in the slice-product normal form…" (6 lines). This paragraph described an internal Lean representation choice ("slice-product normal form", "minimizing wide-pullback instance bookkeeping") with no mathematical content — pure implementation strategy leakage.

### 2. Lean-strategy paragraph removed from `lem:coproduct_distrib_fibrePower` statement

**Removed** the identical "In the Lean formalization…" paragraph from the statement of `lem:coproduct_distrib_fibrePower` (same text, 5 lines). Same reason.

### 3. Universe caveat cleaned in `lem:coproduct_distrib_fibrePower` statement

**Before** (lines 7775–7780 pre-edit):
```
\emph{Universe caveat.} This statement is proved at the index universe \(\iota : \operatorname{Type}
0\): the binary distributivity it rests on (Lemma~\ref{lem:isIso_sigmaDesc_fst_mathlib}) is available
in Mathlib only for index types in \(\operatorname{Type} 0\), so the leaves cannot be widened to
\(\operatorname{Type}*\). The reduction of the genuinely universe-polymorphic cover index to
\(\operatorname{Type} 0\) is performed once, at the consumer Lemma~\ref{lem:cech_backbone_left_sigma}.
```

**Issues removed:**
- Raw Lean universe notation `\operatorname{Type}*` (not standard mathematical notation)
- "in Mathlib only" (provenance note, not mathematics)
- "so the leaves cannot be widened to Type*" (implementation jargon)
- "performed once, at the consumer" (proof-organisation note, not mathematics)

**Replaced with** a clean paragraph titled `\emph{Universe constraint.}` that states the constraint mathematically and cross-references `lem:cech_backbone_left_sigma` for the reindexing argument.

### 4. Universe reduction paragraph cleaned in proof of `lem:cech_backbone_left_sigma`

**Before** (lines 7901–7913 pre-edit) contained:
- `\operatorname{Type}*` — raw Lean syntax
- "naively widening the leaves to Type* is not possible because it breaks the Mathlib comparison `\operatorname{isIso\_sigmaDesc\_fst}`" — raw Lean lemma name outside `\lean{…}`, plus implementation-strategy language ("breaks")
- "here, once:" — colloquial

**Replaced** with: "require the index type to lie in `\operatorname{Type} 0`; the cover index I of U is a finite type that need not live in `\operatorname{Type} 0`. The reduction is therefore performed here: choose an equivalence…" — same mathematical content, no raw Lean identifiers or strategy language.

---

## Citation check

All new blocks inspected:

| Block | Citation status |
|-------|----------------|
| `lem:overProd_coproduct_distrib` | Build target; deduced from `lem:prod_coproduct_distrib` + `lem:overProdLeftIsoPullback_mathlib` (both Mathlib). No external citation needed. |
| `lem:overProdLeftIsoPullback_mathlib` | Marked `\mathlibok`, "Provided by Mathlib." Correct. |
| `lem:isIso_sigmaDesc_fst_mathlib` | Marked `\mathlibok`, "Provided by Mathlib." Correct. Universe constraint noted without needing a Stacks quote. |
| `lem:pushforward_iso_preserves_qcoh` | Build target (`% NOTE: build target`). Proof rests on standard ringed-space pushforward; no external source quote required. |
| Six `\lean{…}` helper-name bundles | Lean declaration names in `\lean{…}` blocks — appropriate. |

No missing source quotes identified. No retriever dispatch required.

---

## No-ops confirmed

- `\leanok` markers: not added, not removed.
- Mathematical content of all new bridge notes, `lem:overProd_coproduct_distrib` statement, `lem:isIso_sigmaDesc_fst_mathlib` statement, universe-reduction note, and `\uses` on `lem:pushforward_iso_preserves_qcoh`: all preserved verbatim or with only syntactic cleanup (removing raw `Type*`, removing Lean identifier outside `\lean{}`).
- No LaTeX errors introduced.
