/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Albanese.AVRigidityArbitraryField
import AlgebraicJacobian.Albanese.AlbaneseJacobian
import AlgebraicJacobian.Jacobian

/-!
# The Albanese universal property over an arbitrary base field

`Albanese/AlbaneseJacobian.lean` instantiates Milne Proposition III.6.1 over an
**algebraically closed** field. This file removes that restriction, and states the result
in the shape the headline's fifth obligation `isAlbanese_pic0Et` (`Jacobian.lean`) asks
for: `IsAlbanese C P J`, over an arbitrary field `k`, for a given marked point.

## What made this possible, and what it does *not* discharge

The `k̄` restriction was never in Milne's argument. `Albanese/AlbaneseFromData.lean` proves
the factorisation in an arbitrary `CartesianMonoidalCategory`; the two geometric inputs it
consumes are Milne §I.1 Corollaries 1.4 and 1.2, and both are now available over an
arbitrary field (`Albanese/AVRigidityArbitraryField.lean`: commutativity is mathlib's
Stacks 0BFD, and pointed rigidity descends along `Over.pullback` because `IsMonHom` is a
pair of equations). So `isAlbanese_pic0Et`'s docstring pricing of the passage from `k̄` to
`k` as "the Galois-descent step of cluster `G`" overcharges for *this* step: no descent of
the universal property is needed, because the argument never needed the hypothesis.

**This is not a discharge of `isAlbanese_pic0Et`, and the antecedents below are not
witnessed for any curve.** What is still owed, at any base field:

1. `SymPowData C g` — the symmetric power `Sym^g C` with its symmetrisation projection,
   equivalently `HasColimit (permDiagram C g)`. This is the object the whole leg is
   blocked on (`AJC.albanese.symmetric`); the geometry is the cocycle agreement of the
   chart quotients plus `OrbitsInAffineOpen` for the curve;
2. `hdesc` — the descent datum, **for every target abelian variety `A`**. Over `k̄` this
   is supplied geometrically from a section of `f^{(g)}` over a dense open (Milne
   III.5.1(a) birationality, `exists_unique_descent_of_section`); that supply route is
   itself stated over `k̄` and is *not* transported here;
3. `aj`, `f`, `hf`, `haj0` — the Abel–Jacobi map and its symmetrisation. For the étale
   tower these must additionally be carried from `Pic0Scheme` to `Pic0SchemeEt`.

Genus `0` is not a separate case *of this theorem* — it is covered by taking `g = 0` — but
the headline leaf also needs the genus-`0` instance of items 1–3, which is Mumford §4
rigidity and is not addressed here.

## Main results

* `albanese_up_of_symPowData_arbitraryField` — the unique-factorisation statement over an
  arbitrary field, matching `albanese_universal_property_of_symPowData_generic` with the
  `[IsAlgClosed]` binder deleted.
* `isAlbanese_of_symPowData_arbitraryField` — the same content packaged as `IsAlbanese`,
  i.e. in the shape `isAlbanese_pic0Et` and `JacobianWitness.isAlbaneseFor` consume. Note
  `IsAlbanese` quantifies over the target `A`, so the descent datum is required uniformly
  in `A`; that is visible in the hypothesis and is the honest form of the obligation.

## References

Milne, *Abelian Varieties*, §III.6 Proposition 6.1; §I.1 Corollaries 1.2 and 1.4.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open scoped CategoryTheory.Obj

namespace AlgebraicGeometry

variable {k : Type u} [Field k]

/-- **Milne III.6.1 over an arbitrary base field.**

Same statement as `albanese_universal_property_of_symPowData_generic`
(`Albanese/AlbaneseJacobian.lean`) with the `[IsAlgClosed kbar]` binder deleted: for any
object `C`, any `g`, any symmetric-power datum, and any two abelian varieties `J`, `A` over
`k`, a pointed `φ : C ⟶ A` factors uniquely through a pointed `aj : C ⟶ J` whose
symmetrisation is `f`, given the descent datum.

