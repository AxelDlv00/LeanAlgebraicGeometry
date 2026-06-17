# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
coe-stacks00oe

## Iteration
200

## Structural problem

Prove `ringKrullDim (S_m) = n` for `S` a smooth `R`-algebra of
relative dimension `n` over a field `R = k̄`, at any maximal ideal
`m ⊂ S`. This is **Stacks 00OE** (Lane COE Stage 6 sub-gap (ii.B)),
the only residual sorry on `isRegularLocalRing_stalk_of_smooth`
(`AlgebraicJacobian/Albanese/CodimOneExtension.lean:751`) after the
iter-199 cotangent-iso (ii.A) closure.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Polynomial.height_eq_height_add_one` (`Mathlib.RingTheory.KrullDimension.Polynomial`) | Comm-alg / poly-ring Krull-dim | low | ANALOGUE_FOUND |
| `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` (`Mathlib.RingTheory.KrullDimension.Regular`) | Comm-alg / regular sequences | medium | ANALOGUE_FOUND (top) |
| `Ideal.height_eq_height_add_of_liesOver_of_hasGoingDown` (`Mathlib.RingTheory.Ideal.KrullsHeightTheorem`) | Comm-alg / going-down | low | PARTIAL_ANALOGUE |
| `IsLocalization.AtPrime.ringKrullDim_eq_height` (`Mathlib.RingTheory.Ideal.Height`) | Comm-alg / loc. dimension | trivial | ANALOGUE_FOUND (adapter) |
| `MvPolynomial.ringKrullDim_of_isNoetherianRing` (`Mathlib.RingTheory.KrullDimension.Polynomial`) | Comm-alg / poly Krull-dim | trivial | PARTIAL_ANALOGUE (upper bound only) |
| `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`) | Comm-alg / Kähler differentials | zero | NO_USEFUL_ANALOGUE (cotangent side, not Krull side) |

**No single-lemma Mathlib analogue exists** for Stacks 00OE. The
search returned zero Loogle hits for
`(Algebra.IsStandardSmoothOfRelativeDimension, ringKrullDim)` and
`(Algebra.IsStandardSmoothOfRelativeDimension, Ideal.height)`,
confirming the directive's premise: Mathlib has every building
block but does not package the result. The project's task is
**chaining**, not building new infrastructure.

## Top suggestion

Compose Analogues 4 + 1 + 2 as a single project-side helper
`smoothAlgebra_relativeDim_ringKrullDim_localization` that
`isRegularLocalRing_stalk_of_smooth` consumes by one `rw`. The
3-step recipe:

**Step 1 — recast Krull-dim as height (Analogue 4)**:
`rw [IsLocalization.AtPrime.ringKrullDim_eq_height]` on the goal,
reducing `ringKrullDim S_m = n` to `m.height = n`.

**Step 2 — polynomial-ring height (Analogue 1)**: iterate
`Polynomial.height_eq_height_add_one` `#ι` times over the base
field `k` (with `(0 : Ideal k).height = 0` by
`ringKrullDim_eq_zero_of_field`) to obtain `m'.height = #ι` for
the preimage `m'` in `MvPolynomial ι k`. ≤ 30 LOC packaged helper.

**Step 3 — drop by regular-sequence length (Analogue 2)**: apply
`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` in
`R'_{m'}` with the relations `(f_j)_{j ∈ σ}` of the
SubmersivePresentation, giving
`ringKrullDim S_m + #σ = ringKrullDim R'_{m'} = #ι`. Solve for
`n = #ι − #σ`.

The **substantive residual obligation** is constructing the
regular-sequence witness `RingTheory.Sequence.IsRegular R'_{m'}
(f_j)_{j ∈ σ}` in Step 3. This is Stacks 00SW / 00OW (the
algebraic content of "Jacobian invertible ⟹ relations Koszul-
regular at the closed point") and is not in Mathlib at commit
`b80f227`. Project-side build estimate: 30–60 LOC against
`Algebra.SubmersivePresentation.jacobian_isUnit` +
`RingTheory.Sequence.isRegular_cons_iff` +
`IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`.

**Total iter-201+ build estimate**: 80–120 LOC, below the
directive's pessimistic 200–300 LOC ceiling because the iter-198
SubmersivePresentation extraction has already paid the
Noether-normalization-equivalent cost.

**First file to touch**:
`AlgebraicJacobian/Albanese/CodimOneExtension.lean` around the
"Sub-gap (ii.B)" comment block at L836, or factor into a new
`AlgebraicJacobian/Albanese/SmoothKrullDim.lean` (recommended for
isolation) exporting a single
`ringKrullDim_localization_of_isStandardSmoothOfRelativeDimension`
helper.

## Fallback route

If the regular-sequence step proves harder than 60 LOC (the
SubmersivePresentation's relations live in `MvPolynomial ι R`, not
in the localization `R'_{m'}`, so a base-change argument is needed),
use the **upper-bound-via-spanFinrank shortcut**:
- Upper bound: `ringKrullDim S_m ≤ ringKrullDim (S_m/m) + spanFinrank m =
  0 + n` via `ringKrullDim_le_ringKrullDim_add_spanFinrank` and the
  iter-199 (ii.A) cotangent finrank `= n` result.
- Lower bound: descent from the smooth ⟹ flat map `k → S_m` via
  going-down (Analogue 3) and the polynomial-ring chain of primes.

This fallback reuses (ii.A) directly but is conceptually messier
than the regular-sequence route.

## Discarded

- **Noether normalization + going-up** (`exists_finite_inj_algHom_of_fg` +
  `instHasGoingDownOfIsDomainOfFaithfulSMulOfIsIntegralOfIsIntegrallyClosed`):
  feasible but strictly harder than the SubmersivePresentation route,
  which already encodes the explicit `#generators − #relations` arithmetic.
- **`Module.supportDim`** API: same content via different packaging,
  no new technique.
- **`Algebra.trdeg` route**: Mathlib lacks the "trdeg = Krull dim for
  finite-type k-algebra integral domains" general lemma at commit
  `b80f227`; building it would itself require Stacks-00OE-shape reasoning.
- **`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`**:
  already used by iter-198 for the (i) sub-gap; gives cotangent rank,
  not Krull dim. Distinct invariant.

## Persistent file
- `analogies/coe-stacks00oe.md` — full analogue list and detailed
  3-step recipe captured for iter-201+ Lane COE prover.

Overall verdict: Stacks 00OE has no single-lemma Mathlib analogue,
but a directly portable 3-step chain (Analogues 4+1+2) closes
(ii.B) in ≈ 80–120 LOC project-side, with the only substantive
residual being a regular-sequence-from-Jacobian helper.
