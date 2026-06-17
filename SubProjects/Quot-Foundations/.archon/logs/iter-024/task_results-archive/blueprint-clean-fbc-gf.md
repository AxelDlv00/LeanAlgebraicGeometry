# Blueprint Clean Report — fbc-gf (iter-024)

## Status: COMPLETE

## Files edited

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

Three project-history phrases stripped from rendered prose (Seam-B/C region and one
superseded-lemma tombstone):

| Line | Old | New |
|------|-----|-----|
| ~1869 | `is no longer on the live path to Lemma~…` | `is no longer on the path to Lemma~…` |
| ~2414 | `This is the live remaining crux of the affine section-level computation:` | `This is the crux of the affine section-level computation:` |
| ~2437 | `This is the live remaining obligation of the affine section-level computation;` | `This is the closing step of the affine section-level computation;` |

All `% LEAN SIGNATURE`, `% SOURCE QUOTE:`, `% SOURCE QUOTE PROOF:`, `% NOTE:`,
`% LEAN INTERNAL:` comment blocks in the Seam-A/B/C region were inspected and left
verbatim (including iter-024 references inside `%` comments, which are never rendered).
`\leanok` markers on `lem:base_change_mate_inner_value_eq`, `lem:base_change_mate_gstar_generator_close`,
`lem:base_change_mate_gstar_counit_transport`, and `lem:base_change_mate_gstar_transpose`
were not touched.

Citation discipline verified:
- `lem:base_change_mate_inner_value_eq`: `% SOURCE QUOTE:` present (stacks-coherent.tex,
  "describe pullbacks and pushforwards" step). ✓
- `lem:base_change_mate_gstar_generator_close` (Seam-B): `% SOURCE QUOTE:` present
  ("boils down to the equality", stacks-coherent.tex L933-938). ✓
- `lem:base_change_mate_gstar_transpose` (Seam-B assembly): same `% SOURCE QUOTE:`
  present. ✓
- Three eCancel atoms (A-2a/b/c): no external reference; no `% SOURCE QUOTE:` needed. ✓

LaTeX / `\uses{}` / `\label{}` formatting in the new eCancel blocks inspected — no errors
found.

---

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`

One rendered-prose Lean-leakage fix in the geometric-bridges subsection (lines ~1467-1469):

Removed the temporal phrase "at the present pin" and the Lean type names
`\texttt{SheafOfModules.IsFiniteType}` / `\texttt{IsQuasicoherent}` from the subsection
introductory paragraph. The mathematical point (Mathlib does not provide the affine-local
finite-sections result) is retained in timeless form.

```diff
- restricted sheaf over the base open. Neither is supplied directly by Mathlib at the
- present pin: Mathlib carries only the abstract local-generator predicates
- \texttt{SheafOfModules.IsFiniteType} / \texttt{IsQuasicoherent}, not the affine-local
- identification of \(\F|_W\) with the associated sheaf of \(\Gamma(\F, W)\) together
- with the finiteness this transports.
+ restricted sheaf over the base open. Neither is supplied directly by Mathlib: Mathlib
+ does not provide the affine-local identification of \(\F|_W\) with the associated sheaf
+ of \(\Gamma(\F, W)\) together with the finiteness this transports.
```

Citation discipline verified:
- G1 (`lem:gf_qcoh_fintype_finite_sections`): `% SOURCE QUOTE:` present (stacks-properties.tex
  L2092-2098, Tag 01PB, lemma-finite-type-module). Verbatim match confirmed. `% SOURCE QUOTE PROOF:`
  present (pointer + summary; tag not missing). ✓
- G3 (`lem:gf_flat_locality_assembly`): no external reference; no `% SOURCE QUOTE:` needed. ✓
- `thm:generic_flatness`: `% SOURCE:` and `% SOURCE QUOTE:` present (nitsure \S4). ✓

LaTeX / `\uses{}` / `\label{}` formatting in G1, G3, and `thm:generic_flatness` blocks
inspected — no errors found.

## Out of scope (not edited)
- Subsection heading "The affine base-change lemma and its remaining obligations" (line 821,
  FBC): outside focus area and pre-existing; "remaining obligations" is standard mathematical
  phrasing, not project-history narrative.
- "Proved directly in Lean" phrases in dévissage chain (GF lines 240–884): outside focus
  area (pre-G1 content); not edited this iter.
- All `%`-comment blocks mentioning iter-024, "this iter", "PROVED" engine, etc.: these are
  LaTeX comments, not rendered prose; left verbatim per directive.
