# Blueprint Writer Report

## Slug
iter060

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task 1 — Coverage debt

**OpenImmersionPushforward side (4 new blocks):**
- **Added lemma** `\label{lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero}` /
  `\lean{AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero,
  AlgebraicGeometry.preadditiveCoyoneda_mapHomologicalComplex_d_apply}` — Ext-vanishing forces
  the coyoneda right-derived object to vanish. Proof sketch via `isoRightDerivedObj`
  (`lem:right_derived_injective_resolution`) + `extMk_eq_zero_iff` (`lem:ext_homcomplex_mathlib`).
  Private differential-apply helper bundled into the pin as directed.
- **Added lemma** `\label{lem:subsingleton_ext_of_iso_fst}` /
  `\lean{AlgebraicGeometry.subsingleton_ext_of_iso_fst}` — contravariant Ext-functoriality transfers
  subsingletons along an iso in the first argument. Sketch via `mk₀`/`comp_zero`.
- **Added lemma** `\label{lem:ext_jShriekOU_eq_zero_of_specIso}` /
  `\lean{AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso}` — the assembled Serre-vanishing leaf:
  spectrum Ext-transport + `EnoughInjectives.of_equivalence` + subsingleton-transfer +
  general-affine Serre vanishing. `\uses` exactly the six labels named in the directive.
- **Added lemma** `\label{lem:enoughInjectives_of_hasInjectiveResolutions}` /
  `\lean{AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions}` — connector: degree-0 term
  of a chosen injective resolution with its mono unit is an injective presentation.

**CechSectionIdentification side (2 pins + 1 block):**
- **Revised** `lem:prod_coproduct_distrib` — added
  `CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib` to the `\lean{}` pin (coproduct-in-first-arg
  form).
- **Added lemma** `\label{lem:overProd_coproduct_distrib_right}` /
  `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib_right}` — braiding-twin
  `A ⨯ (∐ Yᵢ) ≅ ∐ (A ⨯ Yᵢ)` in `Over S`, `\uses{lem:overProd_coproduct_distrib}`.
- **Revised** `lem:overProd_coproduct_distrib` — bundled the four structure-map-compat helpers
  `pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst`, `overSigma_hom_eq` into its `\lean{}` pin.

### Task 2 — Stale build-target comments
**No-op (already true).** The `% NOTE: build target. The Lean declaration does not exist yet.` comments
the directive expected on `lem:overProd_coproduct_distrib` (~7654) and `lem:coproduct_distrib_fibrePower`
(~7740) **do not exist** in the chapter — they were already removed in a prior round. Verified the
backing Lean decls (`overProd_coproduct_distrib`, `widePullback_coproduct_iso`) do exist. The only
remaining `% NOTE: build target ... does not exist yet` comments are on the five transport lemmas
(`lem:pushforward_commutes_free/_sheafify`, `lem:yoneda_transport_along_homeo`,
`lem:jshriek_transport_along_iso`, `lem:pushforward_iso_preserves_qcoh`), and those are **accurate** —
I confirmed none of those Lean declarations exist yet, so I left them in place.

### Task 3 — Expanded sketches
- **Revised** `lem:pushforward_iso_preserves_qcoh` proof — expanded from the one-liner to: (a)
  quasi-coherence as a local property checked on an affine cover (the module's `QuasicoherentData`);
  (b) pushforward along the iso of ringed spaces is transport of module data; (c) explicit by-hand
  transport of the local presentation across the homeomorphism (affine opens → affine opens via
  `lem:isAffineOpen_image_of_iso_mathlib`); (d) the `φ_* = (φ⁻¹)^*` pullback identification; (e) an
  explicit note that `Scheme.Modules.pushforward` has NO general qcoh-preservation lemma (only along
  iso / qcqs). Added `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source}` from Stacks Schemes "Functoriality
  for quasi-coherent modules" (items 1, 7, and the closing pushforward remark). Added
  `lem:isAffineOpen_image_of_iso_mathlib` to its `\uses`.
- **Revised** `lem:cech_backbone_left_sigma` proof — inserted the intermediate
  `lem:widePullback_overX_eq_prod` bridge step (slice-product normal form → wide-pullback form before
  `lem:widePullback_openImm_inter`); named the universe-reduction API (`Finite.equivFin` /
  `Fintype.equivFin`, `Sigma.whiskerEquiv` for the LHS coproduct reindex, `Equiv.arrowCongr` for the
  RHS multi-index codomain reindex). Added `lem:widePullback_overX_eq_prod` to its `\uses`.
- **Revised** `lem:coproduct_distrib_fibrePower` — added a "Slice-product normal form" prose note
  recording that the σ-component is `∏ᶜ (fun k => Over.mk (f (σ k)))`, connected to the wide fibre
  power by `lem:widePullback_overX_eq_prod`.

### Cross-references introduced (DAG wiring for accuracy)
- `lem:open_immersion_pushforward_comp` — added
  `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` and `lem:ext_jShriekOU_eq_zero_of_specIso`
  to both `\uses` blocks (its Lean acyclicity proof invokes both leaves).
- `lem:coproduct_distrib_fibrePower` — added `lem:overProd_coproduct_distrib_right` to both `\uses`
  blocks (its `widePullback_coproduct_iso` induction consumes it).
- `lem:cech_backbone_left_sigma` — added `lem:widePullback_overX_eq_prod` to both `\uses` blocks.

## Verification
- `leandag build --json`: `unknown_uses: []` (no broken refs). All 11 new `\lean{}` targets matched
  (isZero_coyoneda + private helper, subsingleton_ext, enoughInjectives, ext_jShriekOU,
  overProd_coproduct_distrib_right, coprodFirst_distrib, pcd_hom_fst/snd, cf_hom_fst, overSigma_hom_eq).
- `leandag query --isolated --chapter Cohomology_CechHigherDirectImage`: 0 isolated nodes.
- LaTeX balanced: 203 `\begin{lemma}`/203 `\end{lemma}`, 153/153 proofs.
- No `\leanok`/`\mathlibok` added or removed.

## References consulted
- `references/stacks-schemes.tex` — verbatim quote (L4729–4767) for the expanded
  `lem:pushforward_iso_preserves_qcoh`: Section "Functoriality for quasi-coherent modules", items (1)
  (qcoh is local on affine opens), (7) (pullback preserves qcoh), and the closing remark "it is in
  general not the case that the pushforward of a quasi-coherent module is quasi-coherent".
- `references/summary.md` — source index.

## Macros needed
- None. Used standard `\prod^{\mathrm{c}}` for the slice product `∏ᶜ`; no new macro required.

## Notes for Plan Agent
- The directive's Task 2 was based on a stale snapshot: the named NOTE comments were already gone.
  No edit was needed there. The real remaining build-target NOTEs are on the five transport lemmas
  (9414–9526), which are still accurate — leave them until those Lean decls land.
- `lem:ext_jShriekOU_eq_zero_of_specIso` depends on five other transport lemmas that are still
  build-targets (e.g. `lem:jshriek_transport_along_iso`, `lem:pushforward_iso_preserves_qcoh`); the
  leaf itself is proved in Lean but its blueprint dependencies remain unformalized — expected.

## Strategy-modifying findings
None.
