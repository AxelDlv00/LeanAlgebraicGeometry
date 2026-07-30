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

end QuotientHom

end PicScheme

end Scheme

end AlgebraicGeometry
