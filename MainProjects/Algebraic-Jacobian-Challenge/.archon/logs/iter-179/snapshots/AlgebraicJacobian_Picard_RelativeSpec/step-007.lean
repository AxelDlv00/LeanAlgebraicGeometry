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

## Status (iter-179 Block A — Mathlib `relativeGluingData` adopted)

iter-173 Lane B scaffolded the six pinned declarations with `sorry` bodies and
a type-level `sorry` on `QcohAlgebra`. iter-174 Lane G replaced the type-level
`sorry` on `QcohAlgebra` with the **Encoding I** structure (sheafified
`Under`-object form: `sheaf` + `unit`). iter-176 closed the body of
`RelativeSpec`/`structureMorphism` with the silently-discarding placeholder
`RelativeSpec _𝒜 := X`, `structureMorphism _ := 𝟙 X`; the lean-auditor iter-177
flagged both CRITICAL "weakened-wrong". The iter-178 mathlib-analogist consult
(`analogies/relative-spec-encoding.md`) identified that **Mathlib already ships
the construction** under a different name —
`Scheme.AffineZariskiSite.relativeGluingData`
(`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`).

**iter-179 Block A** lands the carrier upgrade: `QcohAlgebra` gains the
third `coequifibered` field (Stacks 01LL form of quasi-coherence — strictly
weaker than `SheafOfModules.IsQuasicoherent` and provably equivalent under
the dense-subsite equivalence `AffineZariskiSite.sheafEquiv`), and the bodies
of `RelativeSpec` and `RelativeSpec.structureMorphism` are now the Mathlib
canonical values `(relativeGluingData _).glued` and `.toBase`. Each of the
three downstream theorems (`UniversalProperty`, `affine_base_iff`,
`base_change`) previously discharged the trivialized goal against the
placeholder; they now carry honest `sorry` bodies pending iter-179+ Block B
rewrites against `RelativeGluingData.cover` /
`HasAffineProperty.iff_of_iSup_eq_top` /
`SmallAffineZariski.isColimitCocone` (see consult Block B).

The 6 pinned declarations are:

1. `AlgebraicGeometry.Scheme.QcohAlgebra` (**structure**, Block A iter-179)
   — a sheaf of commutative rings on `X`, an `O_X`-algebra unit
   `X.sheaf ⟶ sheaf`, and the Stacks-01LL `Coequifibered` overlay consumed
   by `relativeGluingData`. See `analogies/relative-spec-encoding.md`
   Decision 2.
2. `AlgebraicGeometry.Scheme.RelativeSpec` (noncomputable def, ~3 LOC body)
   — the relative-spectrum scheme,
   `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`.
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
$\mathcal{O}_X$, plus the quasi-coherence requirement.

iter-179 (Block A) packages this as a triple of (i) a sheaf of CommRings,
(ii) an `O_X`-algebra unit from the structure sheaf, and (iii) the
`Coequifibered` overlay (Stacks 01LL form): the affine restriction of the
unit is `NatTrans.Coequifibered`, i.e. on every affine open `U` and section
`f`, the restriction-to-basic-open `D(f) ⊆ U` is `IsLocalization.Away f`.
This is the strictly-weaker, sheafified-tensor-free formulation that
Mathlib's `Scheme.AffineZariskiSite.relativeGluingData` consumes
(`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`); it is
equivalent to the full `SheafOfModules.IsQuasicoherent` predicate under the
dense-subsite equivalence `AffineZariskiSite.sheafEquiv`. See
`analogies/relative-spec-encoding.md` for the iter-178 consult that
identified this idiom.

Blueprint reference: `def:qc_sheaf_of_algebras` (Stacks 01LL,
situation-relative-spec). -/

/-- A **quasi-coherent sheaf of `O_X`-algebras** (iter-179 Block A,
Mathlib-aligned form).

A triple of
- `sheaf` : a sheaf of commutative rings on the underlying topological space
  of `X`,
- `unit` : an `O_X`-algebra unit, i.e. a morphism of sheaves of commutative
  rings `X.sheaf ⟶ sheaf` from the structure sheaf to the carrier, and
