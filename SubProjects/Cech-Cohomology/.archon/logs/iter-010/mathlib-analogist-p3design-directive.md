# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
p3design

## Design question

How should the P3 affine-acyclicity lemma `CechAcyclic.affine` be (re-)signed and built in Lean, given that its proof is the *standard-cover* prime-local contracting-homotopy argument? Two coupled decisions:

1. **The "standard affine open cover" Lean type.** The blueprint proves vanishing only for a *standard* open cover `U = ⋃ D(fᵢ)` of an affine `U = Spec A` (the `fᵢ ∈ A` generating the unit ideal), but the current Lean signature takes a general `𝒰 : X.OpenCover` (see `## Project artifact(s)`). We have DECIDED to narrow the non-protected signature to standard covers. What is the right Lean encoding of "a standard affine open cover of an affine scheme"? Options to weigh: (a) a bundled structure carrying `Fin n → Γ(X, O_X)` + a `Ideal.span = ⊤` proof + the identification of the cover opens with `basicOpen fᵢ`; (b) a predicate on an existing `X.OpenCover`; (c) reuse of an existing Mathlib notion (e.g. `PrimeSpectrum.basicOpen`, `IsAffineOpen`, `Scheme.affineCover`, the `Spec`/`basicOpen` API, or any "covers by basic opens / generate unit ideal" idiom). Does Mathlib already have a standard-affine-cover construct or the closest idiom?

2. **The localisation Čech complex + its exactness.** The mathematical core is: for `M` an `A`-module and `f₁,…,fₙ` generating `(1)`, the extended complex `0 → M → ∏ M_{f_{i₀}} → ∏ M_{f_{i₀}f_{i₁}} → ⋯` is exact, proved by localising at each prime `𝔭`, picking `i_fix` with `f_{i_fix} ∉ 𝔭`, and using the contracting homotopy `h(s)_{i₀…iₚ} = s_{i_fix i₀…iₚ}`. Does Mathlib already have ANY form of this — the algebraic standard-cover Čech exactness (Stacks `algebra-lemma-cover-module` / `algebra-lemma-cover-module-exact`), a Koszul/Čech complex of localisations, or `exact-after-localisation` machinery (`Module.eq_zero_of_localization`, `LocalizedModule`, faithfully-flat-cover exactness)? What is the right Mathlib idiom for "a complex of modules is exact ⇔ exact after localising at every prime", and for assembling the alternating-sum localisation complex? Identify the building blocks so the from-scratch build aligns with Mathlib rather than re-inventing a parallel API.

## Project artifact(s) under question
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`:764-774 — `theorem CechAcyclic.affine [IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f 𝒰 F).homology p)` — currently `sorry`; general `X.OpenCover`, to be narrowed to standard covers.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`: blocks `def:cech_complex`, `lem:cech_acyclic_affine` (the proof sketch with the prime-local contracting homotopy), and `lem:cech_augmented_resolution` (the extended-complex exactness consumer).

## Why now

P3 is the project's long-pole bottleneck (every geometric node routes through `CechAcyclic.affine`). Before scaffolding the narrowed signature + the from-scratch localisation-homotopy infrastructure, I want the Lean encoding of "standard affine cover" and the localisation-Čech-exactness building blocks to be Mathlib-aligned, so the ~250–550 LOC we build composes with Mathlib (`PrimeSpectrum`, `LocalizedModule`, `IsLocalization`, the `Spec`/`O_X.Modules` API) rather than forming a parallel API. The narrowed signature will be the input type the prover formalizes against; getting its shape right now avoids a costly re-sign later.

## Hints
Relevant Mathlib namespaces to probe: `AlgebraicGeometry.Scheme.OpenCover`, `AlgebraicGeometry.IsAffineOpen`, `PrimeSpectrum.basicOpen`, `RingedSpace`/`Scheme.basicOpen`, `Ideal.span`/`Submodule.span ... = ⊤`, `IsLocalization`, `LocalizedModule`, `Module.localization`, `Localization.away`, exactness-via-localisation (`Module.eq_zero_iff_forall_isLocalizedModule` / `LinearMap.exact` localisation lemmas), `CategoryTheory.ShortComplex` / `HomologicalComplex` over `ModuleCat`. Stacks tags: `algebra-lemma-cover-module`, `algebra-lemma-characterize-zero-local`. Also check whether `SheafOfModules` / `Scheme.Modules` has a section-over-affine = module-localisation bridge (`IsAffineOpen.…` global-sections-as-localisation lemmas).

## Severity expectation
high-stakes — this design is load-bearing for the entire P3/P5 geometric build; be strict about idiom adherence and name the concrete cost of any parallel-API path.
