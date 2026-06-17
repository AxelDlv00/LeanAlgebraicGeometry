# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
coe-stacks00sw

## Iteration
201

## Structural problem

Construct `RingTheory.Sequence.IsRegular A (f_j)_{j ∈ σ}` for the relations
`(f_j)` of an `Algebra.SubmersivePresentation R (R[x_1,…,x_n] / (f_j))` at
the localisation `A = (R[x])_{m'}` at a maximal ideal `m'` lifting through
the presentation. The Jacobian-invertibility hypothesis (the project's
`Algebra.SubmersivePresentation.jacobian_isUnit`) provides a *cotangent-side*
linear-independence statement (`Algebra.SubmersivePresentation.basisCotangent`);
the goal is to convert that to a *regular-sequence-side* statement on the
local ring at the closed point. This is Step 3 of the iter-201 Lane COE
closure path for `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth`
(line 1061 of `CodimOneExtension.lean`).

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem` (`Mathlib.RingTheory.Regular.Flat:65`) | commutative algebra / localisation | none (direct invocation) | ANALOGUE_FOUND |
| `Algebra.SubmersivePresentation.basisCotangent` + `cotangentEquiv` (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent:127,143`) | smooth-algebra cotangent | medium | ANALOGUE_FOUND |
| `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal` (`Mathlib.RingTheory.Regular.RegularSequence:510`) | local-ring regular-sequence theory | none (direct invocation) | ANALOGUE_FOUND |
| `LinearIndependent.of_isLocalizedModule_of_isRegular` (`Mathlib.RingTheory.Localization.Module`) | linear algebra / localisation | low | ANALOGUE_FOUND |
| `Mathlib.Analysis.Calculus.ImplicitFunction` | differential geometry / Banach analysis | high (technique not portable) | PARTIAL_ANALOGUE |
| `Mathlib.RingTheory.Henselian.IsHenselian.exists_unique_lift` | non-archimedean / Hensel | high (requires m-adic completion detour) | PARTIAL_ANALOGUE |

## Top suggestion

Build a **project-side Matsumura helper**
`matsumura_isRegular_of_linearIndependent_cotangent` (~30–50 LOC) capturing
the classical "in a regular local ring `(A, m)` of Krull dim `n`, a sequence
`f₁,…,f_c ∈ m` whose images in `m/m²` are `κ`-linearly independent forms a
`RingTheory.Sequence.IsRegular A [f₁,…,f_c]`" theorem (Matsumura "Commutative
Ring Theory" Thm 14.2 / Stacks `00NQ`).

Proof structure: induction on `c`, dim-drops-by-one via the existing Mathlib
substrate `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` (in
`Mathlib.RingTheory.KrullDimension.Regular`), `IsSMulRegular` on the
non-zero-divisor `f_1` via `IsRegularLocalRing ⇒ IsDomain` + `f_1 ≠ 0` (which
follows from `f_1 ∉ m²` ⇒ `f_1 ∉ {0}`), then `isRegular_cons_iff` to descend.
The key Mathlib hooks already exist: `IsRegularLocalRing.iff_finrank_cotangentSpace`,
`ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`, and
`IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`.

Then compose with two transport helpers (~30–40 LOC):

1. `submersivePresentation_relations_linearIndependent_cotangent_localization`
   (~20 LOC) — transport `Algebra.SubmersivePresentation.basisCotangent`'s
   linear-independence statement from `I/I²` over `S` to `m_A/m_A²` over `κ(m_A)`
   on the localisation `A = P.Ring_{m'}`. Uses Analogue D (`LinearIndependent.of_isLocalizedModule_of_isRegular`)
   for the localisation step + a small conormal-localisation identification
   (`(I/I²) ⊗_S Sₘ ≃ (I·A)/(I·A)²` which Mathlib provides via the cotangent
   tensor-product API).

2. `submersivePresentation_relations_isRegular_localization` (~10–15 LOC) —
   invoke the Matsumura helper with the lin-indep premise from (1), then
   apply Analogue A (`isRegular_of_isLocalizedModule_of_mem`) to land the
   final IsRegular in the form needed by
   `ringKrullDim_quotient_add_eq_of_regular_sequence` at L807.

