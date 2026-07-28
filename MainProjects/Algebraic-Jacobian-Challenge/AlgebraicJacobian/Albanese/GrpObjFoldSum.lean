/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib

/-!
# The `g`-fold sum `C^g ⟶ A` and its permutation symmetry

Milne's proof of the Albanese universal property (*Abelian Varieties* III.6
Proposition 6.1) opens with "clearly this is symmetric, and so it factors
through `C^{(g)}`", where "this" is

`C^g ⟶ A`,  `(P₁, …, P_g) ↦ φ(P₁) + ⋯ + φ(P_g)`

for `φ : C ⟶ A` a morphism into an abelian variety. This file supplies that
morphism together with the content behind the word "clearly": its invariance
under permuting the `g` factors. It is the input that the universal property of
the symmetric power `Sym^g C` consumes.

## The mechanism: hom-sets into a group object are commutative monoids

The whole file rests on a Mathlib fact that makes the geometry evaporate. In a
cartesian monoidal category, `Mathlib/CategoryTheory/Monoidal/Cartesian/Mon.lean`
equips the hom-set `X ⟶ A` of a monoid object `A` with a `Monoid` structure
whose multiplication is *definitionally* `f * h = lift f h ≫ μ[A]`, and upgrades
it to a `CommMonoid` when `A` is a commutative monoid object (`IsCommMonObj`).
`Over (Spec k̄)` is cartesian monoidal and braided, and an abelian variety is a
commutative group object there.

So the `g`-fold sum is a `Finset.prod` of morphisms, its symmetry is
`Equiv.prod_comp`, and no hand-rolled induction over `Fin g` is needed. Stating
it this way is not a shortcut: it is the correct observation that Milne's
"clearly" is exactly the commutativity of `A`'s group law and nothing else.

## Main definitions

* `MonObj.preHom` — precomposition `(X ⟶ A) →* (W ⟶ A)` as a monoid
  homomorphism. Mathlib gives the hom-set its monoid structure but does not
  record that precomposition respects it; this is what lets `map_prod` move a
  precomposition through the products below.
* `MonObj.permAut` — the automorphism of `∏ᶜ (fun _ : Fin n => C)` permuting the
  factors along `σ : Equiv.Perm (Fin n)`.
* `MonObj.powSum` — the morphism `∏ᶜ (fun _ : Fin n => C) ⟶ A` sending
  `(P₁, …, P_n) ↦ φ(P₁) * ⋯ * φ(P_n)`, i.e. the product over `i : Fin n` of the
  projections composed with `φ`.

## Main results

* `MonObj.powSum_perm` — **`powSum` is `S_n`-symmetric**:
  `permAut C σ ≫ powSum n φ = powSum n φ`. This is Milne's "clearly this is
  symmetric", and the hypothesis the symmetric-power universal property consumes.
* `MonObj.comp_powSum` — `powSum` is natural in the source.

## Instantiating this at an abelian variety

`powSum` requires `[IsCommMonObj A]`, which is *load-bearing*: without it the
hom-set is only a `Monoid`, the `∏` notation cannot be written, and the symmetry
is false. It is **not** obtained by synthesis, but it *is* available as a theorem on
the project's standard abelian-variety package — use

```
letI := isCommMonObj_of_isProper_smooth_of_package A
```

(`AlgebraicGeometry.isCommMonObj_of_isProper_smooth_of_package`,
`Albanese/AVSelfProduct.lean`: Milne §I.1 Corollary 1.4, proved from the Rigidity
Lemma, with the three `A ⊗ A` side conditions discharged).

Earlier revisions of this note said the project *could not* supply `IsCommMonObj`,
because `isCommMonObj_of_isProper_smooth` (`Albanese/AVCommutative.lean`) carries
hypotheses `[GeometricallyIrreducible (A ⊗ A).hom] [LocallyOfFiniteType (A ⊗ A).hom]
[IsReduced (A ⊗ A).left]` that synthesis cannot discharge. That was a statement about
instance **keying**, not about the mathematics: `(A ⊗ A).hom` is reducibly
`pullback.fst A.hom A.hom ≫ A.hom` (`Over.tensorObj_hom`), and one rewrite puts each
goal in a form mathlib's own instances solve. See `Albanese/AVSelfProduct.lean`.

## Scope

This file deliberately stops at the symmetry statement. It does **not** construct
`Sym^n C`: at this Mathlib pin there is no quotient of a scheme by a finite group
action. (`analogies/m3-route-audit.md` scoped that construction at roughly 2400–3800 lines;
treat the figure as **historical** — `Albanese/SymPowColimit.lean` since reduced the
obligation to one `HasColimit` instance and discharged the affine-algebra half outright.)
What is supplied here is the *input* to the symmetric
power's universal property, which is the half of Milne's symmetrisation step that
does not depend on the quotient existing.

The other half now has a home: `Albanese/SymPowInterface.lean` takes that universal
property as **data** (`SymPowData`) and uses `powSum_perm` below to turn Milne's
`Sym^n φ` into a construction. The quotient is still missing as an *object*, but no
statement downstream of it is a statement about a `sorry` any more.

## References

Milne, *Abelian Varieties*, §III.6 Proposition 6.1, p. 104; blueprint
`lem:symmetric_product_av_map` in
`blueprint/src/chapters/Albanese_AlbaneseUP.tex`.
-/

set_option autoImplicit false

universe v u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace CategoryTheory.MonObj

