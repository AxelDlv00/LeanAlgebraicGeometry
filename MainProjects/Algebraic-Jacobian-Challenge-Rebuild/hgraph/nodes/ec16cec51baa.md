---
author: sync
content_type: theorem
created: '2026-07-19T11:01:19'
decl: AlgebraicGeometry.map_divFamPhi_top
docstring: '**The full-window image dictionary**: `Φ` carries the whole free window
  `K ⊗[k] H_a`

  exactly onto `H⁰(𝒪(N(a)))` at the transported window divisor — the `d`-free companion

  of `map_divFamPhi_divisorWindow`, giving both the pole-bound side (`hKM`/`hK''`)
  and the

  multiplier surjectivity (`hcarve`''s `h`-side) of the seed''s P-fib-N inputs.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_divFamPhi_top
type: lean
updated: '2026-07-19T11:01:19'
---
theorem map_divFamPhi_top
    (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1) :
    Submodule.map (divFamPhi C K π a hH1) ⊤
      = Scheme.divisorSections K (windowTransportDivisor C K π a) ⊤ := by
  have h1 : Submodule.map (relThetaWindowEquiv C K π a hH1).toLinearMap
      (⊤ : Submodule K (K ⊗[k]
        ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤))) = ⊤ := by
    rw [Submodule.map_top, LinearMap.range_eq_top]
    exact (relThetaWindowEquiv C K π a hH1).surjective
  have h2 : Submodule.map (thetaFieldRead C K π a) ⊤
      = Scheme.divisorSections K (thetaFieldDivisor C K π a) ⊤ := by
    refine le_antisymm ?_ ?_
    · rintro _ ⟨s, -, rfl⟩
      exact thetaFieldRead_mem C K π a s
    · intro f hf
      obtain ⟨s, hs⟩ := exists_thetaFieldRead_eq C K π a hf
      exact ⟨s, trivial, hs⟩
  have hmk : Units.mk0
      ((thetaFieldShiftUnit C K π a : (relCurve C K).functionFieldˣ) :
        (relCurve C K).functionField)
      (Units.ne_zero (thetaFieldShiftUnit C K π a)) = thetaFieldShiftUnit C K π a :=
    Units.ext rfl
  simp only [divFamPhi]
  rw [Submodule.map_comp, Submodule.map_comp, h1, h2,
    map_mulLinear_divisorSections_top K
      (Units.ne_zero (thetaFieldShiftUnit C K π a)) _]
  congr 1
  rw [hmk, ← divOf_thetaFieldShiftUnit C K π a]
  abel