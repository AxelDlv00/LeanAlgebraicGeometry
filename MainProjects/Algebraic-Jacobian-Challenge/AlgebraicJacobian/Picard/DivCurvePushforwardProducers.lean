/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivPushforwardFlat
import AlgebraicJacobian.Picard.DivTwistRank
import AlgebraicJacobian.Projective.EffectiveCartierSupport

/-!
# Curve-specific finite pushforward producers

The divisor-to-Grassmannian route spends finiteness of the effective divisor over
the test base before it can form finite pushforward sections.  For a smooth
proper geometrically integral relative curve this finiteness is a theorem, not a
caller-supplied `LocallyQuasiFinite` instance.  The declarations here expose
that curve specialization for arbitrary test objects and for the locally
trivial twist used by D2'.

These are substrate producers only: they do not assert evaluation surjectivity,
construct a Grassmannian point, or discharge Picard representability.
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

/-- The schematic support of a relative effective Cartier divisor on a smooth
proper geometrically integral curve is finite over every test base.  Properness
is the `DivFamily` support field, while quasi-finiteness is supplied by the
curve-fibre theorem. -/
theorem isFinite_support_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) :
    IsFinite (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) := by
  letI : IsProper (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    x.properSupport
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  exact IsFinite.of_isProper_of_locallyQuasiFinite _

/-! The curve support producer also discharges the quasi-finiteness input of
`coherentSheafFlat_id_pushforward`.  Keeping this bridge here exposes the
identity-flatness input used when specializing flattening-stratification
arguments, without repeating the geometric instance argument at each call
site. -/

/-- The pushforward of the structure sheaf of a curve divisor is flat over an
arbitrary test object once the curve hypotheses supply finite fibres. -/
theorem coherentSheafFlat_id_pushforward_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) :
    CoherentSheafFlat (𝟙 (T.left : Scheme.{u}))
      ((Modules.pushforward (pullback.snd π T.hom)).obj x.F) := by
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  intro U hU V hV e
  exact (Scheme.DivFamily.coherentSheafFlat_id_pushforward (T := T) x) hU hV e

/-! The curve-specialized form of the identity-pullback flatness input used by
`flatLocusStratification_universal`.  The universal flattening statement keeps
the identity pullback in its module carrier, so exposing this exact shape lets
the D3' producer consume the curve's finite-fibre theorem without asking each
caller to rebuild the `pullbackId` transport.
-/
theorem coherentSheafFlat_id_pullbackId_pushforward_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) :
    CoherentSheafFlat (𝟙 (T.left : Scheme.{u}))
      ((Modules.pullback (𝟙 (T.left : Scheme.{u}))).obj
        ((Modules.pushforward (pullback.snd π T.hom)).obj x.F)) := by
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  intro U hU V hV e
  exact (Scheme.DivFamily.coherentSheafFlat_id_pullbackId_pushforward (T := T) x) hU hV e

/-- The finite-presentation input for the pushforward tower on a locally
noetherian test base, with the support finiteness supplied by curve geometry. -/
theorem isFinitePresentation_pushforward_of_curve
    [IsProper π] [SmoothOfRelativeDimension 1 π]
    [GeometricallyIntegral π]
    [IsLocallyNoetherian (T.left : Scheme.{u})]
    (x : DivFamily π T) :
    ((Modules.pushforward (pullback.snd π T.hom)).obj x.F).IsFinitePresentation := by
  letI : LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) :=
    locallyQuasiFinite_support_of_curve T π x
  exact isFinitePresentation_pushforward x

/-- A locally trivial line-bundle twist has finite support over every test base.
The support equality is the tensor-inverse argument, and the remaining finite
map is the curve producer above. -/
theorem twist_isFiniteSupport_of_curve
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T) :
    IsFinite (Modules.schematicSupportι (x.twist L) ≫ pullback.snd π T.hom) := by
  dsimp [twist]
  rw [Modules.isFinite_tensorObj_left_iff_support
    (pullback.snd π T.hom)
    ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F
    (hL.pullback (pullback.fst π T.hom))]
  exact isFinite_support_of_curve x

