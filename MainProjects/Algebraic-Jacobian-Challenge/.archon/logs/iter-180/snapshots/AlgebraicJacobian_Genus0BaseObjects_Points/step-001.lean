/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus0BaseObjects.BareScheme
import AlgebraicJacobian.Genus0BaseObjects.ChartIso

/-!
# Genus-`0` base objects (Stratum 3): standard `k̄`-points on `ℙ¹`; `𝔾_a` and `𝔾_m`

This file is **Stratum 3** of the four-stratum split of the legacy
`AlgebraicJacobian.Genus0BaseObjects` (iter-175 refactor `g0bo-split`). It ships:

* the three standard `k̄`-points `0 = [0 : 1]`, `1 = [1 : 1]`, `∞ = [1 : 0]` of
  `ProjectiveLineBar kbar`, encoded as sections of `ProjectiveLineBar.hom`;
* the additive group `Ga` over `Spec k̄` (= `AffineSpace (Fin 1)`) and its
  affine, finite-presentation, and reduced instances;
* the multiplicative group `Gm` over `Spec k̄` (= `Spec k̄[t, t⁻¹]`) and its
  affine, finite-presentation, reduced, domain, and irreducible-space instances,
  plus the scaffold `GrpObj Gm` and the resulting `Smooth Gm.hom`;
* the multiplicative identity `Gm.onePt = η[Gm kbar]`.

Upstream strata: `BareScheme`, `ChartIso`. Downstream stratum: `GmScaling`.
-/

set_option autoImplicit false
set_option linter.style.setOption false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

noncomputable section

namespace AlgebraicGeometry

/-! ### The standard `k̄`-points `0`, `1`, `∞` on `ℙ¹`

The three distinguished `k̄`-points of `ℙ¹_{k̄}` are `[0 : 1]` (the affine origin), `[1 : 1]`
(the affine unit), and `[1 : 0]` (the point at infinity). They are encoded as morphisms
`𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`, i.e. sections of `ProjectiveLineBar.hom`.

The construction goes through `Proj.fromOfGlobalSections`: a `k̄`-point of `Proj 𝒜` is
specified by an evaluation ring map `MvPolynomial (Fin 2) kbar →+* k̄` (composed into
`Γ(Spec k̄, ⊤)` via `Scheme.ΓSpecIso`) whose image of the irrelevant ideal `(X₀, X₁)`
generates the unit ideal — automatic whenever the evaluation vector has a unit coordinate. -/

/-- **The underlying ring map of a `k̄`-point of `ℙ¹`.** Sends `X₀ ↦ v 0`, `X₁ ↦ v 1`,
then composes back into `Γ(Spec k̄, ⊤)` via the inverse of `Scheme.ΓSpecIso`. -/
private noncomputable def ProjectiveLineBar.evalIntoGlobal
    (kbar : Type u) [Field kbar] (v : Fin 2 → kbar) :
    MvPolynomial (Fin 2) kbar →+* Γ(Spec (.of kbar), ⊤) :=
  (Scheme.ΓSpecIso (.of kbar)).inv.hom.comp (MvPolynomial.eval v)

