# Lean ↔ Blueprint Check Report

## Slug
quot

## Iteration
035

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`, blueprint L57–138)
- **Lean target exists**: yes (L123–126)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsLocallyNoetherian S] (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _F : X.Modules) (_s : S) : Polynomial ℚ`; blueprint says "encoded as a function `S → Polynomial ℚ`" ✓
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint statement block has `\leanok` (correct: declaration exists). No proof-block `\leanok` (correct: body is a typed sorry). Inline comment honestly states "iter-177+: body unfolds to the graded-Euler-characteristic construction; for the iter-176 file-skeleton the body is a typed sorry."
- **Notes**: Pre-existing stub, properly marked. Untouched this iter.

---

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`, blueprint L3948–4021)
- **Lean target exists**: yes (L161–165)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u` functor; blueprint says "contravariant functor `(Sch/S)^op ⥤ Set`" ✓
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint statement block has `\leanok` (correct). No proof-block `\leanok` (correct). Inline comment says "iter-177+: body packages on-objects/on-morphisms data; for the iter-176 file-skeleton the body is a typed sorry."
- **Notes**: Pre-existing stub, properly marked. Untouched this iter.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`, blueprint L4031–4083)
- **Lean target exists**: yes (L198–201)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u` functor; blueprint says `Grass(V,d) : (Sch/S)^op → Set` ✓
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint statement block has `\leanok` (correct). Inline comment says "iter-177+: body re-exports QuotFunctor; for the iter-176 file-skeleton the body is a typed sorry."
- **Notes**: Pre-existing stub, properly marked. Untouched this iter.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`, blueprint L4097–4217)
- **Lean target exists**: yes (L225–228)
- **Signature matches**: **partial** — Lean declares `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, which is a bare existence of a representing object. The blueprint prose says "representable by a **smooth projective** S-scheme of **relative dimension d(r-d)**, equipped with a **tautological rank-d quotient** π*V ↠ U and a **Plücker closed embedding** into ℙ_S(⋀^d V)."  The Lean statement omits every one of these geometric refinements.
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint statement block has `\leanok` (correct: declaration exists). No proof-block `\leanok` (correct: proof body is sorry). The blueprint has an explicit NOTE at L4112–4116 acknowledging this mismatch: "The Lean statement…is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding. The `\lean{}` pin above points at a declaration that under-delivers the prose statement; it should be strengthened or split into a separate skeleton label."
- **Notes**: Pre-existing acknowledged signature shortfall. Properly self-documented in blueprint. Untouched this iter.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}` (chapter: `lem:section_localization_descent`, blueprint L3544–3628)
- **Lean target exists**: **no** — `isLocalizedModule_basicOpen_descent` does NOT appear as a declared theorem anywhere in the Lean file. It is referenced only in comments (L1317, L1352, L1622).
- **Signature matches**: N/A — declaration absent.
- **Proof follows sketch**: N/A.
- **Notes**: The blueprint block has NO `\leanok` (correct). The `% NOTE (iter-035)` at L3551–3560 is **accurate in every detail**:
  - The pinned named form does not exist. ✓
  - The cover-hypothesis form `isLocalizedModule_basicOpen_descent_of_cover` landed axiom-clean at ~L1626. ✓
  - The named form stays gated on the slice→Spec R_r section transport (Hfr). ✓
  - The NOTE explicitly recommends: "Planner: either repoint `\lean{}` to `..._descent_of_cover` + add a thin downstream block for the named form, or add a dedicated cover-form block."

  **The coverage gap**: `isLocalizedModule_basicOpen_descent_of_cover` (L1626–1646) is a **public (non-private), fully proved** theorem (no sorry, axiom-clean per project memory). It has **no `\lean{}` pin anywhere in the blueprint**. This is the primary coverage finding for this iter — see Red Flags section below.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}` (chapter: `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`, blueprint L3490–3540)
