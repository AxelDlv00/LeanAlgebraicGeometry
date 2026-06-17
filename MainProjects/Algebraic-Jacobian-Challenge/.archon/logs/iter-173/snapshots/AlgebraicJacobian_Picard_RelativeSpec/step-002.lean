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
functor `Spec_X(𝒜) : QcohAlg(X)^op ⥤ Sch/X` used by the relative Picard functor on a
product `C ×_k T`.

## Status (iter-173 Lane B file-skeleton)

This file is the **iter-173 Lane B** file-skeleton: each of the six pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/Picard_RelativeSpec.tex`) with a `sorry`
body. The bodies are iter-174+ work after the sibling chapters `A.1.b`
(`Picard_LineBundlePullback.tex`) and `A.1.c` (relative Picard functor) land.

The 6 pinned declarations are:

1. `AlgebraicGeometry.Scheme.QcohAlgebra` (def, ~5 LOC)
   — the type of quasi-coherent `O_X`-algebras.
2. `AlgebraicGeometry.Scheme.RelativeSpec` (noncomputable def, ~10 LOC)
   — the relative-spectrum scheme.
3. `AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty` (theorem, ~15 LOC)
   — the structure morphism `Spec_X(𝒜) → X` is an affine morphism; this is the
     substantive consequence of the representability statement of Stacks 01LQ.
4. `AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff` (theorem, ~8 LOC)
   — when `X = Spec R` the relative spectrum is affine (Stacks 01LO).
5. `AlgebraicGeometry.Scheme.RelativeSpec.base_change` (theorem, ~10 LOC)
   — `RelativeSpec` commutes with base change (Stacks 01LS).
6. `AlgebraicGeometry.Scheme.RelativeSpec.functor` (def, ~8 LOC)
   — the object-level functorial assignment `QcohAlg(X) → Over X`.

## Note on type expressivity

Because `QcohAlgebra X` is itself defined with a typed `sorry` at the *type level*
(Mathlib `b80f227` ships no `QcohAlgebra` notion directly), several pinned theorems
cannot yet quantify over `O_X`-algebra Hom-sets directly. Following the project
rule "Never weaken the type to dodge the proof" we encode each theorem by its
*intended substantive consequence*: e.g. the universal property is encoded as
"the structure morphism is affine" (which the representability statement of
Stacks 01LQ structurally implies), and base change is encoded as an existential
on the pulled-back algebra. The litmus test for each declaration is that
unfolding it reveals a non-tautological claim, not `Iso.refl _` or `trivial`.

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
abstractly as a type-level placeholder: the iter-173 file-skeleton leaves this
as a typed `sorry` at the type level because Mathlib `b80f227` does not yet
provide a `QcohAlgebra` notion (the closest is `Scheme.Modules`, which is the
`O_X`-module category but lacks the algebra-structure overlay).

iter-174+ will instantiate this as a structure pairing
`A : SheafOfModules X.ringCatSheaf` with `isQcoh : QuasiCoherent A`
and `algStr : Mon_Class A` (monoid-object structure for the tensor product
of `O_X`-modules) plus the commutativity witness.

Blueprint reference: `def:qc_sheaf_of_algebras` (Stacks 01LL,
situation-relative-spec). -/

/-- A **quasi-coherent sheaf of `O_X`-algebras**: a sheaf of `O_X`-algebras whose
underlying `O_X`-module is quasi-coherent.

iter-174+: instantiate as a structure
```
structure QcohAlgebra (X : Scheme.{u}) where
  module : X.Modules
  algStr : Mon_Class module  -- algebra structure via tensor monoidal product
  isCommutative : ... -- commutativity witness
