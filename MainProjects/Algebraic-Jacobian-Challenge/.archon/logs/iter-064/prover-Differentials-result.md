# AlgebraicJacobian/Differentials.lean

## Summary

Created `AlgebraicJacobian/Differentials.lean` as a new file scaffolding Phase B step 1 (relative Kähler differentials for schemes). The file compiles successfully with 6 `sorry` bodies. Added `import AlgebraicJacobian.Differentials` to `AlgebraicJacobian.lean`.

## Declarations scaffolded

| Line | Declaration | Type | Status |
|------|-------------|------|--------|
| 59 | `relativeDifferentialsPresheaf` | `X.PresheafOfModules` | **Compiles** (noncomputable def) |
| 66 | `relativeDifferentialsPresheaf_isSheaf` | `Presheaf.IsSheaf ...` | **Compiles** (theorem, sorry) |
| 75 | `relativeDifferentials` | `X.Modules` | **Compiles** (noncomputable def) |
| 85 | `universalDerivation` | morphism of abelian presheaves | **Compiles** (def, sorry) |
| 101 | `cotangent_exact_sequence` | `∃ α β, ShortComplex.Exact ... ∧ Epi β` | **Compiles** (theorem, sorry) |
| 117 | `smooth_iff_locally_free_omega` | `Smooth f ↔ ∀ x, ∃ U, ... Module.Free ... ∧ Module.rank ... = n` | **Compiles** (theorem, sorry) |
| 132 | `cotangent_at_section` | similar for pullback along a section | **Compiles** (theorem, sorry) |
| 153 | `serre_duality_genus` | equality of `Module.rank k (HModule ...)` | **Compiles** (theorem, sorry) |

## Mathlib API points consulted

- **`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`** (`Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf`): constructs the presheaf of Kähler differentials from a morphism of presheaves of rings. Used as the core of `relativeDifferentialsPresheaf`.
- **`TopCat.Presheaf.pullbackPushforwardAdjunction`**: adjunction `pullback ⊣ pushforward` for presheaves. Used to convert the scheme morphism's `f.c : S.presheaf ⟶ pushforward.obj X.presheaf` into the map `pullback.obj S.presheaf ⟶ X.presheaf` needed for `relativeDifferentials'`.
- **`CommRingCat.KaehlerDifferential`** (`Mathlib.Algebra.Category.ModuleCat.Differentials.Basic`): ring-level Kähler differential module in the bundled category setting.
- **`AlgebraicGeometry.Scheme.Modules`** and **`Scheme.PresheafOfModules`**: the project's target category for sheaves/presheaves of modules over a scheme.
- **`SheafOfModules.mk`**: constructor from a `PresheafOfModules` + sheaf condition to a `SheafOfModules` (i.e. `X.Modules`).
- **`AlgebraicGeometry.Smooth`** and **`LocallyOfFinitePresentation`**: morphism properties used in `smooth_iff_locally_free_omega`.
- **`ShortComplex.Exact`** and **`Epi`**: used to state the cotangent exact sequence.
- **`Module.Free`** and **`Module.rank`**: used to express local freeness of the sheaf of differentials.

## Modelling decisions

1. **Presheaf construction**: `relativeDifferentialsPresheaf` is defined directly via `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'` applied to the inverse-image presheaf of the structure sheaf. This is the mathematically correct construction (pullback of rings + Kähler differential).

2. **Sheaf upgrade**: `relativeDifferentials` uses `SheafOfModules.mk` with the sheaf condition stated as a separate theorem. This matches the standard `X.Modules` packaging.

3. **Universal derivation**: Expressed as a morphism of presheaves of abelian groups `X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶ (relativeDifferentials f).val.presheaf`. The sheaf-level upgrade follows from the presheaf morphism because both source and target are sheaves.

4. **Cotangent exact sequence**: Stated as an existence of morphisms `α` and `β` with `ShortComplex.Exact` and `Epi β`. This captures exactness at `Ω_{X/S}` and surjectivity `Ω_{X/S} → Ω_{X/Y}`.

5. **Smoothness theorem**: Uses `Smooth f` (not the deprecated `IsSmooth`) and states local freeness via `Module.Free` and `Module.rank` on sections over affine opens. `LocallyOfFinitePresentation` is used as a regular hypothesis.

6. **Serre duality**: The RHS uses a `sorry`-typed `Sheaf J (ModuleCat k)` placeholder because converting `C.left.Modules` to a sheaf of `k`-modules requires a restriction-of-scalars helper that does not yet exist in the project. A note in the docstring documents this gap.

## Compilation status

- `lake build AlgebraicJacobian.Differentials` — **success** (6 `sorry` warnings only).
- `lake build AlgebraicJacobian` — **success** (full project builds).
- New file LOC: ~165 lines.
- New `sorry` count: 6 (all in `Differentials.lean`).
- No new axioms.
- No deprecation warnings.

## Blueprint alignment

The following blueprint labels map to the Lean declarations:
- `def:relative_kaehler_presheaf` → `relativeDifferentialsPresheaf`
- `def:relative_kaehler_sheaf` → `relativeDifferentials`
- `def:universal_derivation` → `universalDerivation`
- `thm:cotangent_exact_sequence` → `cotangent_exact_sequence`
- `thm:smooth_iff_locally_free_omega` → `smooth_iff_locally_free_omega`
- `cor:cotangent_at_section` → `cotangent_at_section`
- `thm:serre_duality_genus` → `serre_duality_genus`

All declarations compile with `sorry` bodies and are ready for the `sync_leanok` script to mark `\leanok`.

## Recommendations for iter-065

1. **Close `relativeDifferentialsPresheaf_isSheaf`** — this is the first priority. The sheaf condition for Kähler differentials follows from localization compatibility. Mathlib may already have lemmas about `KaehlerDifferential` commuting with localization.

2. **Close `universalDerivation`** — `PresheafOfModules.DifferentialsConstruction.derivation'` already gives a `Derivation'` of the presheaf. Converting this to a morphism of abelian presheaves should be a matter of unpacking the `Derivation` structure.

3. **Define a `toModuleKSheaf`-like helper for general `O_C`-modules** — the gap in `serre_duality_genus` is that `relativeDifferentials C.hom : C.left.Modules` needs to be converted to `Sheaf J (ModuleCat k)`. This is the restriction-of-scalars along `k → O_C`. Defining this helper would unlock both the Serre duality statement and any future `k`-module cohomology of `O_C`-modules.

4. **Cotangent exact sequence and smoothness theorem** — these are substantial and depend on ring-level results in Mathlib (e.g. `Algebra.Generators.CotangentSpace.exact` and `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`). They should be attacked after the presheaf/sheaf infrastructure is solid.
