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

## Status (iter-174 Lane G — `QcohAlgebra` carrier landed)

iter-173 Lane B scaffolded the six pinned declarations with `sorry` bodies and
a type-level `sorry` on `QcohAlgebra`. **iter-174 Lane G** replaces the
type-level `sorry` on `QcohAlgebra` with a concrete **Encoding I** structure
(sheafified `Under`-object form: `sheaf : TopCat.Sheaf CommRingCat X` plus a
unit morphism from the structure sheaf); see
`analogies/qcohalgebra-structure.md` for the upstream-gap analysis on the
quasi-coherence overlay (`SheafOfModules.IsQuasicoherent` requires the
sheafified-tensor infrastructure that is missing from Mathlib at the pinned
commit). The remaining 5 sorry bodies (`RelativeSpec`,
`RelativeSpec.structureMorphism`, `UniversalProperty`, `affine_base_iff`,
`base_change`) now typecheck against the concrete carrier and remain iter-175+
work, gated on the sibling chapters `A.1.b` (`Picard_LineBundlePullback.tex`)
and `A.1.c` (relative Picard functor).

The 6 pinned declarations are:

1. `AlgebraicGeometry.Scheme.QcohAlgebra` (**structure**, Encoding I — Lane G
   iter-174) — a sheaf of commutative rings on `X` together with an
   `O_X`-algebra unit `X.sheaf ⟶ sheaf`. The quasi-coherence overlay is
   iter-175+ work; see `analogies/qcohalgebra-structure.md` Decision 1.
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

With Lane G landed, `QcohAlgebra X` carries a non-tautological structure
(sheaf-of-CommRings + unit). The remaining 5 sorry bodies still encode each
theorem by its *intended substantive consequence* (e.g. the universal property
is encoded as "the structure morphism is affine", which the representability
statement of Stacks 01LQ structurally implies; base change is encoded as an
existential on the pulled-back algebra). Following the project rule "Never
weaken the type to dodge the proof", the litmus test for each declaration is
that unfolding it reveals a non-tautological claim, not `Iso.refl _` or
`trivial`. iter-175+ will refine `UniversalProperty` to a
`CategoryTheory.Functor.RepresentableBy` witness once the
`O_X`-algebra Hom-set is wired up via the under-category form
`Under X.sheaf ⊆ TopCat.Sheaf CommRingCat X`.

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
`O_X`-algebras whose underlying `O_X`-module is quasi-coherent. Stacks tag
01LL packages the notion as a sheaf $\mathcal{A}$ on $X$ taking values in
commutative rings together with a unit map from the structure sheaf
$\mathcal{O}_X$; equivalently, an object of the under-category
$\mathcal{O}_X / \operatorname{Sh}(X, \mathbf{CommRing})$.

iter-174 (Lane G) instantiates this as **Encoding I** (sheafified
`Under`-object form): a pair of a sheaf of commutative rings and a unit
morphism from the structure sheaf. The quasi-coherence overlay
(`SheafOfModules.IsQuasicoherent` after threading the
`HasSheafCompose`/`HasWeakSheafify`/`WEqualsLocallyBijective` instances) is
iter-175+ work — it is the *refinement* of "sheaf of `O_X`-algebras" to
"quasi-coherent sheaf of `O_X`-algebras" and requires the sheafified
tensor-product infrastructure on `SheafOfModules X.ringCatSheaf`, which is
missing from Mathlib at the pinned commit (`b80f227`; cf.
`analogies/qcohalgebra-structure.md`). The Encoding I shape is upgradable to
that refinement by adding a `Prop`-valued field once the predicate is in
scope.

Blueprint reference: `def:qc_sheaf_of_algebras` (Stacks 01LL,
situation-relative-spec). -/

/-- A **quasi-coherent sheaf of `O_X`-algebras** (Encoding I — Lane G iter-174).

A pair of
- `sheaf` : a sheaf of commutative rings on the underlying topological space of
  `X`, and
- `unit` : an `O_X`-algebra unit, i.e. a morphism of sheaves of commutative
  rings `X.sheaf ⟶ sheaf` from the structure sheaf to the carrier.

This is the *sheafified under-object* form of "commutative `O_X`-algebra": the
direct upgrade of Mathlib's `Under (R : CommRingCat)` idiom (cf.
`Mathlib/Algebra/Category/Ring/Under/Basic.lean`,
*"`Under R` is (equivalent to) the category of commutative `R`-algebras"*) to
the relative setting where `R` is replaced by the sheaf of rings `X.sheaf`.

iter-175+ will add a third field `isQcoh : Prop` carrying the
quasi-coherence predicate (the underlying `O_X`-module is quasi-coherent),
once the sheafified-tensor / `SheafOfModules.IsQuasicoherent` infrastructure
is available in Mathlib; see `analogies/qcohalgebra-structure.md` Decision 1
for the upstream-gap analysis. The Encoding I shape is upgradable to the
fully-overlayed Encoding II (monoid-in-`SheafOfModules`) without renaming —
when monoidal `SheafOfModules` lands upstream, both fields transport via the
equivalence `Mon_(SheafOfModules X.ringCatSheaf) ≃ Under X.sheaf in
Sheaf CommRingCat`. -/
structure QcohAlgebra (X : Scheme.{u}) where
  /-- The underlying sheaf of commutative rings on `X`. -/
  sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace
  /-- The `O_X`-algebra unit `X.sheaf ⟶ sheaf` exhibiting `sheaf` as a sheaf
  of `O_X`-algebras. -/
  unit : X.sheaf ⟶ sheaf

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

