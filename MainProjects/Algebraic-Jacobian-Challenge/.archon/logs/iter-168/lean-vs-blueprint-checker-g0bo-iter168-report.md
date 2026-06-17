# Lean ↔ Blueprint Check Report

## Slug
g0bo-iter168

## Iteration
168

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (which covers `Genus0BaseObjects.lean` via the top-of-chapter `% archon:covers` directive)

## Per-declaration

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`)
- **Lean target exists**: yes (L108 `def ProjectiveLineBar`)
- **Signature matches**: yes — `Over (Spec (.of kbar))` object, encoded as `(ProjectiveLineBarScheme kbar).asOver _`. The bundled prose covers a triple (ℙ¹, 𝔾_a, 𝔾_m), but the `\lean{}` pin targets the headline `ProjectiveLineBar`; the sibling `\lean{}` pins below cover `Ga` and `Gm`.
- **Proof follows sketch**: N/A (definition, no proof body to compare)
- **notes**: prose says ℙ¹ is "the projective line — a smooth proper geometrically irreducible curve of genus 0". The smoothness/geom-irred instances in Lean (L175, L182) are still `sorry`, but the chapter is honest about ℙ¹ being a Mathlib-construction so this scaffold gap is acknowledged off-block. The two-chart cover the prose references ("two standard affine charts $\mathbb{A}^1 = \mathbb P^1 \setminus \{\infty\}$ and $\mathbb P^1 \setminus \{0\}$") is now built in Lean as `projectiveLineBarAffineCover` (L196), but is not pinned by any `\lean{}` block.

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`)
- **Lean target exists**: yes (L502 `abbrev Ga`)
- **Signature matches**: yes — `Over (Spec (.of kbar))`, built as `(GaScheme kbar).asOver _`, where `GaScheme := AffineSpace (Fin 1) (Spec (.of kbar))`. Matches "$\mathbb G_a = \mathbb A^1_{\bar k}$".
- **Proof follows sketch**: N/A
- **notes**: ✓

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`)
- **Lean target exists**: yes (L567 `abbrev Gm`)
- **Signature matches**: yes — `Over (Spec (.of kbar))`, built as `Spec (CommRingCat.of (Localization.Away (X () : MvPolynomial Unit kbar))).asOver _`. The Lean docstring at L41–46 is explicit that this is the AFFINE encoding (`Spec k̄[t, t⁻¹]`), NOT the basic-open of 𝔸¹. The blueprint prose says "$\mathbb G_m = \mathbb A^1 \setminus \{0\}$"; the two encodings agree as schemes but the Lean chose the affine path for `IsAffine` purposes. The prose phrasing is mathematically correct and not contradicted by the Lean encoding.
- **Proof follows sketch**: N/A
- **notes**: ✓

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`)
- **Lean target exists**: yes (L470)
- **Signature matches**: yes — `𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`. Built via `pointOfVec` (a wrapper over `Proj.fromOfGlobalSections`) with the evaluation `X 0 ↦ 0, X 1 ↦ 1`. Prose says "via `Proj.fromOfGlobalSections`"; Lean matches.
- **Proof follows sketch**: N/A
- **notes**: ✓ — axiom-clean per iter-166 close.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`)
- **Lean target exists**: yes (L476)
- **Signature matches**: yes — evaluation `X 0 ↦ 1, X 1 ↦ 1`, witness index `i = 0`.
- **Proof follows sketch**: N/A
- **notes**: ✓

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`)
- **Lean target exists**: yes (L482)
- **Signature matches**: yes — evaluation `X 0 ↦ 1, X 1 ↦ 0`, witness index `i = 0`.
- **Proof follows sketch**: N/A
- **notes**: ✓

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`)
- **Lean target exists**: yes (L633)
- **Signature matches**: yes — `η[Gm kbar]` (the `GrpObj` unit). Prose says "the unit map $\eta[\mathbb G_m]$"; Lean encodes exactly that.
- **Proof follows sketch**: N/A
- **notes**: depends on `gm_grpObj` (L622, currently `sorry`). The named point itself is fine — it's a definitional reference into a still-unfilled structure. Acceptable as scaffold.

### `\lean{AlgebraicGeometry.ga_grpObj}` (chapter: `def:ga_grpObj`)
- **Lean target exists**: yes (L537)
- **Signature matches**: yes — `instance ga_grpObj : GrpObj (Ga kbar)`.
- **Proof follows sketch**: N/A (definition stub) — currently `:= sorry`.
- **notes**: Body is `sorry`. Blueprint explicitly marks this as "on the demoted $\mathbb G_a$-additive companion route" (Lean docstring at L526–536 matches). The `def:ga_grpObj` block has no `\leanok` (correct: sorry-bodied). Acceptable status mismatch.

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`)
- **Lean target exists**: yes (L622)
- **Signature matches**: yes — `instance gm_grpObj : GrpObj (Gm kbar)`.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Body is `sorry`. Blueprint prose at `def:gm_grpObj` (L1034–1047) describes the encoding faithfully. Per the memory file [[genus0-aux-pile-discharged-iter167]] this is the lever currently 3-iter deferred with an escalation watch firing this iter; the blueprint pin is accurate to the still-unfilled target. Acceptable.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`)
- **Lean target exists**: yes (L659)
- **Signature matches**: yes — `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`. Prose at L1063–1082 describes the chartwise definition `(x, λ) ↦ λx` consistently with the Lean target shape.
- **Proof follows sketch**: N/A (definition stub) — `:= sorry`.
- **notes**: Body is `sorry`. The blueprint anchor also covers the companion $\mathbb G_a$-translation `σ` ("\lean name `gaTranslationP1` [expected]") which is **not yet a Lean target** — the chapter's `[expected]` annotation correctly flags this. The label-name mismatch (`def:gaTranslationP1` for the $\sigma_\times$ scaling action) is awkward historically but acknowledged in the iter-164/167 NOTE; no signature error.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`)
- **Lean target exists**: yes (L674)
- **Signature matches**: yes — the Lean equation `lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫ gmScalingP1 kbar = toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar` matches the prose statement of $\sigma_\times(0, \lambda) = 0$ in the encoded categorical form.
- **Proof follows sketch**: N/A — body is `sorry`.
- **notes**: Body is `sorry`; chapter has no `\leanok` for this block, which is correct.

