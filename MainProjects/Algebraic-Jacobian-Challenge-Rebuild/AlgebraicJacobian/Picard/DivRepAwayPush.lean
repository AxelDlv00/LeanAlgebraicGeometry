/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepAwaySpanGlue

/-!
# Pushing an away cover forward along an algebra map

The `pull_naturality` field of `DivRepAffinePullback` compares the forward map at `A` with
the forward map at `B` along a `k`-algebra map `φ : A →ₐ[k] B`.  The forward map is built
from an atlas factorization over a spanning family `f : Fin m → A`, so naturality needs the
*pushed* family `φ ∘ f : Fin m → B` and the induced comparison of carriers.

This file supplies that transport, at the canonical carriers, over `k`:

* `AlgebraicGeometry.DivFamZar.awayPush` — the induced `k`-algebra map
  `Localization.Away a →ₐ[k] Localization.Away (φ a)`, i.e. mathlib's
  `Localization.awayMap` upgraded over the base field.  Characterized by
  `awayPush_algebraMap`.
* `AlgebraicGeometry.DivFamZar.awayPush_comp_toAlgHom` — the square with the two structure
  maps: pushing forward after restricting to `Localization.Away a` is restricting to
  `Localization.Away (φ a)` after `φ`.  This is the identity that turns naturality of the
  forward map into a statement about the pushed cover.
* `AlgebraicGeometry.DivFamZar.span_range_map_eq_top` — the pushed family still spans, so
  it is again an admissible cover.

Nothing here mentions divisors: it is the localization bookkeeping the naturality field
needs, isolated so that the naturality proof itself reads as a comparison of glued values.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory

namespace AlgebraicGeometry

namespace DivFamZar

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]

/-! ## The pushed carrier -/

/-- **The comparison of away carriers along an algebra map**: mathlib's
`Localization.awayMap` of `φ` at `a`, upgraded to a map of `k`-algebras.  Both structure
maps factor through `φ`, which is what makes it one. -/
noncomputable def awayPush (φ : A →ₐ[k] B) (a : A) :
    Localization.Away a →ₐ[k] Localization.Away (φ a) :=
  { Localization.awayMap φ.toRingHom a with
    commutes' := fun x => by
      rw [IsScalarTower.algebraMap_apply k A (Localization.Away a)]
      change Localization.awayMap φ.toRingHom a
        (algebraMap A (Localization.Away a) (algebraMap k A x)) = _
      rw [show Localization.awayMap φ.toRingHom a
              (algebraMap A (Localization.Away a) (algebraMap k A x))
            = algebraMap B (Localization.Away (φ a)) (φ (algebraMap k A x)) by
          simp [Localization.awayMap, IsLocalization.Away.map], φ.commutes]
      exact (IsScalarTower.algebraMap_apply k B (Localization.Away (φ a)) x).symm }

/-- **The characterizing property of `awayPush`**: on the image of `A` it is `φ` followed by
the structure map of the pushed carrier. -/
@[simp]
theorem awayPush_algebraMap (φ : A →ₐ[k] B) (a : A) (x : A) :
    awayPush φ a (algebraMap A (Localization.Away a) x)
      = algebraMap B (Localization.Away (φ a)) (φ x) := by
  simp [awayPush, Localization.awayMap, IsLocalization.Away.map]

set_option maxHeartbeats 3200000 in
-- The composite is checked against the `IsScalarTower` structure maps of two localizations
-- at once, which unfolds the section-ring algebra towers on both sides; the defeq check is
-- well past the default budget (as for `awayMulOfDvd_toAlgHom`).
/-- **The naturality square of the away carriers**: restricting to `Localization.Away a` and
then pushing forward along `φ` is the same as applying `φ` and then restricting to
`Localization.Away (φ a)`.  This is the identity that converts `pull_naturality` into a
comparison over the pushed cover. -/
theorem awayPush_comp_toAlgHom (φ : A →ₐ[k] B) (a : A) :
    (awayPush φ a).comp (IsScalarTower.toAlgHom k A (Localization.Away a))
      = (IsScalarTower.toAlgHom k B (Localization.Away (φ a))).comp φ :=
  AlgHom.ext fun x => awayPush_algebraMap φ a x

/-! ## The pushed cover is a cover -/

/-- **The pushed family still spans**: the image of a spanning family under a ring
homomorphism spans the unit ideal of the target, so an away cover pushes forward to an away
cover. -/
theorem span_range_map_eq_top {ι : Type} (φ : A →ₐ[k] B) (f : ι → A)
    (hspan : Ideal.span (Set.range f) = ⊤) :
    Ideal.span (Set.range fun t => φ (f t)) = ⊤ := by
  have himg : Ideal.map φ.toRingHom (Ideal.span (Set.range f))
      = Ideal.span (Set.range fun t => φ (f t)) := by
    rw [Ideal.map_span, ← Set.range_comp]
    rfl
  rw [← himg, hspan, Ideal.map_top]

end DivFamZar

end AlgebraicGeometry
