# Report: blueprint-clean — keystone sub-lemma chain

**Iteration:** 041  
**Slug:** keystone  
**Target file:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

All Lean-syntax leakage and implementation-note verbosity has been stripped from the four new
sub-lemma blocks, the rewritten keystone proof, and the `rem:o1i8_decomposition` remark.
Mathematics is intact; `\lean{}`, `\uses{}`, `\mathlibok`, SOURCE/SOURCE QUOTE/SOURCE QUOTE PROOF
comments are all preserved verbatim.

## Changes applied

### `lem:qcoh_section_equalizer` (statement)
- Removed the redundant "Equivalently `\operatorname{Function.Exact} \rho\, \delta` holds…"
  sentence — the exactness was already fully expressed by the preceding exact-sequence diagram and
  prose.

### `lem:localized_module_map_exact_mathlib` (statement)
- Replaced `\operatorname{Function.Exact} a\, b` with "forming an exact sequence at \(M_1\) (the
  image of \(a\) equals the kernel of \(b\))".
- Removed the `\operatorname{IsLocalizedModule} S\, \ell_i` predicate parenthetical (math already
  stated as "localisation map … so each \(M_i'\) is the localised module \(S^{-1}M_i\)").
- Replaced the trailing `\operatorname{Function.Exact}(S^{-1}a)\,(S^{-1}b)` clause with "again
  form an exact sequence at \(M_1'\)"; the following "In other words …" sentence provides
  equivalent content.
- `\mathlibok` preserved on the statement block.
- `\lean{IsLocalizedModule.map_exact}` preserved.

### `lem:tile_section_localization` (statement)
- Removed `\operatorname{modulesRestrictBasicOpen} g\, \mathcal{F}` Lean API name; replaced with
  "the restriction \(\mathcal{F}_{(g)}\) of \(\mathcal{F}\) to \(\Spec R_g\)".
- Removed `: \operatorname{IsLocalizedModule}(\operatorname{powers} f)` holds for it" predicate
  clause; folded into "equivalently, there is a canonical \(R\)-linear isomorphism…".

### `lem:tile_section_localization` (proof)
- "Under the **definitional** section comparison" → "Under the **canonical** section comparison"
  (removes Lean definitional-equality jargon).
- "is an `\operatorname{IsLocalizedModule}` for the powers of \(f\)" → "is a localization map at
  the powers of \(f\)".
- "hence tilde" → "hence of the form \(\widetilde{M_g}\)" (removes informal Lean-flavour shorthand).

### `lem:qcoh_section_kernel_comparison` (proof)
- Removed "— the analogue of the project's comparison
  `\operatorname{qcohRestriction\_eq\_comparison}`" — pure API-plumbing aside. The mathematical
  content ("degree-0/1 naturality of restriction-versus-localisation") is retained.

### `lem:qcoh_section_isLocalizedModule` (statement)
- Removed `: one has \operatorname{IsLocalizedModule}(\operatorname{powers} f)\, \rho_f` — the
  mathematical content ("exhibits … as the localization … at the powers of f") was already stated
  in the preceding clause.
- All SOURCE/SOURCE QUOTE/SOURCE QUOTE PROOF comments preserved verbatim.

### `lem:qcoh_section_isLocalizedModule` (proof)
- "is an `\operatorname{IsLocalizedModule}` at the powers of \(f\)" → "is a localization map at
  the powers of \(f\)".
- Final "hence `\operatorname{IsLocalizedModule}(\operatorname{powers} f)\, \rho_f`" → "hence
  \(\rho_f\) is a localization map at the powers of \(f\)".
- Non-circularity paragraph: removed implementation-note parenthetical "(it preserves the cokernel
  presentation)" from the left-adjoint remark; replaced with "(since \(\widetilde{(-)}\) preserves
  colimits)".
- "read through the **definitional** section equality" → "via the **canonical** section equality".

### `rem:o1i8_decomposition`
- Removed `(see \texttt{analogies/o1i8-route.md})` — internal project file reference, not
  appropriate for a standalone mathematical document.

## Preserved (per directive)

- `\lean{}` and `\uses{}` targets: unchanged throughout.
- `\mathlibok` on `lem:localized_module_map_exact_mathlib`: present and untouched.
- No `\leanok` present on any of the new blocks (correct — none added or removed).
- SOURCE / SOURCE QUOTE / SOURCE QUOTE PROOF comment blocks (Stacks 01HV(4), 01I8): verbatim.
- DONE B0–B4 blocks and all other chapters: not touched.

## Verification

Post-edit grep for `Function\.Exact`, `IsLocalizedModule` (in prose), `modulesRestrictBasicOpen`
(in prose), `qcohRestriction`, `definitional`, `analogies/` in the target line range (4293–4670)
returns only:
- `\lean{IsLocalizedModule.map_exact}` — the `\lean{}` pin (kept).
- `\uses{…modulesRestrictBasicOpen…}` — `\uses{}` DAG entries (kept).
- `\ref{lem:presentation_modulesRestrictBasicOpen}` — lemma cross-reference (kept).
- `% …IsLocalizedModule…` — comment lines in the NOTE block (kept).
- `\operatorname{IsLocalizedModule…}` in `lem:qcoh_isIso_fromTildeGamma` proof — outside scope
  (not touched).

No further action required for this task.
