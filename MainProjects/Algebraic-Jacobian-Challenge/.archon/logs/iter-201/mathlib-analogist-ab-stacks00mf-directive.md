# mathlib-analogist directive — slug `ab-stacks00mf`

## Mode: cross-domain-inspiration

## Structural problem

Close the body of `RingTheory.auslander_buchsbaum_formula_succ_pd` (in
`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`, line ~1517,
currently sorry at L1574) without building Stacks 00MF
(`pd M > 0 ⟹ depth M < depth R`, Buchsbaum-Eisenbud "what is exact"
criterion) as a project-side substrate first.

The iter-200 ALIGN_WITH_MATHLIB pivot via
`CategoryTheory.HasProjectiveDimensionLT` SES descent landed 4
axiom-clean helpers
(`hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`,
`hasProjectiveDimensionLT_ker_of_surjection`,
`hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`,
`depth_ker_ge_min_of_surjection_finite_localRing`). The
SES `0 → ker f → R^n → M → 0` from
`exists_minimalSurjection_finite_localRing` (iter-199, also
axiom-clean) plus the iter-200 helpers gives
`pd_R (ker f) = k` exactly when `pd_R M = k+1` exactly. The
depth side gives
`min(depth R, depth M + 1) ≤ depth (ker f)`. To finish, we need
`depth (ker f) = depth M + 1` (the matching upper bound), which
reduces by ℕ∞ arithmetic to `depth M + 1 ≤ depth R`, i.e.
`depth M < depth R` — which is Stacks 00MF for `pd M > 0`.

**Path A** (iter-200 prover handoff): build Stacks 00MF as
substrate (~150-200 LOC project-side; Mathlib upstream PR candidate).
The blueprint chapter has a proof recipe for the
Buchsbaum-Eisenbud criterion (added iter-201). This is feasible
but expensive.

**Path B** (LES-injectivity alternative): close
`depth (ker f) ≤ depth M + 1` directly via an Ext connecting-map
injectivity argument on the SES, without needing the
`pd > 0 ⟹ depth M < depth R` input as an external premise. The
hypothesis would be: the SES at `0 → ker f → R^n → M → 0` plus the
already-existing depth chain helpers should give the needed bound
through the LES of `Ext^*(κ, -)` directly. Mathlib should have
analogous LES-injectivity arguments in cohomological contexts (for
group cohomology, sheaf cohomology, or for `Ext` in any abelian
category).

## Failed approaches

- **Build the full minimal free resolution as a `ChainComplex ℕ`**:
  rejected by the iter-200 `ab-natrecursive` analogist as 3-4× over
  budget AND gated on a Mathlib-absent termination-of-syzygy-tower
  lemma.
- **Stacks 090V classical induction on depth(M)**: directive
  explicitly pivots away (iter-200) toward Path A.
- **The direct AB formula proof in Mathlib's library**: Mathlib does
  not ship `auslander_buchsbaum_formula` axiom-clean for general
  Noetherian local rings; the project is contributing this.

## Search radius

`wide` — any Mathlib domain. Specifically:

- **LES-injectivity precedents in Mathlib's cohomology library**:
  for any abelian category `C`, any SES `0 → A → B → C → 0`, and any
  functor `F : C → AbelianCategory` with derived functors, the LES
  gives boundary connecting maps `δⁱ : F^i C → F^(i+1) A`. The
  precondition for injectivity of `δⁱ` (equivalently, the
  preceding map `F^i B → F^i C` is the zero map) is a recurring
  pattern across cohomology theories.
- **Specific Ext / Tor injectivity**: Mathlib's
  `CategoryTheory.Abelian.Ext` and `Tor` infrastructure. Is there a
  precedent for an injectivity argument like "if `Hom(κ, A) → Hom(κ, B)`
  is the zero map at the start of the LES, then
  `Ext^1(κ, A) ≤ Ext^1(κ, B)`"?
- **Group cohomology / sheaf cohomology analogues**: the same LES-
  injectivity shape appears in `Mathlib/Topology/Sheaves/`,
  `Mathlib/RepresentationTheory/GroupCohomology/`, and possibly in
  `Mathlib/CategoryTheory/Limits/` for derived-functor LES.
- **Cohen-Macaulay-style depth tracking**: Mathlib's
  `Mathlib/RingTheory/CohenMacaulay.lean` (if it exists at b80f227)
  or the project's own `RingTheory.CohenMacaulay` substrate may
  contain or hint at a depth-comparison argument across SES that
  obviates the Buchsbaum-Eisenbud criterion.

## What I expect back

Per descriptor cross-domain-inspiration mode: a ranked list of
structural analogues, each with Mathlib citation + technique + port
suggestion. Specifically:

1. **Verdict: Path A or Path B?** If Path B is feasible, name 2-3
   concrete Mathlib analogues + a sketch of the LES-injectivity
   argument that sidesteps 00MF. If Path B is infeasible, confirm
   Path A (Stacks 00MF substrate ~150-200 LOC) as the binding gap.
2. **If Path B**: rough estimate of project-side LOC for the
   injectivity argument; named Mathlib hooks (`Ext_succ_of_…`,
   `ShortComplex.ShortExact.exact_…`, the corresponding `δ`-functor
   injectivity instance, etc.).
3. **If Path A**: 2-3 highest-leverage Mathlib precedents for the
   `r`-minor ideal + depth chain that suggests an efficient project-side
   build.

## Output

`task_results/mathlib-analogist-ab-stacks00mf.md` + persistent
`analogies/ab-stacks00mf.md`.