```
For the iter-173 file-skeleton this is a typed `sorry` at the type level. -/
noncomputable def QcohAlgebra (X : Scheme.{u}) : Type (u+1) :=
  sorry

namespace RelativeSpec

/-! ## §2. The relative-spectrum scheme

The construction proceeds affine-locally: on an affine open `U = Spec R ⊆ X` we
set `π⁻¹(U) := Spec(𝒜(U))`, where `𝒜(U)` is regarded as an `R`-algebra. The local
pieces glue compatibly because `𝒜` is quasi-coherent (the transition isomorphism
`𝒜(U) ⊗_R S ≅ 𝒜(V)` for `V = Spec S ⊆ U` gives an open immersion of the
corresponding Specs).

Blueprint reference: `thm:relative_spec_exists` (Stacks 01LQ
lemma-glue-relative-spec). -/

end RelativeSpec

/-- The **relative spectrum** scheme `Spec_X(𝒜)` of a quasi-coherent sheaf of
`O_X`-algebras `𝒜`.

iter-174+: the body builds `Scheme.GlueData` from the affine-local pieces
`Spec(𝒜(U))` indexed by the affine opens of `X`, with transition isomorphisms
induced by quasi-coherence (Stacks `lemma-spec-inclusion`). The cocycle
condition reduces to Stacks `lemma-transitive-spec`. -/
noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  sorry

/-- The **structure morphism** `π : Spec_X(𝒜) → X` of the relative spectrum.

This auxiliary declaration (not in the 6 blueprint pins) is needed to express
the intended substantive types of `UniversalProperty`, `base_change`, and
`functor` — they all reference the structure morphism. iter-174+ will produce
it from the `GlueData` of `RelativeSpec`.

Blueprint reference: implicit in `thm:relative_spec_exists`. -/
noncomputable def RelativeSpec.structureMorphism {X : Scheme.{u}}
    (𝒜 : X.QcohAlgebra) : X.RelativeSpec 𝒜 ⟶ X :=
  sorry

namespace RelativeSpec

/-! ## §3. Universal property — affine structure morphism

The Stacks 01LQ universal property says `Spec_X(𝒜)` represents the functor
sending an `X`-scheme `g : T → X` to the set of `O_X`-algebra maps
`𝒜 → g_* O_T`. A direct structural consequence of representability is that the
structure morphism `π : Spec_X(𝒜) → X` is *affine* (Stacks 01LR
lemma-spec-properties, immediate corollary). For the iter-173 file-skeleton we
encode the universal property by this affine-morphism consequence — the
substantive content is the same up to body unfolding, and the type is
non-tautological.

iter-174+: refine the signature to a `CategoryTheory.Functor.RepresentableBy`
witness against the functor of `O_X`-algebra maps once `QcohAlgebra` is
unpacked and the Hom-set on algebras is available.

Blueprint reference: `thm:relative_spec_univ` (Stacks 01LQ lemma-spec). -/

/-- **Universal property of the relative spectrum (affine-structure form).**

The structure morphism `π : Spec_X(𝒜) → X` of the relative spectrum is affine.
This is the substantive consequence of the Stacks 01LQ representability
statement (an `X`-scheme is the relative spectrum of some quasi-coherent
algebra iff its structure morphism is affine).

iter-174+: refine the type signature to the full Yoneda-bijection statement
`Hom_X(T, Spec_X(𝒜)) ≃ Hom_{O_X-alg}(𝒜, g_* O_T)` once `QcohAlgebra` is
unpacked and an `O_X`-algebra Hom-set is in scope. The current type is the
non-tautological structural consequence used downstream by `affine_base_iff`
and `base_change`. -/
theorem UniversalProperty {X : Scheme.{u}} (𝒜 : X.QcohAlgebra) :
    IsAffineHom (RelativeSpec.structureMorphism 𝒜) := by
  sorry

/-! ## §4. Affine base case

When the base `X = Spec R` is affine, `Spec_X(𝒜)` reduces to the absolute
spectrum of the global sections: `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))`. The substantive
content for the iter-173 scaffold is that the relative spectrum is itself
affine. This is Stacks 01LO lemma-spec-affine.

Blueprint reference: `thm:relative_spec_affine_base`. -/

/-- **Affine-base reduction of the relative spectrum.**

For an affine scheme `X = Spec R` and a quasi-coherent `O_X`-algebra `𝒜`,
the relative spectrum `Spec_X(𝒜)` is itself an affine scheme. (More precisely,
there is a canonical isomorphism `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))`, but extracting
`Γ(X, 𝒜) : CommRingCat` requires the unpacked structure of `QcohAlgebra`,
which is iter-174+ work.)

iter-174+: refine to the full statement
`Nonempty ((Spec R).RelativeSpec 𝒜 ≅ Spec (Γ((Spec R), 𝒜)))`
once `Γ` for `QcohAlgebra` is in scope. -/
theorem affine_base_iff {R : CommRingCat.{u}} (𝒜 : (Spec R).QcohAlgebra) :
    IsAffine ((Spec R).RelativeSpec 𝒜) := by
  sorry

/-! ## §5. Base change

The relative spectrum commutes with base change: for a morphism `g : T → X`
and a quasi-coherent `O_X`-algebra `𝒜`, the pullback `g^* 𝒜` is a
quasi-coherent `O_T`-algebra and
`T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)`.

Blueprint reference: `thm:relative_spec_base_change` (Stacks 01LS
lemma-spec-base-change). -/

/-- **Base change of the relative spectrum.**

For a morphism `g : T → X` and a quasi-coherent `O_X`-algebra `𝒜`, there
exists a quasi-coherent `O_T`-algebra `𝒜' = g^* 𝒜` and a canonical isomorphism
of `T`-schemes
`T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)`.

