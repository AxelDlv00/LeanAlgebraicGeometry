# Blueprint-clean report — FBC chapter (iter-017)

**Chapter:** `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
**Slug:** fbc-iter017

---

## Summary

Purity/hygiene pass completed. Three Lean-leakage items in the new Seam-2/Seam-3 prose were
corrected; all other content is untouched.

---

## Changes made

### 1. Removed `_{\mathrm{app},\mathrm{app}}` Lean-subscript notation (Seam-2 proof, step ii)

The parenthetical
```
(the section-level statements
\(\mathrm{pushforwardComp}^{\mathrm{hom}}_{\mathrm{app},\mathrm{app}} = \mathrm{id}\) and
\(\mathrm{pushforwardComp}^{\mathrm{inv}}_{\mathrm{app},\mathrm{app}} = \mathrm{id}\))
```
mirrors the Lean `.app.app` accessor chain. Replaced with
`(their section-level values are the identity)`.

### 2. Replaced `\mathrm{eqToHom}` with mathematical language (Seam-2 proof, step ii)

`eqToHom` is a Lean 4 term, not a mathematical name. Replaced both occurrences:
- "to an `\mathrm{eqToHom}`" → "to a canonical transport along the equality of opens"
- "an `\mathrm{eqToHom}` repackaging" → "a repackaging along that equality"
- `(\mathrm{pushforwardCongr}\,w)^{\mathrm{hom}}_{\mathrm{app},\mathrm{app}}` →
  `(\mathrm{pushforwardCongr}\,w)^{\mathrm{hom}}` (dropping the Lean-subscript)

### 3. Replaced `\mathrm{rfl}` tactic name (Seam-3 proof)

`\mathrm{rfl}` is a Lean tactic. Replaced:
- "cannot be simplified against it by `\(\mathrm{rfl}\)` or by unfolding" →
  "cannot be simplified against it by reflexivity or by definitional unfolding"

### 4. Replaced `\operatorname{extendRestrictScalarsAdj}` Lean name (Seam-3 proof)

`extendRestrictScalarsAdj` is a Mathlib function name. Replaced:
- "module-level adjunction counit of `\(\operatorname{extendRestrictScalarsAdj}\,\psi\)`" →
  "module-level adjunction counit of the extension/restriction-of-scalars adjunction along `\(\psi\)`"

---

## Verification

### Mathlib anchors (3 new ones from fbc-seams2)

All three carry `\mathlibok` + `\lean{...}` and no spurious `% SOURCE` comment:

| Label | Lean name | Has `\mathlibok` | Has `\lean{}` | No `% SOURCE` |
|---|---|---|---|---|
| `lem:unit_conjugateEquiv_mathlib` | `CategoryTheory.unit_conjugateEquiv` | ✓ | ✓ | ✓ |
| `lem:comp_unit_app_mathlib` | `CategoryTheory.Adjunction.comp_unit_app` | ✓ | ✓ | ✓ |
| `lem:conjugateEquiv_pullbackComp_inv_mathlib` | `AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv` | ✓ | ✓ | ✓ |

### `lem:pullbackPushforward_unit_comp`

Present with `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` and correct `\uses{...}` listing
the three anchors above. Statement and proof are pure mathematics with no Lean leakage. ✓

### SOURCE QUOTE preservation

All `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` blocks verified intact (24 occurrences confirmed
by grep). No source-quote material was altered. ✓

### `\leanok` markers

Not touched. ✓

### Remaining Lean names in prose

After the fixes, grep for Lean tactic names (`rfl`, `simp`, `apply`, `exact`, `eqToHom`,
`extendRestrictScalarsAdj`, `app,app`) in non-comment lines returns empty — no remaining leakage. ✓

---

## No further action required

No missing references, no broken `\uses{}` / `\ref{}`, no LaTeX syntax errors introduced.
The chapter is now blueprint-pure and ready for the prover round.
