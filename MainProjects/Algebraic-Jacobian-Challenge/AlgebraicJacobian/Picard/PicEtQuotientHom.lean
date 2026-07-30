/-
Copyright (c) 2026 Archon Horizon contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.FiniteGaloisQuotient
import AlgebraicJacobian.Picard.PicEtDescentAssembly

/-!
# The Hom-side of the étale descent goal

`Picard/FGAPicRepresentability.lean` records, at `:475`, that the seam's
four-input paragraph lists *antecedents* and that **no declaration in this
project states the theorem they are antecedents of**; `I-1312` refuted the one
claim that `Picard/PicEtDescentAssembly.lean` supplied such a statement, and that
file's own §4 says the same. This file states and proves the part of that missing
goal which is **not** `P → P`.

## What is here, and why it is not a restatement of a hypothesis

The obstruction §4 of `PicEtDescentAssembly.lean` correctly identifies is that an
implication whose antecedent reads "the `k`-scheme exists with its properties" has
its own conclusion as a hypothesis. That is a fact about the *object* side of the
descent. The **Hom** side is different: clause 3 of
`AlgebraicJacobian.GaloisDescent.IsGaloisQuotient` already *asserts* a unique
descent of equivariant morphisms, and no declaration in the project extracts it
as the bijection

```
Hom_K(T, Y)  ≃  { equivariant  T_L ⟶ X  over  Spec L }
```

that the phrase "`Hom_K(T, Y) ≅ Hom_L(T_L, X)^Γ`" in that clause's own docstring
names. `quotientHomEquiv` below is that extraction, and
`picEtQuotientHomEquiv` composes it with a `k'`-side representation of
`picEt (C_{k'})` to land on **classes of the curve**: for every `k`-test `T`,

```
Hom_k(T, Y)  ≃  { equivariant  T_{k'} ⟶ X' }  →  picEt(C_{k'})(T_{k'})
```

with the first map a bijection and the second the representation's `homEquiv`.

## Three things this does NOT claim

* **It does not close the seam.** `Scheme.fgaPicardRepresentability` is untouched
  and is used here only as a `sorryAx` control. Clause (1)'s field 1 is witnessed
  for no curve, and the `k'`-side representation is a **hypothesis** of every
  statement below, not a produced object — it is the Milne–Kollár campaign's
  undischarged output.
* **It is not the invariance step.** The right-hand side above is
  *`Γ`-equivariant morphisms*, not *`Γ`-invariant `picEt`-classes*. Matching those
  two predicates is `G1`, roadmap `AJC.picrep.etale-rep.invariance` (`ajc-p2`),
  and is deliberately left as the named residue rather than assumed. §3 states
  precisely what remains.
* **`IsGaloisQuotient` is `Prop`-valued**, so `quotientHomEquiv` must conclude
  `Nonempty (… ≃ …)`: `Exists.casesOn` cannot eliminate into `Type`. Measured, not
  worked around — the data-valued form is *unprovable* from this hypothesis, and a
  lane wanting the `Equiv` itself must strengthen `IsGaloisQuotient` to a
  structure. That is recorded here because it is a fact about the project's own
  gate, not about this file.

## What the proofs use, measured

`quotientHomEquiv` does **not** use `[FiniteDimensional K L]` or `[IsGalois K L]`
— the linter flags both as unused, and they are `omit`ted below. The clause-3
content is a bijection between a `∃!` and its own witness set; finiteness and
Galois-ness of `L/K` enter `IsGaloisQuotient`'s *inhabitation*
(`HasGaloisQuotient`), never this extraction. So a lane pricing this step should
not budget any field theory for it.
-/

universe u

open CategoryTheory AlgebraicGeometry Limits

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

open AlgebraicJacobian.GaloisDescent

section QuotientHom

variable {K L : Type u} [Field K] [Field L] [Algebra K L]

/-- **Clause 3 of `IsGaloisQuotient`, extracted as the bijection its own docstring
names**: for every `K`-test `T`, morphisms `T ⟶ Y` over `Spec K` correspond to
`Γ`-equivariant morphisms `T_L ⟶ X` over `Spec L`.

The forward map is `u ↦ (u ×_K L) ≫ e.hom`, i.e. base-change the descended
morphism and compare along the quotient's structural isomorphism. Injectivity and
surjectivity are the uniqueness and existence halves of clause 3's `∃!`.

`Nonempty` rather than a bare `≃` is forced: `IsGaloisQuotient` is a `Prop`, so
its witness `e` cannot be eliminated into `Type`. See the module docstring.

