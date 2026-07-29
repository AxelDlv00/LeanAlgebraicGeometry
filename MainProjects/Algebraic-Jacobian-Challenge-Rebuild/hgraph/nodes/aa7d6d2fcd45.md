---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Scheme.LocalEquations.divEq_pullback_pullback
docstring: '**Pullback of a divisor composes**: pulling back in two stages along `g`
  then `f` is

  `DivEq` to pulling back along a morphism (propositionally) equal to the composite

  `g ≫ f`, with unit `1` — the two covers agree (preimage of preimage is preimage
  of the

  composite) and the equations agree on the nose (`Scheme.Hom.appLE_comp_appLE`).

  Representative input of the functor law `DivFam.mapAlg_comp`.'
file: AlgebraicJacobian/Picard/DivisorFamilyMapAlg.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.LocalEquations.divEq_pullback_pullback
type: lean
updated: '2026-07-29T15:26:30'
---
theorem divEq_pullback_pullback {X Y Z : Scheme.{u}} {f : Y ⟶ X} {g : Z ⟶ Y} {h : Z ⟶ X}
    (hgf : g ≫ f = h) (E : X.LocalEquations) (hreg₁) (hreg₂) (hreg₃) :
    DivEq ((E.pullback f hreg₁).pullback g hreg₂) (E.pullback h hreg₃) := by
  subst hgf
  have hcov : ∀ z : Z, ((E.cover.pullback f).pullback g).opens z ≤
      (E.cover.pullback (g ≫ f)).opens z := fun z =>
    le_of_eq (by
      rw [Scheme.PointedCover.pullback_opens, Scheme.PointedCover.pullback_opens,
        Scheme.PointedCover.pullback_opens, Scheme.Hom.comp_preimage,
        Scheme.Hom.comp_apply])
  refine ⟨(E.cover.pullback f).pullback g, fun z => le_rfl, hcov, fun z => ⟨1, ?_⟩⟩
  rw [Units.val_one, one_mul]
  -- the two-stage pulled equation is `appLE ≫ appLE` of the base equation, which is
  -- `appLE` of the composite (`Scheme.Hom.appLE_comp_appLE`); both restriction
  -- collapses are `pullbackEqn_res`
  have h2 := congr(($(Scheme.Hom.appLE_comp_appLE g f
    (E.cover.opens (f.base (g.base z))) ((E.cover.pullback f).opens (g.base z))
    (((E.cover.pullback f).pullback g).opens z) le_rfl le_rfl)).hom
      (E.eqn (f.base (g.base z))))
  exact (pullbackEqn_res g (E.pullback f hreg₁) z le_rfl).trans
    (h2.trans (pullbackEqn_res (g ≫ f) E z (hcov z)).symm)

end Scheme.LocalEquations

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
variable {π : C.left ⟶ P1 k} [IsAffineHom π]

namespace DivisorAdaptation

variable {d : (relCurve C R).LocalEquations} (A : DivisorAdaptation C R π d)

/-! ## The base-changed adaptation -/