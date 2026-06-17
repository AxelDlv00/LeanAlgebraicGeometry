# Iter-154 objectives (per-task detail)

## Lane 1 — `Cotangent/ChartAlgebra.lean` : close KDM `mem_range_algebraMap_of_D_eq_zero`

**Status entering iter-154:** 1 open `sorry` (KDM, decl ~L270 / sorry ~L427).
The route was a confirmed-blocked Mathlib gap (FT.3) at iter-153 close;
overturned this iter by the `mathlib-analogist` `ftthree-kernel` consult.

**Source of truth:** `analogies/ftthree-kernel-iter154.md` (8 compiling
`example` blocks + Mathlib citation table with module paths) and
`RigidityKbar.tex` KDM proof block § (FT.1)–(FT.3).

**Recipe (verified by compilation, b80f227):**
- FT.1 — push `D_B b = 0` to `D_K b = 0`, `K = Frac B` (`IsFractionRing`,
  `KaehlerDifferential.map_D` via existing `_hFunct`).
- FT.2 — `by_contra` `b` transcendental ⟹ `RatFunc k ↪ K`;
  `PerfectField.ofCharZero` + `EssFiniteType.comp`/`.of_comp` ⟹
  `FormallySmooth.of_perfectField` ⟹ `instSubsingletonH1CotangentOfFormallySmooth`
  ⟹ `H1Cotangent.exact_δ_mapBaseChange` makes `mapBaseChange` injective;
  `mapBaseChange_tmul`+`map_D`+`one_smul` then
  `FaithfullyFlat.one_tmul_eq_zero_iff` ⟹ `D_{RatFunc k} X = 0` ⊥ FT.3 base case.
- FT.3 — base case `D_{Frac k[X]} X ≠ 0` (`isLocalizedModule_map` +
  `IsLocalizedModule.eq_zero_iff` + `polynomialEquiv_D` +
  `nonZeroDivisors.coe_ne_zero`); closer `IsAlgebraic k b ⟹ b ∈ range`
  (`adjoin.finiteDimensional` + `IsIntegral.of_finite` +
  `IsAlgClosed.algebraMap_bijective_of_isIntegral`).

**Likely stall (strategy-critic flag):** `of_perfectField` needs
`EssFiniteType (RatFunc k) (Frac B)` + `PerfectField (RatFunc k)`. Establish
explicitly if instance synthesis misses them.

**Bright-line:** verified route → close it. If stalled on instance plumbing,
report the precise failing instance/goal; do NOT add a helper layer or
re-decompose (→ targeted analogist re-consult next iter).

**Hygiene (low priority, post-close):** remove dead `_mvPoly_*` private helpers
(`_mvPoly_coeff_pderiv_at_shifted`, `_mvPoly_mem_range_C_of_pderiv_eq_zero`,
`_mvPoly_mem_range_C_of_D_eq_zero`); KEEP `_hFunct`.

**Success = project 8 → 7**, KDM axiom-clean (`{propext, Classical.choice,
Quot.sound}`, no `sorryAx`). Closing KDM also retires the transitive `sorryAx`
on `df_zero_factors_through_constant_on_chart`.

## Gated / off-limits (no prover)
- `RigidityKbar.lean` (`rigidity_over_kbar`) — M2.b, gated on KDM.
- `Jacobian.lean` (`genusZeroWitness`, `positiveGenusWitness`) — gated / Route A.
- `ChartAlgebraS3.lean` (S3.* ×4) — descoped, orphaned.
