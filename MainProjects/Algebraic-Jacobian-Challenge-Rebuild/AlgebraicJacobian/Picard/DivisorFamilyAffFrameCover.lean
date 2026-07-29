/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffFraming
import AlgebraicJacobian.Picard.DivSchemeFrameCover

/-!
# The ε frame cover, keyed on the WINDOW QUOTIENT rather than on a carrier

Roadmap leaf `AJCR.w4-rep.datum.dat-d.ddr.divrep.framecover-aff`.

`Picard/DivisorFamilyAffFraming.lean` established that the ε-pair and its pair-chart framing
clause are expressible over the widened carrier, and recorded what it did not do:

> It does not prove `exists_certChartCover` over the widened carrier — that theorem's proof
> runs the certificate cover and the per-piece frame covers, which is real work and belongs to
> whoever restates it.

**This file measures that work, and the measurement is the content.**  The frame-cover
keystone `divFamEps_exists_frameCover` (`Picard/DivSchemeFrameCover.lean:456`) reads its
carrier `DivFam C S π g` at exactly **three** points, all inside
`exists_frame_chart_at_prime`: `Module.Finite`, `Module.Projective` and
`rankAtStalk … = g` of the window quotient
`(R ⊗[k] H_a) ⧸ divisorWindow d`.  Everything downstream — `exists_away_free_pair`,
`exists_component_matrix`, `exists_det_submatrix_notMem_of_mul_eq_one`,
`exists_away_isUnit_of_notMem`, `map_component_chart` — consumes a Grassmannian *point* and a
base ring, and never asks what produced the submodule.

And `divisorWindow d hH1` (`Picard/DivisorFamilyWindow.lean:103`) is a `Submodule.comap` of
`d.vanishingSubmodule`: it takes the local-equation system and the H¹ vanishing, and mentions
**no** adaptation, **no** cover and **no** chart typing.  So the window layer is not
chart-typed at all; the chart typing entered only through the *route* by which the chart-typed
files supplied those three facts (`windowQuotEquiv` from `IsCertified`'s (c2) clauses).

## The one step that is genuinely new

Restating the layer with the three facts as hypotheses is free, but the tower transport is
not.  The chart-typed `map_divFamWindowGr` (`Picard/DivSchemeFrameCover.lean:188`) proves
`Grassmannian.map β (point over R_h) = point over R_u` by routing through the divisor
*object* — `DivFam.window_mapAlg` on both legs plus `DivFam.mapAlg_comp` — which needs a
carrier with a functorial `mapAlg`.  Carrier-free there is no object to route through, so the
composite must be proved where it actually lives, on the submodule:

* `windowBaseChange_windowBaseChange` — transitivity of the window pushforward over a tower
  `R → R' → R''`, for an arbitrary `k`-module ambient `H`.  Not in the tree before; both
  inclusions are `windowBaseChange_le_iff` against the compared generators, and the content
  is one `cancelBaseChange` compatibility (`rfl` fails on it, checked).

## What this does and does NOT establish

It does **not** produce a widened divisor-representability, and no antecedent of
`pic0RepresentableByOfCharts` moves.  Specifically: the three window-quotient facts are
**hypotheses** here, and on the widened side the route to them runs through
`AffAdaptation.windowQuotEquiv` (`Picard/DivisorFamilyAffTheta.lean:914`), which is itself
conditional on surjectivity of the widened `thetaGluedEval` — a statement that file explicitly
does not prove.  So the honest ledger is:

  the frame cover's chart dependence   REMOVED (this file)
  the three window-quotient facts      OPEN on the widened side, reducing to widened
                                       evaluation surjectivity

That is a relocation of the obligation, not a discharge of it, and the relocation is worth
recording because it replaces "restate a 24-module tower" with one named surjectivity.

## Main declarations

* `AlgebraicGeometry.divisorWindowGrOfQuot` — the window as a Grassmannian point from the
  quotient certificate alone; `divFamWindowGr` with its vehicle removed.
* `AlgebraicGeometry.windowBaseChange_windowBaseChange` — transitivity of the window
  pushforward.
* `AlgebraicGeometry.map_divisorWindowGrOfQuot` — the tower transport, carrier-free.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

open Grassmannian Scheme

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

section Curve

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]

