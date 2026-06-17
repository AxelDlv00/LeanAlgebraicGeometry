# Iter 054 — Objectives (per-lane detail)

## Lane 1 — GF `FlatteningStratification.lean` [fine-grained] — CLOSE genericFlatness (deadline iter-055)
Build the B2 atomic chain (decls do not yet exist), then assembly + close.
- B2.1 `gf_crossChart_basicOpen_eq` — matched `(g,ḡ)` (`g|_O=ḡ|_O`, `D(g),D(ḡ)≤O=W∩W_j`) ⟹ `D(g)=D(ḡ)`; via
  `Scheme.basicOpen_res` [verified]. Pure geometry.
- B2.2 `gf_section_localization_twoleg` — `Γ(F,D(g)) = (powers g)⁻¹Γ(F,W) = (powers ḡ)⁻¹M_j`. Takes `ḡ` + the
  basicOpen-eq proof as EXPLICIT args. Two `qcoh_section_localization_basicOpen` legs + `IsLocalizedModule.iso`.
- B2.3 `gf_base_localization_comparison` — `Γ(S,U)` localization of `A_f` for general affine `U≤V`; via the
  integral scheme's function-field embedding. MAY weaken to "`A_f→R` flat" if `IsLocalization` awkward (note it).
- B2.4 `gf_crossChart_spanning_cover` (GEOMETRIC CRUX) — finite matched family `{(g_k,ḡ_k)}`, `D(g_k)=D(ḣ_k)⊆
  W∩W_{j(k)}`, `g_k` span unit ideal of `Γ(X,W)`. Common basic opens of two affines = basis of overlap +
  quasi-compact finite subcover. Re-break candidate `gf_common_basicOpen_basis`; search
  `IsAffineOpen.exists_basicOpen_le` / `PrimeSpectrum.isBasis_basic_opens` first.
- assembly: rewrite `gf_flat_locality_assembly` over `Module.flat_of_isLocalized_span` [verified] feeding
  B2.4+B2.2+B1+per-patch freeness. Then CLOSE `genericFlatness` (Step 4).
- Clean stale GAP-G1 (L2892–2900) + iter-diary (L539–545, L2843–2865) comments.

## Lane 2 — GR-quot `GrassmannianQuot.lean` [prove] — drop ≥1 declaration-sorry
- PRIMARY: close `functor`. Build `pullbackObjUnitToUnit_id` = `pullbackObjUnitToUnit(𝟙 T)=((pullbackId T).app
  unit).hom` (+`_comp`); both laws close by coproduct-`ext` over `free=∐unit`. Recipe: `homEquiv_unit` +
  `Equiv.symm_apply_eq` → `leftAdjointIdIso`/`conjugateEquiv_pullbackId_hom`. Keep `pullbackId` OPAQUE.
- SECONDARY: `glue` body — `overRestrictPullbackIso` + `existsUnique_gluing'`, C1/C2 in place. Term-mode.

## Lane 3 — SNAP `SectionGradedRing.lean` [mathlib-build] — ship the crux
- Build `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`): promote actN/actM/projL to nat.
  transformations of `Cᵒᵖ⥤AddCommGrpCat`, lift objectwise `isColimitCofork` (DONE) via
  `evaluationJointlyReflectsColimits` [verified], apex via `PresheafOfModules.Monoidal.tensorObj_obj` [verified].
- Discharge crux `isIso_sheafification_whiskerRight_unit` (coequalizer-preservation + `W` inverts ℤ-whiskered
  rows + `isIso_sheafification_map_iff`). Then `tensorObjAssoc` + `tensorPowAdd` ride.
- Escalate (no new helper layer) if promotion not Mathlib-constructible in 1 iter.
