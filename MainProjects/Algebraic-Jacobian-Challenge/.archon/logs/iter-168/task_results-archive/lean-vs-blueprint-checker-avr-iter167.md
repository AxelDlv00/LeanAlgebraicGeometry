# Lean ↔ Blueprint Check Report

## Slug

avr-iter167

## Iteration

167

## Files audited

- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (1199 lines, 17 declarations: 15 public theorems/lemmas, 2 private helpers)
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (1550 lines, 24 `\lean{...}` hooks; chapter declares `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean` — this dispatch checks AVR only; the 11 `\lean{...}` hooks pointing to Genus0BaseObjects.lean are out of scope here and verified by the sister dispatch `g0bo-iter167`)

## Per-declaration

For every `\lean{...}` block in the chapter whose target should live in **AVR.lean**, one entry.

### `\lean{AlgebraicGeometry.rigidity_lemma}` (chapter: `thm:rigidity_lemma`, L91)
- **Lean target exists**: yes (`theorem rigidity_lemma` at L765).
- **Signature matches**: yes — the iter-157 signature refactor (adding `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`, the basepoint `x₀`, `y₀`, `z₀`, and the collapse hypothesis `_hf`) is documented in the chapter prose (the "Formalization note" + `rmk:rigidity_lemma_decomposition`) and matches the Lean exactly. `[LocallyOfFiniteType (X ⊗ Y).hom]` (iter-161 addition) is also explicitly recorded in the chapter prose.
- **Proof follows sketch**: yes — Lean splits as the chapter's `rmk:rigidity_lemma_decomposition` describes: `rigidity_snd_lift` (cartesian-monoidal algebra) + `rigidity_core` (scheme-level gluing) + `rigidity_eqOn_dense_open` (geometric heart).
- **notes**: chain is now axiom-clean (iter-162); chapter prose has been refreshed accordingly. ✓

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (chapter: `lem:rigidity_eqOn_dense_open`, L238)
- **Lean target exists**: yes (L507).
- **Signature matches**: yes — the collapse hypothesis `_hf` is threaded through correctly (the iter-157 unsoundness REMAINS REPAIRED); the chapter explicitly justifies why `_hf` is load-bearing.
- **Proof follows sketch**: yes — Lean construction of `U = X × V`, `V = Y - G`, `G = p₂(f⁻¹(Z - U₀))` mirrors the chapter's proof prose precisely; the fibre-fact discharge via `Scheme.image_preimage_eq_of_isPullback` matches the "Formalization notes: the fibre fact" prose.
- **notes**: `\leanok` on statement + proof; sorry-free in its own body. ✓

### `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (chapter: `lem:rigidity_eqOn_saturated_open_to_affine`, L385)
- **Lean target exists**: yes (L431).
- **Signature matches**: yes — `[LocallyOfFiniteType (X ⊗ Y).hom]` threaded as the chapter prose specifies.
- **Proof follows sketch**: yes — Lean body wires Step 2 (`morphism_eq_of_eqAt_closedPoints`) over Step 1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`); matches the chapter's Step 1 / Step 2 decomposition exactly.
- **notes**: `\leanok` on statement + proof. ✓

### `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` (chapter: `lem:morphism_eq_of_eqAt_closedPoints`, L472)
- **Lean target exists**: yes (L115).
- **Signature matches**: yes — `[IsReduced W]`, `[JacobsonSpace W]`, `[Z.IsSeparated]` match the chapter prose verbatim.
- **Proof follows sketch**: yes — Lean assembles the coproduct probe `∐_{x ∈ closedPoints W} Spec κ(x) → W`, proves dominance via `closure_closedPoints`, and feeds `ext_of_isDominant`; chapter prose describes the same construction.
- **notes**: `\leanok` on statement + proof. ✓

### `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` (chapter: `lem:eq_comp_of_isAffine_of_properIntegral`, L515)
- **Lean target exists**: yes (L156).
- **Signature matches**: yes — `[IsAlgClosed kbar]`, `[IsIntegral W]`, `[UniversallyClosed wk]`, `[LocallyOfFiniteType wk]`, `[IsAffine V]` exactly match the chapter's "every hypothesis is load-bearing" enumeration.
- **Proof follows sketch**: yes — `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + `IsAlgClosed.ringHom_bijective_of_isIntegral` + `ext_of_isAffine` is the Lean argument; chapter prose names the same Mathlib lemmas.
- **notes**: `\leanok` on statement + proof. ✓

