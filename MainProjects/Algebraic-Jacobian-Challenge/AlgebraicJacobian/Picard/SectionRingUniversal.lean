/-
Copyright (c) 2026 Archon Horizon. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Horizon (Archon Horizon)
-/
import Mathlib

/-!
# Universal global sections of a proper geometrically integral curve (campaign `B0`)

This file supplies the **field of constants** substrate for the FGA Picard-scheme
representability campaign (`instHasPicScheme`, milestone `B0` of
`informal/pic-representability-campaign.md`).

For a curve `C` over a field `k` that is **proper** and **geometrically integral**,
the ring of global sections `Γ(C, 𝒪_C)` is:

* a **field** (`isField_globalSections`, Stacks `0BUG`(1); Mathlib
  `isField_of_universallyClosed`), because a proper morphism is universally closed
  and `C` is integral;
* **finite-dimensional** over `k` (`finiteDimensional_globalSections`; Mathlib
  `finite_appTop_of_universallyClosed`), because a proper morphism is locally of
  finite type — so `Γ(C, 𝒪_C)` is a *finite field extension* of `k`.

The sharp statement that this finite field extension is **trivial** — i.e.
`Γ(C, 𝒪_C) = k` — is the content Kleiman/Milne use to build canonical divisors and
rigidified representatives (campaign `B1`, `B3`-corollary, `B6`, `J1`, `G3`).  Over
`k` it is equivalent to `k` being the *field of constants* of `C`; the one honest
remaining input is the degree-zero flat base change
`Γ(C_{k̄}, 𝒪) ≅ k̄ ⊗_k Γ(C, 𝒪)` (which Mathlib v4.31 does not yet provide at the
scheme level).  We isolate that input in the `Prop`-class `HasTrivialConstants`
and prove the `k`-algebra isomorphism `Γ(C, 𝒪_C) ≃ₐ[k] k` from it
(`globalSectionsAlgEquivBase`).  No global instance is supplied — the class is an
honest use-site gate, mirroring `IsConstantField` / `HasDedekindChart`.

Campaign reference: milestone `B0` of `informal/pic-representability-campaign.md`
(Kleiman §2 uses `Γ(C, 𝒪) = k` implicitly throughout the rigidification of
`Pic^♯`).  No blueprint node is claimed yet — the sharp `Γ(C, 𝒪) = k` statement
is still gated (`HasTrivialConstants`), so `\leanok` would be premature.
-/

universe u

open CategoryTheory AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [Field k]

/-! ## The `k`-algebra structure on the global sections `Γ(C, 𝒪_C)` -/

/-- The structural ring map `k → Γ(C, 𝒪_C)` of a `k`-curve `C`, obtained from the
structure morphism `C.hom : C ⟶ Spec k` on global sections, transported across
`Γ(Spec k, ⊤) ≅ k`. -/
noncomputable def constMap (C : Over (Spec (CommRingCat.of k))) :
    CommRingCat.of k ⟶ Γ(C.left, ⊤) :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ C.hom.appTop

/-- The `k`-algebra structure on `Γ(C, 𝒪_C)` induced by the structure morphism. -/
noncomputable scoped instance globalSectionsAlgebra (C : Over (Spec (CommRingCat.of k))) :
    Algebra k Γ(C.left, ⊤) :=
  (constMap C).hom.toAlgebra

lemma algebraMap_globalSections (C : Over (Spec (CommRingCat.of k))) :
    algebraMap k Γ(C.left, ⊤) = (constMap C).hom := rfl

/-! ## `Γ(C, 𝒪_C)` is a finite field extension of `k` -/

