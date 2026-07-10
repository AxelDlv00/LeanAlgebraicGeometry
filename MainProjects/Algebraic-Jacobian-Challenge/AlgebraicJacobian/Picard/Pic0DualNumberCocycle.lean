/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.Pic0TangentSpace
import AlgebraicJacobian.Picard.DualNumberUnits

/-!
# Tangent-space endgame: the representability leg of Kleiman §5 Thm 5.11

Leg (iii) of the Kleiman §5 Thm.~5.11 tangent-space computation for
`Pic⁰_{C/k}` (`Pic0.tangentSpaceIso`, `Picard/Pic0AbelianVariety.lean`): for a
functor `F` on `Over (Spec k)` **represented by** a `k`-scheme `X` and a
section `e` of the structure morphism, the pointed dual-number points of `X`
at `e` — the functor-of-points Zariski tangent space `T_e X` — are identified,
through the representing natural bijection, with the **fiber** of
`F(Spec k[ε]) → F(Spec k)` (restriction along the `ε ↦ 0` closed point) over
the class of `e`; when `F` is the set-valued shadow of a functor in abelian
groups, translation by the constant dual-number point over `e` normalises the
fiber to the **kernel** of `F(Spec k[ε]) →+ F(Spec k)`.

Applied to `F = Pic^♯_{C/k}` (`PicScheme.picSharp`, whose representing scheme
is the `[HasPicScheme C]`-gated `PicScheme C`), this is exactly Kleiman's
identification `T_e Pic_{C/k} = ker(Pic(C ×_k Spec k[ε]) → Pic(C))` — see
`Pic0.cotangentSpaceDual_equiv_relPicKernel` in
`Picard/Pic0AbelianVariety.lean`. The remaining legs of Thm 5.11 (the
truncated-exponential Čech-cocycle computation of that kernel on a 2-affine
cover, with the `k`-linearity bookkeeping) will live here as well — whence
the file name.

## Main declarations

- `AddMonoidHom.fiberEquivKer'` — the fiber of an additive-group homomorphism
  over the image of a point translates onto the kernel.
- `IsLocalRing.ringHom_ext_of_surjective_residue_comp` — **uniqueness of
  local retractions to the base field at a rational point**: two local ring
  homomorphisms `R →+* k` retracting a given `ι : k →+* R` with `k ↠ κ(R)`
  agree.
- `AlgebraicGeometry.overDualNumber`, `overDualNumberZero`,
  `overDualNumberAugment` — the dual-number object `Spec k[ε]` of
  `Over (Spec k)` with its `ε ↦ 0` point and its augmentation, a retract
  pair (`overDualNumberZero_comp_augment`).
- `AlgebraicGeometry.overSection_ext` — two sections of a `k`-scheme through
  the same point coincide (the point is `k`-rational, so the stalk data of a
  section is the *unique* local retraction `𝒪_{X,x} → k`).
- `AlgebraicGeometry.specMap_fstRingHom_comp_eq` — a pointed dual-number
  point restricts along `ε ↦ 0` to the pointing section itself.
- `AlgebraicGeometry.pointedDualNumberPointsEquivRepresentableFiber` — the
  fiber description of `T_e X` for represented functors.
- `AlgebraicGeometry.pointedDualNumberPointsEquivAddKernel` — the kernel
  description for representably group-valued functors.
- `DualNumber.scaleRingHom`, `AlgebraicGeometry.overDualNumberScale` — the
  Mumford `ε ↦ aε` scaling of `k[ε]` resp. of the dual-number object of
  `Over (Spec k)`, with its retract-pair compatibilities.
- `AlgebraicGeometry.relPicKernelSMul` — the induced multiplicative-monoid
  action of `k` on the dual-number kernel of a group-valued functor (the
  scalar multiplication of the Kleiman/Mumford `k`-module structure on
  `T_e`; distributivity in the scalar is deferred to the cocycle leg).

## References

Kleiman, "The Picard scheme", §5, proof of Thm.~5.11 (arXiv:math/0504020);
Mumford, "Abelian varieties", §II.4 (the `Spec k[ε]`-point description of the
tangent space of a functor).

Blueprint: `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`,
§ `sec:pic0_tangent_space`.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u v w

open CategoryTheory IsLocalRing

