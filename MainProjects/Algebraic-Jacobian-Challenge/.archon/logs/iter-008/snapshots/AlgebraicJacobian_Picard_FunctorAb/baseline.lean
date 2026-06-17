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

## Status (iteration 004 — prover round)

`PicardFunctorAb` is **filled**: the underlying-set quotient
`Pic(C ×_k S) / p_S^* Pic(S)` is wrapped through `Additive` (which converts
the multiplicative `CommGroup` instance on `Pic` to the `AddCommGroup`
instance demanded by `AddCommGrpCat.of`), and the action on morphisms is
`PicardFunctor.quotMap` post-composed with `MonoidHom.toAdditive` and bundled
via `AddCommGrpCat.ofHom`. Functoriality reduces on the nose to
`PicardFunctor.quotMap_id` / `PicardFunctor.quotMap_comp` and the
multiplicative-to-additive equiv `MonoidHom.toAdditive`.

## Status (iteration 008 — étale-sheafification scaffold)

`PicardFunctorAb.etaleSheafified` is **scaffolded**: the étale-topology
sheafification of `PicardFunctorAb`, packaged as a sheaf on
`Scheme.etaleTopology.{u}` over `Spec k` valued in `AddCommGrpCat.{u+1}`.
The body post-composes with `AddCommGrpCat.uliftFunctor.{u+1, u}` to bridge
the universe gap between the iter-004 codomain `AddCommGrpCat.{u}` and the
value-universe `AddCommGrpCat.{u+1}` at which `HasSheafify` is inferable in
current Mathlib. The closure body is a one-liner against
`CategoryTheory.presheafToSheaf`; the prover round will install it.
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

/-- Phase C step 3 forget-and-recover: the natural iso recovering
`PicardFunctor C` from `PicardFunctorAb C ⋙ forget AddCommGrpCat`. The
underlying-set functor of `PicardFunctorAb` agrees on the nose with
`PicardFunctor` (via the type-equal `Additive` wrapper of the iter-004
closure), so the iso is the identity natural transformation. See blueprint
chapter `Picard_FunctorAb.tex` (`def:PicardFunctorAb_forgetCompare`). -/
noncomputable def PicardFunctorAb.forgetCompare
    (C : Over (Spec (CommRingCat.of k))) :
    PicardFunctorAb C ⋙ CategoryTheory.forget AddCommGrpCat.{u} ≅ PicardFunctor C :=
  NatIso.ofComponents (fun _ => Iso.refl _) (by intros; rfl)

/-- Object-evaluation simp lemma for `PicardFunctorAb` along the forgetful
functor. The `Additive` wrapper inside the iter-004 `PicardFunctorAb` is
type-equal to its underlying multiplicative quotient, so applying
`forget AddCommGrpCat` recovers `(PicardFunctor C).obj S` on the nose. Tagged
`@[simp]` for downstream rewriting. Phase C step 4 polish (iter-007). -/
@[simp] lemma PicardFunctorAb_forget_obj (C : Over (Spec (CommRingCat.of k)))
    (S : (Over (Spec (CommRingCat.of k)))ᵒᵖ) :
    (CategoryTheory.forget AddCommGrpCat).obj ((PicardFunctorAb C).obj S)
      = (PicardFunctor C).obj S :=
  rfl

/-- Phase C step 3 *proper*: étale-sheafify `PicardFunctorAb C` to obtain
a sheaf on `Scheme.etaleTopology.{u}` over `Spec k` valued in
`AddCommGrpCat.{u+1}`. Post-composes with the universe-lift functor
`AddCommGrpCat.uliftFunctor.{u+1, u}` to bridge the gap between the
iter-004 codomain `AddCommGrpCat.{u}` and the value-universe
`AddCommGrpCat.{u+1}` at which `HasSheafify` is inferable in current
Mathlib. See blueprint chapter `Picard_FunctorAb.tex`
(`def:PicardFunctorAb_etaleSheafified`). Phase C step 3 *proper* (iter-008).
-/
noncomputable def PicardFunctorAb.etaleSheafified
    (C : Over (Spec (CommRingCat.of k))) :
    Sheaf ((Scheme.etaleTopology.{u}).over (Spec (CommRingCat.of k)))
      AddCommGrpCat.{max u (u+1)} :=
  sorry

end AlgebraicGeometry.Scheme
