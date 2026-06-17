# Lean ↔ Blueprint Check Report

## Slug
quot-iter036

## Iteration
036

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (1698 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (4447 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackTopIso}` (chapter: `lem:pullback_gamma_top_iso`, blueprint L3666–3712)

- **Lean target exists**: yes — `Scheme.Modules.gammaPullbackTopIso` at lines 1688–1691
- **Signature matches**: yes — blueprint: `Γ((pullback j).obj M, ⊤) ≅ Γ(M, range j)`; Lean: `Γ((Scheme.Modules.pullback f).obj M, ⊤) ≅ Γ(M, f.opensRange)`. The `eqToIso (by rw [Scheme.Hom.image_top_eq_opensRange])` bridge confirms `f ''ᵁ ⊤ = f.opensRange` definitionally. Match is exact.
- **Proof follows sketch**: yes — blueprint proof (L3699–3711) says "apply `restrictFunctorIsoPullback f` at M and evaluate at V = ⊤." Lean body is `gammaPullbackImageIso f M ⊤ ≪≫ eqToIso (...)`, which is precisely `Γ(-, ⊤)` applied to `(restrictFunctorIsoPullback f).symm.app M`, matching the sketch.
- **No sorry / placeholder**: confirmed. Body is a closed term composition with no `sorry`.
- **notes**: `\leanok` marker correctly placed on `lem:pullback_gamma_top_iso` statement block (L3666) by `sync_leanok`. Proof block correctly has no `\leanok` (proof is a `def` body, not a `theorem`).

---

## Red flags

### Stale blueprint NOTE — declaration existence

**Blueprint L3675**: `% NOTE: the pinned Lean decl gammaPullbackTopIso does NOT yet exist; it is the iter-036 prover target`

This is now incorrect: `gammaPullbackTopIso` was delivered this iteration and exists axiom-clean at Lean line 1688. The NOTE should be updated to reflect the landed status and axiom report. This is a **stale comment** — not a math error, but it should be cleaned up so the next planner is not confused.

### Over-optimistic blueprint NOTE — "one-liner" claim (CRITICAL)

**Blueprint L3678–3679** (inside `lem:pullback_gamma_top_iso`, NOTE block):
```
% Once it lands, the named-form descent (\cref{lem:section_localization_descent}) and gap1
% (\cref{lem:qcoh_affine_isIso_fromTildeΓ}) are both one-liners.
```

**Blueprint L3749–3750** (inside `lem:section_localization_descent`, NOTE block):
```
% Once lem:pullback_gamma_top_iso lands
% this block and gap1 are both one-liners.
```

**This claim is INCORRECT.** The prover has confirmed (and the code reflects) that two Mathlib-absent ingredients remain between `gammaPullbackTopIso` and the named-form descent `isLocalizedModule_basicOpen_descent`:

**(I) Ring-iso-semilinear `IsLocalizedModule` transport.**
The P1 transport (`isIso_fromTildeΓ_restrict_basicOpen`) delivers `IsIso fromTildeΓ` for the module M′ on `Spec R_r`. Applying `isLocalizedModule_restrict_of_isIso_fromTildeΓ` then gives `IsLocalizedModule(powers f')` on `Γ(M', ⊤) → Γ(M', D(f'))`, where the localization is over the ring `R_r = R[r⁻¹]` at the image element `f' = f/1 ∈ R_r`.

`gammaPullbackTopIso` (and `gammaPullbackImageIso`) provide section isomorphisms `Γ(M', ⊤) ≅ Γ(M, D(r))` and `Γ(M', D(f')) ≅ Γ(M, D(f) ⊓ D(r))`. But transporting `IsLocalizedModule(powers f') over R_r` across those section isos to `IsLocalizedModule(powers f) over R` on `Γ(M, D(r)) → Γ(M, D(f) ⊓ D(r))` requires a **semilinear** variant of `IsLocalizedModule.of_linearEquiv` that works across a ring homomorphism `R → R_r`. Mathlib's `IsLocalizedModule.of_linearEquiv` and `IsLocalizedModule.of_linearEquiv_right` handle only the same-ring case. No semilinear transport is available at the pinned commit.

**(II) Base-change-of-localization R → R_r.**
To identify `powers f` over R with `powers f'` over R_r, one needs a compatibility lemma relating the two localization submonoids under the ring map `algebraMap R R_r`. This is conceptually `Submonoid.map_powers` composed with a semilinear repackaging — also not directly available in Mathlib at the pinned commit in the form needed here.

Concretely: the named-form `isLocalizedModule_basicOpen_descent` (Lean target `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent`) remains **two substantive Lean lemmas away** from the landed infrastructure, not a one-liner. The blueprint NOTEs at L3678–3679 and L3749–3750 must be corrected before the next planning iteration or the planner will assign false one-liner objectives.

---

## Unreferenced declarations (informational)

### `gammaPullbackImageIso` (Lean lines 1668–1672) — **should be pinned, major**

This is the **general-in-U** form: `Γ((pullback f).obj M, U) ≅ Γ(M, f ''ᵁ U)` for any `U : X.Opens`. The blueprint proof of `lem:pullback_gamma_top_iso` (L3700–3711) implicitly relies on this general statement (it is how `gammaPullbackTopIso` is built). Moreover, the two-sentence naturality claim of `lem:pullback_gamma_top_iso` (L3690–3693: "naturally in the open argument: for opens V ≤ ⊤ of U the comparison … intertwines the restriction maps, so any two such instances commute with the restriction between them") is exactly the content of this declaration plus `gammaPullbackImageIso_hom_naturality`. The blueprint should carry a `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso}` pin.

