/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Albanese.SymPowInterface

/-!
# The symmetric power is a colimit of the permutation action

`Albanese/SymPowInterface.lean` names the universal property of `Sym^n C` as data
(`SymPowData`) and proves Milne's Albanese argument over it. It also records the honest
limitation: the *bare* structure is trivially inhabited (`symPowDataTrivial`, take
`proj := 𝟙`), so what the downstream theorems quantify over is the **pair**
`(D, hproj)` with `hproj : ∀ σ, permAut C σ ≫ D.proj = D.proj`, and that pair had only
one witness — `n = 1`.

This file removes that limitation by identifying what the pair *is*.

## The identification

Let `permDiagram C n : SingleObj (Equiv.Perm (Fin n)) ⥤ K` be the one-object diagram of
the `S_n`-action on `C^n` by `permAut`. Then:

* `symPowOfColimit` — a colimit of `permDiagram C n` **is** a `SymPowData C n`, and
* `symPowOfColimit_proj_perm` — its projection is symmetric **for free**: the symmetry
  hypothesis is literally `colimit.w`, the cocone condition;
* `SymPowData.isColimit` — conversely, any pair `(D, hproj)` *is* a colimit of the same
  diagram.

So the pair the Albanese theorems consume is not merely *implied by* a quotient — it is
**equivalent** to a colimit of the permutation action. That is the categorical content of
Milne III.3 Proposition 3.1 separated from its affine-and-glue implementation.

## Why this is a reduction and not a restatement

Three things change, and each is checked below rather than asserted.

1. **The trivial witness is refuted, in the tree.** `permAut_swap_ne_id` exhibits a
   concrete `K` (`Type`), a concrete object (`Bool`) and `n = 2` at which
   `permAut ≠ 𝟙`; hence `symPowDataTrivial` genuinely fails `hproj` there
   (`symPowDataTrivial_not_proj_perm`). The `SymPowInterface` header asserted this;
   nothing had checked it.
2. **The pair is inhabited at every `n`, not just `n = 1`**, in any cartesian monoidal
   category with the relevant colimit — `symPowData_of_hasColimit`. The interface's
   `n = 1`-only caveat was a statement about `K`, not about `n`.
3. **The obligation becomes a mathlib-shaped one.** "Construct `Sym^n C`" is replaced by
   `HasColimit (permDiagram C n)`. For the two categories checked here — `Type u` and
   affine `k`-schemes `(Under k)ᵒᵖ` — mathlib *already* discharges it, so the pair is
   inhabited there at every `n` with no new geometry (`symPowDataType`,
   `symPowDataAffine`).

## What is still open, stated precisely

`Sym^n C` for `C` a **proper** curve in `Over (Spec k̄)`. `Over (Spec k̄)` is not known to
have these colimits: the affine construction glues, and gluing is exactly the part of
Milne III.3.1 that this file does not do. The gain is not that the curve case is done —
it is that the remaining obligation is now one named instance about one named diagram,
the symmetry half is discharged permanently, and the affine case is *proved* rather than
scoped at hundreds of lines.

Note also the direction of the equivalence: because `SymPowData.isColimit` shows the pair
*is* a colimit, no future construction can supply the pair without supplying that colimit.
The reduction is therefore lossless — it cannot have replaced the problem with a
strictly harder one.

## References

Milne, *Abelian Varieties*, §III.3 Proposition 3.1 (the symmetric power), p. 94; §III.6
Proposition 6.1, p. 104. Blueprint `def:symmetric_power_curve`. The consumer is
`Albanese/AlbaneseFromData.lean`.
-/

set_option autoImplicit false

universe v u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace CategoryTheory

variable {K : Type u} [Category.{v} K] [CartesianMonoidalCategory K] [HasFiniteProducts K]

/-! ## §1. The permutation action as a diagram

`MonObj.permAut` (`Albanese/GrpObjFoldSum.lean`) gives the factor-permuting endomorphism
of `C^n`. Bundling it as a monoid homomorphism into `End (C^n)` turns the `S_n`-action
into a functor out of `SingleObj (Equiv.Perm (Fin n))`, which is the shape mathlib's
colimit API consumes.