**No field-theoretic hypothesis is used** — neither `[FiniteDimensional K L]` nor
`[IsGalois K L]` appears, and neither is needed. -/
theorem quotientHomEquiv {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (ρ : SemilinearGalAction K L X f) {Y : Scheme.{u}}
    {g : Y ⟶ Spec (CommRingCat.of K)} (hq : IsGaloisQuotient ρ g)
    (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of K)) :
    Nonempty ({u : T ⟶ Y // u ≫ g = t} ≃
      {h : pullback t (Spec.map (CommRingCat.ofHom (algebraMap K L))) ⟶ X //
        h ≫ f = pullback.snd t (Spec.map (CommRingCat.ofHom (algebraMap K L))) ∧
          (pullbackSemilinearGalAction K L t).IsEquivariant ρ h}) := by
  obtain ⟨e, he, heq, huniv⟩ := hq
  refine ⟨Equiv.ofBijective
    (fun u => ⟨pullbackBaseChange K L g t u.1 u.2 ≫ e.hom, ?_, ?_⟩) ⟨?_, ?_⟩⟩
  · rw [Category.assoc, he, pullbackBaseChange_snd]
  · exact SemilinearGalAction.isEquivariant_pullbackBaseChange_comp (g := g) (t := t) ρ
      (he := heq) u.1 u.2
  · intro a b hab
    obtain ⟨w, hw, hwu⟩ := huniv T t (pullbackBaseChange K L g t b.1 b.2 ≫ e.hom)
      (by rw [Category.assoc, he, pullbackBaseChange_snd])
      (SemilinearGalAction.isEquivariant_pullbackBaseChange_comp (g := g) (t := t) ρ
        (he := heq) b.1 b.2)
    exact (hwu _ (congrArg Subtype.val hab)).trans (hwu _ rfl).symm
  · rintro ⟨h, hhf, hheq⟩
    obtain ⟨w, hw, -⟩ := huniv T t h hhf hheq
    exact ⟨w, Subtype.ext hw⟩

/-- **`Over`-homs are the subtype of scheme morphisms commuting with the structure
maps.** Pure bookkeeping (`Over.w` one way, `Over.homMk` the other), recorded
because it is the bridge between `quotientHomEquiv`, which is stated on bare
schemes because `IsGaloisQuotient` is, and the `Over (Spec k)`-tests that `picEt`
is a functor on. -/
noncomputable def overHomEquivSubtype {k : Type u} [Field k]
    (T Y : Over (Spec (CommRingCat.of k))) :
    (T ⟶ Y) ≃ {u : T.left ⟶ Y.left // u ≫ Y.hom = T.hom} where
  toFun φ := ⟨φ.left, Over.w φ⟩
  invFun u := Over.homMk u.1 u.2
  left_inv φ := by ext; rfl
  right_inv u := by ext; rfl

end QuotientHom

/-! ## §2. Composing with the `k'`-side representation: down to classes of the curve -/

section CurveClasses

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-- **`quotientHomEquiv` in the slice**: for a semilinear action on `X'.left` with
Galois quotient `Y`, morphisms `T ⟶ Y` *in `Over (Spec k)`* correspond to
`Γ`-equivariant `T_{k'} ⟶ X'.left` over `Spec k'`.

`quotientHomEquiv` composed with `overHomEquivSubtype`. This is the form the
descent goal needs, because `picEt` is a functor on `Over (Spec k)` while
`IsGaloisQuotient` is stated on bare schemes.

**No curve occurs here, and that is deliberate.** An earlier draft of this
declaration bound `C` with its two curve instances; `C` did not appear in the
conclusion, which is exactly the `HasDivFunctor` failure mode protection `I-0838`
names. The binder is removed rather than justified: this statement is about the
action and the quotient, nothing else. The curve enters at
`equivariantToClass` and at `homClassMap_of_galoisQuotient` below, where it
occurs in the conclusion. -/
theorem homEquiv_equivariant_of_galoisQuotient
    {X' : Over (Spec (CommRingCat.of k'))}
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (hq : AlgebraicJacobian.GaloisDescent.IsGaloisQuotient ρ Y.hom)
    (T : Over (Spec (CommRingCat.of k))) :
    Nonempty ((T ⟶ Y) ≃
      {h : pullback T.hom (specMapAlgebra k k') ⟶ X'.left //
        h ≫ X'.hom = pullback.snd T.hom (specMapAlgebra k k') ∧
          (AlgebraicJacobian.GaloisDescent.pullbackSemilinearGalAction k k'
            T.hom).IsEquivariant ρ h}) := by
  obtain ⟨φ⟩ := quotientHomEquiv ρ hq T.left T.hom
  exact ⟨(overHomEquivSubtype T Y).trans φ⟩

/-- **The second leg**: an equivariant `T_{k'} ⟶ X'.left` over `Spec k'` gives a
`picEt (C_{k'})`-class on the base-changed test, by the representation's own
`homEquiv`.

The equivariance is *discarded* here on purpose — that is precisely the
information `G1` must recover, and stating the leg without it is what makes the
residue visible instead of hidden inside a bundled claim.

