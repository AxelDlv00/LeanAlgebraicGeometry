# Lean ↔ Blueprint Check Report

## Slug
quotscheme-iter034

## Iteration
034

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (1320 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (4075 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: partial — blueprint specifies `L` as a **line bundle** and `F` as a **coherent sheaf with schematic support proper over S**, but Lean uses `(_L _F : X.Modules)` for both without those constraints; also missing a proper-support hypothesis. The output type `Polynomial ℚ` and the `s : S` parameter are correct.
- **Proof follows sketch**: N/A (body is `:= sorry`; blueprint has `\leanok` authorizing sorry)
- **notes**: Module docstring explicitly labels this an "iter-176 file-skeleton" with "typed sorry". Blueprint NOTE under `def:hilbert_polynomial` says body will be filled "iter-177+". The `\leanok` marker on the blueprint block is consistent with the sorry body.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: partial — return type `(Over S)ᵒᵖ ⥤ Type u` is correct; inputs `_π`, `_L`, `_E`, `_Φ` match the blueprint's description of the morphism, line bundle, coherent sheaf, and polynomial. The missing data (flatness, properness, surjection, etc.) lives in the body, not in the type.
- **Proof follows sketch**: N/A (body is `:= sorry`; `\leanok` in blueprint)
- **notes**: Blueprint has `\leanok`. Module docstring explains the sorry skeleton.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(_V : S.Modules) (_d : ℕ) : (Over S)ᵒᵖ ⥤ Type u` matches the functor of rank-d quotients.
- **Proof follows sketch**: N/A (body is `:= sorry`; `\leanok` in blueprint)
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225)
- **Signature matches**: no — blueprint prose states representability **by a smooth projective S-scheme of relative dimension d(r-d), with tautological rank-d quotient π*V ↠ U and Plücker embedding into ℙ_S(⋀^d V)**. Lean states only `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)` — a raw existence claim with no smooth/projective/dimension/tautological-quotient/Plücker data.
- **Proof follows sketch**: N/A (proof is `by sorry`)
- **notes**: The blueprint's `thm:grassmannian_representable` block itself contains a `% NOTE` acknowledging: "The Lean statement is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding." Blueprint has `\leanok`. The mismatch is documented but significant.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: `def:is_locally_free_of_rank`)
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — definition matches "open cover {Ui} with M|_{Ui} ≅ O_{Ui}^{⊕d}"; Lean uses `Nonempty (...≅ SheafOfModules.free (ULift (Fin d)))` which is the correct encoding.
- **Proof follows sketch**: yes (pure definition, no sorry)
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: `def:modules_annihilator`)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `IdealSheafData.ofIdeals fun U => Module.annihilator Γ(X,U.1) Γ(F,U.1)` matches the affine-local formula.
- **Proof follows sketch**: yes (uses `ofIdeals` as described in blueprint)
- **notes**: Blueprint has `\leanok`. The blueprint NOTE acknowledges that `ofIdeals` sidesteps basic-open coherence, as stated in the module docstring.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (chapter: `lem:modules_annihilator_ideal_le`)
- **Lean target exists**: yes (line 305)
- **Signature matches**: yes
- **Proof follows sketch**: yes (one-liner via `IdealSheafData.ideal_ofIdeals_le`)
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: `def:schematic_support`)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — `(annihilator F).subscheme` matches V(Ann(F))
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (chapter: `def:schematic_support_immersion`)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: `def:has_proper_support`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `IsProper (schematicSupportι F ≫ f)` matches blueprint exactly
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (chapter: `lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes (line 362)
- **Signature matches**: yes — `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` with `[Module.Finite R M]` matches blueprint
- **Proof follows sketch**: yes — proof follows the blueprint's "clear one common denominator over the generators" strategy
- **notes**: Blueprint has `\leanok`. The Lean proof uses `IsLocalizedModule.mk'_smul_mk'` and `Finset.dvd_prod_of_mem` in exactly the way the sketch implies.

### `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` (chapter: `lem:isLocalizedModule_tilde_restrict`)
- **Lean target exists**: yes (line 467)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `tilde.isoTop` + `IsLocalizedModule.of_linearEquiv_right` as described
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (chapter: `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`)
- **Lean target exists**: yes (line 510)
- **Signature matches**: yes
- **Proof follows sketch**: yes — naturality square + transport via `IsLocalizedModule.of_linearEquiv` as described
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation}` (chapter: `lem:isLocalizedModule_basicOpen_of_presentation`)
- **Lean target exists**: yes (line 686)
- **Signature matches**: yes
- **Proof follows sketch**: yes — composes `isIso_fromTildeΓ_of_presentation` with `isLocalizedModule_restrict_of_isIso_fromTildeΓ`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.map_units_restrict_basicOpen}` (chapter: `lem:map_units_restrict_basicOpen`)
- **Lean target exists**: yes (line 705)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `tilde.isUnit_algebraMap_end_basicOpen` + `.pow n`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}` (chapter: `lem:exists_finite_basicOpen_cover_le_quasicoherentData`)
- **Lean target exists**: yes (line 730)
- **Signature matches**: yes — `∃ t : Finset R, Ideal.span (t : Set R) = ⊤ ∧ ∀ r ∈ t, ∃ i, D(r) ≤ q.X i` matches blueprint
- **Proof follows sketch**: yes — uses `PrimeSpectrum.isBasis_basic_opens` + `Ideal.span_eq_top_iff_finite`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.overEquivalence_functor_isCocontinuous}` (chapter: `lem:overEquivalence_functor_isCocontinuous`)
- **Lean target exists**: yes (line 786)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.overEquivalence_inverse_isCocontinuous}` (chapter: `lem:overEquivalence_inverse_isCocontinuous`)
- **Lean target exists**: yes (line 815)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.overEquivalence_inverse_isDenseSubsite}` (chapter: `lem:overEquivalence_inverse_isDenseSubsite`)
- **Lean target exists**: yes (line 841)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Equivalence.isDenseSubsite_inverse_of_isCocontinuous`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.overEquivalence_functor_isContinuous}` (chapter: `lem:overEquivalence_functor_isContinuous`)
- **Lean target exists**: yes (line 849)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.overEquivalence_inverse_isContinuous}` (chapter: `lem:overEquivalence_inverse_isContinuous`)
- **Lean target exists**: yes (line 860)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.overEquivalence_sheafCongr}` (chapter: `def:overEquivalence_sheafCongr`)
- **Lean target exists**: yes (line 877)
- **Signature matches**: yes
- **Proof follows sketch**: yes — applies `Equivalence.sheafCongr`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}` (chapter: `def:over_restrict_equiv`)
- **Lean target exists**: yes (line 930)
- **Signature matches**: yes — `SheafOfModules.{u} (X.ringCatSheaf.over U) ≌ U.toScheme.Modules`
- **Proof follows sketch**: yes — `pushforwardPushforwardEquivalence` + symmetry
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso}` (chapter: `lem:over_restrict_functor_iso`)
- **Lean target exists**: yes (line 963)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `pushforwardComp ≪≫ pushforwardCongr`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictIso}` (chapter: `lem:over_restrict_iso`)
- **Lean target exists**: yes (line 980)
- **Signature matches**: yes
- **Proof follows sketch**: yes — object-level form of `overRestrictFunctorIso`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}` (chapter: `lem:over_restrict_pullback_iso`)
- **Lean target exists**: yes (line 990)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `overRestrictIso ≪≫ restrictFunctorIsoPullback`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso}` (chapter: `def:over_restrict_unit_iso`)
- **Lean target exists**: yes (line 1069)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `isIso_unitToPushforwardObjUnit_of_isIso'` with identity comparison
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPresentation}` (chapter: `def:over_restrict_presentation`)
- **Lean target exists**: yes (line 1095)
- **Signature matches**: yes — `Presentation.ofIsIso ∘ Presentation.map`
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData}` (chapter: `def:presentation_pullback_iota_of_quasicoherentData`)
- **Lean target exists**: yes (line 1118)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}` (chapter: `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`)
- **Lean target exists**: yes (line 1299)
- **Signature matches**: yes — `IsIso fromTildeΓ` of the pullback chain including the affine identification
- **Proof follows sketch**: yes — `isIso_fromTildeΓ_presentationPullback` + preimage affineness
- **notes**: Blueprint has `\leanok`. The blueprint's `% NOTE: the pinned Lean decl does NOT yet exist` is **stale** — the declaration was added in this iter. The NOTE should be updated to reflect it is now axiom-clean.

### `\lean{AlgebraicGeometry.bijective_comp_of_localizations}` (chapter: `lem:bijective_comp_of_localizations`)
- **Lean target exists**: yes (line 579), `private`
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `IsLocalizedModule.linearEquiv` + `linearMap_ext` as stated
- **notes**: Blueprint explicitly notes `private` is deliberate; the `\lean{}` pin is for DAG purposes.

### `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` (chapter: `lem:isIso_sheaf_of_isIso_app_basicOpen`)
- **Lean target exists**: yes (line 554), `private`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Same `private` note as above.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}` (chapter: `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict`)
- **Lean target exists**: yes (line 614)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `isIso_sheaf_of_isIso_app_basicOpen` + `SpecModulesToSheafFullyFaithful.isIso_of_isIso_map`
- **notes**: Blueprint has `\leanok`.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (chapter: `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`)
- **Lean target exists**: yes (line 653)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint has `\leanok`.