/-- **Fibers of an additive-group homomorphism translate onto the kernel.**
For `f : A →+ B` and a base point `a₀ : A`, subtracting `a₀` identifies the
fiber of `f` through `f a₀` with `ker f`. This is the normalisation step
turning the fiber description of the dual-number points of a represented
group functor (`pointedDualNumberPointsEquivRepresentableFiber` below) into
the kernel description of Kleiman §5 Thm.~5.11. (Primed: mathlib's
`AddMonoidHom.fiberEquivKer` states the same content on the carriers
`f ⁻¹' {f a} ≃ f.ker`; this variant is phrased on the equation subtypes the
represented-fiber equivalence produces.) -/
def AddMonoidHom.fiberEquivKer' {A : Type u} {B : Type v}
    [AddCommGroup A] [AddCommGroup B] (f : A →+ B) (a₀ : A) :
    {a : A // f a = f a₀} ≃ {a : A // f a = 0} where
  toFun a := ⟨a.1 - a₀, by rw [map_sub, a.2, sub_self]⟩
  invFun a := ⟨a.1 + a₀, by rw [map_add, a.2, zero_add]⟩
  left_inv a := Subtype.ext (by simp)
  right_inv a := Subtype.ext (by simp)

/-- **Uniqueness of local retractions to the base field at a rational
point.** Let `R` be a local ring, `k` a field, `ι : k →+* R` a homomorphism
such that `k → R → κ(R)` is surjective (a "rational point"). Then two *local*
ring homomorphisms `φ ψ : R →+* k` with `φ ∘ ι = ψ ∘ ι = id` are equal:
locality forces both to kill the maximal ideal, and by rationality every
`r : R` is congruent to a constant `ι c` mod `m`, so `φ r = c = ψ r`.

This is the algebraic heart of `AlgebraicGeometry.overSection_ext` below (two
sections of a `k`-scheme through one point coincide). Stated with an explicit
`ι` rather than `[Algebra k R]` so that call sites with categorical carriers
(`CommRingCat` stalks) need no instance bookkeeping. -/
theorem IsLocalRing.ringHom_ext_of_surjective_residue_comp
    {k : Type u} {R : Type v} [Field k] [CommRing R] [IsLocalRing R]
    {ι : k →+* R} (hres : Function.Surjective ((residue R).comp ι))
    {φ ψ : R →+* k} (hφl : IsLocalHom φ) (hψl : IsLocalHom ψ)
    (hφ : φ.comp ι = RingHom.id k) (hψ : ψ.comp ι = RingHom.id k) :
    φ = ψ := by
  have key : ∀ (χ : R →+* k), IsLocalHom χ → χ.comp ι = RingHom.id k →
      ∀ (r : R) (c : k), residue R r = residue R (ι c) → χ r = c := by
    intro χ hχ hχ1 r c hc
    have hmem : r - ι c ∈ maximalIdeal R := by
      rw [← residue_eq_zero_iff, map_sub, hc, sub_self]
    have h0 : χ (r - ι c) = 0 := by
      by_contra hne
      exact (mem_maximalIdeal _).mp hmem
        (hχ.map_nonunit _ (isUnit_iff_ne_zero.mpr hne))
    have hr : χ r = χ (r - ι c) + χ (ι c) := by
      rw [← map_add, sub_add_cancel]
    rw [hr, h0, zero_add]
    exact RingHom.congr_fun hχ1 c
  ext r
  obtain ⟨c, hc⟩ := hres (residue R r)
  rw [key φ hφl hφ r c hc.symm, key ψ hψl hψ r c hc.symm]

namespace DualNumber

open TrivSqZeroExt

variable {R : Type w} [CommRing R]

/-- **The `ε ↦ aε` scaling of the dual numbers**: `TrivSqZeroExt.map` of
scalar multiplication by `a` on the infinitesimal part, as a ring
homomorphism `R[ε] →+* R[ε]`, `r + m ε ↦ r + (a m) ε`. Mumford's `k`-module
structure on the tangent space `T_e F` of a functor at a rational point
scales tangent vectors by functoriality along it ("Abelian varieties",
§II.4); the scheme-level upgrade is `AlgebraicGeometry.overDualNumberScale`
below. -/
def scaleRingHom (a : R) : R[ε] →+* R[ε] :=
  (TrivSqZeroExt.map (a • (LinearMap.id : R →ₗ[R] R))).toRingHom

@[simp]
theorem fst_scaleRingHom (a : R) (x : R[ε]) : (scaleRingHom a x).fst = x.fst := by
  simp [scaleRingHom]

@[simp]
theorem snd_scaleRingHom (a : R) (x : R[ε]) : (scaleRingHom a x).snd = a * x.snd := by
  simp [scaleRingHom]

/-- Scalings compose multiplicatively: `(ε ↦ aε) ∘ (ε ↦ bε) = (ε ↦ (ab)ε)`. -/
theorem scaleRingHom_comp_scaleRingHom (a b : R) :
    (scaleRingHom a).comp (scaleRingHom b) = scaleRingHom (a * b) :=
  RingHom.ext fun x => TrivSqZeroExt.ext (by simp) (by simp [mul_assoc])

/-- Scaling by `1` is the identity. -/
theorem scaleRingHom_one : scaleRingHom (1 : R) = RingHom.id R[ε] :=
  RingHom.ext fun x => TrivSqZeroExt.ext (by simp) (by simp)

/-- Scaling by `0` is the retract `R[ε] → R → R[ε]` (kill `ε`, include
back). -/
theorem scaleRingHom_zero :
    scaleRingHom (0 : R) = (algebraMap R R[ε]).comp (fstRingHom (R := R)) :=
  RingHom.ext fun x => TrivSqZeroExt.ext
    (by simp [TrivSqZeroExt.algebraMap_eq_inl])
    (by simp [TrivSqZeroExt.algebraMap_eq_inl])

/-- The scaling fixes the constants: `scaleRingHom a ∘ inl = inl`. -/
theorem scaleRingHom_comp_algebraMap (a : R) :
    (scaleRingHom a).comp (algebraMap R R[ε]) = algebraMap R R[ε] :=
  RingHom.ext fun c => TrivSqZeroExt.ext
    (by simp [TrivSqZeroExt.algebraMap_eq_inl])
    (by simp [TrivSqZeroExt.algebraMap_eq_inl])

/-- The scaling commutes with reduction mod `ε`: `fst ∘ scaleRingHom a = fst`. -/
theorem fstRingHom_comp_scaleRingHom (a : R) :
    (fstRingHom (R := R)).comp (scaleRingHom a) = fstRingHom (R := R) :=
  RingHom.ext fun x => by simp

end DualNumber

namespace AlgebraicGeometry

variable {k : Type u} [Field k]

/-! ## §1. The dual-number object of `Over (Spec k)` and its retract pair -/

/-- The composite `Spec k → Spec k[ε] → Spec k` of the `ε ↦ 0` point with the
augmentation is the identity: on rings, `fst ∘ inl = id`. -/
lemma specMap_fstRingHom_comp (k : Type u) [Field k] :
    Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k))) ≫
        Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
      = 𝟙 (Spec (CommRingCat.of k)) := by
  have h : CommRingCat.ofHom (algebraMap k (DualNumber k)) ≫
      CommRingCat.ofHom (DualNumber.fstRingHom (R := k)) = 𝟙 (CommRingCat.of k) := by
    ext c
    simp [TrivSqZeroExt.algebraMap_eq_inl]
  rw [← Spec.map_comp, h, Spec.map_id]