One convention point worth stating, since it is the only place a sign can go wrong:
composition in `End X` is `f * g = g ≫ f`, so a *homomorphism* out of `Equiv.Perm (Fin n)`
must use `σ ↦ permAut C σ⁻¹`. With that inverse the multiplicativity is `rfl` after
projecting; without it one gets an anti-homomorphism. -/

/-- **The `S_n`-action on `C^n`, as a monoid homomorphism into `End (C^n)`.**

Sends `σ` to `permAut C σ⁻¹`. The inverse is forced by mathlib's `End` convention
(`f * g = g ≫ f`); see the section note. -/
noncomputable def permEnd (C : K) (n : ℕ) :
    Equiv.Perm (Fin n) →* End (∏ᶜ (fun _ : Fin n => C)) where
  toFun σ := MonObj.permAut C σ⁻¹
  map_one' := by
    apply Pi.hom_ext; intro i
    rw [MonObj.permAut_π]; simp
  map_mul' σ τ := by
    apply Pi.hom_ext; intro i
    change MonObj.permAut C (σ * τ)⁻¹ ≫ _ = (MonObj.permAut C τ⁻¹ ≫ MonObj.permAut C σ⁻¹) ≫ _
    rw [MonObj.permAut_π, Category.assoc, MonObj.permAut_π, MonObj.permAut_π]
    rfl

/-- **The permutation-action diagram.** The one-object diagram in `K` whose single value
is `C^n` and whose endomorphisms are the factor permutations. A colimit of it is the
quotient `C^n / S_n`. -/
noncomputable def permDiagram (C : K) (n : ℕ) : SingleObj (Equiv.Perm (Fin n)) ⥤ K :=
  SingleObj.functor (permEnd C n)

variable (C : K) (n : ℕ)

omit [CartesianMonoidalCategory K] in
/-- The diagram's value at the unique object is `C^n`. -/
theorem permDiagram_obj (j : SingleObj (Equiv.Perm (Fin n))) :
    (permDiagram C n).obj j = ∏ᶜ (fun _ : Fin n => C) := rfl

omit [CartesianMonoidalCategory K] in
/-- **The action, expressed as a diagram map.** `permAut C σ` is the diagram's map at
`σ⁻¹`; the double inverse is the `End`-convention bookkeeping of `permEnd`. This is the
bridge every proof below crosses. -/
theorem permAut_eq_map (σ : Equiv.Perm (Fin n)) :
    MonObj.permAut C σ = (permDiagram C n).map (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹) := by
  change MonObj.permAut C σ = MonObj.permAut C σ⁻¹⁻¹
  rw [inv_inv]

omit [CartesianMonoidalCategory K] in
/-- **Every cocone leg is symmetric.** This is the cocone condition `Cocone.w` read
through `permAut_eq_map`, and it is the reason the symmetry hypothesis of `SymPowData`
costs nothing on the colimit side. -/
theorem cocone_app_perm (c : Cocone (permDiagram C n)) (σ : Equiv.Perm (Fin n)) :
    MonObj.permAut C σ ≫ c.ι.app (SingleObj.star _) = c.ι.app (SingleObj.star _) := by
  rw [permAut_eq_map C n σ]
  exact c.w (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹)

/-- **A symmetric morphism out of `C^n` is a cocone.** The converse packaging of
`cocone_app_perm`: `S_n`-invariance of `h` is exactly the cocone condition. -/
noncomputable def symCocone {T : K} (h : (∏ᶜ (fun _ : Fin n => C)) ⟶ T)
    (hsym : ∀ σ : Equiv.Perm (Fin n), MonObj.permAut C σ ≫ h = h) :
    Cocone (permDiagram C n) where
  pt := T
  ι :=
    { app := fun _ => h
      naturality := by
        intro X Y f
        change MonObj.permAut C (f : Equiv.Perm (Fin n))⁻¹ ≫ h = h ≫ 𝟙 T
        rw [Category.comp_id]
        exact hsym _ }

