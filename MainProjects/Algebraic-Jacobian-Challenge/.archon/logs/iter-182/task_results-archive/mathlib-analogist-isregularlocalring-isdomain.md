# Mathlib Analogist Report

## Mode
api-alignment

## Slug
isregularlocalring-isdomain

## Iteration
182

## Question

Does Mathlib have `IsRegularLocalRing R → IsDomain R` (Stacks 00NQ)?
This is the load-bearing gap in
`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:435
exists_isRegular_of_regularLocal` (iter-181 Lane G substantive helper
sorry); without it (or an equivalent route) `CohenMacaulay.of_regular`
cannot have a kernel-clean body.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Does Mathlib expose `IsRegularLocalRing → IsDomain` directly? | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. Cheapest route among (a) direct 00NQ / (b) regular-quotient induction / (c) Serre's regularity | NEEDS_MATHLIB_GAP_FILL — (a)=(b) ≈ 300 LOC multi-iter; (c) infeasible | informational |
| 3. Alternative regular-sequence construction bypassing `IsDomain` | NO_USEFUL_ALTERNATIVE | informational |

## Informational

**Decision 1 — Mathlib status.** Mathlib's entire regular-local-ring API
at the pinned commit lives in **one** file:
`.lake/packages/mathlib/Mathlib/RingTheory/RegularLocalRing/Defs.lean`
(≈78 LOC). It declares `IsRegularLocalRing` (extends `IsLocalRing +
IsNoetherianRing` + `spanFinrank_maximalIdeal = ringKrullDim`), provides
the cotangent-space iff, and exposes a **single converse-direction
instance** `IsLocalRing + IsDomain + IsPrincipalIdealRing →
IsRegularLocalRing`. There is **no** declaration concluding `IsDomain R`
from `IsRegularLocalRing R`. Verified by (i) reading the file end-to-end,
(ii) `lean_loogle "IsRegularLocalRing, IsDomain"` returning only the
converse, (iii) `grep -rln "IsRegularLocalRing" Mathlib` returning the
single Defs file.

**Decision 2 — route cost.** All three candidate routes were assessed.
- Route (a) "direct via minimal primes + Krull intersection" and Route
  (b) "regular-quotient induction" are not two routes but two halves
  of the same Stacks 00NQ proof — a joint induction on `spanFinrank`
  proving both the `IsDomain` implication and the regular-sequence
  existence simultaneously.
- Mathlib supplies **most** sub-lemmas at the pinned commit:
  `Ideal.finite_minimalPrimes_of_isNoetherianRing`,
  `Ideal.subset_union_prime` (prime avoidance),
  `Ideal.iInf_pow_eq_bot_of_isLocalRing` (Krull intersection),
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim_of_mem_nonZeroDivisors`,
  `Module.supportDim_quotSMulTop_succ_eq_of_notMem_minimalPrimes_of_mem_maximalIdeal`,
  `Ideal.height_le_one_of_isPrincipal_of_mem_minimalPrimes`,
  `biUnion_associatedPrimes_eq_compl_nonZeroDivisors`,
  `RingTheory.Sequence.IsRegular.cons`,
  `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`.
  Total assembly estimate: **≈ 300 LOC, multi-iter**.
- The one **non-routine sub-helper** is the cotangent-space dim drop:
  for `x ∈ 𝔪 \ 𝔪²`, `finrank κ (CotangentSpace (R/(x))) = finrank κ
  (CotangentSpace R) - 1`. Mathlib has only qualitative `≤ 1` /
  `= 0` forms. Estimate ≈ 80 LOC standalone.
- Route (c) via Serre's regularity (`pd_R(κ) = d`) requires
  Koszul-complex-is-projective-resolution-of-κ, which is NOT in Mathlib
  at this commit and is itself harder than 00NQ. **Out of scope.**

**Decision 3 — alternative bypass.** An attempt to construct
`exists_isRegular_of_regularLocal` *without* first proving `IsDomain`
fails at step 1 of the induction: the first regular-sequence element
must lie in `𝔪 \ ⋃ Ass(R)` (since
`biUnion_associatedPrimes_eq_compl_nonZeroDivisors` says the
non-zero-divisors are exactly the complement of the associated-prime
union). Height bounds rule out *minimal* primes, but **embedded primes**
(elements of `Ass(R) \ minimalPrimes(R)`) can have any height up to `d`
and cannot be avoided a priori. The standard "regular local has no
embedded primes" fact is itself downstream of `IsDomain`. Hence the
detour is unavoidable.

## Recommendation

Three actionable options for iter-182 (see
`analogies/isregularlocalring-isdomain.md` for details):

1. **(Recommended for iter-182) Pivot Lane G prover** to one of the
   two off-target depth lemmas in the same file:
   `depth_eq_smallest_ext_index` (L228, Stacks 00LP) or
   `depth_of_short_exact` (L268, Stacks 00LE). Both are substantive,
   self-contained, and not gated on the `IsDomain` chain. They feed
   downstream depth infrastructure regardless.

2. **Multi-iter project-side 00NQ build**, split into:
   - *Sub-lane* G1 (≈ 80 LOC): cotangent-space dim drop standalone.
   - *Sub-lane* G2 (≈ 200 LOC): joint induction delivering both
     `IsRegularLocalRing → IsDomain` and
     `exists_isRegular_of_regularLocal`.
   Estimated 2–3 iters with helper budget ≤ 2 per iter. Schedule as a
   new STRATEGY row for iter-184+ once off-target depth lemmas land.

3. **Mathlib upstream PR** (parallel side-action by the mathematician
   outside the loop): submit `IsRegularLocalRing.toIsDomain` to
   `Mathlib.RingTheory.RegularLocalRing.Defs`. Multi-week wait; right
   long-term move; doesn't unblock the current iter.

Concrete recommendation: **execute Option 1 this iter** (pivot Lane G
to `depth_eq_smallest_ext_index`), **queue Option 2** as a new STRATEGY
row, and **flag Option 3** as a candidate user-side action in
`TO_USER.md`.

## Persistent file
- `analogies/isregularlocalring-isdomain.md` — full design rationale and
  per-sub-lemma Mathlib citation table captured for future iters.

Overall verdict: `IsRegularLocalRing → IsDomain` is genuinely absent at
pinned commit `b80f227`; the gap is upstream Mathlib content, ≈ 300 LOC
to close project-side via Stacks 00NQ (one non-routine sub-helper plus
assembly), and no cheaper route bypassing `IsDomain` exists — pivot Lane
G this iter while the 00NQ sub-project is scheduled.
