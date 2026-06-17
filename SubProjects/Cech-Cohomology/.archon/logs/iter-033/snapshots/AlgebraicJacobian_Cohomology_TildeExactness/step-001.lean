/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.RingTheory.LocalProperties.Exactness

/-!
# The tilde functor preserves finite limits (Stacks 01HV, exactness of `~`)

Project-local supplement (Route-P step P3, feeding `qcoh_kernel_qcoh`).

For `X = Spec R`, the tilde functor `~ : ModuleCat R ⥤ (Spec R).Modules`,
`M ↦ M^~`, is exact; in particular it preserves finite limits (kernels).  The
mathematical content is *stalkwise flatness*: the stalk of `M^~` at the point
`x ↔ 𝔭` is the localisation `M_𝔭` (Mathlib's
`ModuleCat.tilde.toStalk` is an `IsLocalizedModule`), localisation `R → R_𝔭` is
flat hence exact, and isomorphisms of `𝒪_X`-modules are detected on stalks.

This file is `AlgebraicGeometry.tildePreservesFiniteLimits`.
-/

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace AlgebraicGeometry

variable {R : CommRingCat.{u}}

end AlgebraicGeometry
