/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivDegree

/-!
# The empty divisor: the first inhabitant of `Scheme.DivFamily`

`Scheme.DivFamily π T` (`Picard/DivFunctorDef.lean`) is the carrier of the whole
divisor side of the Milne–Kollár campaign: `Scheme.DivFunctor`, its degree slices
`Scheme.DivFunctorDeg`, the Abel maps `abelDeg` / `abelMapWitness`, the flatness
inputs of `Picard/DivPushforwardFlat.lean`, and `IdentityComponent`'s
`ClassDegreePinned` acceptance test are all quantified over it. Until this file it
had **zero producers**, for any `π`, any base, and any test object including the
trivial one — measured with `exact?` and recorded in its own docstring. The
consequence recorded there: *every* statement quantified over a `DivFamily` was
"true but untested", with no instance to be wrong about.

This file supplies the first inhabitant, unconditionally in `π : X ⟶ S` and
`T : Over S`: the **empty divisor** `D = ∅`, whose structure sheaf `O_D` is the
zero module and whose ideal is all of `O_{X_T}`.

## Why the empty divisor satisfies the divisor condition

The divisor condition of `DivFamily` is that the kernel ideal `I = ker q` be
*invertible* (`LineBundle.IsLocallyTrivial`). For `q : O_{X_T} ⟶ 0` the kernel is
`O_{X_T}` itself (`Limits.kernelZeroIsoSource`), and the structure sheaf is
trivially locally trivial (`RelPicFunctor.isLocallyTrivial_unit`, restated here as
`isLocallyTrivial_unit'` because that one is `private`). So the invertible-ideal
condition — the field that makes `DivFamily` a divisor rather than an arbitrary
quotient — holds *for the reason it should*: `O_{X_T}/O_{X_T} = 0` cuts out the
empty subscheme, an effective divisor of degree zero.

The three remaining fields are properties of the zero module, and the file proves
each rather than assuming it:

* `isFinitePresentation` — the zero module is finitely presented. Mathlib has no
  instance for this (measured: `infer_instance` and `exact?` both fail on
  `(0 : Y.Modules).IsFinitePresentation`), so §1 builds the `QuasicoherentData`:
  the singleton family `{⊤}` covers the top of the opens site
  (`coversTop_singleton_top`), the restriction functor preserves zero objects
  (`preservesZeroMorphisms_overFunctor`, proved from `PresheafOfModules` extensionality
  because instance search for it times out), and a zero sheaf of modules has an
  *empty* presentation — no generators and no relations, both trivially finite.
* `flat` — flatness over the base. The section modules of a zero module are
  subsingletons, and a subsingleton module is flat.
* `properSupport` — the schematic support of the zero module is the subscheme cut
  out by the annihilator, which is `⊤`, so the support is **empty**
  (`Scheme.IdealSheafData.instIsEmptyCarrierCarrierCommRingCatSubschemeTop`) and any
  morphism out of it is proper via `IsProper.instOfIsFinite`. Note this is where the
  empty divisor is *cheaper than a general one*: properness of the support is a real
  hypothesis for a nonempty divisor and free here, with no properness assumption on
  `π` at all.

## What this does and does not buy

**Does**: the divisor cluster is no longer vacuous. `Nonempty (DivFamily π T)` for
every `π` and `T`; `(DivFunctor π).obj (op T)` and `(DivFunctorDeg π 0).obj (op T)`
are inhabited; `HasFiberDeg zero 0`; and the base-change action carries `zero` to
`zero` (`pullbackAlong_zero`), so the classes are a global section of `DivFunctor`
rather than a fibrewise accident. Every theorem in `DivDegree.lean` and
`DivPushforwardFlat.lean` now has a witness to be checked against.

