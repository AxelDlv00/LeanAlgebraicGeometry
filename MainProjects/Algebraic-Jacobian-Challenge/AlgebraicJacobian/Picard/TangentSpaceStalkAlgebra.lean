/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TangentSpaceDualNumbers
import AlgebraicJacobian.Picard.TangentSpaceSchemePoints

/-!
# Tangent-space substrate: the stalk `k`-algebra layer (A.3.iii substrate)

For a scheme `X` over `Spec k` (`k` a field) with structure morphism
`f : X ⟶ Spec k`, the stalk `𝒪_{X,x}` at every point `x : X` is canonically a
`k`-algebra: the composite of the global-sections identification
`k ≅ Γ(Spec k)`, the germ map into the stalk of `Spec k` at `f x`, and the
stalk map of `f`. This threads the `k`-linear structure through the
scheme-level dual-number description of `Picard/TangentSpaceSchemePoints.lean`
and connects it to the local-algebra substrate of
`Picard/TangentSpaceDualNumbers.lean`.

## Main declarations

- `AlgebraicGeometry.stalkStructureHom` — the structure homomorphism
  `k ⟶ 𝒪_{X,x}` of a scheme over `Spec k`.
- `AlgebraicGeometry.stalkAlgebra` — the induced `k`-algebra structure on the
  stalk; installed as a scoped instance `overStalkAlgebra` for objects of
  `Over (Spec k)`.
- `AlgebraicGeometry.fromSpecStalk_comp_eq` — the canonical map
  `Spec 𝒪_{X,x} ⟶ X` followed by the structure morphism is
  `Spec` of the structure homomorphism.
- `AlgebraicGeometry.comp_eq_spec_iff_of_base_eq` — for `g : Spec S ⟶ X`
  (`S` local) landing at `x`, the over-`Spec k` triangle
  `g ≫ f = Spec ψ` holds iff the induced stalk map
  `𝒪_{X,x} ⟶ S` is compatible with the structure homomorphisms; proved at
  the `Spec.map` level via faithfulness of `Spec`.
- `AlgebraicGeometry.overDualNumberAtEquivAlgHom` — **the `k`-algebra
  refinement of the dual-number points**: morphisms
  `Spec k[ε] ⟶ X` *over `Spec k`* landing at `x` correspond to `k`-**algebra**
  homomorphisms `𝒪_{X,x} →ₐ[k] k[ε]` whose constant component kills the
  maximal ideal. (A plain ring homomorphism is *not* automatically `k`-linear
  — wild automorphisms of `k` — so the over-structure is essential.)
- `AlgebraicGeometry.overDualNumberAtEquivCotangentSpaceDual` — the capstone
  composition with `localDualNumberHomEquivCotangentSpaceDual`: at a
  `k`-rational point `x`, the over-`Spec k` dual-number points of `X` at `x`
  form the `κ(x)`-linear dual of the cotangent space `m_x/m_x²`. This is the
  geometric form of Kleiman §5 Thm. 5.11's tangent-space computation,
  awaiting only the `H¹` identification for `thm:pic0_tangent_space_iso`.

Blueprint: `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`,
§ `sec:pic0_tangent_space` (`def:tangent_stalk_algebra`,
`lem:tangent_from_spec_stalk_over`, `lem:tangent_over_triangle_iff`,
`cor:tangent_over_dual_number_alghom`,
`thm:tangent_over_dual_number_cotangent_dual`).
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory IsLocalRing

namespace AlgebraicGeometry

section StalkStructureHom

variable {k : Type u} [Field k] {X : Scheme.{u}}

/-- **The structure homomorphism into a stalk.** For a scheme `X` over
`Spec k` with structure morphism `f` and a point `x : X`, the canonical ring
homomorphism `k ⟶ 𝒪_{X,x}`: identify `k` with the global sections of
`Spec k`, take the germ at `f x`, and apply the stalk map of `f`. -/
noncomputable def stalkStructureHom (f : X ⟶ Spec (CommRingCat.of k)) (x : X) :
    CommRingCat.of k ⟶ X.presheaf.stalk x :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫
    (Spec (CommRingCat.of k)).presheaf.germ ⊤ (f x) trivial ≫ f.stalkMap x

