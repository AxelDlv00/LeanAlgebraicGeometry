/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.Morphisms.FinitePresentation
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf
import Mathlib.Algebra.Category.ModuleCat.Sheaf
import Mathlib.AlgebraicGeometry.Modules.Presheaf
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

/-! # Relative Kähler differentials for schemes

This file constructs the sheaf of relative Kähler differentials `Ω_{X/S}`
of a morphism of schemes `f : X → S`, together with its universal derivation
`d : 𝒪_X → Ω_{X/S}`. It also states the cotangent exact sequence and the
characterisation of smoothness in terms of local freeness of `Ω`.

The construction builds on Mathlib's ring-theoretic `KaehlerDifferential`
and the presheaf-of-modules differential construction
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`.

## Status (iteration 064 — scaffold)

All main declarations have `sorry` bodies. Closure trajectory is estimated
at ~10 iterations per `STRATEGY.md`.

## References

Blueprint: `blueprint/src/chapters/Differentials.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

variable {X Y S : Scheme.{u}}

/-! ## The relative cotangent presheaf and sheaf -/

/-- The relative cotangent **presheaf** of a morphism of schemes `f : X ⟶ S`.

On each open `U ⊆ X`, the sections are the Kähler differential module of
the ring map `O_S(f(U)) → O_X(U)` induced by `f`. More precisely, we use
the inverse-image presheaf `f⁻¹ O_S` on `X` and the canonical map to `O_X`;
the Kähler differential construction then gives a presheaf of `O_X`-modules.

Mathlib leverage: `TopCat.Presheaf.pullback` for `f⁻¹`,
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
for the presheaf of Kähler differentials. -/
noncomputable def relativeDifferentialsPresheaf (f : X ⟶ S) : X.PresheafOfModules :=
  let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
    f.c
  PresheafOfModules.DifferentialsConstruction.relativeDifferentials' φ'

/-! ### Sheaf condition: decomposition

Closing `relativeDifferentialsPresheaf_isSheaf` is the main outstanding
gap of Phase B step 1. The mathematical proof has three layers:

1. **`KaehlerDifferential` commutes with localisation.** For a ring map
   `A → B` and `f ∈ B`, `Ω_{B[1/f]/A} ≅ Ω_{B/A} ⊗_B B[1/f]`. Mathlib's
   `KaehlerDifferential.isLocalizedModule` (and the scheme variant
   `KaehlerDifferential.isLocalizedModule_map`) provides this.
2. **The presheaf is a sheaf on the basis of affine basic opens.** On a
   basic open `D(f)` of `Spec B`, sections are `Ω_{B[1/f]/A}`. Gluing on a
   basic-open cover `{D(fᵢ)}` of `Spec B` follows from the localisation
   compatibility of step 1, applied to each `fᵢ`.
3. **Globalisation to all opens.** A presheaf on a scheme is a sheaf iff
   it is a sheaf on the basis of affine opens (more precisely, on the
   basic opens of every affine open). This is the standard scheme
   sheaf-of-modules construction.

The substep theorems below are the natural decomposition. Each remains
`sorry` pending the full proof; the structure mirrors the blueprint at
`blueprint/src/chapters/Differentials.tex`. -/

/-- Substep 1 (localisation compatibility): For an affine open `V` of `X`
mapped to an affine open `U` of `S`, the sections of
`relativeDifferentialsPresheaf` over `V` are isomorphic (as additive groups)
to the Kähler differential module `KaehlerDifferential (φ'.app (op V))`. -/
theorem relativeDifferentialsPresheaf_obj_kaehler (f : X ⟶ S)
    (V : (TopologicalSpace.Opens X.toTopCat)ᵒᵖ) :
    ((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) =
      CommRingCat.KaehlerDifferential
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
          f.base).homEquiv _ _).symm f.c |>.app V) :=
  rfl

/-- The presheaf of relative differentials is a **sheaf** in the Zariski
topology: Kähler differentials commute with localisation, which gives the
gluing axiom on affine opens.

**Status (iter-065):** Sorry. Proof requires combining:
- Substep 1 (`relativeDifferentialsPresheaf_obj_kaehler`, definitional)
- Substep 2: sheaf condition on the basis of basic opens, derived from
  `KaehlerDifferential.isLocalizedModule`
- Substep 3: globalisation from a basis to all opens (Mathlib has
  `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` and `isSheafFor` lemmas
  for restricting to a basis)

