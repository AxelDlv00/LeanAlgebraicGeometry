# progress-critic — slug `route202`

Audit the 4 active prover lanes proposed for iter-202. Issue
per-route CONVERGING / CHURNING / STUCK / UNCLEAR verdict + Dispatch-
sanity check on the PROGRESS.md proposal.

## Active lanes (4) — last K=5 iters signals

K = 5 (iter-197..201 trajectory).

### Lane WD-A4a (`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`)

- **Sorry count per iter** (file-level): iter-197 3 → 198 3 → 199 3 →
  200 3 → 201 3.
- **Helpers added per iter** (this lane):
  - iter-197: ~0 (lane held).
  - iter-198: ~3 helpers + structural blocker doc.
  - iter-199: ~2 axiom-clean §2 helpers (`order_neg`, `order_pow_of_ne_zero`)
    + 3-Sub-build roadmap surfaced.
  - iter-200: ~8 axiom-clean substrate decls (PrimeDivisor.ext,
    restrictToOpen, ofOpen, 2 simp helpers, equivOpen, stalkIso,
    IsRegularInCodimensionOne.instOpen) — Sub-build 1 closed.
  - iter-201: ~6 axiom-clean decls (4 private `Ring.*` ord-naturality
    helpers + public `Scheme.Opens.functionFieldIso` + private
    packaging `ordFrac_stalkIso_naturality`) — Sub-build 2 HARD BAR
    MET + PUSH-BEYOND partial.
- **Prover statuses last 5 iters**: 199 PARTIAL (substrate-only) →
  200 PARTIAL (Sub-build 1 substrate) → 201 COMPLETE (Sub-build 2
  HARD BAR + PUSH-BEYOND partial).
- **Recurring blocker phrases**: "USER-blocked sig strengthening on
  L535" (this is a real strategy-level constraint, not a prover
  failure — Sub-builds 2/3 are out of scope of that block).
- **Strategy `Iters left`**: ~4-6 (refreshed iter-202 from ~3-6).
- **Lane phase entered**: iter-187 (1st substrate iter) — currently
  iter 14 in this lane's life; current Sub-build (3) is iter-202 work.
- **iter-202 proposal**: Lane WD-A4a-Sub-build-3 (discharge h_compat
  via Scheme.Opens.functionFieldIso + stalkSpecializes naturality).

### Lane AB-A4b (`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`)

- **Sorry count per iter** (file-level): iter-197 1 → 198 1 → 199 1 →
  200 1 → 201 1.
- **Helpers added per iter** (this lane):
  - iter-197: ~3 helpers.
  - iter-198: ~5 helpers (gap (4) closed).
  - iter-199: ~1 axiom-clean substrate helper (`exists_minimalSurjection_finite_localRing`,
    ~99 LOC, Nakayama-lift via `Pi.basisFun.constr`).
  - iter-200: ~4 axiom-clean SES-descent helpers via Path A → Path B
    ALIGN_WITH_MATHLIB pivot (`hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`,
    `hasProjectiveDimensionLT_ker_of_surjection`,
    `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`,
    `depth_ker_ge_min_of_surjection_finite_localRing`).
  - iter-201: ~4 axiom-clean matrix-collapse helpers (`elemMap`,
    `elemMap_apply`, `linearMap_finFunR_matrix_decomp`,
    `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`) per
    Path B analogist recipe. Plus `notMem_minimalPrimes_of_regularLocal_succ`
    closure (closed independently, enabling `CohenMacaulay.of_regular`
    axiom-clean for the first time per iter-201 lean-auditor cross-file
    finding).
- **Prover statuses last 5 iters**: 197 PARTIAL → 198 PARTIAL →
  199 PARTIAL → 200 PARTIAL → 201 PARTIAL.
- **Recurring blocker phrases**: iter-200 "Stacks 00MF needed" →
  iter-201 analogist verdict "Path B obviates 00MF; matrix-collapse
  substrate is the binding new piece" → iter-201 prover landed
  matrix-collapse + identified Nat-induction restructuring as iter-202
  closure obligation.
- **Strategy `Iters left`**: ~2-4 (refreshed iter-202 from ~3-6).
- **Lane phase entered**: iter-185 (early AB substrate work) —
  currently iter 16 in this lane's life; binding HARD BAR is the
  `_succ_pd` body closure.
- **iter-202 proposal**: Lane AB-Path-B-Close (body closure via
  Nat-induction restructuring + remove `private` from 3 declarations
  for cross-file consumption by Lane COE iter-203).

### Lane COE-A4c0 (`AlgebraicJacobian/Albanese/CodimOneExtension.lean`)

