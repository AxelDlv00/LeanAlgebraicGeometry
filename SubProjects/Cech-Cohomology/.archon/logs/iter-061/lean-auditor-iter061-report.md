# Lean Audit Report

## Slug
iter061

## Iteration
061

## Scope
- files audited: 2 (per directive)
- files skipped: 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor — see notes)
- **excuse-comments**: 0 flagged
- **notes**:
  - **`isIso_modules_of_toPresheaf` (lines 615–617)** — genuine one-liner: `isIso_of_reflects_iso φ (Scheme.Modules.toPresheaf X)`. `toPresheaf` reflects isomorphisms because it factors through a fully faithful functor; the Mathlib lemma applies directly. Not a Subsingleton/defeq launder. ✓
  - **`isIso_prodLift_of_isLimit` (lines 622–631)** — genuine proof. The strategy is: if `BinaryFan.mk α β` is a limit, the canonical map `h.conePointUniqueUpToIso (prodIsProd P Q)` is iso by the universal property; `heq` identifies it with `prod.lift α β` via `prod.hom_ext` + `conePointUniqueUpToIso_hom_comp`; then `infer_instance` closes. Tactic chain is well-directed and non-circular. ✓
  - **`coprodDecompMap` (lines 639–645)** — genuine definition: `prod.lift` of two adjunction unit components. The type is precisely the comparison map described in the Handoff. Not vacuous. ✓
  - **Handoff block (lines 647–680)** — accurately describes a real residual (`isIso_coprodDecompMap` is absent from the file by design; the Handoff correctly says the iso proof is unbuilt). The two blockers listed ((a) instance trap for `PreservesLimitsOfShape` on a composite functor, (b) `isProductOfDisjoint` cone-matching) are genuine mathematical obstacles. No false claims. ✓
  - **`pushPull_sigma_iso` sorry (line 729)** — goal type `pushPullObj F Y_p ≅ ∏ᶜ σ => pushPullObj F (Over.mk j_σ)` matches the surrounding Planner strategy block exactly. Honest sorry. ✓
  - **`pushPull_eval_prod_iso` sorry (line 820)** — goal is degreewise evaluation of the product, assembled from Stub 2 + Stub 3. Matches description. ✓
  - **`cechSection_complex_iso` sorry (line 890)** — goal type `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` matches the corrected blueprint target (augmented complex, not the non-augmented complex that was previously wrong). ✓
  - **`cechSection_contractible` sorry (line 949)** — goal `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0` correctly targets the *augmented* complex; consistent with prior audit correction. ✓
  - **`set_option` scoping** — line 363: `set_option maxHeartbeats 1600000 in` (scoped over `widePullback_coproduct_iso`) ✓; line 723: `set_option synthInstance.maxHeartbeats 800000 in` (scoped over `pushPull_sigma_iso`) ✓. Both use the `in` form.
  - **Minor** — `set_option synthInstance.maxHeartbeats 800000 in` at line 723 is scoped over a `sorry` declaration. The bump has no effect on a `sorry` body (there is no proof elaboration to time out). It was presumably added in anticipation of the real proof. Not harmful, but mildly misleading. See Minor section.
  - **Module-level docstring (lines 24–28)** accurately reflects the current file state: items 5 and 6 reference `.augment ε hε`, consistent with the actual signatures. Not stale. ✓
  - **`widePullbackBaseCongr` (lines 502–527)** — comment correctly explains why this is specialized to `Scheme` (universe pinning for `rw`/`simp`). ✓

---

