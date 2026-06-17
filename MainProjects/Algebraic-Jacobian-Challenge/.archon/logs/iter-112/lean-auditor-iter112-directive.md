# Lean Auditor Directive

## Slug
iter112

## Scope (files)
all

## Focus areas (optional)
The iter-112 prover round edited `AlgebraicJacobian/Differentials.lean`, introducing two new top-level helpers
(`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L159 with a `sorry` body,
`relativeDifferentialsPresheaf_isSheaf_type` at L188 fully closed) and rewrote the proof body of
`relativeDifferentialsPresheaf_isSheaf` (L220) into a Step-1-then-helper-delegation pattern.
Pay extra attention to that file. Otherwise audit the whole project as usual.

## Known issues
- Carry-over major findings from `lean-auditor-iter109` audit on `Differentials.lean` header rot,
  `BasicOpenCech.lean` docstring rot, `BasicOpenCech.lean:L1742` cross-iter excuse-comment framing.
  Please re-flag if still present but do NOT count as new findings.
- The 7 named-deferred Mathlib-gap sorries + 1 budget-deferral
  (`Modules/Monoidal.lean:L173 instIsMonoidal_W`,
  `Picard/LineBundle.lean:L82 SheafOfModules.pullback_tensorObj`,
  `Picard/LineBundle.lean:L96 SheafOfModules.pullback_oneIso`,
  `Picard/Functor.lean:L181 representable`,
  `Jacobian.lean:L179 nonempty_jacobianWitness`,
  `Differentials.lean:L622 h_exact`,
  `Differentials.lean:L976 serre_duality_genus`,
  `BasicOpenCech.lean:L1846 h_loc_exact -- DEFERRED (budget)`)
  are all DOCUMENTED, on-purpose, named-deferred — please flag only if a NEW excuse-comment
  or undocumented `sorry` appears.
- The two iter-112 new helpers documented above are SCAFFOLDING explicitly enacting the
  blueprint Route (a) recipe; flag them only if the docstring/body diverges substantively
  from the chapter prose.