**Refined target signature** (replacing the directive's draft):

```lean
private theorem Algebra.SubmersivePresentation.relations_isRegular_in_localization
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S] [Nontrivial S]
    [IsNoetherianRing R] {ι σ : Type*} [Finite σ] [Finite ι]
    (P : Algebra.SubmersivePresentation R S ι σ)
    (m : Ideal P.Ring) [m.IsMaximal]
    (hmem : ∀ j, P.relation j ∈ m)
    (A : Type*) [CommRing A] [Algebra P.Ring A] [IsLocalization.AtPrime A m]
    -- A inherits IsLocalRing, IsNoetherianRing, IsRegularLocalRing automatically:
    -- IsLocalRing via IsLocalization.AtPrime.isLocalRing
    -- IsNoetherianRing via IsLocalization.isNoetherianRing
    -- IsRegularLocalRing via the iter-200 substrate + dim = #ι chain
    :
    RingTheory.Sequence.IsRegular A
      ((List.ofFn (n := Fintype.card σ)
         (fun i => (algebraMap P.Ring A) (P.relation ((Fintype.equivFin σ).symm i)))))
```

The two natural choices for the witness's index list — `List.ofFn (P.relation ∘ e)`
for a chosen `e : Fin (Fintype.card σ) ≃ σ`, or `Finset.univ.toList.map P.relation`
— are interchangeable by `IsLocalRing.isRegular_of_perm`; the iter-200
consumer (`ringKrullDim_quotient_add_eq_of_regular_sequence`) only uses
`rs.length = Fintype.card σ`, which holds for both choices.

**Cost estimate refinement.** The directive's 30–60 LOC estimate stands —
30–50 LOC for the Matsumura helper, 20–30 LOC for the cotangent-localisation
transport, 10–15 LOC for the assembly. Total ~60–95 LOC, modestly above
the directive's upper bound but still well within the iter-201 budget.
The slight inflation is the cost of building Stacks 00NQ as a clean named
helper rather than inlining it via `isRegular_cons_iff` chains; the
trade-off favours the named helper because it's a candidate for an
upstream Mathlib PR and because it makes the closure of L1061 a clean
~5-line invocation.

**First Mathlib files to read for technique**:
- `Mathlib.RingTheory.KrullDimension.Regular:208`
  (`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`) — the dim-of-quotient
  arithmetic; informs the induction structure of the Matsumura helper.
- `Mathlib.RingTheory.Regular.Flat:65–73`
  (`IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem`) — the closing
  bridge for Step 3, reduces "build IsRegular on `A`" to "build
  IsWeaklyRegular on `P.Ring`".
- `Mathlib.RingTheory.Smooth.StandardSmoothCotangent:116–144`
  (`cotangentEquiv` and `basisCotangent`) — the cotangent-side substrate
  feeding the lin-indep premise.

**First project file to touch**:
`AlgebraicJacobian/Albanese/CodimOneExtension.lean` around line 815,
between the existing `ringKrullDim_quotient_add_eq_of_regular_sequence`
substrate (L807) and the `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
substrate (L834). Add the three named helpers above, then close the L1061
`sorry` in `isRegularLocalRing_stalk_of_smooth`.

## Discarded

- **Mathlib Koszul-complex API**: explicitly listed as a TODO in
  `Mathlib.RingTheory.Regular.RegularSequence:21`; no substrate to port.
- **`Module.exists_basis_of_span_of_maximalIdeal_rTensor_injective`**
  (`Mathlib.RingTheory.LocalRing.Module`): constructs a basis from
  Tor-vanishing, not a regular sequence; wrong direction.
- **`Mathlib.Analysis.Calculus.ImplicitFunction`**: structural mirror of the
  problem in differential geometry, but the contraction-mapping technique
  does not port to formal-power-series / m-adic settings inside Lean
  without a major detour.
- **`Mathlib.RingTheory.Henselian.IsHenselian`**: same structural shape
  via Newton iteration in m-adic topology, but applying it would require
  completing `A` to `Â` first, then descending — a strictly longer route
  than the Matsumura helper.
- **Étale-descent regular sequences**: no Mathlib substrate.
- **`Mathlib.RingTheory.RegularLocalRing.Defs` + `spanFinrank`-direct
  reasoning**: the `IsRegularLocalRing` definition is `spanFinrank
  maximalIdeal = ringKrullDim`, downstream of "having a regular sequence
  of length = dim", not a source of one.

## Persistent file
- `analogies/coe-stacks00sw.md` — full analogue list, mapping, and the
  Matsumura-helper porting plan captured for future iters.

Overall verdict: four direct Mathlib analogues land the closure in ~60–95
LOC via a project-side Matsumura `lin-indep cotangent ⇒ regular sequence`
helper; the helper is the substantive piece, and the existing Mathlib
substrate (regular-local-ring API + `IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem`
+ `basisCotangent`) discharges every other ingredient.
