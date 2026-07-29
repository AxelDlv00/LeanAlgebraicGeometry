/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorIso

/-!
# The pullback–tensor comparison with one trivialised factor

This file records the **one-sided reduction** of the pullback–tensor comparison
`Scheme.Modules.pullbackTensorMap f P Q : f^*(P ⊗ Q) ⟶ f^*P ⊗ f^*Q`
(`Picard/TensorObjSubstrate.lean`): invertibility for a *locally trivial* second
factor `Q` and an **arbitrary** first factor `P` reduces to the single residual
statement `pullbackTensorMap f P 𝒪_X` — the "twist an arbitrary sheaf by the
structure sheaf" case.

## Why this shape, and what it is for

The campaign milestone D2' (`AJC.picrep.divgrassmannian`) needs the comparison at
`P ⊗ L^{⊗m}` where `P` is a *quotient sheaf of a divisor family* — not locally
free, not trivialisable — and `L^{⊗m}` is a line bundle. The landed
`Modules.pullbackTensorIsoOfLocallyTrivial`
(`Picard/TensorObjSubstrate/PullbackTensorIso.lean:153`) requires **both**
factors locally trivial, so it does not apply; the general statement
`Modules.pullbackTensorMap_isIso` (`Picard/QuotFunctorDef.lean:458`) is a
`sorry`. Between those two lies exactly the shape a twist needs, and this file
measures how much of it is free.

## What is proved here, and what is not

* `pullbackTensorMap_isIso_of_right_iso_unit` — **PROVED, sorry-free**: if the
  second factor is *isomorphic to* the structure sheaf, invertibility transfers
  from the structure-sheaf case. The first factor is arbitrary. This is the step
  that removes the second local-triviality hypothesis of
  `pullbackTensorMap_isIso_of_base_unit`, whose proof this one mirrors with
  `𝟙 P` in place of a trivialisation of `P`; naturality
  (`pullbackTensorMap_natural`) is unconditional, which is what makes the
  substitution legitimate.

* `PullbackTensorRightUnit` — the **residual obligation**, carried as a
  `Prop`-class with **no instance**, exactly the house pattern for a statement
  that is true but unproved (contrast `HasSmoothProperQuotient`, and see
  protection `I-0074` caveat 2 on why a global instance would be the wrong move).
  Its field mentions both `f` and `P`: it asserts invertibility of
  `pullbackTensorMap f P 𝒪_X`, so there is no way to satisfy it without saying
  something about the morphism and the sheaf it is about.

* `pullbackTensorMap_isIso_of_right_locallyTrivial` — the assembly: from the
  residual class plus local triviality of `Q` alone, invertibility at `P ⊗ Q`
  for arbitrary `P`. **This is an implication, not a discharge**: the class it
  binds has no producer in the project, and this file does not claim one.

## The honest accounting

What this file buys is a strict reduction in the number of *inputs*, not a
closed gate: D2''s twist previously needed either the sorried general statement
or a local-triviality hypothesis on a sheaf that does not have one. It now needs
`PullbackTensorRightUnit`, one statement about `P ⊗ 𝒪_X`. That residual is
**not** free and this file does not pretend otherwise — no unitor-compatibility
lemma for `pullbackTensorMap` exists in the project or in Mathlib `v4.31`
(searched), so proving it means either a unitor-compatibility square for the
comparison map or a repeat of the `pullbackTensorMap_unit_isIso` sheafification
argument with one side left general.

Nothing here is an input to `Scheme.fgaPicardRepresentability`; the seam's
obligation is untouched. The consumers are D2'/D4' on the Milne–Kollár route.

## References

Stacks 01CD (`tensor-product-pullback`), the unconditional statement this file
approximates. Blueprint: `lem:pullback_tensor_map_isiso`,
`lem:pullback_tensor_iso_loctriv`.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

namespace Scheme.Modules

/-- **One-sided transfer along an isomorphism of the second factor.**

If `Q ≅ 𝒪_X` then invertibility of `pullbackTensorMap f P Q` follows from
invertibility of `pullbackTensorMap f P 𝒪_X`, for an **arbitrary** first factor
`P`.

