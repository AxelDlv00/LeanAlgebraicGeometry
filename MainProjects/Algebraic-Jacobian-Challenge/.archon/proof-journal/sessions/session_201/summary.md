# Session 201 — Review of iter-201

## Session metadata

- **Session number**: 201 (= iter-201)
- **Sorry count before**: 78 (iter-200 close)
- **Sorry count after**: 78 (unchanged — substrate-only iter; net 0)
- **Project axioms**: 0 → 0 (**21st consecutive zero-axiom build
  streak**)
- **Targets attempted**: 3 prover lanes — all returned `done` clean
  (no API 529; per `logs/iter-201/meta.json`)
  - Lane WD-A4a Sub-build 2 on
    `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
  - Lane AB-Stacks-00MF Path B on
    `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
  - Lane COE-Stage6.B-Jacobian on
    `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- **Iteration shape**: 3-lane substrate-only iter under USER
  2026-05-28 standing directive (ROUTE C PAUSE permanent; Route A
  bottom-up; reference-driven mathlib-build).

## Outcome at a glance

- **`lake build AlgebraicJacobian` GREEN** per
  `.archon/logs/iter-201/meta.json` (`prover.status: done`,
  `planValidate.objectives: 3`).
- **13 axiom-clean substrate declarations added across the 3 files**
  (6 in WD; 4 in AB `RingTheory.Module`; 3 private in COE
  `AlgebraicGeometry.Scheme`). Every new declaration verified via
  `lean_verify` to depend only on the kernel triple `{propext,
  Classical.choice, Quot.sound}`.
- **Sorry trajectory**: WD 3 → 3, AB 1 → 1, COE 3 → 3. **Net 0** —
  matches the iter-201 plan's **worst-case** projection (78 → 78,
  all 3 lanes substrate-only). No closures; no new sorries.
- **HARD BAR landings**: **1 of 3 lanes** met HARD BAR with
  substantive structural advance plus an additional PUSH-BEYOND
  partial.
  - Lane WD-A4a Sub-build 2: **MET**.
    `Ring.ordFrac_ringEquiv` axiom-clean at L311 plus 3 ancillary
    naturality helpers (`Ring.ord_ringEquiv`,
    `Ring.nonZeroDivisors_ringEquiv`,
    `Ring.ordMonoidWithZeroHom_ringEquiv`). PUSH-BEYOND step (2)
    **partial**: `Scheme.Opens.functionFieldIso` axiom-clean (L380)
    + `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`
    axiom-clean (L519) as a scheme-side wrapper taking the
    IsFractionRing-compatibility `h_compat` as a parameter; iter-202
    Sub-build 3 will discharge `h_compat` via stalkSpecializes
    naturality.
  - Lane AB-Stacks-00MF Path B: **NOT MET** for the closure HARD
    BAR; **MET** for the matrix-collapse-substrate sub-HARD-BAR.
    The 4 axiom-clean `RingTheory.Module` helpers
    (`elemMap`, `elemMap_apply`, `linearMap_finFunR_matrix_decomp`,
    `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`) IS the
    binding new piece per the `ab-stacks00mf` analogist Path B
    recipe. The body of `auslander_buchsbaum_formula_succ_pd`
    (residual sorry at L1696) remains unclosed; iter-202 closes it
    by restructuring as `induction k generalizing M`, with
    base-case = matrix-collapse + LES (~50-80 LOC) and inductive
    step = `depth_of_short_exact` parts (2)+(3) (~30-50 LOC, no
    matrix-collapse needed).
  - Lane COE-Stage6.B-Jacobian: **NOT MET** for the Step A
    closure HARD BAR; substrate-only progress on 3 sub-pieces. The
    Step A1 Matsumura helper is gated on the Mathlib gap
    `IsRegularLocalRing → IsDomain` (Stacks 00NQ) AND on the
    inductive `A / (f₁)` regular-local-ring preservation, both
    confirmed absent at Mathlib `b80f227`. The 3 substrate landings
    cover (a) Step A2 cotangent-side lin-indep forward
    ergonomics + transport through a generic localisation map and
    (b) Mathlib-gap-conditional Step 1+2+3 composite at the
    polynomial-ring setting; once the Stacks 00NQ pieces land they
    will collapse Step A to ~30-50 LOC.
- **Plan trajectory** (per iter-201 plan): best 78 → ~73-75,
  realistic 78 → ~76-77, worst 78 → ~78. **Lands worst-case band**
  with substantive structural advance on Lane WD plus axiom-clean
  binding substrate on Lane AB.
- **No placeholder body / headline-laundering risk** this iter —
  every new declaration is honest mathematical content with full
  axiom-clean bodies; the trailing sorries (L1696 in AB; L1061 in
  COE; the existing L535 / L538 / L1108 in WD plus the 2 other
  COE sites) are precisely-typed substrate gaps named in the
  prover reports.

## Per-target attempts (drawn from `attempts_raw.jsonl`)

### Target 1 — `AlgebraicGeometry.Scheme.rationalMap_order_finite_support`
### (Lane WD-A4a Sub-build 2 — Scheme/Lean: `RiemannRoch/WeilDivisor.lean`)

The lane budget targets a single HARD BAR + an optional
PUSH-BEYOND; both landed.

- **Substrate L247 `Ring.ord_ringEquiv`** — built the R-linear
  equivalence `R/(x) ≃ₗ[R] S/(e x)` via
  `Ideal.quotientEquiv (Ideal.span {x}) (Ideal.span {e x}) e _ `
  promoted to R-linear by `Quotient.inductionOn`, then chained
  `LinearEquiv.length_eq` (R-side) with
  `Module.length_eq_of_surjective` (R-vs-S, surjective algebra
  map). RESOLVED axiom-clean.
- **Substrate L273 `Ring.nonZeroDivisors_ringEquiv`** —
  `MulEquivClass.map_nonZeroDivisors` + `Submonoid.map` chase via
  `e.injective`. RESOLVED axiom-clean.
- **Substrate L285 `Ring.ordMonoidWithZeroHom_ringEquiv`** —
  `unfold Ring.ordMonoidWithZeroHom; by_cases r ∈ nzd R` then
  rewrite each branch via the above two helpers. RESOLVED
  axiom-clean.
- **HARD BAR L311 `Ring.ordFrac_ringEquiv`** — `by_cases hx : x = 0`,
  obtain `(a, b)` with `b ∈ nzd R` via `IsLocalization.surj`,
  deduce `a ≠ 0` from `x ≠ 0` + `algebraMap R K_R b ≠ 0` (via
  `IsFractionRing.injective` + `mem_nonZeroDivisors_iff_ne_zero`),
  lift to `a ∈ nzd R` via `mem_nonZeroDivisors_of_ne_zero` (uses
  `[IsDomain R]`), express both sides as
  `mk' K_R a ⟨b, _⟩` / `mk' K_S (e a) ⟨e b, _⟩` via
  `IsLocalization.mk'_eq_iff_eq_mul`, apply Mathlib's
  `Ring.ordFrac_eq_div`, close via
  `ordMonoidWithZeroHom_ringEquiv` on numerator and denominator.
  RESOLVED axiom-clean. **HARD BAR met**.
