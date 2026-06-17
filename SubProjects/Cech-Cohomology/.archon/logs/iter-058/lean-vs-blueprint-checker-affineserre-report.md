# Lean ↔ Blueprint Check Report

## Slug
affineserre

## Iteration
058

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated chapter, §§ 3285–3735 and §§ 8795–9251)

---

## Per-declaration (focused on the two new decls the directive names)

### `\lean{AlgebraicGeometry.affine_serre_vanishing_general_open}` (chapter: `lem:affine_serre_vanishing_general_open`)

- **Lean target exists**: yes — `theorem affine_serre_vanishing_general_open` at line 881.
- **Signature matches**: yes.
  - Blueprint: `R` ring, `F` quasi-coherent `O_{Spec R}`-module, `V` any affine open, `[EnoughInjectives (Spec R).Modules]`, conclusion `Ext^p(j_! O_V, F) = 0` for `p > 0`.
  - Lean: `{R : CommRingCat.{u}} [EnoughInjectives (Spec R).Modules] (F : (Spec R).Modules) [F.IsQuasicoherent] (V : (Spec R).Opens) (hV : IsAffineOpen V) (p : ℕ) (hp : 0 < p) (e : CategoryTheory.Abelian.Ext (jShriekOU V) F p) : e = 0` — exact match.
- **Proof follows sketch**: yes.
  - Blueprint says: apply `affine_serre_vanishing_general_of_tildeVanishing`, discharge `htilde` with `affine_tildeVanishing_general`.
  - Lean body: `affine_serre_vanishing_general_of_tildeVanishing F (affine_tildeVanishing_general F) V hV p hp e` — one-line term proof matching the sketch exactly.
- **`\leanok` on statement and proof blocks**: yes (blueprint lines 9195 and 9219).
- **notes**: clean; no placeholder, no sorry. The blueprint pin is precise.

---

### `affine_tildeVanishing_general` (private helper, no blueprint `\lean{...}` pin)

- **Lean target exists**: yes — `private theorem affine_tildeVanishing_general` at line 862.
- **Signature matches**: N/A — no `\lean{...}` pin exists in the blueprint for this declaration.
  - The blueprint's `lem:affine_cech_vanishing_general_seed` (lines 9028–9110) pins `sectionCech_homology_exact_of_affineOpen` and `basicOpen_algMap_section` from `CechAcyclic.lean`, not `affine_tildeVanishing_general`.
- **Proof follows sketch**: partial (see notes).
- **notes**: `affine_tildeVanishing_general` is the exact private-wrapper analogue of `affine_tildeVanishing` for the general-affine case. It calls `sectionCech_homology_exact_of_affineOpen` (sorry-free in `CechAcyclic.lean`) with the index `ULift (Fin n)` instantiation. Its non-general counterpart `affine_tildeVanishing` IS explicitly pinned in the blueprint at `lem:affine_cech_vanishing_qcoh` (line 6058). This creates a minor blueprint inconsistency: parallel helpers are treated differently. Both are `private`, so neither is part of the public API, but the discrepancy makes the blueprint harder to audit mechanically.

---

### All other `\lean{...}`-pinned declarations in this file

The file contains 24 non-`sorry`, non-`axiom` declarations. All but one are pinned:

| Lean declaration | Blueprint label | `\lean{}` match | Sorry-free |
|---|---|---|---|
| `affine_faces_mem` | `lem:affine_faces_mem` (l. 3298) | ✓ | ✓ |
| `coverOpen_affineOpenCoverOfSpan` | `lem:cover_datum_bridge` (l. 3627) | ✓ | ✓ |
| `affine_injective_acyclic` | `lem:affine_injective_acyclic` (l. 3660) | ✓ | ✓ |
| `toSheaf_preservesFiniteColimits` | `lem:toSheaf_preservesFiniteColimits` (l. 3498) | ✓ | ✓ |
| `toSheaf_preservesEpimorphisms` | `lem:to_sheaf_preserves_epi` (l. 3556) | ✓ | ✓ |
| `standard_cover_cofinal` | `lem:standard_cover_cofinal` (l. 3331) | ✓ | ✓ |
| `affine_surj_of_vanishing` | `lem:affine_surj_of_vanishing` (l. 3406) | ✓ | ✓ |
| `affineCoverSystem` | `def:affine_cover_system` (l. 3705) | ✓ | ✓ |
| `affine_cover_span_localizationAway` | `lem:affine_cover_span_localizationAway` (l. 6148) | ✓ | ✓ |
| `cechCohomology_isZero_of_iso` | `lem:cechCohomology_isZero_of_iso` (l. 6116) | ✓ | ✓ |
| `affine_cech_vanishing_qcoh_of_tildeVanishing` | `lem:affine_cech_vanishing_qcoh` (l. 6057) | ✓ | ✓ |
| `affine_serre_vanishing_of_tildeVanishing` | `lem:affine_serre_vanishing` (l. 3221) | ✓ | ✓ |
| `affine_tildeVanishing` (private) | `lem:affine_cech_vanishing_qcoh` (l. 6058) | ✓ | ✓ |
| `affine_cech_vanishing_qcoh` | `lem:affine_cech_vanishing_qcoh` (l. 6056) | ✓ | ✓ |
| `affine_serre_vanishing` | `lem:affine_serre_vanishing` (l. 3220) | ✓ | ✓ |
| `isAffineOpen_specBasicOpen` | `lem:isAffineOpen_specBasicOpen` (l. 8810) | ✓ | ✓ |
| `standard_cover_cofinal_affine` | `lem:standard_cover_cofinal_affine` (l. 8832) | ✓ | ✓ |
| `affine_surj_of_vanishing_affine` | `lem:affine_surj_of_vanishing_affine` (l. 8888) | ✓ | ✓ |
| `affineCoverSystemGeneral` | `def:affine_cover_system_general` (l. 8919) | ✓ | ✓ |
| `affine_cech_vanishing_qcoh_general_of_tildeVanishing` | `lem:affine_cech_vanishing_general_of_tildeVanishing` (l. 9117) | ✓ | ✓ |
| `affine_serre_vanishing_general_of_seed` | `lem:affine_serre_vanishing_general_of_seed` (l. 9144) | ✓ | ✓ |
| `affine_serre_vanishing_general_of_tildeVanishing` | `lem:affine_serre_vanishing_general_of_tildeVanishing` (l. 9171) | ✓ | ✓ |
| **`affine_tildeVanishing_general`** (private) | **not pinned** | — | ✓ |
| `affine_serre_vanishing_general_open` | `lem:affine_serre_vanishing_general_open` (l. 9198) | ✓ | ✓ |

