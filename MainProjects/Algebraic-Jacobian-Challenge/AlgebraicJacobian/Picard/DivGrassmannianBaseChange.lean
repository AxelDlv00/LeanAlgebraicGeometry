/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianEvaluationNaturality
import AlgebraicJacobian.Picard.DivTwistPushforwardProducers
import AlgebraicJacobian.Picard.FiniteSupportCanonicalBaseChange

/-!
# Base change of divisor Grassmannian classes

The divisor-to-Grassmannian construction commutes with arbitrary changes of
test scheme. The finite support of a curve divisor makes the canonical target
base-change map invertible; evaluation compatibility then gives equality of
the locally free quotient classes.

This is the D2 adaptation of the functoriality mechanism in Kleiman,
*The Picard scheme*, `th:LinSys` (TeX lines 2000--2004). It does not assert
representability of the linear-system or Picard functor.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry.Scheme.DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T T' : Over S}
variable [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]

/-- Pushforward of a twisted curve divisor commutes with arbitrary base change.
The finite-support theorem applies to the canonical comparison itself. -/
noncomputable def pushforwardTwistPullbackIso_of_curve
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (ψ : T' ⟶ T) :
    (Modules.pullback ψ.left).obj
        ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) ≅
      (Modules.pushforward (pullback.snd π T'.hom)).obj
        ((x.pullbackAlong ψ).twist L) := by
  letI : (x.twist L).IsFinitePresentation := x.twist_isFinitePresentation L hL
  letI : (x.twist L).IsQuasicoherent := inferInstance
  have hbc : IsIso ((canonicalBaseChangeMap (quotBaseSquare π ψ)).app (x.twist L)) :=
    canonicalBaseChangeMap_isIso_of_isFinite_schematicSupport
      (quotBaseSquare π ψ) (x.twist L) (twist_isFiniteSupport_of_curve L hL x)
  exact @asIso _ _ _ _
    ((canonicalBaseChangeMap (quotBaseSquare π ψ)).app (x.twist L)) hbc ≪≫
    (Modules.pushforward (pullback.snd π T'.hom)).mapIso (twistPullbackIso L x ψ hL)

@[simp]
theorem pushforwardTwistPullbackIso_of_curve_hom
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (ψ : T' ⟶ T) :
    (pushforwardTwistPullbackIso_of_curve L hL x ψ).hom =
      (canonicalBaseChangeMap (quotBaseSquare π ψ)).app (x.twist L) ≫
        (Modules.pushforward (pullback.snd π T'.hom)).map
          (twistPullbackMap L x ψ) := rfl

set_option backward.isDefEq.respectTransparency false in
/-- Surjectivity of the D2 evaluation persists under every change of test
scheme, including nonflat maps and nonnoetherian targets. -/
theorem grassmannianEval_epi_pullback_of_curve
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (ψ : T' ⟶ T)
    (hEpi : Epi (x.grassmannianEval L)) :
    Epi ((x.pullbackAlong ψ).grassmannianEval L) := by
  letI := hEpi
  let e := pushforwardTwistPullbackIso_of_curve L hL x ψ
  have he : ((pullbackTriangleIso (Over.w ψ) ((Modules.pushforward π).obj L)).inv ≫
      (Modules.pullback ψ.left).map (x.grassmannianEval L)) ≫ e.hom =
      (x.pullbackAlong ψ).grassmannianEval L := by
    simpa only [e, pushforwardTwistPullbackIso_of_curve_hom, Category.assoc] using
      grassmannianEval_pullback L x ψ
  rw [← he]
  exact epi_comp' (epi_comp' inferInstance
    (Functor.map_epi (Modules.pullback ψ.left) (x.grassmannianEval L))) inferInstance

/-- The rank of the twisted divisor pushforward is preserved by arbitrary
base change once that pushforward is locally free. -/
theorem grassmannianTarget_isLocallyFreeOfRank_pullback_of_curve
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (ψ : T' ⟶ T) {d : ℕ}
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T'.hom)).obj
        ((x.pullbackAlong ψ).twist L)) d :=
  Modules.isLocallyFreeOfRank_of_iso_general
    (pushforwardTwistPullbackIso_of_curve L hL x ψ).symm
    (Modules.pullback_isLocallyFreeOfRank ψ.left hLocFree)

/-- D2 quotient classes commute with arbitrary change of test scheme. The
evaluation epi and target rank are needed only before base change; the
preceding theorems supply them for the pulled-back divisor family. -/
theorem grassmannianClass_pullback_of_curve
    [IsLocallyNoetherian S]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) (ψ : T' ⟶ T) {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    (Grassmannian ((Modules.pushforward π).obj L) d).map ψ.op
        (x.grassmannianClass L hEpi hLocFree) =
      (x.pullbackAlong ψ).grassmannianClass L
        (grassmannianEval_epi_pullback_of_curve L hL x ψ hEpi)
        (grassmannianTarget_isLocallyFreeOfRank_pullback_of_curve L hL x ψ hLocFree) := by
  apply Quotient.sound
  refine ⟨pushforwardTwistPullbackIso_of_curve L hL x ψ, ?_⟩
  change ((pullbackTriangleIso (Over.w ψ) ((Modules.pushforward π).obj L)).inv ≫
      (Modules.pullback ψ.left).map (x.grassmannianEval L)) ≫
      ((canonicalBaseChangeMap (quotBaseSquare π ψ)).app (x.twist L) ≫
        (Modules.pushforward (pullback.snd π T'.hom)).map
          (twistPullbackMap L x ψ)) = (x.pullbackAlong ψ).grassmannianEval L
  simpa only [Category.assoc] using grassmannianEval_pullback L x ψ

end AlgebraicGeometry.Scheme.DivFamily