The proof is `pullbackTensorMap_isIso_of_base_unit`'s, with `𝟙 P` in place of a
trivialisation of the first factor: `pullbackTensorMap_natural` is
unconditional, so the naturality square for `(𝟙 P, eQ.hom)` exhibits
`pullbackTensorMap f P Q` as a right factor of a composite of isomorphisms.
Only the second factor is constrained, which is the whole point — the first is
the divisor-family quotient of D2', which is not trivialisable. -/
theorem pullbackTensorMap_isIso_of_right_iso_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (eQ : Q ≅ SheafOfModules.unit X.ringCatSheaf)
    (h : IsIso (pullbackTensorMap f P (SheafOfModules.unit X.ringCatSheaf))) :
    IsIso (pullbackTensorMap f P Q) := by
  have hnat := pullbackTensorMap_natural f (𝟙 P) eQ.hom
  haveI : IsIso (tensorObj_functoriality (𝟙 P) eQ.hom) :=
    (tensorObjIsoOfIso (Iso.refl P) eQ).isIso_hom
  haveI : IsIso ((Scheme.Modules.pullback f).map (tensorObj_functoriality (𝟙 P) eQ.hom)) :=
    Functor.map_isIso _ _
  haveI hG : IsIso (tensorObj_functoriality ((Scheme.Modules.pullback f).map (𝟙 P))
      ((Scheme.Modules.pullback f).map eQ.hom)) :=
    (tensorObjIsoOfIso ((Scheme.Modules.pullback f).mapIso (Iso.refl P))
      ((Scheme.Modules.pullback f).mapIso eQ)).isIso_hom
  haveI hL : IsIso ((Scheme.Modules.pullback f).map (tensorObj_functoriality (𝟙 P) eQ.hom) ≫
      pullbackTensorMap f P (SheafOfModules.unit X.ringCatSheaf)) := inferInstance
  rw [hnat] at hL
  exact IsIso.of_isIso_comp_right (pullbackTensorMap f P Q)
    (tensorObj_functoriality ((Scheme.Modules.pullback f).map (𝟙 P))
      ((Scheme.Modules.pullback f).map eQ.hom))

/-- **The residual obligation of the one-sided comparison** — a true statement,
carried as a hypothesis class with **no instance**.

`pullbackTensorMap f P 𝒪_X : f^*(P ⊗ 𝒪_X) ⟶ f^*P ⊗ 𝒪_Y` is an isomorphism for
every morphism `f` and every module `P`. Both sides are canonically `f^*P` via
the right unitors (`tensorObj_right_unitor`), so the content is the
compatibility of the comparison map with those unitors — a special case of
Stacks 01CD, and true unconditionally.

**Why a class and not a `sorry`.** The house pattern for "true, unproved, and
needed at a use site" is a `Prop` class with no global instance
(`HasSmoothProperQuotient`, protection `I-0074`): a `sorry`-bodied theorem would
make every consumer silently `sorry`-reachable, and a global instance would hide
the gap from `#print axioms`. Delete this class when the statement is proved.

**Why it mentions its subject.** The field quantifies over nothing: it is about
the specific `f` and `P` in the binders, so it cannot be satisfied by an
irrelevant nonemptiness (the `HasDivFunctor` failure mode, protection `I-0838`).
There is no local-triviality hypothesis on `P` anywhere in it. -/
class PullbackTensorRightUnit {X Y : Scheme.{u}} (f : Y ⟶ X) (P : X.Modules) : Prop where
  /-- The comparison at `P ⊗ 𝒪_X` is invertible. -/
  isIso_pullbackTensorMap_unit :
    IsIso (pullbackTensorMap f P (SheafOfModules.unit X.ringCatSheaf))

/-- **The one-sided comparison, assembled**: for a locally trivial second factor
`Q` and an **arbitrary** first factor `P`, the comparison
`f^*(P ⊗ Q) ⟶ f^*P ⊗ f^*Q` is an isomorphism — modulo the single residual
`PullbackTensorRightUnit f P`.

This is an **implication**, not a closed gate: `PullbackTensorRightUnit` has no
instance in the project, so the conclusion holds for no `(f, P)` until one is
supplied. What the statement establishes is that the *second* local-triviality
hypothesis of `pullbackTensorIsoOfLocallyTrivial` is removable — a line-bundle
twist of an arbitrary sheaf needs one statement about `P ⊗ 𝒪_X`, not a
trivialisation of `P`.

Local triviality of `Q` is used only pointwise, to produce a trivialisation over
a neighbourhood of each point; the transfer itself is
`pullbackTensorMap_isIso_of_right_iso_unit`, which needs `Q ≅ 𝒪` globally. The
statement is therefore given at a *globally* trivialisable `Q`, which is the
shape a twist by `L^{⊗m}` presents after restriction to a trivialising chart —
D2' consumes it chart-locally and globalises with `isIso_of_isIso_restrict`, the
same assembly `pullbackTensorIsoOfLocallyTrivial` uses. -/
theorem pullbackTensorMap_isIso_of_right_locallyTrivial {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (eQ : Q ≅ SheafOfModules.unit X.ringCatSheaf)
    [h : PullbackTensorRightUnit f P] :
    IsIso (pullbackTensorMap f P Q) :=
  pullbackTensorMap_isIso_of_right_iso_unit f P Q eQ h.isIso_pullbackTensorMap_unit

/-- The `Iso` packaging of `pullbackTensorMap_isIso_of_right_locallyTrivial`,
for consumers that want `f^*(P ⊗ Q) ≅ f^*P ⊗ f^*Q` as data.

Carries the same residual class, so it is exactly as conditional as the theorem
it packages. -/
noncomputable def pullbackTensorIsoOfRightLocallyTrivial {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P Q : X.Modules) (eQ : Q ≅ SheafOfModules.unit X.ringCatSheaf)
    [PullbackTensorRightUnit f P] :
    (Scheme.Modules.pullback f).obj (tensorObj P Q) ≅
      tensorObj ((Scheme.Modules.pullback f).obj P) ((Scheme.Modules.pullback f).obj Q) :=
  @asIso _ _ _ _ (pullbackTensorMap f P Q)
    (pullbackTensorMap_isIso_of_right_locallyTrivial f P Q eQ)

/-- **Consistency of the residual class**: it is satisfied when the first factor
is *also* trivialisable, by the landed two-sided base case
`pullbackTensorMap_isIso_of_base_unit`.

This is not a global instance and does not discharge anything for D2' (whose `P`
is a divisor-family quotient, not trivialisable). It is recorded for one reason:
it exhibits a *witness* for `PullbackTensorRightUnit`, so the class is not
vacuous — there really are `(f, P)` satisfying it, and a consumer binding it is
not binding an empty hypothesis. Per protection `I-0838`, a gate should be shown
inhabitable before anything is built on it. -/
theorem pullbackTensorRightUnit_of_iso_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P : X.Modules) (eP : P ≅ SheafOfModules.unit X.ringCatSheaf) :
    PullbackTensorRightUnit f P :=
  ⟨pullbackTensorMap_isIso_of_base_unit f eP (Iso.refl _)⟩

