# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
043

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (% archon:covers QcohTildeSections.lean at line 12)

---

## Per-declaration (blueprint `\lean{}` blocks relevant to this file)

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections, ..._hom, ..._inv}` (lem:qcoh_iso_tilde_sections)
- **Lean target exists**: yes (lines 65–89: `qcoh_iso_tilde_sections`, `qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv`)
- **Signature matches**: yes — conditional iso `F ≅ tilde (Γ F)` given `[IsIso F.fromTildeΓ]`, plus the two simp lemmas for `.hom`/`.inv`
- **Proof follows sketch**: yes — `(asIso F.fromTildeΓ).symm`, consistent with blueprint "unconditional conditional" packaging
- **notes**: none

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (lem:qcoh_iso_tilde_sections_of_presentation)
- **Lean target exists**: yes (lines 74–77)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` (lem:isIso_fromTildeGamma_of_genSections)
- **Lean target exists**: yes (lines 119–123)
- **Signature matches**: yes — two `GeneratingSections` → `IsIso F.fromTildeΓ`
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` (lem:qcoh_iso_tilde_sections_of_genSections)
- **Lean target exists**: yes (lines 132–136)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.free_isQuasicoherent}` (lem:free_isQuasicoherent)
- **Lean target exists**: yes (lines 105–109, as `instance`)
- **Signature matches**: yes
- **Proof follows sketch**: yes (iso to `tildeFinsupp`, `prop_of_iso`)
- **notes**: none

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}` (lem:exists_finite_basicOpen_subcover)
- **Lean target exists**: yes (lines 152–188)
- **Signature matches**: yes — `{ι}, U, hU` → `∃ n f φ, ∀j D(f j) ≤ U(φ j), span = ⊤`
- **Proof follows sketch**: yes (pointwise basic-open cover, quasicompactness extraction, finset equivFin)
- **notes**: none

### `\lean{AlgebraicGeometry.isLocalizedModule_of_span_cover, ...helpers}` (lem:isLocalizedModule_of_span_cover)
- **Lean target exists**: yes (lines 332–381; private helpers `exists_sum_pow_eq_one`, `mem_range_of_span_pow`, `eq_zero_of_span_pow`, `map_smul_endFun`, `bump_eq`, `per_j_surj`, `per_j_eq` are bundled)
- **Signature matches**: yes
- **Proof follows sketch**: yes (three-clause descent: map_units, surj, eq)
- **notes**: blueprint pin also names the helpers explicitly at line 5099 — all present in Lean

### `\lean{AlgebraicGeometry.tilde_section_isLocalizedModule}` (lem:tilde_section_isLocalizedModule)
- **Lean target exists**: yes (lines 410–432)
- **Signature matches**: yes — `IsLocalizedModule (powers f) (restriction map of modulesSpecToSheaf.obj (tilde M))`
- **Proof follows sketch**: yes (transport via `tilde.toOpen_res` and `tilde.isoTop`)
- **notes**: none

### `\lean{AlgebraicGeometry.section_isLocalizedModule_of_isIso_fromTildeΓ}` (lem:section_isLocalizedModule_of_isIso_fromTildeGamma)
- **Lean target exists**: yes (lines 443–489)
- **Signature matches**: yes — `[IsIso F.fromTildeΓ]` → `IsLocalizedModule (powers f) (section restriction of modulesSpecToSheaf.obj F)`
- **Proof follows sketch**: yes (conjugate tilde local model by β-components of the iso)
- **notes**: none

### `\lean{AlgebraicGeometry.section_isLocalizedModule_of_presentation}` (lem:section_isLocalizedModule_of_presentation)
- **Lean target exists**: yes (lines 500–506)
- **Signature matches**: yes
- **Proof follows sketch**: yes (discharges IsIso via presentation then delegates)
- **notes**: none

### `\lean{AlgebraicGeometry.qcoh_finite_presentation_cover, AlgebraicGeometry.coversTop_iSup_eq_top}` (lem:qcoh_finite_presentation_cover)
- **Lean target exists**: yes (lines 529–557 for `qcoh_finite_presentation_cover`; line 529 also contains `coversTop_iSup_eq_top` as a private lemma used internally)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `lem:qcoh_finite_presentation_cover` has no `\leanok` in blueprint (loop infrastructure will reconcile at next `sync_leanok`); not a checker concern

### `\lean{AlgebraicGeometry.qcoh_section_equalizer, AlgebraicGeometry.res_trans_apply}` (lem:qcoh_section_equalizer)
- **Lean target exists**: yes (lines 577–581 for `res_trans_apply`; lines 593–640 for `qcoh_section_equalizer`)
- **Signature matches**: yes — the blueprint NOTE at line 4296 already records that the Lean decl is strictly more general (arbitrary `U : ι → Opens` rather than basic-opens specifically); this is an upward generalization, not a mismatch
- **Proof follows sketch**: yes
- **notes**: no `\leanok` on this blueprint block either; `sync_leanok` will resolve

### `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}` (lem:isLocalizedModule_powers_restrictScalars_of_algebraMap)
- **Lean target exists**: yes (lines 663–702)
- **Signature matches**: yes
- **Proof follows sketch**: yes (three-clause descent; scalar tower used for unit clause)
- **notes**: none

### `\lean{AlgebraicGeometry.tile_image_opens_identities}` (lem:tile_image_opens_identities)
- **Lean target exists**: yes (lines 761–795)
- **Signature matches**: yes — returns a conjunction of the two image-opens equalities
- **Proof follows sketch**: yes (first part uses `opensRange_of_isIso`; second uses `specAwayToSpec_eq` and set-theoretic membership)
- **notes**: none

### lem:tile_section_comparison — NO `\lean{}` pin (deferred by blueprint comment at line 4412)
- **Lean target exists**: no declaration built yet. A comment block at Lean lines 797–864 documents progress and the one remaining obstruction.
- **Consistency**: expected — the blueprint comment explicitly defers the pin; no `\leanok` present; no wrong stub. This is correctly tracked as in-progress.
- **notes**: see Blueprint → Lean section for accuracy issue with the proof note

### `\lean{AlgebraicGeometry.tile_section_localization}` (lem:tile_section_localization)
- **Lean target exists**: no — there is no `tile_section_localization` declaration in the Lean file, only a comment block (lines 797–864) explaining the remaining gap
- **Signature matches**: N/A (no declaration to compare)
- **Proof follows sketch**: N/A
- **notes**: Aspirational `\lean{}` pin; consistent with in-progress status. No `\leanok` on the blueprint block. Gated on `tile_section_comparison` landing first.

### `\lean{AlgebraicGeometry.qcoh_section_isLocalizedModule}` (lem:qcoh_section_isLocalizedModule)
- **Lean target exists**: no — downstream of `tile_section_localization`; not yet built
- **Signature matches**: N/A
- **notes**: Aspirational pin; consistent with the overall project state

---

## Red flags

### Placeholder / suspect bodies
None. No `:= sorry`, `:= True`, or suspect bodies in the Lean file. The two new `rfl` lemmas (`modulesSpecToSheaf_smul_eq`, `modulesRestrictBasicOpen_smul_eq`) have bodies `:= rfl` for claims that ARE genuinely definitional — these are correct, not suspect.

### Excuse-comments
None. The comment block at Lean lines 797–864 ("PARTIAL this iter") is an honest progress note documenting a reduced obstruction, not an excuse for wrong code. No declarations are papered with wrong bodies.

### Axioms / Classical.choice on substantive claims
None. The file is axiom-clean (all proofs from Mathlib and type theory).

---

## Unreferenced declarations (informational — Lean → Blueprint coverage debt)

These two declarations exist in the Lean file but have **no `\lean{}` pin** in the blueprint:

### `AlgebraicGeometry.modulesSpecToSheaf_smul_eq` (Lean line 730)
```lean
lemma modulesSpecToSheaf_smul_eq (F : (Spec R).Modules) (W : (Spec R).Opens) (r : R)
    (x : (modulesSpecToSheaf.obj F).presheaf.obj (Opposite.op W)) :
    r • x = (((Spec R).ringCatSheaf.val.map (homOfLE (le_top : W ≤ ⊤)).op).hom
              ((StructureSheaf.globalSectionsIso R).hom.hom r)
            • (show F.val.obj (Opposite.op W) from x)) := rfl
