# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
042

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections, …_hom, …_inv}` (chapter: `lem:qcoh_iso_tilde_sections`)
- **Lean target exists**: yes — all three (`qcoh_iso_tilde_sections`, `qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv`)
- **Signature matches**: yes. Lean: `F ≅ tilde (moduleSpecΓFunctor.obj F)` under `[IsIso F.fromTildeΓ]`. Blueprint: `F ≅ M^~` for `M = Γ(X, F)` when the tilde–Γ counit is an iso. ✓
- **Proof follows sketch**: yes. Body is `(asIso F.fromTildeΓ).symm`, consistent with "packaged inverse of the counit." The `_hom`/`_inv` simp lemmas have body `:= rfl`, which is correct (these are definitionally true by construction of `asIso`). ✓
- **`\leanok` in blueprint**: yes (line 3781)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (`lem:qcoh_iso_tilde_sections_of_presentation`)
- **Lean target exists**: yes
- **Signature matches**: yes. Takes `F.Presentation`, discharges `IsIso F.fromTildeΓ` via `isIso_fromTildeΓ_of_presentation`, returns `F ≅ tilde (moduleSpecΓFunctor.obj F)`. ✓
- **Proof follows sketch**: yes. One-liner: set `haveI` from the presentation lemma, call `qcoh_iso_tilde_sections`. ✓
- **`\leanok` in blueprint**: yes (line 3805)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.free_isQuasicoherent}` (`lem:free_isQuasicoherent`)
- **Lean target exists**: yes — `instance free_isQuasicoherent (ι : Type u) : (SheafOfModules.free …).IsQuasicoherent`
- **Signature matches**: yes. Blueprint: "free O_X-module on ι generators is quasi-coherent." Lean: `SheafOfModules.free.{u} (R := (Spec R).ringCatSheaf) ι` is quasi-coherent. ✓
- **Proof follows sketch**: yes. Uses `prop_of_iso` with `tildeFinsupp`. ✓
- **`\leanok` in blueprint**: yes (line 4814)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` (`lem:isIso_fromTildeGamma_of_genSections`)
- **Lean target exists**: yes
- **Signature matches**: yes. Given `σ : F.GeneratingSections` and `τ : (kernel σ.π).GeneratingSections`, concludes `IsIso F.fromTildeΓ`. Exactly matches blueprint. ✓
- **Proof follows sketch**: yes. Assembles `F.Presentation` from the two families, then calls `isIso_fromTildeΓ_of_presentation`. ✓
- **`\leanok` in blueprint**: yes (line 5416/5432)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` (`lem:qcoh_iso_tilde_sections_of_genSections`)
- **Lean target exists**: yes — `noncomputable def`
- **Signature matches**: yes. Takes `σ`, `τ`; produces `F ≅ tilde (moduleSpecΓFunctor.obj F)`. ✓
- **Proof follows sketch**: yes. Chains `isIso_fromTildeΓ_of_genSections` into `qcoh_iso_tilde_sections`. ✓
- **`\leanok` in blueprint**: yes (line 5442/5454)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}` (`lem:exists_finite_basicOpen_subcover`)
- **Lean target exists**: yes
- **Signature matches**: yes. Given `U : ι → Opens` with `⨆ i, U i = ⊤`, produces `n, f : Fin n → R, φ : Fin n → ι` with `basicOpen (f j) ≤ U (φ j)` and `Ideal.span (Set.range f) = ⊤`. ✓
- **Proof follows sketch**: yes. Extracts pointwise basic-open witnesses, then applies `isCompact_univ.elim_finite_subcover` and `PrimeSpectrum.iSup_basicOpen_eq_top_iff`. ✓
- **`\leanok` in blueprint**: yes (line 4836/4865)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.isLocalizedModule_of_span_cover, …}` (`lem:isLocalizedModule_of_span_cover`)
- **Lean target exists**: yes — `theorem isLocalizedModule_of_span_cover` plus 7 bundled private helpers
- **Signature matches**: yes. Given `g : M →ₗ[R] N`, `f : R`, a finite spanning family `s : Fin n → R`, and per-`j` `IsLocalizedModule (powers f)` of the `s j`-localized map, concludes `IsLocalizedModule (powers f) g`. Exactly matches blueprint. ✓
- **Proof follows sketch**: yes. Three-clause descent: unit clause (bijectivity-of-f is local on a spanning cover via `bijective_of_localized_span`), surjectivity clause (accumulates via `per_j_surj` and `mem_range_of_span_pow`), equalizer clause (via `per_j_eq` and `eq_zero_of_span_pow`). Matches blueprint's partition-of-unity argument exactly. ✓
- **`\leanok` in blueprint**: **absent** — neither statement nor proof block has `\leanok`. The Lean declaration has a complete proof with no sorry. (See Major finding M-1.)
- **notes**: The `% NOTE` in the blueprint explains that the 7 helpers are bundled solely to avoid leandag `unmatched` coverage debt. Acceptable.

