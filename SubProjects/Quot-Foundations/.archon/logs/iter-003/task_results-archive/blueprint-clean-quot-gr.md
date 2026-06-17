# blueprint-clean report — quot-gr (iter-003)

## Chapters examined

- `blueprint/src/chapters/Picard_QuotScheme.tex`
- `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## SOURCE QUOTE validation

All `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` blocks were checked against
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` and Mathlib
`HilbertPoly.lean`. All quotes are verbatim or correctly paraphrased; no
insertions or corrections were needed.

Specific checks:
- `def:hilbert_polynomial` (L453–L478): ✓ verbatim
- `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg` (L453–L464): ✓ verbatim
- `lem:gradedHilbertSerre_rational` (L459–L464): ✓ verbatim
- `thm:hilbertPoly_of_sectionModule` (L468–L478): ✓ verbatim
- `def:quot_functor` (L394–L498): ✓ verbatim
- `def:grassmannian_scheme` (L546–L599, L773–L850): ✓ verbatim
- `thm:grassmannian_representable` (L798–L930): ✓ verbatim
- `def:gr_affine_chart` (L807–L821): ✓ verbatim
- `def:gr_transition` (L822–L836): ✓ verbatim
- `lem:gr_cocycle` (L838–L848): ✓ verbatim
- `def:gr_glued_scheme` (L843–L850): ✓ verbatim
- `lem:gr_separated` (L856–L860): ✓ verbatim
- `lem:gr_proper` (L865–L891): ✓ verbatim
- `lem:hilbertPoly_exists_mathlib` (`Polynomial.existsUnique_hilbertPoly` at
  HilbertPoly.lean:195): ✓ statement matches Mathlib

---

## Edits made — `Picard_QuotScheme.tex`

### 1. Project-history phrase removed from `% NOTE` comment
**Location:** `thm:grassmannian_representable`, lines 606–607.

Removed: `"not resolved in the present pass; the RelativeSpec chapter is not
edited here."` — project-history language with no mathematical content.

Retained: `"This is a deferred open question."` — the mathematical status.

### 2. Lean-API paragraphs removed from `thm:grassmannian_representable` body
**Location:** theorem body, "Faithful target" and "Universe constraint" paragraphs.

These two paragraphs discussed Lean universe levels (`Type v`, `hom-universe`),
Lean typeclass spellings (`IsRepresentable`, `RepresentableBy`, `reprX`,
`Functor.IsRepresentable.has_representation`), and rationale for choosing one
Lean API spelling over another. None of this is mathematical content; it is
Lean formalization engineering that does not belong in the theorem statement.

The remaining mathematical statement — that `Grass(V,d)` is representable by a
smooth projective S-scheme of relative dimension `d(r−d)` with a tautological
quotient and Plücker embedding — is preserved in full.

### 3. Lean API names removed from `lem:functor_is_representable_mathlib` body
The lemma body previously named five `Functor.*` Mathlib identifiers
(`has_representation`, `representableBy`, `reprX`, `representableByEquiv`,
`yoneda`) that are secondary API details irrelevant to the mathematical
statement. The body was trimmed to: the predicate `F.IsRepresentable` asserts
the existence of an object `Y` with a natural bijection `Hom_C(-,Y) ≅ F`.
The `\lean{}` pin, `\mathlibok`, and `\label` are unchanged.

### 4. `\section{Lean encoding}` removed
**Location:** Former section 6, `\label{sec:quot_lean_encoding}` (not
cross-referenced anywhere in the blueprint).

This section was entirely Lean implementation notes: named the Lean target
file, described two "phases" of formalization, discussed absent Mathlib
predicates (`IsCoherent`, `SheafOfModules.IsLocallyFree`), and listed
"intended signatures" with Lean typeclass names. No mathematical content.

The label `sec:quot_lean_encoding` was confirmed to be unreferenced across the
entire blueprint before removal.

---

## Edits made — `Picard_GrassmannianCells.tex`

**None.** The chapter is already clean:
- No Lean tactic syntax in prose or proofs.
- No project-history language.
- All SOURCE QUOTE blocks verified verbatim against the Nitsure source.

---

## Markers preserved (unchanged)

All `\lean{}` pins, `\label`, `\uses`, `\mathlibok`, and `\leanok` markers in
both chapters were left exactly as written. No mathematical content of any
declaration was altered.