/-! ## §2. A colimit of the action is a `SymPowData`, with symmetry for free

This is the forward half of the identification. Note which part is doing the work: the
universal property of `SymPowData` is `colimit.desc` plus `colimit.hom_ext`, and the
symmetry hypothesis `hproj` — the half that ruled out the trivial witness and had only
an `n = 1` witness before — is `colimit.w`. Nothing is assumed about `n`. -/

section OfColimit

variable [HasColimit (permDiagram C n)]

/-- **The symmetric power from a colimit of the permutation action.**

`carrier := colimit (permDiagram C n)`, `proj := colimit.ι`, and the universal property is
`colimit.desc` — a symmetric `h` is a cocone by `symCocone`, and uniqueness is
`colimit.hom_ext` on the one-object index category. -/
noncomputable def symPowOfColimit : SymPowData C n where
  carrier := colimit (permDiagram C n)
  proj := colimit.ι (permDiagram C n) (SingleObj.star _)
  desc := fun {T} h hsym => by
    have hd : colimit.ι (permDiagram C n) (SingleObj.star _)
        ≫ colimit.desc (permDiagram C n) (symCocone C n h hsym) = h :=
      colimit.ι_desc (symCocone C n h hsym) (SingleObj.star _)
    refine ⟨colimit.desc (permDiagram C n) (symCocone C n h hsym), hd, ?_⟩
    intro u hu
    exact colimit.hom_ext fun j => by
      obtain rfl : j = SingleObj.star _ := Subsingleton.elim _ _
      exact hu.trans hd.symm

omit [CartesianMonoidalCategory K] in
@[simp]
theorem symPowOfColimit_carrier :
    (symPowOfColimit C n).carrier = colimit (permDiagram C n) := rfl

omit [CartesianMonoidalCategory K] in
@[simp]
theorem symPowOfColimit_proj :
    (symPowOfColimit C n).proj = colimit.ι (permDiagram C n) (SingleObj.star _) := rfl

omit [CartesianMonoidalCategory K] in
/-- **The symmetry hypothesis, for free.** The projection of `symPowOfColimit` is
`S_n`-symmetric because that is the cocone condition `colimit.w`.

This is the declaration that changes the interface's status: `SymPowInterface.lean` needs
the *pair* `(D, hproj)`, and here `hproj` comes with the object at no cost and at every
`n`. -/
theorem symPowOfColimit_proj_perm (σ : Equiv.Perm (Fin n)) :
    MonObj.permAut C σ ≫ (symPowOfColimit C n).proj = (symPowOfColimit C n).proj := by
  have h := colimit.w (permDiagram C n) (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹)
  change MonObj.permAut C σ ≫ colimit.ι (permDiagram C n) (SingleObj.star _) = _
  rw [permAut_eq_map C n σ]
  exact h

omit [CartesianMonoidalCategory K] in
/-- **The pair, packaged.** Existence of the object the Albanese theorems quantify over,
in the form a call site consumes: a `SymPowData` *together with* its symmetry. -/
theorem symPowData_of_hasColimit :
    ∃ D : SymPowData C n, ∀ σ : Equiv.Perm (Fin n),
      MonObj.permAut C σ ≫ D.proj = D.proj :=
  ⟨symPowOfColimit C n, symPowOfColimit_proj_perm C n⟩

end OfColimit

/-! ## §3. Conversely: the pair *is* a colimit

The other half of the identification, and the one that makes the reduction lossless. Any
`SymPowData` whose projection is symmetric exhibits its carrier as a colimit of
`permDiagram C n`.

Consequence worth stating explicitly, because it is what rules out having traded the
problem for a harder one: nobody can supply the pair `(D, hproj)` *without* supplying this
colimit. So `HasColimit (permDiagram C n)` is not a sufficient condition that might be
stronger than needed — it is equivalent to the thing the Albanese argument consumes. -/

section ToColimit

