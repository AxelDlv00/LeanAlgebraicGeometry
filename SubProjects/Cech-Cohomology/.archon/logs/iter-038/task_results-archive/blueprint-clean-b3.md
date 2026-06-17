# Blueprint-clean report — iter-038, slug b3

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Region:** Route B section (lines ~3964–4310)

## Changes made

### 1. `lem:overEquivalence_isContinuous` statement — project-narrative trimmed

**Location:** statement block, last sentence of the lemma body.

**Before:**
> "(Mathlib supplies the equivalence but leaves its continuity as a TODO; these four declarations close it, and they are exactly what the site-equivalence transport of step B3 requires.)"

**After:**
> "Their continuity is the site-theoretic input required by the site-equivalence transport of step B3."

**Reason:** The parenthetical "Mathlib supplies the equivalence but leaves its continuity as a TODO; these four declarations close it" is project-development narrative, not mathematical content. The mathematical purpose (continuity needed by B3) is preserved in clean form.

### 2. `lem:restrict_over_compat` proof, Step B3a — Lean syntax removed from prose

**Location:** Last sentence of the B3a paragraph.

**Before:**
> "…unlike step B2, where both ring sheaves were \(\operatorname{over}\) of the same base and related by the identity \(R.\operatorname{map\,id}\), here the two ring sheaves live on different sites and the comparison is a non-trivial open-immersion isomorphism, not a \(\operatorname{map\,id}\)-triviality."

**After:**
> "…unlike step B2, where both ring sheaves were \(\operatorname{over}\) of the same base and related by the identity ring homomorphism, here the two ring sheaves live on different sites and the comparison is a non-trivial open-immersion isomorphism."

**Reason:** `R.\operatorname{map\,id}` is Lean dot-notation; `\operatorname{map\,id}\)-triviality` is a Lean-ism. Both replaced with standard mathematical language.

## No-change items (verified clean)

- `lem:overEquivalence_mathlib` (`\mathlibok` anchor): clean, no issues.
- `lem:overEquivalence_isContinuous` proof block: mathematically clean, `\uses{lem:overEquivalence_mathlib}` resolves.
- `lem:qcoh_finite_presentation_cover` `\lean{}` pin: bundling `coversTop_iSup_eq_top` is correct, no prose leakage.
- `lem:presentation_over_basicOpen` `\uses{}` (tightened by writer): `lem:presentation_map_mathlib` in statement, `{lem:presentation_map_mathlib, lem:pushforwardPushforwardEquivalence_mathlib, lem:presentation_ofIsIso_mathlib}` in proof — all resolve.
- B3 named-construction references kept as directed: `appIso`, `restrictFunctor`, `pushforwardPushforwardEquivalence`, `basicOpenIsoSpecAway`, `restrict_obj`, `modulesRestrictBasicOpen`, `ringCatSheaf`, `specBasicOpen`, `overEquivalence` — all acceptable dependency anchors.
- B3a/B3b/B3c structure, `\uses{}` chains, `\ref{}` calls: all verified correct.

## Label resolution check (edited region)

All `\uses{}`/`\ref{}` labels referenced in the edited blocks:

| Label | Defined at line |
|-------|----------------|
| `lem:overEquivalence_mathlib` | 3965 |
| `lem:pushforwardPushforwardEquivalence_mathlib` | 3952 |
| `lem:modules_restrict_basicOpen` | 4514 |
| `lem:restrict_obj_mathlib` | 4010 |
| `lem:overEquivalence_isContinuous` | 3975 |
| `lem:presentation_map_mathlib` | 3929 |
| `lem:presentation_ofIsIso_mathlib` | 3942 |
| `lem:exists_finite_basicOpen_subcover` | 4471 |
| `lem:quasicoherentData_mathlib` | 3998 |
| `lem:presentation_modulesRestrictBasicOpen` | 4212 |
| `lem:tilde_restrict_basicOpen` | 4601 |

All resolve. No orphan references introduced.

## Markers

`\leanok` and `\mathlibok` markers were not touched.
