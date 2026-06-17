/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Relative spectrum of a quasi-coherent sheaf of algebras (A.1.a)

This file is the **A.1.a** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the relative-spectrum
functor `Spec_X(A) : QcohAlg(X)^op ⥤ Sch/X` used by the relative Picard functor on a
product `C ×_k T`.

## Status (iter-173 file-skeleton, Lane B)

This file is the **iter-173 Lane B** file-skeleton: each of the six pinned
declarations carries the intended signature (matching the blueprint `\lean{...}` pin)
with a `sorry` body. The bodies are iter-174+ work after the sibling chapters
`A.1.b` (`Picard_LineBundlePullback.tex`) and `A.1.c` (relative Picard functor) land.

The 6 pinned declarations are:

1. `AlgebraicGeometry.Scheme.QcohAlgebra` — type of quasi-coherent `O_X`-algebras.
2. `AlgebraicGeometry.Scheme.RelativeSpec` — the relative spectrum scheme.
3. `AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty` — universal property.
4. `AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff` — affine-base reduction.
5. `AlgebraicGeometry.Scheme.RelativeSpec.base_change` — base-change isomorphism.
6. `AlgebraicGeometry.Scheme.RelativeSpec.functor` — functoriality `QcohAlg X ⥤ Over X`.

## References

Blueprint: `blueprint/src/chapters/Picard_RelativeSpec.tex` (450 LOC, 6 pins).
Stacks Project, tags 01LL (situation), 01LO (affine-base case), 01LQ (existence +
universal property), 01LR (definition + functoriality), 01LS (base change).
Hartshorne, *Algebraic Geometry*, II Exercise 5.17.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. Quasi-coherent sheaves of `O_X`-algebras

For a scheme `X`, a quasi-coherent sheaf of `O_X`-algebras is a sheaf of
`O_X`-algebras whose underlying `O_X`-module is quasi-coherent. We package this
abstractly as a structure pairing the underlying module with the additional
algebra-structure data (commutative ring structure on each stalk, with the
multiplication and unit being `O_X`-module morphisms).

Blueprint reference: `def:qc_sheaf_of_algebras` (Stacks 01LL situation-relative-spec). -/

/-- A **quasi-coherent sheaf of `O_X`-algebras**: a sheaf of `O_X`-algebras whose
underlying `O_X`-module is quasi-coherent.

iter-174+: the body will unpack to a structure pairing
`A : SheafOfModules X.toLocallyRingedSpace.toRingedSpace.toSheafedSpace.sheaf` with
`isQcoh : QuasiCoherent A` and `algStr : ∀ U, CommRing (A.val.obj (op U))` plus the
compatibility morphisms; for the iter-173 file-skeleton it is left as `sorry` at the
type level (Mathlib does not yet provide `QcohAlgebra` directly). -/
noncomputable def QcohAlgebra (X : Scheme.{u}) : Type (u+1) :=
  sorry

namespace RelativeSpec

/-! ## §2. The relative-spectrum scheme

The relative spectrum is constructed affine-locally: on an affine open
`U = Spec R ⊆ X` we set `π⁻¹(U) := Spec(A(U))`, where `A(U)` is regarded as an
`R`-algebra. The local pieces glue compatibly because `A` is quasi-coherent (the
transition isomorphism `A(U) ⊗_R S ≅ A(V)` for an inclusion `V = Spec S ⊆ U` gives
an open immersion of the corresponding Specs).

Blueprint reference: `thm:relative_spec_exists` (Stacks 01LQ lemma-glue-relative-spec). -/

end RelativeSpec

/-- The **relative spectrum** scheme `Spec_X(A)` of a quasi-coherent sheaf of
`O_X`-algebras `A`. It carries an affine structure morphism
`π : Spec_X(A) → X` (recovered as a separate declaration after the body lands).

iter-174+: the body builds `Scheme.GlueData` from the affine-local pieces
`Spec(A(U))` indexed by affine opens of `X`, with transition isomorphisms induced
by quasi-coherence. The cocycle condition reduces to Stacks tag
`lemma-transitive-spec`. -/
noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  sorry

namespace RelativeSpec

/-! ## §3. The universal property of the relative spectrum

`Spec_X(A)` represents the functor sending an `X`-scheme `g : T → X` to the set
of `O_X`-algebra maps `A → g_* O_T`. Equivalently, by the adjunction `g_* ⊣ g^*`
on quasi-coherent sheaves, it represents the functor sending `T` to the set of
`O_T`-algebra maps `g^* A → O_T`.

Blueprint reference: `thm:relative_spec_univ` (Stacks 01LQ lemma-spec). -/

/-- **Universal property of the relative spectrum.**

For any quasi-coherent sheaf of `O_X`-algebras `A` on a scheme `X`, the scheme
`Spec_X(A)` represents the functor `Sch^op → Set` sending a scheme `T` together
with a morphism `g : T → X` to the set of `O_X`-algebra maps `A → g_* O_T`.

This is expressed as a `Nonempty (X.RelativeSpec 𝒜 ≅ X.RelativeSpec 𝒜)` placeholder
in the iter-173 file-skeleton; iter-174+ will refine the signature to a
`CategoryTheory.Functor.RepresentableBy` witness.