---

## Red flags

None. No `sorry`, no `axiom`, no suspect `:= True`/`:= rfl`, no excuse-comments found in the file. All 24 declarations have genuine proof bodies. `grep sorry` on `AffineSerreVanishing.lean` returns zero hits.

The only sorry in the imported chain is `CechAcyclic.affine` (line 110 of `CechAcyclic.lean`), which is the unfilled P3 lemma. **`affine_tildeVanishing_general` does not call `CechAcyclic.affine`** — it routes through `sectionCech_homology_exact_of_affineOpen` → `sectionCech_homology_exact_of_affineCover` → `sectionCechAbExact_affine` → `dDiff_exact_of_affineCover`, all of which are sorry-free. The new declarations in this file are axiom-clean.

---

## Unreferenced declarations (informational)

- `affine_tildeVanishing_general` (line 862): `private`; its non-general parallel `affine_tildeVanishing` IS blueprint-pinned (line 6058). The inconsistency is minor (both are private helpers with the same structure), but a blueprint-writing agent should add it to the `\lean{}` block of `lem:affine_cech_vanishing_general_seed` for parity with the distinguished case.

---

## Blueprint adequacy for this file

- **Coverage**: 23/24 Lean declarations have a corresponding `\lean{...}` block. 1 unreferenced declaration (`affine_tildeVanishing_general`, private helper — acceptable but inconsistent with the non-general parallel).
- **Proof-sketch depth**: adequate. The blueprint's §8795+ subsection provides detailed proof sketches for each of the new general-affine declarations. The proof of `lem:affine_serre_vanishing_general_open` (lines 9220–9249) walks through all three cover-system fields and explicitly names each contributing lemma; the Lean proof faithfully follows this structure.
- **Hint precision**: precise. Every `\lean{...}` pin in the general-affine subsection names the correct fully-qualified Lean identifier, modulo the missing `affine_tildeVanishing_general` pin noted above.
- **Generality**: matches need. The blueprint correctly identifies `affineCoverSystemGeneral` as the key generalisation from `{D(f)}` to all affine opens, and the Lean file implements exactly this. No parallel API was required.

**One secondary observation (not a correctness error):** `lem:affine_cech_vanishing_general_seed` (blueprint lines 9028–9110) has no `\leanok` marker on either the statement or the proof block, even though the pinned declarations (`sectionCech_homology_exact_of_affineOpen`, `basicOpen_algMap_section`) are both sorry-free in `CechAcyclic.lean`. This is a `sync_leanok` omission, not a prover failure; `sync_leanok` should pick it up next cycle. Also, `basicOpen_algMap_section` is declared `private` in `CechAcyclic.lean`, so pinning it as `AlgebraicGeometry.basicOpen_algMap_section` follows the same convention used for `AlgebraicGeometry.affine_tildeVanishing` — a project-wide pattern that `sync_leanok` apparently handles.

**Recommended chapter-side actions:**
1. *(minor)* Add `AlgebraicGeometry.affine_tildeVanishing_general` to the `\lean{...}` block of `lem:affine_cech_vanishing_general_seed` (or a new proof-block NOTE), for parity with the non-general `affine_tildeVanishing` pin. This is purely editorial.
2. *(informational)* `sync_leanok` should add `\leanok` to the statement and proof blocks of `lem:affine_cech_vanishing_general_seed` once it processes `sectionCech_homology_exact_of_affineOpen`.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**: `affine_tildeVanishing_general` is not pinned in any blueprint `\lean{...}` block, while its structural parallel `affine_tildeVanishing` is (blueprint line 6058). A blueprint-writing agent should add the pin to `lem:affine_cech_vanishing_general_seed` for editorial parity.

**Overall verdict**: `AffineSerreVanishing.lean` faithfully implements its blueprint — every declaration is sorry-free, all public declarations match their blueprint signatures precisely, and the two new decls (`affine_tildeVanishing_general` and `affine_serre_vanishing_general_open`) follow the blueprint sketches exactly; the sole finding is a minor blueprint pin inconsistency for the private helper `affine_tildeVanishing_general`.
