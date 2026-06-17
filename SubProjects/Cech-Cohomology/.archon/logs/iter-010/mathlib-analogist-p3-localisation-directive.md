# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
p3-localisation

## Design question

How should the project represent and prove **P3** — the positive-degree exactness of the
standard-cover Čech complex of an affine scheme — given that it must be built essentially
from scratch for `Scheme.Modules`? Concretely, two coupled decisions:

(a) **Cover-type decision.** The protected target routes through a non-protected lemma
`CechAcyclic.affine` whose current Lean signature takes a *general* `𝒰 : X.OpenCover`, but
the mathematical content (Stacks `lemma-cech-cohomology-quasi-coherent-trivial`) is about a
*standard* cover `U = ⋃ D(f_i)` with `f_1,…,f_n ∈ A` generating the unit ideal. We have
DECIDED to narrow the signature to the standard-cover case. What is the right Lean
*encoding* of "a standard affine open cover of `Spec A`"? Should it be (i) a bespoke
structure carrying `(f : Fin n → A)` + `(hspan : Ideal.span (Set.range f) = ⊤)`, (ii) a
predicate on an existing `X.OpenCover` asserting each member is a basic open `D(fᵢ)`, or
(iii) something built from Mathlib's existing affine-cover / `PrimeSpectrum.basicOpen` API?

(b) **Complex-and-exactness decision.** The standard-cover Čech complex on `Spec A` with
`F|_U = M~` is the complex of localisations
`∏_{i₀} M_{f_{i₀}} → ∏_{i₀i₁} M_{f_{i₀}f_{i₁}} → ⋯`, and positive-degree exactness is the
Stacks contracting-homotopy argument: localise the *extended* complex
`0 → M → ∏ M_{f_{i₀}} → ⋯` at an arbitrary prime `𝔭`, pick `i_fix` with `f_{i_fix} ∉ 𝔭`,
and `h(s)_{i₀…iₚ} = s_{i_fix i₀…iₚ}` gives `dh + hd = id`. How should this be represented
in Mathlib idiom? Specifically: (1) Does Mathlib already have an exactness/acyclicity result
for the Čech (alternating face map) complex of a ring/module by a family of localisations
generating the unit ideal — i.e. a `Scheme.Modules`/`CommAlg`-level analogue of Stacks
`Algebra.lemma-cover-module`? (2) What is the idiomatic Mathlib way to certify exactness
"after localising at every prime" (a faithfully-flat / local-to-global / `Module.Flat` /
`IsLocalization`-at-prime nullity criterion)? (3) Is the contracting homotopy best expressed
via Mathlib's `Homotopy`/`HomotopyEquiv` API on a `CochainComplex`, or by directly exhibiting
the complex as built from a Koszul-type / augmented simplicial object that Mathlib already
knows is exact?

## Project artifact(s) under question
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:764-774` — `CechAcyclic.affine`
  (the P3 sorry, with the current general-`OpenCover` signature and the Stacks-02KG comment).
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` — the existing `CechComplex`,
  `CechNerve`, `pushPullFunctor` constructions (the scheme-level backbone the localisation
  description must connect to).
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — `lem:cech_acyclic_affine`
  (statement + Stacks contracting-homotopy proof sketch, with verbatim SOURCE QUOTE PROOF) and
  `lem:cech_augmented_resolution` (the augmented/extended-complex exactness).

## Why now

P3 is the project's long pole and is genuinely from-scratch (leansearch so far shows only
generic `Acyclic`/`ExactAt` for `Scheme.Modules`). Before I effort-break the P3 blueprint and
dispatch a `mathlib-build` prover to grow this infrastructure, I need to know whether Mathlib
already provides any of: a standard-affine-cover type, a localisation-Čech-complex exactness
lemma, or a clean "exact after localising at every prime" certifier — so the build aligns with
the Mathlib idiom instead of reinventing a parallel API. The cover-type encoding in particular
will be load-bearing for every downstream P5 consumer (the basis lemma, the resolution lemma),
so getting its shape right now avoids a fragmented bespoke type that later needs bridge lemmas.

## Hints (optional)
- Commutative-algebra side: `IsLocalization`, `IsLocalization.Away`, `Ideal.span … = ⊤`,
  `RingHom.toAlgebra`, the "cover by localizations" / `Algebra` cover-module exactness, the
  prime-local nullity criterion (`Module.isZero`-after-localization, `Module.Flat`,
  `IsLocalization.injective`/`localization_le` faithfulness, `LocalizedModule`).
- Homotopy/complex side: `CategoryTheory.Abelian` `Homotopy`, `HomotopyEquiv`,
  `AlternatingFaceMapComplex`, `CechNerve`/`Arrow.cechNerve` (does Mathlib's simplicial Čech
  nerve come with any built-in exactness for an epi/covering?), `Koszul`/`unitOfTensorProduct`.
- Scheme side: `AlgebraicGeometry.Scheme.OpenCover`, `affineCover`, `PrimeSpectrum.basicOpen`,
  `Scheme.Modules`, `IsAffineOpen.fromSpec`, the `Γ(D(f), F) = M_f` localisation API
  (`AlgebraicGeometry` `Spec`/`Modules` localisation-of-sections lemmas).
- The blueprint deliberately reduces the *sheaf* statement to the *module/algebra* statement
  (exactness of the extended complex of localisations); the question of whether Mathlib has the
  algebra statement (Stacks `Algebra.lemma-cover-module`) is the single highest-value lookup.

## Severity expectation
high-stakes