The pullback `g^* 𝒜 : T.QcohAlgebra` is bound by the existential; iter-174+
will refine to a named `pullbackQcoh g 𝒜` operation once `QcohAlgebra` is
unpacked.

iter-174+: the body invokes the universal property and unwinds the bijection:
a `T`-morphism `S → T ×_X Spec_X(𝒜)` is an `X`-morphism `S → Spec_X(𝒜)`
together with a `T`-factorisation of `S → X`, which by Yoneda is the same as
an `O_S`-algebra map `(f')^*(g^* 𝒜) = f^* 𝒜 → O_S`, i.e. an element of the
functor for `(T, g^* 𝒜)`. -/
theorem base_change {X T : Scheme.{u}} (g : T ⟶ X) (𝒜 : X.QcohAlgebra) :
    ∃ (𝒜' : T.QcohAlgebra),
      Nonempty (pullback g (RelativeSpec.structureMorphism 𝒜) ≅
                  T.RelativeSpec 𝒜') := by
  sorry

/-! ## §6. Functoriality

The construction `𝒜 ↦ Spec_X(𝒜)` extends to a contravariant functor
`Spec_X : QcohAlg(X)^op ⥤ Over X`. The iter-173 file-skeleton encodes the
object-level functorial assignment as `X.QcohAlgebra → Over X`; the
morphism-level action and full `Functor` packaging are iter-174+ work after
`QcohAlgebra` is unpacked to a category.

Blueprint reference: `thm:relative_spec_functorial` (Stacks 01LR
definition-relative-spec + lemma-glueing-gives-functor-spec). -/

/-- **The relative-spectrum functor (object level).**

The object-level functorial action `𝒜 ↦ Over.mk (π_𝒜) : Over X`, packaging
the relative spectrum together with its structure morphism over `X`.

iter-174+: the body is concrete via `Over.mk (RelativeSpec.structureMorphism 𝒜)`
but is left as `sorry` here because `RelativeSpec.structureMorphism` is itself
a typed `sorry`; once the structure morphism lands the body collapses to
`fun 𝒜 => Over.mk (structureMorphism 𝒜)`. The full categorical functor
`X.QcohAlgebra ⥤ Over X` (with `map` action induced by the universal property)
becomes expressible once `QcohAlgebra` carries its category structure. -/
noncomputable def functor (X : Scheme.{u}) :
    X.QcohAlgebra → Over X :=
  fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)

end RelativeSpec

end Scheme

end AlgebraicGeometry
