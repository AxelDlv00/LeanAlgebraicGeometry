# Mathlib Analogist Report

## Slug
finite-prod-loc

## Iteration
106

## Questions

(Q1) Product-localisation commutation + `IsLocalizedModule.Pi` for the
`h_loc_exact` sorry at `BasicOpenCech.lean:1783`.

(Q2) Mathlib idiom for proving R-linearity of an alternating sum of
`Pi.lift`-style categorical morphisms (the 7-iter-stuck
`cechCofaceMap_pi_smul` body at `BasicOpenCech.lean:1120`).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1a — `IsLocalizedModule.pi` finite product instance | ALIGN_WITH_MATHLIB | critical (project should consume this directly) |
| Q1b — per-coord `IsLocalization.Away` → `IsLocalizedModule` bridge | ALIGN_WITH_MATHLIB | major (write the glue) |
| Q1c — `Function.Exact` transport across `IsLocalizedModule.iso` | PROCEED | informational |
| Q2a — post-hoc R-linearity in `ModuleCat k` for `R ≠ k` | MATHLIB_GAP_CONFIRMED (self-imposed by project's design) | critical |
| Q2b — tactical `change`-to-named-family bridging | PROCEED (try first, time-boxed) | informational |

## Must-fix-this-iter

- **Q1a/Q1b — the project has not yet written `h_loc_exact`'s closure
  (raw sorry at `BasicOpenCech.lean:1783`)**. The iter-069 docstring
  mentions "the product-localisation commutation `LocalizedModule
  (powers f) (∏ᶜ_x M_x) ≅ ∏ᶜ_x LocalizedModule (powers f) M_x`" as a
  step but never invokes the canonical Mathlib instance that
  *provides* it as a typeclass:

  ```
  instance IsLocalizedModule.pi : IsLocalizedModule S (.pi fun i ↦ f i ∘ₗ .proj i)
  ```

  in `Mathlib.RingTheory.TensorProduct.IsBaseChangePi:93`. The iter-107+
  plan agent's prover assignment for `h_loc_exact` should explicitly
  cite this instance.

- **Q2a — the iter-099 → iter-105 series has spent 7 iters trying to
  certify R-linearity post-hoc in `ModuleCat k` for `R = Γ(C.left, U) ≠
  k`**. This is a self-imposed Mathlib gap: `Linear k`-enriched
  `ModuleCat k` does not provide `Linear R`, and Mathlib's
  `alternatingCofaceMapComplex` works at the `Preadditive`-only level
  (no R-linearity propagation). The continuing post-hoc approach is
  the source of the stuck pattern; the iter-107+ plan should pivot to
  one of the two paths in the analogy file:
  - Path B (tactical, ~30-50 LOC, try first): `set F :=
    cechCofaceMap_summand_family s₀ n` at the top of
    `cechCofaceMap_pi_smul`'s body, then `change` the goal into a
    named-family form; apply `alternating_sum_pi_smul_aux` directly.
  - Path A (architectural, ~150-250 LOC, fallback): refactor the
    local-to-global proof to operate on `K₀_R := cechCochain` valued
    in `ModuleCat R`, where R-linearity of the differential is
    intrinsic. Bridge to `K₀` (the `ModuleCat k`-valued form) via
    `restrictScalars`.

## Major

- **Q1b — write the per-coord `IsLocalization.Away` → `IsLocalizedModule`
  bridge using Mathlib's
  `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`
  in `Mathlib.Algebra.Module.LocalizedModule.IsLocalization`** rather
  than inventing a per-coord stand-in. Total ~50 LOC of glue (per-coord
  algebra instance + `isLocalization_of_eq_basicOpen` + the adapter).

## Informational

- **Q1c — `Function.Exact` transport across `IsLocalizedModule.iso`**:
  use `LinearEquiv.exact_iff_exact` (Mathlib search confirms the
  generic form exists). The project must produce the iso from
  `IsLocalizedModule.iso` applied to the `IsLocalizedModule.pi`
  instance.

- **Q2b — tactical `change`-to-named-family**: this is a project-local
  micro-tactic, no Mathlib precedent. Recommended as the *first* iter
  to try because it reuses iter-104's already-closed
  `cechCofaceMap_summand_family_R_linear` (50 LOC) directly. If
  iter-107's prover lands the `change` defeq, the proof closes in
  ~20-30 lines. If `change` fails, escalate to Path A.

- **Strategy-critic LOC estimate validation**: the strategy-critic's
  ~80 LOC estimate for `h_loc_exact` is **valid at the low end of
  ~80-120 LOC**. The bulk is the per-coord algebra + `IsLocalization.Away`
  bookkeeping (Q1b, ~50 LOC); the `IsLocalizedModule.pi` invocation +
  `LinearEquiv.exact_iff` transport is short (~30 LOC).

## Persistent file
- `analogies/finite-product-localisation-and-cech-r-linearity.md` —
  design rationale, full citation list, recommended sequencing for
  iter-107+.

## Cited Mathlib precedents

| Concern | Mathlib precedent | Path:line |
|---|---|---|
| Pi-localisation typeclass | `IsLocalizedModule.pi` (instance) | `Mathlib/RingTheory/TensorProduct/IsBaseChangePi.lean:93` |
| Binary product analogue | `IsLocalizedModule.prodMap` (instance) | `Mathlib/RingTheory/TensorProduct/IsBaseChangePi.lean:77` |
| Base change finite product | `IsBaseChange.pi` (lemma) | `Mathlib/RingTheory/TensorProduct/IsBaseChangePi.lean:48` |
| Affine ⇒ basic-open = localization on sections | `IsAffineOpen.isLocalization_of_eq_basicOpen` | `Mathlib/AlgebraicGeometry/AffineScheme.lean:716` |
| Algebra `IsLocalization` → `IsLocalizedModule` | `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` | `Mathlib/Algebra/Module/LocalizedModule/IsLocalization.lean` |
| Canonical `IsLocalizedModule` iso | `IsLocalizedModule.iso` | `Mathlib/Algebra/Module/LocalizedModule/Basic.lean` |
| `Function.Exact` & `IsLocalizedModule.map` (PROJECT'S DIRECTIVE: not the closing tool — circular) | `IsLocalizedModule.map_exact` | `Mathlib/Algebra/Module/LocalizedModule/Exact.lean:56` |
| Local-to-global exactness | `exact_of_localized_span` | `Mathlib/RingTheory/LocalProperties/Exactness.lean:211` |
| `ModuleCat R` Pi-iso | `ModuleCat.piIsoPi` | `Mathlib/Algebra/Category/ModuleCat/Products.lean` |
| Categorical alternating coface complex | `alternatingCofaceMapComplex` (works in `Preadditive C`, NOT `Linear R C`) | `Mathlib/AlgebraicTopology/AlternatingFaceMapComplex.lean` |
| `Linear R C` typeclass | `CategoryTheory.Linear` (does NOT instantiate on `ModuleCat k` for `R ≠ k`) | `Mathlib/CategoryTheory/Linear/Basic.lean` |

Overall verdict: **Q1 is ALIGN_WITH_MATHLIB with a clear ~80-120 LOC
recipe; Q2 is a self-imposed Mathlib gap from building the Čech
complex in `ModuleCat k` instead of `ModuleCat R` — try a tactical
`change`-to-named-family (Path B, ~30-50 LOC) for iter-107, and if
that fails, fall back to an architectural `ModuleCat R` refactor
(Path A, ~150-250 LOC) for iter-108+.**
