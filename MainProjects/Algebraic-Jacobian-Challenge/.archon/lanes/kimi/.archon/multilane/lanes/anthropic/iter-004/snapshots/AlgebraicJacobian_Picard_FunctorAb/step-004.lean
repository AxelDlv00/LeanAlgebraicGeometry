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
Wraps `PicardFunctor.quotMap` via `AddCommGrpCat.ofHom`, transporting the
multiplicative `Pic` quotient through `Additive` to obtain the
`AddCommGroup` instance required by `AddCommGrpCat.of`. -/
noncomputable def PicardFunctorAb
    (C : Over (Spec (CommRingCat.of k))) :
    (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u} where
  obj S := AddCommGrpCat.of (Additive
    (Pic (Limits.pullback C.hom S.unop.hom) ⧸
      (Pic.pullback (Limits.pullback.snd C.hom S.unop.hom)).range))
  map {_ _} f :=
    AddCommGrpCat.ofHom (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop))
  map_id _ := by
    simp only [unop_id, PicardFunctor.quotMap_id, MonoidHom.toAdditive_id,
      AddCommGrpCat.ofHom_id]
  map_comp f g := by
    simp only [unop_comp, PicardFunctor.quotMap_comp]
    rw [show MonoidHom.toAdditive
        ((PicardFunctor.quotMap C g.unop).comp (PicardFunctor.quotMap C f.unop)) =
        (MonoidHom.toAdditive (PicardFunctor.quotMap C g.unop)).comp
          (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop)) from rfl,
      AddCommGrpCat.ofHom_comp]

end AlgebraicGeometry.Scheme