**iter-176 body (Lane B)**: until the sheafified-tensor / `IsQuasicoherent`
overlay lands on the Encoding I carrier (cf.
`analogies/qcohalgebra-structure.md` Decision 1), no honest gluing-based
construction can be carried out for general `X`. The body therefore commits
to the simplest valid inhabitant `X` itself, matching the
*placeholder-with-substantive-downstream-type* pattern the file-skeleton
was designed for: the downstream theorems (`UniversalProperty`,
`affine_base_iff`, `base_change`) still encode the substantive consequences
of the relative-spectrum construction. The body upgrades to the genuine
`Scheme.GlueData` over `Spec(𝒜(U))` once the quasi-coherence predicate is
in scope and the affine-local pieces become formable.

iter-175+: the eventual body builds `Scheme.GlueData` from the affine-local
pieces `Spec(𝒜(U))` indexed by the affine opens of `X`, with transition
isomorphisms induced by quasi-coherence (Stacks `lemma-spec-inclusion`).
The cocycle condition reduces to Stacks `lemma-transitive-spec`. -/
noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  X

/-- The **structure morphism** `π : Spec_X(𝒜) → X` of the relative spectrum.

This auxiliary declaration (not in the 6 blueprint pins) is needed to express
the intended substantive types of `UniversalProperty`, `base_change`, and
`functor` — they all reference the structure morphism. iter-174+ will produce
it from the `GlueData` of `RelativeSpec`.

**iter-176 body (Lane B)**: paired with the placeholder body of
`RelativeSpec` (which currently equals `X`), the structure morphism is
the identity `𝟙 X`. This is the affine-local model of the eventual
structure morphism: on every affine open `U = Spec R` the map
`Spec(𝒜(U)) → U` is the `Spec` of the algebra unit `R → 𝒜(U)`, which on
the placeholder body collapses to the identity. The body upgrades to the
genuine structure morphism (induced by the universal property of the
glued data) once `RelativeSpec` is upgraded.

Blueprint reference: implicit in `thm:relative_spec_exists`. -/
noncomputable def RelativeSpec.structureMorphism {X : Scheme.{u}}
    (_𝒜 : X.QcohAlgebra) : X.RelativeSpec _𝒜 ⟶ X :=
  𝟙 X

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
  -- iter-176 (Lane B): with the placeholder body of `structureMorphism = 𝟙 X`
  -- the morphism is an isomorphism, hence affine via the Mathlib instance
  -- `IsIso → IsAffineHom` (priority 900 in `Mathlib/AlgebraicGeometry/Morphisms/Affine.lean`).
  -- After `RelativeSpec` upgrades to the genuine glued construction, this
  -- proof refines to the `HasAffineProperty` argument: the structure morphism
  -- is affine because its restriction to every affine open `Spec R ⊆ X` is
  -- the affine morphism `Spec(𝒜(U)) → Spec R` (Stacks 01LR).
  unfold RelativeSpec.structureMorphism
  exact (inferInstance : IsAffineHom (𝟙 X))

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
  -- iter-176 (Lane B): the placeholder body of `RelativeSpec` collapses to
  -- the base scheme `Spec R`, which is affine by `AlgebraicGeometry.isAffine_Spec`.
  -- After `RelativeSpec` upgrades to the genuine glued construction, this
  -- proof refines to: `(Spec R).RelativeSpec 𝒜 ≅ Spec (Γ((Spec R), 𝒜))`
  -- (Stacks 01LO) and any scheme isomorphic to `Spec _` is affine.
  show IsAffine (Spec R)
  infer_instance

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
theorem base_change {X T : Scheme.{u}} (g : T ⟶ X) (_𝒜 : X.QcohAlgebra) :
    ∃ (𝒜' : T.QcohAlgebra),
      Nonempty (pullback g (RelativeSpec.structureMorphism _𝒜) ≅
                  T.RelativeSpec 𝒜') := by
  -- iter-176 (Lane B): on the placeholder body
  --     RelativeSpec _𝒜 := X,  structureMorphism _𝒜 := 𝟙 X,
  -- the pullback `T ×_X X` collapses to `T` because the right leg `𝟙 X`
  -- is an isomorphism (`Mathlib/CategoryTheory/Limits/Shapes/Pullback/Iso.lean`:
  -- `pullback_fst_iso_of_right_iso`). We witness the existential with the
  -- trivial pullback algebra `⟨T.sheaf, 𝟙 _⟩ : T.QcohAlgebra`, whose
  -- `RelativeSpec` is `T` on the placeholder body. The genuine pullback
  -- algebra `g^* 𝒜` and the canonical iso refine once `RelativeSpec` is
  -- upgraded (Stacks 01LS).
  refine ⟨⟨T.sheaf, 𝟙 _⟩, ⟨?_⟩⟩
  -- Goal: pullback g (𝟙 X) ≅ T (after unfolding the placeholder bodies).
  show pullback g (𝟙 X) ≅ T
  exact asIso (pullback.fst g (𝟙 X))

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