/-- **The dual-number object** `Spec k[ε]` as an object of `Over (Spec k)`,
via the structure map `Spec` of `k → k[ε]`. Its pointed `X`-valued points at
a section `e` of a `k`-scheme `X` form the Zariski tangent space `T_e X`
(Mumford, "Abelian varieties", §II.4). -/
noncomputable def overDualNumber (k : Type u) [Field k] :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))))

/-- **The `ε ↦ 0` point** `Spec k ⟶ Spec k[ε]` of the dual-number object, as
a morphism in `Over (Spec k)` out of the trivial over-object. Restriction of
a tangent vector along it recovers the underlying point. -/
noncomputable def overDualNumberZero (k : Type u) [Field k] :
    Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ overDualNumber k :=
  Over.homMk (Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k))))
    (specMap_fstRingHom_comp k)

/-- **The augmentation** `Spec k[ε] ⟶ Spec k` of the dual-number object, as a
morphism in `Over (Spec k)` into the trivial over-object. Composition with it
produces "constant" tangent vectors. -/
noncomputable def overDualNumberAugment (k : Type u) [Field k] :
    overDualNumber k ⟶ Over.mk (𝟙 (Spec (CommRingCat.of k))) :=
  Over.homMk (Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))))
    (Category.comp_id _)

/-- The `ε ↦ 0` point and the augmentation form a retract pair:
`Spec k → Spec k[ε] → Spec k` is the identity of the trivial over-object. -/
lemma overDualNumberZero_comp_augment (k : Type u) [Field k] :
    overDualNumberZero k ≫ overDualNumberAugment k
      = 𝟙 (Over.mk (𝟙 (Spec (CommRingCat.of k)))) := by
  apply Over.OverMorphism.ext
  exact specMap_fstRingHom_comp k

/-! ## §2. Sections through a common point coincide -/

