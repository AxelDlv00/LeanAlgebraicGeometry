# Iter-052 objectives (detail)

## Lane A — `AffineSerreVanishing.lean` — discharge 02KG tops (mathlib-build, CRITICAL)
- Build `affine_cech_vanishing_qcoh F : HasVanishingHigherCech (affineCoverSystem R) F` and the
  `affine_serre_vanishing` Ext-vanishing top, unconditional, by discharging `htilde` of the existing
  `_of_tildeVanishing` forms (lines 437 / 466).
- Glue: `htilde := fun n g f hcov p hp => sectionCech_homology_exact_of_localizationAway
  (moduleSpecΓFunctor.obj F) (fun i => g i.down) f hcov p hp`. Defeq: `cechCohomology U (toPsh.obj (tilde M))`
  = `(sectionCechComplex U (tilde M)).homology`; `0<p ↔ 1≤p`; `ι := ULift (Fin n)`.
- `sectionCech_homology_exact_of_localizationAway` from `CechAcyclic.lean` (transitively imported via
  `CechToCohomology → CechBridge → CechAcyclic`).
- Blueprint: `lem:affine_cech_vanishing_qcoh`, `lem:affine_serre_vanishing`,
  `lem:affine_cech_vanishing_tilde_subcover`.

## Lane B — `CechHigherDirectImage.lean` — `cechAugmented_exact` (mathlib-build, DEEP)
- Target: `cechAugmentedComplex 𝒰 F` exact (the augmented Čech complex is a resolution of qcoh `F`).
- Route (sections/sheafification, `analogies/stalkwise-exact-xmodules.md`):
  1. `cechAugmented_exact` from `∀ i, IsZero (homology i)`.
  2. homology-sheaf = sheafify(presheaf homology) via `homologyIsoSheafify`; locally zero on the affine basis
     (`sectionCech_affine_vanishing`) ⟹ 0 via `LocallyBijective` W-equivalences; reflect `IsZero` via faithful
     `toSheaf` (`reflects_exact_of_faithful`).
  3. presheaf-homology per open = `sectionCechComplex` homology (mapHomology-vs-sections plumbing; diamond-prone).
  4. augmentation node (deg 0) via `exact_of_isLocalized_span` / `combDifferential_exact`.
- Object layer already built (`cechAugmentedComplex` + companions). Reuse `qcoh_iso_tilde_sections`.
- Deep; mathlib-build may hand off a decomposition. Fallback = local "insert index i" homotopy over each `Uᵢ`.
- Blueprint: `lem:cech_augmented_resolution` (proof rewritten iter-052).

## Verification expectations
- Both lanes axiom-clean `{propext, Classical.choice, Quot.sound}`; no new sorry; project sorry stays = 2
  (the two frozen ones). Lane A should fully close; Lane B may PARTIAL with a decomposition handoff.