/-- The `k`-algebra structure on the stalk `𝒪_{X,x}` of a scheme over
`Spec k`, induced by `stalkStructureHom`. Not a global instance: for objects
of `Over (Spec k)` it is installed as the scoped instance
`overStalkAlgebra`. -/
@[reducible] noncomputable def stalkAlgebra (f : X ⟶ Spec (CommRingCat.of k)) (x : X) :
    Algebra k (X.presheaf.stalk x) :=
  (stalkStructureHom f x).hom.toAlgebra

/-- The canonical map `Spec 𝒪_{X,x} ⟶ X` followed by the structure morphism
is `Spec` of the structure homomorphism. -/
lemma fromSpecStalk_comp_eq (f : X ⟶ Spec (CommRingCat.of k)) (x : X) :
    X.fromSpecStalk x ≫ f = Spec.map (stalkStructureHom f x) := by
  unfold stalkStructureHom
  rw [← Scheme.SpecMap_stalkMap_fromSpecStalk, Spec.fromSpecStalk_eq, ← Spec.map_comp,
    Category.assoc]

/-- **Over-`Spec k` triangles are structure-homomorphism compatibilities.**
For a local ring `S`, a morphism `g : Spec S ⟶ X` and any `ψ : k ⟶ S`, the
triangle `g ≫ f = Spec ψ` commutes iff the ring homomorphism
`𝒪_{X, g(𝔪)} ⟶ S` induced by `g` intertwines the structure homomorphisms.
Proved at the `Spec.map` level using that `Spec` is faithful. -/
lemma comp_eq_spec_iff {S : CommRingCat.{u}} [IsLocalRing S]
    (f : X ⟶ Spec (CommRingCat.of k)) (g : Spec S ⟶ X) (ψ : CommRingCat.of k ⟶ S) :
    g ≫ f = Spec.map ψ ↔
      stalkStructureHom f (g (closedPoint S)) ≫ Scheme.stalkClosedPointTo g = ψ := by
  constructor
  · intro h
    apply Spec.map_injective
    rw [Spec.map_comp, ← fromSpecStalk_comp_eq, ← Category.assoc,
      Scheme.Spec_stalkClosedPointTo_fromSpecStalk, h]
  · intro h
    rw [← h, Spec.map_comp, ← fromSpecStalk_comp_eq, ← Category.assoc,
      Scheme.Spec_stalkClosedPointTo_fromSpecStalk]

/-- Variant of `comp_eq_spec_iff` at a fixed point `x` with the stalk
transported along `g(𝔪) = x`, matching the stalk data produced by
`specToEquivOfLocalRingAt`. -/
lemma comp_eq_spec_iff_of_base_eq {S : CommRingCat.{u}} [IsLocalRing S]
    (f : X ⟶ Spec (CommRingCat.of k)) {g : Spec S ⟶ X} {x : X}
    (hx : g.base (closedPoint S) = x) (ψ : CommRingCat.of k ⟶ S) :
    g ≫ f = Spec.map ψ ↔
      stalkStructureHom f x ≫
        (X.presheaf.stalkCongr (Inseparable.of_eq hx.symm)).hom ≫
          Scheme.stalkClosedPointTo g = ψ := by
  subst hx
  have hcongr : (X.presheaf.stalkCongr (Inseparable.of_eq
      (rfl : g.base (closedPoint S) = g.base (closedPoint S)).symm)).hom = 𝟙 _ := by
    simp [TopCat.Presheaf.stalkCongr]
  rw [hcongr, Category.id_comp]
  exact comp_eq_spec_iff f g ψ

end StalkStructureHom

section OverStalkAlgebra

variable {k : Type u} [Field k]

/-- The canonical `k`-algebra structure on the stalks of a scheme over
`Spec k`, for objects of the over-category. Scoped: activated by
`open AlgebraicGeometry`. -/
noncomputable scoped instance overStalkAlgebra
    (X : Over (Spec (CommRingCat.of k))) (x : X.left) :
    Algebra k (X.left.presheaf.stalk x) :=
  stalkAlgebra X.hom x

lemma algebraMap_overStalkAlgebra
    (X : Over (Spec (CommRingCat.of k))) (x : X.left) (c : k) :
    algebraMap k (X.left.presheaf.stalk x) c = (stalkStructureHom X.hom x).hom c := rfl

open TrivSqZeroExt

