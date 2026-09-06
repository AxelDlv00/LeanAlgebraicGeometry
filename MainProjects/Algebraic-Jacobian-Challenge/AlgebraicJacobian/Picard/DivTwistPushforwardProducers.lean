/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivCurvePushforwardProducers
import AlgebraicJacobian.Picard.DivLocallyClosed
import AlgebraicJacobian.Picard.FiniteSupportPushforwardFiber
import AlgebraicJacobian.Picard.TensorFinitePresentation

/-!
# Finite sections of twisted divisor pushforwards

The Grassmannian comparison uses the pushforward of a locally trivial twist of
a divisor family.  The curve support producer and the finite-support
section theorem already work over an arbitrary test object; this file exposes
their composition for the actual twisted target.  The result is the finite
module input for the later finite-flat/local-free and evaluation producers.

The finite-presentation fact for the twist is supplied by the line-bundle
coherence module from local triviality and finite presentation of the divisor
module.  This keeps the arbitrary-test-base rank producer independent of the
much larger downstream embedding module.

No generation, rank, representability, or rational-point hypothesis is hidden
in this declaration.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

noncomputable section

namespace AlgebraicGeometry

namespace Scheme

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- The locally trivial D2 twist is finitely presented.  This is the intrinsic
producer consumed by finite-support pushforward and flatness; callers do not
need to supply a separate presentation hypothesis. -/
theorem twist_isFinitePresentation
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) :
    (x.twist L).IsFinitePresentation := by
  dsimp [twist]
  exact Modules.isFinitePresentation_tensorObj_left_of_isLocallyTrivial _ _
    (hL.pullback (pullback.fst π T.hom)) x.isFinitePresentation

/-- A locally trivial twist of a divisor family has finite pushforward sections
over every affine open of every test object.  This is the arbitrary-base finite
module producer used by the D2 Grassmannian route. -/
theorem module_finite_sections_pushforward_twist_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T)
    {V : T.left.Opens} (hV : IsAffineOpen V) :
    Module.Finite Γ(T.left, V)
      Γ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L), V) := by
  letI : (x.twist L).IsFinitePresentation := x.twist_isFinitePresentation L hL
  exact Modules.module_finite_sections_pushforward_of_isFinite_schematicSupport
    (pullback.snd π T.hom) (x.twist L)
    (twist_isFiniteSupport_of_curve L hL x) hV

/-- On a locally noetherian test object, the finite sections producer upgrades
the twisted divisor pushforward to finite presentation.  This is the
coherence input for the later finite-flat/local-free Grassmannian step. -/
theorem isFinitePresentation_pushforward_twist_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    [IsLocallyNoetherian (T.left : Scheme.{u})]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) :
    ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)).IsFinitePresentation := by
  letI : (x.twist L).IsFinitePresentation := x.twist_isFinitePresentation L hL
  letI : (x.twist L).IsQuasicoherent := inferInstance
  letI : ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)).IsQuasicoherent :=
    Modules.pushforward_isQuasicoherent (pullback.snd π T.hom) (x.twist L)
  apply Modules.isFinitePresentation_of_finite_sections
  intro V hV
  exact module_finite_sections_pushforward_twist_of_curve L hL x hV

/-! ## Flatness and the rank-stratum bridge -/

