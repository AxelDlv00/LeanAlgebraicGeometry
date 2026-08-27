/-
Copyright (c) 2026 The StacksPart05Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart05Lib Contributors
-/

import StacksPart05Lib.FormalSpaces

/-!
# StacksPart05Lib.FiniteType

Small convenience lemmas for the representable scheme model of finite-type
morphisms.  The underlying property and its closure instances are defined in
`StacksPart05Lib.FormalSpaces`; this file exposes the same closure facts when
the hypotheses are supplied as terms rather than typeclass instances.
-/

namespace StacksPart05Lib

open CategoryTheory
open CategoryTheory.Limits
open AlgebraicGeometry

/-! ## Multiplicativity and isomorphisms -/

/-- The conjunction defining scheme finite type is multiplicative. -/
instance schemeFiniteType_isMultiplicative :
    MorphismProperty.IsMultiplicative schemeFiniteType := by
  change MorphismProperty.IsMultiplicative (@LocallyOfFiniteType ⊓ @QuasiCompact)
  infer_instance

/-- Finite-type morphisms are stable under pre- and postcomposition by isomorphisms. -/
instance schemeFiniteType_respectsIso :
    MorphismProperty.RespectsIso schemeFiniteType := by
  change MorphismProperty.RespectsIso (@LocallyOfFiniteType ⊓ @QuasiCompact)
  infer_instance

/-- An isomorphism of schemes is finite type. -/
theorem scheme_finiteType_of_isIso {X Y : Scheme} (f : X ⟶ Y) [IsIso f] :
    schemeFiniteType f := by
  change LocallyOfFiniteType f ∧ QuasiCompact f
  constructor <;> infer_instance

/-! ## Term-level closure -/

/-- Composition preserves finite type when its two factors are given as terms. -/
theorem scheme_finiteType_comp_of_mem {X Y Z : Scheme} (f : X ⟶ Y) (g : Y ⟶ Z)
    (hf : schemeFiniteType f) (hg : schemeFiniteType g) :
    schemeFiniteType (f ≫ g) := by
  exact MorphismProperty.comp_mem schemeFiniteType f g hf hg

/-- The second projection of a pullback is finite type when the map being
base-changed is finite type.  The other projection is supplied symmetrically
by `scheme_finiteType_baseChange_fst_of_mem` below. -/
theorem scheme_finiteType_baseChange_of_mem {X Y S : Scheme} (f : X ⟶ S)
    (g : Y ⟶ S) (hf : schemeFiniteType f) :
    schemeFiniteType (pullback.snd f g) := by
  exact MorphismProperty.pullback_snd (P := schemeFiniteType) f g hf

/-- The first projection of a pullback is finite type when its other map is. -/
theorem scheme_finiteType_baseChange_fst_of_mem {X Y S : Scheme} (f : X ⟶ S)
    (g : Y ⟶ S) (hg : schemeFiniteType g) :
    schemeFiniteType (pullback.fst f g) := by
  exact MorphismProperty.pullback_fst (P := schemeFiniteType) f g hg

end StacksPart05Lib
