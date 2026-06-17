# Blueprint-clean report — iter-056

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Changes made

### 1. Lean name leakage removed (line 8082–8083)

**Block:** proof detail (2a) of `lem:open_immersion_pushforward_comp`

The parenthetical `(\(\operatorname{isAffineHom\_of\_affine\_separated}\))` was a raw Lean
declaration name embedded in proof prose. The Lean name is already captured in the statement
block's `\lean{...}` marker; the in-proof reference was redundant and leaked implementation
detail into the mathematical text.

- **Before:** `The immersion \(j\) is an affine morphism (\(\operatorname{isAffineHom\_of\_affine\_separated}\)): for \(U\) affine...`
- **After:** `The immersion \(j\) is an affine morphism: for \(U\) affine...`

### 2. Dead-end remark reworded (lines 8114–8125)

**Block:** inline remark after proof detail (2c) of `lem:open_immersion_pushforward_comp`

Two pieces of project-history language were replaced with mathematically neutral phrasing:

- `Remark (a rejected route)` → `Remark (a blocked approach)` — "rejected route" is
  project-history language; "blocked approach" is a timeless mathematical statement.
- `V = j^{-1}(V)` (confusing self-referential notation) → `j^{-1}(V)` (direct).
- The concluding sentence `The Form~B development of absolute cohomology was adopted precisely
  to avoid that infrastructure, so the sound route keeps the \operatorname{isoSpec} transport
  on the whole affine U (2b) and handles the general affine open ambiently (2c).`
  was replaced with `--- infrastructure not available in the present formalism. The sound route
  therefore keeps the spectrum isomorphism at the level of the whole affine U as in~(2b) and
  handles the general affine open ambiently via~(2c).` — removing "Form~B" (project-internal
  jargon) while preserving the mathematical substance.

The full mathematical content of the dead-end observation is retained: the open-subscheme
`j⁻¹V ≅ Spec Γ(j⁻¹V)` transport forces a restriction functor whose derived comparison is
exactly "restriction preserves injectives", infrastructure the present formalism is designed
to avoid.

## Verification checks

| Check | Result |
|---|---|
| `% SOURCE` block for `lem:open_immersion_pushforward_comp` | ✓ intact (lines 7966–7974) |
| `% SOURCE QUOTE PROOF` block for `lem:open_immersion_pushforward_comp` | ✓ intact (lines 7991–8001) |
| `% SOURCE` + `% SOURCE QUOTE PROOF` for `lem:affine_serre_vanishing` | ✓ intact (lines 3217–3254) |
| `lem:isoSpec_scheme_mathlib` carries `\mathlibok` | ✓ |
| `lem:ext_mapExactFunctor_mathlib` carries `\mathlibok` | ✓ |
| `lem:modules_pushforward_mathlib` carries `\mathlibok` | ✓ |
| `lem:affine_serre_vanishing_general_open` carries NO marker | ✓ (TODO placeholder only) |
| `lem:modules_isoSpec_ext_transport` carries NO marker | ✓ (TODO placeholder only) |
| Remaining `\operatorname{Scheme.isoSpec}` / `\operatorname{Ext.mapExactFunctor}` in proof body | ✓ retained — these follow the project's established convention for Mathlib-anchor parentheticals, each has a corresponding `\mathlibok` block in the chapter |
| `\lean{}`, `\uses{}`, `\mathlibok`, `% NOTE:` markers | ✓ untouched |
| Sub-brick A stub blocks | ✓ untouched (scope is out-of-chapter) |

## No further issues found

No other Lean tactic strings, `:=` leakage, or iter-narrative were detected in the new/edited
blocks after grepping the chapter for known patterns.