set_option maxHeartbeats 2500000 in
-- The affine-cover transport through a line-bundle trivialisation is the
-- only expensive part of this flatness producer; keep its larger heartbeat
-- budget local to the proof rather than raising the module-wide default.
/-- Tensoring a flat sheaf by a locally trivial line bundle preserves flatness
over an arbitrary base morphism, provided the tensor target's finite
presentation is supplied.  The explicit finite-presentation input keeps this
lightweight producer independent of the downstream Grassmannian embedding. -/
theorem coherentSheafFlat_tensorObj_left_of_isLocallyTrivial_with_finitePresentation
    {B Y : Scheme.{u}} (q : Y ⟶ B) (L F : Y.Modules)
    (hL : LineBundle.IsLocallyTrivial L)
    (hTFp : (Modules.tensorObj L F).IsFinitePresentation)
    (hF : CoherentSheafFlat q F) :
    CoherentSheafFlat q (Modules.tensorObj L F) := by
  letI : (Modules.tensorObj L F).IsFinitePresentation := hTFp
  choose U hUaff hxU _hUtop using fun y : Y =>
    exists_isAffineOpen_mem_and_subset (x := q.base y)
      (U := (⊤ : B.Opens)) (by trivial)
  choose W hxW hWaff hWle hWiso using fun y : Y =>
    hL.exists_affine_trivializing_le (x := y) (W := q ⁻¹ᵁ U y) (hxU y)
  intro U0 hU0 W0 hW0 e0
  refine flat_section_of_affine_cover q (Modules.tensorObj L F) W hWaff U hUaff hWle
    (fun y => ⟨y, hxW y⟩) ?_ hU0 hW0 e0
  intro y
  letI : Module Γ(B, U y) Γ((Modules.tensorObj L F), W y) :=
    Module.compHom _ (q.appLE (U y) (W y) (hWle y)).hom
  letI : Module Γ(B, U y) Γ(F, W y) :=
    Module.compHom _ (q.appLE (U y) (W y) (hWle y)).hom
  haveI : Module.Flat Γ(B, U y) Γ(F, W y) := hF (hUaff y) (hWaff y) (hWle y)
  let eL : L.restrict (W y).ι ≅
      SheafOfModules.unit (W y : Scheme).ringCatSheaf := (hWiso y).some
  let eRes : (Modules.tensorObj L F).restrict (W y).ι ≅ F.restrict (W y).ι :=
    Modules.tensorObj_restrict_iso (W y).ι L F ≪≫
      Modules.tensorObjIsoOfIso eL (Iso.refl _) ≪≫
      Modules.tensorObj_left_unitor _
  let eX := Modules.sectionLinearEquivOfRestrictIso (W y) eRes
  letI : Algebra Γ(B, U y) Γ(Y, W y) :=
    (q.appLE (U y) (W y) (hWle y)).hom.toAlgebra
  letI : IsScalarTower Γ(B, U y) Γ(Y, W y) Γ(F, W y) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  letI : IsScalarTower Γ(B, U y) Γ(Y, W y)
      Γ((Modules.tensorObj L F), W y) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  letI : LinearMap.CompatibleSMul Γ((Modules.tensorObj L F), W y) Γ(F, W y)
      Γ(B, U y) Γ(Y, W y) :=
    ⟨fun f c z => by
      rw [← IsScalarTower.algebraMap_smul (Γ(Y, W y)) c z,
        ← IsScalarTower.algebraMap_smul (Γ(Y, W y)) c (f z), f.map_smul]⟩
  exact Module.Flat.of_linearEquiv (M := Γ(F, W y))
    (eX.restrictScalars (Γ(B, U y)))

/-! The support-descent transport below turns this tensor-flatness result into
identity-flatness of the actual pushforward target. -/

/-- The twisted divisor pushforward is flat over an arbitrary test base.  The
proof descends to the finite schematic support, applies affine pushforward
flatness there, and transports back through the support-descent isomorphism. -/
theorem coherentSheafFlat_id_pushforward_twist_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) :
    CoherentSheafFlat (𝟙 (T.left : Scheme.{u}))
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) := by
  letI : (x.twist L).IsFinitePresentation := x.twist_isFinitePresentation L hL
  letI : (x.twist L).IsQuasicoherent := inferInstance
  let q := pullback.snd π T.hom
  let i := Modules.schematicSupportι (x.twist L)
  have hfin : IsFinite (i ≫ q) := twist_isFiniteSupport_of_curve L hL x
  letI : IsFinite (i ≫ q) := hfin
  letI : IsAffineHom (i ≫ q) := inferInstance
  letI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom (Modules.annihilator (x.twist L)).subschemeι)
  let N := (Modules.pullback i).obj (x.twist L)
  have hdesc : x.twist L ≅ (Modules.pushforward i).obj N :=
    Modules.schematicSupportDescentIso (x.twist L)
  haveI : N.IsQuasicoherent := pullback_isQuasicoherent_hom i
    (x.twist L) inferInstance
  have htwflat : CoherentSheafFlat q (x.twist L) := by
    dsimp [DivFamily.twist]
    exact coherentSheafFlat_tensorObj_left_of_isLocallyTrivial_with_finitePresentation q
      ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F
      (hL.pullback (pullback.fst π T.hom))
      (x.twist_isFinitePresentation L hL) x.flat
  have h1 : CoherentSheafFlat q ((Modules.pushforward i).obj N) :=
    coherentSheafFlat_of_iso q hdesc htwflat
  have h2 : CoherentSheafFlat (i ≫ q) N :=
    Scheme.CoherentSheafFlat.of_pushforward_of_isAffineHom i q N h1
  have h3 : CoherentSheafFlat (𝟙 (T.left : Scheme.{u}))
      ((Modules.pushforward (i ≫ q)).obj N) :=
    Scheme.CoherentSheafFlat.pushforward_of_isAffineHom (i ≫ q)
      (𝟙 (T.left : Scheme.{u})) N (by
        intro U hU V hV eV
        have hcomp :
            ((i ≫ q) ≫ (𝟙 (T.left : Scheme.{u}))).appLE U V eV =
              (i ≫ q).appLE U V eV := by
          rw [← Scheme.Hom.appLE_comp_appLE (i ≫ q)
            (𝟙 (T.left : Scheme.{u})) U U V le_rfl eV]
          rw [Scheme.id_appLE]
          simp
        rw [hcomp]
        exact h2 hU hV eV)
  intro U hU V hV eV
  exact coherentSheafFlat_of_iso (𝟙 (T.left : Scheme.{u}))
    ((Modules.pushforwardComp i q).app N ≪≫
      (Modules.pushforward q).mapIso hdesc.symm) h3 hU hV eV

