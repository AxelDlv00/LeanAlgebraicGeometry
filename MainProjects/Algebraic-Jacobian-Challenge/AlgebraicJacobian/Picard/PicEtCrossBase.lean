/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib
import AlgebraicJacobian.Picard.PicEtSheaf
import AlgebraicJacobian.RiemannRoch.CurveBaseChange

/-!
# The cross-base identification for `picEt` — input 2 of the repaired descent route

This file addresses `AJC.picrep.etale-rep.crossbase`, the input that
`review-ajc` measured (`I-1076`) as missing from every site that prices the
repaired representability route, and as *upstream* of the Galois step rather
than beside it.

## What obligation this is

The seam sorry `fgaPicardRepresentability`
(`Picard/FGAPicRepresentability.lean`) is discharged, on the committed
Milne–Kollár route, by descending `PicScheme.picEt` from a separably closed
extension. The descent needs the `k'`-scheme produced over `k'` to represent
`picEt` **of the base-changed curve** `C_{k'}`. What the construction actually
hands you is `picEt` **of the `k`-curve `C`, restricted to `k'`-tests**. Those
are *a priori* different functors on `(Sch/k')`, and if they are not
identified there is no functor for a Galois descent datum to be a datum *for* —
a mismatch no green build would reveal, since both sides typecheck.

So the obligation is: for finite separable `k'/k` and a `k'`-test `T`,

```
picEt (C_{k'})  ≅  (Over.map φ).op ⋙ picEt C          (φ : Spec k' ⟶ Spec k)
```

as functors on `(Sch/k')ᵒᵖ`.

## What this file proves, and what it does not

**The whole sheafification layer of the obligation is FREE**, and that is the
result here. `picEt` is a *categorical* sheafification, and Mathlib's
`Functor.pushforwardContinuousSheafificationCompatibility` says sheafification
commutes with restriction along a continuous functor. Restriction along
`Over.map φ` *is* continuous for the two localised étale topologies (by
synthesis — `§1`), so the sheaf-level identification reduces, with no residue,
to the same statement one level down at the *unsheafified* relative Picard
presheaf (`§2`). That reduction is the content: it converts a statement about
an object defined by a universal property into a statement about an explicit
quotient of line-bundle classes.

**The presheaf-level face is NOT proved here** and is left as one explicit,
named `sorry` (`§3`, `relPresheaf_crossBaseIso`). Its geometric heart is
identified and *is* discharged (`§2`, `crossBaseTotalIso`): the two total
spaces `C_{k'} ×_{k'} T` and `C ×_k T` are canonically isomorphic by a single
Mathlib lemma, `pullbackLeftPullbackSndIso`. What remains on top of that
scheme-level iso is bookkeeping — transporting the `H_T`-coset quotient along
it and checking naturality in `T` — not a further geometric input.

**Nothing here closes the seam sorry, and no antecedent of
`fgaPicardRepresentability` is witnessed for any curve by this file.** The
identification is one of three inputs to the *route*; the route's other two are
the descent test (`Picard/EtaleFieldCover.lean`, landed) and `G1`/`G2`.

## Why not port the sibling project's version

`Algebraic-Jacobian-Challenge-Rebuild` proves a cross-base comparison as a
`MulEquiv` (`picEtCrossBaseEquiv`, `Picard/PicEtCrossBase.lean:316`, 468
lines). It is **not importable and not transcribable**: that project's `picEt`
is a hand-built limit of plus-classes over affine opens, this one's is a
categorical sheafification, and there is no `lake` edge between the projects.
Most of its length is a section-ring scalar tower which — as `review-ajc`
predicted and `§1` here confirms — a sheafification-based `picEt` does not
need, because the sheafification layer is discharged by a Mathlib
compatibility iso instead. The 468 lines were a design lead, and the lead was
that they are not the seam.

## Measurement discipline

Every synthesis claim below was checked with `lake build` first (oleans fresh,
EXIT=0, 8865 jobs) — a stale-import environment reports every probe as
succeeding (`I-1057`). The continuity claim of `§1` carries a control: the
strictly stronger `IsDenseSubsite` at the *same* two topologies does **not**
synthesize, so the pushforward is not an equivalence and the compatibility iso
of `§2` is not a triviality.
-/

universe u

open CategoryTheory AlgebraicGeometry Limits

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §1. The restriction functor on tests, and its continuity -/

