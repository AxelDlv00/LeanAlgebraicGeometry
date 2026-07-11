/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Algebra.PiLocalization
import AlgebraicJacobian.Descent.UnitDescent

/-!
# Čech 1-cocycles on a finite localization cover as descent cocycles

Let `A` be a commutative ring and `f : ι → A` a finite family.  Fix models for the
localizations of `A` away from the single, double and triple products of the `f i`:

* `S i` with `IsLocalization.Away (f i) (S i)` — "sections on `D(f i)`";
* `T i j` with `IsLocalization.Away (f i * f j) (T i j)` — sections on the overlaps;
* `W i j k` with `IsLocalization.Away (f i * (f j * f k)) (W i j k)` — triple overlaps.

A **cover cocycle** (`IsLocalization.AwayCover.IsCoverCocycle`) is a family of units
`γ i j : (T i j)ˣ` that is `1` on the diagonal and satisfies the Čech 1-cocycle identity
on triple overlaps, all maps being the canonical (unique!) `A`-algebra maps between
localizations.  This file converts such a family into a descent 1-cocycle
`cocycleUnit γ : (B ⊗[A] B)ˣ` for the cover algebra `B := ∀ i, S i`
(`Module.IsDescentCocycle`, from `AlgebraicJacobian.Descent.UnitDescent`), via the
`A`-algebra identifications `B ⊗[A] B ≃ ∀ p, T p.1 p.2` and
`B ⊗[A] (B ⊗[A] B) ≃ ∀ t, W t.1 t.2.1 t.2.2` of `AlgebraicJacobian.Algebra.PiLocalization`.

The bridge lemmas (`lmul'_cocycleUnit`, `piTripleEquiv_descentFace*`,
`piDoubleEquiv_descentIncl*`) compute the images of the simplicial ring maps of
`UnitDescent` through these identifications: they become index-wise canonical restriction
maps.  Every one of them is an instance of the pi-ext principle
(`AlgHom.ext_of_isLocalization_pi`): both sides are `A`-algebra maps out of a finite
product of localizations of `A`, so it suffices to compare them on the coordinate
idempotents.

Consumers (`AlgebraicJacobian.Picard.PicAffine`) use:

* `isDescentCocycle_cocycleUnit` — the conversion;
* `cocycleUnit_mul` — multiplicativity in `γ`;
* `exists_units_of_cocycleUnit_eq_descentCoboundary` — a cocycle whose descent unit is a
  coboundary is an index-wise coboundary;
* `map_cocycleUnit` — compatibility with refinement of covers.
-/

universe u

open TensorProduct

namespace IsLocalization.Away

variable {A : Type u} [CommRing A]

section algHomOfIsUnit

variable (S T : Type u) [CommRing S] [CommRing T] [Algebra A S] [Algebra A T]

/-- The canonical `A`-algebra map out of an `Away f` localization into any `A`-algebra
where `f` becomes invertible.  Any two `A`-algebra maps with this source and target are
equal (`IsLocalization.algHom_subsingleton`). -/
noncomputable def algHomOfIsUnit (f : A) [IsLocalization.Away f S]
    (h : IsUnit (algebraMap A T f)) : S →ₐ[A] T :=
  IsLocalization.liftAlgHom (M := Submonoid.powers f) (f := Algebra.ofId A T) <| by
    rintro ⟨y, n, rfl⟩
    exact (h.pow n).imp fun u hu => by simpa [Algebra.ofId_apply, map_pow] using hu

end algHomOfIsUnit

end IsLocalization.Away

namespace IsLocalization.AwayCover

variable {A : Type u} [CommRing A] {ι : Type u} [Fintype ι] [DecidableEq ι]
variable (f : ι → A)
variable (S : ι → Type u) [∀ i, CommRing (S i)] [∀ i, Algebra A (S i)]
  [∀ i, IsLocalization.Away (f i) (S i)]
variable (T : ι → ι → Type u) [∀ i j, CommRing (T i j)] [∀ i j, Algebra A (T i j)]
  [∀ i j, IsLocalization.Away (f i * f j) (T i j)]
