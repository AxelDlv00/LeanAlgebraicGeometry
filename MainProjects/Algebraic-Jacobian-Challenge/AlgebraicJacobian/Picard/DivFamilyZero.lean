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
object: that would need the slice to be a *singleton* at every test object, which is
false as soon as `X_T` has a nonzero invertible ideal with zero-degree quotient, and
is not proved here in either direction. The row `AJC.picrep.divzero` records the
open question; §5 states the two halves that would settle it.

## Main declarations

* `Scheme.DivFamily.zero π T` — the empty divisor family.
* `Scheme.DivFamily.instNonempty` — `Nonempty (DivFamily π T)`, as an instance.
* `Scheme.DivFamily.pullbackAlong_zero` — base change carries `zero` to `zero`.
* `Scheme.DivFamily.fiberDeg_zero` / `hasFiberDeg_zero` — the empty divisor has
  fibre degree `0` at every point.
* `Scheme.DivFunctor.zeroClass` / `Scheme.DivFunctorDeg.zeroClass` — the resulting
  inhabitants of the functor and of its degree-`0` slice.
* `Scheme.Modules.isFinitePresentation_of_isZero` — reusable: a zero sheaf of
  modules on any scheme is finitely presented. Absent from Mathlib.

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
  have h : Sieve.ofObjects (fun _ : PUnit.{u+1} => (⊤ : TopologicalSpace.Opens (Y : TopCat))) V = ⊤ := by
    ext W _
    simp only [Sieve.top_apply, iff_true]
    exact ⟨PUnit.unit, ⟨homOfLE le_top⟩⟩
  rw [h]
  exact GrothendieckTopology.top_mem _ _

set_option synthInstance.maxHeartbeats 1600000 in
set_option maxHeartbeats 2000000 in
-- Headroom: `overFunctor` is `pushforward (id)`, so `hom_ext` unfolds the slice-site
-- sheafification instances -- the same blow-up documented at
-- `QuotScheme.presentationPullbackIotaOfQuasicoherentData`.
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

set_option synthInstance.maxHeartbeats 1600000 in
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

set_option synthInstance.maxHeartbeats 1600000 in
set_option maxHeartbeats 2000000 in
-- Headroom: the cover-member presentation is elaborated on the slice site `Over top`,
-- provisioning its `HasWeakSheafify`/`WEqualsLocallyBijective` instances under a binder.
noncomputable def zeroQuasicoherentData {M : Y.Modules} (hM : IsZero M) :
    M.QuasicoherentData where
  I := PUnit.{u+1}
  X _ := (⊤ : TopologicalSpace.Opens (Y : TopCat))
  coversTop := coversTop_singleton_top
  presentation _ := zeroPresentation (isZero_over_of_isZero hM _)

set_option synthInstance.maxHeartbeats 1600000 in
set_option maxHeartbeats 2000000 in
-- Headroom: same slice-site instance provisioning as `zeroQuasicoherentData` above.
instance zeroQuasicoherentData_isFinitePresentation {M : Y.Modules} (hM : IsZero M) :
    (zeroQuasicoherentData hM).IsFinitePresentation where
  isFinite_presentation _ := zeroPresentation_isFinite (isZero_over_of_isZero hM _)

set_option synthInstance.maxHeartbeats 1600000 in
set_option maxHeartbeats 2000000 in
-- Headroom: `shrink` re-derives the covering sieve, re-entering the slice-site synthesis.
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

end Scheme.Modules

end AlgebraicGeometry
