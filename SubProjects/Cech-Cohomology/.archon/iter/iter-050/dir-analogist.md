## Mode: api-alignment

## Question / proposed design
We must prove a residual leaf on the 02KG critical path and want the cheapest Mathlib-aligned route
before committing a (likely multi-session) prover chain.

**The residual.** For an `R`-module `M` (`R : CommRingCat`), `f : R`, and a finite family `g : Fin n → R`
with `D(f) = ⨆ᵢ D(gᵢ)` in `Spec R`, and `p > 0`:
`Ȟᵖ({D(gᵢ)}, ~_R M) = 0` — positive-degree section Čech cohomology of the tilde sheaf over a standard
cover of a **proper** distinguished open `D(f)`.

We already have (axiom-clean, public) `sectionCech_affine_vanishing R M s (hspan : Ideal.span (range s) = ⊤)`:
positive-degree section Čech vanishing for `~_R M` when the family `s` spans the WHOLE unit ideal (covers
all of `Spec R`). The residual's family `{gᵢ}` spans only an ideal whose radical contains `f`, so it does
NOT span `R` for proper `D(f)`. Over `R_f = Localization.Away f` the images `{gᵢ/1}` DO span `⊤` (we proved
this: `affine_cover_span_localizationAway`).

## The route fork I need adjudicated
The section Čech complex over `{D_R(gᵢ)}` of `~_R M` has degree-`p` term `∏_σ M_{g_σ}` (since
`Γ(D_R(g_σ), ~_R M) = M_{g_σ}`), differentials = alternating sums of localization maps. Because `f` is
already invertible in each `R_{g_σ}` (as `D(g_σ) ⊆ D(f)`), `M_{g_σ} = (M_f)_{g_σ}`. So this complex is
"the same" as the section Čech complex of `~_{R_f} M_f` over `{D_{R_f}(gᵢ/1)}`, which vanishes by
`sectionCech_affine_vanishing` over `R_f`. Two ways to formalize the identification:

- **(A) change-of-SPACE (sheaf):** use the scheme iso `Spec R_f ≅ D(f) ⊆ Spec R`, pull the sheaf `~_R M`
  back to `~_{R_f} M_f`, and build a cochain-complex iso `sectionCechComplex (D_R g) (~_R M) ≅
  sectionCechComplex (D_{R_f} g/1) (~_{R_f} M_f)` degreewise + naturality. iter-049's prover recommended
  this, reusing `QcohRestrictBasicOpen` (`modulesRestrictBasicOpen`, `modulesRestrictBasicOpenIso`,
  `presentationModulesRestrictBasicOpen`).
- **(B) change-of-RING (algebraic):** identify the two complexes purely as algebraic Čech complexes of
  modules (`M_{g_σ} = (M_f)_{g_σ}` as `R`/`R_f`-modules, differentials = localization maps), WITHOUT going
  through `Spec R_f` as a scheme. This would want to reuse the `CechAcyclic.lean` algebraic core — but that
  core (`combDifferential`, `depDiff_exact`, `dDiff`, the `dCoeff`/`cechCoeff` machinery) is largely
  `private`. NOTE: `CechAcyclic.lean` ALSO exposes a PUBLIC change-of-ring localization-comparison API:
  `Inverts`, `comparison`, `comparison_isLocalizedModule`, `Inverts.smul_pow_cancel`, plus public
  `dDiff`/`dToCech`/`locDiff`/`fLoc`/`map_dDiff_eq_locDiff`. Assess whether these suffice to re-derive the
  residual over `R_f` directly, or whether a refactor to expose more of the core is warranted.

## What I want from you
1. Does Mathlib have a **change-of-base-ring functoriality** for the algebraic Čech/Koszul complex of a
   module, or for a localized-module section complex, that makes the identification cheap? (Search:
   `Localization`, `IsLocalizedModule`, Čech/Koszul complex base change, `LocalizedModule` functoriality,
   `AlgebraicGeometry.Spec`/`basicOpen` scheme-iso `Spec R_f ≅ D(f)`.)
2. Which of route (A) / (B) is the Mathlib-idiomatic, lower-cost path? Is the scheme iso
   `Spec (Localization.Away f) ≅ D(f)` (or its restriction-of-`~M` consequence) already in Mathlib in a
   directly usable form (e.g. `AlgebraicGeometry.Scheme.restrictFunctorΓ`, `Spec.map` of the localization
   algebra map, `PrimeSpectrum.localization_away_*`, `StructureSheaf`/`Spec` tilde-restriction lemmas)?
3. Concretely: is exposing the `CechAcyclic` private algebraic core (a refactor) cheaper than building the
   change-of-space cochain iso, or vice versa? Give a cost estimate (LOC / # bridge lemmas) for each.

## Files to read
- `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (public API: `sectionCech_affine_vanishing`,
  `Inverts`/`comparison`/`comparison_isLocalizedModule` ~lines 487–680, `dCoeff`/`dDiff`/`locDiff`/`fLoc`
  ~lines 880–1070; private core `comb*`/`dep*` lines 144–487).
- `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` (`modulesRestrictBasicOpen*` engine).
- `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` (lines ~399–480: the residual reduction +
  `affine_cover_span_localizationAway`, `cechCohomology_isZero_of_iso`, the two `_of_tildeVanishing` forms).
- `references/stacks-coherent.tex` Tag 02KG / `lemma-cech-cohomology-quasi-coherent-trivial`.

Write the persistent rationale to `analogies/02kg-residual-changeofbase.md`.
