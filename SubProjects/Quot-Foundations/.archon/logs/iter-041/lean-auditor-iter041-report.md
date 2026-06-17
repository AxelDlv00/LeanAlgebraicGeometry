# Lean Audit Report

## Slug
iter041

## Iteration
041

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/QuotScheme.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 126/165/201/228 — the 4 protected scaffold `sorry`s are present and correctly labelled as file-skeleton placeholders in their docstrings. Out of scope per directive; not re-reported.
  - **`set_option maxHeartbeats 1600000 in` (line 2058)** — wraps `section_localization_hfr_aux`. The immediately preceding comment ("Large multi-step assembly (localization combiner + `eqToHom` open-transport); needs headroom.") is accurate: the proof body assembles six typeclass-heavy `IsLocalizedModule` steps and three `eqToHom` open-transport isos, all feeding `isLocalizedModule_powers_transport`. 1600000 is 2× the default (800000); it is justified and not masking a fragile proof.
  - **Pre-existing `set_option maxHeartbeats 2000000` blocks** (lines 1100, 1163, 1233, 1252, 1281) — all pre-existing, all accompanied by `synthInstance.maxHeartbeats 800000` and `backward.isDefEq.respectTransparency false`. Each is justified by the `SheafOfModules.Presentation.map` typeclass synthesis blow-up across the `overEquivalence` functor, explicitly noted in comments. Not new this iteration, not problematic.
  - **`section_localization_hfr_aux` opaque-`j` device (line 2075)**: The opaque hypothesis is the function signature parameter `j : Spec S ⟶ Spec R [IsOpenImmersion j]` — an *abstract* open immersion. There is no concrete composite unfolded inside the proof. The wrapper `section_localization_hfr_basicOpen` (line 2198) instantiates `j` at `compositeBasicOpenImmersion M q s i hs` (line 2206); all three auxiliary hypotheses (`hP1`, `hf'`, `eT`, `eB`) are produced by separate named lemmas (`pullback_composite_immersion_isIso_fromTildeΓ`, `σ.apply_symm_apply _`, `(Scheme.Hom.image_top_eq_opensRange j).trans compositeBasicOpenImmersion_opensRange`, `image_basicOpen_eq_inf`) — no hidden defeq shortcut.
  - **`hf'` proof in `section_localization_hfr_basicOpen` (line 2217)**: `σ.apply_symm_apply _` is the standard `RingEquiv.apply_symm_apply` applied to `f' := σ.symm (algebraMap R A f)`. This is a genuine propositional proof that `σ(σ.symm x) = x`, not a `rfl` on a nontrivial claim. The nontrivial content (that `j.appIso ⊤ . inv` coincides with `σ`) is baked into the definition of `σ` using `gammaImageRingEquiv j ⊤`.
  - **`image_basicOpen_of_affine` (line 2027), `compositeBasicOpenImmersion_image_basicOpen` (line 2038), `image_basicOpen_eq_inf` (line 2051)**: All fully proved, thin geometry helpers. No issues.
  - **`isLocalizedModule_basicOpen_descent` (line 2240)**: Fully proved, thin orchestration of `isLocalizedModule_basicOpen_descent_of_basicOpen_cover`. No issues.
  - **`isIso_fromTildeΓ_of_isQuasicoherent` (line 2261)**: One-line wrapper, fully proved. No issues.
  - **No `test_sorry_marker` or other debug/scaffold markers** found anywhere in the file.

---

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (ongoing, correctly described)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **New `simp only` stage at lines 1829–1830** in `base_change_mate_fstar_reindex_legs_conj`: collapses `gammaMap_pushforwardComp_inv_eq_id` (the `.inv` coherence) and `gammaMap_pushforwardCongr_hom` (the `pushforwardCongr` coherence → `eqToHom`). The comment block (lines 1816–1848) accurately describes both what succeeds and what does not: the `.hom` form `gammaMap_pushforwardComp_hom_eq_id` is reported to not match in the discrimination tree (probed iter-041), leaving the third coherence uncollapsed. Comment is honest about the partial nature ("PARTIAL") and explicitly names the asymmetric gap.
  - **`sorry` at line 1848**: The open sorry is the known "4-iter blocker" — the cross-layer core that requires assembling a multi-adjunction `conjugateEquiv`. The comment labels it accurately as "REMAINING (the heaviest node)" and does not misrepresent the proof state as closed.
  - **Sorry-backed transitive dependency acknowledged (lines 2237–2240 and 2301–2305)**: The comment in `base_change_mate_gstar_transpose` explicitly says `base_change_mate_fstar_reindex` "is currently sorry-backed (its `…_legs` apparatus carries a dead `sorry`), so this content must be REPROVEN INLINE here, not cited". This is accurate and honest — the sorry-backed lemma is not invoked as if proven.
  - **`set_option maxHeartbeats 4000000 in` at lines 1751 and 1852**: Both pre-existing; justified by post-`subst` `whnf` load during defeq matching of the `pullbackSpecIso`/`TensorProduct.include*` composites. No new heartbeat overrides introduced this iteration.
  - **No new sorry-backed lemma cited as proven.** The `sorry` at line 2315 (in `base_change_mate_gstar_transpose`) is a separate pre-existing open obligation; the comment identifies `base_change_mate_extendScalars_inner_value_counit` (step b) as axiom-clean while correctly tagging the inline Seam-2 reindex (step a) as requiring reproof rather than citing the sorry-backed `base_change_mate_fstar_reindex`.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

None.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 0
- **excuse-comments**: 0

Overall verdict: Both files are clean for the work added this iteration; all new declarations in `QuotScheme.lean` are fully proved and the opaque-`j` wrapper is instantiated honestly; the `FlatBaseChange.lean` edit adds a partial `simp` stage with an honest comment, correctly acknowledges the residual `sorry`, and does not cite sorry-backed lemmas as proven.