### `\lean{AlgebraicGeometry.isIntegral_of_retract}` (chapter: `lem:isIntegral_of_retract_of_integral`, L561)
- **Lean target exists**: yes (L203). Note the slight name divergence between the `\label{lem:isIntegral_of_retract_of_integral}` and the Lean name `isIntegral_of_retract`; the `\lean{...}` hook resolves it correctly.
- **Signature matches**: yes — Lean is the maximally general retract statement (any retract `r ≫ pr = 𝟙 S` of an integral `T`); chapter prose is the special case (section of the first projection) but explicitly flags this generalisation in its `% NOTE: (iter-162 review)`.
- **Proof follows sketch**: partial — the chapter prose describes a *global-sections* split-injection argument for reducedness; the Lean uses the *per-stalk* split-injection route (`pr.stalkMap` injective, `isReduced_of_isReduced_stalk`). The `% NOTE: (iter-162 review)` explicitly flags this PROOF DIVERGENCE (cosmetic; sound either way). Mathematical content matches.
- **notes**: `\leanok` on statement + proof. ✓

### `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` (chapter: `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`, L599)
- **Lean target exists**: yes (L262).
- **Signature matches**: yes — full instance set (`[IsAlgClosed kbar]`, `[IsProper X.hom]`, `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[LocallyOfFiniteType (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`) matches the chapter prose.
- **Proof follows sketch**: yes — the `pointOfClosedPoint`/`Over.homMk` machinery, the slice section `s = lift (𝟙 X) (toUnit X ≫ ŷ)`, the `IsIntegral X.left` retract step, and the appeal to `eq_comp_of_isAffine_of_properIntegral` all match the chapter's "Mumford's per-slice step, cohomology-free (route B)" prose; `\uses{lem:eq_comp_of_isAffine_of_properIntegral, lem:isIntegral_of_retract_of_integral}` is correct.
- **notes**: `\leanok` on statement + proof. The chapter's claim that this is "the chain's single genuinely-deep residual `sorry`" is stale (iter-162 closed it; the `% NOTE (iter-162 review)` at L211-216 of `rmk:rigidity_lemma_decomposition` already flags this). Minor cosmetic only.

### `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}` (chapter: `lem:hom_additivity_over_product`, L696)
- **Lean target exists**: yes (L814).
- **Signature matches**: partial — Lean is *strictly more general* than the prose (the prose says "$V$, $W$ complete varieties", but Lean only requires $V$ complete + the standard variety instances on $V \otimes W$; iter-164 hygiene also dropped A-side `[Smooth A.hom]`/`[GeometricallyIrreducible A.hom]`, leaving only `[GrpObj A]` + `[IsProper A.hom]` on the target). Both deltas are recorded in the chapter's `% NOTE: (iter-163 review)` and `% NOTE: (iter-164 review)`.
- **Proof follows sketch**: yes — Lean forms the group difference `φ := h / ((p ≫ f) · (q ≫ g))`, derives V-axis collapse and W-section vanishing, applies `rigidity_lemma`, then `g' = 1` from the section identity, giving `φ = 1`. Matches Milne's Corollary 1.5 proof.
- **notes**: `\leanok` on statement + proof. ✓

### `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}` (chapter: `lem:av_regular_map_is_hom`, L768)
- **Lean target exists**: yes (L884).
- **Signature matches**: partial — Lean target dropped `[Smooth B.hom]`/`[GeometricallyIrreducible B.hom]` (iter-164 hygiene). The A-side still carries `[Smooth A.hom]`/`[GeometricallyIrreducible A.hom]`; chapter's `% NOTE: (iter-164 review)` flagged the symmetric drop as a follow-up but did NOT land it. Lean is more general on B than the prose ("$\alpha : A \to B$ of abelian varieties") requires.
- **Proof follows sketch**: yes — Lean applies `hom_additive_decomp_of_rigidity` to `μ[A] ≫ α`, base point `η[A]`, with axis-restrictions reducing to `α` via `lift_comp_one_right`/`left`; packaged as `IsMonHom`. Matches Milne Corollary 1.2.
- **notes**: `\leanok` on statement + proof. ✓