/-- **Two sections of a `k`-scheme through the same point coincide.** For a
scheme `X` over `Spec k` and sections `e₁, e₂` of the structure morphism with
`e₁(*) = e₂(*)`, already `e₁ = e₂`: the common image point is `k`-rational
(`bijective_algebraMap_residueField_of_section`), a morphism `Spec k ⟶ X` at
a fixed point is determined by its stalk data (`specToEquivOfLocalRingAt`),
and the stalk data of a section is a *local retraction* `𝒪_{X,x} → k` of the
structure homomorphism — unique at a rational point
(`IsLocalRing.ringHom_ext_of_surjective_residue_comp`). -/
theorem overSection_ext (X : Over (Spec (CommRingCat.of k)))
    {e₁ e₂ : Spec (CommRingCat.of k) ⟶ X.left}
    (h₁ : e₁ ≫ X.hom = 𝟙 (Spec (CommRingCat.of k)))
    (h₂ : e₂ ≫ X.hom = 𝟙 (Spec (CommRingCat.of k)))
    (hbase : e₁.base default = e₂.base default) :
    e₁ = e₂ := by
  haveI : IsLocalRing ↥(CommRingCat.of k) := inferInstanceAs (IsLocalRing k)
  haveI : Subsingleton ↥(Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  set x : X.left := e₂.base (closedPoint ↥(CommRingCat.of k)) with hxdef
  have hb₂ : e₂.base (closedPoint ↥(CommRingCat.of k)) = x := hxdef.symm
  have hb₁ : e₁.base (closedPoint ↥(CommRingCat.of k)) = x :=
    (congrArg e₁.base (Subsingleton.elim _ _)).trans <|
      hbase.trans <| (congrArg e₂.base (Subsingleton.elim _ _)).trans hb₂
  -- the common image point is `k`-rational
  have hres : Function.Surjective
      (algebraMap k (ResidueField (X.left.presheaf.stalk x))) :=
    (bijective_algebraMap_residueField_of_section X h₂
      ((congrArg e₂.base (Subsingleton.elim _ _)).trans hb₂)).2
  -- surjectivity of `k → 𝒪_{X,x} → κ(x)` with the explicit structure hom
  have hres' : Function.Surjective
      ((residue (X.left.presheaf.stalk x)).comp (stalkStructureHom X.hom x).hom) := by
    intro y
    obtain ⟨c, hc⟩ := hres y
    refine ⟨c, ?_⟩
    have : residue (X.left.presheaf.stalk x)
        (algebraMap k (X.left.presheaf.stalk x) c)
          = algebraMap k (ResidueField (X.left.presheaf.stalk x)) c :=
      residue_algebraMap c
    rw [RingHom.comp_apply, ← algebraMap_overStalkAlgebra X x, this, hc]
  -- pass to stalk data
  let E := specToEquivOfLocalRingAt X.left (CommRingCat.of k) x
  have hE : E ⟨e₁, hb₁⟩ = E ⟨e₂, hb₂⟩ := by
    apply Subtype.ext
    have hv₁ : (E ⟨e₁, hb₁⟩).1
        = (X.left.presheaf.stalkCongr (Inseparable.of_eq hb₁.symm)).hom ≫
            Scheme.stalkClosedPointTo e₁ := rfl
    have hv₂ : (E ⟨e₂, hb₂⟩).1
        = (X.left.presheaf.stalkCongr (Inseparable.of_eq hb₂.symm)).hom ≫
            Scheme.stalkClosedPointTo e₂ := rfl
    rw [hv₁, hv₂]
    -- both stalk data are local retractions of the structure homomorphism
    haveI : IsLocalHom ((X.left.presheaf.stalkCongr
        (Inseparable.of_eq hb₁.symm)).hom).hom := isLocalHom_of_isIso _
    haveI : IsLocalHom ((X.left.presheaf.stalkCongr
        (Inseparable.of_eq hb₂.symm)).hom).hom := isLocalHom_of_isIso _
    have hc₁ : stalkStructureHom X.hom x ≫
        (X.left.presheaf.stalkCongr (Inseparable.of_eq hb₁.symm)).hom ≫
          Scheme.stalkClosedPointTo e₁ = 𝟙 (CommRingCat.of k) :=
      (comp_eq_spec_iff_of_base_eq X.hom hb₁ (𝟙 (CommRingCat.of k))).mp
        (by rw [Spec.map_id]; exact h₁)
    have hc₂ : stalkStructureHom X.hom x ≫
        (X.left.presheaf.stalkCongr (Inseparable.of_eq hb₂.symm)).hom ≫
          Scheme.stalkClosedPointTo e₂ = 𝟙 (CommRingCat.of k) :=
      (comp_eq_spec_iff_of_base_eq X.hom hb₂ (𝟙 (CommRingCat.of k))).mp
        (by rw [Spec.map_id]; exact h₂)
    apply CommRingCat.hom_ext
    refine IsLocalRing.ringHom_ext_of_surjective_residue_comp hres'
      (CommRingCat.isLocalHom_comp _ _) (CommRingCat.isLocalHom_comp _ _) ?_ ?_
    · have := congrArg CommRingCat.Hom.hom hc₁
      simpa using this
    · have := congrArg CommRingCat.Hom.hom hc₂
      simpa using this
  exact congrArg Subtype.val (E.injective hE)

/-- **A pointed dual-number point restricts to the pointing section.** For a
section `e` of a `k`-scheme `X` and a dual-number point `g` of `X` over
`Spec k` landing at `e(*)`, the restriction of `g` along the `ε ↦ 0` point is
`e` itself — a scheme-morphism-level upgrade of the topological base-point
condition, valid because sections through a common (automatically
`k`-rational) point coincide (`overSection_ext`). -/
theorem specMap_fstRingHom_comp_eq (X : Over (Spec (CommRingCat.of k)))
    {e : Spec (CommRingCat.of k) ⟶ X.left}
    (he : e ≫ X.hom = 𝟙 (Spec (CommRingCat.of k)))
    {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left}
    (hg : g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))))
    (hbase : g.base (closedPoint (DualNumber k)) = e.base default) :
    Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k))) ≫ g = e := by
  haveI : Subsingleton ↥(Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  haveI : Subsingleton ↥(Spec (CommRingCat.of (DualNumber k))) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum (DualNumber k)))
  refine overSection_ext X ?_ he ?_
  · rw [Category.assoc, hg, specMap_fstRingHom_comp]
  · have h0 : (Spec.map (CommRingCat.ofHom
        (DualNumber.fstRingHom (R := k)))).base default
          = closedPoint (DualNumber k) := Subsingleton.elim _ _
    rw [Scheme.Hom.comp_apply, h0, hbase]