- **PUSH-BEYOND L380 `Scheme.Opens.functionFieldIso`** — compose
  `Scheme.Opens.stalkIso U (genericPoint U.toScheme)` with
  `X.presheaf.stalkCongr` along
  `genericPoint_eq_of_isOpenImmersion U.ι`. `Inseparable` witness
  collapses to `refl` after the rewrite. RESOLVED axiom-clean
  (forced `noncomputable`).
- **PUSH-BEYOND L519 `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`** —
  apply `Ring.ordFrac_ringEquiv` with
  `e := (Scheme.PrimeDivisor.stalkIso U Y hYU).commRingCatIsoToRingEquiv`
  taking `e_K` and `h_compat` as caller-supplied parameters. The
  typeclass chain (`IsDomain`, `IsNoetherianRing`,
  `Ring.KrullDimLE 1`) discharges via iter-200's
  `IsRegularInCodimensionOne.instOpen` and `instKrullDimLEStalk`.
  RESOLVED axiom-clean.

Attempt log: 6 distinct axiom-clean substrate decls. Several
`lean_run_code` cycles on the matrix-collapse Module substrate
(below) generated unrelated friction; the WD lane proceeded
without retries.

### Target 2 — `RingTheory.auslander_buchsbaum_formula_succ_pd`
### (Lane AB-Stacks-00MF Path B — `Albanese/AuslanderBuchsbaum.lean`)