### `gammaPullbackImageIso_hom_naturality` (Lean lines 1678–1682) — **should be pinned, major**

This is the explicit naturality/intertwines-restriction lemma: `((pullback f).obj M).presheaf.map i.op ≫ (gammaPullbackImageIso f M V).hom = (gammaPullbackImageIso f M U).hom ≫ M.presheaf.map (f.opensFunctor.map i).op`. It is the formal statement of the naturality claimed in the blueprint lemma statement. Without a `\lean{...}` pin it is invisible to the blueprint dependency graph; the next prover who needs to chain restriction maps will not know it exists. Blueprint should carry `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_naturality}`.

### Pre-existing protected stubs

All 4 pre-existing sorries confirmed at lines 126/165/201/228 (bodies of `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`). Comments correctly describe them as "iter-177+ work" / "file-skeleton body is a typed sorry." These are not red flags — they are blueprint-authorized future work, explicitly noted in the module header.

### Other helpers (acceptable, no pins needed)

The file contains many private and project-local helper declarations (`iSup_basicOpen_subtype_eq_top`, `res_comp`, `descent_smul_eq_zero`, `descent_overlap_agree`, `descent_surj`, `isIso_sheaf_of_isIso_app_basicOpen`, `bijective_comp_of_localizations`, `isIso_unitToPushforwardObjUnit_of_isIso'`, `opensMap_final_of_schemeIso`, `overEquivalence_functor_isCocontinuous`, `overEquivalence_inverse_isCocontinuous`, `overEquivalence_inverse_isDenseSubsite`, `overEquivalence_functor_isContinuous`, `overEquivalence_inverse_isContinuous`). All are correctly `private` or documented as project-local; they are infrastructure for the pinned declarations. No additional pins required.

---

## Blueprint adequacy for this file

- **Coverage**: 4 blueprint-pinned declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) plus the new `gammaPullbackTopIso` are all present in the Lean file and signatures match. Missing pins: `gammaPullbackImageIso` and `gammaPullbackImageIso_hom_naturality` (2 unreferenced substantive helpers). Count: 5/5 pinned declarations present, 2 substantive helpers unregistered.

- **Proof-sketch depth**: **partially under-specified for the gap1-D path.** The individual declarations are well-sketched; the gap is in the blueprint's aggregated claim that once `gammaPullbackTopIso` lands the remaining work is "trivial" — this is false by the prover's report (see over-optimistic NOTE above). The proof of `lem:section_localization_descent` (L3786–3820) outlines the steps but does not flag that the ring-change semilinear transport is a non-trivial Mathlib gap; a reader following only the blueprint prose would expect `IsLocalizedModule.of_linearEquiv` to suffice.

- **Hint precision**: **precise for `gammaPullbackTopIso`**; `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackTopIso}` correctly identifies the Lean declaration. **Loose for the naturality companion and the general-U helper** (blueprint does not name them).

- **Generality**: matches need for `gammaPullbackTopIso` (the `⊤` instance). The `gammaPullbackImageIso` general-U form, needed for the Hfr chain (where U can be any open ≤ D(r) including overlaps D(r)⊓D(r')), should also be captured in the blueprint since it is a separate, re-usable API point.

- **Recommended chapter-side actions**:
  1. **MUST FIX (this iter, blocks planner)**: Update the NOTE at `lem:pullback_gamma_top_iso` (L3675) to mark `gammaPullbackTopIso` as landed and axiom-clean.
  2. **MUST FIX (this iter, blocks planner)**: Correct the over-optimistic "one-liner" claims at L3678–3679 and L3749–3750. Add explicit note that two Mathlib-absent ingredients remain: (I) ring-iso-semilinear `IsLocalizedModule` transport, and (II) base-change-of-localization compatibility for `powers f` over R vs `powers f'` over R_r. Estimate the residual work accurately so the next planner scopes it correctly.
  3. **Major (this iter if possible)**: Add `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso}` pin to `lem:pullback_gamma_top_iso` (or a sibling lemma block), with a statement: `Γ((pullback f).obj M, U) ≅ Γ(M, f ''ᵁ U)` for general U.
  4. **Major (this iter if possible)**: Add `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_naturality}` pin documenting the naturality/intertwines-restriction clause.

---

## Severity summary

| Finding | Severity |
|---|---|
| `gammaPullbackTopIso` delivered, pin correct, signature matches | ✅ OK |
| 4 pre-existing protected stubs confirmed at L126/165/201/228 | ✅ OK |
| Blueprint NOTE L3675 stale ("does NOT yet exist" after landing) | major |
| Blueprint NOTE L3678–3679 and L3749–3750 over-optimistic "one-liner" claim | **must-fix-this-iter** |
| `gammaPullbackImageIso` unregistered in blueprint (general-U helper) | major |
| `gammaPullbackImageIso_hom_naturality` unregistered (naturality companion) | major |

**Must-fix-this-iter gate fires on the over-optimistic NOTE.** If the planner reads those NOTEs at face value, the next iteration will assign a false one-liner prover objective for `isLocalizedModule_basicOpen_descent` and gap1, wasting a full prover cycle.

**Overall verdict**: `gammaPullbackTopIso` landed axiom-clean with correct pin and matching signature; the pre-existing stubs are authorized; however the blueprint chapter carries two over-optimistic "one-liner" notes that must be corrected before the next planning phase, and two substantive helpers (`gammaPullbackImageIso`, `gammaPullbackImageIso_hom_naturality`) lack blueprint pins.
