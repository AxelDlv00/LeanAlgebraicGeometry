/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.Functor

/-!
# The relative Picard functor as an abelian-group-valued presheaf

Phase C step 3 setup (per `STRATEGY.md`): the `AddCommGrpCat`-valued variant
of the relative Picard functor of Chapter `Picard_Functor.tex`. The
underlying-set functor agrees on the nose with the iter-004 `PicardFunctor`;
only the codomain changes from `Type u` to `AddCommGrpCat.{u}`. This is the
input shape required by `CategoryTheory.presheafToSheaf` for the (deferred)
étale sheafification of the Picard presheaf.

See `blueprint/src/chapters/Picard_FunctorAb.tex`.

## Status (iteration 004 — refactor scaffold)

This file is a scaffold. The single definition below is `sorry`. The next
prover round wraps `PicardFunctor.quotMap` (closed in iter-004) via
`AddCommGrpCat.ofHom` to discharge it.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [Field k]

/-- Phase C step 3 codomain change: the `AddCommGrpCat`-valued variant of the
relative Picard functor. The underlying-set functor agrees on the nose with
`PicardFunctor` (Chapter `Picard_Functor.tex`); only the codomain changes.
Wraps `PicardFunctor.quotMap` via `AddCommGrpCat.ofHom`. -/
noncomputable def PicardFunctorAb
    (C : Over (Spec (CommRingCat.of k))) :
    (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u} := sorry

end AlgebraicGeometry.Scheme
