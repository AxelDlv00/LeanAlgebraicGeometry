/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Isogeny

/-!
# The finite-kernel dimension criterion for isogenies

The source characterization of isogenies has several geometric formulations.
The underlying finite-map and flatness infrastructure is developed separately;
this module packages the dimension/finite-kernel equivalence that is already
available over an arbitrary field.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicGeometry

namespace MilneLib

/-- For homomorphisms of abelian varieties over a field, being an isogeny is
equivalent to having finite scheme-theoretic kernel and equal global Krull
dimension.  This is the `(a) <-> (c)` slice of Milne's four-way
characterization; the projectivity and flatness slices remain separate. -/
theorem Isogeny.iff_topologicalKrullDim_eq_and_finite_kernel
    {K : Type u} [Field K]
    {A B : Over (Spec (.of K))} [GrpObj A] [GrpObj B]
    (hA : IsAbelianVariety A) (hB : IsAbelianVariety B)
    (f : A ⟶ B) [IsMonHom f] :
    Isogeny f ↔
      topologicalKrullDim A.left = topologicalKrullDim B.left ∧
        IsFinite (isogenyKernelToBase f) := by
  constructor
  · intro h
    exact ⟨Isogeny.topologicalKrullDim_eq_of_isAbelianVariety_of_arbitraryField
      hA hB f h, Isogeny.finite_kernel f h⟩
  · rintro ⟨hdim, hker⟩
    exact Isogeny.of_topologicalKrullDim_eq_of_finite_kernel_of_arbitraryField
      hA hB f hker hdim

end MilneLib