- **Mathlib API probe (~15 min)**: `lean_loogle` /
  `lean_leansearch` over `Abelian.Ext.{add_comp, smul_comp,
  mk₀_smul, mk₀_sum, comp_sum}` and `ModuleCat.ofHom_{add, smul,
  sum}`. Findings:
  - `Ext.mk₀_sum` / `Ext.comp_sum` / `Ext.mk₀_smul` /
    `Ext.comp_smul` all EXIST.
  - `ModuleCat.ofHom_add` EXISTS (`Mathlib/Algebra/Category/
    ModuleCat/Basic.lean`); `ModuleCat.ofHom_smul` and `ofHom_sum`
    do NOT exist as named lemmas (the Ext-side `mk₀_smul`
    absorbs the scalar).
  Confirmed that Path B's matrix-collapse argument is
  Mathlib-substrate-complete; ofHom_smul's absence does not
  matter because scalars are absorbed into the basis vectors
  before pushing through ofHom.

- **Substrate L~1418 `Module.elemMap n m i j`** — defined
  `(toSpanSingleton R (Fin n → R) (Pi.single i 1)) ∘ₗ
  (LinearMap.proj j)`. RESOLVED axiom-clean.
- **Substrate L~1425 `Module.elemMap_apply`** —
  `LinearMap.toSpanSingleton_apply` + `Pi.single_eq_same` /
  `Pi.single_eq_of_ne` case-split. RESOLVED axiom-clean.
- **Substrate L~1442 `Module.linearMap_finFunR_matrix_decomp`** —
  `A x = (∑_{(i,j)} A(Pi.single j 1) i • elemMap _ _ i j) x`.
  Decompose `x = ∑_j (x j) • Pi.single j 1`, push through `A` via
  `map_sum + map_smul`, expand each row
  `A(Pi.single j 1) = ∑_i (...) • Pi.single i 1`, reshuffle the
  double sum via `Finset.sum_product_right`, close via
  `LinearMap.smul_apply + elemMap_apply`. RESOLVED axiom-clean
  after several `lean_run_code` iterations on the rewrite
  ordering: the basis decomposition must happen BEFORE the outer
  sum reshuffle, not after.
- **Substrate L~1481
  `Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`** —
  the matrix-collapse helper per the `ab-stacks00mf` Path B
  recipe. Given `A : R^m →ₗ R^n` with `A(Pi.single j 1) i ∈
  Ann_R N`, the postcomposition `e.comp (mk₀ (ofHom A))` is zero
  in `Ext^p(N, R^n)`. Substitute the matrix decomposition into
  `ofHom`, push through `mk₀` and `comp` via
  `ModuleCat.hom_sum + Ext.mk₀_sum + Ext.comp_sum` and
  `Ext.mk₀_smul + Ext.comp_smul`; each summand reduces to
  `A_{ij} • (e.comp (mk₀ (ofHom (elemMap _ _ i j))))`, where the
  scalar `A_{ij} ∈ Ann_R N` makes the summand zero via the
  existing `ext_smul_eq_zero_of_mem_annihilator` (L229).
  RESOLVED axiom-clean (`{propext, Classical.choice, Quot.sound}`
  per `lean_verify`).

- **Closure of `auslander_buchsbaum_formula_succ_pd` body** — NOT
  attempted. The analogist Path B base case (k=0, pd M=1) needs
  ~50-80 LOC of LES bookkeeping + linear-equivalence transport on
  top of the matrix-collapse substrate. The inductive step
  (k≥1) needs ~30-50 LOC of `depth_of_short_exact` parts (2)+(3),
  and per the analogist alternative does NOT need matrix-collapse
  (only the base case needs it). Both pieces are doable in
  iter-202 with the substrate landed; restructuring as
  `induction k generalizing M` is required so the IH at smaller k
  is reachable inside the recursive call.

### Target 3 — `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth`
### (Lane COE-Stage6.B-Jacobian — `Albanese/CodimOneExtension.lean`)