/-- The cocone attached to a `SymPowData` with symmetric projection. -/
noncomputable def SymPowData.cocone (D : SymPowData C n)
    (hproj : ∀ σ : Equiv.Perm (Fin n), MonObj.permAut C σ ≫ D.proj = D.proj) :
    Cocone (permDiagram C n) where
  pt := D.carrier
  ι :=
    { app := fun _ => D.proj
      naturality := by
        intro X Y f
        change MonObj.permAut C (f : Equiv.Perm (Fin n))⁻¹ ≫ D.proj = D.proj ≫ 𝟙 _
        rw [Category.comp_id]
        exact hproj _ }

/-- **The pair is a colimit.** A `SymPowData` with symmetric projection is precisely a
colimit of the permutation action — its universal property *is* the colimit property,
transported across the fact that a cocone on a one-object diagram is a symmetric
morphism (`cocone_app_perm`). -/
noncomputable def SymPowData.isColimit (D : SymPowData C n)
    (hproj : ∀ σ : Equiv.Perm (Fin n), MonObj.permAut C σ ≫ D.proj = D.proj) :
    IsColimit (D.cocone C n hproj) where
  desc c := (D.desc (c.ι.app (SingleObj.star _)) (cocone_app_perm C n c)).choose
  fac c j := by
    obtain rfl : j = SingleObj.star _ := Subsingleton.elim _ _
    exact (D.desc (c.ι.app (SingleObj.star _)) (cocone_app_perm C n c)).choose_spec.1
  uniq c u hu :=
    (D.desc (c.ι.app (SingleObj.star _)) (cocone_app_perm C n c)).choose_spec.2 u
      (hu (SingleObj.star _))

omit [CartesianMonoidalCategory K] in
/-- **The obligation is exactly a `HasColimit`.** Supplying the pair the Albanese
theorems quantify over is equivalent to the diagram having a colimit — so replacing
"construct `Sym^n C`" by `HasColimit (permDiagram C n)` neither weakens nor strengthens
the problem. -/
theorem hasColimit_permDiagram_iff :
    HasColimit (permDiagram C n) ↔
      ∃ D : SymPowData C n, ∀ σ : Equiv.Perm (Fin n),
        MonObj.permAut C σ ≫ D.proj = D.proj := by
  refine ⟨fun _ => symPowData_of_hasColimit C n, fun ⟨D, hproj⟩ => ?_⟩
  exact ⟨⟨⟨D.cocone C n hproj, D.isColimit C n hproj⟩⟩⟩

end ToColimit

end CategoryTheory

/-! ## §4. The trivial witness is genuinely refuted at `n = 2`

`SymPowInterface.lean` keeps `symPowDataTrivial` (`proj := 𝟙`) as its acceptance test and
states that it fails the symmetry hypothesis for `n ≥ 2` "since it would force
`permAut C σ = 𝟙`". That was an *assertion*: nothing in the tree had exhibited a category
and an object where `permAut` at a transposition really differs from the identity, so the
argument for why the interface is not vacuous rested on an unchecked step.

It is checked here, concretely: `K = Type`, `C = Bool`, `n = 2`, `σ = swap 0 1`. Evaluating
both projections at the tuple `(true, false)` separates them. -/

namespace CategoryTheory

open Limits

/-- The tuple `(true, false)` in `Bool²`, as a `Type`-morphism out of `Bool`. Used only to
separate the two projections. -/
noncomputable def boolPairTuple : (Bool : Type) ⟶ (∏ᶜ fun _ : Fin 2 => (Bool : Type)) :=
  Pi.lift (P := (Bool : Type))
    (fun i : Fin 2 => TypeCat.ofHom (fun _ : Bool => decide (i = 0)))

/-- **`permAut` at a transposition is not the identity.** Witnessed in `Type` at `Bool`
and `n = 2`: composing with the `0`-th projection turns `permAut (swap 0 1) = 𝟙` into
`π₁ = π₀`, which the tuple `(true, false)` refutes.