/-! ## The residual, sharpened to a single coherence identity

The three statements below narrow `PullbackTensorRightUnit` from "prove an
`IsIso`" to "prove one equation", and prove everything in it except that
equation. This is the measurement a lane taking the residual should start from.

The unitor route: both sides of `pullbackTensorMap f P 𝒪_X` are canonically
`f^*P`, so the map ought to be the composite

```
f^*(P ⊗ 𝒪_X) --f^*ρ_P--> f^*P --ρ⁻¹--> f^*P ⊗ 𝒪_Y --1 ⊗ (pullbackUnitIso)⁻¹--> f^*P ⊗ f^*𝒪_X
```

of `tensorObj_right_unitor`, its inverse downstairs, and `pullbackUnitIso`
(`f^*𝒪_X ≅ 𝒪_Y`, unconditional). `unitorRoute_isIso` proves that composite is an
isomorphism — with no hypothesis on `P`. So the residual is *exactly* the
assertion that `pullbackTensorMap` agrees with it.

Measured, so nobody re-derives it: that identity is **not** closed by `rfl`,
`dsimp only; rfl`, `simp`, or `aesop_cat` (all four tried at these binders; the
goal survives unchanged). It is a genuine coherence square at the sheafification
level, of the same kind as `pullbackTensorMap_unit_isIso`'s proof
(`Picard/TensorObjSubstrate.lean:1654`, via `pullbackEtaUnitSquare` and
`isIso_sheafifyEta_of_unitSquare`) — which is the argument to imitate, with one
side left general instead of both taken to be the unit. -/

/-- **The unitor composite is an isomorphism** — PROVED, sorry-free, with no
hypothesis on `P`.

This is the "everything except the identity" half of the residual: the target
composite of the unitor route is invertible because each of its three factors is
(`tensorObj_right_unitor` twice, `pullbackUnitIso` once, all unconditional
isomorphisms). Consequently `PullbackTensorRightUnit f P` follows from the single
equation `pullbackTensorMap = ` this composite, and from nothing else. -/
theorem unitorRoute_isIso {X Y : Scheme.{u}} (f : Y ⟶ X) (P : X.Modules) :
    IsIso ((Scheme.Modules.pullback f).map (tensorObj_right_unitor P).hom
      ≫ (tensorObj_right_unitor ((Scheme.Modules.pullback f).obj P)).inv
      ≫ tensorObj_functoriality (𝟙 ((Scheme.Modules.pullback f).obj P))
          (pullbackUnitIso f).inv) := by
  haveI : IsIso ((Scheme.Modules.pullback f).map (tensorObj_right_unitor P).hom) :=
    Functor.map_isIso _ _
  haveI : IsIso ((tensorObj_right_unitor ((Scheme.Modules.pullback f).obj P)).inv) :=
    (tensorObj_right_unitor _).isIso_inv
  haveI : IsIso (tensorObj_functoriality (𝟙 ((Scheme.Modules.pullback f).obj P))
      (pullbackUnitIso f).inv) :=
    (tensorObjIsoOfIso (Iso.refl _) (pullbackUnitIso f).symm).isIso_hom
  infer_instance

/-- **The residual, as the one coherence identity it really is.** Supplying this
equation discharges `PullbackTensorRightUnit f P`, by `unitorRoute_isIso`.

Stated as a hypothesis rather than proved: see the section note for the four
tactics that do not close it and for the sheafification argument that should. -/
theorem pullbackTensorRightUnit_of_unitorRoute {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P : X.Modules)
    (h : pullbackTensorMap f P (SheafOfModules.unit X.ringCatSheaf)
      = (Scheme.Modules.pullback f).map (tensorObj_right_unitor P).hom
        ≫ (tensorObj_right_unitor ((Scheme.Modules.pullback f).obj P)).inv
        ≫ tensorObj_functoriality (𝟙 ((Scheme.Modules.pullback f).obj P))
            (pullbackUnitIso f).inv) :
    PullbackTensorRightUnit f P :=
  ⟨h ▸ unitorRoute_isIso f P⟩

end Scheme.Modules

end AlgebraicGeometry
