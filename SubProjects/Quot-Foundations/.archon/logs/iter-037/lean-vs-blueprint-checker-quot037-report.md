# Lean ↔ Blueprint Check Report

## Slug
quot037

## Iteration
037

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (1811 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (4506 lines)

---

## Per-declaration

The chapter covers both `QuotScheme.lean` and `GradedHilbertSerre.lean`. Only declarations
from `QuotScheme.lean` are audited here. GradedHilbertSerre.lean blocks (`sectionGradedRing`,
`sectionGradedModule`, `gradedModule_hilbertSeries_rational`, `IsRatHilb.*`, etc.) are out of scope.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (def:hilbert_polynomial)
- **Lean target exists**: yes (line 55 approx)
- **Signature matches**: yes — `(π : X ⟶ S) → L → F → s → Polynomial ℚ`; blueprint prose matches
- **Proof follows sketch**: N/A — authorized scaffold `:= sorry`; blueprint `\leanok` on statement only
- **Notes**: frozen scaffold; `:= sorry` is authorized

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (def:quot_functor)
- **Lean target exists**: yes
- **Signature matches**: yes — `π L E Φ → (Over S)ᵒᵖ ⥤ Type u`; prose matches
- **Proof follows sketch**: N/A — authorized scaffold `:= sorry`
- **Notes**: frozen scaffold

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (def:grassmannian_scheme)
- **Lean target exists**: yes
- **Signature matches**: yes — `V → d → (Over S)ᵒᵖ ⥤ Type u`; prose matches
- **Proof follows sketch**: N/A — authorized scaffold `:= sorry`
- **Notes**: frozen scaffold

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (thm:grassmannian_representable)
- **Lean target exists**: yes (line ~220)
- **Signature matches**: **partial** — Lean provides bare existence `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`; blueprint prose claims smooth projective S-scheme of relative dimension d(r-d), tautological rank-d quotient bundle, Plücker embedding into ℙ(∧^d V). Blueprint NOTE at thm:grassmannian_representable explicitly acknowledges this gap.
- **Proof follows sketch**: N/A — authorized scaffold `by sorry`
- **Notes**: pre-existing authorized mismatch; blueprint NOTE says "weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding." The `\lean{...}` pin under-delivers the prose.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (def:is_locally_free_of_rank)
- **Lean target exists**: yes (line ~232)
- **Signature matches**: yes — `(M : SheafOfModules) (d : ℕ) : Prop`; prose matches
- **Proof follows sketch**: N/A — definition
- **Notes**: blueprint notes "Mathlib does not provide this predicate"; correct

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (def:modules_annihilator)
- **Lean target exists**: yes (line ~260)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — definition; body is axiom-clean
- **Notes**: `\leanok` present; matches

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (lem:modules_annihilator_ideal_le)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present; matches

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (lem:annihilator_localization_eq_map)
- **Lean target exists**: yes (line 362; in `namespace Module` outside `namespace AlgebraicGeometry`)
- **Signature matches**: yes — `[Module.Finite R M] (f : M →ₗ[R] Mₚ) [IsLocalizedModule S f] : Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` — matches blueprint's `Ann(S⁻¹M) = (Ann M)·S⁻¹R`
- **Proof follows sketch**: yes — two-direction proof `⊇` (image of annihilator annihilates) and `⊆` (clear common denominator over generators) matches blueprint prose exactly
- **Notes**: `\leanok` present on blueprint statement; proof is complete, axiom-clean; fully-qualified name `Module.annihilator_isLocalizedModule_eq_map` (not under `AlgebraicGeometry.*`) is correct

### `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` (lem:isLocalizedModule_tilde_restrict)
- **Lean target exists**: yes (line ~450)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — iff by the two engines
- **Notes**: `\leanok` present; appears twice in blueprint (forward ref + definition block); consistent

### `\lean{AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation}` (lem:isLocalizedModule_basicOpen_of_presentation)
- **Lean target exists**: yes (line ~650)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.map_units_restrict_basicOpen}` (lem:map_units_restrict_basicOpen)
- **Lean target exists**: yes (line ~700)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}` (lem:exists_finite_basicOpen_cover_le_quasicoherentData)
- **Lean target exists**: yes (line ~750)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.overEquivalence_functor_isCocontinuous}` through `overEquivalence_sheafCongr` (6 declarations)
- **Lean targets exist**: yes (lines 776-882)
- **Signature matches**: yes for all 6
- **Proof follows sketch**: yes for all 6
- **Notes**: all `\leanok` present; these fill the Mathlib `Topology/Sheaves/Over.lean` TODO

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}` (def:over_restrict_equiv)
- **Lean target exists**: yes (line ~885)
- **Signature matches**: yes — `SheafOfModules (X.ringCatSheaf.over U) ≃ U.toScheme.Modules`
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present; axiom-clean

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso}` (lem:over_restrict_functor_iso)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictIso}` (lem:over_restrict_iso)
- **Lean target exists**: yes (line ~940)
- **Signature matches**: yes — iso between transported slice restriction and geometric restriction functor
- **Proof follows sketch**: yes — NOTE in blueprint confirms "RESOLVED and axiom-clean"
- **Notes**: `\leanok` present; blueprint NOTE confirms step-2 ring-sheaf identification collapsed to `rfl`

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}` (lem:over_restrict_pullback_iso)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso}` (def:over_restrict_unit_iso), `overRestrictPresentation` (def:over_restrict_presentation), `presentationPullbackιOfQuasicoherentData` (def:presentation_pullback_iota_of_quasicoherentData)
- **Lean targets exist**: yes (lines 998-1125)
- **Signature matches**: yes for all 3
- **Proof follows sketch**: yes for all 3
- **Notes**: all `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.presentationPullbackιRestrict}` through `presentationPullbackOfSchemeIso` (5 declarations)
- **Lean targets exist**: yes (lines 1127-1314)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: all `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_presentationPullback}` (lem:isIso_fromTildeΓ_presentationPullback)
- **Lean target exists**: yes (line ~1280)
- **Signature matches**: yes — general form: IsIso fromTildeΓ on any affine open of a cover member
- **Proof follows sketch**: yes — 5-step affine descent as described
- **Notes**: `\leanok` present; this is the general keystone of which the next is an instance

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}` (lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent)
- **Lean target exists**: yes (line ~1310)
- **Signature matches**: yes
- **Proof follows sketch**: yes — blueprint NOTE confirms "RESOLVED and axiom-clean"
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover}` (lem:section_localization_descent_of_cover)
- **Lean target exists**: yes (line ~1600)
- **Signature matches**: yes — takes finite basic-open cover and per-piece localization data (Hfr) as hypothesis, produces global IsLocalizedModule
- **Proof follows sketch**: yes — three IsLocalizedModule fields verified: map_units (uses lem:map_units_restrict_basicOpen), surj (gluing + flatness), exists_of_eq (separatedness + per-piece exists_of_eq)
- **Notes**: `\leanok` present; blueprint NOTE confirms "LANDED, axiom-clean"

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackTopIso}` (lem:pullback_gamma_top_iso)
- **Lean target exists**: yes (line 1801)
- **Signature matches**: yes — `Γ((pullback f).obj M, ⊤) ≅ Γ(M, f.opensRange)` where `f.opensRange = f ''ᵁ ⊤`
- **Proof follows sketch**: yes — `U = ⊤` instance of `gammaPullbackImageIso` composed with `eqToIso`
- **Notes**: `\leanok` on blueprint statement; proof block lacks `\leanok` (consistent with chapter-wide convention that only statement blocks carry `\leanok`); Lean `def` body appears complete

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso}` (lem:gamma_pullback_image_iso)
- **Lean target exists**: yes (line 1781)
- **Signature matches**: yes — `Γ((pullback f).obj M, U) ≅ Γ(M, f ''ᵁ U)` for any open `U`
- **Proof follows sketch**: yes — `Functor.mapIso` of `(restrictFunctorIsoPullback f).symm.app M`
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_naturality}` (lem:gamma_pullback_image_iso_hom_naturality)
- **Lean target exists**: yes (line 1791)
- **Signature matches**: yes — naturality of `gammaPullbackImageIso` across restrictions
- **Proof follows sketch**: yes — definitional reduction to `mapPresheaf.naturality`
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.bijective_comp_of_localizations}` (lem:bijective_comp_of_localizations)
- **Lean target exists**: yes (private declaration, lines ~1370-1400)
- **Signature matches**: yes — two localizations of M at S, map h intertwining them → h bijective
- **Proof follows sketch**: yes — uniqueness via `linearMap_ext`
- **Notes**: `\leanok` present; private; blueprint NOTE acknowledges private status