## Red flags

### Placeholder / suspect bodies

The following bodies are `sorry` and the chapter is consistent (no `\leanok` on the corresponding block), so they are scaffold-acknowledged, not laundered:

- `projectiveLineBar_geomIrred` (L175) — `:= sorry`. **Blueprint silent** on this Lean-specific typeclass instance; only the bundled `def:genus0_base_objects` prose says "geometrically irreducible curve". Acceptable as a Mathlib-derivation scaffold; see "Blueprint adequacy" below.
- `projectiveLineBar_smoothOfRelDim` (L182) — `:= sorry`. **Blueprint silent**, same comment.
- `homogeneousLocalizationAwayIso_aux_left` (L368, `private`) — `sorry`. **Blueprint silent on the entire chart-ring iso machinery**. The Lean docstring (L350–367) is honest: "iter-168 partial: structural setup … gets us to the underlying `Localization.Away (X i)` comparison; the residual identity reduces to a monomial-by-monomial check …". Not an excuse comment — it is a transparent status note documenting which Mathlib bridge needs threading. This means the public `homogeneousLocalizationAwayIso` def at L378 *technically* propagates sorryAx and is not yet a confirmed ring iso (the chapter has no `\lean{}` pin to it, so the chapter does not claim it is).
- `ga_grpObj` (L537) — `:= sorry`. Anchored at `def:ga_grpObj`, no `\leanok`. Consistent.
- `gm_grpObj` (L622) — `:= sorry`. Anchored at `def:gm_grpObj`, no `\leanok`. Consistent.
- `gmScalingP1` (L659) — `:= sorry`. Anchored at `def:gaTranslationP1`, no `\leanok`. Consistent.
- `gmScalingP1_collapse_at_zero` (L674) — `:= sorry`. Anchored at `lem:gmScaling_fixes_zero`, no `\leanok`. Consistent.
- `gm_geomIrred` (L763) — `sorry`. **Blueprint silent** (no `\lean{}` pin); Lean docstring at L755–760 honestly identifies the Mathlib gap.
- `projGm_isReduced` (L795) — `sorry`. **Blueprint silent** (no `\lean{}` pin); Lean docstring at L779–790 honestly identifies the Mathlib gap.