- **Lean target exists**: yes (L1299–1313)
- **Signature matches**: yes — `IsIso` of `fromTildeΓ` of the iterated pullback to a basic-open preimage; blueprint statement matches the five-step descent.
- **Proof follows sketch**: yes — proof calls `isIso_fromTildeΓ_presentationPullback`, which is exactly the "per affine open of a cover member" general form cited in the blueprint NOTE at L3499–3505. Five-step route matches. The `% NOTE: RESOLVED and axiom-clean` at L3499 is accurate.
- **Notes**: Statement block has `\leanok`. No sorry. ✓

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (chapter: `lem:qcoh_section_localization_basicOpen`, blueprint L2476–2546)
- **Lean target exists**: no — only in comments.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **Notes**: Blueprint block has NO `\leanok` (correct). NOTE at L2481–2493 says "the pinned Lean decl does NOT yet exist." Honest.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_section_localization`, blueprint L2698–2760)
- **Lean target exists**: no — only in comments.
- **Notes**: Blueprint block has NO `\leanok` (correct). NOTE at L2703–2711 says "the Lean decl does NOT yet exist." Honest.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_isIso_fromTildeΓ`, blueprint L3630–3669)
- **Lean target exists**: no — only in comments.
- **Notes**: Blueprint block has NO `\leanok` (correct). NOTE at L3635–3641 says "the Lean decl does NOT yet exist." Honest.

---

### Declarations confirmed axiom-clean in-file (no further issues)

All of the following have matching `\lean{}` pins in the blueprint (with `\leanok` on statement and proof blocks where applicable) and have no sorry in the Lean file:

| Lean decl (file line) | Blueprint label | Status |
|---|---|---|
| `annihilator` (L298) | `def:modules_annihilator` | ✓ |
| `annihilator_ideal_le` (L305) | `lem:modules_annihilator_ideal_le` | ✓ |
| `Module.annihilator_isLocalizedModule_eq_map` (L362) | `lem:annihilator_localization_eq_map` | ✓ |
| `schematicSupport` (L312) | `def:schematic_support` | ✓ |
| `schematicSupportι` (L320) | `def:schematic_support_immersion` | ✓ |
| `HasProperSupport` (L328) | `def:has_proper_support` | ✓ |
| `SheafOfModules.IsLocallyFreeOfRank` (L253) | `def:is_locally_free_of_rank` | ✓ |
| `isLocalizedModule_tilde_restrict` (L467) | `lem:isLocalizedModule_tilde_restrict` | ✓ |
| `isLocalizedModule_restrict_of_isIso_fromTildeΓ` (L510) | `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` | ✓ |
| `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (L614) | `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict` | ✓ |
| `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (L653) | `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` | ✓ |
| `isLocalizedModule_basicOpen_of_presentation` (L686) | `lem:isLocalizedModule_basicOpen_of_presentation` | ✓ |
| `map_units_restrict_basicOpen` (L705) | `lem:map_units_restrict_basicOpen` | ✓ |
| `exists_finite_basicOpen_cover_le_quasicoherentData` (L730) | `lem:exists_finite_basicOpen_cover_le_quasicoherentData` | ✓ |
| `overEquivalence_functor_isCocontinuous` (L786) | `lem:overEquivalence_functor_isCocontinuous` | ✓ |
| `overEquivalence_inverse_isCocontinuous` (L815) | `lem:overEquivalence_inverse_isCocontinuous` | ✓ |
| `overEquivalence_inverse_isDenseSubsite` (L841) | `lem:overEquivalence_inverse_isDenseSubsite` | ✓ |
| `overEquivalence_functor_isContinuous` (L849) | `lem:overEquivalence_functor_isContinuous` | ✓ |
| `overEquivalence_inverse_isContinuous` (L860) | `lem:overEquivalence_inverse_isContinuous` | ✓ |
| `overEquivalence_sheafCongr` (L877) | `lem:over_site_sheaf_equivalence` | ✓ |
| `overRestrictEquiv` (L930) | `lem:over_restrict_equiv` | ✓ |
| `overRestrictFunctorIso` (L963) | `lem:over_restrict_functor_iso` | ✓ |
| `overRestrictIso` (L980) | `lem:over_restrict_iso` | ✓ |
| `overRestrictPullbackIso` (L990) | `lem:over_restrict_pullback_iso` | ✓ |
| `overRestrictUnitIso` (L1069) | `lem:over_restrict_unit_iso` | ✓ |
| `overRestrictPresentation` (L1095) | `def:over_restrict_presentation` | ✓ |
| `presentationPullbackιOfQuasicoherentData` (L1118) | `def:presentation_pullback_iota_of_quasicoherentData` | ✓ |
| `presentationPullbackιRestrict` (L1179) | `lem:presentation_pullback_iota_restrict` | ✓ |
| `opensMapEquivOfIso` (L1194) | `lem:opensMap_equiv_of_iso` | ✓ |
| `opensMap_final_of_schemeIso` (L1213) | `lem:opensMap_final_of_schemeIso` | ✓ |
| `pullbackSchemeIsoUnitIso` (L1226) | `lem:pullbackSchemeIso_unit_iso` | ✓ |
| `presentationPullbackOfSchemeIso` (L1244) | `lem:presentation_pullback_of_schemeIso` | ✓ |
| `isIso_fromTildeΓ_presentationPullback` (L1269) | `lem:isIso_fromTildeΓ_presentationPullback` | ✓ |

