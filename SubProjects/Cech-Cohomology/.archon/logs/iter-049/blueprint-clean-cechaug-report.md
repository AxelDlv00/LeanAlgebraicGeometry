# Blueprint-clean report — iter-049 (`lem:cech_augmented_resolution`)

**File edited:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`  
**Block:** `\begin{proof}` of `\label{lem:cech_augmented_resolution}` (~lines 6837–6874)

---

## SOURCE QUOTE verification

### `% SOURCE QUOTE:` (lemma statement, lines 6793–6807)
Verbatim match against `references/stacks-coherent.tex` lines 68–82.  **PASS.**

### `% SOURCE QUOTE PROOF:` (lines 6826–6836)
Selective quote with ellipsis (`...`) eliding the mid-paragraph sentence ("Similarly for a localization...") and the display-math homotopy definition; the boundary sentences and the homotopy rule formula are verbatim.  
Cross-checked against `references/stacks-coherent.tex` lines 80–103.  **PASS.**

---

## Issues found and fixed

### Fix 1 — Project-history language (lines 6848–6849, before edit)

**Before:**
```latex
  (Lemma~\ref{lem:qcoh_iso_tilde_sections}, now unconditional for quasi-coherent
  \(\mathcal{F}\) via Lemma~\ref{lem:qcoh_isIso_fromTildeGamma}) we have
```

The phrase "now unconditional" is planner-narrative ("this became unconditional in iter N") with no mathematical content.  Both referenced labels exist in the blueprint (`lem:qcoh_iso_tilde_sections` at line 3724, `lem:qcoh_isIso_fromTildeGamma` at line 5212).

**After:**
```latex
  (Lemmas~\ref{lem:qcoh_iso_tilde_sections} and \ref{lem:qcoh_isIso_fromTildeGamma}) we have
```

Both citations are retained; the historical annotation is removed.

---

### Fix 2 — Lean identifier leakage (lines 6869–6871, before edit)

**Before:**
```latex
  Lemma~\ref{lem:cech_acyclic_affine}
  (\(\operatorname{sectionCech\_affine\_vanishing}\)), proved there through the
  prime-local span certificate \(\operatorname{exact\_of\_isLocalized\_span}\).
```

`sectionCech_affine_vanishing` and `exact_of_isLocalized_span` are Lean definition names (underscore-separated, not mathematical notation).  "prime-local span certificate" is a project-internal description of a Lean proof method.

**After:**
```latex
  Lemma~\ref{lem:cech_acyclic_affine}.
```

The mathematical cross-reference is preserved; the Lean-name parenthetical and implementation description are removed.

---

## No-touch confirmation

- `\leanok`, `\mathlibok`, `\lean{}` markers: untouched.
- `\uses{}`, `\label{}`, `\lean{}` in the lemma-statement block: untouched.
- `\textit{Source: …}` citation lines: untouched.
- All other proof blocks in the chapter: untouched.

---

## Status

**PASS.** Proof block reads as timeless, standalone mathematical prose. SOURCE QUOTE comments are verbatim-accurate. No further issues detected in this block.
