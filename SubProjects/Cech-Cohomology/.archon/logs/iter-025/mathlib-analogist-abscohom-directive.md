# mathlib-analogist directive — absolute sheaf cohomology H^n(U, F) for module sheaves

## Mode: api-alignment

## Context (self-contained)
This project proves a Čech-computes-cohomology statement for `O_X`-modules on schemes. Two
upcoming declarations both need **absolute sheaf cohomology** `H^p(U, F)` (p > 0) of an
`O_X`-module restricted to an open `U`, together with its **long exact sequence** for a short
exact sequence of sheaves:

1. `lem:cech_to_cohomology_on_basis` (Stacks 01EO, `AlgebraicGeometry.cech_eq_cohomology_of_basis`)
   — a dimension-shift proof that runs the sheaf-cohomology long exact sequence of
   `0 → F → I → Q → 0` (with `I` injective, so `H^n(U,I)=0` for n>0) to deduce
   `H^p(U,F)=0` for p>0 from Čech vanishing.
2. The downstream P5a consumers (`open_immersion_pushforward_comp`,
   `cech_term_pushforward_acyclic`) which feed `affine_serre_vanishing`, stated with the absolute
   `H^k(f^{-1}V, G)`.

The project's sheaves are `SheafOfModules (sheafCompForget ...)` / `PresheafOfModules` over the
structure sheaf of a scheme `X` (Mathlib `AlgebraicGeometry.Scheme.Modules`,
`PresheafOfModules`, `SheafOfModules`). Higher direct images are already realized as
`((pushforward f).rightDerived i).obj F` using `HasInjectiveResolutions X.Modules`.

## The question
What is the **canonical Mathlib idiom** to express `H^p(U, F)` (absolute sheaf cohomology of a
module sheaf over an open `U` of a scheme / ringed space) and its long exact sequence, such that:
- it agrees with / is comparable to `((globalSectionsFunctor or Γ(U,-)).rightDerived p).obj F`,
- it carries a long exact sequence for a SES of module sheaves,
- and `H^n(U, I) = 0` for `I` injective in the relevant abelian category, n > 0?

Specifically evaluate these candidate routes and tell me which Mathlib actually supports today:

**Route α — derived global sections in `X.Modules` directly.** Use
`(Γ-over-U functor).rightDerived p` on `X.Modules` (or `SheafOfModules`), exploiting that
`X.Modules` already has `HasInjectiveResolutions`. Is there a Mathlib "sections over an open U"
functor `X.Modules ⥤ ModuleCat _` (restriction-then-global-sections) whose `rightDerived`
is usable, and does Mathlib give its LES (`Functor.rightDerived` δ-functor / connecting maps)?
Name the exact Mathlib decls (`Abelian.rightDerived`, `Functor.rightDerivedZero`, the LES from
`ShortComplex.ShortExact.rightDerived...` / `Functor.rightDerived` δ-functor, etc.).

**Route β — `CategoryTheory.Sheaf.H` (AddCommGrp-valued sheaf cohomology) via a forget.**
Does Mathlib have `CategoryTheory.Sheaf.H` (or `Sheaf.cohomology` / `H^n` on
`Sheaf J AddCommGrp`)? If so, can a module sheaf be pushed to an `AddCommGrp`-valued sheaf via a
forgetful functor, and does that forget preserve injectives / the LES so that `H^n(U,I)=0` and
the connecting maps transport? Name the exact decls and whether the forget is exact / has the
needed adjoint.

**Route γ — Čech-only / avoid absolute cohomology.** Can the 01EO dimension shift be restated
to use ONLY Čech cohomology (the project already has the section-Čech complex
`sectionCechComplex` and its homology), never invoking absolute `H^n(U,-)`? The Stacks proof
mixes Čech LES and sheaf-cohomology LES; assess whether a purely-Čech reformulation closes
`H^p(U,F)=0` (e.g. defining `H^p(U,F) := colim_𝒰 Ȟ^p(𝒰,F)` over the cofinal system, so the
"absolute" cohomology IS the colimit of Čech) — and whether that matches what
`affine_serre_vanishing` downstream actually consumes.

## What I need back
- A ranked recommendation: which route the project should commit to for realizing `H^p(U,F)`,
  with the exact Mathlib decls each requires and a verdict on whether each exists TODAY.
- For the winner: the concrete Lean shape (functor + rightDerived OR Sheaf.H + forget OR the
  Čech-colimit definition) and the LES decl that supplies the connecting maps.
- Flag any route that would force a bespoke from-scratch cohomology theory (multi-hundred-LOC) so
  the planner can avoid it.
- Persist the analysis to `analogies/absolute-cohomology.md`.

This is a design decision the planner must make before dispatching `cech_eq_cohomology_of_basis`;
the strategy already flags `CategoryTheory.Sheaf.H + forget` (Route β) as the suspected cheap
path — confirm or refute it.
