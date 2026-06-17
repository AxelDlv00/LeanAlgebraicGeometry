# mathlib-analogist directive — slug `coe-stacks00sw`

## Mode: cross-domain-inspiration

## Structural problem

Construct `RingTheory.Sequence.IsRegular R'_{m'} (f_j)_{j ∈ σ}` for the
relations `(f_j)_{j ∈ σ}` of an `Algebra.SubmersivePresentation
A_R R[x_1, …, x_n] / (f_j)_{j ∈ σ}` at the localisation `R'_{m'}` at
a maximal ideal `m'` lifting through the presentation. Mathematically:
the relations of a submersive (= standard-smooth) presentation form a
Koszul-regular sequence at any closed point of the local ring because
the Jacobian matrix is invertible modulo the maximal ideal (Stacks
00SW / 00OW).

The substantive iter-201 Lane COE main effort is closing the body of
`AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth` at L1061
in `CodimOneExtension.lean`. The closure path:

1. Extract an explicit
   `Algebra.SubmersivePresentation k Γ(X.left, V)` from
   `Algebra.IsStandardSmoothOfRelativeDimension` (Stage 6 sub-gap (i)
   substrate, iter-198 axiom-clean).
2. Identify the maximal ideal `m` of `Γ(X.left, V)` corresponding to
   the point `z`.
3. Build `RingTheory.Sequence.IsRegular Γ(X.left, V)_{m} (f_j)_{j ∈ σ}`
   from `SubmersivePresentation.jacobian_isUnit` + `isRegular_cons_iff` +
   `isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal` (this is the
   substantive iter-201 piece).
4. Apply the iter-200 axiom-clean substrate
   `ringKrullDim_quotient_add_eq_of_regular_sequence` + capstone
   `ringKrullDim_localization_atMaximal_MvPolynomial` to derive
   `ringKrullDim Γ(X.left, V)_{m} = n` (the relative dimension).
5. Conclude `IsRegularLocalRing (X.left.presheaf.stalk z)` via the
   Krull-dim-equals-cotangent-finrank criterion (`IsRegularLocalRing.iff_finrank_cotangentSpace`)
   + the iter-199 Stage 6.B substrate (closed-point cotangent ↔ Kähler iso).

## Failed approaches

- **Build Stacks 00OE the packaged form**
  `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`
  directly: iter-198 estimate was ~200-300 LOC; iter-200 reduced to ~80-120 LOC
  via the 3-step composition (Steps 1+2 landed). Step 3 is the remaining
  ~30-60 LOC residual substrate per iter-200 prover handoff.
- **Build the witness in `MvPolynomial` then transport via
  `RingEquiv`**: the project's iter-200 helpers already do this on the
  Krull-dim side (`MvPolynomial.maximalIdeal_height_eq_card` then
  `…_eq_natCard` via `renameEquiv`). However the regular-sequence
  side has no Mathlib analogue ready for the natural index-set
  transport; the direct route via the `SubmersivePresentation`'s
  built-in `Algebra.SubmersivePresentation.relation` data structure
  (Mathlib `Mathlib/RingTheory/Smooth/StandardSmooth.lean`) is cleaner.

## Search radius

`wide` — any Mathlib domain. Specifically:

- **Algebraic-geometry / commutative-algebra precedents**: Mathlib's
  `RingTheory.Sequence.IsRegular` API for any analogous "Koszul-regular
  sequence from a Jacobian-invertibility hypothesis" construction. The
  Koszul-complex / regular-sequence theory in
  `Mathlib/RingTheory/Sequence.lean` +
  `Mathlib/RingTheory/Koszul.lean` + the smooth-morphism API at
  `Mathlib/RingTheory/Smooth/StandardSmooth.lean`.
- **Local-ring precedents**: Mathlib's
  `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
  is the bridge between the global regular-sequence definition and the
  local "weakly regular in the maximal ideal" version. Find any
  precedent that constructs a regular sequence from a unit-Jacobian
  hypothesis using this bridge.
- **Cross-domain shapes that might inform**: descent of regular sequences
  across localisation; Koszul-complex acyclicity from a free
  presentation; the "Jacobian criterion for smoothness ⇒ regularity"
  shape that appears in geometry (Stacks 00TT / 00OE chain) and in
  the analytic setting (real-analytic / complex-analytic smooth
  ⇒ regular).

## What I expect back

Ranked list of structural analogues — each with:
- Mathlib citation (file path + declaration name when possible).
- The technique used there (in plain language).
- A concrete suggestion for how to port it to the project's
  `Algebra.SubmersivePresentation.relations_isRegular_in_localization`
  construction.

A target deliverable signature for the project to build:

```lean
lemma Algebra.SubmersivePresentation.relations_isRegular_in_localization
    {k S : Type*} [CommRing k] [CommRing S] [Algebra k S]
    (P : Algebra.SubmersivePresentation k S)
    (m : Ideal S) [m.IsMaximal] [SomeJacobianHypothesis P m]
    (Sm : Type*) [CommRing Sm] [Algebra S Sm] [IsLocalization.AtPrime Sm m] :
    RingTheory.Sequence.IsRegular Sm (P.relations) := …
```

(or similar — refine the signature as the analogist sees fit).

Estimate cost: ~30-60 LOC per the iter-200 prover handoff. Verify or
refine.

## Output

`task_results/mathlib-analogist-coe-stacks00sw.md` + persistent
`analogies/coe-stacks00sw.md`.