```
Axiom-clean `rfl` lemma. Sub-ingredient of `tile_section_comparison` (Sub-lemma B). Not referenced by any blueprint block. **Coverage debt.**

### `AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq` (Lean line 740)
```lean
lemma modulesRestrictBasicOpen_smul_eq (F : (Spec R).Modules) (g : R)
    (c : ...) (m : ...) :
    c • m = (((specBasicOpen g).ι.appIso _).inv.hom
              (((basicOpenIsoSpecAway g).inv.appIso _).inv.hom c))
            • (...) := rfl
```
Axiom-clean `rfl` lemma. Second sub-ingredient of `tile_section_comparison` (Sub-lemma B). Not referenced by any blueprint block. **Coverage debt.**

All other unreferenced items are private helpers (`exists_sum_pow_eq_one`, `mem_range_of_span_pow`, `eq_zero_of_span_pow`, `map_smul_endFun`, `bump_eq`, `per_j_surj`, `per_j_eq`, `coversTop_iSup_eq_top`, `res_trans_apply`) bundled into their parent blocks' `\lean{}` pins, which is correct.

---

## Blueprint adequacy for this file

- **Coverage**: 15/17 Lean declarations have a corresponding `\lean{}` block (the 2 missing are `modulesSpecToSheaf_smul_eq` and `modulesRestrictBasicOpen_smul_eq`). The unbuilt targets (`tile_section_localization`, `qcoh_section_isLocalizedModule`) have aspirational pins but no Lean implementation; this is expected in-progress state. Private helpers are properly bundled. Unreferenced substantive declarations: **2** (the two new rfl lemmas).

- **Proof-sketch depth**: **under-specified for `lem:tile_section_comparison`** in two ways (see below). All other blocks are adequate.

- **Hint precision**: **precise** for all pinned blocks. The deferred pin on `lem:tile_section_comparison` is consistent with Archon practice (comment-marked).

- **Generality**: **matches need** overall. The `qcoh_section_equalizer` generalization is already noted in the blueprint.

### `lem:tile_section_comparison` proof note is now inaccurate (Major)

The blueprint proof note at lines 4432–4454 contains two claims that diverge from the actual Lean reduction found this iteration:

**Claim 1 (line 4432): "~100–150 LOC construction"**
The iter-043 Lean work shows this is wrong. The two `rfl` lemmas (`modulesSpecToSheaf_smul_eq`, `modulesRestrictBasicOpen_smul_eq`) together eliminate the bulk of the bookkeeping: the SCALAR ACTION is definitional via these bridges. After the two `rfl` reductions the sole remaining goal is a single concrete ring identity (~30–50 LOC closer, per the in-file handoff). The "~100–150 LOC" estimate overstates the remaining work by 3–5×.

**Claim 2 (lines 4450–4454): "This bridge is genuinely non-definitional: the two global-ring section modules ... are not definitionally equal — they differ both by the base ring and by the provably-equal but not-definitionally-equal opens."**
This is now partially misleading. While the module *objects* (as additive groups, respecting opens) are still not definitionally equal, the *scalar action* IS captured by two `rfl` lemmas. The remaining non-definitional content is precisely isolated to:

```
  (ringCatSheaf.map (homOfLE ⋯).op).hom (algebraMap R Γ(⊤,𝒪) r)
    = ((basicOpenIsoSpecAway g).inv.appIso ⊤).inv.hom
        (algebraMap R_g Γ(⊤,𝒪_{R_g}) (algebraMap R R_g r))
