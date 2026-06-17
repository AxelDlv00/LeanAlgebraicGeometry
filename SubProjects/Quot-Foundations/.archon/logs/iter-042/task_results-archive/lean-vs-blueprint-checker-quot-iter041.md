# Lean ↔ Blueprint Check Report

## Slug
quot-iter041

## Iteration
041

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration (gap1 producer chain, iter-041 new decls)

### `\lean{...isLocalizedModule_basicOpen_descent}` (chapter: `lem:section_localization_descent`, ~line 4102)
- **Lean target exists**: yes (line 2240)
- **Signature matches**: yes
  - Blueprint: quasi-coherent M on Spec R, f : R ⊢ IsLocalizedModule (powers f) on Γ(M,⊤)→Γ(M,D(f))
  - Lean: `[hqc : M.IsQuasicoherent] (f : R) : IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE le_top).op).hom` ✓
- **Proof follows sketch**: yes — blueprint says "refine quasi-coherence cover to finite basic-open cover, supply Hfr per-element via `section_localization_hfr_basicOpen`, feed to `isLocalizedModule_basicOpen_descent_of_basicOpen_cover`"; Lean proof (lines 2245–2251) follows exactly this route.
- **notes**: `\leanok` present and correct. One stale `% NOTE` inside the block says "the pinned Lean decl isLocalizedModule_basicOpen_descent does NOT yet exist" — contradicted by `\leanok`; minor cleanup needed.

### `\lean{...isIso_fromTildeΓ_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_isIso_fromTildeΓ`, ~line 4212)
- **Lean target exists**: yes (line 2261)
- **Signature matches**: yes
  - Blueprint: M quasi-coherent on Spec R ⊢ IsIso M.fromTildeΓ
  - Lean: `[M.IsQuasicoherent] : IsIso M.fromTildeΓ` ✓
- **Proof follows sketch**: yes — blueprint says "apply section-localization descent (keystone D) to get IsLocalizedModule(powers f) for all f, then feed to `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`"; Lean calls `isIso_fromTildeΓ_of_isLocalizedModule_restrict M (fun f => isLocalizedModule_basicOpen_descent M f)` which is the forward direction of that iff. Mathematically identical.
- **notes**: `\leanok` present and correct. Stale `% NOTE` says "the Lean decl does NOT yet exist" — contradicted by `\leanok`; minor cleanup needed.

### `\lean{...section_localization_hfr_basicOpen}` (chapter: `lem:section_localization_hfr_basicOpen`, ~line 4409)
- **Lean target exists**: yes (line 2198)
- **Signature matches**: yes
  - Blueprint: quasi-coherent M on Spec R, q : QuasicoherentData, D(s) ≤ q.X i, f : R ⊢ IsLocalizedModule (powers f) on Γ(M,D(s))→Γ(M,D(f)⊓D(s))
  - Lean: `(M : (Spec R).Modules) (q : M.QuasicoherentData) (f s : R) (i : q.I) (hs : basicOpen s ≤ q.X i) : IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE inf_le_right).op).hom` ✓
  - Minor simplification: blueprint mentions "D(r) ≤ q.X_i, D(s) ≤ D(r)" as context but the Lean decl drops the intermediate r, stating only "D(s) ≤ q.X i" — this is strictly weaker hypothesis (more general), not a mismatch.
- **Proof follows sketch**: yes (with structural deviation) — blueprint's proof sketch describes the full assembly monolithically (composite immersion j, semilinear transports e₁/e₂, combiner); Lean splits the heavy lifting into `section_localization_hfr_aux` (abstract, ~110 lines) with `section_localization_hfr_basicOpen` as a thin wrapper that instantiates the abstract core. Mathematical content matches.
- **notes**: `\leanok` present and correct. Stale `% NOTE` inside the block says "The Lean decl section_localization_hfr_basicOpen does NOT yet exist" — contradicted by `\leanok`; minor cleanup needed.

---