### `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` (lem:isIso_sheaf_of_isIso_app_basicOpen)
- **Lean target exists**: yes (private)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **Notes**: `\leanok` present; private; blueprint NOTE acknowledges private status

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}` (lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict)
- **Lean target exists**: yes (line ~560)
- **Signature matches**: yes — per-basic-open section localization → IsIso fromTildeΓ
- **Proof follows sketch**: yes — basis + stalks argument as described
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (def:schematic_support)
- **Lean target exists**: yes (line ~300)
- **Signature matches**: yes — closed subscheme V(Ann F) ↪ X
- **Proof follows sketch**: N/A — definition
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (def:schematic_support_immersion)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes — `schematicSupport F ⟶ X`
- **Notes**: `\leanok` present

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (def:has_proper_support)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `IsProper (schematicSupportι F ≫ f)`
- **Notes**: `\leanok` present

### Pending / gated declarations (no Lean target yet — expected)

#### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}` (lem:section_localization_descent)
- **Lean target exists**: no — blueprint NOTE (line 3793) confirms "the pinned Lean decl isLocalizedModule_basicOpen_descent does NOT yet exist"
- **Notes**: named-form gap1-D keystone; cover-form (`_of_cover`) exists axiom-clean; named form is the instantiation at the quasi-coherence cover once Hfr is produced; gated on the two iter-037 transport theorems landing correctly into the descent chain

#### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` (lem:qcoh_affine_isIso_fromTildeΓ)
- **Lean target exists**: no — blueprint NOTE (line 3886) confirms "the Lean decl does NOT yet exist; gap1 is the PRIMARY stated gap"
- **Notes**: gap1 final assembly; one-liner once `isLocalizedModule_basicOpen_descent` lands; assembles via `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (already axiom-clean)

#### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent}` (lem:qcoh_affine_section_localization / lem:qcoh_affine_section_localization_basicOpen)
- **Lean target exists**: no — blueprint NOTE (lines ~2476-2546) confirms decl "does NOT yet exist"; corollary of gap1
- **Notes**: expected gap; correct behavior

---

## Red flags

### Placeholder / suspect bodies
None among the non-scaffold declarations. All `sorry`-carrying declarations are in the four
authorized frozen scaffold stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
`Grassmannian.representable`).

### Excuse-comments
None. The `-- USER:` comments in the file are mathematician-directed hints per the Archon
protocol, not excuse-comments on broken code.

### Known blueprint-acknowledged mismatch (not new)

- **`Grassmannian.representable`** — the `\lean{...}` pin points to a scaffold stub that
  under-delivers the prose statement: the Lean type omits smoothness, properness, relative
  dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding. Blueprint
  NOTE at `thm:grassmannian_representable` explicitly acknowledges this as a "weakened existence
  skeleton" and recommends strengthening or splitting into a separate skeleton label. This is
  a pre-existing authorized situation, not a regression introduced in iter-037.

---

## Unreferenced declarations (informational)

### Substantive — missing proper `\lean{...}` blocks (coverage debt, iter-037)

These two new declarations are axiom-clean, non-private, and substantive, but have no proper
`\begin{lemma}...\lean{...}...\end{lemma}` block in the blueprint. They are mentioned only in
a NOTE comment at `lem:pullback_gamma_top_iso` (blueprint lines 3768–3782):

1. **`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear`**
   (line 1670 — `theorem`)
   - Ring-iso-σ-semilinear IsLocalizedModule transport: given σ : R ≃+* R', semilinear
     AddEquivs e₁, e₂, and an IsLocalizedModule S g, produces IsLocalizedModule (S.map σ) h
   - Mathlib-absent at pinned commit; bridges the semilinear section iso
     (`gammaPullbackImageIso`) to R-linear Hfr data
   - Fully proved (3 fields: map_units, surj, exists_of_eq), no sorry

