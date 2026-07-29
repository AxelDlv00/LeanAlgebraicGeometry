/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.UniformRiemannRoch

/-!
# Axiom probe for `Ledger/UniformRiemannRoch.lean`

`#print axioms` for **every declaration this module's docstrings cite**, measured at
**synthesis sites** wherever a synthesis site exists: each headline is re-elaborated at the
concrete curve `Adelic.p1Over k` with `k := ULift ℚ`, so the three curve binders, the two
`Module.Finite` cohomology instances and the ℙ¹ chart gate are actually found here rather than
quantified over.  A theorem quantifying over an instance reports clean axioms as stated and picks
up `sorryAx` only when the instance is supplied — which is the whole point of §3.

Printing every *cited* name is deliberate: this lane has shipped phantom declaration names in its
own docstring summary lists four times, and a name that does not exist makes this file fail to
elaborate rather than pass silently.

The two `control_*` lines at the end MUST report `sorryAx`.  If they come back clean the probe has
stopped discriminating and every clean line above it means nothing.

Run: `lake env lean scripts/ajcrr-uniformriemannroch-axioms.lean` — exit 0 with the axiom lines
on stdout.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry AlgebraicGeometry.Adelic

/-! ## §1. As stated (abstract binders)

The single-field curve forms and the three uniform statements/reductions. -/

-- §1 of the module: the two single-field curve forms
#print axioms AlgebraicGeometry.exists_bound_section_drop_curve
#print axioms AlgebraicGeometry.exists_bound_generated_curve

-- §2: the three uniform statements (definitions)
#print axioms AlgebraicGeometry.UniformRiemannRoch
#print axioms AlgebraicGeometry.UniformSectionDrop
#print axioms AlgebraicGeometry.UniformGeneration

-- §3: the shared χ entry and the three reductions
#print axioms AlgebraicGeometry.chi_baseChangeField_eq_curve
#print axioms AlgebraicGeometry.uniformRiemannRoch_of_uniformBaseDivisor
#print axioms AlgebraicGeometry.uniformSectionDrop_of_uniformBaseDivisor
#print axioms AlgebraicGeometry.uniformGeneration_of_uniformBaseDivisor

-- §4: the ℙ¹ witnesses
#print axioms AlgebraicGeometry.uniformRiemannRoch_p1Over
#print axioms AlgebraicGeometry.uniformSectionDrop_p1Over
#print axioms AlgebraicGeometry.uniformGeneration_p1Over

/-! ## §2. Every other declaration cited in this module's docstrings

If any of these names is wrong the file fails to elaborate. -/

#print axioms AlgebraicGeometry.exists_bound_section_drop_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_bound_generated_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_bound_subsingleton_hModule_one_curve
#print axioms AlgebraicGeometry.exists_bound_h0_eq_genus_curve
#print axioms AlgebraicGeometry.exists_isFinite_isDominant_toP1
#print axioms AlgebraicGeometry.UniformVanishing
#print axioms AlgebraicGeometry.UniformBaseDivisor
#print axioms AlgebraicGeometry.riemannRoch_baseChangeField
#print axioms AlgebraicGeometry.chi_moduleKSheaf_baseChangeField
#print axioms AlgebraicGeometry.genus_baseChangeField_curve
#print axioms AlgebraicGeometry.nonempty_affineCoverMVSquare_of_curve
#print axioms AlgebraicGeometry.uniformVanishing_of_uniformBaseDivisor_curve
#print axioms AlgebraicGeometry.uniformVanishing_of_uniform_base_of_genus_invariant
#print axioms AlgebraicGeometry.h0_eq_of_deg_ge
#print axioms AlgebraicGeometry.h0_eq_h0_sub_point_add_residueDeg_of_deg_ge
#print axioms AlgebraicGeometry.surjective_eval_of_deg_ge
#print axioms AlgebraicGeometry.generated_of_deg_ge
#print axioms AlgebraicGeometry.Adelic.uniformBaseDivisor_p1Over
#print axioms AlgebraicGeometry.Adelic.uniformVanishing_p1Over
#print axioms AlgebraicGeometry.Adelic.genus_p1Over_eq_zero
#print axioms AlgebraicGeometry.moduleFinite_hModule_zero
#print axioms AlgebraicGeometry.devissageSES

/-! ## §3. THE SYNTHESIS SITES — the measurement that actually counts

Each headline re-elaborated at the concrete curve `Adelic.p1Over (ULift ℚ)`, so every instance is
found by synthesis here rather than assumed by the caller.  The three §3 reductions are also
instantiated *through* the ℙ¹ base-divisor witness, which is the only place in this file where a
`UniformBaseDivisor` hypothesis is actually discharged rather than quantified over. -/

section Synthesis