None of these are placeholders for a blueprint-claimed substantive body that the chapter calls closed. All are scaffold-acknowledged, no laundering.

### Excuse-comments

- **L708–712 (`projectiveLineBar_isReduced`)**: docstring opens with "**`ℙ¹` is reduced.** Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)` … would close via `IsReduced.of_openCover` …)". **The body is no longer a sorry** (iter-168 closed it axiom-clean per the directive — proof body at L719–753 actually executes the described strategy). The "scaffold sorry" framing is now factually false. This is stale documentation, not an excuse for wrong code (the code is correct), but a reader skimming the docstring would conclude the instance is still unfilled. Severity treated as **major** under the spec ("comments that are stale but not actively misleading"); borderline-misleading because the docstring's first line directly contradicts the closed proof body that follows it.
- **L680–696 (section header for "(E) Product-stability instances on `ℙ¹ ⊗ 𝔾_m`")**: also calls `ℙ¹` is reduced a "scaffold (Mathlib gap: `IsReduced (Proj 𝒜)` …)". Same staleness: iter-168 closed it. Should be refreshed alongside the `projectiveLineBar_isReduced` docstring.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations in the file. No `Classical.choice _` patterns used on substantive claims (`Classical` only appears in two `classical` tactics inside ordinary proof scripts, which is standard).

## Unreferenced declarations (informational)

The following declarations have no `\lean{...}` pin in the chapter. Most are helper-level (private, instance-class scaffolding) and acceptable; **bold** entries are substantive enough to warrant blueprint coverage.