/-! ## §3. The fiber and kernel descriptions of the tangent space -/

/-- **The tangent space of a represented functor, as a fiber.** Let `F` be a
functor on `Over (Spec k)` represented by a `k`-scheme `X`, and `e` a section
of the structure morphism. Composition with the representing natural
bijection identifies the pointed dual-number points of `X` at `e` — the
Zariski tangent space `T_e X` in functor-of-points form — with the fiber of
the restriction map `F(Spec k[ε]) → F(Spec k)` (along the `ε ↦ 0` point) over
the class of `e`. The base-point condition transports to the fiber condition
by `specMap_fstRingHom_comp_eq` (sections through a common rational point
coincide). -/
noncomputable def pointedDualNumberPointsEquivRepresentableFiber
    (X : Over (Spec (CommRingCat.of k)))
    {F : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type v}
    (rep : F.RepresentableBy X)
    {e : Spec (CommRingCat.of k) ⟶ X.left}
    (he : e ≫ X.hom = 𝟙 (Spec (CommRingCat.of k))) :
    {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
        g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
          ∧ g.base (closedPoint (DualNumber k)) = e.base default}
      ≃ {a : F.obj (Opposite.op (overDualNumber k)) //
          F.map (overDualNumberZero k).op a
            = rep.homEquiv
                (Over.homMk e he : Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ X)} where
  toFun g :=
    ⟨rep.homEquiv (Over.homMk g.1 g.2.1 : overDualNumber k ⟶ X), by
      rw [← rep.homEquiv_comp]
      exact DFunLike.congr_arg rep.homEquiv (Over.OverMorphism.ext
        (specMap_fstRingHom_comp_eq X he g.2.1 g.2.2))⟩
  invFun a :=
    ⟨(rep.homEquiv.symm a.1).left,
      Over.w (rep.homEquiv.symm a.1),
      by
        haveI : Subsingleton ↥(Spec (CommRingCat.of (DualNumber k))) :=
          inferInstanceAs (Subsingleton (PrimeSpectrum (DualNumber k)))
        haveI : Subsingleton ↥(overDualNumber k).left :=
          inferInstanceAs (Subsingleton (PrimeSpectrum (DualNumber k)))
        have hcomp : overDualNumberZero k ≫ rep.homEquiv.symm a.1
            = (Over.homMk e he : Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ X) := by
          apply rep.homEquiv.injective
          rw [rep.homEquiv_comp, Equiv.apply_symm_apply]
          exact a.2
        have hleft : Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k)))
            ≫ (rep.homEquiv.symm a.1).left = e :=
          congrArg CategoryTheory.CommaMorphism.left hcomp
        calc (rep.homEquiv.symm a.1).left.base (closedPoint (DualNumber k))
            = (Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k)))
                ≫ (rep.homEquiv.symm a.1).left).base default := by
              rw [Scheme.Hom.comp_apply]
              exact congrArg (rep.homEquiv.symm a.1).left.base
                (Subsingleton.elim _ _)
          _ = e.base default := by rw [hleft]⟩
  left_inv g := Subtype.ext
    (congrArg CategoryTheory.CommaMorphism.left
      (rep.homEquiv.symm_apply_apply
        (Over.homMk g.1 g.2.1 : overDualNumber k ⟶ X)))
  right_inv a := Subtype.ext (by
    have h : ∀ (w : (rep.homEquiv.symm a.1).left ≫ X.hom = (overDualNumber k).hom),
        rep.homEquiv (Over.homMk (rep.homEquiv.symm a.1).left w) = a.1 := by
      intro w
      rw [show Over.homMk (rep.homEquiv.symm a.1).left w = rep.homEquiv.symm a.1 from
        Over.OverMorphism.ext rfl, Equiv.apply_symm_apply]
    exact h _)

