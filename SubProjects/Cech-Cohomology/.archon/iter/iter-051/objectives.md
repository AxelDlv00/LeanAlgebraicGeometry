# Iter-051 objectives

Two `mathlib-build` lanes, re-dispatched after iter-050's plan-validate no-run. Both build NEW decls.

## Lane 1 (CRITICAL) — `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- **Target:** new public theorem `sectionCech_homology_exact_of_localizationAway` (does not yet exist).
- **Blueprint:** `lem:affine_cech_vanishing_tilde_subcover` in `chapters/Cohomology_CechHigherDirectImage.tex`.
- **Reference:** Stacks **02KG** (`lemma-quasi-coherent-affine-cohomology-zero`) change-of-base + 01HV(4)
  D(f)-sections; standard-cover vanishing `lemma-cech-cohomology-quasi-coherent-trivial`.
- **Route B (change-of-ring):** re-instantiate polymorphic `SectionCechModule.dDiff_exact` over
  `R_f = Localization.Away f` with `g/1` (spanning via `affine_cover_span_localizationAway`, DONE); transfer
  positive-degree exactness to the R-side via the `M_{gσ} ≅ (M_f)_{gσ}` AddEquiv ladder (`AwayComparison`
  API); wrap as `IsZero` homology. Recipe: `analogies/02kg-residual-changeofbase.md`.
- **Mode:** mathlib-build (no sorry). ~5–8 lemmas / ~120–200 LOC.

## Lane 2 (INDEPENDENT) — `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- **Target:** new decl `cechAugmented_exact` (does not yet exist).
- **Blueprint:** `lem:cech_augmented_resolution`.
- **Reference:** Stacks `lemma-cech-cohomology-quasi-coherent-trivial`; contracting homotopy
  `h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}` (`% SOURCE QUOTE` from `references/stacks-coherent.tex`).
- **Argument:** stalk-local exactness; on affine `U=Spec A`, `F|_U≅~M` (`qcoh_iso_tilde_sections`), localize
  at a prime, some `f_i` a unit ⟹ contracting homotopy from the P3 standard-cover vanishing. May need a
  "sheaf-complex exact iff stalkwise exact" criterion — build axiom-clean if Mathlib lacks it.
- **Mode:** mathlib-build (no sorry). Deep infra; decomposition handoff acceptable.

## Untouched this iter
- `AffineSerreVanishing.lean` — discharge of the 02KG tops waits on Lane 1 (iter-052 follow-up).
- Dead `CechAcyclic.lean:110` sorry, protected `CechHigherDirectImage.lean:679` sorry — not lane targets.