It is nonetheless **injective** (`equivariantToClass_injective`): forgetting
equivariance loses no morphisms, only cuts down the target. -/
noncomputable def equivariantToClass
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (PicScheme.picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    (T : Over (Spec (CommRingCat.of k)))
    (h : {h : pullback T.hom (specMapAlgebra k k') ⟶ X'.left //
        h ≫ X'.hom = pullback.snd T.hom (specMapAlgebra k k') ∧
          (AlgebraicJacobian.GaloisDescent.pullbackSemilinearGalAction k k'
            T.hom).IsEquivariant ρ h}) :
    (PicScheme.picEt (Scheme.baseChangeField C k')).obj
      (Opposite.op (PicScheme.baseTest (k' := k') T)) :=
  rep.homEquiv (Over.homMk h.1 h.2.1)

/-- **The second leg is injective.** `rep.homEquiv` is an equivalence and
`Over.homMk` is injective in its underlying map, so forgetting equivariance
does not merge two morphisms — it only fails to be *surjective*.

This sharpens the residue and is the reason the composite below is injective
rather than merely a map: what `G1` owes is not injectivity but the
**characterisation of the image**, i.e. which `picEt (C_{k'})`-classes are
`Γ`-invariant. An earlier draft of this file's docstrings said only "the second leg
is a map, not a bijection", which is true and leaves the reader to guess which half
fails; this measures it. -/
theorem equivariantToClass_injective
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (PicScheme.picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    (T : Over (Spec (CommRingCat.of k))) :
    Function.Injective (equivariantToClass C rep ρ T) := by
  intro a b hab
  have h1 : (Over.homMk a.1 a.2.1 : PicScheme.baseTest (k' := k') T ⟶ X')
      = Over.homMk b.1 b.2.1 := rep.homEquiv.injective hab
  exact Subtype.ext (congrArg CategoryTheory.Over.Hom.left h1)

/-- **The Hom-side of the descent goal, with the curve in the conclusion.**

For a smooth proper curve `C` over an **arbitrary** field `k`, a field extension
`k'/k`, a `k'`-scheme `X'` **representing** `picEt (C_{k'})`, a semilinear
`Gal`-action on `X'.left`, and a `k`-scheme `Y` that is its Galois quotient: there
is a map

```
Hom_{Over (Spec k)}(T, Y)  ⟶  picEt (C_{k'}) (T_{k'})
```

for every `k`-test `T`, factoring as a **bijection** onto `Γ`-equivariant
morphisms followed by the representation's `homEquiv`. This is the statement the
seam's four-input paragraph (`Picard/FGAPicRepresentability.lean:475`) lists
antecedents *of*, on its Hom side, and it is the shape the descent step must
upgrade.

**Exactly which half is owed, measured rather than hedged.** The first leg is a
bijection (`homEquiv_equivariant_of_galoisQuotient`, from `IsGaloisQuotient`
clause 3) and the second leg is **injective**
(`equivariantToClass_injective`), so the whole composite is injective
(`homClassMap_of_galoisQuotient_injective`). What is missing is **surjectivity onto
the `Γ`-invariant classes** — the characterisation of the image, which is campaign
`G1`, roadmap `AJC.picrep.etale-rep.invariance` (`ajc-p2`). Do **not** read this
as a representation of `picEt C`: it is an injection into the classes of the
base-changed curve, and even a bijection onto the invariants would still need the
amalgamation of `Picard/EtaleFieldCover.lean` to descend to `picEt C (T)`.

**Three things this does not do.**
* It does not close or weaken `Scheme.fgaPicardRepresentability`, which is used in
  this file's verification only as a `sorryAx` control.
* `rep` is a **hypothesis**, the campaign's undischarged output; field 1 of clause
  (1) is witnessed for no curve, so nothing here is instantiable at a curve today.
* It carries no `HasRationalPoint` binder (`I-0491`), and no separability or
  finiteness hypothesis on `k'/k` — none is used. -/
noncomputable def homClassMap_of_galoisQuotient
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (PicScheme.picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (hq : AlgebraicJacobian.GaloisDescent.IsGaloisQuotient ρ Y.hom)
    (T : Over (Spec (CommRingCat.of k))) :
    (T ⟶ Y) → (PicScheme.picEt (Scheme.baseChangeField C k')).obj
      (Opposite.op (PicScheme.baseTest (k' := k') T)) :=
  fun φ => equivariantToClass C rep ρ T
    ((homEquiv_equivariant_of_galoisQuotient ρ hq T).some φ)

/-- **The composite is injective**: distinct `k`-morphisms `T ⟶ Y` give distinct
`picEt (C_{k'})`-classes on `T_{k'}`.

Both legs are injective, so this is their composition. It is the strongest
statement available without `G1`: a Galois quotient of a `k'`-representation
**embeds** its `k`-points into the classes of the base-changed curve, for every
test, over an arbitrary field. What remains for field 1 of the seam's clause (1) is
the image characterisation, not the injection. -/
theorem homClassMap_of_galoisQuotient_injective
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (PicScheme.picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (hq : AlgebraicJacobian.GaloisDescent.IsGaloisQuotient ρ Y.hom)
    (T : Over (Spec (CommRingCat.of k))) :
    Function.Injective (homClassMap_of_galoisQuotient C rep ρ hq T) :=
  (equivariantToClass_injective C rep ρ T).comp
    (homEquiv_equivariant_of_galoisQuotient ρ hq T).some.injective

end CurveClasses

end PicScheme

end Scheme

end AlgebraicGeometry
