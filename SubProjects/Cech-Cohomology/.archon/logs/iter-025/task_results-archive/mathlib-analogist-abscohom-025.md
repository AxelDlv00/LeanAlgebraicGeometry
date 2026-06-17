# Mathlib Analogist Report

## Mode
api-alignment

## Slug
abscohom-025

## Iteration
025

## Question
What is the canonical Mathlib idiom to express `H^p(U, F)` (absolute sheaf cohomology of
a module sheaf over an open `U` of a scheme) and its long exact sequence, such that it
agrees with derived global sections, carries a LES for a SES of module sheaves, and has
`H^n(U, I) = 0` for injective `I`, `n > 0`? Evaluate Route α (derived global sections via
`Functor.rightDerived`), Route β (`CategoryTheory.Sheaf.H` + forget), Route γ (Čech
colimit). The strategy suspects Route β (`Sheaf.H` + forget) is the cheap path — confirm
or refute.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Realize `H^p(U,F)` as `Abelian.Ext^p(𝒪_U, F)` (Route α via Ext, NOT via `Functor.rightDerived`) | ALIGN_WITH_MATHLIB | major (proposal stage) |
| Route β = `CategoryTheory.Sheaf.H` + forget | NEEDS_MATHLIB_GAP_FILL (refuted as cheap path) | informational |
| Route α via `Functor.rightDerived` (sections functor) | DIVERGE — no LES in Mathlib | informational |
| Route γ = Čech colimit | PROCEED (fallback only) | informational |

## Ranked recommendation

1. **WINNER — Ext realization of derived global sections.** Define
   `H^p(U,F) := Ext^p(𝒪_U, F|_U)` (sheaf cohomology = Ext of the structure sheaf, since
   `Γ(U,-) = Hom(𝒪_U,-)`). Mathlib's `CategoryTheory.Abelian.Ext` supplies **all three**
   required pieces off the shelf:
   - **LES**: `Ext.covariant_sequence_exact₁/₂/₃`, `Ext.covariantSequence`,
     `Ext.covariantSequence_exact`
     (`Mathlib/Algebra/Homology/DerivedCategory/Ext/ExactSequences.lean:62,82,100,124,
     140,148,155`) — the covariant (second-variable) LES for `hS : S.ShortExact` at a
     fixed first argument `X`, with connecting map `hS.extClass.postcomp`. Needs only
     `[Abelian C] [HasExt.{w} C]`.
   - **Injective vanishing**: `Ext.eq_zero_of_injective`
     (`.../Ext/EnoughInjectives.lean:99`) — `Ext X I (n+1) = 0` for `[Injective I]`,
     needs only `[HasExt.{w} C]`. Exactly `H^{n+1}(U,I)=0`; needs only the *second* Ext
     argument injective.
   - **`H^0 = Γ`**: `Ext.homEquiv₀` / `Ext.addEquiv₀` (`.../Ext/Basic.lean:223,319`).
   - **`HasExt` availability**: unconditional `HasExt.standard : HasExt.{max u v} C`
     (`.../Ext/Basic.lean:93`); instance `IsGrothendieckAbelian.hasExt`
     (`Mathlib/CategoryTheory/Abelian/GrothendieckCategory/HasExt.lean:36`).
     `SheafOfModules.{v} R` is `Abelian`
     (`Mathlib/Algebra/Category/ModuleCat/Sheaf/Abelian.lean:40`).
   Remaining project work is low–medium: pick the open-subscheme module category +
   `Scheme.Modules.restrictFunctor` (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:319`)
   to express `𝒪_U`/`F|_U`; the degree-0 `Hom(𝒪_U,-) ≅ Γ(U,-)` identification; and (only
   in the `Ext^p(𝒪_U, I|_U)` variant) one "open-immersion restriction preserves
   injectives" lemma — avoidable by keeping the injective `I` as the second Ext argument.

2. **FALLBACK — Route γ (Čech colimit).** `H^p := colim_𝒰 Ȟ^p(𝒰,F)` reusing the
   project's `sectionCechComplex` + homology and the partly-built SES-of-Čech machinery
   (`ses_cech_h1`). LES via `HomologicalComplex`/`ShortComplex` homology sequence +
   filtered-colimit exactness. Medium-high: forces restating downstream
   `affine_serre_vanishing` / `H^k(f^{-1}V,G)` consumers in colim form and reproves 01EO
   by hand. Use only if Ext universe/smallness bookkeeping over `SheafOfModules` becomes
   painful.

3. **AVOID — Route α via `Functor.rightDerived`.** `(Γ(U,-)).rightDerived p` gets
   injective vanishing for free (`Functor.isZero_rightDerived_obj_injective_succ`,
   `Mathlib/CategoryTheory/Abelian/RightDerived.lean:151`), but **Mathlib has no LES for
   `Functor.rightDerived`** — verified: nothing connects `rightDerived` to a
   SES/triangle/exact sequence. Building it reconstructs the derived-category machinery
   `Abelian.Ext` already packages (multi-hundred LOC).

4. **AVOID — Route β.** See refutation below.

## Major

- **Adopt the Ext realization of `H^p(U,F)` (not `Functor.rightDerived`).** No shipped
  code to refactor — absolute cohomology is still in the proposal stage — so the planner
  simply dispatches `cech_eq_cohomology_of_basis` (01EO) and the affine-vanishing
  consumers against `Ext^p(𝒪_U, -)` with the LES = `Ext.covariantSequence_exact` and the
  injective vanishing = `Ext.eq_zero_of_injective`. Choosing `Functor.rightDerived`
  instead would strand 01EO with no LES and force a from-scratch derived-functor LES.

## Informational

- **Route β REFUTED (the suspected cheap path is the most expensive).**
  `CategoryTheory.Sheaf.H` / `Sheaf.cohomology` / an `H^n` on `Sheaf J AddCommGrp` **does
  not exist** in Mathlib (`lean_local_search "Sheaf.H"` returns only `Sheaf.Hom.*`
  morphism lemmas). Mathlib has no AddCommGrp-valued abstract sheaf-cohomology object and
  no forgetful transport of such a theory. Route β = build the whole theory ⇒
  NEEDS_MATHLIB_GAP_FILL, not a shortcut.
- **No LES↔`rightDerived` bridge is forced by the Ext choice.**
  `cech_computes_higherDirectImage` (frozen) uses Route A = Leray acyclic resolution, not
  a LES; `higherDirectImage` stays `(pushforward f).rightDerived`. Absolute `H^p(U,-)`
  (Ext) appears only in 01EO and affine-Serre vanishing. The single eventual meeting
  point is the affine-acyclicity step (`H^i(affine,qcoh)=0` ⟹ Čech terms `f_*`-acyclic,
  Stacks `lemma-quasi-coherence-higher-direct-images-application`); that comparison is
  required under any realization of `H^p`, so it does not count against Ext.

## Persistent file
- `analogies/absolute-cohomology.md` — full decision record with citations for future iters.

Overall verdict: **ALIGN_WITH_MATHLIB** — realize absolute `H^p(U,F)` as
`Abelian.Ext^p(𝒪_U, F|_U)`; Ext is the only route where Mathlib ships the LES (and the
injective vanishing) off the shelf, while Route β (`Sheaf.H`) is refuted as nonexistent
and `Functor.rightDerived` has no LES.