---

### `\lean{AlgebraicGeometry.qcoh_finite_presentation_cover, AlgebraicGeometry.coversTop_iSup_eq_top}` (`lem:qcoh_finite_presentation_cover`)
- **Lean target exists**: yes — both `qcoh_finite_presentation_cover` and `coversTop_iSup_eq_top` (private)
- **Signature matches**: yes. Given `[hF : F.IsQuasicoherent]`, produces a QuasicoherentData `q`, `n, g : Fin n → R, φ : Fin n → q.I` with covering and spanning conditions. ✓
- **Proof follows sketch**: yes. Unpacks `nonempty_quasicoherentData`, translates `coversTop` to `⨆ = ⊤`, feeds to `exists_finite_basicOpen_subcover`. ✓
- **`\leanok` in blueprint**: **absent** (See Major finding M-1.)
- **notes**: No issues with the code.

---

### `\lean{AlgebraicGeometry.qcoh_section_equalizer, AlgebraicGeometry.res_trans_apply}` (`lem:qcoh_section_equalizer`)
- **Lean target exists**: yes — `theorem qcoh_section_equalizer` and private `res_trans_apply`
- **Signature matches**: yes (with a note). Lean is **strictly more general** than the blueprint statement: it takes arbitrary `U : ι → (Spec R).Opens` with `∀ i, U i ≤ W` and `W ≤ ⨆ U i`, while the blueprint states it for a finite family of basic-open intersections. This is the downstream specialization. The existing `% NOTE` (iter-041) in the blueprint documents this accurately. Sections are `(modulesSpecToSheaf.obj F).presheaf.obj` (ModuleCat R-valued). ✓
- **Proof follows sketch**: yes. Injectivity from `section_ext`; exactness from `existsUnique_gluing'` + `res_trans_apply`. ✓
- **`\leanok` in blueprint**: **absent** (See Major finding M-1.)
- **notes**: The blueprint generalization note is accurate. Lean decl subsumes the stated one.

---

