# Blueprint Clean Report — iter-037 (bchain)

**File:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Route B Section Audit (primary target)

Lines 3852–4388 (the iter-037 additions):

- **No Lean tactic / type-ascription leakage found.** All prose uses mathematical notation consistently.
- **No project-history / iteration-narrative** text in visible typeset body.
- **Source quotes verified verbatim** against `references/stacks-schemes.tex`:
  - `lem:qcoh_section_isLocalizedModule` SOURCE QUOTE (L701–702): matches exactly.
  - `lem:qcoh_section_isLocalizedModule` SOURCE QUOTE PROOF (L1262–1268): matches exactly.
  - `lem:qcoh_isIso_fromTildeGamma` SOURCE QUOTE (L1280–1284): matches exactly.
  - `lem:qcoh_isIso_fromTildeGamma` SOURCE QUOTE PROOF (L1380–1386): matches exactly.
  - `rem:o1i8_decomposition` SOURCE QUOTE PROOF (L1288–1386 with ellipses): constituent quotes match.
- **`\leanok` unchanged** — none added or removed.
- **`\uses{}` edges and mathematical statements unaltered.**

## Pre-existing Drift Fixed (outside Route B)

Eight targeted edits to pre-existing Lean leakage found elsewhere in the chapter:

### Edit 1 — cechFreeEval lemma body (former lines 1793–1811)
**Problem:** "The Lean entry point for the degree-p unfolding is `cechFreePresheafComplex_X` (which exposes ... by `rfl`)..." — explicit Lean meta-reference + `\operatorname{rfl}` tactic term.  
**Fix:** Removed the paragraph from visible prose; moved Lean assembly notes to a `% NOTE` comment. Also removed the bare `(\(\operatorname{cechFreeComplexAug}\))` parenthetical.

### Edit 2 — homCechComplex lemma body (former lines 2595–2605)
**Problem:** "The isomorphism is built from `HomologicalComplex.Hom.isoOfComponents` with all components the identity (`Iso.refl`), ... (a `rfl` lemma exposing ...)." — multiple Lean names and `\operatorname{rfl}` tactic term.  
**Fix:** Removed from visible prose; Lean construction detail moved to `% NOTE` comment.

### Edit 3a — absolute cohomology LES lemma statement (former line 3201)
**Problem:** `\(\operatorname{exact}_{1,2,3}\)` — Lean subscript naming convention in visible statement.  
**Fix:** Replaced with "three step-exactness lemmas (for positions 1, 2, and 3 of the sequence)".

### Edit 3b — absolute cohomology LES proof (former line 3207)
**Problem:** `\(\operatorname{covariant\_sequence\_exact}_{1,2,3}\)` in proof text.  
**Fix:** Replaced with "the corresponding step-exactness lemma of Lemma~\ref{lem:ext_covariant_les_mathlib}".

### Edit 4 — sectionCech_ab_exact lemma statement body (former lines 1002–1023)
**Problem:** Itemized strategy description using Lean declaration names (`sectionCech_isZero_homology_of_objD_exact`, `Function.Exact`, `objD q`, `exactAt_iff_isZero_homology`, `HomologicalComplex.exactAt_iff'`, `ShortComplex.ab_exact_iff_function_exact`, `sectionCechAbExact`, `dDiff_exact`, `Function.Exact.of_ladder_addEquiv_of_exact`) throughout.  
**Fix:** Rewrote as two-item mathematical description ("Reduction" and "Ladder transport") using `\ref{}` cross-references in place of raw Lean names. Mathematical content preserved.

### Edit 5 — sectionCech_ab_exact proof (former lines 1029–1055)
**Problem:** Proof text heavily Lean-centric — same Lean declaration names plus `sectionCechProductEquiv_p`, `sectionToModuleAddEquiv`, `sectionToModuleAddEquiv_apply`, `sectionProdEquiv_symm_apply`.  
**Fix:** Rewrote proof using mathematical language and `\ref{}` cross-references. Logical structure preserved: reduction to group-level exactness, additive ladder from `lem:section_cech_product_equiv`, commuting squares from `lem:section_cech_objd_apply` and `lem:section_cech_coface_match`, horizontal exactness from `lem:section_cech_module_exact`.

### Edit 6 — quasiIso_of_evaluation lemma body (former lines 1707–1711)
**Problem:** "The Lean entry point is `quasiIso_of_evaluation`, which combines..." — explicit Lean meta-reference.  
**Fix:** Replaced with direct mathematical statement: "This follows from joint conservativity of the evaluation functors ... combined with the fact that each evaluation functor preserves homology."

### Edit 7 — ext_covariant_les Mathlib lemma body (former line 3077)
**Problem:** `\(\operatorname{covariant\_sequence\_exact}_{1,2,3}\)` — Lean subscript naming.  
**Fix:** Replaced with "three individual step-exactness lemmas".

## Invariants Verified

- `\leanok` count: 52 (unchanged)
- `\mathlibok` count: 25 (unchanged)
- No `\uses{}` edges altered
- No mathematical statements altered
- All `% SOURCE QUOTE` and `% NOTE` comments retained
- Route B blocks (`lem:tilde_section_isLocalizedModule`, `lem:section_isLocalizedModule_of_isIso_fromTildeGamma`, `lem:section_isLocalizedModule_of_presentation`, `lem:qcoh_finite_presentation_cover`, `lem:presentation_over_basicOpen`, `lem:restrict_over_compat`, `lem:presentation_modulesRestrictBasicOpen`, `lem:qcoh_section_isLocalizedModule`, `lem:qcoh_isIso_fromTildeGamma`, `rem:o1i8_decomposition`) all intact and correct.

## Status

PASS — blueprint is clean for iter-037.
