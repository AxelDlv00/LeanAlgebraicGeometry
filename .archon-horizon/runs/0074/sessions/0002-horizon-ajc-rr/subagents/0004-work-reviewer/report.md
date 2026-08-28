TIGHT SCOPE, and please do not run any `lake build` or any command taking over ~60 seconds. Read the Lean source and report. Budget: a few minutes.

Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge

Read ONE file: AlgebraicJacobian/RiemannRoch/Adelic/ChartFinitenessRefuted.lean (about 420 lines, sorry-free, builds green — I have already verified it compiles and that all declarations report [propext, Classical.choice, Quot.sound]).

I need an adversarial check of whether its MATHEMATICS is right and whether its DOCSTRINGS overstate. Do not re-verify compilation.

THE CENTRAL THEOREM: `module_finite_functionField_of_chart_finite` claims that for a nonempty affine open U of an integral, locally-Noetherian, regular-in-codim-1 scheme X over a field k of constants,
   `Module.Finite k (sectionSub k U 0)  →  Module.Finite k X.functionField`.

The proof chain is:
 1. `sectionSub k U 0` = rational functions with ord_P ≥ 0 at every prime divisor P meeting U.
 2. It is closed under multiplication (`sectionSub_mul_mem_zero`, orders add) and contains 1, so `chartAlg` makes it a k-subalgebra of K(X).
 3. It contains the image of the chart ring Γ(X,U) (`algebraMap_chart_mem_sectionSub_zero`, via `order_algebraMap_chart_nonneg` — stalk scalar tower + mathlib `IsDedekindDomain.HeightOneSpectrum.valuation_le_one` + `order = -log ∘ pointValuation`).
 4. Finite-dimensional + domain ⟹ field (`fieldOfFiniteDimensional`).
 5. A subfield of K(X) containing Γ(X,U), whose fraction field is K(X) (`chartRing_isFractionRing`, needs `IsAffineOpen U` + `Nonempty U`), must be all of K(X) (`chartAlg_eq_top_of_isField`).

QUESTIONS, in priority order:
1. Is step 5 right? `chartAlg_eq_top_of_isField` uses `IsFractionRing.div_surjective` to write f = a/b with a,b in Γ(X,U) and then inverts b inside the field. Check the argument, especially that `b ≠ 0` in K(X) is correctly derived and that `Algebra.eq_top_iff` is the right closing move.
2. Is step 3 right — in particular, does `order_algebraMap_chart_nonneg` genuinely need no affineness (it claims the stalk tower exists for ANY open containing the point)?
3. `not_module_finite_functionField_of_primeDivisor`: claims K(X)/k is never finite once ONE prime divisor exists, via `valSubalg` (the ord ≥ 0 subring at P) being a k-finite domain hence a field, contradicted by `exists_order_eq P 1` giving t of order 1 whose inverse would have order -1. Is that airtight? Is `valSubalg` really a subalgebra (check its `algebraMap_mem'`)?
4. DOCSTRING HONESTY. The module docstring and the theorem docstrings make claims about scope — specifically that the collapse reaches U = ⊤ exactly when X is affine, and that this makes certain `Module.Finite k (sectionSub k ⊤ D)` binders elsewhere in the lane vacuous at affine schemes but fine at a proper curve. Is anything in the prose stronger than what the Lean proves? Flag any sentence that outruns its theorem.
5. Does anything in the file quietly assume the curve is a CURVE (relative dimension 1) when the theorem statement does not, or vice versa?

Report: for each numbered item, CONFIRMED / OVERSTATED / WRONG with file:line and a one-line reason. Be blunt; I would rather hear a defect now than ship it.
