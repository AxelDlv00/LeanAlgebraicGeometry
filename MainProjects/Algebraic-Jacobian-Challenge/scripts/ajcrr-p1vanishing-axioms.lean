/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.P1Vanishing

/-!
# Axiom probe for `Ledger/P1Vanishing.lean`

`#print axioms` for **every declaration this module's docstrings cite**, measured at
**synthesis sites**: each headline is re-elaborated at the concrete curve `Adelic.p1Over k` with
`k := ULift ℚ`, so the gate instances and the `Module.Finite` binders are actually synthesised
rather than quantified over.  A theorem quantifying over an instance reports clean axioms as
stated and only picks up `sorryAx` when the instance is supplied — that is the whole reason for
the `synth_*` block below.

Printing every *cited* name (not just the interesting ones) is deliberate: this lane has shipped
phantom declaration names in its own docstring summary lists four times, and a name that does not
exist makes this file fail to elaborate rather than pass silently.

The two `control_*` declarations at the end MUST report `sorryAx`.  If they ever come back clean
the probe has stopped measuring anything.

Run: `lake env lean scripts/ajcrr-p1vanishing-axioms.lean` — exit 0 with the axiom lines on
stdout.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry AlgebraicGeometry.Adelic

/-! ## §1. As stated (abstract binders) -/

-- §1 abstract core
#print axioms AlgebraicGeometry.Adelic.sup_eq_top_of_laurent_pair_span_one
#print axioms AlgebraicGeometry.Adelic.mem_span_pow_map_of_span_pow

-- §2 overlap span
#print axioms AlgebraicGeometry.Adelic.LaurentChartData.span_ladder_overlap

-- §3 the chart square and the vanishing
#print axioms AlgebraicGeometry.Adelic.LaurentChartData.chartSquare
#print axioms AlgebraicGeometry.Adelic.LaurentChartData.subsingleton_h1Cok

-- §4 at ℙ¹
#print axioms AlgebraicGeometry.Adelic.subsingleton_hModule_one_p1Over
#print axioms AlgebraicGeometry.Adelic.genus_p1Over_eq_zero
#print axioms AlgebraicGeometry.Adelic.uniformBaseDivisor_p1Over
#print axioms AlgebraicGeometry.Adelic.uniformVanishing_p1Over

/-! ## §2. Every other declaration cited in this module's docstrings

If any of these names is wrong the file fails to elaborate. -/

#print axioms AlgebraicGeometry.Adelic.exists_pow_mul_eq_res
#print axioms AlgebraicGeometry.Adelic.span_ladder_of_pow_mul_mem_span
#print axioms AlgebraicGeometry.Adelic.pow_mul_mem
#print axioms AlgebraicGeometry.Adelic.exists_finset_forall_mem_span_pow_mul
#print axioms AlgebraicGeometry.Adelic.module_finite_quotient_of_laurent_pair
#print axioms AlgebraicGeometry.Adelic.LaurentChartData.pullbackSquare
#print axioms AlgebraicGeometry.Adelic.LaurentChartData.module_finite_H1Cok
#print axioms AlgebraicGeometry.Adelic.p1LaurentChartData
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.hModuleOneEquivH1Cok_curve
#print axioms AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality
#print axioms AlgebraicGeometry.uniformBaseDivisor_zero_of_genus_eq_zero
#print axioms AlgebraicGeometry.uniformVanishing_of_genus_eq_zero
#print axioms AlgebraicGeometry.uniformVanishing_of_subsingleton_h1
#print axioms AlgebraicGeometry.subsingleton_hModule_one_iff_genus_eq_zero
#print axioms AlgebraicGeometry.Scheme.subsingleton_h1Cokₗ_unit_baseChangeField_iff
#print axioms AlgebraicGeometry.UniformVanishing
#print axioms AlgebraicGeometry.UniformBaseDivisor
#print axioms AlgebraicGeometry.chi_divisorSheaf_p1Over
#print axioms AlgebraicGeometry.moduleFinite_genus_carrier_p1Over

/-! ## §3. THE SYNTHESIS SITES — the measurement that actually counts

Each headline re-elaborated at a concrete field and the concrete curve, so every instance
(the ℙ¹ chart gate, the three curve binders, the `Module.Finite` cohomology instances) is
found by synthesis here rather than assumed by the caller. -/