The route via `SheafOfModules.IsQuasicoherent` is not viable since that
requires the result we are trying to prove (the presheaf must already be
a sheaf to be packaged as a `SheafOfModules`). -/
theorem relativeDifferentialsPresheaf_isSheaf (f : X ⟶ S) :
    Presheaf.IsSheaf (Opens.grothendieckTopology X.toTopCat)
      (relativeDifferentialsPresheaf f).presheaf := by
  -- Strategy: reduce to the underlying presheaf of types via
  -- `isSheaf_iff_isSheaf_comp`, then verify the sheaf condition on
  -- affine opens using `KaehlerDifferential.isLocalizedModule_map`.
  -- The proof requires substantial development of a
  -- "sheaf condition restricted to affine basis" lemma + the localisation
  -- compatibility for Kähler differentials in the scheme-language.
  sorry

/-- The sheaf of relative differentials `Ω_{X/S}`.

Packages the presheaf `relativeDifferentialsPresheaf` with the sheaf axiom
`relativeDifferentialsPresheaf_isSheaf` into the standard `X.Modules` shape. -/
noncomputable def relativeDifferentials (f : X ⟶ S) : X.Modules :=
  ⟨relativeDifferentialsPresheaf f, relativeDifferentialsPresheaf_isSheaf f⟩

/-! ## Universal derivation -/

/-- The universal derivation `d : 𝒪_X → Ω_{X/S}`.

