# Iter 053 — Objectives detail

## Lane 1 — GF `FlatteningStratification.lean` [mathlib-build]
Source-span descent chain (stalk route DEAD). Build bottom-up:
- B1.0 `gf_localizedModule_baseChange_tensor_comm` — `LocalizedModule T (N⊗_R K) ≅ (LocalizedModule T N)⊗_R K`.
  Route: localization = base change (`T⁻¹B ⊗_B M`) + tensor assoc. Search `IsLocalizedModule.isBaseChange` [exp].
- B1 `gf_flat_localizedModule_sameBase` — `[Flat R N]` ⟹ `Flat R (LocalizedModule T N)`, `T : Submonoid B`.
  B1.0 + exactness of localization. THE genuine Mathlib gap.
- B2 `gf_section_localization_flat_descent` — `Γ(F,D(g))≅(M_j)_ḡ` + `Γ(S,U)`⟂`A_f`. Reuse gap2 +
  `gf_qcoh_fintype_finite_sections` (both DONE).
- assembly `gf_flat_locality_assembly` — rewrite over `Module.flat_of_isLocalized_span` on `{D(g)⊆W∩W_j}`.
- CLOSE `genericFlatness` (Step 4 = assembly).
Do NOT build `gf_stalk_flat_over_base` (dead). Hard deadline iter-055.

## Lane 2 — GR `GrassmannianQuot.lean` [prove]
- `glue` body: descent via `overRestrictPullbackIso` + `existsUnique_gluing'`; C1/C2 + transport DONE.
  Term-mode under the diamond; keep immersions opaque.
- `functor` (`def:grassmannian_functor`): glue-INDEPENDENT; Setoid quotient of rank-`d` loc-free quotients +
  pullback functoriality; reuse `IsLocallyFreeOfRank`. Likely cheaper ≥1-sorry drop.
MUST drop ≥1 of the 5 sorries this iter (else STUCK iter-054).

## Lane 3 — SNAP `SectionGradedRing.lean` [mathlib-build]
- brick `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`): `P⊗_R Q` underlying ≅
  coequalizer(`P⊗_ℤ R⊗_ℤ Q ⇉ P⊗_ℤ Q`). Objectwise = TensorProduct quotient; promote to `Cᵒᵖ⥤AddCommGrp`.
- discharge crux `isIso_sheafification_whiskerRight_unit` (reduced to `J.W(toPresheaf.map(η_P▷Q))`): `a`
  preserves coequalizer + `(W AddCommGrp).monoidal`. Then `tensorObjAssoc`/`tensorPowAdd`.
Make-or-break; escalate if the brick is not Mathlib-constructible in 1 iter (no new helper layer).
