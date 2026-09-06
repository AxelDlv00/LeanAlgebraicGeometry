/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.Morphisms.Affine
import Mathlib.AlgebraicGeometry.Morphisms.Immersion
import MilneLib.StableAffineCover

/-!
# Finite subsets in affine opens

`Scheme.FiniteInAffine` records the geometric input used by Milne's finite
quotient construction: every finite subset is contained in one affine open.
The property is kept explicit rather than installed as a global instance.  In
particular, the orbit corollary below makes the hypothesis needed by quotient
and symmetric-power constructions visible at the call site.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace AlgebraicGeometry
namespace Scheme

/-- Every finite subset of `X` is contained in a single affine open. -/
def FiniteInAffine (X : Scheme.{u}) : Prop :=
  ∀ s : Set X, s.Finite → ∃ U : X.affineOpens, s ⊆ U.1

/-- An affine scheme satisfies `FiniteInAffine`. -/
theorem finiteInAffine_of_isAffine (X : Scheme.{u}) [IsAffine X] :
    FiniteInAffine X := by
  intro s hs
  exact ⟨⟨⊤, isAffineOpen_top X⟩, fun _ _ => trivial⟩

/-- `FiniteInAffine` is invariant under isomorphism. -/
theorem finiteInAffine_of_iso {X Y : Scheme.{u}} (e : X ≅ Y)
    (hX : FiniteInAffine X) : FiniteInAffine Y := by
  intro s hs
  obtain ⟨U, hU⟩ := hX (e.hom.base ⁻¹' s)
    (hs.preimage (TopCat.homeoOfIso ((Scheme.forgetToTop).mapIso e)).injective.injOn)
  refine ⟨⟨e.hom ''ᵁ U.1, U.2.image_of_isOpenImmersion e.hom⟩, ?_⟩
  intro y hy
  exact ⟨e.inv.base y, hU (by simpa using hy), by simp⟩

/-- An affine morphism pulls `FiniteInAffine` back from its target. -/
theorem finiteInAffine_of_isAffineHom {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsAffineHom f] (hY : FiniteInAffine Y) : FiniteInAffine X := by
  intro s hs
  obtain ⟨U, hU⟩ := hY (f.base '' s) (hs.image _)
  exact ⟨⟨f ⁻¹ᵁ U.1, U.2.preimage f⟩,
    fun x hx => hU ⟨x, hx, rfl⟩⟩

/-- `FiniteInAffine` descends along an open immersion.  Finite prime
avoidance shrinks an ambient affine open into the immersion range. -/
theorem finiteInAffine_of_isOpenImmersion {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsOpenImmersion f] (hY : FiniteInAffine Y) : FiniteInAffine X := by
  classical
  intro s hs
  obtain ⟨U, hU⟩ := hY (f.base '' s) (hs.image f.base)
  letI : Fintype s := hs.fintype
  obtain ⟨r, hr, hrle⟩ :=
    MilneLib.exists_basicOpen_le_of_finite U.2
      (fun x : s => f.base x)
      (fun x => hU ⟨x, x.2, rfl⟩)
      (fun x => Scheme.Hom.mem_opensRange.mpr ⟨(x : X), rfl⟩)
  refine ⟨⟨f ⁻¹ᵁ Y.basicOpen r,
    (U.2.basicOpen r).preimage_of_isOpenImmersion f hrle⟩, ?_⟩
  intro x hx
  change f.base x ∈ Y.basicOpen r
  exact hr ⟨x, hx⟩

/-- `FiniteInAffine` descends along arbitrary immersions, by factoring an
immersion into a closed immersion followed by an open immersion. -/
theorem finiteInAffine_of_isImmersion {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsImmersion f] (hY : FiniteInAffine Y) : FiniteInAffine X := by
  obtain ⟨Z, g₁, g₂, hg₁, hg₂, -⟩ :=
    (AlgebraicGeometry.IsImmersion.isImmersion_iff_exists (f := f)).mp
      (inferInstance : IsImmersion f)
  letI := hg₁
  letI := hg₂
  exact finiteInAffine_of_isAffineHom g₁
    (finiteInAffine_of_isOpenImmersion g₂ hY)

end Scheme
end AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction

variable {G : Type u} [Group G] [Finite G] {X : Scheme.{u}}
  (act : G →* Aut X)

/-- `FiniteInAffine` supplies the affine-orbit hypothesis for a finite action. -/
theorem orbitsInAffineOpen_of_finiteInAffine
    (hX : AlgebraicGeometry.Scheme.FiniteInAffine X) : OrbitsInAffineOpen act := by
  intro x
  obtain ⟨U, hU⟩ := hX (Set.range fun g : G => (act g).hom.base x)
    (Set.finite_range _)
  exact ⟨U, fun g => hU ⟨g, rfl⟩⟩

end StableGroupAction

end MilneLib