This is the fact that makes `SymPowData`'s symmetry hypothesis non-vacuous for `n ≥ 2`. -/
theorem permAut_swap_ne_id :
    MonObj.permAut (Bool : Type) (Equiv.swap (0 : Fin 2) 1) ≠ 𝟙 _ := by
  intro hc
  have h0 := congrArg (fun f => f ≫ Pi.π (fun _ : Fin 2 => (Bool : Type)) 0) hc
  simp only [MonObj.permAut_π, Category.id_comp] at h0
  rw [Equiv.swap_apply_left] at h0
  have h1 := congrArg (fun f => boolPairTuple ≫ f) h0
  simp only [boolPairTuple, Pi.lift_π] at h1
  have h2 := congrArg
    (fun (f : (Bool : Type) ⟶ (Bool : Type)) => ConcreteCategory.hom f true) h1
  simp at h2

/-- **The trivial datum fails the symmetry hypothesis.** So `symPowDataTrivial` is not a
witness for the pair `(D, hproj)` at `n = 2`, and the `SymPowInterface` header's
contrastive claim is now a checked fact rather than a remark. -/
theorem symPowDataTrivial_not_proj_perm :
    ¬ (∀ σ : Equiv.Perm (Fin 2),
        MonObj.permAut (Bool : Type) σ ≫ (symPowDataTrivial (Bool : Type) 2).proj
          = (symPowDataTrivial (Bool : Type) 2).proj) := by
  intro h
  refine permAut_swap_ne_id ?_
  have h2 := h (Equiv.swap 0 1)
  change MonObj.permAut (Bool : Type) (Equiv.swap 0 1) ≫ 𝟙 _ = 𝟙 _ at h2
  rwa [Category.comp_id] at h2

end CategoryTheory

/-! ## §5. Where mathlib already discharges the obligation

Two categories where `HasColimit (permDiagram C n)` is available with no new geometry, so
the pair `(D, hproj)` is inhabited **at every `n`**:

* `Type u` — colimits of every shape;
* affine `k`-schemes, presented as `(Under k)ᵒᵖ`. This is the affine case of Milne III.3
  Proposition 3.1: dually the colimit is `Spec` of the ring of `S_n`-invariants of the
  `n`-fold tensor power, which is exactly Milne's `Spec (A^{⊗n})^{S_n}`. Mathlib supplies
  it through limits in `Under k`, so the affine half of that proposition needs no
  construction here.

What is *not* here is the curve case: `Over (Spec k̄)` with `C` proper. The gluing of the
affine quotients — the remaining half of Milne III.3.1 — is what would give that, and it
is the honest boundary. -/

namespace CategoryTheory

open Limits

/-- **Every `n`, in `Type`.** The symmetric power interface with its symmetry hypothesis,
inhabited at all `n` — `Type` has all colimits.

Contrast with `symPowDataOne`: that was `n = 1` only. Here `n` is arbitrary, so the
statements the Albanese argument quantifies over are non-vacuous in the range where the
group-law step is genuinely exercised. -/
theorem symPowData_type (X : Type u) (n : ℕ) :
    ∃ D : SymPowData X n, ∀ σ : Equiv.Perm (Fin n),
      MonObj.permAut X σ ≫ D.proj = D.proj :=
  symPowData_of_hasColimit X n

/-- **Every `n`, for affine `k`-schemes** — the affine case of Milne III.3 Proposition 3.1.

`(Under k)ᵒᵖ` is the category of affine `k`-schemes; its colimits are limits in
`Under k`, and dually the colimit of the permutation action on the `n`-fold coproduct is
`Spec` of the invariant subring of the `n`-fold tensor power. Mathlib has both, so this
holds with no construction. -/
theorem symPowData_affine (k : CommRingCat.{u}) (X : (Under k)ᵒᵖ) (n : ℕ) :
    letI : CartesianMonoidalCategory (Under k)ᵒᵖ := ofHasFiniteProducts
    ∃ D : SymPowData X n, ∀ σ : Equiv.Perm (Fin n),
      MonObj.permAut X σ ≫ D.proj = D.proj :=
  letI : CartesianMonoidalCategory (Under k)ᵒᵖ := ofHasFiniteProducts
  symPowData_of_hasColimit X n

end CategoryTheory
