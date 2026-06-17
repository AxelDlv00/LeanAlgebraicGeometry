# Blueprint Review: quot-recheck
**Iter:** 043
**Scope:** Fast-path re-review of `Picard_QuotScheme.tex` (gap2 + Piece-A gate)

## Top-level summaries

No must-fix findings. All 4 iter-043 defects are confirmed fixed. HARD GATE CLEARS.

## Per-chapter

### `Picard_QuotScheme.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Gap2 + Piece-A lanes fully road-worthy. See defect confirmations below.

## Defect confirmations (directive's 4-item checklist)

**Defect 1 — FIXED.** `lem:qcoh_section_localization_basicOpen` proof (lines 2513–2567) now:
- Routes Part (2) through `\cref{lem:section_localization_hfr_aux_general}` (line 2525–2526).
- Names `\cref{lem:fromSpec_image_top_section_coherence}` as the section-coherence crux (line 2563–2564).
- No occurrence of "sole genuinely new piece" anywhere in the proof block. ✅

**Defect 2 — FIXED.** All 4 helper blocks present with `\label{}` + `\lean{}`:
| Blueprint label | `\lean{}` pin | Lean decl (line) | `\uses{}` |
|---|---|---|---|
| `lem:modules_restrict_linear` | `AlgebraicGeometry.Scheme.Modules.restrictₗ` | line 2251 (`noncomputable def`) | omitted — no deps (correct) |
| `lem:modules_restrict_basicOpen_linear` | `AlgebraicGeometry.Scheme.Modules.restrictBasicOpenₗ` | line 2267 | `{lem:modules_restrict_linear}` ✅ |
| `lem:fromSpec_image_top_section_coherence` | `AlgebraicGeometry.Scheme.Modules.fromSpec_image_top_section_coherence` | line 2288 | `{def:gamma_image_ring_equiv}` ✅ |
| `lem:section_localization_hfr_aux_general` | `AlgebraicGeometry.Scheme.Modules.section_localization_hfr_aux_general` | line 2321 | 5-item list ✅ |

All 4 `\lean{}` pins match real existing Lean declarations in the correct namespace
(`AlgebraicGeometry.Scheme.Modules`, within the `namespace Scheme.Modules` block at line 1159). ✅

**Defect 3 — FIXED.** `lem:qcoh_pullback_fromSpec` block (lines 2672–2711):
- `\lean{AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec}` — this is a prover target not yet formalized; the `\lean{}` pin is the correct intended declaration name. ✅
- `\uses{lem:isQuasicoherent_quasicoherentData_mathlib, def:over_restrict_presentation, def:presentation_pullback_iota_of_quasicoherentData, lem:presentation_map_mathlib, lem:modules_pullback_mathlib}` — all 5 labels verified present in chapter. ✅

**Defect 4 — FIXED.** `lem:qcoh_section_localization_basicOpen` statement `\uses{}` (lines 2479–2484) now lists:
`lem:qcoh_pullback_fromSpec` (Piece A) + `lem:modules_restrict_linear` + `lem:modules_restrict_basicOpen_linear` + `lem:fromSpec_image_top_section_coherence` + `lem:section_localization_hfr_aux_general` — all 5 new labels confirmed. ✅

## Label-resolution spot-check

All `\uses{}` labels in the 4 new helper blocks and in the revised gap2 `\uses{}` are defined within the chapter:
- `def:gamma_image_ring_equiv` → line 4190 ✅
- `lem:gamma_pullback_image_iso` → line 4049 ✅
- `lem:gamma_pullback_image_iso_hom_semilinear` → line 4216 ✅
- `lem:gamma_pullback_image_iso_hom_naturality` → line 4077 ✅
- `lem:isLocalizedModule_ringEquiv_semilinear` → line 4112 ✅
- `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` → line 2742 ✅
- `lem:qcoh_affine_isIso_fromTildeΓ` → line 4364 ✅
- `lem:qcoh_affine_section_localization` → line 2883 ✅
- `lem:isQuasicoherent_quasicoherentData_mathlib` → line 2935 ✅
- `lem:modules_pullback_mathlib` → line 2954 ✅
- `lem:presentation_map_mathlib` → line 2989 ✅
- `def:over_restrict_presentation` → line 3467 ✅
- `def:presentation_pullback_iota_of_quasicoherentData` → line 3498 ✅

No broken `\uses{}` edges detected for any of the 4 new helper blocks or the revised gap2 block.

## Severity summary

- **must-fix**: none
- **gate verdict**: CLEARS — both gap2 (`isLocalizedModule_basicOpen`) and Piece-A (`isQuasicoherent_pullback_fromSpec`) prover lanes may dispatch this iter.
