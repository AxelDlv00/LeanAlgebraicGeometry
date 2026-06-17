# Iter-050 objectives — per-lane detail

## Lane 1 (CRITICAL) — `CechAcyclic.lean` — route-B 02KG residual
- **Target:** new PUBLIC theorem `AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway`
  (does not yet exist). Pinned by `lem:affine_cech_vanishing_tilde_subcover`.
- **Statement:** for `M` an `R`-module, `f : R`, finite `g : ι → R` with `D(f) = ⨆ᵢ D(gᵢ)` and `p>0`, the
  positive-degree section Čech homology of `~M` over `{D(gᵢ)}` is zero.
- **Recipe (route B, change-of-ring):**
  1. `{gᵢ/1}` spans `⊤` in `R_f = Localization.Away f` — `affine_cover_span_localizationAway` (DONE).
  2. Re-instantiate the polymorphic `private SectionCechModule.dDiff_exact` over `R_f` with `g/1`.
  3. Degreewise `M_{gσ} ≅ (M_f)_{gσ}` AddEquiv from public `AwayComparison.comparison` +
     `comparison_isLocalizedModule` (transitivity `M_a[1/b]=M_{ab}`); `gσ∈√(f)` witness from `D(gσ)⊆D(f)`.
  4. `Function.Exact.of_ladder_addEquiv_of_exact` (shape of `sectionCechAbExact`, ~line 1577); naturality
     mirrors `cechCoface_dToCech` (~line 941); wrap as `IsZero` homology (cf. `sectionCech_homology_exact`).
- **Mode:** mathlib-build, no sorry. ~5–8 lemmas. Co-located here to keep the `private` core in scope.
- **Rationale file:** `analogies/02kg-residual-changeofbase.md`.
- **Follow-up (iter-051):** pass as `htilde` to the `_of_tildeVanishing` forms in `AffineSerreVanishing.lean`
  → drop the hyp → unconditional `affine_cech_vanishing_qcoh` + `affine_serre_vanishing`.

## Lane 2 (INDEPENDENT) — `CechHigherDirectImage.lean` — P5a augmented resolution
- **Target:** new decl `AlgebraicGeometry.cechAugmented_exact` (does not yet exist). Pinned by
  `lem:cech_augmented_resolution`. Do NOT touch protected `cech_computes_higherDirectImage` / line-679 sorry.
- **Statement:** augmented Čech complex `0→F→C⁰→C¹→⋯` is exact (Čech nerve is a resolution of `F`).
- **Recipe (stalk-at-prime):** exactness is stalk-local; on affine `U=Spec A`, `F|_U≅~M`
  (`qcoh_iso_tilde_sections`, unconditional); localize at a prime `𝔭`; some `fᵢ∉𝔭` is a unit ⟹ contracting
  homotopy = the P3 standard-cover vanishing. Likely needs a "sheaf complex exact iff stalkwise exact"
  criterion — build project-side if absent. May need to construct the augmented cochain object + augmentation
  `F→C⁰` first.
- **Mode:** mathlib-build, no sorry. DEEP infra (effort ~1054) — partial + precise decomposition handoff is a
  valuable outcome.