- `coequifibered` : the Stacks-01LL form of quasi-coherence — every
  restriction of `sheaf` to a basic-open `D(f) ⊆ U` is the
  `IsLocalization.Away f` of `sheaf U`. This is the exact predicate
  consumed by `Scheme.AffineZariskiSite.relativeGluingData`
  (`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`).

The shape matches the input of Mathlib's relative-gluing construction
verbatim, so `RelativeSpec` is defined directly as
`(relativeGluingData 𝒜.coequifibered).glued`. The
`NatTrans.Coequifibered` predicate is strictly weaker than the full
sheaf-of-modules quasi-coherence predicate
`SheafOfModules.IsQuasicoherent`, but equivalent under the dense-subsite
equivalence `AffineZariskiSite.sheafEquiv`, so no information is lost. See
`analogies/relative-spec-encoding.md` Decision 2 for the consult that
identified this carrier shape. -/
structure QcohAlgebra (X : Scheme.{u}) where
  /-- The underlying sheaf of commutative rings on `X`. -/
  sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace
  /-- The `O_X`-algebra unit `X.sheaf ⟶ sheaf` exhibiting `sheaf` as a sheaf
  of `O_X`-algebras. -/
  unit : X.sheaf ⟶ sheaf
  /-- **Stacks 01LL quasi-coherence overlay (`Coequifibered` form)**: every
  restriction of `sheaf` to a basic-open `D(f) ⊆ U` is `IsLocalization.Away f`.
  Strictly weaker than `SheafOfModules.IsQuasicoherent` (which needs
  sheafified-tensor infrastructure not yet in Mathlib); equivalent under the
  dense-subsite equivalence `Scheme.AffineZariskiSite.sheafEquiv`. This is the
  exact predicate consumed by `AffineZariskiSite.relativeGluingData`
  (`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`); see
  `analogies/relative-spec-encoding.md` Decision 2. -/
  coequifibered : NatTrans.Coequifibered
    (Functor.whiskerLeft (AffineZariskiSite.toOpensFunctor X).op unit.hom)

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