**Does not**: this closes no `sorry` and witnesses no antecedent of
`Scheme.fgaPicardRepresentability`. In particular it is *not* a step of D1′: the
campaign's D1′ wants divisor families of a **prescribed positive degree** `d`
arising from a very ample `O(1)`, which needs the projectivity input
(`AJC.picrep.projectivity`) and P5 uniform `H¹` vanishing. What the empty divisor
does for that programme is remove the possibility that the target type is
uninhabited — a question that had to be settled before any positive-degree producer
could be believed, and which no lane had settled in either direction.

**One caveat, stated because it is the natural over-reading.** The degree-zero slice
being inhabited does *not* make `DivFunctorDeg π 0` representable by the terminal
object `Over.mk (𝟙 S)`. That would need the slice to be a *singleton* at every test
object, and this file proves only the `Nonempty` half. The missing half is
`Subsingleton ((DivFunctorDeg π 0).obj (op T))` — i.e. that the empty divisor is the
*only* relative divisor of degree `0`. That is the expected statement (a degree-`0`
effective divisor on a fibre of a relative curve is empty), but it is a fact about
`fiberDeg`, not a formality: `fiberDeg` is a `finrank` with a junk value at
infinite dimension, so the implication `fiberDeg = 0 → F` is zero needs finiteness of
the fibre sections. Neither direction is proved here, and no lane holds it. The row
`AJC.picrep.divzero` records it as the open question this file leaves.

## Main declarations

* `Scheme.DivFamily.zero π T` — the empty divisor family.
* `Scheme.DivFamily.instNonempty` — `Nonempty (DivFamily π T)`, as an instance.
* `Scheme.DivFamily.pullbackAlong_zero` — base change carries `zero` to `zero`.
* `Scheme.DivFamily.fiberDeg_zero` / `hasFiberDeg_zero` — the empty divisor has
  fibre degree `0` at every point.
* `Scheme.DivFunctor.zeroClass` / `Scheme.DivFunctorDeg.zeroClass` — the resulting
  inhabitants of the functor and of its degree-`0` slice, with
  `Scheme.DivFunctor.map_zeroClass` making the first a global section.
* `Scheme.Modules.isFinitePresentation_of_isZero` — reusable: a zero sheaf of
  modules on any scheme is finitely presented. Absent from Mathlib.
* `Module.Flat.of_subsingleton'`, `Scheme.Modules.coversTop_singleton_top`,
  `Scheme.Modules.preservesZeroMorphisms_overFunctor`,
  `Scheme.Modules.isZero_free_pempty` — the other reusable bricks §1 needed.

Every declaration here is `sorry`-free and axiom-clean
(`[propext, Classical.choice, Quot.sound]`), measured against
`Scheme.fgaPicardRepresentability` reporting `sorryAx` in the same probe file with the
oleans rebuilt first.

Reference: Kleiman, "The Picard scheme", §3 Def. `df:red`/`df:div`, Ex. `ex:DivC`
(arXiv:math/0504020).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry ZeroObject TopologicalSpace

namespace AlgebraicGeometry

/-! ## §1. A zero sheaf of modules is finitely presented

Mathlib carries no instance for this (`infer_instance` and `exact?` both fail on
`(0 : Y.Modules).IsFinitePresentation`), so the `QuasicoherentData` is built by
hand: one cover member `⊤`, no generators, no relations. -/

namespace Scheme.Modules

variable {Y : Scheme.{u}}

/-- **The singleton family `{⊤}` covers the top of the opens site.**

The one covering datum every "global" presentation needs, and the reason a *global*
presentation of a sheaf of modules on `Y` is already a `QuasicoherentData`: the sieve
`Sieve.ofObjects (fun _ => ⊤) V` is the top sieve at every open `V`, because
`V ≤ ⊤` supplies the required arrow. -/
theorem coversTop_singleton_top :
    (Opens.grothendieckTopology (Y : TopCat)).CoversTop
      (fun _ : PUnit.{u+1} => (⊤ : TopologicalSpace.Opens (Y : TopCat))) := by
  intro V
  have h : Sieve.ofObjects
      (fun _ : PUnit.{u+1} => (⊤ : TopologicalSpace.Opens (Y : TopCat))) V = ⊤ := by
    ext W _
    simp only [Sieve.top_apply, iff_true]
    exact ⟨PUnit.unit, ⟨homOfLE le_top⟩⟩
  rw [h]
  exact GrothendieckTopology.top_mem _ _

