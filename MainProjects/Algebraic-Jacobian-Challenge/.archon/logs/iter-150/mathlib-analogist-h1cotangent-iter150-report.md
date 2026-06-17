# Mathlib Analogist Report

## Mode

cross-domain-inspiration

## Slug

h1cotangent-vanishing-iter150

## Iteration

150

## Structural problem

The project needs to prove (or sidestep) the structural-equation cohomology
statement `Γ(X, O_X) ≅ k` for a smooth proper geometrically irreducible
scheme `X / k`. The downstream consumer is `rigidity_over_kbar` in
`AlgebraicJacobian/RigidityKbar.lean`, which chains:
`rigidity_over_kbar → Scheme.Over.ext_of_diff_zero →
df_zero_factors_through_constant_on_chart →
KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero →
constants_integral_over_base_field`. The iter-149 commitment to path (b)
decomposes `Γ ≅ k` into four (S3.*) sub-claims; iter-149 status is 0/4
closed and the load-bearing (S3.pi.1) flat base change of Γ remains a
Mathlib gap. The directive asks for cross-domain analogues that could let
the chain consume `Subsingleton (Algebra.H1Cotangent k B)` directly, or
otherwise restructure the closure path.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `IsAlgClosed.algebraMap_bijective_of_isIntegral` (consumer reformulation over `\bar k`) | field theory (alg closed) | low (~15–20 LOC) | ANALOGUE_FOUND |
| `Algebra.IsAlgebraic.isSeparable_of_perfectField` + `PerfectField.ofCharZero` (CharZero collapse of (S3.sep.*)) | field theory (perfect) | low (~15 LOC) | ANALOGUE_FOUND |
| `MvPolynomial.mkDerivation` + `pderiv` (KDM (BR.5) joint-kernel via MvPolynomial monomial expansion) | commutative algebra | medium (~60–80 LOC) | ANALOGUE_FOUND |
| `Algebra.FormallySmooth.of_perfectField` (chart-side FormallySmooth-for-free) | ring theory | zero (already fires) | PARTIAL_ANALOGUE |
| `Algebra.FormallySmooth.subsingleton_h1Cotangent` (H1Cotangent-vanishing pivot) | ring theory (André-Quillen) | — | NO_USEFUL_ANALOGUE |

## Top suggestion

**Hybrid pivot — consumer reformulation over `\bar k` + CharZero collapse
of (S3.sep.*) + MvPolynomial-pderiv closure of KDM (BR.5).** Concretely,
introduce a new specialisation
`constants_integral_over_base_field_of_isAlgClosed` in
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (between L246 and the
`Scheme.Over.ext_of_diff_zero` block at L492), whose body closes in ~15 LOC
via `IsAlgClosed.algebraMap_bijective_of_isIntegral`
(`Mathlib.FieldTheory.IsAlgClosed.Basic`) applied to the iter-148–149
`_hAppTopFinite` + `_hΓfield'` scaffold. Rewire
`df_zero_factors_through_constant_on_chart` (L222–240) to consume this
specialisation under the chart-algebra envelope's already-CharZero
hypothesis (`[CharZero k]` at L223), and rewire the consumer site in
`rigidity_over_kbar` to substitute `kbar` for `k` (already
algebraically closed by `[Field kbar]` ambient). The four (S3.*)
sub-claims become dead code for the M2.a critical path and can be
deferred indefinitely as Mathlib-PR work for the general-`k` formulation.
Parallel-track the KDM (BR.5) joint-kernel collapse via
`MvPolynomial.pderiv` + monomial expansion (~60–80 LOC), which closes
the chart-algebra residual under iter-149's `[CharZero k]` +
`[Algebra.IsStandardSmoothOfRelativeDimension n k B]` hypotheses without
requiring the directive's "induct over the standard-smooth presentation"
roadmap.

**Estimated net LOC for M2.a critical-path closure under the hybrid**:
~120–170 LOC (vs ~310–550 LOC for iter-149 path (b) full (S3.*)).
**Saving**: ~50–60%.

**First file to touch**: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.

## Discarded

- **H1Cotangent-vanishing pivot for `rigidity_over_kbar`**
  (`Algebra.FormallySmooth.subsingleton_h1Cotangent`,
  `Mathlib.RingTheory.Smooth.Basic`): mathematically incoherent.
  `Subsingleton (Algebra.H1Cotangent k B)` is André-Quillen H¹ vanishing
  (about lifting square-zero extensions), independent content from
  zeroth structure-sheaf cohomology `Γ ≅ k`. Naming collision between
  the project's "cotangent-vanishing pile" and Mathlib's `H1Cotangent`
  typeclass; the two pivots solve different problems.
- **Hopf-algebra augmentation-ideal-equals-primitives angle**
  (`HopfAlgebra.counit` in `Mathlib.RingTheory.HopfAlgebra.Basic`):
  superficial structural similarity but the project's `B` is not a
  Hopf algebra, and Mathlib's Hopf algebra API has no scheme-side
  bridge to chart-algebras of schemes.
- **Locally constant / preconnected functions over compact Hausdorff
  space** (`IsLocallyConstant.apply_eq_of_preconnectedSpace`,
  `Mathlib.Topology.LocallyConstant.Basic`): topological analogue is
  shape-correct (connected ⇒ constant) but the scheme-level analogue
  requires the cohomological proper-base-change machinery that the
  project is trying to avoid. No portable technique.

## Persistent file

- `analogies/h1cotangent-vanishing-iter150.md` — full analogue list with
  citations, technique extraction, and porting cost analysis.

Overall verdict: hybrid pivot (consumer reformulation over `\bar k` +
CharZero collapse of (S3.sep.*) + MvPolynomial-pderiv KDM (BR.5)) is
the recommended iter-150 commitment; the H1Cotangent-direct-consumption
pivot proposed by the directive is mathematically incoherent and
discarded.