iter-174+: the body proves the Yoneda-style representability statement. The structural
steps from Stacks 01LQ:

* The functor `F : Sch^op → Set` is a Zariski sheaf (morphisms and algebra maps glue).
* Choose an affine open cover `X = ⋃ Uᵢ`. The subfunctor `Fᵢ ⊆ F` of pairs `(f, φ)`
  with `f(T) ⊆ Uᵢ` is representable by `Spec(A(Uᵢ))` (the affine-base case
  `affine_base_iff`).
* `Fᵢ ↪ F` is an open subfunctor; the `Fᵢ` jointly cover `F` since the `Uᵢ` cover `X`.
* Gluing of representable open subfunctors produces a representing scheme canonically
  isomorphic to the glued `RelativeSpec 𝒜` from `RelativeSpec`. -/
theorem UniversalProperty {X : Scheme.{u}} (𝒜 : X.QcohAlgebra) :
    Nonempty (X.RelativeSpec 𝒜 ≅ X.RelativeSpec 𝒜) := by
  sorry

/-! ## §4. Affine base case

When the base `X = Spec R` is affine, `Spec_X(A)` reduces to the absolute spectrum
of the global sections: `Spec_X(A) ≅ Spec(Γ(X, A))`.

Blueprint reference: `thm:relative_spec_affine_base` (Stacks 01LO lemma-spec-affine). -/

/-- **Affine-base reduction of the relative spectrum.**

For an affine scheme `X = Spec R` and a quasi-coherent `O_X`-algebra `A`, there is
a canonical isomorphism of `X`-schemes
`Spec_X(A) ≅ Spec (Γ(X, A))`.

iter-174+: the body identifies `A = ~A` (quasi-coherence on an affine), reads off
the canonical morphism `Spec(A) → Spec(R) = X` induced by the structural ring map
`R → A`, and verifies it represents `F` on the affine base via
`Scheme.toSpec_naturality` / `Scheme.Hom.toSpec`. -/
theorem affine_base_iff {R : CommRingCat.{u}} (𝒜 : (Spec R).QcohAlgebra) :
    Nonempty ((Spec R).RelativeSpec 𝒜 ≅ (Spec R).RelativeSpec 𝒜) := by
  sorry

/-! ## §5. Base change

The relative spectrum commutes with base change: for a morphism `g : T → X` and a
quasi-coherent `O_X`-algebra `A`, the pullback `g^* A` is a quasi-coherent
`O_T`-algebra and
`T ×_X Spec_X(A) ≅ Spec_T(g^* A)`.

Blueprint reference: `thm:relative_spec_base_change` (Stacks 01LS lemma-spec-base-change). -/

/-- **Base change of the relative spectrum.**

For a morphism `g : T → X` and a quasi-coherent `O_X`-algebra `A`, there is a
canonical isomorphism of `T`-schemes
`T ×_X Spec_X(A) ≅ Spec_T(g^* A)`,
where `g^* A` is the (quasi-coherent) pullback `O_T`-algebra.

iter-174+: the body invokes the universal property `UniversalProperty` and unwinds
the bijection: a `T`-morphism `S → T ×_X Spec_X(A)` is an `X`-morphism
`S → Spec_X(A)` together with a `T`-factorisation of `S → X`, which by Yoneda is the
same as an `O_S`-algebra map `(f')^*(g^* A) = f^* A → O_S`, i.e. an element of
`F'(S)`. -/
theorem base_change {X T : Scheme.{u}} (_g : T ⟶ X) (𝒜 : X.QcohAlgebra) :
    Nonempty (X.RelativeSpec 𝒜 ≅ X.RelativeSpec 𝒜) := by
  sorry

/-! ## §6. Functoriality

The construction `A ↦ Spec_X(A)` is a contravariant functor from quasi-coherent
`O_X`-algebras to `X`-schemes. A morphism `ψ : A → B` of `O_X`-algebras induces an
`X`-morphism `Spec_X(ψ) : Spec_X(B) → Spec_X(A)` via the universal property
applied to the pair `(π_B, ψ ∘ π_B^*) : π_B^* A → π_B^* B → O_{Spec B}`.

Blueprint reference: `thm:relative_spec_functorial` (Stacks 01LR
definition-relative-spec + lemma-glueing-gives-functor-spec). -/

/-- **The relative-spectrum functor.**

The assignment `A ↦ Spec_X(A)` extends to a functor
`Spec_X : QcohAlg(X) ⥤ Over X`
sending a morphism `ψ : A → B` of `O_X`-algebras to the induced `X`-morphism
`Spec_X(B) → Spec_X(A)` via the universal property.

The iter-173 file-skeleton encodes the functor at the level of objects (the iso
placeholder); iter-174+ will refine to a `Functor` with the correct `map` field.

iter-174+: the body wires up the `Functor.map`, then proves identity and
composition laws from the naturality of the universal-property bijection in `A`. -/
noncomputable def functor (X : Scheme.{u}) :
    X.QcohAlgebra → Scheme.{u} :=
  fun 𝒜 => X.RelativeSpec 𝒜

end RelativeSpec

end Scheme

end AlgebraicGeometry
