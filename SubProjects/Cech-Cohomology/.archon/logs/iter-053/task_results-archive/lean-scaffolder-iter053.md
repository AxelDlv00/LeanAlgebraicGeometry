# Lean Scaffolder Report — iter053

## Status: SUCCESS

Both stub files compile with only expected `declaration uses sorry` warnings. No errors,
no unresolved imports, no unknown identifiers.

---

## File 1 — `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`

**Verification:**
```
AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean:78:8: warning: declaration uses `sorry`
```
(single warning, no errors)

**Final pinned signature:**
```lean
theorem cechAugmented_exact (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p) := by
  sorry
```

**Lean name:** `AlgebraicGeometry.cechAugmented_exact` (matches blueprint `\lean{AlgebraicGeometry.cechAugmented_exact}`).

**Namespace/opens:** `namespace AlgebraicGeometry`, `open Scheme.Modules`, `open CategoryTheory Limits`.

**Affineness convention:**
- Cover elements: `h𝒰 : ∀ i, IsAffine (𝒰.X i)` — uses `OpenCover.X : I₀ → Scheme`, the
  canonical field in Mathlib's `Cover` structure (verified via Mathlib source at
  `AlgebraicGeometry/Cover/MorphismProperty.lean`: `X := obj`).
- Intersections: `[X.IsSeparated]` — `Scheme.IsSeparated X`, which wraps
  `IsSeparated (terminal.from X)` (verified via leansearch: `Scheme.IsSeparated.mk`).
  Together these ensure all finite intersections of cover elements are affine.
- Finiteness: `[Finite 𝒰.I₀]` — matches the convention of `cech_computes_higherDirectImage`.

---

## File 2 — `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

**Verification:**
```
AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean:63:8: warning: declaration uses `sorry`
AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean:84:8: warning: declaration uses `sorry`
```
(two warnings for two stubs, no errors)

**Final signatures:**

Part (1) helper stub:
```lean
theorem higherDirectImage_openImmersion_acyclic [HasInjectiveResolutions U.Modules]
    (j : U ⟶ X) [IsOpenImmersion j] [IsAffine U] [X.IsSeparated]
    (H : U.Modules) (hH : H.IsQuasicoherent) (q : ℕ) (hq : 0 < q) :
    IsZero (higherDirectImage j q H) := by
  sorry
```

Part (2) pinned stub:
```lean
theorem higherDirectImage_openImmersion_comp
    [HasInjectiveResolutions X.Modules] [HasInjectiveResolutions U.Modules]
    (j : U ⟶ X) [IsOpenImmersion j] [IsAffine U] [X.IsSeparated]
    (f : X ⟶ S) (H : U.Modules) (hH : H.IsQuasicoherent) (k : ℕ) :
    Nonempty (higherDirectImage f k ((pushforward j).obj H) ≅
              higherDirectImage (j ≫ f) k H) := by
  sorry
```

**Lean names:**
- `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` (helper, not pinned but supports (2))
- `AlgebraicGeometry.higherDirectImage_openImmersion_comp` (pinned, matches blueprint
  `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}`)

**Hypothesis notes:**
- `[HasInjectiveResolutions U.Modules]` for (1): needed because `higherDirectImage j q H` uses
  `U.Modules` as source (verified: `higherDirectImage (f : X ⟶ S) i F` requires
  `[HasInjectiveResolutions X.Modules]` — i.e. the *source* category, here `U`).
- `[HasInjectiveResolutions X.Modules]` added to (2): needed for `higherDirectImage f k (j_* H)`
  where `j_* H : X.Modules` is the source object for `f : X ⟶ S`.
- `pushforward j` from `open Scheme.Modules` to write `j_* H = (pushforward j).obj H`.

---

## Build root — `AlgebraicJacobian.lean`

Lines added after `import AlgebraicJacobian.Cohomology.QcohTildeSections`:
```lean
import AlgebraicJacobian.Cohomology.CechAugmentedResolution
import AlgebraicJacobian.Cohomology.OpenImmersionPushforward
```

---

## Uncovered declarations

None. Both declarations have corresponding blueprint entries:
- `cechAugmented_exact` ← `\lean{AlgebraicGeometry.cechAugmented_exact}` in `lem:cech_augmented_resolution`
- `higherDirectImage_openImmersion_comp` ← `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` in `lem:open_immersion_pushforward_comp`

The helper `higherDirectImage_openImmersion_acyclic` (part (1) of `lem:open_immersion_pushforward_comp`)
is pinned under the same blueprint label `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}`
as the two-part lemma. If a separate `\lean{...}` pin is desired for part (1), the planner should
add `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` to the same block.

---

## Declaration name verification

All referenced names were verified to exist:
- `cechAugmentedComplex` — `CechHigherDirectImage.lean:745`
- `higherDirectImage` — `HigherDirectImage.lean:47`
- `pushforward` — from `open Scheme.Modules` (used in `HigherDirectImage.lean:49`)
- `IsOpenImmersion` — Mathlib `AlgebraicGeometry.OpenImmersion` (leansearch confirmed)
- `IsAffine` — Mathlib `AlgebraicGeometry.AffineScheme` (leansearch confirmed)
- `Scheme.IsSeparated` — Mathlib `AlgebraicGeometry.Morphisms.Separated` (leansearch confirmed)
- `PresheafOfModules.homologyIsoSheafify` — `HigherDirectImagePresheaf.lean:112`
- `sectionCech_homology_exact_of_localizationAway` — `CechAcyclic.lean:1868`
- `isZero_presheafToSheaf_obj_of_W` — `CechHigherDirectImage.lean:811`
- `isZero_presheafToSheaf_obj_of_isLocallyBijective` — `CechHigherDirectImage.lean:840`
- `affineCoverSystem` — `AffineSerreVanishing.lean:373`
- `standard_cover_cofinal` — `AffineSerreVanishing.lean:167`
- `Functor.rightDerivedIsoOfAcyclicResolution` — `AcyclicResolution.lean:893`
- `qcoh_iso_tilde_sections` — `QcohTildeSections.lean:66`
