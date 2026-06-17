# Iter-054 objectives detail

## Lane 1 — `CechAugmentedResolution.lean` — close `cechAugmented_exact` residual `hSec` (line 180)
- **Target:** `IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)`, `GV = toPresheaf ⋙ eval(op V)`,
  `Kp = (forget ⋙ restrictScalars α).mapHomologicalComplex (cechAugmentedComplex 𝒰 F)`, `V ≤ coverOpen 𝒰 i`.
- **Recipe (blueprint Step 3 (a)–(e); `analogies/deepbridge.md` Decisions 1a/1b):**
  1. Identify the abstract section complex with the concrete cochain complex `D = ∏_σ Γ(coverInter σ ⊓ V, F)`
     (alternating-coface differential) via `Functor.mapHomologicalComplex` naturality + per-degree
     product-of-sections iso. [the L1-style identification — the genuine project work]
  2. `V ≤ coverOpen 𝒰 i_fix` ⟹ prepend `i_fix` is the IDENTITY on each section term
     (`coverInter (i_fix∷σ)⊓V = coverInter σ⊓V`). Build `HomologicalComplex.Homotopy (𝟙 D) 0` with component
     maps `combHomotopy i_fix` and relation field discharged by `combHomotopy_spec`.
  3. Close `IsZero (D.homology p)` ∀p via: `Homotopy.homologyMap_eq` + `HomologicalComplex.homologyMap_id`
     + `HomologicalComplex.homologyMap_zero` + `IsZero.iff_id_eq_zero`.
- **DEAD END:** ExtraDegeneracy (variance — simplicial ChainComplex only). Do NOT thread qcoh/affineness/tilde.
- **Mode:** mathlib-build (build the identification infra; no papered sorry; precise decomposition if blocked).

## Lane 2 — `OpenImmersionPushforward.lean` — close `_acyclic` (line 87) + `_comp` (line 128); re-sign `_comp`
- **Bridge (1) [attempt DIRECTLY — progress-critic: may be near-rfl]:** identify
  `(pushforwardResolutionPresheafComplex f I).homology n` (at V) with `Ext^n(jShriekOU(f⁻¹V), G)` via
  `InjectiveResolution.extAddEquivCohomologyClass` ∘ `CochainComplex.HomComplex.homologyAddEquiv.symm`, then
  degreewise `jShriekOU_homEquiv : (jShriekOU U ⟶ F) ≃+ Γ(U,F)` to turn the Hom-complex into the
  section/pushforward complex, with `InjectiveResolution.cochainComplexXIso` matching ℕ/ℤ indexing.
  `InjectiveResolution.isoRightDerivedObj` (already at HigherDirectImagePresheaf:164) settles the rightDerived side.
- **Bridge (2):** Serre-transport — `isAffineHom_of_affine_separated` ⟹ affine preimage `j⁻¹V` (resp. `U∩f⁻¹V`)
  ⟹ `isoSpec : j⁻¹V ≅ Spec Γ(j⁻¹V)` + naturality ⟹ `affine_serre_vanishing` kills `Hᵠ` (q≥1).
- **Bridge (3):** locally-zero ⟹ sheafification zero for `PresheafOfModules.sheafification (𝟙)`, via the
  `sheafificationCompToSheaf` square (analogue of the new `isZero_presheafToSheaf_of_locally_isZero`).
- **Re-sign:** `_comp` return type `Nonempty (A ≅ B)` → canonical `A ≅ B` (NOT protected; blueprint says `≅`).
- **Mode:** mathlib-build. Part (1) `_acyclic` first (needs only bridges 1–3); then `_comp` (adds the
  termwise f_*-acyclicity + `rightDerivedIsoOfAcyclicResolution` + `pushforwardComp` transport).

## Blueprint source of truth
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:
`lem:cech_augmented_resolution` (Step 3 (a)–(e)), `lem:open_immersion_pushforward_comp` (Bridges 1–3),
plus the 2 helper blocks + the `lem:ext_homcomplex_mathlib` anchor. Recipe analogy: `analogies/deepbridge.md`.