variable (W : ι → ι → ι → Type u) [∀ i j k, CommRing (W i j k)]
  [∀ i j k, Algebra A (W i j k)]
  [∀ i j k, IsLocalization.Away (f i * (f j * f k)) (W i j k)]

/-! ## The canonical restriction maps -/

/-- Restriction to the overlap from the left index: `S i →ₐ[A] T i j`. -/
noncomputable def inclLeft (i j : ι) : S i →ₐ[A] T i j :=
  IsLocalization.Away.algHomOfDvd (f i) (f i * f j) (S i) (T i j) (dvd_mul_right _ _)

/-- Restriction to the overlap from the right index: `S j →ₐ[A] T i j`. -/
noncomputable def inclRight (i j : ι) : S j →ₐ[A] T i j :=
  IsLocalization.Away.algHomOfDvd (f j) (f i * f j) (S j) (T i j) (dvd_mul_left _ _)

/-- The diagonal identification `T i i →ₐ[A] S i`. -/
noncomputable def diag (i : ι) : T i i →ₐ[A] S i :=
  IsLocalization.Away.algHomOfIsUnit (S := T i i) (S i) (f i * f i) <| by
    rw [map_mul]
    exact (IsLocalization.Away.algebraMap_isUnit (S := S i) (f i)).mul
      (IsLocalization.Away.algebraMap_isUnit (S := S i) (f i))

/-- Restriction from the `(1,2)`-overlap to the triple overlap. -/
noncomputable def face₁₂ (i j k : ι) : T i j →ₐ[A] W i j k :=
  IsLocalization.Away.algHomOfDvd (f i * f j) (f i * (f j * f k)) (T i j) (W i j k)
    ⟨f k, by ring⟩

/-- Restriction from the `(1,3)`-overlap to the triple overlap. -/
noncomputable def face₁₃ (i j k : ι) : T i k →ₐ[A] W i j k :=
  IsLocalization.Away.algHomOfDvd (f i * f k) (f i * (f j * f k)) (T i k) (W i j k)
    ⟨f j, by ring⟩

/-- Restriction from the `(2,3)`-overlap to the triple overlap. -/
noncomputable def face₂₃ (i j k : ι) : T j k →ₐ[A] W i j k :=
  IsLocalization.Away.algHomOfDvd (f j * f k) (f i * (f j * f k)) (T j k) (W i j k)
    ⟨f i, by ring⟩

/-! ## Cover cocycles -/

variable {f S T W}

/-- A **Čech 1-cocycle of units** on the finite localization cover `f : ι → A`:
a family of units on the double overlaps, equal to `1` on the diagonal, satisfying the
cocycle identity on the triple overlaps. -/
structure IsCoverCocycle (γ : ∀ i j, (T i j)ˣ) : Prop where
  diag_eq_one : ∀ i, diag f S T i (γ i i).val = 1
  cocycle : ∀ i j k,
    face₂₃ f T W i j k (γ j k).val * face₁₂ f T W i j k (γ i j).val
      = face₁₃ f T W i j k (γ i k).val

variable (f S T W)

/-! ## The identification of tensor powers of the cover algebra -/

