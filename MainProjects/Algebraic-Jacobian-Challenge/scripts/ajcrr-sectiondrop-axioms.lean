/-
Scratch axiom probe for `RiemannRoch/Ledger/SectionDrop.lean` (task ajc-rr).

Measured at a SYNTHESIS SITE, not at the declaration: a theorem quantifying over the two
`Module.Finite` cohomology binders reports clean axioms as *stated* and would only pick up
`sorryAx` when those instances are synthesised.  The curve section below therefore
instantiates the whole drop layer at the challenge curve `C`, where `ChiCurve` discharges
both binders by synthesis, and prints axioms of the *instantiated* statements.

NOTE ON WHAT A CLEAN LINE HERE DOES AND DOES NOT SAY (axiom-frontier §6b's trap (b)):
`subsingleton_hModule_one_of_le` takes a vanishing `Subsingleton (H¹ 𝒪(D₀))` as an explicit
hypothesis.  A clean axiom line says nothing about that hypothesis being *available* — it is
the open base datum.  The clean line certifies the peel implication, not any vanishing.
-/
import AlgebraicJacobian.RiemannRoch.Ledger.SectionDrop
import AlgebraicJacobian.RiemannRoch.Ledger.ChiCurve

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Scheme

/-! ## §1 Axioms as stated (binders open) -/

#print axioms AlgebraicGeometry.h0_sub_point_le
#print axioms AlgebraicGeometry.h1_le_h1_sub_point
#print axioms AlgebraicGeometry.h0_le_h0_sub_point_add_residueDeg
#print axioms AlgebraicGeometry.h0_sub_h0_sub_point_add_h1_sub_h1_sub_point
#print axioms AlgebraicGeometry.surjective_hModule_one_divisorSheafLE
#print axioms AlgebraicGeometry.injective_hModule_zero_divisorSheafLE
#print axioms AlgebraicGeometry.subsingleton_hModule_one_of_subsingleton_sub_point
#print axioms AlgebraicGeometry.subsingleton_hModule_one_add_effective
#print axioms AlgebraicGeometry.subsingleton_hModule_one_of_le
#print axioms AlgebraicGeometry.h0_divisorSheaf_of_subsingleton_of_le
#print axioms AlgebraicGeometry.h1_divisorSheaf_eq_zero_of_le
#print axioms AlgebraicGeometry.h0_eq_h0_sub_point_add_residueDeg_of_subsingleton

/-! ## §2 The synthesis site: instantiate at the challenge curve

Both `Module.Finite` binders are *synthesised* here from `ChiCurve`'s instances, so these
are the lines that would expose a `sorryAx` hiding in the finiteness discharge. -/

section SynthesisSite

variable {k : Type u} [Field k]

/-- The peel, at the challenge curve, with both finiteness instances synthesised. -/
theorem probe_peel_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {D₀ D : C.left.CurveDivisor} (hle : D₀ ≤ D) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) →
      Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  exact fun h => subsingleton_hModule_one_of_le k hle h

/-- Exact Riemann–Roch above `D₀`, at the challenge curve, in the `1 - genus + deg` form:
both finiteness binders synthesised, `χ(𝒪_C)` replaced by `1 - ledgerGenus C`. -/
theorem probe_exactRR_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {D₀ D : C.left.CurveDivisor} (hle : D₀ ≤ D) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) →
      (Sheaf.h0 (C.left.divisorSheaf k D) : ℤ)
        = 1 - ledgerGenus C + CurveDivisor.deg k D := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  intro h
  have hrr := h0_divisorSheaf_of_subsingleton_of_le k hle h
  have hO : Sheaf.chi (C.left.moduleKSheaf k) = 1 - ledgerGenus C := chi_moduleKSheaf C
  omega

/-- The exact section drop, at the challenge curve, both binders synthesised. -/
theorem probe_exact_drop_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {x : C.left} (hx : x ≠ genericPoint C.left) (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton
        (Sheaf.HModule (C.left.divisorSheaf k (D - CurveDivisor.single hx 1)) 1) →
      (Sheaf.h0 (C.left.divisorSheaf k D) : ℤ) =
        Sheaf.h0 (C.left.divisorSheaf k (D - CurveDivisor.single hx 1))
          + C.left.residueDeg k x := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact fun h => h0_eq_h0_sub_point_add_residueDeg_of_subsingleton k hx D h

end SynthesisSite

#print axioms probe_peel_curve
#print axioms probe_exactRR_curve
#print axioms probe_exact_drop_curve