### `\lean{...compositeBasicOpenImmersion_flocus_image}` (chapter: `lem:composite_immersion_flocus_basicOpen`, ~line 4341) — **PIN MISMATCH**
- **Lean target exists**: **no** — `compositeBasicOpenImmersion_flocus_image` does not appear anywhere in the Lean file.
- **Signature matches**: N/A (no target)
- **Proof follows sketch**: N/A
- **notes**: The blueprint block states TWO claims: (a) σ(f') = algebraMap R R_s f (definitional from f' := σ⁻¹(·)); (b) j''ᵁD(f') = D(f)⊓D(s). Neither claim appears as a standalone named decl. In the Lean implementation:
  - Claim (b) is covered by `compositeBasicOpenImmersion_image_basicOpen` (line 2038) + `image_basicOpen_eq_inf` (line 2051), combined inline inside `section_localization_hfr_basicOpen` (line 2222–2224).
  - Claim (a) is discharged inline as `σ.apply_symm_apply` in `section_localization_hfr_basicOpen` (line 2217).
  - **Re-pin is NOT safe** without a split: no single existing decl covers both claims simultaneously for the specific f' = σ⁻¹(algebraMap R R_s f). A simple re-pin to `compositeBasicOpenImmersion_image_basicOpen` would be wrong (it's more general, takes arbitrary f', and gives j''ᵁD(f') as a basic open of the transported section, not as D(f)⊓D(s) specifically).
  - The block has no `\leanok` (correct, since target doesn't exist), but the stale `\lean{...}` pin will confuse the DAG and blueprint-doctor.

### `\lean{...gamma_image_iso_semilinear_top}` (chapter: `lem:gamma_image_iso_semilinear_top`, ~line 4364) — **PIN MISMATCH**
- **Lean target exists**: **no** — `gamma_image_iso_semilinear_top` does not appear in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The mathematical content (upgrading D(f')-level semilinearity to ⊤-level σ) was absorbed inline into `section_localization_hfr_aux` (lines 2120–2136: `he₁`, `he₂` hypothesis proofs). Block has no `\leanok` (correct). The stale pin creates a phantom dependency in the DAG: `lem:section_localization_hfr_basicOpen` lists `\uses{..., lem:gamma_image_iso_semilinear_top, ...}` which in turn has a `\lean{...}` pin pointing to a non-existent decl.

### `\lean{...flocus_section_scalar_tower}` (chapter: `lem:flocus_section_scalar_tower`, ~line 4389) — **PIN MISMATCH**
- **Lean target exists**: **no** — `flocus_section_scalar_tower` does not appear in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: A-module structure and IsScalarTower instances for f-locus sections were constructed inline inside `section_localization_hfr_aux` (lines 2100–2109: `iAN₂`, `iRN₁`, `iRN₂`, `iST₁`, `iST₂`). Block has no `\leanok` (correct). Same DAG phantom issue as above.

---

### `\lean{...isLocalizedModule_basicOpen}` (chapter: `lem:qcoh_section_localization_basicOpen`, ~line 2478) — future, informational
- **Lean target exists**: no
- **notes**: Blueprint `% NOTE` explicitly flags this as future (gap2 — general scheme X, arbitrary QC sheaf). No `\leanok`. No expectation that this iter builds it. Informational only.

### `\lean{...isLocalizedModule_basicOpen_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_section_localization`, ~line 2718) — G1-core, now buildable
- **Lean target exists**: no
- **notes**: Blueprint `% NOTE` says "G1-core is now a DOWNSTREAM COROLLARY of gap1". Since gap1 (`isIso_fromTildeΓ_of_isQuasicoherent`) is now closed, G1-core is a 2-line corollary via `isIso_fromTildeΓ_of_isQuasicoherent` + `isLocalizedModule_restrict_of_isIso_fromTildeΓ`. No `\leanok` (correct — not yet built). Should be promoted to a near-term objective.

---

## Red flags

### Placeholder / suspect bodies
None in the iter-041 new declarations (lines 2027–2264). The only `:= sorry` bodies in the file appear in the iter-176 file-skeleton declarations at lines 126, 165, 201, 228 (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) — all explicitly documented as "iter-176 file-skeleton, body is a typed sorry" and NOT claimed as substantive by any `\leanok` blueprint block.

### Excuse-comments
None in new declarations.

### Axioms / Classical.choice on non-trivial claims
None found in the new gap1 declarations.

---

## Unreferenced declarations (informational)

The following 4 new declarations have no `\lean{...}` reference in the blueprint chapter:

| Declaration | Line | Assessment |
|---|---|---|
| `image_basicOpen_of_affine` | 2027 | Pure geometry helper for an open immersion of affines; used by `compositeBasicOpenImmersion_image_basicOpen`. No blueprint obligation needed (lean_aux). |
| `compositeBasicOpenImmersion_image_basicOpen` | 2038 | Instantiation of `image_basicOpen_of_affine` at the concrete composite immersion; used inside `section_localization_hfr_basicOpen`. Partially covers `lem:composite_immersion_flocus_basicOpen` (b-image only, see above). |
| `image_basicOpen_eq_inf` | 2051 | Helper: j''ᵁD(f') = (j''ᵁ⊤) ⊓ D(g) under a transport hypothesis. Used inside `section_localization_hfr_basicOpen`. Covers the other half of `lem:composite_immersion_flocus_basicOpen`. |
| `section_localization_hfr_aux` | 2075 | Abstract proof engine for the geometric Hfr producer (~110 lines, maxHeartbeats 1600000). Absorbs the content of blueprint sub-lemmas (b-flocus/c/d). No blueprint block; the subsection narrative describes it but doesn't pin it. |

None of these are "substantive" in the sense of being independent theorems the blueprint claims are proven separately — they are all implementation helpers for `section_localization_hfr_basicOpen`.

---

## Blueprint adequacy for this file

- **Coverage (gap1 chain)**: 3/7 new declarations have corresponding `\lean{...}` blocks (`section_localization_hfr_basicOpen`, `isLocalizedModule_basicOpen_descent`, `isIso_fromTildeΓ_of_isQuasicoherent`). The 4 unreferenced ones are helpers (acceptable). Coverage of the broader file is not re-audited here.

- **Proof-sketch depth**: **adequate** for the three substantive declarations. The proof sketches in `lem:section_localization_descent` and `lem:section_localization_hfr_basicOpen` are detailed enough to have guided the formalization. The `section_localization_hfr_aux` auxiliary proof (~110 lines, heavy machinery) is not previewed in the blueprint but its structure is entirely captured by the existing `lem:section_localization_hfr_basicOpen` proof sketch.

- **Hint precision**: **loose** for three sub-lemma blocks. The blueprint planned `lem:composite_immersion_flocus_basicOpen`, `lem:gamma_image_iso_semilinear_top`, and `lem:flocus_section_scalar_tower` as separate lemmas pinned to `compositeBasicOpenImmersion_flocus_image`, `gamma_image_iso_semilinear_top`, and `flocus_section_scalar_tower` respectively; none of these were built as standalone declarations. The `\lean{...}` pins are therefore incorrect — they point to non-existent targets, creating phantom blueprint obligations.

- **Generality**: **matches need**. The producer is stated at the right level of generality for the keystone descent.

- **Recommended chapter-side actions**:
  1. **`lem:composite_immersion_flocus_basicOpen`**: Update or SPLIT. Option A: remove the `\lean{...}` pin and annotate with `% NOTE: content absorbed into section_localization_hfr_aux; σ-identity is σ.apply_symm_apply (inline), image computed via compositeBasicOpenImmersion_image_basicOpen + image_basicOpen_eq_inf (section_localization_hfr_basicOpen:2222-2224)`. Option B: split into two blocks with correct pins to `compositeBasicOpenImmersion_image_basicOpen` (image claim only) and a new decl (or further inline note).
  2. **`lem:gamma_image_iso_semilinear_top`** and **`lem:flocus_section_scalar_tower`**: Update `\lean{...}` pins to either (a) remove them and annotate content-absorbed-inline, or (b) create named Lean lemmas for them (not required since they're trivial instances).
  3. **Stale `% NOTE` comments** in `lem:section_localization_descent`, `lem:qcoh_affine_isIso_fromTildeΓ`, and `lem:section_localization_hfr_basicOpen`: All three contain "does NOT yet exist" notes now contradicted by `\leanok`. Review agent should clean these up.
  4. **G1-core**: `lem:qcoh_affine_section_localization` / `isLocalizedModule_basicOpen_of_isQuasicoherent` is now a 2-line corollary of gap1. Plan agent should schedule it as a near-term objective.

---

## Severity summary

| Finding | Severity |
|---|---|
| `lem:composite_immersion_flocus_basicOpen` pins non-existent `compositeBasicOpenImmersion_flocus_image`; re-pin requires SPLIT | **major** |
| `lem:gamma_image_iso_semilinear_top` pins non-existent `gamma_image_iso_semilinear_top`; content absorbed into `section_localization_hfr_aux` | **major** |
| `lem:flocus_section_scalar_tower` pins non-existent `flocus_section_scalar_tower`; content absorbed into `section_localization_hfr_aux` | **major** |
| G1-core (`isLocalizedModule_basicOpen_of_isQuasicoherent`) not yet built; now trivially derivable from gap1 | **major** |
| Stale `% NOTE: does NOT yet exist` in `lem:section_localization_descent`, `lem:qcoh_affine_isIso_fromTildeΓ`, `lem:section_localization_hfr_basicOpen` | **minor** |
| 4 new helper decls (`image_basicOpen_of_affine`, `compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`, `section_localization_hfr_aux`) have no blueprint block | **minor** (informational — all are implementation helpers) |

**No must-fix-this-iter findings.** All three primary gap1 declarations (`isLocalizedModule_basicOpen_descent`, `isIso_fromTildeΓ_of_isQuasicoherent`, `section_localization_hfr_basicOpen`) have correct signatures, axiom-clean proofs, and matching `\leanok` blueprint blocks. The major findings are blueprint-side pin mismatches for three sub-lemma blocks whose mathematical content was absorbed into `section_localization_hfr_aux`; these affect the blueprint DAG but do not indicate wrong Lean code.

**Overall verdict**: gap1 chain (`isLocalizedModule_basicOpen_descent` + `isIso_fromTildeΓ_of_isQuasicoherent` + `section_localization_hfr_basicOpen`) is correctly formalized and faithfully matches the blueprint statements; blueprint has 3 stale `\lean{...}` pins for sub-lemmas absorbed into `section_localization_hfr_aux`, and G1-core is now buildable as a gap1 corollary.