/-- `C` proper + geometrically integral over the one-point base `Spec k` is an
integral scheme. -/
instance isIntegral_left_of_geometricallyIntegral (C : Over (Spec (CommRingCat.of k)))
    [GeometricallyIntegral C.hom] : IsIntegral C.left := by
  haveI : Subsingleton (Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  haveI : IsIntegral (Spec (CommRingCat.of k)) :=
    haveI : IsDomain ↑(CommRingCat.of k) := inferInstanceAs (IsDomain k)
    inferInstance
  exact GeometricallyIntegral.isIntegral_of_subsingleton C.hom

/-- **`Γ(C, 𝒪_C)` is a field.**  For a proper geometrically integral curve `C/k`,
the ring of global sections is a field (Stacks `0BUG`; Mathlib
`isField_of_universallyClosed`, valid because proper ⟹ universally closed and `C`
is integral). -/
theorem isField_globalSections (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [GeometricallyIntegral C.hom] :
    IsField Γ(C.left, ⊤) :=
  isField_of_universallyClosed k C.hom

/-- The structure map `k → Γ(C, 𝒪_C)` is module-finite (Mathlib
`finite_appTop_of_universallyClosed`, valid because proper ⟹ locally of finite
type).  `constMap C = (ΓSpecIso).inv ≫ appTop` and both factors are finite (the
first is an isomorphism). -/
theorem finite_constMap (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [GeometricallyIntegral C.hom] :
    (constMap C).hom.Finite := by
  have hf : (C.hom.appTop.hom).Finite :=
    AlgebraicGeometry.finite_appTop_of_universallyClosed k C.hom
  have hbij := ConcreteCategory.bijective_of_isIso (Scheme.ΓSpecIso (CommRingCat.of k)).inv
  have hiso : ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom).Finite :=
    RingHom.Finite.of_surjective _ hbij.2
  have hcomp : (constMap C).hom
      = (C.hom.appTop.hom).comp ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom) := by
    simp [constMap]
  rw [hcomp]; exact hf.comp hiso

/-- **`Γ(C, 𝒪_C)` is finite-dimensional over `k`.**  Combined with
`isField_globalSections`, this exhibits `Γ(C, 𝒪_C)` as a *finite field extension*
of `k`. -/
theorem finiteDimensional_globalSections (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [GeometricallyIntegral C.hom] :
    Module.Finite k Γ(C.left, ⊤) :=
  finite_constMap C

/-! ## `Γ(C, 𝒪_C) = k` under the field-of-constants gate -/

/-- **Field-of-constants gate** (`B0` residual).  The structure map `k → Γ(C, 𝒪_C)`
is surjective — equivalently, `k` is the field of constants of `C`.  Together with
`isField_globalSections` this is `Γ(C, 𝒪_C) = k`.

There is no global instance: the honest remaining input is degree-zero flat base
change `Γ(C_{k̄}, 𝒪) ≅ k̄ ⊗_k Γ(C, 𝒪)` (with `C_{k̄}` integral by geometric
integrality forcing the finite extension `Γ(C, 𝒪)/k` to be both separable — from
geometric reducedness — and to remain a domain after `⊗ k̄` — from geometric
irreducibility — hence trivial).  Mathlib v4.31 supplies no scheme-level `H⁰` base
change, so we gate on the conclusion, as with `IsConstantField`. -/
class HasTrivialConstants (C : Over (Spec (CommRingCat.of k))) : Prop where
  surjective_constMap : Function.Surjective (constMap C).hom

/-- **`Γ(C, 𝒪_C) ≃ₐ[k] k`.**  Under the field-of-constants gate, the finite field
extension `Γ(C, 𝒪_C)/k` is trivial: the structure map is a `k`-algebra
isomorphism.  (Injectivity is automatic — `k` is a field and `Γ(C, 𝒪_C)` is
nonzero.) -/
noncomputable def globalSectionsAlgEquivBase (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [GeometricallyIntegral C.hom] [HasTrivialConstants C] :
    Γ(C.left, ⊤) ≃ₐ[k] k := by
  haveI : Nontrivial Γ(C.left, ⊤) := (isField_globalSections C).nontrivial
  have hinj : Function.Injective (algebraMap k Γ(C.left, ⊤)) :=
    (algebraMap k Γ(C.left, ⊤)).injective
  have hsurj : Function.Surjective (algebraMap k Γ(C.left, ⊤)) :=
    HasTrivialConstants.surjective_constMap
  exact (AlgEquiv.ofBijective (Algebra.ofId k Γ(C.left, ⊤)) ⟨hinj, hsurj⟩).symm

end AlgebraicGeometry.Scheme