variable {K : Type u} [Category.{v} K] [CartesianMonoidalCategory K]

/-! ## §0. Precomposition is a monoid homomorphism on hom-sets

`Mathlib/CategoryTheory/Monoidal/Cartesian/Mon.lean` gives `X ⟶ A` its monoid
structure with `f * h = lift f h ≫ μ[A]` and `1 = toUnit X ≫ η[A]`, but does not
record that *precomposition* respects it. It does, and bundling it as a
`MonoidHom` is what lets `map_prod` move a precomposition through the finite
products below. -/

/-- **Precomposition with `u : W ⟶ X`, as a monoid homomorphism**
`(X ⟶ A) →* (W ⟶ A)`. Multiplicativity is `comp_lift` (a lift precomposed is the
lift of the precompositions); unitality is uniqueness of the map to the unit
object. -/
noncomputable def preHom {A X W : K} [MonObj A] (u : W ⟶ X) : (X ⟶ A) →* (W ⟶ A) where
  toFun f := u ≫ f
  map_one' := by
    change u ≫ (toUnit X ≫ η[A]) = toUnit W ≫ η[A]
    rw [← Category.assoc]
    congr 1
    exact Subsingleton.elim _ _
  map_mul' f h := by
    change u ≫ (lift f h ≫ μ[A]) = lift (u ≫ f) (u ≫ h) ≫ μ[A]
    rw [← Category.assoc, comp_lift]

@[simp]
theorem preHom_apply {A X W : K} [MonObj A] (u : W ⟶ X) (f : X ⟶ A) :
    preHom u f = u ≫ f := rfl

section PermAut

variable [HasFiniteProducts K]

/-- **The factor-permuting automorphism of `C^n`.** For `σ : Equiv.Perm (Fin n)`,
the morphism `C^n ⟶ C^n` whose `i`-th component is the `σ i`-th projection; on
points, `(P₁, …, P_n) ↦ (P_{σ 1}, …, P_{σ n})`. -/
noncomputable def permAut (C : K) {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    (∏ᶜ (fun _ : Fin n => C)) ⟶ (∏ᶜ (fun _ : Fin n => C)) :=
  Pi.lift (fun i => Pi.π (fun _ : Fin n => C) (σ i))

omit [CartesianMonoidalCategory K] in
@[reassoc (attr := simp)]
theorem permAut_π (C : K) {n : ℕ} (σ : Equiv.Perm (Fin n)) (i : Fin n) :
    permAut C σ ≫ Pi.π (fun _ : Fin n => C) i = Pi.π (fun _ : Fin n => C) (σ i) := by
  simp only [permAut, Pi.lift_π]

end PermAut

section PowSum

variable [HasFiniteProducts K] [BraidedCategory K]

/-- **The `n`-fold sum morphism `C^n ⟶ A`.** For `φ : C ⟶ A` into a commutative
group object, the morphism sending `(P₁, …, P_n) ↦ φ(P₁) * ⋯ * φ(P_n)`, formed as
the product in the commutative monoid `(C^n ⟶ A)` of the projections composed
with `φ`.

In the Albanese application `A` is an abelian variety and the group law is
written additively: this is `(P₁, …, P_g) ↦ φ(P₁) + ⋯ + φ(P_g)`. -/
noncomputable def powSum {C A : K} [MonObj A] [IsCommMonObj A] (n : ℕ) (φ : C ⟶ A) :
    (∏ᶜ (fun _ : Fin n => C)) ⟶ A :=
  ∏ i, (Pi.π (fun _ : Fin n => C) i ≫ φ)

/-- **Milne's "clearly this is symmetric".** The `n`-fold sum is invariant under
permuting the factors of `C^n`. The proof is exactly the commutativity of the
group law of `A`: in the *commutative* monoid `(C^n ⟶ A)` a finite product is
invariant under reindexing (`Equiv.prod_comp`).

This is the hypothesis consumed by the universal property of the symmetric power
`Sym^n C`, which is what licenses the factorisation `C^n ⟶ Sym^n C ⟶ A`. -/
theorem powSum_perm {C A : K} [MonObj A] [IsCommMonObj A] (n : ℕ) (φ : C ⟶ A)
    (σ : Equiv.Perm (Fin n)) :
    permAut C σ ≫ powSum n φ = powSum n φ := by
  classical
  calc permAut C σ ≫ powSum n φ
      = ∏ i, (permAut C σ ≫ Pi.π (fun _ : Fin n => C) i ≫ φ) :=
        map_prod (preHom (permAut C σ)) _ Finset.univ
    _ = ∏ i, (Pi.π (fun _ : Fin n => C) (σ i) ≫ φ) :=
        Finset.prod_congr rfl fun i _ => by rw [← Category.assoc, permAut_π]
    _ = ∏ i, (Pi.π (fun _ : Fin n => C) i ≫ φ) :=
        Equiv.prod_comp σ (fun i => Pi.π (fun _ : Fin n => C) i ≫ φ)

/-- `powSum` is natural in the source: precomposition distributes over the sum. -/
theorem comp_powSum {C A W : K} [MonObj A] [IsCommMonObj A] (n : ℕ) (φ : C ⟶ A)
    (u : W ⟶ (∏ᶜ (fun _ : Fin n => C))) :
    u ≫ powSum n φ = ∏ i, (u ≫ Pi.π (fun _ : Fin n => C) i ≫ φ) := by
  classical
  exact map_prod (preHom u) _ Finset.univ

end PowSum

end CategoryTheory.MonObj
