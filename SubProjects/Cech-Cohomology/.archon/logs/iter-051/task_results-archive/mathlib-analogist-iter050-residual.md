# Mathlib Analogist Report

## Mode
api-alignment

## Slug
iter050-residual

## Iteration
050

## Question
Cheapest Mathlib-aligned route to prove the 02KG residual leaf: for `M` an `R`-module, `f : R`,
finite `g : ι → R` with `D(f) = ⨆ᵢ D(gᵢ)`, and `p > 0`, `Ȟᵖ({D(gᵢ)}, ~_R M) = 0` — where `{gᵢ}`
spans only `√(f)`, not `R`. Fork: (A) change-of-SPACE via `Spec R_f ≅ D(f)` + sheaf restriction, vs
(B) change-of-RING identifying the two module Čech complexes; and whether exposing the `private`
`CechAcyclic` algebraic core is cheaper than building the change-of-space cochain iso.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Route A (change-of-space) vs B (change-of-ring) | ALIGN_WITH_MATHLIB on **B**; diverge from A | major (in-proposal) |
| Expose `private` `SectionCech*` core (refactor)? | PROCEED — no refactor; co-locate proof in `CechAcyclic.lean` | informational |
| Mathlib base-change for module Čech/Koszul complex? | NEEDS_MATHLIB_GAP_FILL (upstream; project owns the substitute) | informational |

## Major

- **Adopt route B (change-of-ring), not route A.** Both routes share the same unavoidable algebraic core
  (a degreewise `M_{gσ} ≅ (M_f)_{gσ}` localization-transitivity iso commuting with the alternating
  localisation differentials). Route A adds, on top of that core, **a tilde base-change sheaf iso**
  `(pullback specAwayToSpec)(~_R M) ≅ ~_{R_f} M_f` that **Mathlib does not have** and the project has only
  at *presentation* level (`presentationModulesRestrictBasicOpen`) — plus a cross-*space* section-group
  identification across `Spec R_f ≅ D(f)`. That is the expensive 01I8-style sheaf-diamond plumbing already
  documented as painful (memory `sheaf-iso-on-basis-plumbing.md`, `rR-semiring-diamond-change-workaround.md`).
  Route B applies the core directly at the module level and never touches a sheaf iso.
  Est: route B ~120–200 LOC / ~5–8 lemmas / 0 refactor; route A ~350–450 LOC / more lemmas / a Mathlib gap.

## Informational

- **No refactor needed.** The residual can be a **new public theorem placed in `CechAcyclic.lean`**, inside
  the existing namespaces, where the `private` `SectionCechModule.dDiff_exact` / `dCoeff` /
  `SectionCechTilde.sectionToModuleAddEquiv` / `sectionCechAbExact` are all in scope. The directive's
  privacy concern only bites if the proof lives in `AffineSerreVanishing.lean`; co-locating dissolves it.
  Recommended shape: `sectionCech_homology_exact_of_localizationAway (M) (g) (f) (hspan : span(range(algebraMap R R_f ∘ g)) = ⊤) (p) (hp)`,
  proved by `Function.Exact.of_ladder_addEquiv_of_exact` (the exact shape of `sectionCechAbExact`,
  `CechAcyclic.lean:1577`) with vertical AddEquivs `M_{gσ} ≅ (M_f)_{gσ}` from the public `AwayComparison`
  API and horizontal rows from `SectionCechModule.dDiff_exact` **re-instantiated over `R_f`** (the
  namespace is `{R}[CommRing R]`-polymorphic). Naturality square mirrors `cechCoface_dToCech`
  (`CechAcyclic.lean:941`). `hspan` is supplied by `affine_cover_span_localizationAway`.

- **Mathlib has no module/section Čech complex**, hence no base-change functoriality for it, and **no
  tilde-base-change lemma**. The substitute is wholly project-owned and already axiom-clean: public
  `AwayComparison.comparison` + `comparison_isLocalizedModule` (transitivity `M_a → M_{ab}`) +
  Mathlib `exact_of_isLocalized_span` (`Mathlib.RingTheory.LocalProperties.Exactness`) — the last
  **requires `span = ⊤` in the base ring**, confirming `{gᵢ}` (and even `{gᵢ, f}`, radical `√f`) cannot be
  run over `R`, only over `R_f`. The `Spec R_f ≅ D(f)` iso (`AlgebraicGeometry.basicOpenIsoSpecAway`,
  `Mathlib.AlgebraicGeometry.Restrict`) IS present and already wrapped (`specAwayToSpec*`,
  `modulesRestrictBasicOpen*`), but it is not the bottleneck for route A — the missing tilde-iso is.

- **One small supporting lemma** route B needs: `gσ ∈ √(f)` (so `f` is a unit in `M_{gσ}`, giving the
  `Inverts` witness for `M_{gσ} ≅ (M_f)_{gσ}`), derivable from `hcov` (`D(gσ) ⊆ D(f)`) by the same
  `PrimeSpectrum.basicOpen`-≤ reasoning already inside `affine_cover_span_localizationAway`.

## Persistent file
- `analogies/02kg-residual-changeofbase.md` — full route comparison, cost estimates, and the concrete
  route-B construction recipe captured for future iters.

Overall verdict: take route B (change-of-ring) as a new public theorem co-located in `CechAcyclic.lean` —
it reuses the axiom-clean public `AwayComparison` API + `dDiff_exact`-over-`R_f` with zero refactor and no
sheaf infrastructure, and is decisively cheaper than route A, which depends on a tilde-base-change sheaf
iso Mathlib lacks.
