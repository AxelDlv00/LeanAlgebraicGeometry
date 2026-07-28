/-
Axiom probe for the fibrewise-large-twist vanishing layer landed by task `ajc-rr` (run 0074 r4):
`Ledger/FiberChart.lean`, `FiberDivisor.lean`, `FiberLattice.lean`, `QcohSections.lean`,
`AffineVanishingQcoh.lean`, `DivisorSheafQcoh.lean`, `FiberVanishing.lean`, `FiberBound.lean`.

Run with:
  lake env lean scripts/ajcrr-fibervanishing-axioms.lean

WHAT A CLEAN LINE HERE DOES AND DOES NOT MEAN.  Per `scripts/axiom-frontier.lean` §6e trap (d),
a theorem whose instance binders nothing can instantiate reports clean axioms and always will.
So the probe below is in three parts:

* §1 measures the DECLARATIONS as stated.  These lines are cheap and prove little on their own.
* §2 measures at a SYNTHESIS SITE: `probe_curve_*` elaborate consumers at an AJC curve bundle
  where the two `Module.Finite` binders and the `IsFinite`/`IsDominant` binders on `π` are
  actually discharged, not assumed.  These are the lines that matter.
* §3 is the CONTROL.  `AlgebraicGeometry.Scheme.fgaPicardRepresentability` must report `sorryAx`.
  If it ever comes back clean, the probe has lost its calibration (a stale olean, per I-0661) and
  §§1-2 mean nothing.

FOURTH CAVEAT, AND IT LIMITS EVERY LINE BELOW: all eight modules measured here are **outside the
root import cone**.  Measured 2026-07-29: `import AlgebraicJacobian` reaches 257 of 274 modules,
and these eight are among the 17 it does not (see `README.md` and inbox `I-0600`).  They are
committed to the ledger, so they are past the grace period — `lake build AlgebraicJacobian` does
not elaborate them, and no `#print axioms` line *through the root* can reach them.  The results
below are therefore **scratch-path**: real, kernel-checked, reproducible by running this file, but
not certified by the root build.  Rooting them is one import line in `AlgebraicJacobian.lean`,
which was outside task `ajc-rr`'s write scope.
-/
import AlgebraicJacobian.RiemannRoch.Ledger.FiberBound
import AlgebraicJacobian.RiemannRoch.Ledger.MapToP1
import AlgebraicJacobian.Picard.FGAPicRepresentability

open AlgebraicGeometry CategoryTheory

/-! ## §1 — the declarations as stated -/

#print axioms AlgebraicGeometry.fiberCoord
#print axioms AlgebraicGeometry.preimage_inf_eq_basicOpen_fiberCoord
#print axioms AlgebraicGeometry.isUnit_fiberCoord_res_inf
#print axioms AlgebraicGeometry.genericPoint_mem_preimage_inf
#print axioms AlgebraicGeometry.germ_fiberCoord_mem_nonZeroDivisors
#print axioms AlgebraicGeometry.Scheme.CurveDivisor.coeffAt_add
#print axioms AlgebraicGeometry.Scheme.CurveDivisor.coeffAt_divOf
#print axioms AlgebraicGeometry.fiberCoord_mul_fiberCoord₁_res
#print axioms AlgebraicGeometry.fiberCoordUnit
#print axioms AlgebraicGeometry.fiberCoordUnit_coeffAt_divOf_nonneg_of_mem_chart₀
#print axioms AlgebraicGeometry.fiberCoordUnit_coeffAt_divOf_nonpos_of_mem_chart₁
#print axioms AlgebraicGeometry.one_le_fiberCoordUnit_coeffAt_divOf_of_notMem_chart₁
#print axioms AlgebraicGeometry.fiberWeilDivisor
#print axioms AlgebraicGeometry.fiberWeilDivisor_nonneg
#print axioms AlgebraicGeometry.fiberWeilDivisor_deg_pos_of_notMem_chart₁
#print axioms AlgebraicGeometry.divisorSections_add_nsmul_fiberWeilDivisor_chart₁
#print axioms AlgebraicGeometry.divisorSections_add_nsmul_fiberWeilDivisor_overlap
#print axioms AlgebraicGeometry.divisorSections_add_nsmul_fiberWeilDivisor_chart₀
#print axioms AlgebraicGeometry.fiberLattice
#print axioms AlgebraicGeometry.fiberLattice_mono
#print axioms AlgebraicGeometry.iSup_fiberLattice
#print axioms AlgebraicGeometry.Scheme.QcohOn
#print axioms AlgebraicGeometry.IsAffineOpen.subsingleton_hModule'_one_of_qcoh
#print axioms AlgebraicGeometry.Scheme.divisorSheaf.instQcohOn
#print axioms AlgebraicGeometry.IsAffineOpen.subsingleton_hModule'_divisorSheaf_one
#print axioms Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top
#print axioms AlgebraicGeometry.fiberLatticeOverlap
#print axioms AlgebraicGeometry.iSup_fiberLatticeOverlap
#print axioms AlgebraicGeometry.fiberLatticeH1Equiv
#print axioms AlgebraicGeometry.subsingleton_hModule_divisorSheaf_one_of_isDominant_toP1
#print axioms AlgebraicGeometry.subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_base_subsingleton_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_bound_h0_eq_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_bound_section_drop_of_isFinite_toP1
#print axioms AlgebraicGeometry.exists_bound_generated_of_isFinite_toP1

/-! ## §2 — measured at a synthesis site

`exists_bound_subsingleton_hModule_one_curve` and `exists_bound_h0_eq_genus_curve` are the
CURVE-LEVEL forms: three curve binders (proper, smooth of relative dimension one, geometrically
irreducible) and nothing else.  Inside them the finite dominant `π` is CONSTRUCTED by
`exists_isFinite_isDominant_toP1`, and both `Module.Finite` cohomology binders are SYNTHESISED by
`ChiCurve`.  So these two lines are the measurement that matters: there is no instance binder left
for a caller to fail to instantiate, and no vanishing hypothesis.

`probe_curve_consumer` goes one step further and elaborates a CONSUMER at such a curve, so the
binders are discharged at a use site rather than merely present in a signature — the §6e trap-(d)
check. -/

section SynthesisSite

universe u

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
  [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]

/-- A consumer: exact Riemann-Roch fires at a curve with only the three curve binders. -/
theorem probe_curve_consumer :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    ∃ b : ℤ, ∀ D : C.left.CurveDivisor, b ≤ Scheme.CurveDivisor.deg k D →
      (Sheaf.h0 (C.left.divisorSheaf k D) : ℤ)
        = 1 - genus C + Scheme.CurveDivisor.deg k D :=
  exists_bound_h0_eq_genus_curve C

end SynthesisSite

#print axioms AlgebraicGeometry.exists_bound_subsingleton_hModule_one_curve
#print axioms AlgebraicGeometry.exists_bound_h0_eq_genus_curve
#print axioms AlgebraicGeometry.exists_isFinite_isDominant_toP1
#print axioms AlgebraicGeometry.chi_divisorSheaf_genus
#print axioms probe_curve_consumer
#print axioms AlgebraicGeometry.baseChange_binders_stable

/-! ## §3 — the control

`fgaPicardRepresentability` is the standing open FGA obligation.  It MUST report `sorryAx`; a
clean line here means the probe is reading stale oleans and §§1-2 are uncalibrated. -/

#print axioms AlgebraicGeometry.Scheme.fgaPicardRepresentability
