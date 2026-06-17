# Iter 020 — Objectives (per-lane detail)

## Lane GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean` [prove]

**Target 1 (must close): L4 finiteness leaf** `exists_localizationAway_finite_mvPolynomial` @754.
- Injectivity scaffolding already landed iter-019 (ν = `IsLocalization.lift`, ψ, bⱼ, φ = `aeval b`,
  compatibility square `hsquare`, `Function.Injective φ`) — transfers verbatim to a finer witness.
- Recipe (Nitsure §4 integral clearing): refine witness `g0 → g := g0·g1` with `g1≠0` clearing the
  `K[X]`-coefficients of the monic integral-dependence relations of the generating set σ
  (`gf_clear_one_denominator` CLOSED / `IsLocalization.exist_integer_multiples` folded over σ); pull
  cleared monic relations back through injective ν ⟹ σᵢ integral over `A_g[X]`;
  `Algebra.adjoin A_g (algebraMap B B_g '' σ)=⊤` + `Algebra.finite_adjoin_of_finite_of_isIntegral`.
- `hgB_unit` needs only `g0 ∣ g`. Heartbeat bump only if ν/bⱼ synthesis stalls.

**Target 2 (begin, ≥1 step): `genericFlatnessAlgebraic`** @1797.
- §4 dévissage via `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` over B; L4+L5 available.
- Prove the motive setup + ≥1 reduction step; honest residual sorry at first blocked node (NOT a bare
  scaffold sorry).

Partial bar: L4 finiteness CLOSED + dévissage motive + ≥1 step. Out of scope: GF-geo @1864.
Recipe file: `analogies/gf-generic-rank-ses.md`. Blueprint: `lem:gf_noether_clear_denominators`
(Step 3c), `lem:gf_isLocalization_lift_injective`.

## Lane QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean` [prove]

**Target (must close): `iSupIndep` base-case leaf** @1494 inside `subquotient_base_eventuallyZero`.
- Goal: `iSupIndep (fun n => LinearMap.range (ψ n))` of degreewise images in finite-dim `Q₀`.
- ROUTE (b) ONLY (route (a) `Submodule.liftQ` = scalar-ring dead end, hard-prohibited):
  destructure `⨆ j≠n range (ψ j)` via `Submodule.mem_iSup_iff_exists_dfinsupp`; extract dfinsupp
  support; read the degree-`n` homogeneous component directly via the ambient grading
  (`decompose_of_mem_ne` / `decompose_of_mem_same`); stay inside `Q₀`'s κ-structure, no outgoing map;
  finish `Submodule.finite_ne_bot_of_iSupIndep`.
- Closing it ⟹ `subquotient_base_eventuallyZero` + `subquotient_hilbertSeries_rational` +
  `gradedModule_hilbertSeries_rational` all axiom-clean = **SNAP-S2 keystone complete**.
- HARD CONSTRAINT: no `DirectSum.Decomposition`/`IsInternal` on quotient/subtype carrier; isDefEq
  recurrence ⇒ STOP + report (no heartbeat raise). 4 protected stubs untouched.
- Blueprint: `lem:graded_subquotient_base_eventuallyZero`.

## FBC — NO PROVER this iter
Route swapped (domain-read route supersedes the dead Seam-2 `fstar_reindex`). iter-021: dead-code
removal refactor + prove Seam-3 `gstar_transpose` @1490.