### `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor code duplication — see notes)
- **excuse-comments**: 0 flagged
- **notes**:
  - **`coversTop_preimage_of_iso` (lines 403–412)** — genuine proof. Applies `hZ` at `⊤` with the transported point `φ.inv.base x`, destructs the sieve witness `⟨i, ⟨g⟩⟩`, derives `φ.inv.base x ∈ Z i` via `leOfHom g`, and builds a neighborhood `W ⊓ (φ.inv ⁻¹ᵁ Z i)` in the preimage sieve of `Y`. The final `exact hxZ` discharges the membership via the definitional equality `x ∈ φ.inv ⁻¹ᵁ Z i ↔ φ.inv.base x ∈ Z i`. Logic is sound. ✓
  - **`pushforward_iso_qcoh_of_slice_qcoh` (lines 425–434)** — genuine one-line proof: introduces `hslice` as a `haveI`, then applies `IsQuasicoherent.of_coversTop` with the preimage family, using `coversTop_preimage_of_iso` to transport the cover. Not vacuous. ✓
  - **`set_option` scoping at lines 414–415** — both options use `in`-scoped form and nest correctly:
    `set_option synthInstance.maxHeartbeats 1000000 in` scopes over `set_option maxHeartbeats 2000000 in <lemma>`, which scopes over the lemma itself. Not hiding an error: the proof body is a single `exact`, and the comment at lines 416–418 explains that `of_coversTop` triggers slow doubly-sliced `HasSheafify`/`WEqualsLocallyBijective` instance synthesis that legitimately times out at default heartbeats. The bumps are a recognized Mathlib-style workaround for slow synthesis, not a proof-correctness crutch. ✓
  - **`sorry` at line 588 (`hqc` case)** — goal is `((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).IsQuasicoherent`; the surrounding comment (lines 571–587) accurately characterizes the remaining obstacle as a cross-ring slice ring hom `ψ_r` for the per-slice presentation transport. Honest sorry. ✓
  - **`sorry` in `higherDirectImage_openImmersion_comp` (line 654)** — two residuals (a) j*-acyclicity and (b) f*-acyclicity for the pushed-forward injective terms. The comment at lines 636–653 gives a complete route; each gap is a genuine cohomological obligation that depends on `higherDirectImage_openImmersion_acyclic`'s own residual. Honest sorry. ✓
  - **`isZero_presheafToSheaf_of_sections_locally_zero` (lines 71–102)** — genuine proof: constructs `Z` (trivial presheaf), builds `IsLocallyInjective` for `0 : Q ⟶ Z` using the hypothesis, `IsLocallySurjective` trivially, then calls `isZero_presheafToSheaf_obj_of_isLocallyBijective`. Tactic chain is well-directed. ✓
  - **`isZero_of_faithful_preservesZeroMorphisms` (lines 42–49)** — duplicated from `CechAugmentedResolution.lean`, noted explicitly in the comment. This is a minor code duplication; see Minor section.
  - The comment explaining the `hqc` residual at lines 571–587 references `pushforward_iso_qcoh_of_slice_qcoh` (which IS built in this file) and `jShriekOU_transport_along_iso` (which IS built at line 391). No stale references. ✓
  - The `case hjt => exact jShriekOU_transport_along_iso U.isoSpec (j ⁻¹ᵁ W)` at line 570 references a declaration that exists (line 391). ✓

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `CechSectionIdentification.lean:723` — `set_option synthInstance.maxHeartbeats 800000 in` is attached to `pushPull_sigma_iso`, which currently has a `sorry` body. The bump has no effect on a `sorry` (no proof elaboration occurs). It was presumably placed in anticipation of the eventual proof, but as written it is a no-op. Not harmful; consider removing or keeping as documentation of expected synthesis cost.

- `OpenImmersionPushforward.lean:42–49` — `isZero_of_faithful_preservesZeroMorphisms` is a verbatim copy of a lemma in `CechAugmentedResolution.lean`, as the comment itself notes. If the import chain is extended or a shared utility file is introduced, this duplication should be resolved. Low priority given current import constraints.

---

## Excuse-comments (always called out separately)

None identified. The heartbeat comment at lines 416–418 (`-- The heartbeat bumps are required: ...`) is technical documentation of a genuine instance-synthesis delay, not an admission that the proof is wrong or temporary. It correctly states "it succeeds when bumped." Not an excuse-comment.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: Both files are clean. All three new declarations (`isIso_modules_of_toPresheaf`, `isIso_prodLift_of_isLimit`, `coprodDecompMap` in CechSectionIdentification; `coversTop_preimage_of_iso`, `pushforward_iso_qcoh_of_slice_qcoh` in OpenImmersionPushforward) are genuine proofs or definitions; all sorries are honest with accurate surrounding descriptions; no stale comments, no excuse-comments, no kernel-soundness traps; `set_option` heartbeat bumps are correctly `in`-scoped throughout.