/-- The structural morphism `Spec k' ⟶ Spec k` of a field extension. -/
noncomputable abbrev specMapAlgebra (k : Type u) [Field k] (k' : Type u) [Field k']
    [Algebra k k'] : Spec (CommRingCat.of k') ⟶ Spec (CommRingCat.of k) :=
  Spec.map (CommRingCat.ofHom (algebraMap k k'))

/-- **Restriction of tests along `k ⊆ k'`**: a `k'`-scheme `T` is in particular
a `k`-scheme, via `T ⟶ Spec k' ⟶ Spec k`. This is the functor along which the
descent step compares the two Picard functors. -/
noncomputable abbrev restrictTest (k : Type u) [Field k] (k' : Type u) [Field k']
    [Algebra k k'] : Over (Spec (CommRingCat.of k')) ⥤ Over (Spec (CommRingCat.of k)) :=
  Over.map (specMapAlgebra k k')

/-- `restrictTest` acts as the identity on the underlying scheme of a test. -/
@[simp]
theorem restrictTest_obj_left (T : Over (Spec (CommRingCat.of k'))) :
    ((restrictTest k k').obj T).left = T.left := rfl

/-- `restrictTest` composes the structure morphism with `φ`, by definition. -/
@[simp]
theorem restrictTest_obj_hom (T : Over (Spec (CommRingCat.of k'))) :
    ((restrictTest k k').obj T).hom = T.hom ≫ specMapAlgebra k k' := rfl

/-- **Restriction of tests is continuous** for the two localised étale
topologies `etaleTopologyOver k'` and `etaleTopologyOver k`.

This is Mathlib's general instance for `Over.map` between localisations of one
topology (`GrothendieckTopology.over`), and it is what makes the sheafification
layer of the cross-base identification free — see `picEt_crossBaseIso_of_relPresheaf`.

**Not a triviality**: the strictly stronger `IsDenseSubsite` at the same two
topologies does *not* synthesize (measured, control for this claim), so the
induced pushforward on sheaves is not an equivalence. -/
instance restrictTest_isContinuous :
    (restrictTest k k').IsContinuous
      (etaleTopologyOver k') (etaleTopologyOver k) :=
  inferInstance

/-! ## §2. The geometric heart: cancellation of the intermediate base -/

/-- **The two total spaces agree.** For a `k'`-test `T`, the curve base-changed
to `k'` and then producted with `T` over `k'` is the same scheme as the
original `k`-curve producted with `T` over `k`:

```
C_{k'} ×_{Spec k'} T  ≅  C ×_{Spec k} T
```

This is the geometric content of the cross-base identification, and it is a
single Mathlib lemma: `baseChangeField C k'` is by definition the pullback of
`C.hom` along `φ`, so this is base-cancellation
(`pullbackLeftPullbackSndIso`) for the composite `T.hom ≫ φ`.

Note the right-hand side is literally the product formed by the *restricted*
test: `((restrictTest k k').obj T).hom` is `T.hom ≫ φ` by definition
(`restrictTest_obj_hom`), so this iso compares exactly the two schemes whose
Picard groups the two sides of the obligation take. -/
noncomputable def crossBaseTotalIso (C : Over (Spec (CommRingCat.of k)))
    (T : Over (Spec (CommRingCat.of k'))) :
    pullback (baseChangeField C k').hom T.hom
      ≅ pullback C.hom ((restrictTest k k').obj T).hom :=
  pullbackLeftPullbackSndIso C.hom (specMapAlgebra k k') T.hom

/-- The cancellation iso is compatible with the projection to the test: both
sides' second projections are the map to `T.left`. -/
@[simp]
theorem crossBaseTotalIso_hom_snd (C : Over (Spec (CommRingCat.of k)))
    (T : Over (Spec (CommRingCat.of k'))) :
    (crossBaseTotalIso C T).hom ≫ pullback.snd C.hom ((restrictTest k k').obj T).hom
      = pullback.snd (baseChangeField C k').hom T.hom :=
  pullbackLeftPullbackSndIso_hom_snd _ _ _

/-! ## §3. The presheaf-level face — the one open obligation of this file -/

/-- **The cross-base identification at the level of the UNSHEAFIFIED relative
Picard presheaf.** This is the one statement this file leaves open, and it is
stated here rather than assumed anywhere downstream.

What it says: the relative Picard presheaf of the base-changed curve `C_{k'}`,
as a functor on `k'`-tests, agrees with the relative Picard presheaf of `C`
evaluated on restricted tests.

**Why it is plausible and what remains.** On a fixed test `T` the two carriers
are `Pic(C_{k'} ×_{k'} T)/π_T^* Pic(T)` and `Pic(C ×_k T)/π_T^* Pic(T)`, and
the two total spaces are canonically isomorphic — that is `crossBaseTotalIso`
above, proved. What is left is to transport the `H_T`-coset quotient along that
iso (the subgroup being quotiented by is the pullback of `Pic(T)` on both
sides, and `crossBaseTotalIso_hom_snd` says the two projections to `T` agree,
which is what makes the subgroups correspond) and to check naturality in `T`.
That is bookkeeping over an established scheme-level iso, not a further
geometric input.

**Deliberately left as an explicit `sorry`.** Per the round's discipline this
is a named open obligation, not a hidden one: no declaration in this file
consumes it, and `picEt_crossBaseIso_of_relPresheaf` below takes the
corresponding iso as an explicit *hypothesis* rather than invoking this. -/
theorem relPresheaf_crossBaseIso (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] (k' : Type u) [Field k']
    [Algebra k k'] :
    Nonempty (PicSharp.relPresheaf (baseChangeField C k')
      ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :=
  sorry

/-! ## §4. The reduction: sheafification adds nothing -/

/-- **The sheafification layer of the cross-base identification is free.**

Given the identification at the level of the unsheafified relative Picard
presheaf, the identification for the étale-sheafified functor
`PicSharp.etaleSheaf` follows with no further geometric input.

The mechanism: `picEt` is defined by *categorical* sheafification, and
sheafification commutes with restriction along a continuous functor
(`Functor.pushforwardContinuousSheafificationCompatibility`), while restriction
along `restrictTest` is continuous for the two localised étale topologies
(`restrictTest_isContinuous`). The underlying presheaf of the resulting
pushforward is *definitionally* the restriction, which is what lets the
composite be read as a statement about `etaleSheaf` directly.

This is the declaration that prices the obligation: it says the descent route's
input 2 costs the presheaf-level face and nothing more. -/
noncomputable def etaleSheaf_crossBaseIso_of_relPresheaf
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (D : Over (Spec (CommRingCat.of k')))
    [SmoothOfRelativeDimension 1 D.hom] [IsProper D.hom]
    (e : PicSharp.relPresheaf D ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :
    (PicSharp.etaleSheaf D).obj ≅ (restrictTest k k').op ⋙ (PicSharp.etaleSheaf C).obj :=
  (sheafToPresheaf _ _).mapIso
    ((presheafToSheaf (etaleTopologyOver k') AddCommGrpCat.{u+1}).mapIso e ≪≫
      ((restrictTest k k').pushforwardContinuousSheafificationCompatibility
        AddCommGrpCat.{u+1} (etaleTopologyOver k') (etaleTopologyOver k)).app
        (PicSharp.relPresheaf C))

/-- **The cross-base identification for `picEt` itself**, i.e. for the
set-valued functor whose representability is the seam obligation
`fgaPicardRepresentability`.

Same content as `etaleSheaf_crossBaseIso_of_relPresheaf`, pushed through the
forgetful functor: `picEt` is `etaleSheaf ⋙ forget`, and whiskering an iso is
an iso. Stated separately because `picEt`, not the group-valued sheaf, is the
functor the seam's `RepresentableBy` clause is about.

**This is an implication, not a closure.** Its hypothesis `e` is exactly the
open obligation `relPresheaf_crossBaseIso`, and it is passed in explicitly
rather than synthesized, so no consumer can mistake this for the full
identification. -/
noncomputable def picEt_crossBaseIso_of_relPresheaf
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (D : Over (Spec (CommRingCat.of k')))
    [SmoothOfRelativeDimension 1 D.hom] [IsProper D.hom]
    (e : PicSharp.relPresheaf D ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :
    picEt D ≅ (restrictTest k k').op ⋙ picEt C :=
  Functor.isoWhiskerRight (etaleSheaf_crossBaseIso_of_relPresheaf C D e)
      (CategoryTheory.forget AddCommGrpCat.{u+1}) ≪≫
    Functor.associator _ _ _

/-- The reduction, specialised to the base-changed curve — the shape the
descent step actually consumes. The base-changed curve inherits both binders
(`smoothOfRelativeDimension_one_hom_baseChangeField`,
`isProper_hom_baseChangeField`), so no hypothesis on `C_{k'}` is needed beyond
those on `C`. -/
noncomputable def picEt_baseChangeField_crossBaseIso_of_relPresheaf
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] (k' : Type u) [Field k']
    [Algebra k k']
    (e : PicSharp.relPresheaf (baseChangeField C k')
      ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :
    picEt (baseChangeField C k') ≅ (restrictTest k k').op ⋙ picEt C :=
  picEt_crossBaseIso_of_relPresheaf C (baseChangeField C k') e

end PicScheme

end Scheme

end AlgebraicGeometry