### Blueprint pins that name NON-EXISTENT Lean declarations

| Blueprint label | Pinned Lean name | Status |
|---|---|---|
| `lem:qcoh_section_localization_basicOpen` | `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen` | **does not exist**; blueprint `% NOTE` acknowledges this explicitly |
| `lem:qcoh_affine_section_localization` | `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` | **does not exist**; blueprint `% NOTE` acknowledges |
| `lem:qcoh_affine_isIso_fromTildeΓ` | `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent` | **does not exist**; blueprint `% NOTE` acknowledges (gap1 primary) |
| `lem:section_localization_descent` | `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent` | **does not exist**; blueprint `% NOTE` acknowledges (gap1 descent keystone D) |

All four missing declarations are explicitly acknowledged in the blueprint with `% NOTE` comments. They form the remaining gap1 assembly: gap1 = (descent D) + (G1-assemble) + (G1-core ↔ gap1 equivalence). The Lean file has all the ingredients but not the final assembly.

---

## Red flags

### Excuse-comments
- `QuotScheme.lean:119-122`: comment "iter-177+: the body unfolds to the graded-Euler-characteristic construction ... For the iter-176 file-skeleton the body is a typed `sorry`" on `hilbertPolynomial`. **However**, the blueprint's `\leanok` explicitly authorizes sorry here, so this is acknowledged workflow rather than an excuse for wrong code.
- `QuotScheme.lean:156-160`, `195-197`, `219-228`: same pattern for `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. Same conclusion.
- `QuotScheme.lean` lines 3930-3938 (blueprint side, not Lean): the blueprint `% NOTE` on `thm:grassmannian_representable` says the Lean statement "under-delivers the prose statement; it should be strengthened or split into a separate skeleton label." This blueprint-side NOTE is itself a mild excuse for a known mismatch; not a Lean-side red flag.

### Stale blueprint NOTE
The blueprint `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` contains:
```
% NOTE: the pinned Lean decl isIso_fromTildeΓ_restrict_basicOpen does NOT yet exist
```
This is stale: `isIso_fromTildeΓ_restrict_basicOpen` **now exists** in the Lean file (line 1299) and is axiom-clean.

---

## Unreferenced declarations (informational)

The following non-private Lean declarations in `QuotScheme.lean` have **no corresponding `\lean{}` pin** in the blueprint chapter. They are all part of the P1 keystone machinery (lines 1127–1317) built to support `isIso_fromTildeΓ_restrict_basicOpen`:

| Declaration | Line | Comment |
|---|---|---|
| `presentationPullbackιRestrict` | 1179 | Step: present geo restriction of M to W ⊆ (q.Xi).toScheme |
| `opensMapEquivOfIso` | 1194 | Helper: opens functor of an iso is an equivalence |
| `opensMap_final_of_schemeIso` | 1213 | Helper: opens functor of an iso is Final |
| `pullbackSchemeIsoUnitIso` | 1226 | Step-4: pullback along iso sends unit to unit |
| `presentationPullbackOfSchemeIso` | 1244 | Step-4: presentation transports along pullback by iso |
| `isIso_fromTildeΓ_presentationPullback` | 1269 | Intermediate: fromTildeΓ is iso for affine W ⊆ cover member |

These are all substantive project-original declarations (not private) that implement steps in the proof of `isIso_fromTildeΓ_restrict_basicOpen`. The blueprint describes the keystone proof at a high level but does not give each helper its own `\lean{}` block. They are helpers (`lean_aux` role) rather than standalone mathematical claims, so the absence of explicit blueprint blocks is acceptable but worth noting for completeness.

Additionally, `isIso_unitToPushforwardObjUnit_of_isIso'` (line 1037) is `private` and unreferenced; no issue.

