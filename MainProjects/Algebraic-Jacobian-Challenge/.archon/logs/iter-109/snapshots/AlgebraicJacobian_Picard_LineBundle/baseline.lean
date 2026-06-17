/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Modules.Monoidal

/-!
# Line bundles and the Picard group of a scheme

Phase C step C1 (per `STRATEGY.md`, recipe `analogies/c1-route.md`).

`LineBundle X` is the units of the (symmetric) monoidal-category skeleton of
`X.Modules`, mirroring the ring-side idiom
`CommRing.Pic R := Shrink (Skeleton (SemimoduleCat R))ˣ`
(`Mathlib.RingTheory.PicardGroup:407`). The `CommGroup` structure derives by
typeclass resolution through `Skeleton.instCommMonoid`
(`Mathlib.CategoryTheory.Monoidal.Skeleton:80`) and `instCommGroupUnits`.

## Load-bearing transitive dependency (post-C1)

The `BraidedCategory (X.Modules)` chain underwriting `instCommGroupLineBundle`
goes through `Localization.Monoidal.Braided`
(`Mathlib.CategoryTheory.Localization.Monoidal.Braided:118`), which needs
`(W X).IsMonoidal` — the project's named-deferred sorry
`instIsMonoidal_W` (`Modules/Monoidal.lean:166`). Post-C1, every theorem about
`LineBundle X`, `Pic X`, `Pic.pullback`, `PicardFunctor`, and the downstream
Jacobian arc transitively consumes that sorry.

## Pull-back gap

`Pic.pullback` body is `sorry`. It awaits closure of
`SheafOfModules.pullback_tensorObj` below — the named-deferred Mathlib gap
recording that `Scheme.Modules.pullback f : Y.Modules ⥤ X.Modules` is monoidal.
Mathlib b80f227 has no `Functor.Monoidal` instance for this functor; the
project takes the named-deferral route per analogist option (c).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite MonoidalCategory

namespace AlgebraicGeometry.Scheme

/-- A line bundle on a scheme `X`: an isomorphism class of invertible
quasi-coherent `O_X`-modules, packaged as the units of the skeleton of the
symmetric monoidal category `X.Modules`. Mirrors `CommRing.Pic R` which is
`Shrink (Skeleton (SemimoduleCat R))ˣ`. -/
def LineBundle (X : Scheme.{u}) : Type _ :=
  (Skeleton X.Modules)ˣ

/-- Tensor product makes the type of line bundles a commutative group: the unit
is the structure sheaf `O_X`, multiplication is `⊗_{O_X}`, and the inverse of
a line bundle `L` is its dual `L^∨ = Hom_{O_X}(L, O_X)`.

Derives via Lean's typeclass resolution from `BraidedCategory (X.Modules)`
through `Skeleton.instCommMonoid` and `instCommGroupUnits`. The
`BraidedCategory (X.Modules)` instance is provided by
`AlgebraicGeometry.Scheme.Modules.instBraidedCategory` in
`Modules/Monoidal.lean`, transitively depending on `instIsMonoidal_W`. -/
noncomputable instance instCommGroupLineBundle (X : Scheme.{u}) :
    CommGroup (LineBundle X) :=
  inferInstanceAs (CommGroup (Skeleton X.Modules)ˣ)

/-- The Picard group of a scheme: line bundles up to isomorphism. -/
abbrev Pic (X : Scheme.{u}) : Type _ := LineBundle X

/-- **Mathlib gap (post-C1, named-deferred per Phase C1 default option (c))**.
The categorical pull-back functor `Scheme.Modules.pullback f : Y.Modules ⥤ X.Modules`
should be monoidal: `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`
for every `M N : Y.Modules`. Mathlib b80f227 does not provide a
`Functor.Monoidal (Scheme.Modules.pullback f)` instance, so this iso must be
hand-built or named-deferred. The project takes the named-deferral route per
analogist `c1-route` (`analogies/c1-route.md`).

A future Mathlib refresh that lands `(SheafOfModules.pullback _).Monoidal`
collapses this sorry to `MonoidalCategoryStruct.tensorObj_iso` (or the
canonical successor lemma). -/
noncomputable def SheafOfModules.pullback_tensorObj {X Y : Scheme.{u}} (f : X ⟶ Y)
    (M N : Y.Modules) :
    (Scheme.Modules.pullback f).obj (M ⊗ N) ≅
      (Scheme.Modules.pullback f).obj M ⊗ (Scheme.Modules.pullback f).obj N := by
  sorry

/-- Pull-back of line bundles along a scheme morphism, as a group
homomorphism. Eventual implementation is
`Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))` once
`Scheme.Modules.pullback f` carries a `Functor.Monoidal` instance — currently a
Mathlib gap surfaced as `SheafOfModules.pullback_tensorObj` above. -/
noncomputable def Pic.pullback {X Y : Scheme.{u}} (f : X ⟶ Y) :
    Pic Y →* Pic X := by
  sorry

/-- Pull-back of line bundles along the identity is the identity homomorphism. -/
@[simp]
lemma Pic.pullback_id (X : Scheme.{u}) : Pic.pullback (𝟙 X) = MonoidHom.id (Pic X) := by
  sorry

/-- Pull-back of line bundles is contravariantly functorial:
`(f ≫ g)^* = f^* ∘ g^*` on Picard groups. -/
@[simp]
lemma Pic.pullback_comp {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) :
    Pic.pullback (f ≫ g) = (Pic.pullback f).comp (Pic.pullback g) := by
  sorry

end AlgebraicGeometry.Scheme