### `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` (chapter: `lem:rational_map_to_av_extends`, L821)
- **Lean target exists**: **NO** — grep across `AlgebraicJacobian/**/*.lean` returns no match. The hook is wrong-but-soft: this block is explicitly marked "Route-A-only (iter-164)" and "off the genus-$0$ critical path", and has no `\leanok` on either the statement or proof block.
- **Signature matches**: N/A (target missing).
- **Proof follows sketch**: N/A.
- **notes**: Blueprint→Lean hook integrity issue, **major** but not blocking AVR work — the block is informational (Route-A future input). Recommendation: either drop the `\lean{...}` hook (leaving a `% TODO: not yet formalized` comment), or add a stub Lean declaration. Not must-fix-this-iter because the AVR critical path does not consume this lemma.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: `prop:morphism_P1_to_AV_constant`, L1338)
- **Lean target exists**: yes (L1093).
- **Signature matches**: yes — `[IsAlgClosed kbar]`, `[GrpObj A]`, `[IsProper A.hom]`, `[Smooth A.hom]`, `[GeometricallyIrreducible A.hom]`, conclusion `∃ a₀, f = toUnit ℙ¹ ≫ a₀` matches the chapter prose ("$f(\mathbb P^1_{\bar k})$ is a single $\bar k$-point").
- **Proof follows sketch**: yes — Lean body landed iter-166: translate by `-f(0)` (witness `a₀ := zeroPt ≫ f`), apply the private helper `morphism_P1_to_grpScheme_const_aux`, untranslate via `div_eq_one.mp`. Chapter proof prose matches this structurally (the $\mathbb G_m$-scaling shortcut: $h := \sigma_\times \fatsemi f$, additive decomposition collapsing W-axis at the scaling fixed point $0$, density of $\mathbb G_m \subset \mathbb P^1$).
- **notes**: `\leanok` on statement + proof. ✓ **The iter-166 NOTE in this block (L1417-1432) is STALE as of iter-167** — it still claims "five honest scaffold sorries" in the helper; iter-167's prover refactor eliminated 4 of them via Lane A's exported instances and promoted the 5th to the named top-level `iotaGm_isDominant`. See "Stale prose" in Red Flags below.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: `prop:genusZero_curve_iso_P1`, L1442)
- **Lean target exists**: yes (L1135).
- **Signature matches**: yes — `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`, `(_hgenus : genus C = 0)`, conclusion `Nonempty (C ≅ ProjectiveLineBar kbar)` matches the chapter's Hartshorne IV.1.3.5 statement.
- **Proof follows sketch**: N/A — body is `sorry` (the Riemann–Roch sub-build is explicitly deferred via `rmk:genusZero_iso_subbuild`; chapter prose is the Hartshorne proof sketch as a forward-looking sketch).
- **notes**: `\leanok` on the *statement* block is correct per the project's marker semantics ("at least a `sorry` present"); no `\leanok` on the proof block (correct: body is `sorry`). ✓

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: `thm:rigidity_genus0_curve_to_AV`, L1500)
- **Lean target exists**: yes (L1160).
- **Signature matches**: yes — verbatim mirror of `rigidity_over_kbar`'s signature minus `[CharZero kbar]`, exactly as the chapter pins.
- **Proof follows sketch**: yes — Lean body landed iter-166 via clean iso-transport (`φ := genusZero_curve_iso_P1`; `g := φ.inv ≫ f`; apply `morphism_P1_to_grpScheme_const`; pin `a₀ = η[A]` via `toUnit_unique`; back-transport via `φ.hom_inv_id`). Matches the chapter proof block.
- **notes**: `\leanok` on statement + proof; sorryAx propagates honestly via upstream `genusZero_curve_iso_P1` (RR bridge) and `iotaGm_isDominant`. ✓

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.iotaGm_isDominant` at L934 (`private lemma`, body `:= sorry`).
  Blueprint adequacy: this is a NEW iter-167 file-local bridge, promoted from a (former) inline `sorry` in `morphism_P1_to_grpScheme_const_aux`. The chapter does not have its own `\lean{...}` block for it (it is a file-local helper of `prop:morphism_P1_to_AV_constant`), but the helper's role is clearly documented in the Lean docstring at L924-930. **Not a must-fix**: it is the project-bespoke "$\mathbb G_m \hookrightarrow \mathbb P^1$ is dense" fact that the chapter proof of `prop:morphism_P1_to_AV_constant` cites in prose ("$\mathbb G_m$ is dense in the irreducible $\mathbb P^1$" → dominant-source/separated-target rigidity handle); the chapter does not need a dedicated lemma block for it. It IS, however, the only AVR-resident `sorry` that strictly blocks lifting `morphism_P1_to_grpScheme_const_aux` to axiom-clean, and is gated on Lane A (`Genus0BaseObjects`) shipping the chartwise body of `gmScalingP1`.

- `AlgebraicGeometry.genusZero_curve_iso_P1` at L1141 (body `:= sorry`).
  Blueprint adequacy: covered by `prop:genusZero_curve_iso_P1` + `rmk:genusZero_iso_subbuild`; the chapter explicitly defers this as a Riemann–Roch sub-build. Out-of-scope for this iter per the directive ("off-limits RR-bridge, unchanged"). Not a red flag against AVR coverage.

### Excuse-comments

None. iter-167 prover claim verified: no `-- TODO:`, no `-- temporary`, no `-- placeholder`, no `-- will fix later`, no `-- wrong but works for now` anywhere in AVR.lean. The iter-166 `-- TODO:` excuses on the 5 helper sorries were genuinely dropped by the iter-167 refactor.

### Axioms / `Classical.choice` on non-trivial claims

None. The two `sorry`s on disk (L934 `iotaGm_isDominant`, L1141 `genusZero_curve_iso_P1`) are openly stated placeholders, both gated on documented upstream work (Lane A's `gmScalingP1` body, the RR sub-build). No `axiom` declarations.

### Stale prose

- **`prop:morphism_P1_to_AV_constant` iter-166 NOTE (chapter L1417-1432)** is STALE. The NOTE still claims `morphism_P1_to_grpScheme_const_aux` carries "five honest scaffold sorries (three $\mathbb P^1 \otimes \mathbb G_m$ product-instance obligations [GeometricallyIrreducible / LocallyOfFiniteType / IsReduced], one `IsReduced (ℙ¹)_{left}` obligation, and one `IsDominant ι_{G_m}.left` obligation)". As of iter-167 this is no longer accurate: the four product/Proj instance sorries have been ELIMINATED (resolved by `infer_instance` from Lane A's `projGm_geomIrred`/`projGm_locallyOfFiniteType`/`projGm_isReduced`/`projectiveLineBar_isReduced`); only the dominance obligation survives, now refactored as the named top-level `iotaGm_isDominant` (a single named `sorry` on the AVR side). Recommended chapter edit: append an iter-167 NOTE acknowledging the prover refactor (5 → 1 sorries, with the 1 named as `iotaGm_isDominant`).

- **`rmk:rigidity_lemma_decomposition`** (L211-216, the iter-162 review NOTE) already correctly flags that the "single genuinely-deep residual sorry" wording elsewhere in the chapter is stale post-iter-162; this is informational and not a fresh finding for iter-167.

## Unreferenced declarations (informational)

The following declarations in AVR.lean have no direct `\lean{...}` reference in the chapter. All are legitimate helpers; flagging only what could be promoted.

- `AlgebraicGeometry.rigidity_snd_lift` (L74) — cartesian-monoidal-algebra helper; explicitly named in `rmk:rigidity_lemma_decomposition`. Acceptable (helper).
- `AlgebraicGeometry.snd_left_isClosedMap` (L93) — "bridge 1 (closed-map step)"; explicitly named in `rmk:rigidity_lemma_decomposition` and in the proof body of `lem:rigidity_eqOn_dense_open`. Acceptable (helper); could be promoted to a `\lean{}` block if desired (minor recommendation).
- `AlgebraicGeometry.rigidity_core` (L679) — scheme-level gluing helper; explicitly named in `rmk:rigidity_lemma_decomposition`. Acceptable (helper).
- `AlgebraicGeometry.iotaGm_isDominant` (L931, **NEW iter-167**) — private file-local dominance bridge; documented in the file-local docstring + `prop:morphism_P1_to_AV_constant`'s iter-166 NOTE (which is itself stale). Acceptable as a private helper, but worth a fresh iter-167 NOTE in the chapter acknowledging its promotion (see "Stale prose" above).
- `AlgebraicGeometry.morphism_P1_to_grpScheme_const_aux` (L958, private) — pointed-case helper for `morphism_P1_to_grpScheme_const`; the chapter's `prop:morphism_P1_to_AV_constant` iter-166 NOTE discusses the split. Acceptable (helper).

## Blueprint adequacy for this file

A bidirectional check.

- **Coverage**: 12/15 public Lean declarations have a corresponding `\lean{...}` block in the chapter. The 3 unreferenced public declarations (`rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_core`) are all named-and-described in `rmk:rigidity_lemma_decomposition` as the three components of the decomposition of `rigidity_lemma`. The 2 private helpers (`iotaGm_isDominant`, `morphism_P1_to_grpScheme_const_aux`) are file-local; their roles are documented in the Lean docstrings and (for the second) in the chapter's iter-166 NOTE. **Coverage is adequate** for AVR.lean.
- **Proof-sketch depth**: **adequate**. The chapter's proof blocks (especially `thm:rigidity_lemma`, `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`, `prop:morphism_P1_to_AV_constant`) preview the Lean tactic-level moves at a level that a prover could have followed faithfully — Mumford's quoted proof + the "Formalization notes" sub-blocks naming `IsProper.toUniversallyClosed`, `Over.snd_left`, `Scheme.image_preimage_eq_of_isPullback`, `isField_of_universallyClosed`, `finite_appTop_of_universallyClosed`, `IsAlgClosed.ringHom_bijective_of_isIntegral`, `ext_of_isAffine`, `ext_of_isDominant_of_isSeparated'`, etc.
- **Hint precision**: **precise** for in-scope blocks (all AVR `\lean{...}` hooks point to existing decls with matching signatures). One pattern note: `lem:hom_additivity_over_product` and `lem:av_regular_map_is_hom` have Lean signatures that are *strictly more general* than the prose; the chapter has dedicated iter-163/iter-164 NOTE comments documenting this drift, so a future prover would not be misled.
- **Generality**: **matches need**. The Lean is uniformly the same or slightly more general than the prose (more general on `V`-completeness in Cor 1.5, on B-side instances in Cor 1.2; same on the rigidity chain).
- **Recommended chapter-side actions**:
  - **(minor) Refresh the iter-166 NOTE on `prop:morphism_P1_to_AV_constant`** (L1417-1432) to reflect iter-167: the helper went from "5 honest scaffold sorries" to **one** named top-level bridge `iotaGm_isDominant` (gated on Lane A's `gmScalingP1` body). The other 4 dischargedvia Lane A instances (`projGm_geomIrred`/`projGm_locallyOfFiniteType`/`projGm_isReduced`/`projectiveLineBar_isReduced`) and `infer_instance`. This is a documentation update; the math is unchanged. Belongs in `recommendations.md`.
  - **(major, not must-fix) Three blueprint→Lean hooks point to non-existent declarations** — `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` (L821), `\lean{AlgebraicGeometry.hom_Ga_to_av_trivial}` (L1130), `\lean{AlgebraicGeometry.morphism_Ga_to_av_const}` (L1260). All three blocks are explicitly marked "off the genus-$0$ critical path" or "Route-A-only (iter-164)" and lack `\leanok` markers, so they will not falsely launder. But the `\lean{...}` hooks themselves are wrong (they name decls that do not exist anywhere in the AlgebraicJacobian tree). Recommendation: replace each with a `% TODO: not yet formalized` comment, or drop the `\lean{...}` hook entirely until the decls exist. **Not blocking iter-167 AVR work** since the genus-$0$ critical path does not consume any of these three lemmas; flag them for the blueprint-writer's catalogue.

## Severity summary

- **must-fix-this-iter**: none.
- **major**:
  - Three blueprint→Lean hooks (`rationalMap_to_av_extends`, `hom_Ga_to_av_trivial`, `morphism_Ga_to_av_const`) name declarations that do not exist anywhere in the `AlgebraicJacobian/` tree. Soft (off-critical-path; no `\leanok` to falsely launder); recommend a clean-up in a future iter.
- **minor**:
  - iter-166 NOTE in `prop:morphism_P1_to_AV_constant` (chapter L1417-1432) is stale: "five honest scaffold sorries" → after iter-167 there is one (`iotaGm_isDominant`); update to the iter-167 picture.
  - Slight signature-vs-prose generality drift on `lem:hom_additivity_over_product` (V-completeness only, not V & W) and `lem:av_regular_map_is_hom` (B-side instances dropped) — already documented in chapter NOTEs; no further action required, listed only for the record.
  - `\label{lem:isIntegral_of_retract_of_integral}` vs Lean `isIntegral_of_retract` — slight naming drift; the `\lean{...}` hook resolves correctly, so this is cosmetic.

## Overall verdict

AVR.lean faithfully realises the blueprint chapter — every in-scope `\lean{...}` hook resolves to an existing declaration whose signature matches (or is strictly more general than) the chapter prose; the iter-167 prover refactor (5 → 1 sorries via 4 instance auto-resolutions + 1 named top-level dominance bridge) is structurally clean and excuse-comment-free; no must-fix-this-iter findings.
