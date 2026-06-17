# Lean ↔ Blueprint Check Report

## Slug
quot-iter038

## Iteration
038

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaImageRingEquiv}` (chapter: `def:gamma_image_ring_equiv`)

**Blueprint location**: tex ~line 3829 (`\begin{definition}\leanok`).

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.gammaImageRingEquiv` at QuotScheme.lean:1815.
- **Signature matches**: **no** — direction is inverted relative to the blueprint's `% LEAN TYPE` pin and prose.

  | Source | Statement |
  |--------|-----------|
  | Blueprint prose (line 3843–3844) | `σ_V : Γ(O_Y, j''ᵁ V) ⟶ Γ(O_U, V)` (image → source) |
  | Blueprint `% LEAN TYPE` pin (line 3837) | `gammaImageRingEquiv (j) (V) : Γ(Y, j ''ᵁ V) ≃+* Γ(U, V)` (image → source) |
  | **Actual Lean type** (QuotScheme.lean:1815–1816) | `gammaImageRingEquiv (j : X ⟶ Y) [IsOpenImmersion j] (V : X.Opens) : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)` (source → image) |

  The Lean type is the *inverse* of the `% LEAN TYPE` pin and the prose description. As a Lean type `RingEquiv A B` vs `RingEquiv B A` are distinct.

- **Proof follows sketch**: N/A (definition body; body is `(j.appIso V).commRingCatIsoToRingEquiv.symm` — real term, no sorry).
- **notes**:
  - **No sorry, no axiom**. The definition is axiom-clean.
  - The Lean direction (source → image) is the *mathematically correct* direction for this iso's downstream use. In `gammaPullbackImageIso_hom_semilinear` the formula `hom(a • x) = σ_V(a) • hom x` requires `σ_V` to map source-ring scalars to image-ring scalars; and in `isLocalizedModule_of_ringEquiv_semilinear` the template `σ : R ≃+* R'` likewise expects source → image. The Lean code satisfies both requirements correctly.
  - The blueprint prose and `% LEAN TYPE` pin state the opposite direction. This is a blueprint error, not a Lean error.
  - **The `% NOTE:` correction flagging the prose direction mismatch has NOT been applied to the blueprint file** (as of the current file state). Lines 3825–3827 carry a `% NOTE (iter-038)` about the semilinearity wall but say nothing about the direction flip. The `% LEAN TYPE` pin at line 3837 still says `Γ(Y, j ''ᵁ V) ≃+* Γ(U, V)`.
  - The `\leanok` marker at line 3829 is correct (real body, no sorry).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_semilinear}` (chapter: `lem:gamma_pullback_image_iso_hom_semilinear`)

**Blueprint location**: tex ~line 3848 (`\begin{lemma}\leanok`).

- **Lean target exists**: yes — at QuotScheme.lean:1825.
- **Signature matches**: **yes** (modulo the `σ_V` direction issue inherited from `gammaImageRingEquiv`, which the Lean resolves correctly).

  Blueprint formula: `hom(a • x) = σ_V(a) • hom x` where `a : Γ(X, V)` (source) and `hom x : Γ(M, j''ᵁ V)` (image).
  Lean statement (QuotScheme.lean:1827–1829):
  ```lean
  (gammaPullbackImageIso j M V).hom (a • x)
    = gammaImageRingEquiv j V a • (gammaPullbackImageIso j M V).hom x
  ```
  This is exactly the blueprint formula with `σ_V = gammaImageRingEquiv` in source→image direction. The two sides are well-typed precisely because `gammaImageRingEquiv j V : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)`.

- **Proof follows sketch**: **yes**.

  Blueprint sketch (lines 3866–3877): unfold `Functor.mapIso` / `mapPresheaf`, invoke `map_smul` field of the underlying presheaf-of-modules morphism, close by `mapPresheaf`-naturality. Explicitly says "argue at the level of presheaf sections (term-mode applied `map_smul` / `mapPresheaf`-naturality), NOT by keyed rewriting under the modules instance diamond."

  Lean proof (QuotScheme.lean:1832–1840):
  ```lean
  simp only [gammaPullbackImageIso, Functor.mapIso_hom, Functor.comp_map,
    Scheme.Modules.toPresheaf_map, CategoryTheory.evaluation_obj_map,
    Scheme.Modules.mapPresheaf_app]
  erw [Scheme.Modules.Hom.app_smul]
  rfl
  ```
  Unfolds via `simp`, then applies `Hom.app_smul` (the `map_smul` / presheaf-module-morphism compatibility), closes by `rfl` (definitional equality via `restrictScalars` action). This is precisely the blueprint's strategy: no keyed rewriting of module-instance diamonds.

- **notes**:
  - **No sorry, no axiom**. The proof is axiom-clean.
  - The `\leanok` marker at line 3848 is correct.
  - The lemma correctly cross-references `\uses{lem:gamma_pullback_image_iso, def:gamma_image_ring_equiv}` in the blueprint.

---

## Red flags

### Blueprint `% LEAN TYPE` pin vs Lean signature

`def:gamma_image_ring_equiv` (tex line 3837): the `% LEAN TYPE` pin records
```
gammaImageRingEquiv (j) (V) : Γ(Y, j ''ᵁ V) ≃+* Γ(U, V)
```
but the Lean type is the inverse direction `Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)`. The pin does not match the formalization. This is a blueprint documentation error (not a Lean error).

### Blueprint prose direction inconsistency

The prose display formula at lines 3843–3845 reads:
```
σ_V : Γ(O_Y, j''ᵁ V) → Γ(O_U, V)
```
but the semilinearity formula at lines 3856–3863 (`hom(a • x) = σ_V(a) • hom x`, with `a` a source-ring scalar) requires `σ_V` to go **source → image**. The prose definition and the formula are internally inconsistent. The Lean code resolves this in favour of the formula (source → image), which is the mathematically correct direction.