2. **`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap`**
   (line 1720 — `theorem`)
   - Base-change-of-localization bridge: if g : M₁ →ₗ[Rr] M₂ is IsLocalizedModule at
     `powers (algebraMap R Rr f)`, then `g.restrictScalars R` is IsLocalizedModule at
     `powers f` over R
   - Mathlib-absent; lets the Rr-level P1 localization read back as R-level Hfr
   - Fully proved (3 fields), no sorry

### Private helpers (acceptable — not flagged)

Several private declarations in the Gap1-D descent section (lines 1315–1645) such as
`descent_surj_aux`, `descent_smul_eq_zero`, `descent_exists_of_eq` (names approximate) serve
as private lemmas for `isLocalizedModule_basicOpen_descent_of_cover`. These do not need
blueprint blocks.

---

## Blueprint adequacy for this file

- **Coverage**: ~43/45 substantive public Lean declarations in `QuotScheme.lean` have a
  corresponding `\lean{...}` block in the chapter. The 2 uncovered are the iter-037 new
  transport theorems (items 1–2 above). Private helpers (~6) and the 3 pending-gap
  declarations are accounted for.
- **Proof-sketch depth**: adequate for all declared items. For the two new iter-037
  theorems: no sketch at all (only a one-line description in a NOTE comment at
  `lem:pullback_gamma_top_iso`).
- **Hint precision**: precise throughout; `\lean{...}` names match fully-qualified Lean names
  with one exception — `Grassmannian.representable` pins a stub that under-delivers the prose.
- **Generality**: matches need for all declared items.
- **Recommended chapter-side actions**:
  - Add a proper `\begin{lemma}\leanok ... \lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear} ... \end{lemma}` block (ingredient I of the Hfr chain)
  - Add a proper `\begin{lemma}\leanok ... \lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap} ... \end{lemma}` block (ingredient II of the Hfr chain)
  - Either strengthen `Grassmannian.representable` to match the full prose (smooth, projective,
    tautological quotient, Plücker), or split into a separate `thm:grassmannian_representable_skeleton`
    that accurately describes the current sorry-stub

---

## Severity summary

**must-fix-this-iter**: none. No undisclosed sorry-level stubs, no signature mismatches beyond
the pre-authorized Grassmannian scaffold, no excuse-comments, no unauthorized axioms.

**major** (2 findings):
1. `isLocalizedModule_of_ringEquiv_semilinear` (line 1670): substantive non-private axiom-clean
   theorem with no proper `\lean{...}` blueprint block — only a NOTE mention. Blueprint cannot
   guide prover re-use or dependency tracking for this ingredient.
2. `isLocalizedModule_restrictScalars_powers_algebraMap` (line 1720): same situation —
   ingredient II of the Hfr chain, no proper blueprint block.

**major (pre-existing, authorized)**:
3. `Grassmannian.representable`: `\lean{...}` pin under-delivers the prose statement
   (smoothness, properness, Plücker embedding all omitted from the scaffold stub). Acknowledged
   in the blueprint NOTE. Not a regression, but the pin is technically wrong.

**minor** (3 findings):
- `isLocalizedModule_basicOpen_descent`: blueprint `\lean{...}` block exists with NOTE "decl
  does NOT yet exist" — correct behavior, but the block has no `\leanok` and the NOTE should
  track the two new transport theorems as the gating ingredients.
- `isIso_fromTildeΓ_of_isQuasicoherent`: same — correctly documented as pending.
- `isLocalizedModule_basicOpen_of_isQuasicoherent`: same.

**Overall verdict**: `QuotScheme.lean` is faithful to its blueprint for all formalized
declarations; the two iter-037 transport theorems (`isLocalizedModule_of_ringEquiv_semilinear`
and `isLocalizedModule_restrictScalars_powers_algebraMap`) are axiom-clean and substantive but
lack proper `\lean{...}` blueprint blocks — coverage debt that should be resolved by adding
two lemma blocks in the chapter before these theorems are referenced by downstream provers.