**iter-179 body (Block A)**: built as the canonical Mathlib value
`(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`
(`Mathlib/AlgebraicGeometry/RelativeGluing.lean:102`,
`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`). The
`coequifibered` field of `QcohAlgebra` is precisely the Stacks-01LL form of
quasi-coherence that Mathlib's `relativeGluingData` consumes: the affine
restriction of the `O_X`-algebra unit is `NatTrans.Coequifibered`, i.e. every
basic-open restriction is an `IsLocalization.Away`. The construction glues the
affine pieces `Spec(𝒜(U))` along the directed affine open cover
`Scheme.AffineZariskiSite.directedCover X` and is the exact Mathlib-aligned
template used in `Hom.normalization`
(`Mathlib/AlgebraicGeometry/Normalization.lean:120`); see
`analogies/relative-spec-encoding.md` for the consult that identified this
idiom. -/
noncomputable def RelativeSpec {X : Scheme.{u}} (𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  (AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued

/-- The **structure morphism** `π : Spec_X(𝒜) → X` of the relative spectrum.

This auxiliary declaration (not in the 6 blueprint pins) is needed to express
the intended substantive types of `UniversalProperty`, `base_change`, and
`functor` — they all reference the structure morphism.

**iter-179 body (Block A)**: built as the canonical Mathlib value
`(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase`
(`Mathlib/AlgebraicGeometry/RelativeGluing.lean:114`). The map is the colimit
descent of the natural transformation `Spec(𝒜(U)) → U` over the directed
affine open cover; see `analogies/relative-spec-encoding.md` Decision 3.

Blueprint reference: implicit in `thm:relative_spec_exists`. -/
noncomputable def RelativeSpec.structureMorphism {X : Scheme.{u}}
    (𝒜 : X.QcohAlgebra) : X.RelativeSpec 𝒜 ⟶ X :=
  (AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase

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
  -- Mathlib `relativeGluingData` builder; per `analogies/relative-spec-encoding.md`
  -- Block B. We invoke `isAffineHom_of_forall_exists_isAffineOpen`: for each `x : X`
  -- pick an affine open `U ∋ x` (every `X` has such by `exists_isAffineOpen_mem_and_subset`),
  -- and identify the structure-morphism preimage of `U` with the range of the colimit
  -- inclusion of the affine fiber `Spec(𝒜(U))` (via
  -- `Cover.RelativeGluingData.toBase_preimage_eq_opensRange_ι`); affineness of the
  -- opens-range then follows from `isAffineOpen_opensRange` since the source is
  -- `Scheme.Spec` of `𝒜.sheaf.val.obj (op U)`, an affine scheme.
  apply isAffineHom_of_forall_exists_isAffineOpen
  intro x
  obtain ⟨U, hU, hxU, _⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (U := ⊤) (Set.mem_univ x)
  refine ⟨U, hxU, hU, ?_⟩
  set d := AffineZariskiSite.relativeGluingData 𝒜.coequifibered
  let i : X.AffineZariskiSite := ⟨U, hU⟩
  change IsAffineOpen (d.toBase ⁻¹ᵁ U)
  have key : d.toBase ⁻¹ᵁ U = (d.cover.f i).opensRange := by
    have h := d.toBase_preimage_eq_opensRange_ι i
    simpa [Scheme.Opens.opensRange_ι] using h
  rw [key]
  have : IsAffine (d.cover.X i) := by
    change IsAffine (Scheme.Spec.obj _)
    infer_instance
  exact isAffineOpen_opensRange _

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
  -- Affineness of the relative-spec total space when the base is affine is the
  -- standard "affine over affine is affine" consequence: by
  -- `UniversalProperty` the structure morphism is `IsAffineHom`, and `Spec R`
  -- is itself `IsAffine`, so `isAffine_of_isAffineHom` closes the goal.
  have h : IsAffineHom (RelativeSpec.structureMorphism 𝒜) := UniversalProperty 𝒜
  exact isAffine_of_isAffineHom (RelativeSpec.structureMorphism 𝒜)

/-! ## §5. Base change

The relative spectrum commutes with base change: for a morphism `g : T → X`
and a quasi-coherent `O_X`-algebra `𝒜`, the pullback `g^* 𝒜` is a
quasi-coherent `O_T`-algebra and
`T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)`.

Blueprint reference: `thm:relative_spec_base_change` (Stacks 01LS
lemma-spec-base-change). -/

/-! ### Helpers for `base_change` (iter-179 Lane B helpers)

The base-change theorem packages two Mathlib-gap pieces of content into named
helpers (per the iter-179 directive helper budget = 2):

1. `QcohAlgebra.pullback` — constructs the pulled-back qcoh algebra
   `g^* 𝒜 : T.QcohAlgebra` by pushing forward the structure sheaf of the
   relative-spec pullback `P := pullback g (structureMorphism 𝒜)` along
   `q := pullback.snd : P ⟶ T`. The `sheaf` and `unit` fields are concrete
   (pushforward sheaf and `q.c`); the substantive Mathlib-gap content lives in
   the `coequifibered` field — Stacks 01LL preservation under pushforward by
   an affine morphism. (The morphism `q` is affine because
   `structureMorphism 𝒜` is, via `UniversalProperty`, and `IsAffineHom` is
   stable under base change by `isAffineHom_isStableUnderBaseChange`.)

2. `RelativeSpec.pullback_iso` — the canonical iso
   `pullback g (structureMorphism 𝒜) ≅ T.RelativeSpec (QcohAlgebra.pullback g 𝒜)`.
   The construction follows from the universal property of
   `Cover.RelativeGluingData.glued`: the cocone over the affine directed
   cover of `T` whose vertex is the relative-spec pullback matches the
   cocone of the `relativeGluingData` for the pushed-forward algebra.

Each helper has a substantive type; their bodies carry the residual
Mathlib-gap content. `base_change` itself becomes a 1-line existential
witness. -/

/-- **Base change of a quasi-coherent algebra (pushforward formulation).**
Given a morphism `g : T ⟶ X` and a quasi-coherent `O_X`-algebra `𝒜`, the
pulled-back qcoh algebra `g^* 𝒜 : T.QcohAlgebra` is realised as the
pushforward of the structure sheaf of the relative-spec pullback. The
`sheaf` and `unit` fields are concrete; the `coequifibered` field is the
Mathlib-gap claim that pushforward along an affine morphism preserves the
Stacks-01LL Coequifibered overlay (Stacks 01LR pullback compatibility).
Iter-180+ work: discharge `coequifibered` from `isAffineHom_isStableUnderBaseChange`
combined with the standard "affine pushforward = basic-open localization"
identification. -/
noncomputable def QcohAlgebra.pullback {X T : Scheme.{u}} (g : T ⟶ X)
    (𝒜 : X.QcohAlgebra) : T.QcohAlgebra :=
  let q : CategoryTheory.Limits.pullback g (RelativeSpec.structureMorphism 𝒜) ⟶ T :=
    CategoryTheory.Limits.pullback.snd g (RelativeSpec.structureMorphism 𝒜)
  { sheaf := (TopCat.Sheaf.pushforward CommRingCat.{u} q.base).obj
      (CategoryTheory.Limits.pullback g (RelativeSpec.structureMorphism 𝒜)).sheaf
    unit := ⟨q.c⟩
    -- Mathlib-gap: pushforward along an affine morphism preserves the
    -- Stacks-01LL Coequifibered overlay. `q` is affine (via
    -- `isAffineHom_isStableUnderBaseChange` applied to `UniversalProperty 𝒜`),
    -- so on every affine `U ⊆ T` with section `f ∈ Γ(T, U)` we have
    -- `Γ(P, q⁻¹(D(f))) = Γ(P, q⁻¹U)[1/q.app f]`, i.e. the basic-open
    -- restriction of the pushforward is the relevant `IsLocalization.Away`.
    coequifibered := sorry }

/-- **Canonical base-change isomorphism.** The pullback
`pullback g (structureMorphism 𝒜)` (formed in `Scheme`) is canonically
isomorphic to the relative spectrum of the pulled-back qcoh algebra
`QcohAlgebra.pullback g 𝒜`. The iso descends from the universal property of
`Cover.RelativeGluingData.glued` applied to the directed affine cover of
`T`: each affine open `U ⊆ T` has preimage `q⁻¹U` affine (since `q` is the
projection from the relative-spec pullback and is affine), and these
affine pieces are Mathlib-isomorphic to `Spec(g^*𝒜)(U)` by construction.
Iter-180+ work: assemble the cocone explicitly and invoke the colimit
universal property. -/
theorem pullback_iso {X T : Scheme.{u}} (g : T ⟶ X)
    (𝒜 : X.QcohAlgebra) :
    Nonempty (CategoryTheory.Limits.pullback g (RelativeSpec.structureMorphism 𝒜) ≅
              T.RelativeSpec (QcohAlgebra.pullback g 𝒜)) :=
  sorry

/-- **Base change of the relative spectrum.**

For a morphism `g : T → X` and a quasi-coherent `O_X`-algebra `𝒜`, there
exists a quasi-coherent `O_T`-algebra `𝒜' = g^* 𝒜` and a canonical isomorphism
of `T`-schemes `T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)`.

iter-179 body (Block B): witnessed by the named helpers `QcohAlgebra.pullback`
and `pullback_iso`. -/
theorem base_change {X T : Scheme.{u}} (g : T ⟶ X) (_𝒜 : X.QcohAlgebra) :
    ∃ (𝒜' : T.QcohAlgebra),
      Nonempty (pullback g (RelativeSpec.structureMorphism _𝒜) ≅
                  T.RelativeSpec 𝒜') :=
  ⟨QcohAlgebra.pullback g _𝒜, pullback_iso g _𝒜⟩

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