/-- The `A`-algebra identification of `B ⊗[A] B`, `B := ∀ i, S i`, with the product of
the double-overlap localizations. -/
noncomputable def piDoubleEquiv :
    ((∀ i, S i) ⊗[A] ∀ i, S i) ≃ₐ[A] ∀ p : ι × ι, T p.1 p.2 :=
  (Algebra.TensorProduct.piPiAlgEquiv A S S).trans
    (AlgEquiv.piCongrRight fun p =>
      IsLocalization.Away.tensorEquiv' (f p.1) (f p.2) (S p.1) (S p.2) (T p.1 p.2))

/-- The `A`-algebra identification of `B ⊗[A] (B ⊗[A] B)` with the product of the
triple-overlap localizations. -/
noncomputable def piTripleEquiv :
    ((∀ i, S i) ⊗[A] ((∀ i, S i) ⊗[A] ∀ i, S i)) ≃ₐ[A] ∀ t : ι × ι × ι, W t.1 t.2.1 t.2.2 :=
  (Algebra.TensorProduct.congr AlgEquiv.refl (piDoubleEquiv f S T)).trans <|
    (Algebra.TensorProduct.piPiAlgEquiv A S fun p : ι × ι => T p.1 p.2).trans <|
      AlgEquiv.piCongrRight fun t =>
        IsLocalization.Away.tensorEquiv' (f t.1) (f t.2.1 * f t.2.2) (S t.1)
          (T t.2.1 t.2.2) (W t.1 t.2.1 t.2.2)

/-- A family of units collected into a unit of the product monoid, with definitionally
transparent value and inverse. -/
@[simps]
def _root_.Pi.unitOf {κ : Type u} (M : κ → Type u) [∀ k, Monoid (M k)]
    (β : ∀ k, (M k)ˣ) : (∀ k, M k)ˣ where
  val k := (β k).val
  inv k := ((β k)⁻¹).val
  val_inv := funext fun k => Units.mul_inv _
  inv_val := funext fun k => Units.inv_mul _

/-- The unit of `∀ p, T p.1 p.2` collecting a family of units on the double overlaps. -/
def piUnit (γ : ∀ i j, (T i j)ˣ) : (∀ p : ι × ι, T p.1 p.2)ˣ :=
  Pi.unitOf _ fun p => γ p.1 p.2

@[simp]
lemma piUnit_val (γ : ∀ i j, (T i j)ˣ) (p : ι × ι) :
    (piUnit T γ).val p = (γ p.1 p.2).val := rfl

/-- The descent unit of a family of units on the double overlaps of a finite
localization cover: the corresponding unit of `B ⊗[A] B`. -/
noncomputable def cocycleUnit (γ : ∀ i j, (T i j)ˣ) : ((∀ i, S i) ⊗[A] ∀ i, S i)ˣ :=
  Units.map ((piDoubleEquiv f S T).symm : (∀ p : ι × ι, T p.1 p.2) ≃ₐ[A] _).toAlgHom.toRingHom.toMonoidHom
    (piUnit T γ)

lemma cocycleUnit_val (γ : ∀ i j, (T i j)ˣ) :
    (cocycleUnit f S T γ).val = (piDoubleEquiv f S T).symm (piUnit T γ).val := rfl

@[simp]
lemma piDoubleEquiv_cocycleUnit_val (γ : ∀ i j, (T i j)ˣ) :
    piDoubleEquiv f S T (cocycleUnit f S T γ).val = fun p : ι × ι => (γ p.1 p.2).val := by
  rw [cocycleUnit_val, AlgEquiv.apply_symm_apply]
  rfl

/-- Multiplicativity of the descent unit in the cocycle. -/
lemma cocycleUnit_mul (γ γ' : ∀ i j, (T i j)ˣ) :
    cocycleUnit f S T (fun i j => γ i j * γ' i j)
      = cocycleUnit f S T γ * cocycleUnit f S T γ' := by
  apply Units.ext
  simp only [cocycleUnit_val, Units.val_mul, ← map_mul]
  rfl

/-! ## Transport of the simplicial maps through the identifications

Each lemma below is proved by the pi-ext principle `AlgHom.ext_of_isLocalization_pi`:
both sides, as `A`-algebra maps out of a finite product of localizations of `A`, agree
on the coordinate idempotents (a finite computation via
`Algebra.TensorProduct.piPiAlgEquiv_tmul` and `Pi.single`-arithmetic, using that all
component maps between localizations are canonical), hence are equal.  The forward images
of the idempotents are computed from `piDoubleEquiv (Pi.single i 1 ⊗ₜ Pi.single j 1) =
Pi.single (i,j) 1` and its triple analogue, plus `1 = ∑ i, Pi.single i 1`. -/

/-- Multiplication `B ⊗[A] B → B` becomes the diagonal restriction. -/
lemma lmul'_piDoubleEquiv_symm (w : ∀ p : ι × ι, T p.1 p.2) :
    Algebra.TensorProduct.lmul' A (S := ∀ i, S i) ((piDoubleEquiv f S T).symm w)
      = fun i => diag f S T i (w (i, i)) := by
  sorry

/-- The face `descentFace₂₃` becomes `w ↦ (t ↦ w(t₂, t₃))` restricted. -/
lemma piTripleEquiv_descentFace₂₃ (w : ∀ p : ι × ι, T p.1 p.2) :
    piTripleEquiv f S T W (Module.descentFace₂₃ A (∀ i, S i) ((piDoubleEquiv f S T).symm w))
      = fun t : ι × ι × ι => face₂₃ f T W t.1 t.2.1 t.2.2 (w (t.2.1, t.2.2)) := by
  sorry

/-- The face `descentFace₁₂` becomes `w ↦ (t ↦ w(t₁, t₂))` restricted. -/
lemma piTripleEquiv_descentFace₁₂ (w : ∀ p : ι × ι, T p.1 p.2) :
    piTripleEquiv f S T W (Module.descentFace₁₂ A (∀ i, S i) ((piDoubleEquiv f S T).symm w))
      = fun t : ι × ι × ι => face₁₂ f T W t.1 t.2.1 t.2.2 (w (t.1, t.2.1)) := by
  sorry

/-- The face `descentFace₁₃` becomes `w ↦ (t ↦ w(t₁, t₃))` restricted. -/
lemma piTripleEquiv_descentFace₁₃ (w : ∀ p : ι × ι, T p.1 p.2) :
    piTripleEquiv f S T W (Module.descentFace₁₃ A (∀ i, S i) ((piDoubleEquiv f S T).symm w))
      = fun t : ι × ι × ι => face₁₃ f T W t.1 t.2.1 t.2.2 (w (t.1, t.2.2)) := by
  sorry

/-- The inclusion `descentIncl₁ : B → B ⊗[A] B` becomes the left overlap restriction. -/
lemma piDoubleEquiv_descentIncl₁ (s : ∀ i, S i) :
    piDoubleEquiv f S T (Module.descentIncl₁ A (∀ i, S i) s)
      = fun p : ι × ι => inclLeft f S T p.1 p.2 (s p.1) := by
  sorry

/-- The inclusion `descentIncl₂ : B → B ⊗[A] B` becomes the right overlap restriction. -/
lemma piDoubleEquiv_descentIncl₂ (s : ∀ i, S i) :
    piDoubleEquiv f S T (Module.descentIncl₂ A (∀ i, S i) s)
      = fun p : ι × ι => inclRight f S T p.1 p.2 (s p.2) := by
  sorry

/-! ## The main conversion -/

/-- **A Čech 1-cocycle of units on a finite localization cover is a descent
1-cocycle.** -/
theorem isDescentCocycle_cocycleUnit {γ : ∀ i j, (T i j)ˣ} (hγ : IsCoverCocycle (f := f) (S := S) (W := W) γ) :
    Module.IsDescentCocycle (cocycleUnit f S T γ) where
  lmul'_eq_one := by
    rw [cocycleUnit_val, lmul'_piDoubleEquiv_symm]
    funext i
    exact hγ.diag_eq_one i
  cocycle := by
    apply (piTripleEquiv f S T W).injective
    have hu : (cocycleUnit f S T γ).val = (piDoubleEquiv f S T).symm (piUnit T γ).val := rfl
    rw [map_mul, hu, piTripleEquiv_descentFace₂₃, piTripleEquiv_descentFace₁₂,
      piTripleEquiv_descentFace₁₃]
    funext t
    exact hγ.cocycle t.1 t.2.1 t.2.2

/-- A descent unit that is a coboundary is an index-wise coboundary: if
`cocycleUnit γ = descentCoboundary β` for a unit `β` of the cover algebra, then each
`γ i j` is the quotient of the restrictions of the components of `β`. -/
theorem exists_units_of_cocycleUnit_eq_descentCoboundary {γ : ∀ i j, (T i j)ˣ}
    {β : (∀ i, S i)ˣ} (h : cocycleUnit f S T γ = Module.descentCoboundary A (∀ i, S i) β) :
    ∀ i j, (γ i j).val
      = inclRight f S T i j (β.val j)
        * inclLeft f S T i j ((β⁻¹).val i) := by
  -- Apply `piDoubleEquiv` to the value equation; the left side is `γ` index-wise
  -- (`piDoubleEquiv_cocycleUnit_val`), the right side is computed by
  -- `Module.descentCoboundary_val`, `map_mul`, `piDoubleEquiv_descentIncl₂`,
  -- `piDoubleEquiv_descentIncl₁` (with `s := β.val` resp. `(β⁻¹).val`).
  sorry

/-- Twisting a cover cocycle by an index-wise coboundary multiplies the descent unit by
a descent coboundary. -/
theorem cocycleUnit_eq_descentCoboundary_mul {γ γ' : ∀ i j, (T i j)ˣ} (β : ∀ i, (S i)ˣ)
    (hrel : ∀ i j, (γ' i j).val
      = inclLeft f S T i j (β i).val
          * ((γ i j).val * inclRight f S T i j ((β j)⁻¹).val)) :
    cocycleUnit f S T γ'
      = Module.descentCoboundary A (∀ i, S i) (Pi.unitOf S β)⁻¹
          * cocycleUnit f S T γ := by
  -- `Units.ext`, then apply the injective `piDoubleEquiv` to both values; the left side
  -- is `γ'` index-wise (`piDoubleEquiv_cocycleUnit_val`), the right side is computed by
  -- `Module.descentCoboundary_val` (for the unit `(Pi.unitOf S β)⁻¹`, whose value is
  -- `(1 ⊗ₜ (β⁻¹-components)) * ((β-components) ⊗ₜ 1)`), `map_mul`,
  -- `piDoubleEquiv_descentIncl₁`, `piDoubleEquiv_descentIncl₂` and `hrel`.
  sorry

section picClass

variable [Module.FaithfullyFlat A (∀ i, S i)]

/-- **Coboundary invariance of the Picard class**: two cover cocycles differing by an
index-wise coboundary have the same Picard class. -/
theorem picClass_eq_of_coboundary {γ γ' : ∀ i j, (T i j)ˣ}
    (hγ : IsCoverCocycle (f := f) (S := S) (W := W) γ)
    (hγ' : IsCoverCocycle (f := f) (S := S) (W := W) γ')
    (β : ∀ i, (S i)ˣ)
    (hrel : ∀ i j, (γ' i j).val
      = inclLeft f S T i j (β i).val
          * ((γ i j).val * inclRight f S T i j ((β j)⁻¹).val)) :
    (isDescentCocycle_cocycleUnit f S T W hγ').picClass
      = (isDescentCocycle_cocycleUnit f S T W hγ).picClass :=
  (Module.IsDescentCocycle.picClass_congr _ _
      (cocycleUnit_eq_descentCoboundary_mul f S T β hrel)).trans
    (Module.IsDescentCocycle.picClass_descentCoboundary_mul _
      (isDescentCocycle_cocycleUnit f S T W hγ))

end picClass

/-! ## Refinement of covers -/

section refine

variable {ι' : Type u} [Fintype ι'] [DecidableEq ι']
variable (f' : ι' → A)
variable (S' : ι' → Type u) [∀ i, CommRing (S' i)] [∀ i, Algebra A (S' i)]
  [∀ i, IsLocalization.Away (f' i) (S' i)]
variable (T' : ι' → ι' → Type u) [∀ i j, CommRing (T' i j)] [∀ i j, Algebra A (T' i j)]
  [∀ i j, IsLocalization.Away (f' i * f' j) (T' i j)]
variable (τ : ι' → ι) (hτ : ∀ i', IsUnit (algebraMap A (S' i') (f (τ i'))))

/-- The refinement map between cover algebras along an index map `τ` making each
`f (τ i')` invertible in `S' i'`. -/
noncomputable def refineAlgHom : (∀ i, S i) →ₐ[A] ∀ i', S' i' :=
  Pi.algHom _ _ fun i' =>
    (IsLocalization.Away.algHomOfIsUnit (S := S (τ i')) (S' i') (f (τ i')) (hτ i')).comp
      (Pi.evalAlgHom _ _ (τ i'))

variable (hτT : ∀ i' j', IsUnit (algebraMap A (T' i' j') (f (τ i') * f (τ j'))))

/-- The refinement map on double overlaps. -/
noncomputable def refineOverlapAlgHom (i' j' : ι') : T (τ i') (τ j') →ₐ[A] T' i' j' :=
  IsLocalization.Away.algHomOfIsUnit (S := T (τ i') (τ j')) (T' i' j')
    (f (τ i') * f (τ j')) (hτT i' j')

/-- Base change of the descent unit along a refinement of covers: the descent unit of
the restricted cocycle. -/
theorem map_cocycleUnit (γ : ∀ i j, (T i j)ˣ) :
    Units.map (Algebra.TensorProduct.map (refineAlgHom f S S' τ hτ)
        (refineAlgHom f S S' τ hτ)).toRingHom.toMonoidHom (cocycleUnit f S T γ)
      = cocycleUnit f' S' T' (fun i' j' =>
          Units.map (refineOverlapAlgHom f T T' τ hτT i' j').toRingHom.toMonoidHom
            (γ (τ i') (τ j'))) := by
  -- Apply `piDoubleEquiv f' S' T'` to both sides.  The composite
  -- `piDoubleEquiv' ∘ (map h h) ∘ (piDoubleEquiv).symm` is index-wise
  -- `refineOverlapAlgHom` by the pi-ext principle (evaluate on the idempotents
  -- `Pi.single (i,j) 1`, whose preimages are `Pi.single i 1 ⊗ₜ Pi.single j 1`).
  sorry

variable (W' : ι' → ι' → ι' → Type u) [∀ i j k, CommRing (W' i j k)]
  [∀ i j k, Algebra A (W' i j k)]
  [∀ i j k, IsLocalization.Away (f' i * (f' j * f' k)) (W' i j k)]

include hτ in
/-- **Refinement invariance of the Picard class**: restricting a cover cocycle along a
refinement of finite localization covers does not change the Picard class of the
descended module. -/
theorem picClass_map_refine [Module.FaithfullyFlat A (∀ i, S i)]
    [Module.FaithfullyFlat A (∀ i', S' i')]
    {γ : ∀ i j, (T i j)ˣ} {γ' : ∀ i' j', (T' i' j')ˣ}
    (hγ : IsCoverCocycle (f := f) (S := S) (W := W) γ)
    (hγ' : IsCoverCocycle (f := f') (S := S') (W := W') γ')
    (hrel : ∀ i' j', γ' i' j'
      = Units.map (refineOverlapAlgHom f T T' τ hτT i' j').toRingHom.toMonoidHom
          (γ (τ i') (τ j'))) :
    (isDescentCocycle_cocycleUnit f' S' T' W' hγ').picClass
      = (isDescentCocycle_cocycleUnit f S T W hγ).picClass := by
  have h := map_cocycleUnit f S T f' S' T' τ hτ hτT γ
  have hγ'' : cocycleUnit f' S' T' γ'
      = Units.map (Algebra.TensorProduct.map (refineAlgHom f S S' τ hτ)
          (refineAlgHom f S S' τ hτ)).toRingHom.toMonoidHom (cocycleUnit f S T γ) := by
    rw [h]
    congr 1
    funext i' j'
    exact hrel i' j'
  exact (Module.IsDescentCocycle.picClass_congr _ _ hγ'').trans
    (Module.IsDescentCocycle.picClass_map (refineAlgHom f S S' τ hτ)
      (isDescentCocycle_cocycleUnit f S T W hγ))

end refine

end IsLocalization.AwayCover