Private helpers with blueprint acknowledgment notes:

| Lean decl | Blueprint label | Status |
|---|---|---|
| `private bijective_comp_of_localizations` (L579) | `lem:bijective_comp_of_localizations` | Pin acknowledged as private in NOTE; ✓ |
| `private isIso_sheaf_of_isIso_app_basicOpen` (L554) | `lem:isIso_sheaf_of_isIso_app_basicOpen` | Pin acknowledged as private in NOTE; ✓ |

---

## Red Flags

### Missing blueprint block — substantive public declaration

**`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover`** at L1626–1646.

This theorem is:
- **Public** (not `private`)
- **Fully proved** (no `sorry` in the body; axiom-clean per prior iter review)
- **The actual gap1-D keystone that landed this iter** — the blueprint NOTE at `lem:section_localization_descent` explicitly identifies it as the work completed

It takes the cover-form hypothesis `Hfr` directly and delivers `IsLocalizedModule (Submonoid.powers f)` for the global section restriction. The blueprint has no dedicated `\lean{}` block for it anywhere. The `lem:section_localization_descent` block pins a *different* name (`isLocalizedModule_basicOpen_descent`) that does not exist in Lean.

The NOTE at L3551–3560 explicitly calls this out and instructs the planner to act: "Planner: either repoint `\lean{}` to `..._descent_of_cover` + add a thin downstream block for the named form, or add a dedicated cover-form block."

**Action needed**: The planner must add a dedicated `lem:section_localization_descent_of_cover` blueprint block for `isLocalizedModule_basicOpen_descent_of_cover`, and optionally repoint (or retain as a future target) the `lem:section_localization_descent` pin for the named form. This is a blueprint adequacy gap for the most significant theorem landed this iter.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no `\lean{}` pin in the blueprint:

1. **`isLocalizedModule_basicOpen_descent_of_cover`** (L1626) — **substantive, public**. See Red Flags above. Should have a blueprint block.

2. Private helpers: `iSup_basicOpen_subtype_eq_top` (L1330), `res_comp` (L1340), `descent_smul_eq_zero` (L1356), `descent_overlap_agree` (L1418), `descent_surj` (L1461) — all `private`. No blueprint block required by convention. ✓

3. Private helpers (older): `isIso_unitToPushforwardObjUnit_of_isIso'` (L1037), `isIso_sheaf_of_isIso_app_basicOpen` (L554), `bijective_comp_of_localizations` (L579) — `private`. The latter two have blueprint pins with explicit "private" acknowledgment notes; the first has no pin (acceptable since it is private and the blueprint already covers `unitToPushforwardObjUnit` via Mathlib). ✓

---

## Blueprint adequacy for this file