noncomputable local instance instOverCleftAffFrameCover :
    C.left.Over (Spec (CommRingCat.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [IsDominant π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)

/-! ## The window layer, keyed on the window submodule rather than on a carrier -/

section WindowLayer

-- The curve instances of the ambient section are genuinely unused in this layer: the window
-- Grassmannian point is built from `divisorWindow d` and three facts about its quotient, and
-- `divisorWindow` names no adaptation, cover or chart typing.  That is the measurement this
-- section exists to record, so the linter is silenced rather than the variables omitted (the
-- ambient instances are mutually referenced and cannot be dropped individually).
set_option linter.unusedSectionVars false

variable (a : ℕ) (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
variable {R : Type u} [CommRing R] [Algebra k R]

/-- **The window as a Grassmannian point, from the quotient certificate alone**: the
`windowBaseChangeGr` package of `divisorWindow d`, taking the three quotient facts as
hypotheses rather than extracting them from an adaptation.

This is `divFamWindowGr` (`Picard/DivSchemeFrameCover.lean:143`) with its vehicle removed.
`divisorWindow` (`Picard/DivisorFamilyWindow.lean:103`) is a `Submodule.comap` of
`d.vanishingSubmodule` and mentions no adaptation, no cover and no chart typing, so
nothing here knows which carrier certified `d`. -/
noncomputable def divisorWindowGrOfQuot (d : (relCurve C R).LocalEquations)
    (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
    [Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    [Module.Projective R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) p = g) :
    Grassmannian.grFunctorAff k
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤) g R' :=
  windowBaseChangeGr R' (divisorWindow d ha1) g hrank

@[simp]
lemma divisorWindowGrOfQuot_toSubmodule (d : (relCurve C R).LocalEquations)
    (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
    [Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    [Module.Projective R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) p = g) :
    (divisorWindowGrOfQuot g a ha1 d R' hrank).toSubmodule
      = windowBaseChange R' (divisorWindow d ha1) :=
  rfl

/-- **Transitivity of the window pushforward** over a tower `R → R' → R''`.

This is the step the chart-typed transport did NOT have to prove: `map_divFamWindowGr`
(`Picard/DivSchemeFrameCover.lean:188`) reaches the same conclusion by going *through the
divisor object* — `DivFam.window_mapAlg` on both legs plus `DivFam.mapAlg_comp` — which needs
a carrier with a functorial `mapAlg`.  Carrier-free there is no object to route through, so
the composite has to be proved where it lives, on the submodule.

Both inclusions are `windowBaseChange_le_iff` against the compared generators; the tower
hypothesis enters only as `IsScalarTower`, and `H` is an arbitrary `k`-module. -/
theorem windowBaseChange_windowBaseChange {H : Type u} [AddCommGroup H] [Module k H]
    {R : Type u} [CommRing R] [Algebra k R]
    (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
    (R'' : Type u) [CommRing R''] [Algebra k R''] [Algebra R R''] [Algebra R' R'']
    [IsScalarTower k R R''] [IsScalarTower k R' R''] [IsScalarTower R R' R'']
    (N : Submodule R (R ⊗[k] H)) :
    windowBaseChange R'' (windowBaseChange R' N) = windowBaseChange R'' N := by
  -- the `R'`-linear comparison arrow `R' ⊗[k] H → R'' ⊗[k] H` of the upper leg
  set ψ : (R' ⊗[k] H) →ₗ[R'] (R'' ⊗[k] H) :=
    (TensorProduct.AlgebraTensorModule.cancelBaseChange k R' R'' R'' H).toLinearMap ∘ₗ
      (TensorProduct.mk R' R'' (R' ⊗[k] H) 1) with hψdef
  have hψ : ∀ y : R' ⊗[k] H, ψ y
      = TensorProduct.AlgebraTensorModule.cancelBaseChange k R' R'' R'' H (1 ⊗ₜ y) :=
    fun _ => rfl
  -- the tower compatibility of the comparison: the two legs agree on the lower generators
  have key : ∀ x : R ⊗[k] H,
      ψ (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' H (1 ⊗ₜ x))
        = TensorProduct.AlgebraTensorModule.cancelBaseChange k R R'' R'' H (1 ⊗ₜ x) := by
    intro x
    induction x using TensorProduct.induction_on with
    | zero => simp
    | add x y hx hy => simp only [TensorProduct.tmul_add, map_add, hx, hy]
    | tmul r h => simp [hψ]
  refine le_antisymm ?_ ?_
  · -- `⊆`: test the upper generators, then the lower ones through `ψ`
    rw [windowBaseChange_le_iff]
    have hstep : windowBaseChange R' N
        ≤ Submodule.comap ψ ((windowBaseChange R'' N).restrictScalars R') := by
      rw [windowBaseChange_le_iff]
      intro x hx
      refine Submodule.mem_comap.mpr ?_
      rw [key x]
      exact cancelBaseChange_one_tmul_mem_windowBaseChange hx
    intro y hy
    rw [← hψ y]
    exact hstep hy
  · -- `⊇`: a lower generator is `ψ` of an upper generator
    rw [windowBaseChange_le_iff]
    intro x hx
    rw [← key x, hψ]
    exact cancelBaseChange_one_tmul_mem_windowBaseChange
      (cancelBaseChange_one_tmul_mem_windowBaseChange hx)

set_option maxHeartbeats 800000 in
-- Instantiates the window pushforward at two localizations inside a `toAlgebra` tower; the
-- same elaboration profile as the chart-typed `map_divFamWindowGr`, which is budgeted
-- identically.
/-- **The tower transport of the window point, carrier-free** — the analogue of
`map_divFamWindowGr` (`Picard/DivSchemeFrameCover.lean:188`) with no `DivFam` in it. -/
theorem map_divisorWindowGrOfQuot (d : (relCurve C R).LocalEquations)
    [Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    [Module.Projective R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) p = g)
    (h u : R) (β : Localization.Away h →ₐ[k] Localization.Away u)
    (hβ : β.toRingHom.comp (algebraMap R (Localization.Away h))
      = algebraMap R (Localization.Away u)) :
    Module.Grassmannian.map β
        (divisorWindowGrOfQuot g a ha1 d (Localization.Away h) hrank)
      = divisorWindowGrOfQuot g a ha1 d (Localization.Away u) hrank := by
  letI : Algebra (Localization.Away h) (Localization.Away u) := β.toAlgebra
  letI : IsScalarTower k (Localization.Away h) (Localization.Away u) :=
    IsScalarTower.of_algebraMap_eq' (IsScalarTower.algebraMap_eq k _ _)
  haveI htowerR : IsScalarTower R (Localization.Away h) (Localization.Away u) := by
    refine IsScalarTower.of_algebraMap_eq' ?_
    rw [RingHom.algebraMap_toAlgebra]
    exact hβ.symm
  refine Module.Grassmannian.ext ?_
  rw [Module.Grassmannian.map_toSubmodule β
      (divisorWindowGrOfQuot g a ha1 d (Localization.Away h) hrank),
    divisorWindowGrOfQuot_toSubmodule]
  -- the projective-quotient instance the `ker_baseChangeMkQ` description consumes is the
  -- Grassmannian point's own field, at the intermediate ring
  haveI : Module.Projective (Localization.Away h)
      ((Localization.Away h ⊗[k]
        ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        windowBaseChange (Localization.Away h) (divisorWindow d ha1)) :=
    (divisorWindowGrOfQuot g a ha1 d (Localization.Away h) hrank).projective_quotient
  rw [Grassmannian.ker_baseChangeMkQ_eq_map_baseChange (Localization.Away u)
      (windowBaseChange (Localization.Away h) (divisorWindow d ha1)),
    divisorWindowGrOfQuot_toSubmodule]
  exact windowBaseChange_windowBaseChange (Localization.Away h) (Localization.Away u)
    (divisorWindow d ha1)

end WindowLayer

end Curve

end AlgebraicGeometry