set_option synthInstance.maxHeartbeats 1600000 in -- slice-site sheafification blow-up
set_option maxHeartbeats 2000000 in
/-- **The restriction functor to an open preserves zero morphisms.**

`SheafOfModules.overFunctor` is `SheafOfModules.pushforward (𝟙 _)`, which acts as the
identity on section groups, so the statement is `rfl` componentwise. It is proved
rather than synthesized because instance search for
`(overFunctor Y.ringCatSheaf U).PreservesZeroMorphisms` exhausts its heartbeat budget
(measured: `deterministic timeout at typeclass, 20000 heartbeats`) — the
sheafification/slice-site instances it unfolds are the same blow-up
`QuotScheme.presentationPullbackιOfQuasicoherentData` documents. -/
theorem preservesZeroMorphisms_overFunctor (U : TopologicalSpace.Opens (Y : TopCat)) :
    (SheafOfModules.overFunctor Y.ringCatSheaf U).PreservesZeroMorphisms := by
  constructor
  intro _ _
  apply SheafOfModules.hom_ext
  apply PresheafOfModules.hom_ext
  intro _
  rfl

/-- **The empty generating sections of a zero sheaf of modules.**

No generators at all: the structure map `free PEmpty ⟶ M` is epi because *every*
morphism into a zero object is, so there is nothing to generate. Stated for a general
sheaf of rings on the opens site so that both `M` and its restrictions `M.over U`
can use it. -/
def zeroGeneratingSections
    {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat.{u}} [HasWeakSheafify J AddCommGrpCat.{u}]
    [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    {M : SheafOfModules.{u} R} (hM : IsZero M) : M.GeneratingSections where
  I := PEmpty.{u+1}
  s j := PEmpty.elim j
  epi := ⟨fun {_} g h _ => hM.eq_of_src g h⟩

instance zeroGeneratingSections_isFiniteType
    {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat.{u}} [HasWeakSheafify J AddCommGrpCat.{u}]
    [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    {M : SheafOfModules.{u} R} (hM : IsZero M) :
    (zeroGeneratingSections hM).IsFiniteType where
  finite := (inferInstance : Finite PEmpty.{u+1})

/-- **`free PEmpty` is an initial, hence zero, sheaf of modules.**

There is exactly one morphism out of it into any target — `freeHomEquiv` turns a
morphism `free PEmpty ⟶ Z` into a family of sections indexed by `PEmpty`, of which
there is one — so it is initial, and an initial object in a category with zero
morphisms is a zero object. -/
theorem isZero_free_pempty
    {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat.{u}} [HasWeakSheafify J AddCommGrpCat.{u}]
    [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})] :
    IsZero (SheafOfModules.free (R := R) PEmpty.{u+1}) :=
  IsInitial.isZero <|
    IsInitial.ofUnique (h := fun Z =>
      ⟨⟨(SheafOfModules.freeHomEquiv Z).symm (fun j => PEmpty.elim j)⟩,
        fun _ => (SheafOfModules.freeHomEquiv Z).injective (funext fun j => PEmpty.elim j)⟩)

/-- **A zero sheaf of modules has an empty presentation** — no generators and no
relations.

