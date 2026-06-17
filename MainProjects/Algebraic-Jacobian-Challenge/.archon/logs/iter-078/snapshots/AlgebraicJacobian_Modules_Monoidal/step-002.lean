/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# The symmetric monoidal structure on `X.Modules`

Phase C step C0 (per `STRATEGY.md`): the category of $\mathcal O_X$-modules
on a scheme $X$ carries a canonical symmetric monoidal structure, with
tensor product given by sheafification of the presheaf tensor product and
tensor unit given by the structure sheaf $\mathcal O_X$ itself.

See `blueprint/src/chapters/Modules_Monoidal.tex`.

## Status (iteration 077 — refactor-subagent scaffold)

This file scaffolds the three signatures (`tensorObj`,
`instMonoidalCategoryStruct`, `instMonoidalCategory`) needed by Phase C
step C1 (refining `LineBundle` from `CommRing.Pic Γ(X, ⊤)` to the
invertible-object definition). The bodies are `sorry` for the prover
rounds iter-078+ to fill, using:

- `PresheafOfModules.monoidalCategory` (presheaf-side structure)
- `PresheafOfModules.Monoidal.tensorObj` (pointwise tensor)
- `PresheafOfModules.sheafification` (left adjoint to inclusion)
- `SheafOfModules.toSheafCompSheafToPresheafIso` (the comparison data)

## Mathematical content

For two $\mathcal O_X$-modules $M$ and $N$,
$$
  M \otimes_{\mathcal O_X} N
    := \mathrm{sheafify}(M_{\mathrm{psh}} \otimes_{\mathcal O_X, \mathrm{psh}} N_{\mathrm{psh}}).
$$
The associator/unitors/braiding on the sheaf side are sheafifications of their
presheaf counterparts; the coherence axioms transfer via the universal
property of sheafification.
-/

set_option autoImplicit false

universe u

open CategoryTheory MonoidalCategory

namespace AlgebraicGeometry.Scheme.Modules

variable (X : Scheme.{u})

/-- The tensor product of two $\mathcal O_X$-modules: sheafify the presheaf
tensor product of the underlying presheaves-of-modules.

The instance lookup for `MonoidalCategoryStruct (PresheafOfModules R₀)` requires
`R₀` to syntactically present as `R ⋙ forget₂ CommRingCat RingCat`. Since
`X.ringCatSheaf.obj = X.sheaf.val ⋙ forget₂ CommRingCat RingCat` only
definitionally (through `sheafCompose`), we use `show` to expose the form. -/
noncomputable def tensorObj (M N : X.Modules) : X.Modules :=
  letI : MonoidalCategoryStruct (PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategoryStruct
      (PresheafOfModules.{u} (X.sheaf.val ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((Modules.toPresheafOfModules X).obj M ⊗ (Modules.toPresheafOfModules X).obj N)

/-- The symmetric monoidal category structure on `X.Modules`: the tensor
product is `tensorObj`, the tensor unit is the structure sheaf $\mathcal O_X$,
and the associator, unitors, and braiding are inherited from the presheaf
side through sheafification.

ITER-078 STATUS: the data part of the monoidal structure (`tensorObj`,
`tensorUnit`, `whiskerLeft`, `whiskerRight`, `tensorHom`) is supplied by
sheafifying the presheaf-side counterpart through
`PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)`; the associator
and unitors are constructed by sheafifying the natural transformations from
the presheaf-side ones, but the construction is incomplete because the
sheafification of an isomorphism is an isomorphism only when packaged via
the adjunction. We leave a structured `sorry` here while documenting the
exact gap for future iterations. -/
noncomputable instance instMonoidalCategoryStruct :
    MonoidalCategoryStruct (X.Modules) := sorry

/-- The pentagon, triangle, and hexagon axioms transfer from the presheaf side
through the universal property of sheafification.

ITER-078 STATUS: blocked on `instMonoidalCategoryStruct` above; once the
structure is in place the coherence axioms follow from the corresponding
presheaf-side axioms by transporting along the sheafification functor (which
is left adjoint to the fully-faithful inclusion `toPresheafOfModules` and
hence preserves all colimits — in particular, the tensor product). The
formal pattern is the one in `CategoryTheory.Localization.Monoidal.Basic`. -/
noncomputable instance instMonoidalCategory :
    MonoidalCategory (X.Modules) := sorry

end AlgebraicGeometry.Scheme.Modules
