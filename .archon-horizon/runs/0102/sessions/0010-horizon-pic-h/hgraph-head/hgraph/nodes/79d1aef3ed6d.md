---
author: sync
content_type: theorem
created: '2026-07-30T09:57:51'
decl: AlgebraicGeometry.pic0Map_lamOfDivRep
docstring: '**`lamOfDivRep` restricted along a test morphism IS the chart value there.**


  `lamOfDivRep n divRep m Z hdeg` is the universal element of `divRep` pushed through

  `chartValueTrans` (`Picard/JacobianDataQcFromRep.lean`).  Restricting it along `q
  : T ⟶ D` gives

  the chart value of the `D`-point `q` — two naturality steps and nothing else:

  `picEtMap_chartValue` moves the restriction inside `chartValue`, and

  `RepresentableBy.homEquiv_comp` at `q ≫ 𝟙 D` identifies the restricted universal
  element with

  `divRep.homEquiv q`.


  **Why it matters for `hcl`.**  `hcl`''s equation is `pic0Map C q lam = rep.homEquiv
  (testPoint y)`

  with `lam` a class a producer must supply.  At `lam := lamOfDivRep …` — the class
  the chart layer

  already carries, per that file''s own "`lam` is PRODUCED, not assumed" section —
  the left side is

  *the chart value of `q`*.  So `hcl` at that `lam` says exactly: **the class of `y`
  is a chart

  value at some field point**, with no reference to an Abel morphism or a compatibility
  square.'
file: AlgebraicJacobian/Picard/Pic0ChartFieldPointClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0Map_lamOfDivRep
type: lean
updated: '2026-08-01T09:44:15'
---
theorem pic0Map_lamOfDivRep {D : Over (Spec (.of k))}
    (divRep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    {T : Over (Spec (.of k))} (q : T ⟶ D) :
    ((pic0Map C q (lamOfDivRep n divRep m Z hdeg)).1 : picEt C T)
      = chartValue C π n m Z T (divRep.homEquiv q) := by
  rw [pic0Map_coe, lamOfDivRep, chartValueTrans_app_coe, picEtMap_chartValue]
  refine congrArg (chartValue C π n m Z T) ?_
  have h := divRep.homEquiv_comp q (𝟙 D)
  rw [Category.comp_id] at h
  exact h.symm

/-! ## The section a representation names at a field point -/

variable (C) in