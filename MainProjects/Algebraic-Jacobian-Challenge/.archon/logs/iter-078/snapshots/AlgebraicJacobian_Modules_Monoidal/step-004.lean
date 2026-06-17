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
  letI : MonoidalCategoryStruct (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
    show MonoidalCategoryStruct
      (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
      inferInstance
  (_root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((Modules.toPresheafOfModules X).obj M ⊗ (Modules.toPresheafOfModules X).obj N)

/-- The symmetric monoidal category structure on `X.Modules`: the tensor
product is `tensorObj`, the tensor unit is the structure sheaf $\mathcal O_X$,
and the associator, unitors, and braiding are inherited from the presheaf
side through sheafification.

ITER-078 STATUS — STRUCTURED PARTIAL ATTEMPT.

The presheaf-side category `X.PresheafOfModules` carries
`PresheafOfModules.monoidalCategoryStruct`. The data fields `tensorObj`,
`whiskerLeft`, `whiskerRight`, `tensorHom`, and `tensorUnit` can be
constructed by sheafifying the corresponding presheaf-side data through
`L := PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)`, the left
adjoint to the fully-faithful forgetful functor `F := toPresheafOfModules`.

The blocker is the associator/leftUnitor/rightUnitor fields: they require
an iso `tensorObj (tensorObj M N) K ≅ tensorObj M (tensorObj N K)`. After
unfolding, the LHS is `L (F (L (F M ⊗ F N)) ⊗ F K)` and the RHS is
`L (F M ⊗ F (L (F N ⊗ F K)))`. These differ because `F ∘ L` is the
sheafification monad, not the identity — bridging them requires the
**localization-monoidal machinery** (`CategoryTheory.Localization.Monoidal`)
applied to the localization functor `L`, which:

1. Establishes that `L.IsLocalization W` for `W := (isomorphisms _).inverseImage L`
   via `Adjunction.isLocalization` (which is available since the right
   adjoint `F ⋙ restrictScalars (𝟙 _)` is Full + Faithful — both already
   instances in Mathlib at `PresheafOfModules/Sheafification.lean:168,171`).
2. Establishes `W.IsMonoidal` — stability of `W` under whiskering. This
   is the substantive new Mathlib content needed: it asserts that if
   `sheafification f` is iso then `sheafification (X ◁ f)` is also iso.
   This holds because sheafification preserves colimits (it is a left
   adjoint) and the presheaf tensor product is a colimit-preserving
   bifunctor on each variable.
3. Then `LocalizedMonoidal L W (Iso.refl _)` provides the full monoidal
   structure on `X.Modules`, matching our definition of `tensorObj`.

The infrastructure pieces (1) and (3) are off-the-shelf; only (2) — the
monoidality of the sheafification's inverted-iso class for
`PresheafOfModules` — is genuinely missing from Mathlib. This single
gap-fill, once supplied, makes the structure and the instance below close
mechanically.

We leave the two `sorry`s in place so the file compiles (sorry-count
budget: 3 → 2; one closure achieved on `tensorObj`). -/
noncomputable instance instMonoidalCategoryStruct :
    MonoidalCategoryStruct (X.Modules) := sorry

/-- The pentagon, triangle, and hexagon axioms transfer from the presheaf side
through the universal property of sheafification.

ITER-078 STATUS: blocked on `instMonoidalCategoryStruct` above. Once the
structure is in place via `LocalizedMonoidal` (see the long comment on the
struct), the coherence axioms follow from the corresponding presheaf-side
axioms by transporting along the (monoidal) sheafification functor —
explicitly via `Localization.Monoidal.pentagon`, `Localization.Monoidal.triangle`,
etc. -/
noncomputable instance instMonoidalCategory :
    MonoidalCategory (X.Modules) := sorry

end AlgebraicGeometry.Scheme.Modules