section Synthesis

/-- The vanishing at a concrete field: `k := ULift.{u} ℚ`. -/
theorem synth_subsingleton_h1_p1 :
    Subsingleton (Scheme.HModule (ULift.{u} ℚ)
      (Scheme.toModuleKSheaf (p1Over (ULift.{u} ℚ))) 1) :=
  subsingleton_hModule_one_p1Over (ULift.{u} ℚ)

/-- The genus at a concrete field. -/
theorem synth_genus_p1 : genus (p1Over (ULift.{u} ℚ)) = 0 :=
  genus_p1Over_eq_zero (ULift.{u} ℚ)

/-- `UniformBaseDivisor` at a concrete field. -/
theorem synth_uniformBaseDivisor_p1 : UniformBaseDivisor (p1Over (ULift.{u} ℚ)) 0 :=
  uniformBaseDivisor_p1Over (ULift.{u} ℚ)

/-- **The headline at a synthesis site**: extension-uniform bounded vanishing at a concrete
curve over a concrete field, every instance found here. -/
theorem synth_uniformVanishing_p1 : UniformVanishing (p1Over (ULift.{u} ℚ)) :=
  uniformVanishing_p1Over (ULift.{u} ℚ)

/-- The datum-level vanishing at the concrete ℙ¹ datum. -/
theorem synth_subsingleton_h1Cok_p1 :
    Subsingleton ((p1LaurentChartData (ULift.{u} ℚ)).chartSquare.H1Cok
      (Scheme.toModuleKSheaf (p1Over (ULift.{u} ℚ)))) :=
  (p1LaurentChartData (ULift.{u} ℚ)).subsingleton_h1Cok

/-- The overlap span at the concrete datum. -/
theorem synth_span_ladder_overlap_p1 :
    ⊤ ≤ Submodule.span (ULift.{u} ℚ)
      ((⋃ j : ℕ, (fun z => ((p1Over (ULift.{u} ℚ)).left.presheaf.map (homOfLE
            (inf_le_left : (p1LaurentChartData (ULift.{u} ℚ)).V₀ ⊓
              (p1LaurentChartData (ULift.{u} ℚ)).V₁ ≤
                (p1LaurentChartData (ULift.{u} ℚ)).V₀)).op).hom
          (p1LaurentChartData (ULift.{u} ℚ)).x ^ j * z) ''
              ({1} : Set Γ((p1Over (ULift.{u} ℚ)).left,
                (p1LaurentChartData (ULift.{u} ℚ)).V₀ ⊓
                  (p1LaurentChartData (ULift.{u} ℚ)).V₁)))
        ∪ (⋃ j : ℕ, (fun z => ((p1Over (ULift.{u} ℚ)).left.presheaf.map (homOfLE
            (inf_le_right : (p1LaurentChartData (ULift.{u} ℚ)).V₀ ⊓
              (p1LaurentChartData (ULift.{u} ℚ)).V₁ ≤
                (p1LaurentChartData (ULift.{u} ℚ)).V₁)).op).hom
          (p1LaurentChartData (ULift.{u} ℚ)).y ^ j * z) ''
              ({1} : Set Γ((p1Over (ULift.{u} ℚ)).left,
                (p1LaurentChartData (ULift.{u} ℚ)).V₀ ⊓
                  (p1LaurentChartData (ULift.{u} ℚ)).V₁)))) :=
  (p1LaurentChartData (ULift.{u} ℚ)).span_ladder_overlap

#print axioms synth_subsingleton_h1_p1
#print axioms synth_genus_p1
#print axioms synth_uniformBaseDivisor_p1
#print axioms synth_uniformVanishing_p1
#print axioms synth_subsingleton_h1Cok_p1
#print axioms synth_span_ladder_overlap_p1

end Synthesis

/-! ## §4. Controls — these MUST fire `sorryAx`

Two declarations of the neighbouring Picard lane, known to be sorried at HEAD.  If either comes
back clean, this probe has stopped discriminating and its clean lines above mean nothing. -/

section Controls

#print axioms AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_isIso
#print axioms AlgebraicGeometry.Scheme.gammaFiber_finrank_baseChange_field

end Controls
