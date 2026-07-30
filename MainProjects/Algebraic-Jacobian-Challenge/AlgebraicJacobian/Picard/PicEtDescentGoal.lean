/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import AlgebraicJacobian.Picard.GaloisDescent.PicEtGaloisAction
import AlgebraicJacobian.Picard.PicEtDescentRepresentability
import AlgebraicJacobian.Picard.PicEtSeparated

/-!
# THE DESCENT GOAL: `k'`-side representability + a Galois quotient ⟹ clause (1) over `k`

`AJC.picrep.etale-rep.descent-assembly`.

## The defect this file addresses, quoted rather than paraphrased

`Picard/FGAPicRepresentability.lean` says, of the four inputs of the étale-descent
repair:

> **And a list of inputs is not a route.** Every entry below is an *antecedent*.
> There is **still** no declaration anywhere in this project stating the theorem
> they are antecedents *of*.

`I-1312` refuted the one file that had claimed to supply such a statement
(`Picard/PicEtDescentAssembly.lean`'s `representableByRestrict_of_baseChange`
concludes a `RepresentableBy` for a `k'`-**object**, i.e. restates the `k'`-side
input in the right variables rather than crossing the descent step). This file
states and proves that theorem.

Its shape, and the reason it is not `P → P`: the hypothesis is a representation of
`picEt (C_{k'})` — the Picard functor of the **base-changed** curve, over `k'` —
plus a Galois quotient of the resulting action. The conclusion is a representation
of `picEt C`, the functor over `k` whose representability is field 1 of the seam's
clause (1). Neither the conclusion nor `HasPicSchemeEt C` occurs in any hypothesis.

## What composes, and where each piece comes from

Four files hold the pieces; nothing joined them.

1. `GaloisDescent/PicEtGaloisAction.lean` — `semilinearGalActionOfRepresentableBy`
   makes the semilinear Galois action **free from `rep`**, so the quotient
   hypothesis is about an action the representation already determines.
2. `PicEtQuotientHom.lean` — `quotientHomEquiv_uniform` turns clause 3 of
   `IsGaloisQuotient` into `Hom_k(T, Y) ≃ {equivariant T_{k'} ⟶ X'}`, uniformly in
   `T` (the per-test `Nonempty` cannot carry a naturality square; the uniform one
   can).
3. `rep` itself — the second leg `{equivariant T_{k'} ⟶ X'} → picEt(C_{k'})(T_{k'})`
   with `range_equivariantToClass` characterising its image.
4. `PicEtDescentRepresentability.lean` — `representableBy_of_galInvariantEquiv`
   takes a natural family of `Equiv`s onto the `Γ`-**invariant** classes on `T_{k'}`
   and concludes `(picEt C).RepresentableBy Y`.

