/-
Scratch axiom probe for `RiemannRoch/Ledger/DegreeVanishing.lean` (task ajc-rr).

Measured at a SYNTHESIS SITE, not at the declaration.  Every headline of
`DegreeVanishing.lean` quantifies over the two `Module.Finite` cohomology binders, so a
`#print axioms` on the declaration reports clean axioms *as stated* and would only pick up
`sorryAx` when those instances are actually constructed.  §2 below therefore instantiates the
whole degree-threshold layer at the challenge curve `C`, where `ChiCurve` discharges both
binders by synthesis, and prints axioms of the *instantiated* statements.  Those are the lines
that count.

WHAT A CLEAN LINE HERE DOES AND DOES NOT SAY.  `subsingleton_hModule_one_of_deg_ge` takes a
base vanishing `Subsingleton (H¹ 𝒪(D₀))` as an explicit hypothesis.  A clean axiom line
certifies the *implication* — that from one vanishing, the whole degree half-space vanishes —
and says nothing about that hypothesis being available at a general curve.  It is available
at genus zero (`probe_deg_ge_of_zero_curve`, whose hypothesis is `H¹(𝒪_C) = 0`) and is
otherwise the one residual port named in the module docstring.  Do not read a clean line as
unconditional bounded vanishing; that is exactly trap (b) of axiom-frontier §6b.

SCRATCH PATH, NOT THE ROOT TARGET.  `Ledger/DegreeVanishing.lean` imports
`Ledger/SectionDrop.lean`, which is not in the root cone (measured from the root *file*
`AlgebraicJacobian.lean`: `ChiLedger`/`ChiCurve`/`ChiSlice` are IN, `SectionDrop` is OUT).  The
incremental cone of this file over the rooted part is therefore two files, itself and
`SectionDrop`; the roll-up import is outside this lane's write scope (tracked at I-0600).
Until then the standing root probe does not see any of this — the cone-relativity of a
*positive* availability claim, per I-0622.
-/
import AlgebraicJacobian.RiemannRoch.Ledger.DegreeVanishing
import AlgebraicJacobian.RiemannRoch.Ledger.ChiCurve

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Scheme

/-! ## §1 Axioms as stated (binders open) -/

#print axioms AlgebraicGeometry.exists_unit_nonneg_of_h0_pos
#print axioms AlgebraicGeometry.subsingleton_hModule_one_sub_divOf
#print axioms AlgebraicGeometry.exists_le_subsingleton_of_deg_ge
#print axioms AlgebraicGeometry.subsingleton_hModule_one_of_deg_ge
#print axioms AlgebraicGeometry.h1_eq_zero_of_deg_ge
#print axioms AlgebraicGeometry.exists_bound_subsingleton_hModule_one
#print axioms AlgebraicGeometry.h0_eq_of_deg_ge
#print axioms AlgebraicGeometry.exists_bound_h0_eq
#print axioms AlgebraicGeometry.h0_eq_h0_sub_point_add_residueDeg_of_deg_ge
#print axioms AlgebraicGeometry.subsingleton_of_deg_ge_of_zero
#print axioms AlgebraicGeometry.subsingleton_of_deg_ge_of_moduleKSheaf
#print axioms AlgebraicGeometry.deg_lt_of_not_subsingleton
#print axioms AlgebraicGeometry.subsingleton_of_h1_eq_zero
#print axioms AlgebraicGeometry.subsingleton_hModule_one_of_deg_ge_of_h1_eq_zero
#print axioms AlgebraicGeometry.surjective_hModule_zero_devissageπ
#print axioms AlgebraicGeometry.surjective_eval_of_deg_ge
#print axioms AlgebraicGeometry.generated_of_deg_ge

/-! ## §2 The synthesis site: instantiate at the challenge curve

Both `Module.Finite` binders are *synthesised* here from `ChiCurve`'s instances, so these are
the lines that would expose a `sorryAx` hiding in the finiteness discharge. -/

section SynthesisSite