### `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}` (`lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`)
- **Lean target exists**: yes
- **Signature matches**: yes. Given `A`-modules `M, N` with `IsScalarTower R A M/N`, `φ : M →ₗ[A] N`, `IsLocalizedModule (powers (algebraMap R A f)) φ`, concludes `IsLocalizedModule (powers f) (φ.restrictScalars R)`. ✓
- **Proof follows sketch**: yes. Three-clause direct descent using `hsmul` (`f^k • n = (algebraMap R A f)^k • n` via scalar tower). ✓
- **`\leanok` in blueprint**: yes (lines 4349/4363)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.tilde_section_isLocalizedModule}` (`lem:tilde_section_isLocalizedModule`)
- **Lean target exists**: yes
- **Signature matches**: yes. `IsLocalizedModule (powers f)` of `(modulesSpecToSheaf.obj (tilde M)).presheaf.map (homOfLE le_top).op).hom`. ✓
- **Proof follows sketch**: yes. Uses `tilde.toOpen_res` and `IsLocalizedModule.of_linearEquiv_right`. ✓
- **`\leanok` in blueprint**: yes (line 4028/4040)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.section_isLocalizedModule_of_isIso_fromTildeΓ}` (`lem:section_isLocalizedModule_of_isIso_fromTildeGamma`)
- **Lean target exists**: yes
- **Signature matches**: yes. Under `[IsIso F.fromTildeΓ]`, shows `IsLocalizedModule (powers f)` of the `F`-restriction map. ✓
- **Proof follows sketch**: yes. Constructs `α : F ≅ tilde M`, takes `β = modulesSpecToSheaf.map α.hom`, uses naturality of `β` to conjugate the `tilde M` local-model (via `tilde_section_isLocalizedModule`) to the `F`-restriction. ✓
- **`\leanok` in blueprint**: yes (lines 4051/4063)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.section_isLocalizedModule_of_presentation}` (`lem:section_isLocalizedModule_of_presentation`)
- **Lean target exists**: yes
- **Signature matches**: yes. Given `F.Presentation`, concludes `IsLocalizedModule (powers f)` of the F-restriction. ✓
- **Proof follows sketch**: yes. Discharges `[IsIso F.fromTildeΓ]` via `isIso_fromTildeΓ_of_presentation` then applies `section_isLocalizedModule_of_isIso_fromTildeΓ`. ✓
- **`\leanok` in blueprint**: yes (lines 4072/4086)
- **notes**: No issues.

---

### `\lean{AlgebraicGeometry.tile_image_opens_identities}` (`lem:tile_image_opens_identities`) — **NEW this iter**
- **Lean target exists**: yes
- **Signature matches**: yes. Returns the conjunction:  
  `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ ⊤) = specBasicOpen g` and  
  `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ D(algebraMap R R_g f)) = specBasicOpen (g * f)`.  
  Blueprint states exactly these two identities: `ι(Spec R_g) = D(g)` and `ι(D(f̄)) = D(gf)`. ✓
- **Proof follows sketch**: yes. Blueprint says "proved set-theoretically; not definitional." Lean uses `Scheme.Hom.comp_image`, `Opens.ext`, and point-wise comap reasoning (`PrimeSpectrum.localization_away_comap_range`). Non-definitional, as expected. ✓
- **`\leanok` in blueprint**: absent — expected for a declaration formalized this iteration; `sync_leanok` will add it on the next run.
- **notes**: The `% NOTE` comment in the blueprint correctly previews the Lean statement's iterated-image form. No issues.

---

### `AlgebraicGeometry.tile_section_localization` (`lem:tile_section_localization`) — **DEFERRED**
- **Lean target exists**: no — deliberately absent. A block comment at lines 771–793 of the Lean file documents the deferral.
- **Deferral comment honest**: **yes**. The comment gives the precise technical obstruction:  
  - `(modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (op V)` is `ModuleCat ↑(Localization.Away g)` (local ring),  
  - `(modulesSpecToSheaf.obj F).presheaf.obj (op (ι ''ᵁ V))` is `ModuleCat ↑R` (global ring).  
  The types are not equal; neither the carriers nor the scalar coherence `algebraMap R R_g r • x = r • x` is `rfl`. This correctly explains why Sub-lemma B (`lem:tile_section_comparison`) cannot be `rfl`. Estimate ~100–150 LOC is consistent with the blueprint note.
- **Blueprint sketch for `lem:tile_section_comparison` accurate**: **yes** — the 5-step proof in the blueprint (Step 1 global presentation, Step 2 localisation over R_g via `section_isLocalizedModule_of_presentation`, Step 3 opens identities via `tile_image_opens_identities`, Step 4 section comparison via Sub-lemma B, Step 5 base-ring descent via `isLocalizedModule_powers_restrictScalars_of_algebraMap`) correctly identifies:  
  - that the definitional equality `restrict_obj` holds only at the *local-ring* functor level,  
  - that the upgrade to the *global-ring* functor `modulesSpecToSheaf.obj` requires transporting across both `StructureSheaf.globalSectionsIso` restriction-of-scalars maps with a naturality and compatibility check,  
  - that this is a genuine ~100–150 LOC construction and not a wiring shortcut.  
  The blueprint does NOT authorize a trivial rfl route, and the deferred-note comment is consistent with the blueprint's honest description.
- **notes**: Per directive: no defect to report here.

---

## Red flags

None found.

### Placeholder / suspect bodies
None. No `:= sorry`, no `:= True`, no trivial-tautology bodies on substantive claims. The two `:= rfl` bodies (`qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv`) are correct: the equalities are definitional by construction.

### Excuse-comments
None. The block comment deferring `tile_section_localization` is accurate and specific — it names a real mathematical obstruction (module-type mismatch), gives an LOC estimate, and describes the remaining construction path. This is not an excuse-comment; it is an honest deferral note.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

All substantive declarations are `\lean{}`-referenced in the blueprint. The following private helpers have no separate blueprint block, but each is appropriately bundled in the `\lean{}` annotation of its parent:

- `exists_sum_pow_eq_one`, `mem_range_of_span_pow`, `eq_zero_of_span_pow`, `map_smul_endFun`, `bump_eq`, `per_j_surj`, `per_j_eq` → bundled in `lem:isLocalizedModule_of_span_cover`
- `coversTop_iSup_eq_top` → bundled in `lem:qcoh_finite_presentation_cover`
- `res_trans_apply` → bundled in `lem:qcoh_section_equalizer`

This bundling is correct and explicitly documented by `% NOTE` comments in the blueprint.

---

## Blueprint adequacy for this file

- **Coverage**: 17/17+ substantive Lean declarations have a corresponding `\lean{...}` block in the chapter. All private helpers are bundled in their parent annotation. Coverage is complete.
- **Proof-sketch depth**: **adequate**. Every proved declaration has either an adequate proof sketch or a documented `% NOTE` explaining the relationship between the Lean statement and the blueprint statement (e.g. the generalization note on `qcoh_section_equalizer`). The `lem:tile_section_comparison` proof body is detailed enough (~4 explicit sub-steps plus a naturality-and-compatibility closing sentence) for a prover to understand the construction path and know it is genuinely ~100–150 LOC.
- **Hint precision**: **precise**. All `\lean{...}` tags use fully-qualified names (`AlgebraicGeometry.*`), and each declared sub-item (helpers, simp lemmas) is either separately named or explicitly bundled.
- **Generality**: **matches need**. The Lean `qcoh_section_equalizer` is more general than stated (any cover, not just basic-open intersections); the blueprint note documents this explicitly and correctly.
- **Recommended chapter-side actions**: none for this iteration. The one `\lean{}` pin that lacks `\leanok` for a non-sorry declaration (`tile_image_opens_identities`) will be resolved by the next `sync_leanok` run.

---

## Severity summary

### Major
**M-1. Three `\lean{}`-pinned declarations lack `\leanok` despite having complete Lean proofs.**

The following blueprint blocks have `\lean{}` annotations and corresponding Lean declarations with no `sorry`, but neither the statement nor the proof block carries `\leanok`:

| Blueprint label | Lean declaration | Lines (blueprint) |
|---|---|---|
| `lem:isLocalizedModule_of_span_cover` | `AlgebraicGeometry.isLocalizedModule_of_span_cover` | 5095–5116 |
| `lem:qcoh_finite_presentation_cover` | `AlgebraicGeometry.qcoh_finite_presentation_cover` | 4094–4113 |
| `lem:qcoh_section_equalizer` | `AlgebraicGeometry.qcoh_section_equalizer` | 4293–4331 |

These declarations predate this iteration; their absence of `\leanok` is unexpected given that other declarations in the same file (e.g. `tilde_section_isLocalizedModule`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`) do carry `\leanok`. This may indicate a past compilation failure in `QcohTildeSections.lean` or its import `QcohRestrictBasicOpen` that prevented `sync_leanok` from verifying these blocks. The underlying Lean code itself is correct (no sorry, no bad bodies). Severity: **major** — stale missing markers, fixable by resolving any upstream compilation issue and re-running sync.

### Minor
**m-1. `tile_image_opens_identities` lacks `\leanok` (expected — new this iter).**  
Will be added by the next `sync_leanok` run. No action needed now.

**m-2. `qcoh_section_equalizer` Lean decl is strictly more general than the blueprint statement.**  
Documented by existing `% NOTE` (iter-041). No blueprint change needed.

---

**Overall verdict**: The file is clean — no must-fix findings; `tile_image_opens_identities` is correctly formalized and `\lean{}`-pinned; the `tile_section_localization` deferral note is honest and mathematically precise; the blueprint sketch for `lem:tile_section_comparison` correctly describes a genuine non-rfl ~100–150 LOC construction; 1 major finding (3 missing `\leanok` markers for complete proofs, likely a stale sync artifact).