/-- **The tangent space of a representably group-valued functor, as a
kernel** (Kleiman §5 Thm.~5.11, representability leg). Let `G` be an
`AddCommGrpCat`-valued functor on `Over (Spec k)` whose set-valued shadow is
represented by a `k`-scheme `X`, and `e` a section of the structure morphism.
Then the pointed dual-number points of `X` at `e` biject with the **kernel**
of the restriction homomorphism `G(Spec k[ε]) →+ G(Spec k)`: the fiber
description of `pointedDualNumberPointsEquivRepresentableFiber` is normalised
by translating with the constant tangent vector at `e` (the augmentation
composed with `e`, `AddMonoidHom.fiberEquivKer'`).

For `G = PicSharp.relPresheaf C` and `X = PicScheme C` this is
`T_e Pic_{C/k} ≃ ker(Pic^♯(Spec k[ε]) → Pic^♯(Spec k))`, consumed by
`Pic0.cotangentSpaceDual_equiv_relPicKernel`
(`Picard/Pic0AbelianVariety.lean`). -/
noncomputable def pointedDualNumberPointsEquivAddKernel
    (X : Over (Spec (CommRingCat.of k)))
    (G : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{v})
    (rep : (G ⋙ CategoryTheory.forget AddCommGrpCat.{v}).RepresentableBy X)
    {e : Spec (CommRingCat.of k) ⟶ X.left}
    (he : e ≫ X.hom = 𝟙 (Spec (CommRingCat.of k))) :
    {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
        g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
          ∧ g.base (closedPoint (DualNumber k)) = e.base default}
      ≃ {a : (G.obj (Opposite.op (overDualNumber k))) //
          (G.map (overDualNumberZero k).op).hom a = 0} := by
  -- the constant tangent vector at `e`, mapping to the class of `e`
  have ha₀ : (G.map (overDualNumberZero k).op).hom
      (rep.homEquiv (overDualNumberAugment k ≫
        (Over.homMk e he : Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ X)))
        = rep.homEquiv (Over.homMk e he : Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ X) := by
    have h := (rep.homEquiv_comp (overDualNumberZero k)
      (overDualNumberAugment k ≫
        (Over.homMk e he : Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ X))).symm
    rwa [← Category.assoc, overDualNumberZero_comp_augment, Category.id_comp] at h
  exact (pointedDualNumberPointsEquivRepresentableFiber X rep he).trans <|
    (Equiv.subtypeEquivRight fun a => by rw [← ha₀]; exact Iff.rfl).trans
      (AddMonoidHom.fiberEquivKer' (G.map (overDualNumberZero k).op).hom
        (rep.homEquiv (overDualNumberAugment k ≫
          (Over.homMk e he : Over.mk (𝟙 (Spec (CommRingCat.of k))) ⟶ X))))

/-! ## §4. The Mumford `ε ↦ aε` scaling of the dual-number object

The `k`-module structure on the tangent space of a group functor (Mumford,
"Abelian varieties", §II.4; the Kleiman §5 Thm.~5.11 linearity bookkeeping)
scales a tangent vector `Spec k[ε] → X` by precomposition with the
`ε ↦ aε` endomorphism of `Spec k[ε]`. This section provides that
endomorphism in `Over (Spec k)` together with its interaction with the
retract pair: it fixes the `ε ↦ 0` point, composes multiplicatively, is the
identity at `a = 1`, and collapses to the constant retract at `a = 0`. -/

