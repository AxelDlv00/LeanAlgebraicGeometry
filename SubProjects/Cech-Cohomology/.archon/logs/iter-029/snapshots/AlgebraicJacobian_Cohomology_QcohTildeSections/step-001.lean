/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Quasi-coherent sheaves on an affine are sections-tilde (Stacks 01HV/01I8)

Project-local: the affine quasi-coherent structure theorem.  For a quasi-coherent
`O_X`-module `F` on an affine `X = Spec R`, with `M = Γ(X, F)`, there is a natural
isomorphism `F ≅ ~M`, under which `Γ(D(f), F) = M_f`.  This is the "tilde
globalisation" gap recorded by `def:qcoh_sections_localized`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

end AlgebraicGeometry