```

i.e., a pure ring identity in `Γ(D(g), 𝒪)` — "sections over D(g) equal R_g, compatibly with algebraMap." This specific identity is not described in the blueprint.

**Impact**: A prover working from the blueprint alone would expect to build a 100–150 LOC cross-ring transport from scratch, without knowing:
1. Two sub-components are `rfl` (already landed as `modulesSpecToSheaf_smul_eq` / `modulesRestrictBasicOpen_smul_eq`)
2. The true residual is ONE ring identity, closable via `IsLocalization.Away` uniqueness or `ΓSpecIso_naturality` (~30–50 LOC)

### Recommended chapter-side actions
1. Add `\lean{AlgebraicGeometry.modulesSpecToSheaf_smul_eq}` and `\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq}` as a new `\begin{lemma}` block (or bundle both under one "scalar reconciliation bridge" block) in the `lem:tile_section_comparison` area. Both are Sub-lemma B ingredients.
2. Update the `lem:tile_section_comparison` proof note to reflect the actual Lean reduction:
   - Replace "~100–150 LOC construction" with the accurate decomposition: two `rfl` sub-lemmas (already formalized) + one ring identity (~30–50 LOC closer)
   - Add a description of the residual ring identity (LHS = restriction of `algebraMap R → Γ(⊤,𝒪)` to `W`; RHS = `appIso` of `basicOpenIsoSpecAway` applied to the localization map) and the recommended closure strategy (`IsLocalization.Away` uniqueness / `ΓSpecIso_naturality`)
3. Pin `lem:tile_section_comparison` with `\lean{AlgebraicGeometry.tile_scalar_compat}` (plus the two sub-lemmas) once the ring identity closes. The current deferred-pin comment at line 4412 can remain until then.

---

## Severity summary

- **must-fix-this-iter**: NONE.
- **major**:
  - `modulesSpecToSheaf_smul_eq` lacks `\lean{}` pin in blueprint (coverage debt, new axiom-clean lemma)
  - `modulesRestrictBasicOpen_smul_eq` lacks `\lean{}` pin in blueprint (coverage debt, new axiom-clean lemma)
  - `lem:tile_section_comparison` proof note accuracy: "~100–150 LOC" estimate is now 3–5× too high; actual residual (the ring identity `(ringCatSheaf.map ...).hom (algebraMap R ...) = ((basicOpenIsoSpecAway g).inv.appIso ⊤).inv.hom (algebraMap R_g ...)`) is not described in the blueprint
- **minor**:
  - `lem:tile_section_comparison`'s "bridge is NOT rfl" claim is now partially imprecise — the two scalar bridges ARE `rfl`; only the ring identity component is not. Not misleading enough to block progress but should be corrected with the major fix above.

**Overall verdict**: No Lean red flags or wrong code — all axiom-clean, no sorries, no placeholder stubs. The two new `rfl` lemmas are genuine and correct. Two major blueprint-side gaps: missing `\lean{}` pins for the new sub-lemmas and an inaccurate proof-complexity estimate for `lem:tile_section_comparison` that does not reflect the actual Lean reduction (two rfl bridges + one ring identity, ~30–50 LOC remaining, not ~100–150 LOC). — 17 declarations checked, 0 Lean red flags, 3 major blueprint findings.