variable {k : Type u} [Field k]

/-- **Single-field bounded vanishing at the challenge curve**, both finiteness instances
synthesised.  This is the cluster-P item-1 headline measured where it is actually used. -/
theorem probe_bounded_vanishing_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {D₀ : C.left.CurveDivisor} (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) →
      CurveDivisor.deg k D₀ + 1 - Sheaf.chi (C.left.moduleKSheaf k)
          ≤ CurveDivisor.deg k D →
        Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact fun h hD => subsingleton_hModule_one_of_deg_ge k h D hD

/-- **Exact Riemann–Roch above a degree bound at the challenge curve**, in the
`1 - genus + deg` spelling: both binders synthesised, `χ(𝒪_C)` replaced by `1 - ledgerGenus C`.
Note the hypothesis is on `deg D`, not on `D₀ ≤ D` — that is the whole point of the file. -/
theorem probe_rr_deg_ge_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {D₀ : C.left.CurveDivisor} (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) →
      CurveDivisor.deg k D₀ + ledgerGenus C ≤ CurveDivisor.deg k D →
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
  intro h hD
  have hO : Sheaf.chi (C.left.moduleKSheaf k) = 1 - ledgerGenus C := chi_moduleKSheaf C
  -- the curve-form bound `deg D₀ + genus ≤ deg D` is the ledger bound `+ 1 - χ`
  have hrr := h0_eq_of_deg_ge k h D (by omega)
  omega

/-- **The genus-zero specialisation at the challenge curve**: given `H¹(𝒪_C) = 0`, bounded
vanishing holds with `D₀ = 0`, i.e. for every `D` of degree `≥ genus C`.  This is the one
member of the family whose base hypothesis is *not* an open port — it is the honest
unconditional case, and it is the shape a genus-zero consumer uses. -/
theorem probe_deg_ge_of_zero_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.moduleKSheaf k) 1) →
      ledgerGenus C ≤ CurveDivisor.deg k D →
        Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  intro h hD
  have hO : Sheaf.chi (C.left.moduleKSheaf k) = 1 - ledgerGenus C := chi_moduleKSheaf C
  exact subsingleton_of_deg_ge_of_moduleKSheaf k h D (by omega)

/-- **The cofinality theorem at the challenge curve**: the statement `SectionDrop` took as a
hypothesis, now instantiated with both binders synthesised. -/
theorem probe_cofinality_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {D₀ : C.left.CurveDivisor} (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) →
      CurveDivisor.deg k D₀ + 1 - Sheaf.chi (C.left.moduleKSheaf k)
          ≤ CurveDivisor.deg k D →
        ∃ D₁ : C.left.CurveDivisor, D₁ ≤ D ∧
          Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₁) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact fun h hD => exists_le_subsingleton_of_deg_ge k h D hD

/-- **Global generation at the challenge curve**, both finiteness instances synthesised: past
the bound, evaluation `H⁰(𝒪(D)) → H⁰(sky_x J)` is surjective at every closed point.  Cluster-P
item 3 measured where it is used.  Note the vanishing input is at `D − x`, which is why the
degree hypothesis is stated there. -/
theorem probe_generation_curve (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    {D₀ : C.left.CurveDivisor} (D : C.left.CurveDivisor) :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) →
      ∀ {x : C.left} (hx : x ≠ genericPoint C.left),
        CurveDivisor.deg k D₀ + 1 - Sheaf.chi (C.left.moduleKSheaf k)
            ≤ CurveDivisor.deg k (D - CurveDivisor.single hx 1) →
          Function.Surjective
            (Sheaf.HModule.map (devissageSES k hx D).g 0) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  exact fun h _ hx hD => surjective_eval_of_deg_ge k h hx D hD

end SynthesisSite

#print axioms probe_generation_curve
#print axioms probe_bounded_vanishing_curve
#print axioms probe_rr_deg_ge_curve
#print axioms probe_deg_ge_of_zero_curve
#print axioms probe_cofinality_curve
