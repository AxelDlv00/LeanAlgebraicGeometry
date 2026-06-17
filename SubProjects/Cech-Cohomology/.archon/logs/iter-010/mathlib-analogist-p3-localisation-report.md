# Mathlib Analogist Report

## Mode
api-alignment

## Slug
p3-localisation

## Iteration
010

## Question

How should the project represent and prove **P3** — the positive-degree exactness of the
standard-cover Čech complex of an affine scheme — given that it must be built essentially
from scratch for `Scheme.Modules`? (a) The right Lean encoding of "a standard affine open
cover of `Spec A`": bespoke `(f : Fin n → A) + hspan` structure / predicate on an
`OpenCover` / Mathlib affine-cover API. (b) The complex-and-exactness representation:
(1) does Mathlib already have a Čech-of-localizations exactness for a covering family
(`Algebra.lemma-cover-module`)? (2) the idiomatic "exact after localizing at every prime"
certifier? (3) is the contracting homotopy best done via `Homotopy`/`HomotopyEquiv` on a
`CochainComplex`, or via an augmented simplicial object Mathlib already knows is exact?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (a) cover-type encoding | ALIGN_WITH_MATHLIB | major (not yet shipped) |
| (b1) algebra Čech-of-localizations exactness | NEEDS_MATHLIB_GAP_FILL | informational |
| (b2) local-to-global exactness certifier | ALIGN_WITH_MATHLIB | major (not yet shipped) |
| (b3) contracting-homotopy idiom | NEEDS_MATHLIB_GAP_FILL (partial) | informational |

No ALIGN verdict lands on *shipped* divergent code — the P3 proof is still an open
`sorry` and the cover narrowing has not yet been written — so there is no
must-fix-this-iter item; both ALIGNs are adopt-the-idiom-now (Major) directives for the
upcoming build.

## Major

These are the two idioms the `mathlib-build` prover should adopt directly rather than
reinvent.

- **(a) Cover-type — use `affineOpenCoverOfSpanRangeEqTop`.** Narrow `CechAcyclic.affine`
  (`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:764`, NOT protected) to carry
  the spanning-family data `(s : ι → A, hs : Ideal.span (Set.range s) = ⊤)` and build the
  cover via
  `AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop s hs |>.openCover`
  (`Mathlib.AlgebraicGeometry.Cover.Open`). The defining equation
  `affineOpenCoverOfSpanRangeEqTop_f : (…).f i = Spec.map (algebraMap R (Localization.Away (s i)))`
  hands you the `D(f_i)`-with-sections `M_{f_i}` description for free. **Decisive reason
  not to use a bespoke `Fin n` structure or an `OpenCover`-predicate**: the identical
  bundle `(s, hs)` is exactly what the algebra certifier `exact_of_isLocalized_span`
  consumes (`Ideal.span s = ⊤` + `IsLocalizedModule.Away (s i)`), so one datum drives both
  geometry and algebra with zero bridge lemmas. A bespoke structure would need two
  conversion lemmas; a predicate-on-arbitrary-cover would need a "cover ≅ standard cover"
  comparison at every use. Protected `cech_computes_higherDirectImage` and `CechComplex`
  keep their general-`OpenCover` signatures untouched — the existing basis-comparison
  design (`cech_eq_cohomology_of_basis`/`affine_serre_vanishing`) already isolates standard
  covers, so narrowing only the non-protected `CechAcyclic.affine` is consistent.

- **(b2) Local-to-global — use `exact_of_isLocalized_span`.** `Mathlib.RingTheory.\
  LocalProperties.Exactness` provides
  `exact_of_isLocalized_span (s : Set R) (hs : Ideal.span s = ⊤) … (F : M →ₗ[R] N)
  (G : N →ₗ[R] L) : (∀ r : s, Function.Exact (F localized at Away ↑r)
  (G localized at Away ↑r)) → Function.Exact ⇑F ⇑G`. This is the Mathlib analogue of
  Stacks `algebra-lemma-characterize-zero-local`, but localizing at the *spanning
  elements* (the `Away` localizations = `M_{f_i}`) — a cleaner match to Čech than the
  prime version. Use it node-by-node: positive-degree homology vanishing of the cochain
  complex at degree `p` is `Function.Exact (d^{p-1}) (d^p)`; reduce to exactness after each
  `Away (f_r)`. Sibling `exact_of_isLocalized_maximal` (localize at every maximal,
  `AtPrime`) is the literal prime version from the blueprint if the element version proves
  awkward. **This replaces the "localize at an arbitrary prime 𝔭" step of the Stacks/blueprint
  proof** with the element-localization, after which `D(f_r)` is the whole localized space
  and the homotopy with `i_fix = r` contracts globally — no prime needed.

