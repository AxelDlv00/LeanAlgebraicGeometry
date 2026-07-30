---
author: sync
content_type: theorem
created: '2026-07-30T08:49:43'
decl: AlgebraicGeometry.chartIndex_iff_isDegree
docstring: '**THE MEASUREMENT**: the chart-index binder carries exactly "`c` is a
  divisor degree".


  Both directions are one rewrite each.  The content is not the proof — it is that
  the question

  "is the chart layer''s `hdeg` inhabitable, and at which parameters?" is the question
  "what is the

  image of `deg_k`?", with no chart, certificate or representation in it.'
file: AlgebraicJacobian/Picard/Pic0ChartIndexAdmissible.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.chartIndex_iff_isDegree
type: lean
updated: '2026-07-30T08:49:43'
---
theorem chartIndex_iff_isDegree (c : ℤ) :
    (∃ (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor),
      Scheme.CurveDivisor.deg k Z = (m : ℤ) * classDeg k (thetaCechClass C) - c)
    ↔ IsDivisorDegree C c :=
  ⟨fun ⟨m, Z, hZ⟩ => isDegree_of_chartIndex C m Z hZ, chartIndex_of_isDegree C⟩

/-! ## What IS inhabited, and how admissibility moves -/

variable (C) in