end DivFamily

namespace Modules

/-! ## Finite sections over arbitrary affine opens -/

/-- A module with finite schematic support has finitely generated pushforward
sections over every affine open of the base.

The support descent presentation factors these sections through the finite map
`schematicSupportι F ≫ f`: its sections are finite over the base, while the
restriction to the support is finite by affine finite-presentation descent.
This is the arbitrary-test-base section producer needed before the
finite-flat-to-locally-free assembly; it does not assume a noetherian base. -/
theorem module_finite_sections_pushforward_of_isFinite_schematicSupport
    {S X : Scheme.{u}} (f : X ⟶ S) (F : X.Modules)
    [F.IsFinitePresentation]
    (hfin : IsFinite (schematicSupportι F ≫ f))
    {V : S.Opens} (hV : IsAffineOpen V) :
    Module.Finite Γ(S, V) Γ((pushforward f).obj F, V) := by
  let i := schematicSupportι F
  let D := schematicSupport F
  let W : D.Opens := (i ≫ f) ⁻¹ᵁ V
  let N : D.Modules := (pullback i).obj F
  letI : IsFinite (i ≫ f) := hfin
  haveI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom (annihilator F).subschemeι)
  haveI : IsAffineHom (i ≫ f) := inferInstance
  haveI : N.IsFinitePresentation :=
    isFinitePresentation_pullback_schematicSupportι F inferInstance
  letI : Algebra Γ(S, V) Γ(D, W) := (Scheme.Hom.app (i ≫ f) V).hom.toAlgebra
  letI : Module Γ(S, V) Γ(N, W) :=
    Module.compHom _ (Scheme.Hom.app (i ≫ f) V).hom
  haveI : Module.Finite Γ(S, V) Γ(D, W) :=
    IsFinite.finite_app (i ≫ f) V hV
  haveI : Module.Finite Γ(D, W) Γ(N, W) :=
    finite_sections_preimage_of_isAffineHom (i ≫ f) N hV
  haveI : IsScalarTower Γ(S, V) Γ(D, W) Γ(N, W) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  haveI : Module.Finite Γ(S, V) Γ(N, W) :=
    Module.Finite.trans Γ(D, W) _
  have hdesc : F ≅ (pushforward i).obj N :=
    schematicSupportDescentIso F
  have hcomp : (((pushforward f).map hdesc.hom).app V ≫
      ((pushforward f).map hdesc.inv).app V) =
      𝟙 Γ((pushforward f).obj F, V) := by
    rw [← Hom.comp_app, ← Functor.map_comp, hdesc.hom_inv_id]
    simp
  refine Module.Finite.of_surjective
    ({ toFun := fun n => ((pushforward f).map hdesc.inv).app V n
       map_add' := fun a b => map_add _ a b
       map_smul' := fun r n => Hom.app_smul ((pushforward f).map hdesc.inv) r n } :
      Γ(N, W) →ₗ[Γ(S, V)] Γ((pushforward f).obj F, V)) (fun z => ?_)
  exact ⟨((pushforward f).map hdesc.hom).app V z,
    congrArg (fun g => g z) hcomp⟩

/-- Curve specialization of
`module_finite_sections_pushforward_of_isFinite_schematicSupport`: the
structure sheaf of a relative effective Cartier divisor has finite pushforward
sections over every affine open of every test object. -/
theorem DivFamily.module_finite_sections_pushforward_of_curve
    {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) {V : T.left.Opens} (hV : IsAffineOpen V) :
    Module.Finite Γ(T.left, V)
      Γ((pushforward (pullback.snd π T.hom)).obj x.F, V) := by
  letI : x.F.IsFinitePresentation := x.isFinitePresentation
  exact module_finite_sections_pushforward_of_isFinite_schematicSupport
    (pullback.snd π T.hom) x.F (Scheme.DivFamily.isFinite_support_of_curve x) hV

end Modules

end Scheme

end AlgebraicGeometry