The relations live in `kernel (zeroGeneratingSections hM).π`, whose source
`free PEmpty` is itself a zero object (`isZero_free_pempty`), so the kernel is zero
too and the empty family generates it for the same reason. -/
theorem isZero_kernel_zeroGeneratingSections
    {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat.{u}} [HasWeakSheafify J AddCommGrpCat.{u}]
    [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    {M : SheafOfModules.{u} R} (hM : IsZero M) :
    IsZero (kernel (zeroGeneratingSections hM).π) :=
  haveI : Mono (zeroGeneratingSections hM).π := isZero_free_pempty.mono _
  isZero_kernel_of_mono _

noncomputable def zeroPresentation
    {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat.{u}} [HasWeakSheafify J AddCommGrpCat.{u}]
    [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    {M : SheafOfModules.{u} R} (hM : IsZero M) : M.Presentation where
  generators := zeroGeneratingSections hM
  relations := zeroGeneratingSections (isZero_kernel_zeroGeneratingSections hM)

instance zeroPresentation_isFinite
    {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R : Sheaf J RingCat.{u}} [HasWeakSheafify J AddCommGrpCat.{u}]
    [J.WEqualsLocallyBijective AddCommGrpCat.{u}]
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    {M : SheafOfModules.{u} R} (hM : IsZero M) : (zeroPresentation hM).IsFinite where
  isFiniteType_generators := zeroGeneratingSections_isFiniteType hM
  isFiniteType_relations :=
    zeroGeneratingSections_isFiniteType (isZero_kernel_zeroGeneratingSections hM)

set_option synthInstance.maxHeartbeats 1600000 in -- slice-site sheafification blow-up
set_option maxHeartbeats 2000000 in
/-- **The quasi-coherence datum of a zero sheaf of modules**: the singleton cover
`{⊤}`, with the empty presentation on it.

The restriction `M.over ⊤` of a zero module is zero
(`preservesZeroMorphisms_overFunctor` plus `Functor.map_isZero`), so
`zeroPresentation` applies on the cover member. -/
theorem isZero_over_of_isZero {M : Y.Modules} (hM : IsZero M)
    (U : TopologicalSpace.Opens (Y : TopCat)) : IsZero (M.over U) :=
  haveI := preservesZeroMorphisms_overFunctor (Y := Y) U
  Functor.map_isZero (SheafOfModules.overFunctor Y.ringCatSheaf U) hM

set_option synthInstance.maxHeartbeats 1600000 in -- slice-site `Over top` instances
set_option maxHeartbeats 2000000 in
noncomputable def zeroQuasicoherentData {M : Y.Modules} (hM : IsZero M) :
    M.QuasicoherentData where
  I := PUnit.{u+1}
  X _ := (⊤ : TopologicalSpace.Opens (Y : TopCat))
  coversTop := coversTop_singleton_top
  presentation _ := zeroPresentation (isZero_over_of_isZero hM _)

set_option synthInstance.maxHeartbeats 1600000 in -- as `zeroQuasicoherentData` above
set_option maxHeartbeats 2000000 in
instance zeroQuasicoherentData_isFinitePresentation {M : Y.Modules} (hM : IsZero M) :
    (zeroQuasicoherentData hM).IsFinitePresentation where
  isFinite_presentation _ := zeroPresentation_isFinite (isZero_over_of_isZero hM _)

set_option synthInstance.maxHeartbeats 1600000 in -- `shrink` re-enters slice synthesis
set_option maxHeartbeats 2000000 in
/-- **A zero sheaf of modules on a scheme is finitely presented.**

Absent from Mathlib: measured, `infer_instance` and `exact?` both fail on
`(0 : Y.Modules).IsFinitePresentation`. This is the field of `Scheme.DivFamily` that
had no route at `F = 0`, and it is why the empty divisor needed §1 rather than one
line. Everything else about the empty divisor is a one-lemma citation. -/
theorem isFinitePresentation_of_isZero {M : Y.Modules} (hM : IsZero M) :
    M.IsFinitePresentation where
  exists_quasicoherentData :=
    ⟨(zeroQuasicoherentData hM).shrink,
      { isFinite_presentation := fun _ =>
          zeroPresentation_isFinite (isZero_over_of_isZero hM _) }⟩

/-! ## §2. Flatness and proper support of a zero sheaf of modules -/

end Scheme.Modules

/-- **A subsingleton module is flat**, over any commutative ring.

Absent from Mathlib as a usable lemma: `exact?` offers `Module.Flat.of_shrink`, whose
universe parameters cannot be inferred here (it leaves a metavariable). The direct
route is that a subsingleton module is linearly equivalent to `PUnit`, which is flat
by synthesis. -/
theorem Module.Flat.of_subsingleton' {R : Type u} [CommRing R] {M : Type u}
    [AddCommGroup M] [Module R M] [Subsingleton M] : Module.Flat R M :=
  Module.Flat.of_linearEquiv
    (({ toFun := fun _ => PUnit.unit, invFun := fun _ => 0,
        left_inv := fun _ => Subsingleton.elim _ _, right_inv := fun _ => rfl,
        map_add' := fun _ _ => rfl,
        map_smul' := fun _ _ => rfl } : M ≃ₗ[R] PUnit.{u+1}))

namespace Scheme.Modules

variable {Y : Scheme.{u}}

/-- **The sections of a zero sheaf of modules over any open form a subsingleton.**

`Scheme.Modules.toPresheaf` is additive, so it carries `M` to a zero presheaf of
abelian groups, whose value at `V` is a zero object of `Ab` and hence a
subsingleton. -/
theorem subsingleton_sections_of_isZero {M : Y.Modules} (hM : IsZero M)
    (V : Y.Opens) : Subsingleton Γ(M, V) :=
  AddCommGrpCat.subsingleton_of_isZero
    ((Functor.map_isZero (Scheme.Modules.toPresheaf Y) hM).obj _)

/-- **A zero sheaf of modules is flat over any base morphism**, with no hypothesis on
the morphism at all.

`CoherentSheafFlat` asks each section module `Γ(M, V)` to be flat over `Γ(S, U)`. The
section modules are subsingletons (`subsingleton_sections_of_isZero`), and a
subsingleton module is flat. -/
theorem coherentSheafFlat_of_isZero {S' : Scheme.{u}} (g : Y ⟶ S') {M : Y.Modules}
    (hM : IsZero M) : Scheme.CoherentSheafFlat g M := by
  intro U _ V _ e
  letI : Module Γ(S', U) Γ(M, V) := Module.compHom _ (g.appLE U V e).hom
  haveI := subsingleton_sections_of_isZero hM V
  exact Module.Flat.of_subsingleton'

/-- **The annihilator ideal sheaf of a zero sheaf of modules is `⊤`.**

Each affine-local annihilator is the whole ring (`Module.annihilator_eq_top_iff` at a
subsingleton module), and `ofIdeals` of the constant-`⊤` family is `⊤` because `⊤` is
itself an ideal sheaf below it. -/
theorem annihilator_of_isZero {M : Y.Modules} (hM : IsZero M) :
    Scheme.Modules.annihilator M = ⊤ :=
  top_le_iff.mp (le_sSup (by
    intro U
    haveI := subsingleton_sections_of_isZero hM U.1
    exact le_of_eq (Module.annihilator_eq_top_iff.mpr inferInstance).symm))

/-- **The schematic support of a zero sheaf of modules is empty.**

Its annihilator is `⊤`, and the subscheme cut out by the unit ideal sheaf has empty
carrier. -/
theorem isEmpty_schematicSupport_of_isZero {M : Y.Modules} (hM : IsZero M) :
    IsEmpty (Scheme.Modules.schematicSupport M) := by
  rw [Scheme.Modules.schematicSupport, annihilator_of_isZero hM]
  infer_instance

/-- **A zero sheaf of modules has proper support over any base**, unconditionally.

The support is empty, and a morphism out of an empty scheme is finite, hence proper.
This is the field of `DivFamily` that is a *real* hypothesis for a nonempty divisor —
properness of `D → T` — and it is free for the empty one, with **no** properness
assumption on the ambient morphism. -/
theorem hasProperSupport_of_isZero {S' : Scheme.{u}} (g : Y ⟶ S') {M : Y.Modules}
    (hM : IsZero M) : Scheme.Modules.HasProperSupport g M := by
  haveI := isEmpty_schematicSupport_of_isZero hM
  exact IsProper.instOfIsFinite _

end Scheme.Modules

/-! ## §3. The empty divisor -/

namespace Scheme

variable {S X : Scheme.{u}} (π : X ⟶ S) (T : Over S)

/-- **The structure sheaf is locally trivial of rank one.**

`RelPicFunctor.isLocallyTrivial_unit` is `private`, so it is restated here rather
than reused: on any affine open the identity is the required trivialisation. -/
theorem isLocallyTrivial_unit' {Y : Scheme.{u}} :
    LineBundle.IsLocallyTrivial (SheafOfModules.unit Y.ringCatSheaf) := by
  intro x
  obtain ⟨W, hW_aff, hxW, -⟩ :=
    exists_isAffineOpen_mem_and_subset (X := Y) (x := x) (U := ⊤)
      (show x ∈ (⊤ : Y.Opens) from trivial)
  exact ⟨W, hxW, hW_aff,
    ⟨(Scheme.Modules.restrictFunctorIsoPullback W.ι).app _ ≪≫ Modules.pullbackUnitIso W.ι⟩⟩

/-- **THE EMPTY DIVISOR**, and with it the first inhabitant of `Scheme.DivFamily` for
any `π : X ⟶ S` and any test object `T`.

`F = 0`, `q = 0`. The kernel ideal is then all of `O_{X_T}` — via
`Limits.kernelZeroIsoSource`, since the source of `q` is the pulled-back unit — which
is invertible, so the *divisor condition* holds for the geometric reason it should:
`O_{X_T}/O_{X_T} = 0` cuts out `D = ∅`, an effective relative divisor.

No hypothesis on `π`: not proper, not smooth, not even separated. Compare the general
case, where `properSupport` and `flat` are substantive conditions. -/
noncomputable def DivFamily.zero : DivFamily π T where
  F := 0
  isFinitePresentation := Modules.isFinitePresentation_of_isZero (isZero_zero _)
  flat := Modules.coherentSheafFlat_of_isZero _ (isZero_zero _)
  properSupport := Modules.hasProperSupport_of_isZero _ (isZero_zero _)
  q := 0
  epi := (isZero_zero _).epi _
  kerLocallyTrivial :=
    LineBundle.IsLocallyTrivial.of_iso
      (Limits.kernelZeroIsoSource (X := (Scheme.Modules.pullback
        (Limits.pullback.fst π T.hom)).obj (SheafOfModules.unit X.ringCatSheaf))
        (Y := (0 : (Limits.pullback π T.hom).Modules))).symm
      (LineBundle.IsLocallyTrivial.of_iso
        (Modules.pullbackUnitIso (Limits.pullback.fst π T.hom)).symm
        isLocallyTrivial_unit')

instance DivFamily.instNonempty : Nonempty (DivFamily π T) :=
  ⟨DivFamily.zero π T⟩

/-! ## §4. Base change, fibre degree, and the degree-zero slice

The empty divisor is not just a fibrewise accident: base change carries it to the
empty divisor of the new test object, so its classes assemble into a **global section**
of `DivFunctor`, and its fibre degree is `0` at every point of every base. -/

/-- **The pulled-back empty divisor is the empty divisor**, up to the divisor
equivalence — both `F`-sheaves are zero and any two morphisms into a zero object
agree.

This is what makes `zeroClass` below a genuine global section of `DivFunctor` rather
than an unrelated choice at each test object. -/
theorem DivFamily.pullbackAlong_zero {T' : Over S} (ψ : T' ⟶ T) :
    ((DivFamily.zero π T).pullbackAlong ψ).Rel (DivFamily.zero π T') :=
  ⟨(Functor.map_isZero (Scheme.Modules.pullback (quotBaseMap π ψ))
      (isZero_zero _)).iso (isZero_zero _),
    (isZero_zero _).eq_of_tgt _ _⟩

/-- **The fibre of the empty divisor is zero** — `fiberModule` is a module pullback,
which is additive. -/
theorem DivFamily.isZero_fiberModule_zero (t : (T.left : Scheme.{u})) :
    IsZero ((Limits.pullback.snd π T.hom).fiberModule t (DivFamily.zero π T).F) :=
  Functor.map_isZero _ (isZero_zero _)

/-- **The empty divisor has fibre degree `0`**, at every point of every base.

`deg ∅ = dim_{κ(t)} Γ(∅, O_∅) = 0`: the fibre is the zero module, its global sections
are a subsingleton, and `finrank` of a subsingleton is `0`. -/
theorem DivFamily.fiberDeg_zero (t : (T.left : Scheme.{u})) :
    (DivFamily.zero π T).fiberDeg t = 0 := by
  letI := (Limits.pullback.snd π T.hom).fiberSectionsModule t
    ((Limits.pullback.snd π T.hom).fiberModule t (DivFamily.zero π T).F)
  haveI : Subsingleton
      Γ((Limits.pullback.snd π T.hom).fiberModule t (DivFamily.zero π T).F, ⊤) :=
    Modules.subsingleton_sections_of_isZero (DivFamily.isZero_fiberModule_zero π T t) _
  exact Module.finrank_zero_of_subsingleton

/-- **The empty divisor has constant fibre degree `0`** — `HasFiberDeg zero 0`, the
predicate the degree-`d` subfunctor `DivFunctorDeg` is cut out by. -/
theorem DivFamily.hasFiberDeg_zero : (DivFamily.zero π T).HasFiberDeg 0 :=
  fun t => DivFamily.fiberDeg_zero π T t

/-- **The class of the empty divisor** in `Div_{X/S}(T)`: the first inhabitant of the
relative-divisor functor's value at any test object. -/
noncomputable def DivFunctor.zeroClass : (DivFunctor π).obj (Opposite.op T) :=
  Quotient.mk _ (DivFamily.zero π T)

instance DivFunctor.instNonemptyObj : Nonempty ((DivFunctor π).obj (Opposite.op T)) :=
  ⟨DivFunctor.zeroClass π T⟩

/-- **`DivFunctor` carries the zero class to the zero class**, i.e. `zeroClass` is a
*global section* of `Div_{X/S}` — a compatible family over all test objects, not a
choice per object. -/
theorem DivFunctor.map_zeroClass {T' : Over S} (ψ : T' ⟶ T) :
    (DivFunctor π).map ψ.op (DivFunctor.zeroClass π T) = DivFunctor.zeroClass π T' :=
  Quotient.sound (DivFamily.pullbackAlong_zero π T ψ)

/-- **The empty divisor's class has degree `0`**, in the class-level predicate the
degree slices use. -/
theorem DivFunctor.classHasFiberDeg_zeroClass :
    DivFamily.ClassHasFiberDeg (π := π) 0 (DivFunctor.zeroClass π T) :=
  DivFamily.hasFiberDeg_zero π T

/-- **The degree-`0` slice `Div⁰_{X/S}(T)` is inhabited**, for every `π` and every
test object.

This is the statement that turns the whole degree apparatus of `Picard/DivDegree.lean`
from vacuous into tested. Note what it is *not*: an identification of the slice with a
point. See the file docstring — singleton-ness at every test object is what
representability by the terminal object would need, and that is open. -/
noncomputable def DivFunctorDeg.zeroClass : (DivFunctorDeg π 0).obj (Opposite.op T) :=
  ⟨DivFunctor.zeroClass π T, DivFunctor.classHasFiberDeg_zeroClass π T⟩

instance DivFunctorDeg.instNonemptyObjZero :
    Nonempty ((DivFunctorDeg π 0).obj (Opposite.op T)) :=
  ⟨DivFunctorDeg.zeroClass π T⟩

end Scheme

end AlgebraicGeometry