The proof is the same call to `exists_unique_albanese_factorisation`; only the two rigidity
inputs change, to the arbitrary-field forms. -/
theorem albanese_up_of_symPowData_arbitraryField
    (C : Over (Spec (.of k))) (g : ℕ)
    (D : SymPowData C g)
    (hproj : ∀ σ : Equiv.Perm (Fin g), permAut C σ ≫ D.proj = D.proj)
    (P0 : 𝟙_ (Over (Spec (.of k))) ⟶ C) (i₀ : Fin g)
    {J A : Over (Spec (.of k))}
    [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (φ : C ⟶ A) (hφ : P0 ≫ φ = η[A])
    (aj : C ⟶ J) (f : D.carrier ⟶ J)
    (hf : letI : IsCommMonObj J := isCommMonObj_of_package_arbitraryField J
      D.proj ≫ f = powSum g aj)
    (haj0 : P0 ≫ aj = η[J])
    (hdesc : letI : IsCommMonObj A := isCommMonObj_of_package_arbitraryField A
      ∃! ψ : J ⟶ A, D.symAVMap φ = f ≫ ψ) :
    ∃! ψ : J ⟶ A, φ = aj ≫ ψ := by
  letI : IsCommMonObj J := isCommMonObj_of_package_arbitraryField J
  letI : IsCommMonObj A := isCommMonObj_of_package_arbitraryField A
  exact exists_unique_albanese_factorisation D f P0 i₀ hproj aj hf haj0 φ hφ
    (fun ψ hψ => isMonHom_of_pointed_arbitraryField ψ hψ) hdesc

/-- **`IsAlbanese` over an arbitrary base field, from the symmetric power and the descent
datum.**

This is the shape of the headline's fifth obligation `isAlbanese_pic0Et`: `J` *is* the
Albanese of the pointed curve `(C, P)`, over an arbitrary `k`, with no hypothesis on
`C(k)`.

The universal morphism is the given `aj`. Because `IsAlbanese` quantifies over the target
`A`, the descent datum is needed **uniformly in `A`** — that is the `hdesc` binder, and it
is stated that way deliberately rather than for one `A`: a version taking the datum for a
single target would not produce `IsAlbanese`.

What this reduces the obligation to is items 1–3 of the module header, none of which is
witnessed here for any curve. In particular no `SymPowData C g` exists in this development
for `g ≥ 2`, so this theorem has no inhabitant at a curve of genus `≥ 2` today; it is a
reduction of the leaf's *field* hypothesis, not of its content. -/
theorem isAlbanese_of_symPowData_arbitraryField
    (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (g : ℕ) (D : SymPowData C g)
    (hproj : ∀ σ : Equiv.Perm (Fin g), permAut C σ ≫ D.proj = D.proj)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) (i₀ : Fin g)
    (J : Over (Spec (.of k)))
    [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]
    (aj : C ⟶ J) (f : D.carrier ⟶ J)
    (hf : letI : IsCommMonObj J := isCommMonObj_of_package_arbitraryField J
      D.proj ≫ f = powSum g aj)
    (haj0 : P ≫ aj = η[J])
    (hdesc : ∀ (A : Over (Spec (.of k))) [GrpObj A] [IsProper A.hom] [Smooth A.hom]
      [GeometricallyIrreducible A.hom] (φ : C ⟶ A),
      letI : IsCommMonObj A := isCommMonObj_of_package_arbitraryField A
      ∃! ψ : J ⟶ A, D.symAVMap φ = f ≫ ψ) :
    IsAlbanese C P J := by
  refine ⟨aj, haj0, ?_⟩
  intro A _ _ _ _ φ hφ
  letI : IsCommMonObj J := isCommMonObj_of_package_arbitraryField J
  letI : IsCommMonObj A := isCommMonObj_of_package_arbitraryField A
  exact exists_unique_albanese_factorisation D f P i₀ hproj aj hf haj0 φ hφ
    (fun ψ hψ => isMonHom_of_pointed_arbitraryField ψ hψ) (hdesc A φ)

end AlgebraicGeometry