- **Mathlib scout for Step A1 (Matsumura helper)** —
  `lean_local_search` over
  `IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem`,
  `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`,
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`,
  `LinearIndependent.of_isLocalizedModule_of_isRegular`,
  `isRegular_cons_iff`; plus grep over Mathlib
  `RingTheory/RegularLocalRing/` (single file `Defs.lean`).
  Findings:
  - `IsRegularLocalRing → IsDomain` (Stacks 00NQ): ABSENT in
    forward direction; only the PID converse instance
    `[IsLocalRing] [IsDomain] [IsPrincipalIdealRing] → IsRegularLocalRing`
    exists. The standard proof goes via associated-primes /
    Cohen-Macaulay (~100-200 LOC project-local OR Mathlib upstream PR).
  - `A / (f₁) → IsRegularLocalRing` preservation: ABSENT. Mathlib
    has `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`
    (dim drops by 1 under `IsSMulRegular`) but no RLR-preservation
    lemma.
  - `IsRegularLocalRing.localization` (Stacks 00OF): ABSENT
    (confirmed by grep over the whole `RingTheory/RegularLocalRing/`
    directory — only `Defs.lean`).
  All three gaps are substantive. The Step A1 closure is gated.

- **Substrate L854
  `submersivePresentation_relation_cotangent_mk_linearIndependent`** —
  re-package `P.basisCotangent.linearIndependent` combined with
  `P.basisCotangent_apply` as the explicit
  `Cotangent.mk`-of-relation form. RESOLVED axiom-clean. Initial
  attempt used parameter names `ι σ` clashing with greek-letter
  ambient binders (`unexpected token 'ι'`); renamed to `ix sx` and
  recompiled clean.
- **Substrate L889
  `submersivePresentation_relation_cotangent_mk_linearIndependent_localized`** —
  apply `LinearIndependent.of_isLocalizedModule` on top of #1,
  transporting through `LocalizedModule.mkLinearMap` at any prime
  `p` of `S`. RESOLVED axiom-clean. Realises Analogue D of the
  `coe-stacks00sw` recipe at the un-quotiented cotangent level.
  **Residual A2 work**: identifying
  `LocalizedModule p.primeCompl P.toExtension.Cotangent` with
  `(I·A)/(I·A)²` over `A = S_p` (Stacks 02JK at non-Away primes)
  is a separate Mathlib gap not landed here.
- **Substrate L924
  `ringKrullDim_quotient_localization_MvPolynomial_of_regular`** —
  Mathlib-gap-conditional composite chaining iter-200's
  `ringKrullDim_localization_atMaximal_MvPolynomial` (Step 1+2,
  polynomial-ring side) with iter-200's
  `ringKrullDim_quotient_add_eq_of_regular_sequence` (Step 3
  additive form). Given an `IsRegular A rs` witness (the
  substantive iter-201+ Step A obligation), this reduces the
  `ringKrullDim S_m = n` conclusion of Stacks 00OE to a one-line
  invocation. RESOLVED axiom-clean.
- **PUSH-BEYOND L1061 `isRegularLocalRing_stalk_of_smooth`** —
  NOT attempted. Gated on (i) Step A1 (Matsumura helper, Mathlib
  gap), (ii) conormal-localisation iso for `AtPrime` (residual A2,
  Mathlib gap), and (iii) scheme-to-algebra bridge extracting the
  `SubmersivePresentation` from
  `Algebra.IsStandardSmoothOfRelativeDimension Γ(Spec, U) Γ(X.left, V)`.
  No closure cascade to Lane T32 fires this iter.

## Key findings / patterns

1. **Bilinear `Ext` matrix-collapse recipe** is now a project-canonical
   pattern (see `## Knowledge Base` addition in `PROJECT_STATUS.md`).
   For any postcomposition `e.comp (mk₀ (ofHom A))` where `A` factors
   through a finite product, the standard chain is:
   - basis-decompose `A = ∑ A_{ij} • elemMap _ _ i j`;
   - push through `ofHom` via `ModuleCat.hom_sum` + `ofHom_add`;
   - push through `mk₀` via `Ext.mk₀_sum` + `Ext.mk₀_smul`;
   - push through `comp` via `Ext.comp_sum` + `Ext.comp_smul`;
   - close per-summand via a scalar-annihilator helper.
   The absence of `ModuleCat.ofHom_smul` does NOT block this — the
   scalar is absorbed into the basis vector before `ofHom`.

2. **`Ring.ordFrac` is fully API-symmetric under compatible
   `RingEquiv` + `IsFractionRing` chains.** The 4-helper modular
   decomposition (`ord_ringEquiv`, `nonZeroDivisors_ringEquiv`,
   `ordMonoidWithZeroHom_ringEquiv`, `ordFrac_ringEquiv`) factors
   through Mathlib's `Ring.ordFrac_eq_div` + the `mk'` API of
   `IsLocalization`. Reusable for any order/multiplicity transport
   across stalk isomorphisms; see `## Knowledge Base` addition.

3. **The `coe-stacks00sw` recipe's A1 step requires a Mathlib-side
   commutative algebra build of meaningful size** (~100-200 LOC for
   Stacks 00NQ alone). The iter-201 scouting confirms this is not
   a tactical gap but a substantive substrate obligation. The
   Lane T32 re-engagement trigger (named for COE Stage 6.B closure)
   itself names `IsRegularLocalRing → IsDomain` as a piece, so the
   Mathlib-gap closure is doubly-load-bearing.

