# Iter 030 — Objectives detail (Quot-Foundations)

Three import-independent prover lanes. Per-lane recipe + blueprint anchors below.

## Lane 1 — FBC (fine-grained): `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Blueprint: `chapters/Cohomology_FlatBaseChange.tex`. The effort-breaker `fbc-legs` split the crux into a
`.trans`-chain of 5 link sub-lemmas (chapter L1693–L1860). Scaffold + prove each as a NEW Lean decl, each
stated on **freshly-elaborated clean terms** (one `X.Modules` instance in scope ⇒ diamond absent ⇒ ≤30
LOC, term-mode `congrArg`/`Functor.congr_map`/`.trans`), then assemble.

- L1 `base_change_mate_fstar_reindex_legs_link_distribute` — expand the `(g')`-unit and distribute through
  `(Spec φ)_* ⋙ Γ` into five Γ-image factors. `\uses{…_unitExpand, …_gammaDistribute}`.
- L2 `…_link_collapseComp` — the two `pushforwardComp.hom` Γ-factors (F3 inner, F5 surviving) are `𝟙`;
  delete both (these are the `rfl`-trivial collapses). `\uses{…_inner_eCancel_pushforwardComp, …_gammaMap_pushforwardComp_hom_eq_id}`.
- L3 `…_link_cancelEUnit` — the `e`-unit cancels the inverse `e`-unit in the codomain read (genuine iso).
  `\uses{…_inner_eCancel_eUnit, …_codomain_read_legs}`.
- L4 `…_link_cancelPullbackComp` (G4) — trailing `pullbackComp.hom` cancels its inverse in `iso_g`.
  `\uses{…_inner_eCancel_pullbackComp, …_codomain_read_legs}`.
- L5 `…_link_survivor` — the lone affine `(Spec ιA)`-unit survivor = `ρ` (Seam-1 value through the tilde/Γ
  dictionaries). `\uses{…_unit_value, …_pushforward_spec_tilde_iso, def:…_inner_value}`.
- Target `base_change_mate_fstar_reindex_legs` @1335: (i) subst legs, (ii) Γ-collapse inv/congr coherences,
  (iii) `exact (L1.trans (L2.trans (L3.trans (L4.trans L5))))` — the ONE `exact` crosses the diamond by
  defeq. Cascade → `inner_value_eq`/`fstar_reindex` (bodies already `exact …`) → `gstar_transpose` @1695
  (same mechanism; Seams B/C closed).
- Recipe: `analogies/fbc-functorimage-diamond.md`. In-file precedents: `pullbackPushforward_unit_comp`
  (~1144), `…_gammaDistribute` (~1304), `…_inner_eCancel_pushforwardComp` (~1534). Validate one `.trans`
  link per `lean_multi_attempt` on a clean term before the final assembly.
- All genuine-content helpers already exist + proved in-file; the links are thin composable wrappers.
- Out of scope: affine @1968, FBC-B @2008. If a single link resists (likely L3/L4 vs the unfolded codomain
  read), report which link + goal state — that is a real handoff; re-break that link next iter.

## Lane 2 — QUOT gap1 (mathlib-build): `AlgebraicJacobian/Picard/QuotScheme.lean`

Blueprint: `chapters/Picard_QuotScheme.tex`, gap1 cone L2462–L3130. Corrected decomposition (analogist
`quot-transport`, `analogies/quot-gap1-transport.md`). Build order:

1. **C — `AlgebraicGeometry.Scheme.Modules.overRestrictIso`** (`lem:over_restrict_iso`, L2871; new decl):
   `M.over U ≅ M.restrict U.ι` — the `over U ↔ Spec R_r` bridge. The ONE lemma touching the slice site;
   guard with `set_option backward.isDefEq.respectTransparency false` (+ `#adaptation_note`) to tame the
   `(sheafToPresheaf (J.over …)).IsRightAdjoint` / `HasSheafify` synthInstance timeout (the
   `QuasicoherentData.bind` template, `Quasicoherent.lean:360`, is the worked precedent).
2. **P1 — per-affine local-tilde** (`lem:qcoh_affine_section_localization`, L2700): transport
   `q.presentation i` via `SheafOfModules.Presentation.map` (Mathlib, `Quasicoherent.lean:179`) +
   `overRestrictIso` + `pullback` of `D(r) ≅ Spec R_r`, then `isIso_fromTildeΓ_of_presentation`
   (`Tilde.lean:398`, no `Modules.` segment [verified iter-029]).
3. **D — `section_localization_descent`** (`lem:section_localization_descent`, L2955; the keystone): the
   sheaf-equalizer + flat-localization assembly (Stacks 01HA / Hartshorne II.5.3) producing the global
   `∀ f, IsLocalizedModule (powers f) (Γ(M,⊤)→Γ(M,D f))`. Uses `M.isSheaf`, finite cover (the in-file
   `exists_finite_basicOpen_cover_le_quasicoherentData`), `IsLocalization.flat`,
   `TopCat.Sheaf.existsUnique_gluing` [verified].
4. **Assemble gap1** `qcoh_affine_isIso_fromTildeΓ` (`lem:qcoh_affine_isIso_fromTildeΓ`, L3033) via the
   in-file `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (`QuotScheme.lean:653`, DONE). gap1 ⟹
   G1-core one-liner.
- Restriction functor `Scheme.Modules.restrictFunctor`/`pullback` (`Modules/Sheaf.lean`) EXISTS — do NOT
  hand-roll one. mathlib-build discipline: axiom-clean, no `sorry`; stop at the precise step + named-ingredient
  handoff if blocked.
- Out of scope: the 4 protected stubs, SNAP, annihilator forward direction.

## Lane 3 — GR-glue (mathlib-build): `AlgebraicJacobian/Picard/GrassmannianCells.lean`

Blueprint: `chapters/Picard_GrassmannianCells.tex` (`def:gr_glued_scheme`, `def:gr_chart_transition'`,
`lem:gr_chartTransition'_fac`). Sharpened (GR was no-output iter-029):

1. **FIRST** prove the cocycle ring identity `Φ=id` as a STANDALONE named lemma (pure ring, no scheme
   content / no instance diamond): `Φ := cocycleΘIJ(I,J,K) ∘ swap_J ∘ cocycleΘIJ(J,K,I) ∘ swap_K ∘
   cocycleΘIJ(K,I,J) ∘ swap_I` on `Localization.Away (minorDet I J · minorDet I K)`. Prove by
   `IsLocalization.ringHom_ext (powers (minorDet I J · minorDet I K))` → chart-ring generators → reuse
   `cocycle_imageMatrix_eq` (rotated analogue of `lem:gr_cocycle`). ~30–50 LOC.
2. Then the `cocycle` field (both internal `apXY.inv ≫ apXY.hom` pairs cancel via
   `simp [Iso.inv_hom_id_assoc]`, reducing to `Φ=id`), then `theGlueData` (`Scheme.GlueData` indexed by
   `{I // I.card = d}`: U/V/f/t/t_id/t'/t_fac/cocycle), then `Grassmannian.scheme := theGlueData.glued`.
- Diamond recipe (in-file, `chartTransition'_fac`): `erw` (defeq) + `exact congrArg`/`Iso.inv_comp_eq`; the
  `HasPullback` instance diamond makes `rw`/`simp` fail when terms mix def-originated + freshly-typed
  `awayPullbackIso`/`pullback.*`.
- Min bar: land the standalone `Φ=id` lemma + `cocycle`. Hand off the precise remaining `.glued` instance
  obligation if assembly stalls. If R3 produces no decl/sorry-stub → escalate to STUCK next iter.