On each affine open `V = Spec B` over `Spec A`, this is the Mathlib universal
derivation `d_{B/A} : B → Ω_{B/A}`. It is an `A`-linear sheaf map satisfying
the Leibniz rule `d(ab) = a d(b) + b d(a)`. -/
noncomputable def universalDerivation (f : X ⟶ S) :
    X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶
      (relativeDifferentials f).val.presheaf := by
  let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
    f.c
  let d' := PresheafOfModules.DifferentialsConstruction.derivation' φ'
  have h_eq : X.ringCatSheaf.presheaf = X.presheaf ⋙ forget₂ CommRingCat RingCat := rfl
  refine {
    app := fun U ↦ AddCommGrpCat.ofHom (d'.d (X := U)),
    naturality := fun U V g ↦ ?naturality
  }
  case naturality =>
    ext x
    simp only [sheafCompose_obj_obj, PresheafOfModules.presheaf_obj_coe, Functor.comp_obj,
      CommRingCat.forgetToRingCat_obj, Functor.comp_map, AddCommGrpCat.hom_comp]
    suffices d'.d ((ConcreteCategory.hom (X.presheaf.map g)) x) =
        (ConcreteCategory.hom ((relativeDifferentialsPresheaf f).map g)) (d'.d x) by
      simpa using this
    exact d'.d_map g x

/-! ## Cotangent exact sequence

The cotangent exact sequence
```
  f^* Ω_{Y/S} ⟶ Ω_{X/S} ⟶ Ω_{X/Y} ⟶ 0
```
for a composition `X ⟶ Y ⟶ S` is decomposed into five named sub-claims:

1. `cotangentExactSeqAlpha` — the base-change cotangent map
   `f^* Ω_{Y/S} ⟶ Ω_{X/S}`. Locally, this is
   `KaehlerDifferential.mapBaseChange A A' B`, where `A → A' → B` is the
   tower of structure ring maps on an affine chart.
2. `cotangentExactSeqBeta` — the relative-quotient cotangent map
   `Ω_{X/S} ⟶ Ω_{X/Y}`. Locally, this is the surjection
   `KaehlerDifferential.map A A' B B` induced by the inclusion `A → A'`
   that kills the `A`-linear derivations factoring through `A'`.
3. `cotangentExactSeqAlpha_comp_Beta` — composition zero `α ≫ β = 0`,
   from the ring-level `KaehlerDifferential.exact_mapBaseChange_map` (the
   range of `mapBaseChange` lies in the kernel of `map`).
4. `cotangentExactSeqShortComplexExact` — exactness `ker β = im α`,
   from the same ring-level theorem and gluing.
5. `cotangentExactSeqBetaEpi` — `β` is an epi, from
   `KaehlerDifferential.map_surjective` applied on each affine chart.

The headline theorem `cotangent_exact_sequence` then assembles the
existential bundle from these five components without further sorries. -/

/-- The base-change cotangent map `f^* Ω_{Y/S} ⟶ Ω_{X/S}`.

For a composition `X ⟶ Y ⟶ S`, this is the natural map whose local
description on an affine chart with rings `A = O_S(W)`, `A' = O_Y(f(V))`,
`B = O_X(V)` is `KaehlerDifferential.mapBaseChange A A' B`:
```
  Ω_{A'/A} ⊗_{A'} B ⟶ Ω_{B/A}
```
sending `da ⊗ b ↦ b · da` (where the right-hand `da` is the universal
derivation in `Ω_{B/A}`).

**Status:** sorry — the global construction requires gluing the local
base-change maps, mediated by `PresheafOfModules.homMk` applied to the
ring-level `KaehlerDifferential.mapBaseChange`. -/
noncomputable def cotangentExactSeqAlpha (f : X ⟶ Y) (g : Y ⟶ S) :
    (Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶
      relativeDifferentials (f ≫ g) := sorry

/-- The relative-quotient cotangent map `Ω_{X/S} ⟶ Ω_{X/Y}`.

For a composition `X ⟶ Y ⟶ S`, this is the natural surjection whose
local description on an affine chart with rings `A = O_S(W)`,
`A' = O_Y(f(V))`, `B = O_X(V)` is `KaehlerDifferential.map A A' B B`:
```
  Ω_{B/A} ⟶ Ω_{B/A'}
```
sending the universal `A`-linear derivation to the universal `A'`-linear
derivation.

**Status:** sorry — the global construction follows from the morphism of
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
induced by the natural transformation `(f ≫ g)⁻¹ O_S ⟶ f⁻¹ O_Y` between
the pullback ring presheaves. -/
noncomputable def cotangentExactSeqBeta (f : X ⟶ Y) (g : Y ⟶ S) :
    relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f := sorry

/-- The composition `α ≫ β = 0` of the two cotangent maps.

On each affine chart `A → A' → B`, this is the statement that
`KaehlerDifferential.mapBaseChange A A' B ≫ KaehlerDifferential.map A A' B B = 0`,
which follows directly from `KaehlerDifferential.exact_mapBaseChange_map`
(the range of the first map is contained in the kernel of the second).

**Status:** sorry — should reduce to the ring-level exactness lemma
once `cotangentExactSeqAlpha` and `cotangentExactSeqBeta` are constructed. -/
lemma cotangentExactSeqAlpha_comp_Beta (f : X ⟶ Y) (g : Y ⟶ S) :
    cotangentExactSeqAlpha f g ≫ cotangentExactSeqBeta f g = 0 := sorry

/-- Exactness of the cotangent short complex
`f^* Ω_{Y/S} → Ω_{X/S} → Ω_{X/Y}` at the middle term.

On each affine chart, this is `KaehlerDifferential.exact_mapBaseChange_map`:
```
  Function.Exact (KaehlerDifferential.mapBaseChange R A B)
                 (KaehlerDifferential.map R A B B)
```
The scheme-level statement glues these exact sequences via the
quasi-coherence of all three sheaves.

**Status:** sorry — uses the ring-level Mathlib exactness plus an
"exactness is a local property" gluing argument. -/
lemma cotangentExactSeqShortComplexExact (f : X ⟶ Y) (g : Y ⟶ S) :
    (CategoryTheory.ShortComplex.mk
      (cotangentExactSeqAlpha f g) (cotangentExactSeqBeta f g)
      (cotangentExactSeqAlpha_comp_Beta f g)).Exact := sorry

/-- The map `β : Ω_{X/S} ⟶ Ω_{X/Y}` is an epi.

On each affine chart `A → A' → B`, this is
`KaehlerDifferential.map_surjective R S B`, which says the natural map
`Ω_{B/R} → Ω_{B/S}` is surjective for any tower `R → S → B`.

**Status:** sorry — uses the ring-level Mathlib surjectivity plus
"epi is a local property for sheaves of modules". -/
lemma cotangentExactSeqBetaEpi (f : X ⟶ Y) (g : Y ⟶ S) :
    CategoryTheory.Epi (cotangentExactSeqBeta f g) := sorry

/-- Cotangent exact sequence for a composition of schemes `X ⟶ Y ⟶ S`.

For `f : X ⟶ Y` and `g : Y ⟶ S`, there is an exact sequence of
quasi-coherent `𝒪_X`-modules
```
  f^* Ω_{Y/S} ⟶ Ω_{X/S} ⟶ Ω_{X/Y} ⟶ 0.
```
Built on affine charts from the Mathlib ring-level cotangent exact
sequence (`KaehlerDifferential.exact_mapBaseChange_map`) and glued via the
compatibility above.

The five sub-claims `cotangentExactSeqAlpha`, `cotangentExactSeqBeta`,
`cotangentExactSeqAlpha_comp_Beta`, `cotangentExactSeqShortComplexExact`,
and `cotangentExactSeqBetaEpi` carry the remaining sorries; this theorem
itself is closed by assembling them.

The composition-zero proof obligation is now an explicit existential
witness rather than an in-type `by sorry`, eliminating the iter-064/065
nested `by sorry` placeholder inside `ShortComplex.mk`. -/
theorem cotangent_exact_sequence (f : X ⟶ Y) (g : Y ⟶ S) :
    ∃ (α : (Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶
        relativeDifferentials (f ≫ g))
      (β : relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f)
      (h : α ≫ β = 0),
      CategoryTheory.ShortComplex.Exact
        (CategoryTheory.ShortComplex.mk α β h) ∧
      CategoryTheory.Epi β :=
  ⟨cotangentExactSeqAlpha f g, cotangentExactSeqBeta f g,
    cotangentExactSeqAlpha_comp_Beta f g,
    cotangentExactSeqShortComplexExact f g, cotangentExactSeqBetaEpi f g⟩

/-! ## Smoothness and local freeness of `Ω` -/

/-- Smoothness of a finite-presentation morphism is equivalent to `Ω_{X/S}`
being locally free of the given rank.

The forward direction is the Jacobian criterion; the converse follows from
the cotangent exact sequence and Nakayama's lemma applied at each point. -/
theorem smooth_iff_locally_free_omega (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
    Smooth f ↔
      ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentials f).val.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry

/-! ## Cotangent space at a section -/

/-- If `f : X ⟶ S` is smooth and `s : S ⟶ X` is a section of `f`, then the
cotangent space `s^* Ω_{X/S}` is a locally free `𝒪_S`-module of rank `n`.
In particular, if `S = Spec k` and `X` is smooth of relative dimension `n`,
the cotangent space at the corresponding `k`-point is an `n`-dimensional
`k`-vector space. -/
theorem cotangent_at_section (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f)
    (s : S ⟶ X) (hs : s ≫ f = 𝟙 S) (n : ℕ)
    (hsmooth : Smooth f) :
    ∀ (x : S), ∃ (U : S.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
      let R := S.ringCatSheaf.presheaf.obj (.op U)
      let M := ((Scheme.Modules.pullback s).obj (relativeDifferentials f)).val.obj (.op U)
      Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry

/-! ## Restriction of scalars to k-modules -/

/-- The `O_C(U)`-module structure on `M(U)` viewed as a `k`-module via
restriction of scalars along the algebra map `k → O_C(U)`. -/
noncomputable abbrev moduleKPresheafOfModules_obj
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) : ModuleCat.{u} k :=
  (ModuleCat.restrictScalars (toModuleKSheaf.kToSection C U).hom).obj (M.val.obj U)

/-- Smul-naturality lemma for `moduleKPresheafOfModules`: the additive map
`M.val.presheaf.map f` commutes with the `k`-action on source and target after
restriction of scalars. -/
lemma moduleKPresheafOfModules_smul_compat
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) (r : k) :
    M.val.presheaf.map f ≫ (moduleKPresheafOfModules_obj C M V).smul r =
      (moduleKPresheafOfModules_obj C M U).smul r ≫ M.val.presheaf.map f := by
  -- Strategy: lift to ModuleCat.smul_naturality applied to (M.val.map f) over O_C, then transport
  -- the smul argument from `(kToSection C U).hom r` to `(kToSection C V).hom r` using algebraMap
  -- naturality.
  have hsmul_src : (moduleKPresheafOfModules_obj C M U).smul r =
      (M.val.obj U).smul ((toModuleKSheaf.kToSection C U).hom r) := rfl
  have hsmul_tgt : (moduleKPresheafOfModules_obj C M V).smul r =
      (M.val.obj V).smul ((toModuleKSheaf.kToSection C V).hom r) := rfl
  rw [hsmul_src, hsmul_tgt]
  -- Now goal:
  --   M.val.presheaf.map f ≫ (M.val.obj V).smul (kV r)
  --     = (M.val.obj U).smul (kU r) ≫ M.val.presheaf.map f
  have hpres : M.val.presheaf.map f =
      (CategoryTheory.forget₂ (ModuleCat _) AddCommGrpCat).map (M.val.map f) := by
    apply AddCommGrpCat.Hom.ext
    ext x
    exact PresheafOfModules.presheaf_map_apply_coe M.val f x
  rw [hpres]
  -- Now goal in terms of (forget₂).map (M.val.map f); use ModuleCat.smul_naturality:
  have hnat := ModuleCat.smul_naturality (M.val.map f) ((toModuleKSheaf.kToSection C U).hom r)
  -- hnat has smul on the *target* of (M.val.map f) at index (kU r).
  -- That target is (restrictScalars (R.map f).hom).obj (M.val.obj V), so its .smul (kU r)
  -- is definitionally (M.val.obj V).smul ((R.map f).hom (kU r)).
  -- By algebraMap_naturality, (R.map f).hom (kU r) = (kV r), which is what we need.
  have halg : (RingCat.Hom.hom (C.left.ringCatSheaf.obj.map f))
        ((toModuleKSheaf.kToSection C U).hom r) =
      (toModuleKSheaf.kToSection C V).hom r := by
    rw [← toModuleKSheaf.algebraMap_eq_kToSection, ← toModuleKSheaf.algebraMap_eq_kToSection]
    exact toModuleKSheaf.algebraMap_naturality (C := C) f r
  -- Convert hnat's target smul to the desired form via halg
  have htarget : ((ModuleCat.restrictScalars
        (RingCat.Hom.hom (C.left.ringCatSheaf.obj.map f))).obj (M.val.obj V)).smul
        ((toModuleKSheaf.kToSection C U).hom r) =
      (M.val.obj V).smul ((toModuleKSheaf.kToSection C V).hom r) := by
    change (M.val.obj V).smul ((RingCat.Hom.hom (C.left.ringCatSheaf.obj.map f))
        ((toModuleKSheaf.kToSection C U).hom r)) =
      (M.val.obj V).smul ((toModuleKSheaf.kToSection C V).hom r)
    rw [halg]
  rw [htarget] at hnat
  exact hnat

/-- The restriction map for `moduleKPresheafOfModules`, extracted as a separate
definition so the elaborator does not have to inline the smul-naturality proof
inside the main `Functor` definition. -/
noncomputable def moduleKPresheafOfModules_map
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    moduleKPresheafOfModules_obj C M U ⟶ moduleKPresheafOfModules_obj C M V :=
  ModuleCat.homMk (M.val.presheaf.map f) (moduleKPresheafOfModules_smul_compat C M f)

@[simp] lemma moduleKPresheafOfModules_map_forget₂
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    (CategoryTheory.forget₂ (ModuleCat k) AddCommGrpCat).map
        (moduleKPresheafOfModules_map C M f) = M.val.presheaf.map f := by
  unfold moduleKPresheafOfModules_map
  exact ModuleCat.forget₂_map_homMk _ _

/-- The presheaf of `k`-modules obtained from an `O_C`-module by restriction of
scalars along the structure morphism `k → Γ(C, U)`.

On each open `U`, the sections are the `O_C(U)`-module `M(U)` viewed as a
`k`-module via the algebra map `k → O_C(U)`. The restriction maps are `k`-linear
by the naturality of this algebra map. -/
noncomputable def moduleKPresheafOfModules
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := moduleKPresheafOfModules_obj C M U
  map f := moduleKPresheafOfModules_map C M f
  map_id U := by
    apply (CategoryTheory.forget₂ (ModuleCat k) AddCommGrpCat).map_injective
    rw [moduleKPresheafOfModules_map_forget₂, CategoryTheory.Functor.map_id]
    exact M.val.presheaf.map_id U
  map_comp {U V W} f g := by
    apply (CategoryTheory.forget₂ (ModuleCat k) AddCommGrpCat).map_injective
    rw [CategoryTheory.Functor.map_comp]
    simp only [moduleKPresheafOfModules_map_forget₂]
    exact M.val.presheaf.map_comp f g

/-- The presheaf of `k`-modules obtained by restriction of scalars is a sheaf:
its underlying presheaf of abelian groups coincides with that of the original
`O_C`-module. -/
lemma moduleKPresheafOfModules_isSheaf
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (moduleKPresheafOfModules C M) := by
  rw [Presheaf.isSheaf_iff_isSheaf_comp _ _ (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})]
  convert M.isSheaf using 1

/-- The sheaf of `k`-modules obtained from an `O_C`-module by restriction of
scalars along the structure morphism. -/
noncomputable def moduleKSheafOfModules
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k) :=
  ⟨moduleKPresheafOfModules C M, moduleKPresheafOfModules_isSheaf C M⟩

/-! ## Serre duality genus equality -/

/-- For a smooth proper geometrically irreducible curve `C` over a field `k`,
the dimension of `H^0(C, Ω_{C/k})` equals the dimension of `H^1(C, 𝒪_C)`,
and both equal the genus `g(C)`.

This is the dimension-one case of Serre duality applied to the canonical
sheaf `ω_C = Ω_{C/k}`. -/
theorem serre_duality_genus {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left] [IsProper C.hom]
    (hsmooth : Smooth C.hom) :
    Module.rank k (HModule k (toModuleKSheaf C) 0) =
      Module.rank k
        (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) := by
  sorry

end AlgebraicGeometry.Scheme
