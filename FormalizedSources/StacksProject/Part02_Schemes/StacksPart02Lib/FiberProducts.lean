/-
Copyright (c) 2026 The StacksPart02Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart02Lib Contributors
-/

import Mathlib.AlgebraicGeometry.Limits

/-!
# Fiber products of schemes

This module exposes the existence and universal-property interface for fiber
products of schemes, together with the affine case used throughout the Stacks
Project's Schemes chapter.
-/

namespace StacksPart02

open AlgebraicGeometry CategoryTheory CategoryTheory.Limits

universe u

/-- The category of schemes has finite limits (Stacks, Tag 01JM). -/
theorem scheme_hasFiniteLimits : HasFiniteLimits Scheme.{u} := by
  infer_instance

/-- The two projections from a fiber product form a commutative square
(Stacks, Tag 01JP). -/
theorem scheme_fiberProduct_condition
    {X Y S : Scheme.{u}} (f : X ⟶ S) (g : Y ⟶ S) :
    pullback.fst f g ≫ f = pullback.snd f g ≫ g := by
  exact pullback.condition

/-- The first projection of the canonical lift to a fiber product. -/
theorem scheme_fiberProduct_lift_fst
    {X Y S T : Scheme.{u}} (f : X ⟶ S) (g : Y ⟶ S)
    (a : T ⟶ X) (b : T ⟶ Y) (h : a ≫ f = b ≫ g) :
    pullback.lift a b h ≫ pullback.fst f g = a :=
  pullback.lift_fst a b h

/-- The second projection of the canonical lift to a fiber product. -/
theorem scheme_fiberProduct_lift_snd
    {X Y S T : Scheme.{u}} (f : X ⟶ S) (g : Y ⟶ S)
    (a : T ⟶ X) (b : T ⟶ Y) (h : a ≫ f = b ≫ g) :
    pullback.lift a b h ≫ pullback.snd f g = b :=
  pullback.lift_snd a b h

/-- Maps into a fiber product are determined by their two projections. -/
theorem scheme_fiberProduct_hom_ext
    {X Y S T : Scheme.{u}} (f : X ⟶ S) (g : Y ⟶ S)
    {a b : T ⟶ pullback f g}
    (hfst : a ≫ pullback.fst f g = b ≫ pullback.fst f g)
    (hsnd : a ≫ pullback.snd f g = b ≫ pullback.snd f g) :
    a = b := by
  exact pullback.hom_ext hfst hsnd

/-- A fiber product of affine schemes over an affine scheme is affine
(Stacks, Tag 01JQ). -/
theorem scheme_fiberProduct_isAffine
    {X Y S : Scheme.{u}} (f : X ⟶ S) (g : Y ⟶ S)
    [IsAffine X] [IsAffine Y] [IsAffine S] :
    IsAffine (pullback f g) := by
  infer_instance

end StacksPart02
