---
author: sync
content_type: theorem
created: '2026-07-29T11:07:14'
decl: AlgebraicGeometry.exists_effective_deg_eq_of_classDeg_eq_zero
docstring: '**THE SATISFIABILITY PROBE, and it is the one that matters here.**  `L`
  is chosen by the

  consumer but *constrained* (`classDeg K L = g`), so the failure mode is not junk-inhabitation:

  it is that **no class of degree `g` exists**, in which case the theorem above is
  a vacuous

  truth that every `sorry` census and axiom probe passes.


  **RETRACTED 2026-07-29, same session, after a fresh-context audit (`I-0799`).**  The
  first

  draft of this docstring said the probe "comes back positive, and **unconditionally
  on the

  curve**: the degree map hits `g`".  **That is false**, and it is false arithmetically,
  not

  merely unlanded: `CurveDivisor.deg` is weighted by residue degrees

  (`deg D = ∑ₓ Dₓ · [κ(x) : K]`, `RiemannRoch/Divisor.lean:61`), so its image is `index
  · ℤ` for

  the index of the curve.  On a curve of index `3` and genus `1` over `ℚ` there is
  **no** divisor

  of degree `1 = g`, and `exists_effective_deg_eq_of_classDeg_eq` is then a vacuous
  truth.  The

  campaign''s own reference divisors do not escape this: `deg (m • fiberWeilDivisor
  π) = m · δ`

  (`RiemannRoch/WindowLedger.lean:133`), so `= g` needs `δ ∣ g`.


  **So what this lemma does is RELOCATE the hypothesis, not discharge it** — `Z` is
  an argument.

  That is still worth having, because it is the *shape* a `Pic⁰` consumer meets (the
  classes

  DAT-J holds have degree `0`, not `g`, so without this face the degree-`g` statement
  would be

  a theorem nobody could instantiate).  But the honest reading is conditional: **given
  a

  degree-`g` divisor `Z` over the field in question**, every degree-`0` class yields
  an effective

  degree-`g` divisor.  Producing `Z` is a genuine arithmetic hypothesis on the curve,
  open here.


  Given any divisor `Z` of degree `g` (the caller''s fixed reference: in the campaign

  `m • fiberWeilDivisor π` for suitable `m`, whose degree is positive by

  `zero_lt_deg_fiberWeilDivisor`), every degree-`0` class `L₀` yields the degree-`g`
  class

  `L₀ · 𝒪(Z)`, and the theorem above then produces the effective degree-`g` divisor.  So
  the

  hypothesis of `exists_effective_deg_eq_of_classDeg_eq` is inhabited wherever a degree-`g`

  divisor exists, and the shift is one `classDeg_mul`.'
file: AlgebraicJacobian/Picard/JacobianDataAbelEffective.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_effective_deg_eq_of_classDeg_eq_zero
type: lean
updated: '2026-07-29T12:10:32'
---
theorem exists_effective_deg_eq_of_classDeg_eq_zero (g : ℕ)
    (hχ : Sheaf.chi (X.moduleKSheaf K) = 1 - (g : ℤ))
    (Z : X.CurveDivisor) (hZ : CurveDivisor.deg K Z = (g : ℤ))
    (L₀ : X.CechPic) (hL₀ : classDeg K L₀ = 0) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧
      CurveDivisor.picClass K E = L₀ * CurveDivisor.picClass K Z ∧
      CurveDivisor.deg K E = (g : ℤ) := by
  refine exists_effective_deg_eq_of_classDeg_eq K g hχ _ ?_
  rw [classDeg_mul, hL₀, classDeg_picClass, hZ, zero_add]