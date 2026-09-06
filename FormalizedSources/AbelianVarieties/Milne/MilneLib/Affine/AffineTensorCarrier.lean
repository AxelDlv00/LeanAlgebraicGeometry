/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Affine.AffineQuotientOver
import Mathlib.AlgebraicGeometry.Pullbacks

/-!
# Tensor products of affine schemes over a base

The cartesian tensor product in the slice over `Spec k` of two affine spectra
is canonically identified with the spectrum of the corresponding ring tensor
product.
-/

open scoped TensorProduct
open CategoryTheory
open AlgebraicGeometry

namespace MilneLib

universe u

/-- The affine carrier of a tensor product over `Spec k`. -/
noncomputable def affineSpecOver_tensorObj_iso {k A B : Type u} [CommRing k]
    [CommRing A] [CommRing B] [Algebra k A] [Algebra k B] :
    MonoidalCategoryStruct.tensorObj (affineSpecOver (k := k) (A := A))
        (affineSpecOver (k := k) (A := B)) ≅
      affineSpecOver (k := k) (A := A ⊗[k] B) := by
  refine Over.isoMk (pullbackSpecIso k A B) (hw := ?_)
  simp only [affineSpecOver_hom, Over.tensorObj_hom]
  exact pullbackSpecIso_hom_base k A B

end MilneLib