### `% NOTE:` correction not yet applied

The directive states the review agent was to add a `% NOTE:` about the prose direction and correct the `% LEAN TYPE` pin. Neither correction appears in the current blueprint file (as of the state read during this check). The plan agent should ensure these corrections land.

---

## Unreferenced declarations (informational)

The following Lean declarations in `QuotScheme.lean` are not the `\lean{...}` target of any blueprint block (or not yet checked in this iteration). Most are clearly helpers; the ones whose names suggest blueprint relevance are noted:

- `hilbertPolynomial` (line 123) — **sorry body**, documented iter-176 skeleton. Blueprint ref `def:hilbert_polynomial` exists; sorry is explicitly documented in the blueprint as iter-177+ work.
- `QuotFunctor` (line 161) — **sorry body**, iter-176 skeleton. Blueprint ref `def:quot_functor` exists.
- `Grassmannian` (line 198) — **sorry body**, iter-176 skeleton.
- `Grassmannian.representable` (line 225) — **sorry body**, iter-176 skeleton.
- `isLocalizedModule_tilde_restrict` (line 467) — helper for the gap1 bridge; blueprint ref `lem:qcoh_section_localization_basicOpen` context.
- `isLocalizedModule_restrict_of_isIso_fromTildeΓ` (line 510) — helper; blueprint reference exists.
- `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (line 614) — blueprint ref exists.
- `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (line 653) — blueprint ref exists.
- `isLocalizedModule_basicOpen_of_presentation` (line 686) — blueprint ref exists.
- `exists_finite_basicOpen_cover_le_quasicoherentData` (line 730) — blueprint ref exists.
- `overEquivalence_functor_isCocontinuous` (line 786) — blueprint ref in `lem:over_restrict_iso` context.
- `isLocalizedModule_of_ringEquiv_semilinear` (line 1670) — blueprint ref `lem:isLocalizedModule_ringEquiv_semilinear`.
- `isLocalizedModule_restrictScalars_powers_algebraMap` (line 1720) — blueprint ref `lem:isLocalizedModule_restrictScalars_powers_algebraMap`.
- `gammaPullbackImageIso` (line 1781) — blueprint ref `lem:gamma_pullback_image_iso` (existing; not an iter-038 new declaration).
- `gammaPullbackTopIso` (line 1801) — blueprint ref `lem:pullback_gamma_top_iso` (existing).

These are noted for completeness; they are not iter-038 targets and their sorry/axiom status falls outside the scope of this check.

---

## Blueprint adequacy for this file

*Scoped to the two iter-038 declarations only, per directive.*

- **Coverage**: 2/2 iter-038 declarations have a corresponding `\lean{...}` block. Both carry `\leanok`. The `% LEAN TYPE` pin for `def:gamma_image_ring_equiv` is wrong (see above).
- **Proof-sketch depth**: **adequate** for `lem:gamma_pullback_image_iso_hom_semilinear` — the proof sketch correctly names the key step (`map_smul`/`Hom.app_smul`), explicitly warns against keyed rewriting, and the Lean proof follows it exactly. **Silent** for `def:gamma_image_ring_equiv` (definitions need no proof sketch, but the definition body is a one-liner from `j.appIso`).
- **Hint precision**: **wrong** for `def:gamma_image_ring_equiv` — the `% LEAN TYPE` pin specifies the inverse direction from what was formalized. The pin must be updated to `Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)` (or equivalently, written with `j : X ⟶ Y`). The prose display formula `σ_V : Γ(O_Y, j''ᵁ V) → Γ(O_U, V)` also needs flipping. **Precise** for `lem:gamma_pullback_image_iso_hom_semilinear`.
- **Generality**: matches need for both declarations.
- **Recommended chapter-side actions**:
  1. In `def:gamma_image_ring_equiv` (tex ~line 3837), update `% LEAN TYPE` pin to:
     ```
     % gammaImageRingEquiv (j : X ⟶ Y) [IsOpenImmersion j] (V : X.Opens) : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)
     ```
  2. In `def:gamma_image_ring_equiv` prose (tex ~line 3843–3845), flip the direction in the display formula to:
     `σ_V : Γ(O_U, V) → Γ(O_Y, j''ᵁ V)` (source → image).
  3. Add a `% NOTE:` explaining that the Lean direction is source→image (the direction required by the semilinearity formula and by `isLocalizedModule_of_ringEquiv_semilinear`), and that the prose was corrected in iter-038 to match.
  4. No changes needed for `lem:gamma_pullback_image_iso_hom_semilinear`.

---

## Severity summary

- **must-fix-this-iter**: none. Both iter-038 Lean declarations are axiom-clean, correctly proved, and correctly typed for their downstream use. No sorries, no fake statements, no excuse comments on the new work.
- **major**: The blueprint `% LEAN TYPE` pin and prose direction for `def:gamma_image_ring_equiv` are the inverse of the actual Lean type. The `% NOTE:` correction flagged in the directive has not been applied to the blueprint file. A blueprint-writing sub-agent should apply the three corrections listed above.
- **minor**: The prose inconsistency between the `σ_V` direction in the definition and in the semilinearity formula is a latent source of confusion for future readers.

**Overall verdict**: Both iter-038 declarations (`gammaImageRingEquiv`, `gammaPullbackImageIso_hom_semilinear`) are axiom-clean and correctly formalized; the blueprint prose for `def:gamma_image_ring_equiv` states the wrong direction for `σ_V` and the `% LEAN TYPE` pin is inverted — a major blueprint-side correction is needed but no Lean changes are required.