4. **The plan agent's same-iter blueprint-reviewer fast path
   worked correctly** — the iter-201 AB chapter was flagged
   `complete: true, correct: partial` on first pass; the plan agent
   landed 3 `Lemma~REF` substitutions and re-dispatched the
   reviewer scoped to AB alone, which re-verified
   `complete + correct`. This is the canonical no-latency-cost
   shape for must-fix-this-iter blueprint findings.

## Recommendations for the next session

See `recommendations.md`. Top items:
- iter-202 Lane AB-Path-B-Continue: restructure
  `_succ_pd` as `induction k generalizing M`, base case via
  matrix-collapse + LES, inductive step via
  `depth_of_short_exact` (no matrix-collapse needed). Remove
  `private` per plan option (1).
- iter-202 Lane WD-A4a Sub-build 3: discharge `h_compat` via
  stalkSpecializes naturality (~30-60 LOC).
- iter-202 Lane COE: dispatch a `mathlib-analogist` to scout
  whether either of the two Stacks 00NQ / `A/(f₁)` Mathlib gaps
  has a recent upstream PR landing before committing a
  project-local build.

## Blueprint markers updated (manual)

(none this iter — no `\mathlibok` adds, no `\lean{...}` renames
flagged in the prover task reports, no stale `\notready` markers
identified; the deterministic `sync_leanok` ran iter=201 with 5
added / 0 removed touching `RiemannRoch_WeilDivisor.tex` only.)

## Subagent dispatches

| Subagent | Slug | Status |
|---|---|---|
| lean-auditor | `iter201` | RETURNED (1 must-fix / 2 major / 5 minor) |
| lean-vs-blueprint-checker | `wd-iter201` | RETURNED (1 major / 1 soon / 1 minor) |
| lean-vs-blueprint-checker | `ab-iter201` | RETURNED (1 major / 1 soon / 3 minor) |
| lean-vs-blueprint-checker | `coe-iter201` | RETURNED (0 must-fix / 3 soon / 1 minor) |

**lean-auditor `iter201` key findings (landed into
recommendations.md as CRIT-LA-1 / CRIT-LA-2)**:

- **CRIT-LA-1 (must-fix)**: `RelPicFunctor.lean:266-269` `-- TODO +
  exact sorry` excuse-comment on the load-bearing `addCommGroup`
  instance for `Quotient (preimage_subgroup πC πT)`. The iter-201
  plan agent's "DEFERRAL DOCUMENTED" rationale (gated on iter-204+
  TensorObjSubstrate body fill) does NOT silence the audit alarm:
  four downstream declarations silently inherit `sorryAx` via
  instance synthesis through this addCommGroup. iter-202 corrective
  options surfaced (pull-forward of iter-204 work OR carrier-soundness
  probe pattern per iter-199 Lane FGA).

- **CRIT-LA-2 (major × 2)**: `AuslanderBuchsbaum.lean:2415` section
  header + `:1906` docstring carry stale "typed sorry" labels on
  declarations whose bodies ARE now full axiom-clean proofs
  (`notMem_minimalPrimes_of_regularLocal_succ` +
  `finrank_cotangentSpace_quot_span_singleton_succ`). Misleads
  readers (including the plan agent) about file state.

- **Cross-file positive finding (HIGH-IMPACT)**: the iter-201 closure
  of `notMem_minimalPrimes_of_regularLocal_succ` makes
  `CohenMacaulay.of_regular` axiom-clean for the first time AND
  exposes that **the project ALREADY HAS a private project-local
  Stacks 00NQ witness** (`isDomain_of_regularLocal` at
  `AuslanderBuchsbaum.lean:2657`) which the Lane COE prover's
  Mathlib scout missed. This materially changes the iter-202 Lane
  COE plan: Step A1's "Mathlib gap" classification (CRIT-2 in
  recommendations.md) is wrong — the witness exists project-side,
  needs only promotion from `private` to public. The same chain
  also delivers Lane T32 derivative re-engagement trigger
  satisfaction.

The 3 lean-vs-blueprint-checker dispatches remain in flight
(reports landing in `task_results/` and auto-archiving to
`logs/iter-201/`); their findings will be picked up by the iter-202
plan agent.

## Notes (LOW)

- Blueprint doctor: **no structural findings** at iter-201 (every
  chapter `\input`'d; every `\ref` / `\uses` resolves; every
  annotation argument non-empty; no new `axiom` declarations).
- `sync_leanok-state.json`: `{iter: 201, added: 5, removed: 0,
  chapters_touched: [RiemannRoch_WeilDivisor.tex]}` — markers
  reflect the current tree; no manual override required.
- Project axiom streak: 21st consecutive zero-axiom build.
