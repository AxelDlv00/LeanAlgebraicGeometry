/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.CechAcyclic
import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.QcohTildeSections

/-!
# The augmented Čech complex is exact (blueprint `lem:cech_augmented_resolution`)

This file proves that the augmented Čech complex `cechAugmentedComplex 𝒰 F` is exact
(every homology object is the zero object in `X.Modules`) whenever `𝒰` is a finite
affine open cover of `X` with all pairwise intersections affine (ensured by separatedness
of `X`) and `F` is a quasi-coherent `O_X`-module.

The theorem is placed here rather than in `CechHigherDirectImage.lean` to avoid an import
cycle: every ingredient of the sections/sheafification proof route
(`PresheafOfModules.homologyIsoSheafify`, `sectionCech_homology_exact_of_localizationAway`,
`affineCoverSystem`, `qcoh_iso_tilde_sections`) lives in a file that transitively imports
`CechHigherDirectImage.lean`.  Placing `cechAugmented_exact` in this downstream file
(`CechAugmentedResolution.lean`) makes all those ingredients available without a cycle.
The pure-Mathlib site lemmas (`isZero_presheafToSheaf_obj_of_W`,
`isZero_presheafToSheaf_obj_of_W_isZero`, `isZero_presheafToSheaf_obj_of_isLocallyBijective`)
live in `CechHigherDirectImage.lean` and are importable here.

Blueprint: `lem:cech_augmented_resolution`.
Source: Stacks Project, Cohomology of Schemes,
  `lemma-cech-cohomology-quasi-coherent-trivial`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

/- Planner strategy:
Route: sections + sheafification (NOT stalks — `SheafOfModules.stalk` is absent from Mathlib).
Step 1: reflect `IsZero (homology p)` through the faithful additive forgetful functor
`SheafOfModules.toSheaf` (it preserves zero morphisms, so it reflects the zero object). Step 2:
the homology SHEAF = sheafification of the PRESHEAF homology, via the project engine
`PresheafOfModules.homologyIsoSheafify` (HigherDirectImagePresheaf.lean). Step 3: the presheaf
homology is `V ↦ Ȟᵖ(V,F)`, locally zero on the affine basis — over each basic affine `D(g) ⊆ Uᵢ`,
`qcoh_iso_tilde_sections` gives `F|_{D(g)} ≅ ~M` and
`sectionCech_homology_exact_of_localizationAway` (CechAcyclic.lean) kills positive-degree homology;
the basic affines are cofinal (`standard_cover_cofinal` / `affineCoverSystem`), so the map
`0 → presheaf-homology` is locally bijective, hence its sheafification (= the homology sheaf) is
zero. The reusable abelian-sheaf site lemmas `isZero_presheafToSheaf_obj_of_W` /`_of_W_isZero`/
`_of_isLocallyBijective` (in CechHigherDirectImage.lean, importable) discharge the site-theory half.
The ONE bridge to build here: connect the module-level `homologyIsoSheafify` to those abelian-sheaf
site lemmas via the sheafification square `toSheaf ∘ sheafification ≅ presheafToSheaf ∘ forget`
(cf. `PresheafOfModules.sheafificationCompToSheaf`, used in AffineSerreVanishing.lean; see
`analogies/tosheaf-epi.md` and the iter-053 mathlib-analogist report on the toSheaf-reflection
bridge). Diamond-prone — work with `.hom` not `.val`, defeq/`change` not `rw`. Step 4: the
degree-0 augmentation node uses the same spanning-family exactness (`exact_of_isLocalized_span` /
`combDifferential_exact`). Blueprint: `lem:cech_augmented_resolution`.
-/

/-- **The augmented Čech complex is a resolution** (Stacks
`lemma-cech-cohomology-quasi-coherent-trivial`; blueprint `lem:cech_augmented_resolution`).

Let `X` be a separated scheme, `𝒰` a finite open cover of `X` all of whose members are
affine (so every finite intersection `U_{i₀} ∩ ⋯ ∩ U_{iₚ}` is affine by separatedness),
and `F` a quasi-coherent `O_X`-module. Then every homology object of the augmented Čech
complex `cechAugmentedComplex 𝒰 F` is zero:
```
  ∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p).
```
Equivalently, the {\v C}ech nerve of `𝒰` is a resolution of `F` in `X.Modules`. -/
theorem cechAugmented_exact (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p) := by
  sorry

end AlgebraicGeometry