So the composite needs the two ends to meet, and what stands between them is
exactly the predicate match `G1` owes: leg 3's image is
`{c | rep.homEquiv.symm c is Γ-equivariant}` while leg 4 consumes
`{c | c is a Γ-invariant picEt-class}`. That match is **carried here as one named
explicit hypothesis** (`IsInvariantMatch`), not absorbed and not proved: it is
`AJC.picrep.etale-rep.invariance`, and `hcov` is `AJC.picrep.etale-rep.hcov`
(`pic-a`'s row this round).

## What this does NOT do

* It does **not** close `Scheme.fgaPicardRepresentability`. `rep` is a hypothesis —
  the Milne–Kollár campaign's undischarged output — and clause (1) field 1 is
  witnessed for **no** curve. This file is used in its own verification with that
  theorem as a `sorryAx` control.
* It witnesses **no** antecedent of the seam. It converts four antecedents plus one
  named predicate match into the seam's conclusion; the antecedents stay open.
* Per `I-0491` there is no `HasRationalPoint` binder anywhere in this file.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Limits Opposite
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §1. The predicate match `G1` owes, as a named hypothesis -/

/-- **The `G1` predicate match, named.**

Leg 3 of the descent composite lands on the classes whose representing morphism is
`Γ`-equivariant (`range_equivariantToClass`); leg 4 consumes the classes that are
`Γ`-**invariant** in the sense of `IsGalInvariant`. This is the statement that the
two predicates agree — two predicates on one object, which is all that campaign
`G1` is owed on this route (`Picard/PicEtQuotientHom.lean`, module docstring).

It is carried as an explicit hypothesis of everything below and is **not proved
here**. Stated as a definition so that a lane closing `G1` has a name to discharge
and so that the composite's obligations are countable rather than inlined. -/
def IsInvariantMatch (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    (T : Over (Spec (CommRingCat.of k))) : Prop :=
  ∀ c : (picEt (Scheme.baseChangeField C k')).obj (op (baseTest (k' := k') T)),
    (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ (rep.homEquiv.symm c).left
      ↔ IsGalInvariant (k' := k') C T
          ((picEt_crossBaseIso C k').hom.app (op (baseTest (k' := k') T)) c)

/-! ## §2. The descent class of a `k`-morphism, and its naturality

The composite must be built from the **explicit** forward map of `IsGaloisQuotient`
clause 3, not from `(quotientHomEquiv …).some`: a `Nonempty` of a per-test `Equiv`
gives no function `T ↦ e T`, hence no naturality square, hence no
`RepresentableBy` (`Picard/PicEtQuotientHom.lean`, `I-1405`). So this section works
with the structural iso `e` of the quotient directly. -/

section DescentClass

variable {C : Over (Spec (CommRingCat.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  {X' : Over (Spec (CommRingCat.of k'))}
  (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
  {Y : Over (Spec (CommRingCat.of k))}
  (e : Limits.pullback Y.hom (specMapAlgebra k k') ≅ X'.left)
  (he : e.hom ≫ X'.hom = pullback.snd Y.hom (specMapAlgebra k k'))

/-- **The `k'`-side test morphism of a `k`-morphism `u : T ⟶ Y`**: base-change `u`
along `k ⊆ k'` and compare along the quotient's structural iso. This is the forward
map of `IsGaloisQuotient` clause 3, written explicitly. -/
noncomputable def quotientIsoOver : (Over.pullback (specMapAlgebra k k')).obj Y ⟶ X' :=
  Over.homMk e.hom he

noncomputable def descentMor (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    baseTest (k' := k') T ⟶ X' :=
  (Over.pullback (specMapAlgebra k k')).map u ≫ quotientIsoOver e he

/-- **The underlying map of `descentMor` is the one `IsGaloisQuotient` clause 3
speaks about**: `pullbackBaseChange` of `u` followed by the structural iso. The two
spellings of "base change of a slice morphism" — mathlib's `Over.pullback` functor
and the project's `pullbackBaseChange` — agree, and this is the bridge. -/
theorem descentMor_left (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    (descentMor e he T u).left
      = pullbackBaseChange k k' Y.hom T.hom u.left (Over.w u) ≫ e.hom := by
  refine congrArg (· ≫ e.hom) ?_
  have hL : ((Over.pullback (specMapAlgebra k k')).map u).left
      = Limits.pullback.lift
          (Limits.pullback.fst T.hom (specMapAlgebra k k') ≫ u.left)
          (Limits.pullback.snd T.hom (specMapAlgebra k k'))
          (by simp [Limits.pullback.condition, Over.w u]) := rfl
  refine hL.trans (Limits.pullback.hom_ext ?_ ?_)
  · rw [Limits.pullback.lift_fst, pullbackBaseChange_fst]
  · rw [Limits.pullback.lift_snd, pullbackBaseChange_snd]

/-- **The descent class**: the `picEt C`-class on `T_{k'}` that `u : T ⟶ Y`
determines, via `rep` and the cross-base identification. -/
noncomputable def descentClass (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    (picEt C).obj (op ((coverFunctor (k := k) (k' := k')).obj T)) :=
  (picEt_crossBaseIso C k').hom.app (op (baseTest (k' := k') T))
    (rep.homEquiv (descentMor e he T u))

/-- **`descentMor` is functorial in the test.** The base change of a composite is
the composite of the base changes (`pullbackBaseChange_comp`), and the `k'`-side
leg of `coverFunctor.map f` **is** the base change of `f`. -/
theorem descentMor_comp {T T' : Over (Spec (CommRingCat.of k))}
    (f : T ⟶ T') (g : T' ⟶ Y) :
    descentMor e he T (f ≫ g)
      = ((Over.pullback (specMapAlgebra k k')).map f) ≫ descentMor e he T' g := by
  change (Over.pullback (specMapAlgebra k k')).map (f ≫ g) ≫ quotientIsoOver e he
      = _ ≫ (Over.pullback (specMapAlgebra k k')).map g ≫ quotientIsoOver e he
  rw [Functor.map_comp]
  exact Category.assoc _ _ _

end DescentClass

/-! ## §3. The composite Equiv at one test -/

/-- **Leg 1 ∘ leg 3, as an `Equiv` onto the `Γ`-invariant classes on `T_{k'}`,
given the `G1` match.**

`Hom_k(T, Y) ≃ {equivariant T_{k'} ⟶ X'} ≃ {equivariant-image classes}
             = {Γ-invariant classes}`,

where the first step is clause 3 of `IsGaloisQuotient`
(`homEquiv_equivariant_of_galoisQuotient`), the second is `rep` restricted to its
image (`range_equivariantToClass`), and the third is the hypothesis
`IsInvariantMatch` transported along `picEt_crossBaseIso`. -/
noncomputable def galInvariantEquivOfQuotient
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (hq : IsGaloisQuotient ρ Y.hom)
    (hmatch : ∀ T, IsInvariantMatch C rep ρ T)
    (T : Over (Spec (CommRingCat.of k))) :
    (T ⟶ Y) ≃ GalInvariant (k' := k') C T := by
  refine (homEquiv_equivariant_of_galoisQuotient ρ hq T).some.trans ?_
  -- the subtype of bare equivariant morphisms is the subtype of slice morphisms
  have eA : {h : pullback T.hom (specMapAlgebra k k') ⟶ X'.left //
        h ≫ X'.hom = pullback.snd T.hom (specMapAlgebra k k') ∧
          (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ h} ≃
      {φ : baseTest (k' := k') T ⟶ X' //
        (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ φ.left} := by
    have hw : ∀ φ : baseTest (k' := k') T ⟶ X',
        φ.left ≫ X'.hom = pullback.snd T.hom (specMapAlgebra k k') := fun φ => Over.w φ
    let inv : {φ : baseTest (k' := k') T ⟶ X' //
          (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ φ.left} →
        {h : pullback T.hom (specMapAlgebra k k') ⟶ X'.left //
          h ≫ X'.hom = pullback.snd T.hom (specMapAlgebra k k') ∧
            (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ h} :=
      fun φ => ⟨φ.1.left, hw φ.1, φ.2⟩
    exact
      { toFun := fun h => ⟨Over.homMk h.1 h.2.1, h.2.2⟩
        invFun := inv
        left_inv := fun _ => rfl
        right_inv := fun φ =>
          Subtype.ext (CategoryTheory.Over.homMk_eta φ.1 (hw φ.1)) }
  refine eA.trans (Equiv.trans ?_
    (Equiv.subtypeEquiv
      ((picEt_crossBaseIso C k').app (op (baseTest (k' := k') T))).toEquiv
      (fun c => hmatch T c)))
  exact Equiv.subtypeEquiv rep.homEquiv (fun _ => by rw [Equiv.symm_apply_apply])

/-- The underlying class of `galInvariantEquivOfQuotient` is `rep.homEquiv` of the
equivariant morphism, transported across the cross-base identification. Unfolded
here once so the naturality proof below can work with the components. -/
theorem galInvariantEquivOfQuotient_val
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (hq : IsGaloisQuotient ρ Y.hom)
    (hmatch : ∀ T, IsInvariantMatch C rep ρ T)
    (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    (galInvariantEquivOfQuotient C rep ρ hq hmatch T u).1
      = (picEt_crossBaseIso C k').hom.app (op (baseTest (k' := k') T))
          (rep.homEquiv (Over.homMk
            ((homEquiv_equivariant_of_galoisQuotient ρ hq T).some u).1
            ((homEquiv_equivariant_of_galoisQuotient ρ hq T).some u).2.1)) :=
  rfl

end PicScheme

end Scheme

end AlgebraicGeometry