/-- **Irrelevant-ideal-maps-to-top condition** for `ProjectiveLineBar.evalIntoGlobal`: if one
of the coordinates `v 0` or `v 1` is a unit, then the image of `(X₀, X₁)` generates the
unit ideal in `Γ(Spec k̄, ⊤)`. -/
private lemma ProjectiveLineBar.irrelevant_map_eq_top
    (kbar : Type u) [Field kbar] (v : Fin 2 → kbar) (i : Fin 2) (hi : IsUnit (v i)) :
    Ideal.map (ProjectiveLineBar.evalIntoGlobal kbar v)
        (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal = ⊤ := by
  have hX_mem : (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ∈
      (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal :=
    HomogeneousIdeal.mem_irrelevant_of_mem _ Nat.zero_lt_one
      (MvPolynomial.isHomogeneous_X kbar i)
  have hImg_mem : ProjectiveLineBar.evalIntoGlobal kbar v (MvPolynomial.X i) ∈
      Ideal.map (ProjectiveLineBar.evalIntoGlobal kbar v)
        (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal :=
    Ideal.mem_map_of_mem _ hX_mem
  have hImg_unit : IsUnit (ProjectiveLineBar.evalIntoGlobal kbar v (MvPolynomial.X i)) := by
    unfold ProjectiveLineBar.evalIntoGlobal
    rw [RingHom.comp_apply, MvPolynomial.eval_X]
    exact hi.map _
  rw [Ideal.eq_top_iff_one]
  obtain ⟨u, hu⟩ := hImg_unit
  rw [show (1 : Γ(Spec (.of kbar), ⊤)) = ((u⁻¹ : Γ(Spec (.of kbar), ⊤)ˣ) : _) * u from
    (Units.inv_mul _).symm]
  exact Ideal.mul_mem_left _ _ (hu.symm ▸ hImg_mem)

/-- **Helper: construct a `k̄`-point of `ProjectiveLineBar kbar`** from an evaluation vector
`v : Fin 2 → kbar` with at least one unit coordinate. The underlying scheme map is
`Proj.fromOfGlobalSections` of the evaluation; the section condition chases through
`fromOfGlobalSections_toSpecZero` + `IsScalarTower kbar (𝒜 0) MvPoly` collapse to
`MvPolynomial.C` + `MvPolynomial.eval_C` + `toSpecΓ_SpecMap_ΓSpecIso_inv`. -/
private noncomputable def ProjectiveLineBar.pointOfVec
    (kbar : Type u) [Field kbar] (v : Fin 2 → kbar) (i : Fin 2) (hi : IsUnit (v i)) :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  Over.homMk
    (Proj.fromOfGlobalSections (projectiveLineBarGrading kbar)
      (ProjectiveLineBar.evalIntoGlobal kbar v)
      (ProjectiveLineBar.irrelevant_map_eq_top kbar v i hi)) <| by
    -- Section condition: fromOfGlobalSections ≫ ProjectiveLineBar.hom = 𝟙.
    haveI : IsScalarTower kbar ↥(projectiveLineBarGrading kbar 0)
        (MvPolynomial (Fin 2) kbar) :=
      IsScalarTower.of_algebraMap_eq fun _ => rfl
    -- Expose the structure morphism's composition shape.
    change Proj.fromOfGlobalSections _ _ _ ≫ Proj.toSpecZero _ ≫ Spec.map _ = _
    -- Combine via `fromOfGlobalSections_toSpecZero`, then unify the two Spec.maps.
    rw [← Category.assoc, Proj.fromOfGlobalSections_toSpecZero, Category.assoc,
      ← Spec.map_comp, ← CommRingCat.ofHom_comp, RingHom.comp_assoc,
      ← IsScalarTower.algebraMap_eq kbar, MvPolynomial.algebraMap_eq]
    -- The inner composition `(evalIntoGlobal v) ∘ C` collapses to `(ΓSpecIso).inv.hom`.
    -- Build a CommRingCat-level equation, then apply `Spec.map` and finish.
    have hcc : CommRingCat.ofHom
        ((ProjectiveLineBar.evalIntoGlobal kbar v).comp MvPolynomial.C) =
        (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv := by
      apply CommRingCat.hom_ext
      ext r
      change (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom
          ((MvPolynomial.eval v) (MvPolynomial.C r)) = _
      rw [MvPolynomial.eval_C]
    calc _ = (Spec (CommRingCat.of kbar)).toSpecΓ ≫
            Spec.map (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv := by
            exact congrArg _ (congrArg Spec.map hcc)
      _ = _ := AlgebraicGeometry.toSpecΓ_SpecMap_ΓSpecIso_inv _

/-- The `k̄`-point `0 = [0 : 1] ∈ ℙ¹`, encoded as a section of `ProjectiveLineBar.hom` via
`Proj.fromOfGlobalSections` of the evaluation `X₀ ↦ 0`, `X₁ ↦ 1`. -/
noncomputable def ProjectiveLineBar.zeroPt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  ProjectiveLineBar.pointOfVec kbar (fun i => if i = 0 then 0 else 1) 1 (by simp)

/-- The `k̄`-point `1 = [1 : 1] ∈ ℙ¹`, encoded as a section via the evaluation
`X₀ ↦ 1`, `X₁ ↦ 1`. -/
noncomputable def ProjectiveLineBar.onePt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  ProjectiveLineBar.pointOfVec kbar (fun _ => 1) 0 (by simp)

/-- The `k̄`-point `∞ = [1 : 0] ∈ ℙ¹`, encoded as a section via the evaluation
`X₀ ↦ 1`, `X₁ ↦ 0`. -/
noncomputable def ProjectiveLineBar.inftyPt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  ProjectiveLineBar.pointOfVec kbar (fun i => if i = 0 then 1 else 0) 0 (by simp)

/-! ### (B) The additive group `𝔾_a` over `Spec k̄` -/

/-- **The additive group `𝔾_a = 𝔸¹` over `Spec k̄` as an underlying scheme.** This is the
affine line `AffineSpace (Fin 1) (Spec (.of kbar))`. It is affine, locally of finite
presentation, and reduced (its global sections are `MvPolynomial (Fin 1) k̄`, a domain). -/
def GaScheme (kbar : Type u) [Field kbar] : Scheme :=
  AffineSpace.{0, u} (Fin 1) (Spec (.of kbar))

/-- The natural `Over (Spec (.of kbar))` instance on `GaScheme` (via
`AlgebraicGeometry.AffineSpace.over`). -/
instance gaScheme_canOver (kbar : Type u) [Field kbar] :
    (GaScheme kbar).Over (Spec (.of kbar)) :=
  inferInstanceAs ((AffineSpace.{0, u} (Fin 1) (Spec (.of kbar))).Over (Spec (.of kbar)))

/-- **The additive group object `𝔾_a` over `Spec k̄` as an object of
`Over (Spec (.of kbar))`.** -/
abbrev Ga (kbar : Type u) [Field kbar] : Over (Spec (.of kbar)) :=
  (GaScheme kbar).asOver (Spec (.of kbar))

/-- **`𝔾_a` is an affine morphism over `Spec k̄`.** FREE from
`AlgebraicGeometry.AffineSpace.instIsAffineHomOverSchemeInferInstanceOverClass`. -/
instance ga_isAffineHom (kbar : Type u) [Field kbar] :
    IsAffineHom (Ga kbar).hom :=
  inferInstanceAs (IsAffineHom (AffineSpace.{0, u} (Fin 1) (Spec (.of kbar)) ↘
    (Spec (.of kbar))))

/-- **`𝔾_a` is locally of finite presentation over `Spec k̄`.** FREE from
`AffineSpace.instLocallyOfFinitePresentation…OfFinite` (the index `Fin 1` is finite). -/
instance ga_locallyOfFinitePresentation (kbar : Type u) [Field kbar] :
    LocallyOfFinitePresentation (Ga kbar).hom :=
  inferInstanceAs (LocallyOfFinitePresentation
    (AffineSpace.{0, u} (Fin 1) (Spec (.of kbar)) ↘ Spec (.of kbar)))

/-- **`𝔾_a`'s underlying scheme is reduced.** Since the global sections are
`MvPolynomial (Fin 1) k̄`, a domain over a field, the affine scheme is reduced. The proof
transfers `IsReduced (Spec (.of (MvPolynomial _ _)))` (free for any reduced ring) across
`AffineSpace.isoOfIsAffine`. -/
instance ga_isReduced (kbar : Type u) [Field kbar] : IsReduced (Ga kbar).left :=
  isReduced_of_isOpenImmersion (AffineSpace.isoOfIsAffine (Fin 1) _).hom

/-! ### (C) The multiplicative group `𝔾_m` over `Spec k̄` -/

/-- **The ring `k̄[t, t⁻¹] = Localization.Away t`**, where `t = X () : MvPolynomial Unit k̄`.
This is the global-sections ring of `𝔾_m`. -/
abbrev GmRing (kbar : Type u) [Field kbar] : Type u :=
  Localization.Away (MvPolynomial.X () : MvPolynomial Unit kbar)

/-- **The multiplicative group `𝔾_m = Spec k̄[t, t⁻¹]` as an underlying scheme.** This is
the chosen affine encoding (the analogist `gm-scaling-p1` D2.b verdict: AFFINE `Spec`, NOT
the basic-open of `𝔸¹` — the latter loses `IsAffine`). -/
def GmScheme (kbar : Type u) [Field kbar] : Scheme :=
  Spec (CommRingCat.of (GmRing kbar))

/-- The natural `Over (Spec (.of kbar))` instance on `GmScheme`. -/
instance gmScheme_canOver (kbar : Type u) [Field kbar] :
    (GmScheme kbar).Over (Spec (.of kbar)) where
  hom := Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))

/-- **The multiplicative group object `𝔾_m` over `Spec k̄` as an object of
`Over (Spec (.of kbar))`.** -/
abbrev Gm (kbar : Type u) [Field kbar] : Over (Spec (.of kbar)) :=
  (GmScheme kbar).asOver (Spec (.of kbar))

/-- **`𝔾_m` is affine.** -/
instance gm_isAffine (kbar : Type u) [Field kbar] : IsAffine (Gm kbar).left :=
  inferInstanceAs (IsAffine (Spec (CommRingCat.of (GmRing kbar))))

/-- **`𝔾_m` is locally of finite presentation over `Spec k̄`.** Follows from
`Algebra.FinitePresentation k̄ (k̄[t, t⁻¹])` (a localization of a polynomial ring at a single
element is finitely presented), bridged through
`AlgebraicGeometry.HasRingHomProperty.Spec_iff` for the `LocallyOfFinitePresentation` /
`RingHom.FinitePresentation` correspondence. -/
instance gm_locallyOfFinitePresentation (kbar : Type u) [Field kbar] :
    LocallyOfFinitePresentation (Gm kbar).hom :=
  (HasRingHomProperty.Spec_iff (P := @LocallyOfFinitePresentation)).mpr
    ((RingHom.finitePresentation_algebraMap (B := GmRing kbar)).mpr
      inferInstance)

/-- **`𝔾_m`'s underlying scheme is reduced.** `k̄[t, t⁻¹]` is a localization of a domain at
a non-zero-divisor, hence a domain, hence reduced. The `IsReduced (Spec _)` instance picks
up directly from `IsReduced (Localization.Away _)`. -/
instance gm_isReduced (kbar : Type u) [Field kbar] : IsReduced (Gm kbar).left :=
  inferInstanceAs (IsReduced (Spec (CommRingCat.of (GmRing kbar))))

/-- **`k̄[t, t⁻¹]` is an integral domain.** Localization of the integral polynomial ring
`MvPolynomial Unit k̄` at the powers of a nonzero element `X () ≠ 0` preserves the domain
property (`IsLocalization.isDomain_localization` applied to
`Submonoid.powers (X ()) ≤ nonZeroDivisors`, the latter from `MvPolynomial.X_ne_zero`).

Load-bearing for `gm_irreducibleSpace` and `gm_geomIrred`. -/
instance gmRing_isDomain (kbar : Type u) [Field kbar] : IsDomain (GmRing kbar) := by
  unfold GmRing
  exact IsLocalization.isDomain_localization
    (powers_le_nonZeroDivisors_of_noZeroDivisors (MvPolynomial.X_ne_zero _))

/-- **`𝔾_m`'s underlying scheme is irreducible.** Follows from the fact that the
global-sections ring `GmRing = k̄[t, t⁻¹]` is an integral domain (`gmRing_isDomain`)
together with Mathlib's `Spec` of a domain being irreducible
(`PrimeSpectrum.irreducibleSpace`). -/
instance gm_irreducibleSpace (kbar : Type u) [Field kbar] :
    IrreducibleSpace (Gm kbar).left := by
  change IrreducibleSpace (Spec (CommRingCat.of (GmRing kbar)))
  infer_instance

/-! ### `gm_grpObj` — `GrpObj` instance on `𝔾_m` via `ofRepresentableBy`

The route is per the iter-179 `gm-grpobj-representable` analogy (8-step recipe).

Step A: build the units-of-global-sections functor `gmHomFunctor : (Over (Spec k̄))ᵒᵖ ⥤ GrpCat`,
which sends `T ↦ Γ(T.left, ⊤)ˣ`. This is the presheaf of groups that `Gm` represents.

Step B: build the `RepresentableBy` witness asserting `Hom(-, Gm) ≃ Γ(-, ⊤)ˣ` naturally.
The per-`T` bijection is the 3-step chain (over-cat unfold → Γ-Spec adjunction →
`IsLocalization.Away.lift` universal property of `k̄[t, t⁻¹]`).

Step C: `gm_grpObj := GrpObj.ofRepresentableBy (Gm kbar) gmHomFunctor _`. -/

/-- The `(Over (Spec k̄))ᵒᵖ ⥤ GrpCat.{u}` functor of units of global sections.
This is the presheaf of groups that `Gm` represents. -/
private noncomputable def gmHomFunctor (kbar : Type u) [Field kbar] :
    (Over (Spec (.of kbar)))ᵒᵖ ⥤ GrpCat.{u} where
  obj T := GrpCat.of (Γ(T.unop.left, ⊤))ˣ
  map {_ _} φ := GrpCat.ofHom (Units.map (φ.unop.left.appTop).hom.toMonoidHom)
  map_id := by
    intro T
    apply GrpCat.hom_ext
    apply MonoidHom.ext
    intro u
    apply Units.ext
    show ((𝟙 T.unop : T.unop ⟶ T.unop).left.appTop).hom u.val = u.val
    rw [Over.id_left]
    simp
  map_comp := by
    intros T T' T'' φ ψ
    apply GrpCat.hom_ext
    apply MonoidHom.ext
    intro u
    apply Units.ext
    show ((φ ≫ ψ).unop.left.appTop).hom u.val
      = ((ψ.unop.left.appTop).hom (((φ.unop.left.appTop).hom) u.val))
    rw [show (φ ≫ ψ).unop = ψ.unop ≫ φ.unop from rfl, Over.comp_left]
    simp [Scheme.comp_appTop]

/-- The `RepresentableBy` witness exhibiting `Gm kbar` as a representing object for the
units-of-global-sections functor. The per-`T` bijection
`(T ⟶ Gm) ≃ Γ(T.left, ⊤)ˣ` is the 3-step chain
(over-cat unfold → `ΓSpec.adjunction.homEquiv` → `IsLocalization.Away.lift`).

This is the substantive Mathlib-gap content: there is no `Spec(Localization.Away)`
analogue of `AffineSpace.homOverEquiv` in Mathlib (verified by the iter-179
`gm-grpobj-representable` analogy). PARTIAL: skeleton in place; the 3-step
`Equiv` composition and naturality remain. -/
private noncomputable def gmHomFunctor_representableBy (kbar : Type u) [Field kbar] :
    (gmHomFunctor kbar ⋙ forget _).RepresentableBy (Gm kbar) :=
  sorry

/-- **`GrpObj`-structure on `𝔾_m` via `ofRepresentableBy`.**

Installs the multiplicative-group structure on `Gm` using `GrpObj.ofRepresentableBy` with
the units functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`. The representable-by witness exploits the
fact that morphisms into `Spec (Localization.Away t)` correspond exactly to units in the
global sections (Mathlib's `IsLocalization.Away`-Spec bijection).

This `GrpObj Gm` is the LIVE consumer of the iter-166 `morphism_P1_to_grpScheme_const`
proof body (the `𝔾_m`-scaling shortcut applies `hom_additive_decomp_of_rigidity` with
`W = Gm`). -/
instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) :=
  GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) (gmHomFunctor_representableBy kbar)

/-- **`𝔾_m` is smooth over `Spec k̄`.** FREE from `smooth_of_grpObj_of_isAlgClosed` once
`GrpObj`, `LocallyOfFinitePresentation`, and `IsReduced` are installed. -/
instance gm_smooth (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    Smooth (Gm kbar).hom :=
  have : GrpObj (Over.mk (Gm kbar).hom) := gm_grpObj kbar
  smooth_of_grpObj_of_isAlgClosed (Gm kbar).hom

/-- The `k̄`-point `1 ∈ 𝔾_m` (the multiplicative identity), encoded as the group-object
unit `η[Gm kbar] : 𝟙_ ⟶ Gm kbar`. -/
def Gm.onePt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ Gm kbar :=
  η[Gm kbar]

end AlgebraicGeometry

end