---

## Blueprint adequacy for this file

- **Coverage**: Of the declarations in `QuotScheme.lean`, all substantive non-private ones (4 main + ~25 gap1 infrastructure) are either `\lean{}`-pinned in the blueprint or are helpers for pinned keystones. The graded-module infrastructure lives in `GradedHilbertSerre.lean` (also covered by this chapter). Coverage is **adequate** for the declarations this file actually contains.
- **Proof-sketch depth**: **adequate** for the completed declarations. The blueprint provides detailed prose proofs for all the gap1 building blocks (annihilator localization, tilde restrict, over-site equivalence, P1 transport). The gap1 keystones (D, G1-core, gap1) that remain as sorries have detailed proofs in the blueprint showing what needs to be done.
- **Hint precision**: **precise** for completed declarations. The `\lean{}` pins name the actual Lean identifiers. The four non-existent pins are properly flagged with `% NOTE: does not exist` in the blueprint.
- **Generality**: **matches need** for the completed infrastructure. The `hilbertPolynomial` and `QuotFunctor` signatures use `X.Modules` for the line bundle and coherent sheaf arguments, which is broader than the blueprint specifies (no line-bundle or coherence constraint). This is a known skeleton choice, not a generality failure.
- **Recommended chapter-side actions**:
  - Update the `% NOTE: the pinned Lean decl isIso_fromTildeΓ_restrict_basicOpen does NOT yet exist` comment in `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` — it now exists and is axiom-clean.
  - Consider adding `\lean{}` blocks for `presentationPullbackιRestrict`, `pullbackSchemeIsoUnitIso`, `presentationPullbackOfSchemeIso`, `isIso_fromTildeΓ_presentationPullback` once the plan agent decides whether these should be elevated to blueprint-level lemmas or remain documented helpers.
  - The `% NOTE` on `thm:grassmannian_representable` ("should be strengthened or split") records an open task; no immediate action needed.