/-- Curve-specialised rank producer for the twisted pushforward.  Once the
point-rank comparison with fibre `H⁰` is supplied, the finite-presentation and
flatness producers above feed the finite-flat criterion on a locally noetherian
test base.  The point-rank premise is intentionally explicit: it is the
remaining base-change/Nakayama obligation, not a hidden representability
assumption. -/
theorem pushforward_twist_isLocallyFreeOfRank_of_pointRank
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    [IsLocallyNoetherian (T.left : Scheme.{u})]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T)
    {d : ℕ}
    (hRank : ∀ t : (T.left : Scheme.{u}),
      Modules.pointRank (T.left : Scheme.{u})
        ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) t = d) :
    SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d := by
  letI : (x.twist L).IsFinitePresentation := x.twist_isFinitePresentation L hL
  letI : ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)).IsFinitePresentation :=
    isFinitePresentation_pushforward_twist_of_curve L hL x
  exact Modules.isLocallyFreeOfRank_of_finitePresentation_flat_pointRank
    ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L))
    (coherentSheafFlat_id_pushforward_twist_of_curve L hL x) hRank

/-! ## The affine curve rank producer -/

set_option maxHeartbeats 1000000 in
-- Normalizing the pullback/tensor pushforward carrier exceeds the default budget.
set_option backward.isDefEq.respectTransparency false in
/-- For a twisted divisor family on a smooth proper geometrically integral
curve, the point rank of the pushforward equals the degree of the divisor
fibre.  Finite schematic support gives pushforward base change, the affine
`ΓSpecIso` transport identifies its module fibre with `pointRank`, and the
finite-support twist calculation identifies fibre `H⁰` with `fiberDeg`.

This is the rank calculation used in Kleiman, *The Picard scheme*, Section 3,
`sb:Q` and `ex:DivC`; it has no rational-point hypothesis. -/
theorem pointRank_pushforward_twist_eq_fiberDeg_of_curve
    {R : CommRingCat.{u}} {S X : Scheme.{u}} {π : X ⟶ S}
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (f : Spec R ⟶ S) (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π (Over.mk f)) (t : PrimeSpectrum R) :
    Modules.pointRank (Spec R)
        ((Modules.pushforward (pullback.snd π f)).obj (x.twist L)) t =
      x.fiberDeg t := by
  let LT := (Modules.pullback (pullback.fst π (Over.mk f).hom)).obj L
  haveI : LT.IsFinitePresentation :=
    (hL.pullback (pullback.fst π (Over.mk f).hom)).isFinitePresentation
  haveI : LT.IsQuasicoherent := inferInstance
  haveI : x.F.IsFinitePresentation := x.isFinitePresentation
  haveI : x.F.IsQuasicoherent := inferInstance
  haveI : (x.twist L).IsQuasicoherent := by
    dsimp [DivFamily.twist]
    exact Modules.tensorObj_isQuasicoherent LT x.F
  let q := pullback.snd π (Over.mk f).hom
  haveI : QuasiCompact q := by
    dsimp [q]
    infer_instance
  haveI : QuasiSeparated q := by
    dsimp [q]
    infer_instance
  exact (Modules.pointRank_pushforward_eq_fiberH0_of_isFinite_schematicSupport
    q (x.twist L) (twist_isFiniteSupport_of_curve L hL x) t).trans
      (fiberH0_twist_eq_fiberDeg_of_curve L hL x t)

set_option maxHeartbeats 1000000 in
-- The locally-free target expands the same nested pullback/tensor carrier.
set_option backward.isDefEq.respectTransparency false in
/-- **Affine curve D2 rank producer.**  A constant-degree divisor family on a
smooth proper geometrically integral curve has a finite locally free twisted
pushforward of that degree over every noetherian affine test base.

This discharges the explicit point-rank premise of
`pushforward_twist_isLocallyFreeOfRank_of_pointRank`.  It is the finite locally
free module entering Kleiman's divisor-to-Grassmannian construction and does
not assume that the curve has a rational point. -/
theorem pushforward_twist_isLocallyFreeOfRank_of_curve
    {R : CommRingCat.{u}} {S X : Scheme.{u}} {π : X ⟶ S}
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (f : Spec R ⟶ S) [IsNoetherianRing R]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π (Over.mk f))
    {d : ℕ} (hx : x.HasFiberDeg d) :
    SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π f)).obj (x.twist L)) d := by
  letI : IsLocallyNoetherian (Over.mk f).left := by
    change IsLocallyNoetherian (Spec R)
    infer_instance
  apply pushforward_twist_isLocallyFreeOfRank_of_pointRank L hL x
  intro t
  exact (pointRank_pushforward_twist_eq_fiberDeg_of_curve f L hL x t).trans
    (hx t)

end DivFamily

end Scheme

end AlgebraicGeometry