## Informational

- **(b1) NEEDS_MATHLIB_GAP_FILL — the algebra Čech-of-localizations exactness is absent.**
  Mathlib has no `Algebra.lemma-cover-module` analogue: no statement that
  `0 → M → ∏ M_{f_i} → ∏ M_{f_i f_j} → ⋯` is exact. It has only the degree-≤1 *sheaf
  condition* for the structure sheaf (`TopCat.Presheaf.IsSheafEqualizerProducts`,
  `StructureSheaf` gluing) — i.e. the `M → ∏ M_{f_i} ⇉ ∏ M_{f_i f_j}` equalizer (H⁰/H¹
  only) — plus the local-to-global certifiers of (b2). The full positive-degree complex
  exactness is the genuinely from-scratch core of P3. Gap is upstream, not a project fault.

- **(b3) NEEDS_MATHLIB_GAP_FILL / PARTIAL — homotopy machinery is simplicial-only.**
  `CategoryTheory.SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`
  (`Mathlib.AlgebraicTopology.ExtraDegeneracy`) turns an extra degeneracy on an augmented
  **simplicial** object into a `HomotopyEquiv` between its `AlternatingFaceMapComplex`
  (chain complex) and the point — exactly the Stacks `h(s)_{i₀…i_p}=s_{i_fix i₀…i_p}`
  homotopy in spirit. But it is the wrong variance: the project's `CechComplex` is
  **cosimplicial** + `alternatingCofaceMapComplex` (cochain), and Mathlib has **no
  cosimplicial dual** of `ExtraDegeneracy`; also there is no *global* `i_fix` (the degeneracy
  exists only after localizing at `f_{i_fix}`). Recommendation: build the contracting
  homotopy at the **module level** on the localized cochain complex — either a
  `CategoryTheory.Homotopy` on the `CochainComplex`, or (simpler) prove the 3-term
  `Function.Exact` per node directly from `dh + hd = id` and feed `exact_of_isLocalized_span`.
  Treat `ExtraDegeneracy` as the formula template, not a code dependency.

## Build architecture (three-layer bridge)

The assembled P3 statement is not in Mathlib, but two of its three layers are. For the
`mathlib-build` prover:

- **L1 (gap-fill, geometry↔algebra):** identify `CechComplex f 𝒰 F` on the standard cover
  with the module complex `∏_σ M_{f_σ}` via `Γ(D(f_σ)) = M_{f_σ}` (the
  `affineOpenCoverOfSpanRangeEqTop_f` localization-of-sections description). Needs
  `(∏_σ M_{f_σ})_{f_r} ≅ ∏_σ M_{f_σ f_r}` — localization commutes with finite products,
  available via `IsLocalizedModule`/finite `Pi` (`IsLocalization.instForallPiUniv`).
- **L2 (ALIGN, b2):** `exact_of_isLocalized_span` with `s = Set.range f`, node-by-node.
- **L3 (gap-fill, b3):** the explicit `Away (f_r)`-local contracting homotopy
  `h(s)_{i₀…i_p} = s_{r i₀…i_p}` giving `Function.Exact` of the localized differentials.

L2 and the cover constructor are Mathlib-native — do not reinvent. The from-scratch work
is L1 and the L3 module homotopy.

## Persistent file
- `.archon/analogies/p3-localisation.md` — full design rationale and citations captured for
  future iters.

Overall verdict: ALIGN the cover-type to `affineOpenCoverOfSpanRangeEqTop` and the
local-to-global step to `exact_of_isLocalized_span` (both Mathlib-native); the
Čech-of-localizations complex exactness and its localized contracting homotopy are genuine
from-scratch gap-fills, but small ones bracketed by those two idioms.
