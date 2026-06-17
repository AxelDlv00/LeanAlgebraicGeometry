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

/-- **Companion to `SheafOfModules.pullback_tensorObj`**: the categorical pull-back
functor `Scheme.Modules.pullback f` preserves the monoidal unit (the structure
sheaf). This is the unit-preservation half of the monoidality of
`Scheme.Modules.pullback f` — formally part of the same Mathlib gap as
`pullback_tensorObj` above. Recorded as a separate `sorry` here so that
`Pic.pullback` may be fully built from these two oracles. A future
Mathlib refresh landing `(SheafOfModules.pullback _).Monoidal` collapses
this to `Monoidal.εIso` (or the canonical successor). -/
noncomputable def SheafOfModules.pullback_oneIso {X Y : Scheme.{u}} (f : X ⟶ Y) :
    (Scheme.Modules.pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules := by
  sorry

/-- Pull-back of line bundles along a scheme morphism, as a group homomorphism.
The eventual closed form is
`Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))`, requiring a
`Functor.Monoidal` instance on `Scheme.Modules.pullback f` — currently a
Mathlib gap. We hand-build the underlying monoid hom by routing
`(Scheme.Modules.pullback f).mapSkeleton` through the unit-preservation iso
`SheafOfModules.pullback_oneIso` and the tensor-preservation iso
`SheafOfModules.pullback_tensorObj`. -/
noncomputable def Pic.pullback {X Y : Scheme.{u}} (f : X ⟶ Y) :
    Pic Y →* Pic X :=
  Units.map
    { toFun := (Scheme.Modules.pullback f).mapSkeleton.obj
      map_one' := by
        change (Scheme.Modules.pullback f).mapSkeleton.obj
          (toSkeleton (𝟙_ Y.Modules)) = toSkeleton (𝟙_ X.Modules)
        rw [Functor.mapSkeleton_obj_toSkeleton]
        exact congr_toSkeleton_of_iso (SheafOfModules.pullback_oneIso f)
      map_mul' := fun a b => by
        change (Scheme.Modules.pullback f).mapSkeleton.obj
            (toSkeleton (a.out ⊗ b.out)) =
          toSkeleton
            (((Scheme.Modules.pullback f).mapSkeleton.obj a).out ⊗
              ((Scheme.Modules.pullback f).mapSkeleton.obj b).out)
        rw [Functor.mapSkeleton_obj_toSkeleton]
        refine congr_toSkeleton_of_iso ?_
        exact (SheafOfModules.pullback_tensorObj f a.out b.out).trans
          ((fromSkeletonToSkeletonIso _).symm ⊗ᵢ
            (fromSkeletonToSkeletonIso _).symm) }

/-- Pull-back of line bundles along the identity is the identity homomorphism. -/
@[simp]
lemma Pic.pullback_id (X : Scheme.{u}) : Pic.pullback (𝟙 X) = MonoidHom.id (Pic X) := by
  ext u
  apply Units.ext
  change (Scheme.Modules.pullback (𝟙 X)).mapSkeleton.obj u.val = u.val
  -- mapSkeleton.obj u.val = toSkeleton ((pullback (𝟙 X)).obj u.val.out)
  -- and (pullback (𝟙 X)).obj u.val.out ≅ u.val.out (via Scheme.Modules.pullbackId)
  -- so toSkeleton ((pullback (𝟙 X)).obj u.val.out) = toSkeleton u.val.out = u.val.
  have iso : (Scheme.Modules.pullback (𝟙 X)).obj u.val.out ≅ u.val.out :=
    (Scheme.Modules.pullbackId X).app u.val.out
  rw [show (Scheme.Modules.pullback (𝟙 X)).mapSkeleton.obj u.val =
    toSkeleton ((Scheme.Modules.pullback (𝟙 X)).obj u.val.out) from rfl,
    congr_toSkeleton_of_iso iso, toSkeleton_fromSkeleton_obj]

/-- Pull-back of line bundles is contravariantly functorial:
`(f ≫ g)^* = f^* ∘ g^*` on Picard groups. -/
@[simp]
lemma Pic.pullback_comp {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) :
    Pic.pullback (f ≫ g) = (Pic.pullback f).comp (Pic.pullback g) := by
  ext u
  apply Units.ext
  -- LHS: toSkeleton ((pullback (f ≫ g)).obj u.val.out)
  -- RHS: toSkeleton ((pullback f).obj (toSkeleton ((pullback g).obj u.val.out)).out)
  -- Via Scheme.Modules.pullbackComp : pullback g ⋙ pullback f ≅ pullback (f ≫ g),
  -- (pullback (f ≫ g)).obj u.val.out ≅ (pullback f).obj ((pullback g).obj u.val.out)
  -- ≅ (pullback f).obj ((toSkeleton ((pullback g).obj u.val.out)).out).
  show (Scheme.Modules.pullback (f ≫ g)).mapSkeleton.obj u.val =
    (Scheme.Modules.pullback f).mapSkeleton.obj
      ((Scheme.Modules.pullback g).mapSkeleton.obj u.val)
  rw [show (Scheme.Modules.pullback (f ≫ g)).mapSkeleton.obj u.val =
        toSkeleton ((Scheme.Modules.pullback (f ≫ g)).obj u.val.out) from rfl,
      show (Scheme.Modules.pullback f).mapSkeleton.obj
        ((Scheme.Modules.pullback g).mapSkeleton.obj u.val) =
        toSkeleton ((Scheme.Modules.pullback f).obj
          ((toSkeleton ((Scheme.Modules.pullback g).obj u.val.out)).out)) from rfl]
  refine congr_toSkeleton_of_iso ?_
  refine ((Scheme.Modules.pullbackComp f g).symm.app u.val.out).trans ?_
  exact (Scheme.Modules.pullback f).mapIso
    (fromSkeletonToSkeletonIso ((Scheme.Modules.pullback g).obj u.val.out)).symm

end AlgebraicGeometry.Scheme