---

## Severity summary

### Major findings

1. **`Grassmannian.representable` signature mismatch** (`thm:grassmannian_representable`): The blueprint prose claims a smooth, projective, relative-dimension-d(r-d) S-scheme with tautological quotient and Plücker embedding. The Lean statement is bare existence `∃ Y, Nonempty (RepresentableBy Y)`. The blueprint's own `% NOTE` acknowledges this. As a sorry-body skeleton this is expected and documented, but the Lean and blueprint prose diverge significantly.

2. **`hilbertPolynomial` parameter types too weak** (`def:hilbert_polynomial`): Blueprint specifies a line bundle for `_L` and a coherent sheaf with proper support for `_F`; Lean uses unconstrained `X.Modules` for both, with no proper-support hypothesis. Documented in module docstring as a skeleton choice.

3. **Four blueprint-pinned declarations are absent from the file**:
   - `isLocalizedModule_basicOpen` (gap2 keystone)
   - `isLocalizedModule_basicOpen_of_isQuasicoherent` (G1-core)
   - `isIso_fromTildeΓ_of_isQuasicoherent` (gap1 primary)
   - `isLocalizedModule_basicOpen_descent` (gap1 descent keystone D)
   
   All are explicitly acknowledged in blueprint `% NOTE` comments. These are the open gap1 goals.

4. **Stale blueprint NOTE** (`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`): claims `isIso_fromTildeΓ_restrict_basicOpen` does not exist; it now does (line 1299, axiom-clean). The blueprint should be updated.

### Minor findings

1. Six helper declarations in the P1 keystone section (lines 1179–1279) have no explicit blueprint block. They are sound implementations of steps described in the prose proof of `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`.

2. Module docstrings reference "iter-176 file-skeleton" / "iter-177+" — internal iteration labels now outdated for the four main sorry declarations.

---

**Overall verdict**: The file is well-formed against the blueprint for all completed declarations — signatures and proofs are faithful. The four sorried main declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) are authorized by `\leanok` markers with known skeleton bodies. The open gap1 assembly (`isIso_fromTildeΓ_of_isQuasicoherent` and its keystone descent `isLocalizedModule_basicOpen_descent`) is the primary remaining work indicated by the blueprint, and the iter-034 landing of `isIso_fromTildeΓ_restrict_basicOpen` (P1 keystone) closes the P1 step of that assembly — **29 declarations checked, 1 stale NOTE + 4 missing gap1 finals + 2 skeleton signature gaps + 6 undocumented helpers = 13 notable items, 0 must-fix-this-iter**.
