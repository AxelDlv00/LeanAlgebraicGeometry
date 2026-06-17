# Blueprint Clean — iter-033 Report

**Chapters checked:** `Cohomology_FlatBaseChange.tex`, `Picard_QuotScheme.tex`, `Picard_GrassmannianCells.tex`

---

## Cohomology_FlatBaseChange.tex

### Scope: FBC-B chain (7 blocks) + thm:flat_base_change_pushforward

**Source-quote validation (L3/L4/L5 and reduction block):**

- `lem:base_changed_equalizer_diagram` (L3) — SOURCE QUOTE present and validated verbatim against `references/stacks-coherent.tex` lines 1014–1026. The ellipsis in the quote covers the omitted Čech-cohomology equality sentence. ✓
- `lem:flat_base_change_separated` (L4) — SOURCE QUOTE "Since $A \to B$ is flat, the same thing remains true on taking cohomology." matches stacks-coherent.tex line 1027 exactly. ✓
- `lem:flat_base_change_mayer_vietoris` (L5) — SOURCE QUOTE present and validated against stacks-coherent.tex lines 1030–1036; ellipsis covers the Čech spectral-sequence sentence. ✓
- `lem:flat_base_change_reduce_global_sections` (reduction block) — SOURCE QUOTE present and validated against stacks-coherent.tex lines 980–991; multiple ellipses cover intervening lemma-citation phrases. ✓

No missing source quotes found.

**Purity edits made:**

1. **Removed iter-032 project-history comment block** (the `% ===...===` block preceding the FBC-B section, which named "slug fbcb, iter 032" and used internal abbreviations L0–L5). Verbosity per the standard purity rule.

2. **`lem:finite_affine_cover_qcqs` proof** — stripped two Lean identifier references:
   - `\texttt{Scheme.affineCover}` → prose "Mathlib's affine cover and the finite-subcover property"
   - `\texttt{IsSeparated}/\texttt{isAffineOpen\_inter}` → "Mathlib, for separated schemes"

3. **`lem:base_changed_equalizer_diagram` proof** — stripped one Lean identifier:
   - `\texttt{TensorProduct.prodRight}` → "Mathlib, tensor product preserves finite products"

**Blocks confirmed clean (no edits needed):**
- `lem:sheaf_equalizer_products_mathlib` — `\mathlibok` anchor; Lean names in `\texttt{}` are standard for Mathlib anchors.
- `lem:gamma_finite_equalizer` — no Lean leakage.
- `lem:flat_base_change_separated` — no Lean leakage.
- `lem:flat_base_change_mayer_vietoris` — no Lean leakage.
- `lem:flat_base_change_reduce_global_sections` — no Lean leakage.
- `thm:flat_base_change_pushforward` — `% NOTE:` block at line 3504 is a semantic marker (review domain); not touched. SOURCE QUOTE PROOF block intact.
- `% archon:covers` line at file top confirmed present and untouched.
- No `\leanok`/`\mathlibok` markers were added or removed.
- No `\uses{}` fields were altered.

---

## Picard_QuotScheme.tex

### Scope: three new OverRestrictBridge blocks

Blocks checked: `def:over_restrict_equiv`, `lem:over_restrict_functor_iso`, `lem:over_restrict_pullback_iso`.

**Purity edits made:**

1. **`def:over_restrict_equiv` proof** — removed Lean-specific jargon:
   - `\emph{definitionally}` + "which holds by definitional equality" → "which holds by construction"

2. **`lem:over_restrict_functor_iso` proof** — two fixes:
   - "an equality that holds by definitional equality" → "an equality that holds by construction"
   - "the required ring-morphism equality is the routine comparison discharged automatically by the category-theoretic discharger" → "the required ring-morphism equality is routine"

**No source quotes needed** — all three blocks are explicitly "project-bespoke infrastructure (no external source)".

**Blocks confirmed clean after edits:**
- No Lean tactic syntax (erw/rw/simp/etc.) present in any of the three blocks.
- No per-iteration narrative verbosity.
- No `\leanok` markers present on the new blocks (correct — `sync_leanok` phase manages those).
- `\uses{}` fields intact.

**Other NOTEs in the chapter** (not touched):
- `% NOTE (iter-031):` at `lem:over_restrict_iso` line 3109 — review semantic marker, not touched.
- `% NOTE:` blocks elsewhere in the chapter — review domain, not touched.

---

## Picard_GrassmannianCells.tex

### Scope: three new coverage blocks + redundant cocycle narrative in def:gr_glued_scheme

**New blocks confirmed clean (no edits needed):**
- `lem:gr_awayMulCommEquiv_comp_awayInclLeft` — no Lean leakage, no SOURCE QUOTE needed (bespoke), clean.
- `lem:gr_chartTransition'_cocycle` — no Lean leakage, no SOURCE QUOTE needed (bespoke), clean.
- `def:gr_the_glue_data` — no Lean leakage, no `\leanok` (definition assembly, correct), clean.

**Redundant cocycle narrative trimmed:**

In `def:gr_glued_scheme`, the inline "residual cocycle obligation" section (formerly ~30 lines explaining the categorical reduction to the ring identity Φ = id and the proof via image-matrix cocycle computation) was trimmed to a brief cross-reference since this content is now fully covered by the new `lem:gr_chartTransition'_cocycle` and `lem:gr_cocycle_phi_id` blocks:

**Removed:** The multi-paragraph proof sketch from "The residual cocycle obligation. What remains is the t'-cocycle field..." through the ring identity display and matrix reduction discussion.

**Replaced with:**
```
\emph{Cocycle field.} The \(t'\)-cocycle coherence
\(t'_{I,J,K} \circ t'_{J,K,I} \circ t'_{K,I,J} = \mathrm{id}\)
follows from \cref{lem:gr_chartTransition'_cocycle} via the ring identity
\cref{lem:gr_cocycle_phi_id}.
```

**Preserved:**
- `% NOTE (formalization status, iter-031):` block at lines 1610–1622 — review semantic marker, not touched.
- `% NOTE:` block in `lem:gr_chartTransition'_fac` (HasPullback instance diamond) — review domain, not touched.
- `% NOTE (iter-031, declaration-ordering constraint):` block — review domain, not touched.
- The "With this field in hand the glue datum is complete:..." assembly passage — retained (structural definition content).

---

## Summary

| Chapter | Edits Made | Source Quote Issues |
|---------|-----------|---------------------|
| FlatBaseChange | 3 edits (1 comment removal, 2 Lean identifier strips) | All 4 target quotes validated ✓ |
| QuotScheme | 2 edits (Lean jargon fixes in 2 of 3 new blocks) | None (bespoke blocks) |
| GrassmannianCells | 1 edit (trim redundant cocycle prose) | None (bespoke blocks) |

No `\leanok`/`\mathlibok` markers were added or removed. No `\uses{}` fields were altered. The `% archon:covers` directive at the top of FlatBaseChange.tex is intact.