/-- The `ε ↦ aε` scaling commutes with the structure morphism of the
dual-number object: on rings, `scaleRingHom a ∘ inl = inl`
(`DualNumber.scaleRingHom_comp_algebraMap`). -/
lemma specMap_scaleRingHom_comp (a : k) :
    Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom a)) ≫
        Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
      = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))) := by
  have h : CommRingCat.ofHom (algebraMap k (DualNumber k)) ≫
      CommRingCat.ofHom (DualNumber.scaleRingHom a)
        = CommRingCat.ofHom (algebraMap k (DualNumber k)) := by
    rw [← CommRingCat.ofHom_comp, DualNumber.scaleRingHom_comp_algebraMap]
  rw [← Spec.map_comp, h]

/-- **The `ε ↦ aε` scaling of the dual-number object**, as an endomorphism
of `Spec k[ε]` in `Over (Spec k)`. Precomposition with it is Mumford's
scalar multiplication by `a` on tangent vectors (functor-of-points Zariski
tangent space); pushing through a group-valued functor it becomes the scalar
action on the dual-number kernel (`relPicKernelSMul` below). -/
noncomputable def overDualNumberScale (a : k) :
    overDualNumber k ⟶ overDualNumber k :=
  Over.homMk (Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom a)))
    (specMap_scaleRingHom_comp a)

/-- The scaling fixes the `ε ↦ 0` point:
`overDualNumberZero ≫ overDualNumberScale a = overDualNumberZero`. This is
why the scaling preserves the kernel of the restriction map of a functor
along `ε ↦ 0`. -/
lemma overDualNumberZero_comp_scale (a : k) :
    overDualNumberZero k ≫ overDualNumberScale a = overDualNumberZero k := by
  have hr : CommRingCat.ofHom (DualNumber.scaleRingHom a) ≫
      CommRingCat.ofHom (DualNumber.fstRingHom (R := k))
        = CommRingCat.ofHom (DualNumber.fstRingHom (R := k)) := by
    rw [← CommRingCat.ofHom_comp, DualNumber.fstRingHom_comp_scaleRingHom]
  have h : Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k))) ≫
      Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom a))
        = Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k))) := by
    rw [← Spec.map_comp, hr]
  apply Over.OverMorphism.ext
  exact h

/-- The scaling composes multiplicatively:
`overDualNumberScale a ≫ overDualNumberScale b = overDualNumberScale (a * b)`
(note both orders agree, `k` being commutative). -/
lemma overDualNumberScale_comp (a b : k) :
    overDualNumberScale (k := k) a ≫ overDualNumberScale b
      = overDualNumberScale (a * b) := by
  have hr : CommRingCat.ofHom (DualNumber.scaleRingHom b) ≫
      CommRingCat.ofHom (DualNumber.scaleRingHom a)
        = CommRingCat.ofHom (DualNumber.scaleRingHom (a * b)) := by
    rw [← CommRingCat.ofHom_comp, DualNumber.scaleRingHom_comp_scaleRingHom]
  have h : Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom a)) ≫
      Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom b))
        = Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom (a * b))) := by
    rw [← Spec.map_comp, hr]
  apply Over.OverMorphism.ext
  exact h

/-- Scaling by `1` is the identity of the dual-number object. -/
lemma overDualNumberScale_one :
    overDualNumberScale (1 : k) = 𝟙 (overDualNumber k) := by
  have hr : CommRingCat.ofHom (DualNumber.scaleRingHom (1 : k))
      = 𝟙 (CommRingCat.of (DualNumber k)) := by
    rw [DualNumber.scaleRingHom_one]
    rfl
  have h : Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom (1 : k)))
      = 𝟙 (Spec (CommRingCat.of (DualNumber k))) := by
    rw [hr, Spec.map_id]
  apply Over.OverMorphism.ext
  exact h

/-- Scaling by `0` collapses to the constant retract: it factors as the
augmentation followed by the `ε ↦ 0` point. This is why `0 • v` is the zero
tangent vector. -/
lemma overDualNumberScale_zero :
    overDualNumberScale (0 : k)
      = overDualNumberAugment k ≫ overDualNumberZero k := by
  have hr : CommRingCat.ofHom (DualNumber.fstRingHom (R := k)) ≫
      CommRingCat.ofHom (algebraMap k (DualNumber k))
        = CommRingCat.ofHom (DualNumber.scaleRingHom (0 : k)) := by
    rw [← CommRingCat.ofHom_comp, DualNumber.scaleRingHom_zero]
  have h : Spec.map (CommRingCat.ofHom (DualNumber.scaleRingHom (0 : k)))
      = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))) ≫
          Spec.map (CommRingCat.ofHom (DualNumber.fstRingHom (R := k))) := by
    rw [← hr, Spec.map_comp]
  apply Over.OverMorphism.ext
  exact h