- **Sorry count per iter** (file-level): iter-197 3 → 198 3 → 199 3 →
  200 3 → 201 3.
- **Helpers added per iter** (this lane):
  - iter-197: ~0 (lane held).
  - iter-198: ~1 substrate decl + sub-gap (i) discharger.
  - iter-199: ~4 axiom-clean Stage 6.B Stacks 02JK cotangent helpers
    (`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`
    + siblings).
  - iter-200: ~7 axiom-clean private substrate theorems Steps 1+2+3
    additive form (`MvPolynomial.maximalIdeal_height_ge_card_of_field`,
    `maximalIdeal_height_eq_natCard`, `ringKrullDim_localization_atMaximal_MvPolynomial`,
    `ringKrullDim_quotient_add_eq_of_regular_sequence`, etc.).
  - iter-201: ~3 axiom-clean substrate decls
    (`submersivePresentation_relation_cotangent_mk_linearIndependent`,
    `..._localized`, `ringKrullDim_quotient_localization_MvPolynomial_of_regular`)
    — Step A1 PROVER-SCOUT BLOCKED on what it classified as 3 Mathlib
    gaps; iter-201 lean-auditor cross-file finding INVERTED 2 of 3 of
    those: project has them as private witnesses in AB.lean.
- **Prover statuses last 5 iters**: 197 PARTIAL → 198 PARTIAL → 199
  PARTIAL → 200 PARTIAL → 201 PARTIAL.
- **Recurring blocker phrases**: iter-200 "Step 3 Jacobian-regular-sequence
  witness gated on Mathlib gap" → iter-201 "Mathlib gap: IsRegularLocalRing
  → IsDomain (Stacks 00NQ) MISSING" → iter-201 lean-auditor INVERTED:
  "project has `isDomain_of_regularLocal` private at L2657, axiom-clean;
  promotion to public is the binding fix".
- **Strategy `Iters left`**: ~4-7 (refreshed iter-202 from ~3-6).
- **Lane phase entered**: iter-177 file-skeleton — currently iter 24
  in this lane's life; current Stage 6.B Krull-dim formula sub-gap
  is the binding closure target.
- **iter-202 proposal**: Lane COE-Step-B-Bridges (substrate-only —
  scheme-to-algebra bridges for L1061; Step A1 closure deferred
  iter-203 pending Lane AB this-iter promotions).

### Lane TS-A1cSubT (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

- **Sorry count per iter**: file does not yet exist (iter-202 is
  first scaffold dispatch).
- **Helpers added per iter**: N/A.
- **Prover statuses last 5 iters**: N/A; blueprint chapter
  `Picard_TensorObjSubstrate.tex` landed iter-200 (~740 lines, 4
  pinned + 5 supporting declarations).
- **Recurring blocker phrases**: none yet; pre-scaffold.
- **Strategy `Iters left`**: ~3-6 (current).
- **Lane phase entered**: iter-202 (file-skeleton scaffold this iter
  is the lane's first dispatch).
- **iter-202 proposal**: Lane TS-Scaffold (file-skeleton scaffold, 4
  typed-sorry stubs from blueprint chapter; gates Lane RPF body fill
  iter-204+; this is the corrective for the iter-201 lean-auditor
  must-fix on RelPicFunctor L266-269 — the gap is the substrate, this
  iter's scaffold begins the chain that closes it iter-204+).

## PROGRESS.md `## Current Objectives` snapshot

4 files, basenames:
1. `WeilDivisor.lean` (Lane WD)
2. `AuslanderBuchsbaum.lean` (Lane AB)
3. `CodimOneExtension.lean` (Lane COE)
4. `TensorObjSubstrate.lean` (Lane TS, NEW file)

Total: 4 lanes; modes: 3× mathlib-build + 1× prove. Within the
dispatch cap (~10) with headroom for dependencies.

## What to assess

Per-lane verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with
specific corrective when CHURNING or STUCK. Dispatch-sanity check on
the 4-file objective set (count OK, modes reasonable). For Lane COE
in particular: assess whether the "substrate-only this iter, Step A1
iter-203 after AB-promotions land" coordination split is the right
call vs. attempting parallel Lane COE Step A1 + Lane AB promotions
this iter (would Lane COE see stale `private`-bearing file state
mid-session and fail? — the parallel-dispatch coordination concern).

Trajectory pacing: iter-201 trajectory had 1-of-3 HARD BARs MET
(WD). Is this acceptable substrate-only pace given that all 3 lanes
landed meaningful axiom-clean substrate (3 + 4 + 6 = 13 new decls)?
Or does the 0-net-sorry-trajectory warrant a more aggressive
corrective?
