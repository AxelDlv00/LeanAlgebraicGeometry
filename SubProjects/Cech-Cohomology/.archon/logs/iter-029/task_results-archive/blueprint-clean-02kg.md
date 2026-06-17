# Blueprint-Clean Report — iter-029 slug 02kg

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Pass scope:** New blocks added and edited blocks touched by the iter-029 blueprint-writer (Tag 02KG / 01EO reconcile — approx. L3132–L3484 new, L1180–L1188 edited).

---

## Summary

Two purity issues found and fixed. All source quotes verified verbatim against reference files. No missing `% SOURCE:`, `% SOURCE QUOTE:`, or `\textit{Source:}` lines in the new blocks. No missing `% SOURCE QUOTE PROOF:` blocks where required. Project-bespoke blocks (`lem:cover_datum_bridge`, `def:basis_cov_system`, `def:affine_cover_system`) correctly omit source lines.

---

## Fixes Applied

### Fix 1 — Non-standard SOURCE QUOTE label in `lem:standard_cover_cofinal` (was L3249)

**Old:**
```
  % SOURCE QUOTE (cofinality suffices): "Moreover,
```
**New:**
```
  % SOURCE QUOTE: "Moreover,
```
**Reason:** The `(cofinality suffices)` parenthetical is non-standard project-narrative commentary on the label. Convention is bare `% SOURCE QUOTE:`.

---

### Fix 2 — Project-history verbosity in `% NOTE:` of `lem:cech_acyclic_affine` (was L1183–1188)

**Old:**
```
  % NOTE: the top-level Lean target vanishes the absolute SECTION {\v C}ech
  % complex (def:section_cech_complex) rather than the relative pushforward
  % complex; the realizing name is
  % AlgebraicGeometry.sectionCech_affine_vanishing (axiom-clean). The old
  % relative-form name AlgebraicGeometry.CechAcyclic.affine has been de-pinned
  % here: it is a superseded declaration carrying a sorry as orphaned dead code,
  % used by nothing; keeping it pinned would mark this node [sorry]. The
  % CombinatorialCech.* / dependent-port helpers are unchanged and still used
  % verbatim.
```
**New:**
```
  % NOTE: The top-level Lean target vanishes the absolute section {\v C}ech
  % complex (def:section_cech_complex) rather than the relative pushforward
  % complex; the realizing name is
  % AlgebraicGeometry.sectionCech_affine_vanishing.
```
**Reason:** The phrases "de-pinned here", "superseded declaration carrying a sorry as orphaned dead code, used by nothing", "keeping it pinned would mark this node [sorry]", and "CombinatorialCech.* / dependent-port helpers are unchanged and still used verbatim" are project-history verbosity and Lean-status commentary. The retained text states the single relevant mathematical fact: which declaration realises this node.

---

## Source Quote Verification

All source quotes in the new blocks were verified verbatim against the reference files:

| Block | Reference file | Lines | Status |
|---|---|---|---|
| `lem:affine_serre_vanishing` | `stacks-coherent.tex` | L145–155 | ✓ verbatim |
| `lem:affine_faces_mem` | `stacks-schemes.tex` | L513–517 | ✓ verbatim |
| `lem:standard_cover_cofinal` (first quote) | `stacks-schemes.tex` | L531–532 | ✓ verbatim |
| `lem:standard_cover_cofinal` (second quote, after fix) | `stacks-schemes.tex` | L573–577 | ✓ verbatim |
| `lem:standard_cover_cofinal` (third quote) | `stacks-sheaves.tex` | L3861–3879 | ✓ verbatim (items 1–2 of lemma-cofinal-systems-coverings-standard-case) |
| `lem:affine_surj_of_vanishing` | `stacks-cohomology.tex` | L1592–1605 | ✓ verbatim |
| `lem:affine_injective_acyclic` | `stacks-cohomology.tex` | L1407–1422 | ✓ verbatim |
| `def:affine_cover_system` | `stacks-coherent.tex` | L160–163 | ✓ verbatim |
| `lem:qcoh_iso_tilde_sections` | `stacks-schemes.tex` | L691–719 | ✓ verbatim (items 1–4 of lemma-spec-sheaves) |
| `lem:affine_cech_vanishing_qcoh` | `stacks-coherent.tex` | L172–173 | ✓ verbatim |

---

## No-Touch Items (verified correct, left unchanged)

- `\leanok` / `\mathlibok` markers — not modified.
- `\lean{}` and `\uses{}` lists — not modified.
- Project-bespoke blocks (`lem:cover_datum_bridge`, `def:basis_cov_system`): correctly carry no `% SOURCE:` lines.
- `[EnoughInjectives]` disclosures in `lem:affine_serre_vanishing` and related blocks: legitimate hypothesis disclosures consistent with existing convention — left unchanged.
- All `\textit{Source: …}` first lines in source-derived blocks: present and correct.
- `% SOURCE QUOTE PROOF:` present in `lem:affine_serre_vanishing` (proof cites stacks-coherent.tex L147–156): correct.

---

## Files Modified

- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (2 edits)