/-! ## §5. The scaling action on the dual-number kernel of a group functor -/

/-- **Mumford's tangent-vector scaling on the dual-number kernel.** For an
`AddCommGrpCat`-valued functor `G` on `Over (Spec k)`, functoriality along
the `ε ↦ aε` scaling preserves the kernel of the restriction homomorphism
`G(Spec k[ε]) →+ G(Spec k)` — the scaling fixes the `ε ↦ 0` point
(`overDualNumberZero_comp_scale`). This is the scalar multiplication of the
Kleiman/Mumford `k`-module structure on the tangent space of a group functor
at the identity (Mumford, "Abelian varieties", §II.4), transported to the
kernel model of `pointedDualNumberPointsEquivAddKernel`.

Additivity in the vector is `map_add` of `G.map (overDualNumberScale a).op`;
the multiplicative-monoid laws are `relPicKernelSMul_one` /
`relPicKernelSMul_mul` / `relPicKernelSMul_zero` below. Distributivity
`(a + b) • x = a • x + b • x` is **not** formal at this generality (it needs
the sheaf condition of `G` against `k[ε] ×_k k[ε] = k[ε₁, ε₂]`) and belongs
to the cocycle leg of Kleiman §5 Thm.~5.11. -/
noncomputable def relPicKernelSMul
    (G : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{v}) (a : k)
    (x : {x : G.obj (Opposite.op (overDualNumber k)) //
      (G.map (overDualNumberZero k).op).hom x = 0}) :
    {x : G.obj (Opposite.op (overDualNumber k)) //
      (G.map (overDualNumberZero k).op).hom x = 0} :=
  ⟨(G.map (overDualNumberScale a).op).hom x.1, by
    have h : (G.map (overDualNumberZero k).op).hom
        ((G.map (overDualNumberScale a).op).hom x.1)
      = (G.map (overDualNumberZero k ≫ overDualNumberScale a).op).hom x.1 := by
      rw [op_comp, G.map_comp]
      rfl
    rw [h, overDualNumberZero_comp_scale, x.2]⟩

/-- `1 • x = x` for the Mumford scaling on the dual-number kernel. -/
lemma relPicKernelSMul_one
    (G : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{v})
    (x : {x : G.obj (Opposite.op (overDualNumber k)) //
      (G.map (overDualNumberZero k).op).hom x = 0}) :
    relPicKernelSMul G 1 x = x := by
  apply Subtype.ext
  change (G.map (overDualNumberScale (1 : k)).op).hom x.1 = x.1
  rw [overDualNumberScale_one, op_id, G.map_id]
  rfl

/-- `a • (b • x) = (a * b) • x` for the Mumford scaling on the dual-number
kernel. -/
lemma relPicKernelSMul_mul
    (G : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{v}) (a b : k)
    (x : {x : G.obj (Opposite.op (overDualNumber k)) //
      (G.map (overDualNumberZero k).op).hom x = 0}) :
    relPicKernelSMul G a (relPicKernelSMul G b x)
      = relPicKernelSMul G (a * b) x := by
  apply Subtype.ext
  have h : (G.map (overDualNumberScale a).op).hom
      ((G.map (overDualNumberScale b).op).hom x.1)
    = (G.map (overDualNumberScale a ≫ overDualNumberScale b).op).hom x.1 := by
    rw [op_comp, G.map_comp]
    rfl
  change (G.map (overDualNumberScale a).op).hom
      ((G.map (overDualNumberScale b).op).hom x.1)
    = (G.map (overDualNumberScale (a * b)).op).hom x.1
  rw [h, overDualNumberScale_comp]

/-- `0 • x = 0` for the Mumford scaling on the dual-number kernel: scaling
by `0` factors through the restriction to `Spec k`, which kills kernel
elements. -/
lemma relPicKernelSMul_zero
    (G : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{v})
    (x : {x : G.obj (Opposite.op (overDualNumber k)) //
      (G.map (overDualNumberZero k).op).hom x = 0}) :
    (relPicKernelSMul G (0 : k) x).1 = 0 := by
  change (G.map (overDualNumberScale (0 : k)).op).hom x.1 = 0
  have h : (G.map (overDualNumberAugment k ≫ overDualNumberZero k).op).hom x.1
      = (G.map (overDualNumberAugment k).op).hom
          ((G.map (overDualNumberZero k).op).hom x.1) := by
    rw [op_comp, G.map_comp]
    rfl
  rw [overDualNumberScale_zero, h, x.2, map_zero]

end AlgebraicGeometry