Helpers and instance-derivations (acceptable as helpers):
- `projectiveLineBarGrading`, `projectiveLineBarGrading_gradedRing` (L78, L82) — ℕ-grading on $k̄[X_0, X_1]$.
- `ProjectiveLineBarScheme`, `projectiveLineBarScheme_canOver` (L94, L99) — the underlying scheme and `Over` structure; the public-facing `ProjectiveLineBar` is pinned.
- `projectiveLineBar_isProper` (L127) — Mathlib-derived properness instance; chapter prose says ℙ¹ is proper.
- `otherFin`, `otherFin_zero`, `otherFin_one`, `otherFin_ne` (L247–254) — private indexing helper for the chart-ring iso.
- `chartEvalRingHom` and its three simp lemmas (L259–276) — private ring-hom building block for the chart-ring iso.
- `kbarToAwayRingHom` (L293) — private base-ring map; building block.
- `homogeneousLocalizationAwayIso_aux_right` (L315) — private round-trip lemma.
- `ProjectiveLineBar.evalIntoGlobal`, `ProjectiveLineBar.irrelevant_map_eq_top`, `ProjectiveLineBar.pointOfVec` (L401, L409, L436) — private $\bar k$-point constructor; the three public points (`zeroPt`/`onePt`/`inftyPt`) are pinned and reduce to this helper.
- `GaScheme`, `gaScheme_canOver`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced`, `ga_smooth` (L491–545) — Mathlib-derived underlying scheme + property instances on `Ga`.
- `GmRing`, `GmScheme`, `gmScheme_canOver`, `gm_isAffine`, `gm_locallyOfFinitePresentation`, `gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_smooth` (L551–629) — same for `Gm`.

**Substantive but unpinned (flagged):**
- **`projectiveLineBarAffineCover` (L196)** — the 2-chart affine open cover via `Proj.affineOpenCoverOfIrrelevantLESpan`. The blueprint prose at `def:genus0_base_objects` mentions "the two standard affine charts" but no `\lean{}` block pins this Lean target.
- **`homogeneousLocalizationAwayToMvPoly` (L280)**, **`mvPolyToHomogeneousLocalizationAway` (L303)**, **`homogeneousLocalizationAwayIso` (L378)** — the chart-ring iso machinery, the new iter-168 substantive infrastructure. **Not mentioned at all in the chapter**; the blueprint has no roadmap node describing this as a sub-build.
- **`projectiveLineBar_isReduced` (L719)** — NEW substantive iter-168 closure (chart-cover + chart-domain + `Function.Injective.isDomain` argument). **Not pinned**. The chapter's existing `\lean{}` blocks are silent on reducedness of ℙ¹.
- `projGm_locallyOfFiniteType` (L702), `projGm_geomIrred` (L773) — Lane-B product-instance exports, axiom-clean. Not pinned, but borderline acceptable since they are typeclass-glue around the abelian-rigidity consumer in `AbelianVarietyRigidity.lean`.

## Blueprint adequacy for this file

- **Coverage**: 11 of the file's substantive declarations are pinned via `\lean{...}` blocks (the 3 ℙ¹-points, the 3 main objects ℙ¹/𝔾ₐ/𝔾_m, the 1 𝔾_m unit point, the 2 `GrpObj` instances, the scaling action and its fixed-point lemma). The 4 new iter-168 substantive declarations (`projectiveLineBarAffineCover`, `homogeneousLocalizationAwayToMvPoly`/`mvPolyToHomogeneousLocalizationAway`/`homogeneousLocalizationAwayIso`, `projectiveLineBar_isReduced`) plus the 2 instance-scaffolds (`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`) and the 3 Lane-B product exports are unpinned. So Coverage ≈ 11 pinned + ~10 substantive helpers acceptable + 4 newly substantive unpinned (flagged) + 5 instance scaffolds (acceptable).
- **Proof-sketch depth**: **adequate** for everything currently pinned. The chapter gives chart-level prose for `gmScalingP1` and a one-line chart computation for `gmScalingP1_collapse_at_zero`; that is enough to guide formalisation, and the iter-166 NOTE already flags the structural-only split in the consuming proof. **Under-specified for the chart-ring iso sub-build**: there is no blueprint node describing the iso $\mathrm{Away}\,\mathcal A\,(X_i) \cong k̄[u]$ that the Lean prover is now visibly building (forward map, inverse map, two round-trips, `RingEquiv.ofRingHom`). A future prover reading only the chapter would not know this iso is part of the roadmap.
- **Hint precision**: **precise** for the 11 currently pinned declarations — every `\lean{...}` pins a single Lean target whose signature matches the prose. No "smooth vs SmoothOfRelativeDimension"-style guess work was demanded; the chapter prose and Lean instances agree.
- **Generality**: **matches need** — the pinned shapes are exactly what the upstream `morphism_P1_to_grpScheme_const` (in `AbelianVarietyRigidity.lean`) consumes. The blueprint correctly notes the Lean signatures are sometimes strictly more general than the prose (e.g. `[GrpObj A] [IsProper A.hom]` instead of full abelian variety on the target of `hom_additive_decomp_of_rigidity`), and the NOTE comments capture that.
- **Recommended chapter-side actions** (for the blueprint-writer next iter):
  - **Add a `\lean{...}` block for `projectiveLineBar_isReduced`** as a Mathlib-gap-bridge sub-lemma inside section (E)/the chart-cover narrative. The Lean docstring's strategy (chart cover → chart-ring is a domain via `Function.Injective.isDomain` + `IsLocalization.isDomain_localization`) is mathematically interesting and worth a short blueprint node.
  - **Add a roadmap subsection / `\lean{...}` blocks for the chart-ring iso** (`projectiveLineBarAffineCover`, `homogeneousLocalizationAwayToMvPoly`, `mvPolyToHomogeneousLocalizationAway`, `homogeneousLocalizationAwayIso`). Even a stub block per name, in a "formalisation infrastructure" subsection of `def:genus0_base_objects`, would make the chapter explain why the chart-ring iso is being built (it is the natural bridge to use Mathlib's `Localization.Away`-domain to populate `IsReduced (Proj 𝒜)`-type instances on ℙ¹).
  - **Refresh the L708–718 docstring on `projectiveLineBar_isReduced`** so that the Lean side stops claiming "scaffold sorry" — the body is now axiom-clean (iter-168 substantive closure). This is a Lean-side edit (not a blueprint edit) and is therefore outside this checker's write-domain, but the chapter could amend the section-(E) introduction at L680–696 ("`ℙ¹` is reduced — scaffold (…)") to reflect the new status if/when section (E) gets its own blueprint hook.
  - Optionally pin the scaffold instances `projectiveLineBar_geomIrred` and `projectiveLineBar_smoothOfRelDim` with `\lean{...}` blocks so the blueprint surfaces them as named Mathlib-gap obligations, mirroring how `lem:rational_map_to_av_extends` is documented as a sub-build with its own status.

## Severity summary

- **must-fix-this-iter**: none.
  - No placeholder body where the chapter claims a substantive proof. Every sorry-bodied target in the file is either anchored at a `\leanok`-free block (acknowledged scaffold) or has no chapter pin at all.
  - No signature mismatch with the chapter prose for any pinned declaration.
  - No excuse-comments on declarations the blueprint claims are real.
  - No unauthorised axioms.
  - No weakened-wrong definitions.
- **major**:
  - **Missing `\lean{...}` references to substantive new iter-168 declarations**: `projectiveLineBarAffineCover` (L196), `homogeneousLocalizationAwayIso` and its forward/inverse maps (L280, L303, L378), and `projectiveLineBar_isReduced` (L719, the iter-168 substantive closure). These are substantive enough that the blueprint should reference them.
  - **Stale docstring on L708–718 (`projectiveLineBar_isReduced`)** calls a now-axiom-clean instance "Project-side scaffold sorry"; borderline misleading because the docstring's opening line directly contradicts the proof body that follows. Lean-side edit, outside the blueprint-writer's lane, but worth flagging here for the plan agent.
  - **Stale section docstring at L680–696** lists "`ℙ¹` is reduced — scaffold" alongside the other product-stability scaffolds, but `projectiveLineBar_isReduced` is no longer a scaffold. Lean-side; same flagging note.
- **minor**:
  - `projectiveLineBar_geomIrred` and `projectiveLineBar_smoothOfRelDim` are unpinned Lean-specific scaffolds that the chapter could promote to named blocks; not load-bearing for the current critical path.
  - `gm_geomIrred` and `projGm_isReduced` are Lane-B product-stability sorries that are typeclass-glue around `AbelianVarietyRigidity.lean` consumers; the chapter's section-(E) docstring (Lean side) covers them honestly, but no blueprint pins exist. Acceptable as helpers.
  - `projGm_locallyOfFiniteType` and `projGm_geomIrred` (the axiom-clean Lane-B exports) are likewise acceptable unpinned glue.

Overall verdict: **CONVERGING** — file is faithful to the chapter for every currently pinned declaration; iter-168 added substantive new infrastructure (chart-ring iso + axiom-clean `projectiveLineBar_isReduced`) that the chapter does not yet cover and should pin, plus left two stale Lean docstrings that still call a now-closed proof "scaffold sorry". No must-fix-this-iter findings; three major items (missing pins + two stale docstrings) and a handful of minor coverage gaps that the next planning round should hand to the blueprint-writer.