- **Coverage**: Of the 40+ non-private non-stub Lean declarations in this file, all substantive ones have a `\lean{}` block except `isLocalizedModule_basicOpen_descent_of_cover`. Private helpers (8 total) owe no blueprint block. The 4 protected stubs are correctly marked as "statement formalized (sorry body)" in the blueprint.
- **Proof-sketch depth**: **adequate**. Every formalized proof that is not a stub has a sufficiently detailed blueprint sketch. The gap1-D descent steps (Stages 1–5 in `descent_surj`, the `exists_of_eq` engine in `descent_smul_eq_zero`) are each traced in the blueprint's proof sketch for `lem:section_localization_descent` and its component lemmas.
- **Hint precision**: **precise**. All `\lean{}` pins name the correct Lean declaration. The two acknowledged exceptions (`isLocalizedModule_basicOpen`, `isLocalizedModule_basicOpen_descent`, `isLocalizedModule_basicOpen_of_isQuasicoherent`, `isIso_fromTildeΓ_of_isQuasicoherent`) are correctly marked without `\leanok` and with explicit `% NOTE` explanations.
- **Generality**: **matches need**. No parallel API written outside the blueprint's intended scope.
- **Recommended chapter-side actions**:
  1. **Add a dedicated `lem:section_localization_descent_of_cover` block** for `isLocalizedModule_basicOpen_descent_of_cover`, describing it as the cover-form keystone D (takes the `Hfr` hypothesis directly, no quasi-coherence required). Pin `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover}`. The current `lem:section_localization_descent` block (pinning the named form `isLocalizedModule_basicOpen_descent`) can stay as a future target with its existing `% NOTE`.
  2. Optionally: add a note under `thm:grassmannian_representable` clarifying the intended strengthening path (the existing NOTE at L4112–4116 already does this; no immediate action required).

---

## Severity summary

### Major
1. **`isLocalizedModule_basicOpen_descent_of_cover` has no blueprint block** (L1626). A public, fully proved, iter-035 keystone theorem is unregistered in the blueprint. The existing NOTE at `lem:section_localization_descent` explicitly instructs the planner to add a dedicated block or repoint. This blocks accurate `\leanok` propagation and DAG tracking for gap1-D. *(Blueprint adequacy gap; major, not must-fix-this-iter since the Lean is clean — only the blueprint registration is missing.)*

2. **`thm:grassmannian_representable` signature shortfall** (Lean L225, blueprint L4097). The Lean statement is a bare existence-of-representing-object skeleton; the blueprint prose claims a smooth projective scheme of relative dimension d(r-d) with tautological quotient and Plücker embedding. This is a pre-existing, acknowledged partial signature mismatch (blueprint NOTE L4112–4116). *(Not new this iter; pre-existing stub under the "never weaken the type to dodge the proof" rule is intentionally deferred.)*

### Must-fix this iter
**None.**

The 4 protected stubs (L126, L165, L201, L228) are correctly marked in the blueprint as statement-formalized-with-sorry (per the `\leanok` on statement block convention) and have no proof-block `\leanok`. No declaration claiming a substantive proof has a `sorry` body. No excuse-comments or placeholder weakening found.

### Minor
- The `% NOTE` at `lem:bijective_comp_of_localizations` and `lem:isIso_sheaf_of_isIso_app_basicOpen` warns that the `\lean{}` pins resolve only project-internally because the Lean declarations are `private`. This is documented; a future refactor could make them `protected` or add a thin public alias, but no action is required now.

---

**Overall verdict**: The Lean file is in clean, axiom-free formalization state for all non-stub declarations. The single actionable gap is that `isLocalizedModule_basicOpen_descent_of_cover` — the fully proved cover-form gap1-D keystone landed this iter — lacks a blueprint block; the planner should add one as directed by the existing `% NOTE (iter-035)` in `lem:section_localization_descent`. The Grassmannian representability signature shortfall is pre-existing and acknowledged.

**Declarations checked**: ~40 `\lean{}` pins + 5 private helpers + 4 protected stubs. **Red flags**: 1 (missing blueprint block for cover-form keystone).