/-- Step 3 of `overDualNumberAtEquivAlgHom`: ring homomorphisms out of the
stalk compatible with the structure homomorphisms are exactly the
`k`-algebra homomorphisms. -/
noncomputable def stalkHomCompatEquivAlgHom
    (X : Over (Spec (CommRingCat.of k))) (x : X.left) :
    {q : {φ : X.left.presheaf.stalk x ⟶ CommRingCat.of (DualNumber k) //
          ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ.hom a) = 0} //
        stalkStructureHom X.hom x ≫ q.1
          = CommRingCat.ofHom (algebraMap k (DualNumber k))}
      ≃ {φ : X.left.presheaf.stalk x →ₐ[k] DualNumber k //
          ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ a) = 0} where
  toFun q :=
    ⟨⟨q.1.1.hom, fun c => DFunLike.congr_fun (congrArg CommRingCat.Hom.hom q.2) c⟩, q.1.2⟩
  invFun φ :=
    ⟨⟨CommRingCat.ofHom φ.1.toRingHom, φ.2⟩,
      CommRingCat.hom_ext (RingHom.ext fun c => φ.1.commutes c)⟩
  left_inv _ := rfl
  right_inv _ := Subtype.ext (AlgHom.ext fun _ => rfl)

/-- **Over-`Spec k` dual-number points are local `k`-algebra homomorphisms.**
For a field `k`, a scheme `X` over `Spec k` and a point `x : X`, morphisms
`Spec k[ε] ⟶ X` *over `Spec k`* carrying the closed point to `x` correspond
to `k`-algebra homomorphisms `𝒪_{X,x} →ₐ[k] k[ε]` whose constant component
kills the maximal ideal — the interface consumed by
`localDualNumberHomEquivCotangentSpaceDual`. The over-structure is what makes
the stalk data `k`-linear; a bare ring homomorphism need not be. -/
noncomputable def overDualNumberAtEquivAlgHom
    (X : Over (Spec (CommRingCat.of k))) (x : X.left) :
    {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
        g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
          ∧ g.base (closedPoint (DualNumber k)) = x} ≃
      {φ : X.left.presheaf.stalk x →ₐ[k] DualNumber k //
        ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ a) = 0} :=
  calc {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
        g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
          ∧ g.base (closedPoint (DualNumber k)) = x}
      ≃ {p : {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
            g.base (closedPoint (DualNumber k)) = x} //
          p.1 ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))} :=
        { toFun := fun g => ⟨⟨g.1, g.2.2⟩, g.2.1⟩
          invFun := fun p => ⟨p.1.1, p.2, p.1.2⟩
          left_inv := fun _ => rfl
          right_inv := fun _ => rfl }
    _ ≃ {q : {φ : X.left.presheaf.stalk x ⟶ CommRingCat.of (DualNumber k) //
            ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ.hom a) = 0} //
          stalkStructureHom X.hom x ≫ q.1
            = CommRingCat.ofHom (algebraMap k (DualNumber k))} :=
        (specDualNumberAtEquiv X.left x).subtypeEquiv fun p =>
          comp_eq_spec_iff_of_base_eq X.hom p.2 _
    _ ≃ {φ : X.left.presheaf.stalk x →ₐ[k] DualNumber k //
          ∀ a ∈ maximalIdeal (X.left.presheaf.stalk x), fst (φ a) = 0} :=
        stalkHomCompatEquivAlgHom X x

/-- **The tangent space of a `k`-scheme at a rational point** (Kleiman §5
Thm. 5.11, geometric form): for a scheme `X` over `Spec k` and a `k`-rational
point `x` (the residue map `k → κ(x)` is bijective), the dual-number points
of `X` at `x` over `Spec k` form the `κ(x)`-linear dual of the cotangent
space `m_x/m_x²`. Composition of `overDualNumberAtEquivAlgHom` with the
local-algebra capstone `localDualNumberHomEquivCotangentSpaceDual`. -/
noncomputable def overDualNumberAtEquivCotangentSpaceDual
    (X : Over (Spec (CommRingCat.of k))) (x : X.left)
    (hres : Function.Bijective
      (algebraMap k (ResidueField (X.left.presheaf.stalk x)))) :
    {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
        g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
          ∧ g.base (closedPoint (DualNumber k)) = x} ≃
      Module.Dual (ResidueField (X.left.presheaf.stalk x))
        (CotangentSpace (X.left.presheaf.stalk x)) :=
  (overDualNumberAtEquivAlgHom X x).trans
    (localDualNumberHomEquivCotangentSpaceDual hres)

end OverStalkAlgebra

end AlgebraicGeometry
