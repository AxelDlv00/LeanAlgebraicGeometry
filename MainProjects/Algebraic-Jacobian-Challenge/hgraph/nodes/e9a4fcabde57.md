---
author: sync
content_type: theorem
created: '2026-07-29T07:08:53'
decl: probe_curve_consumer
docstring: 'A consumer: exact Riemann-Roch fires at a curve with only the three curve
  binders.'
file: scripts/ajcrr-fibervanishing-axioms.lean
generated: lean
lean_status: lean_ok
title: probe_curve_consumer
type: lean
updated: '2026-07-31T06:47:52'
---
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