/-- The single-field section drop, every instance synthesised at ℙ¹. -/
theorem synth_section_drop_p1 :
    letI : (p1Over (ULift.{u} ℚ)).left.Over (Spec (CommRingCat.of (ULift.{u} ℚ))) :=
      .ofHom (p1Over (ULift.{u} ℚ)).hom
    haveI : SmoothOfRelativeDimension 1
        ((p1Over (ULift.{u} ℚ)).left ↘ Spec (CommRingCat.of (ULift.{u} ℚ))) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (p1Over (ULift.{u} ℚ)).hom)
    ∃ b : ℤ, ∀ {x : (p1Over (ULift.{u} ℚ)).left}
      (hx : x ≠ genericPoint (p1Over (ULift.{u} ℚ)).left)
      (D : (p1Over (ULift.{u} ℚ)).left.CurveDivisor),
      b ≤ Scheme.CurveDivisor.deg (ULift.{u} ℚ) (D - Scheme.CurveDivisor.single hx 1) →
      (Sheaf.h0 ((p1Over (ULift.{u} ℚ)).left.divisorSheaf (ULift.{u} ℚ) D) : ℤ) =
        Sheaf.h0 ((p1Over (ULift.{u} ℚ)).left.divisorSheaf (ULift.{u} ℚ)
            (D - Scheme.CurveDivisor.single hx 1))
          + (p1Over (ULift.{u} ℚ)).left.residueDeg (ULift.{u} ℚ) x :=
  exists_bound_section_drop_curve (p1Over (ULift.{u} ℚ))

/-- The single-field generation form, every instance synthesised at ℙ¹. -/
theorem synth_generated_p1 :
    letI : (p1Over (ULift.{u} ℚ)).left.Over (Spec (CommRingCat.of (ULift.{u} ℚ))) :=
      .ofHom (p1Over (ULift.{u} ℚ)).hom
    haveI : SmoothOfRelativeDimension 1
        ((p1Over (ULift.{u} ℚ)).left ↘ Spec (CommRingCat.of (ULift.{u} ℚ))) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (p1Over (ULift.{u} ℚ)).hom)
    ∃ b : ℤ, ∀ {x : (p1Over (ULift.{u} ℚ)).left}
      (hx : x ≠ genericPoint (p1Over (ULift.{u} ℚ)).left)
      (D : (p1Over (ULift.{u} ℚ)).left.CurveDivisor),
      b ≤ Scheme.CurveDivisor.deg (ULift.{u} ℚ) (D - Scheme.CurveDivisor.single hx 1) →
      Function.Surjective (Sheaf.HModule.map (devissageSES (ULift.{u} ℚ) hx D).g 0) :=
  exists_bound_generated_curve (p1Over (ULift.{u} ℚ))

/-- **The headline at a synthesis site**: extension-uniform global generation at a concrete curve
over a concrete field, every instance found here and the base-divisor hypothesis *discharged*. -/
theorem synth_uniformGeneration_p1 : UniformGeneration (p1Over (ULift.{u} ℚ)) :=
  uniformGeneration_p1Over (ULift.{u} ℚ)

/-- Extension-uniform Riemann–Roch at a synthesis site. -/
theorem synth_uniformRiemannRoch_p1 : UniformRiemannRoch (p1Over (ULift.{u} ℚ)) :=
  uniformRiemannRoch_p1Over (ULift.{u} ℚ)

/-- Extension-uniform section drop at a synthesis site. -/
theorem synth_uniformSectionDrop_p1 : UniformSectionDrop (p1Over (ULift.{u} ℚ)) :=
  uniformSectionDrop_p1Over (ULift.{u} ℚ)

/-- The χ entry at a synthesis site, at a concrete extension `ℚ → ℚ`. -/
theorem synth_chi_baseChangeField_p1 :
    letI : (Scheme.baseChangeField (p1Over (ULift.{u} ℚ)) (ULift.{u} ℚ)).left.Over
        (Spec (CommRingCat.of (ULift.{u} ℚ))) :=
      .ofHom (Scheme.baseChangeField (p1Over (ULift.{u} ℚ)) (ULift.{u} ℚ)).hom
    Sheaf.chi ((Scheme.baseChangeField (p1Over (ULift.{u} ℚ)) (ULift.{u} ℚ)).left.moduleKSheaf
        (ULift.{u} ℚ)) = 1 - (genus (p1Over (ULift.{u} ℚ)) : ℤ) :=
  chi_baseChangeField_eq_curve (p1Over (ULift.{u} ℚ)) (ULift.{u} ℚ)

#print axioms synth_section_drop_p1
#print axioms synth_generated_p1
#print axioms synth_uniformGeneration_p1
#print axioms synth_uniformRiemannRoch_p1
#print axioms synth_uniformSectionDrop_p1
#print axioms synth_chi_baseChangeField_p1

end Synthesis

/-! ## §4. Controls — these MUST fire `sorryAx`

Two declarations of the neighbouring Picard lane, known to be sorried at HEAD.  If either comes
back clean, this probe has stopped discriminating. -/

section Controls

#print axioms AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_isIso
#print axioms AlgebraicGeometry.Scheme.gammaFiber_finrank_baseChange_field

end Controls
