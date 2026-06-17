# Lean ↔ Blueprint Check Report

## Slug
g0bo-iter169

## Iteration
169

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (chapter declares
  `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean
  AlgebraicJacobian/Genus0BaseObjects.lean` near its top)

## Per-declaration

For each `\lean{...}` block in the chapter that names a `Genus0BaseObjects.lean`
target, the row below verifies existence + signature + body shape against the
prose. Other `\lean{...}` blocks in the chapter (rigidity-lemma chain,
hom-additivity, etc.) name declarations in `AbelianVarietyRigidity.lean` and are
out of scope per the directive.

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`, L913)
- **Lean target exists**: yes (L108).
- **Signature matches**: yes. Lean ships
  `def ProjectiveLineBar (kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`,
  i.e. `ℙ¹_k̄` as an object of `Over (Spec k̄)`. Prose pins exactly this.
- **Proof follows sketch**: N/A — this is a definition. Body
  `:= (ProjectiveLineBarScheme kbar).asOver (Spec (.of kbar))` with
  `ProjectiveLineBarScheme := Proj (projectiveLineBarGrading kbar)` is the
  `Proj 𝒜` realisation the prose pins.
- **notes**: chapter prose (L920-926) claims `ℙ¹` is a *smooth proper
  geometrically irreducible curve of genus 0*; on the Lean side `IsProper` (L127)
  is axiom-clean, while `GeometricallyIrreducible` (L175) and
  `SmoothOfRelativeDimension 1` (L182) are scaffold `sorry`s. The chapter does
  not separately pin those instances via `\lean{...}` blocks, so they're
  "prose-only" claims — informational, see Blueprint-adequacy section below.

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`, L949)
- **Lean target exists**: yes (L494, `abbrev Ga (kbar : Type u) [Field kbar] :
  Over (Spec (.of kbar))`).
- **Signature matches**: yes. Prose pins "$\mathbb G_a = \mathbb A^1_{\bar k}$
  as an object of $\mathrm{Over}\,(\Spec\bar k)$".
- **Proof follows sketch**: N/A. Body wraps
  `AffineSpace.{0,u} (Fin 1) (Spec (.of kbar))` via `.asOver _`. Matches prose
  "Mathlib: AffineSpace …".
- **notes**: clean.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`, L960)
- **Lean target exists**: yes (L538, `abbrev Gm`).
- **Signature matches**: yes.
- **Proof follows sketch**: N/A. Body wraps `Spec (.of (Localization.Away (X ()
  : MvPolynomial Unit kbar)))` = `Spec k̄[t, t⁻¹]`. Prose at L932-934 reads
  "$\mathbb G_m = \mathbb A^1 \setminus \{0\}$" which is the affine-`Spec`
  encoding the Lean ships (the iter-165 analogist-confirmed D2.b verdict, NOT
  the basic-open path). Mathematically equivalent.
- **notes**: clean.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`, L971)
- **Lean target exists**: yes (L462).
- **Signature matches**: yes,
  `noncomputable def zeroPt … : 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`.
  Prose pins exactly this section-of-`Over`-`hom` shape.
- **Proof follows sketch**: N/A. Body
  `ProjectiveLineBar.pointOfVec kbar (fun i => if i = 0 then 0 else 1) 1 (by simp)`
  realises `[0 : 1]` via `Proj.fromOfGlobalSections` — matches prose.
- **notes**: clean.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`, L985)
- **Lean target exists**: yes (L468).
- **Signature matches**: yes.
- **Proof follows sketch**: N/A. Body `pointOfVec kbar (fun _ => 1) 0 (by simp)`
  realises `[1 : 1]`.
- **notes**: clean.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`, L997)
- **Lean target exists**: yes (L474).
- **Signature matches**: yes.
- **Proof follows sketch**: N/A. Body
  `pointOfVec kbar (fun i => if i = 0 then 1 else 0) 0 (by simp)` realises
  `[1 : 0]`.
- **notes**: clean.

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`, L1010)
- **Lean target exists**: yes (L604).
- **Signature matches**: yes.
- **Proof follows sketch**: N/A. Body `η[Gm kbar]` — the `GrpObj` unit map —
  matches prose's "unit map `η[𝔾_m]`".
- **notes**: clean, but *depends on the `gm_grpObj` instance* (L593) to type-check;
  see red flag below.

### `\lean{AlgebraicGeometry.ga_grpObj}` (chapter: `def:ga_grpObj`, L1023) — **ORPHANED**
- **Lean target exists**: **NO**. `lean_verify` returns
  `Axiom check failed: Unknown constant '_root_.AlgebraicGeometry.ga_grpObj'`.
  Grep across `Genus0BaseObjects.lean` confirms the only remaining mention is a
  docstring fragment at L588 ("`discipline as ga_grpObj`") — the live instance
  was removed in the iter-169 SECONDARY-4 deletion documented in the prover's
  task-result.
- **Signature matches**: N/A — no target.
- **Proof follows sketch**: N/A.
- **notes**: this is the primary find of this dispatch. The `def:ga_grpObj`
  block (L1020-1032) — including its `\label`, `\lean{...}` pin, `\uses{def:ga}`
  edge, and the entry `AlgebraicGeometry.ga_grpObj` at `blueprint/lean_decls:134` —
  must be removed from the chapter (and `lean_decls` regenerated). No other
  blueprint block has a `\uses{def:ga_grpObj}` edge incoming (grep confirms), so
  the removal is purely local cleanup. Comment line "demoted $\mathbb
  G_a$-additive companion route only" in the block (L1029-1031) is consistent
  with `ga_grpObj` having been on the demoted route the iter-169 plan
  deliberately excised.

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`, L1037)
- **Lean target exists**: yes (L593, `instance gm_grpObj … : GrpObj (Gm kbar)
  := sorry`).
- **Signature matches**: yes — `GrpObj (Gm kbar)` is what the chapter prose
  pins as "the multiplicative group-object structure $(\mathbb G_m, \cdot, 1)$"
  via `\mathtt{GrpObj}`.
- **Proof follows sketch**: **N — body is `:= sorry`**. Chapter prose (L1041-1047)
  describes a multiplicative structure via `GrpObj.ofRepresentableBy` + the units
  functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ` (Lean docstring L582-592 sketches the
  same). The substantive content is not delivered. See red flag below.
- **notes**: documented escalation (3-iter deferred per
  `[[genus0-aux-pile-discharged-iter167]]` memory entry); but the
  rule-as-written treats `:= sorry` on a substantive pinned declaration as a
  red flag regardless of escalation provenance.

### `\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` (chapter: `def:projlinebar_affine_cover`, L1064)
- **Lean target exists**: yes (L196).
- **Signature matches**: yes — `(ProjectiveLineBarScheme kbar).AffineOpenCover`,
  built via `Proj.affineOpenCoverOfIrrelevantLESpan` on `f = ![X 0, X 1]`,
  `m = ![1, 1]`. Matches prose at L1071-1080 verbatim.
- **Proof follows sketch**: N/A (definition); body is the chartwise irrelevant-
  ideal containment proof that the prose previews ("writing any irrelevant
  element as a sum of monomials of strictly positive total degree, so each
  monomial is divisible by $X_0$ or $X_1$"). Lean L206-242 realises exactly this.
- **notes**: clean. Note that `projectiveLineBarAffineCover` is NOT listed in
  `blueprint/lean_decls` — that file is stale w.r.t. the iter-168 pins. Likely
  needs regeneration but is mechanical sync, not a checker finding.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` (chapter: `def:proj_chart_ring_iso`, L1087)
- **Lean target exists**: yes (L370).
- **Signature matches**: yes —
  `HomogeneousLocalization.Away 𝒜 (X i) ≃+* MvPolynomial Unit kbar`. Prose pins
  exactly this $\mathrm{Away}\,\mathcal A\,X_i \cong \bar k[u]$.
- **Proof follows sketch**: matches. Body is
  `RingEquiv.ofRingHom forward inverse forward∘inverse=id inverse∘forward=id`
  with `forward = homogeneousLocalizationAwayToMvPoly` via
  `Localization.awayLift` (L280) and `inverse = mvPolyToHomogeneousLocalizationAway`
  via `MvPolynomial.eval₂Hom` (L303). The two round-trip helpers are exactly
  the prose's "forward direction via `Localization.awayLift`" + "inverse
  direction via the universal property of `MvPolynomial Unit`" (L1099-1104).
- **notes**: the chapter explicitly discloses (L1105-1108) that the reverse
  round-trip ships `sorry`-tainted ("ships sorry-tainted until that residual
  closes. The forward round-trip … is axiom-clean."). Honest disclosure;
  see also the next pin.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` (chapter: `lem:proj_chart_ring_iso_aux_left`, L1114)
- **Lean target exists**: yes (L360) as `private lemma`. The full name
  `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left` is resolvable for
  blueprint-doctor / `lean_verify` purposes, but the `private` modifier means
  it is not callable from other files. Acceptable since the chapter pins only
  document its existence/role; no external consumer needs it directly.
- **Signature matches**: yes — `(mvPolyToHomogeneousLocalizationAway kbar i).comp
  (homogeneousLocalizationAwayToMvPoly kbar i) = RingHom.id _`, exactly the
  prose's "$\mathrm{inverse} \circ \mathrm{forward} = \mathrm{id}$".
- **Proof follows sketch**: **N — body is `sorry` (L364)**. Chapter prose
  acknowledges this and gives the recommended closure path (the "cancel
  surjective" route via `Away.adjoin_mk_prod_pow_eq_top`) at L1125-1131.
- **notes**: documented escalation (iter-168 docstring at L350-359). The `sorry`
  IS DISCLOSED in the chapter — this is a soft red flag, not a hidden one.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `lem:projlinebar_isReduced`, L1137)
- **Lean target exists**: yes (L747).
- **Signature matches**: yes — `IsReduced (ProjectiveLineBar kbar).left`.
- **Proof follows sketch**: yes. Lean L748-781 walks `IsReduced.of_openCover`
  over `projectiveLineBarAffineCover.openCover`, shows each chart
  `HomogeneousLocalization.Away 𝒜 (X i)` is a domain via
  `Function.Injective.isDomain` on the `val`-injection into
  `Localization.Away (X i)` (itself a localization of `MvPolynomial _ kbar` at
  a non-zero-divisor, hence a domain). Prose at L1143-1153 sketches exactly
  this: chart cover → val-injection → reduced (in fact a domain). **Axiom-clean
  per `lean_verify`** (axioms `{propext, Classical.choice, Quot.sound}` — no
  `sorryAx`). Matches the chapter's iter-168 "closed axiom-clean" note (L743-746).
- **notes**: clean.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L1159)
- **Lean target exists**: yes (L685, `def gmScalingP1 … := sorry`).
- **Signature matches**: yes — `ProjectiveLineBar kbar ⊗ Gm kbar ⟶
  ProjectiveLineBar kbar` in `Over (Spec (.of kbar))`. Matches prose's
  "$\sigma_\times \colon \mathbb P^1 \times \mathbb G_m \to \mathbb P^1$".
- **Proof follows sketch**: **N — body is `:= sorry`**. Chapter prose (L1170-
  1188) describes the construction as a *fully landed* total scheme morphism
  with two chart formulae and overlap consistency. Lean's iter-169 docstring
  (L626-684) is **honest** about non-landing — explicitly states "body remains
  `sorry` (typed)" and enumerates both routes (chart-glue / functoriality-of-
  Proj) with Mathlib-gap blockers. **The docstring and the chapter prose
  diverge**: the docstring discloses the iter-169 escalation; the chapter prose
  does not. There is no `% NOTE (iter-169)` near `def:gaTranslationP1`
  mirroring the analogous disclosure that *was* added near `def:proj_chart_ring_iso`
  (L1105-1108). See red flag + adequacy section below.
- **notes**: `sorryAx` confirmed via `lean_verify`. Documented escalation, but
  the chapter narrative does not yet reflect the iter-169 reality.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`, L1210)
- **Lean target exists**: yes (L709).
- **Signature matches**: yes —
  `lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
   gmScalingP1 kbar = toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar`.
  Matches the chapter's named diagram at L1214-1219.
- **Proof follows sketch**: **N — body is `by sorry`**. Chapter prose at
  L1222-1232 provides a chart-level sketch ("On the affine chart $\mathbb A^1
  \times \mathbb G_m$ … the morphism $\sigma_\times$ is the polynomial map
  $(x, \lambda) \mapsto \lambda \cdot x$…") that is not yet realised in the Lean.
- **notes**: `sorryAx` confirmed via `lean_verify`. Lean L697-708 honestly
  disclose the gating relationship to `gmScalingP1` ("strictly downstream of
  `gmScalingP1`'s body"). The chapter prose, again, does not flag the Lean
  non-landing.

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.gm_grpObj` at L593: body `:= sorry`. Chapter
  `def:gm_grpObj` (L1037) pins this as a substantive `GrpObj` instance backing
  the multiplicative structure on `𝔾_m`. Documented as a 3-iter deferred
  escalation (per `[[genus0-aux-pile-discharged-iter167]]` memory and the
  prover's iter-167 task), but per the rule-as-written this is a placeholder on
  a substantive blueprint claim.

- `AlgebraicGeometry.gmScalingP1` at L685: body `:= sorry`. Chapter
  `def:gaTranslationP1` (L1159) pins this as the load-bearing total scheme
  morphism `σ_×`. Documented as an iter-169 PARTIAL/escalation (Lean docstring
  L626-684 explicitly), but the chapter prose still describes the morphism as
  fully built.

- `AlgebraicGeometry.gmScalingP1_collapse_at_zero` at L709: body `by sorry`.
  Chapter `lem:gmScaling_fixes_zero` (L1210) pins this as the load-bearing
  $W$-axis-collapse hypothesis. Gated on `gmScalingP1`; Lean docstring discloses.

- `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left` at L364: body
  `sorry`. Chapter `lem:proj_chart_ring_iso_aux_left` (L1114) pins this and
  **does** disclose the scaffold status in prose (L1124-1131). Soft red flag —
  documented and honest, but the iso `def:proj_chart_ring_iso` therefore ships
  sorry-tainted (chapter says so explicitly at L1105-1108).

### Orphaned `\lean{...}` pin

- Chapter `def:ga_grpObj` (L1020-1032) pins
  `\lean{AlgebraicGeometry.ga_grpObj}`, but `lean_verify` reports
  `Unknown constant '_root_.AlgebraicGeometry.ga_grpObj'`. The declaration was
  removed by the iter-169 SECONDARY-4 deletion. The pin must be removed from
  the chapter and the corresponding entry purged from `blueprint/lean_decls:134`.

### Stale narrative

- The `subsection`/section "The genus-$0$ base objects and the $\mathbb G_m$-
  scaling action (the primary route)" (L908+) and specifically
  `def:gaTranslationP1` (L1156-1205) describe `σ_×` as a fully-constructed
  total morphism. The Lean side is `:= sorry` (with an honest iter-169 TODO
  docstring documenting two attempted routes). The chapter adds a
  `% NOTE (iter-169)` for the chart-ring iso (L1105-1108) but the analogous
  iter-169 NOTE is **missing** at `def:gaTranslationP1` / `lem:gmScaling_fixes_zero`.
  iter-170 blueprint-writer task: add `% NOTE (iter-169)` annotations to those
  two blocks acknowledging the Lean escalation status.

### Axioms / `Classical.choice` on non-trivial claims
None. `lean_verify` on every audited declaration returns only the standard
trusted axiom set (`{propext, Classical.choice, Quot.sound}`, plus `sorryAx`
where bodies are `sorry`).

## Unreferenced declarations (informational)

Substantive declarations in `Genus0BaseObjects.lean` that **no** `\lean{...}`
block in the AVR chapter references. Most are helpers; the ones whose name
suggests they could plausibly merit a blueprint block are flagged.

- `projectiveLineBarGrading` (L78): helper (`Submodule` family). Acceptable.
- `projectiveLineBarGrading_gradedRing` (L82): `GradedRing` instance. Acceptable.
- `ProjectiveLineBarScheme` (L94): exposed as underlying scheme. Acceptable —
  the blueprint pins the `Over`-flavoured `ProjectiveLineBar` instead.
- `projectiveLineBarScheme_canOver` (L99): `Over` instance. Acceptable.
- `projectiveLineBar_isProper` (L127): axiom-clean instance. **Prose at L920-924
  claims `ℙ¹` is proper.** Worth a per-instance `\lean{...}` block similar to
  `lem:projlinebar_isReduced`. Minor.
- `projectiveLineBar_geomIrred` (L175): scaffold `sorry`. **Prose at L920-924
  claims `ℙ¹` is "geometrically irreducible".** Hidden scaffold sorry — minor /
  edge of major (the chapter promises a property that the formalization does
  not yet deliver, but the chapter also describes `def:genus0_base_objects`
  prose-only, not pinned).
- `projectiveLineBar_smoothOfRelDim` (L182): scaffold `sorry`. **Prose at
  L921-922 claims `ℙ¹` is "smooth … of genus 0".** Same minor/edge-of-major
  flavour.
- `otherFin` / `otherFin_zero` / `otherFin_one` / `otherFin_ne` (L247-255):
  private helpers for the chart-ring iso. Acceptable.
- `chartEvalRingHom` + the four `chartEvalRingHom_*` simp lemmas (L259-276):
  private helpers. Acceptable.
- `homogeneousLocalizationAwayToMvPoly` (L280): one direction of the iso.
  Acceptable as helper (the iso `homogeneousLocalizationAwayIso` is what the
  chapter pins).
- `kbarToAwayRingHom` (L293): private helper. Acceptable.
- `mvPolyToHomogeneousLocalizationAway` (L303): other direction of the iso.
  Acceptable as helper.
- `homogeneousLocalizationAwayIso_aux_right` (L315): right round-trip lemma.
  Acceptable as helper (the chapter pins only the left, `_aux_left`).
- `ProjectiveLineBar.evalIntoGlobal` / `irrelevant_map_eq_top` / `pointOfVec`
  (L393-458): private helpers for the three `k̄`-points. Acceptable.
- `GaScheme` (L483): underlying scheme of `Ga`. Acceptable.
- `gaScheme_canOver` (L488): `Over` instance. Acceptable.
- `ga_isAffineHom` (L499): instance. Acceptable.
- `ga_locallyOfFinitePresentation` (L506): instance. Acceptable.
- `ga_isReduced` (L515): instance. Acceptable.
- `GmRing` (L522): name of `Localization.Away (X ())`. Acceptable.
- `GmScheme` (L528): underlying scheme. Acceptable.
- `gmScheme_canOver` (L532): `Over` instance. Acceptable.
- `gm_isAffine` (L542): instance. Acceptable.
- `gm_locallyOfFinitePresentation` (L550): instance. Acceptable.
- `gm_isReduced` (L559): instance. Acceptable.
- `gmRing_isDomain` (L568): load-bearing instance for irreducibility. Acceptable.
- `gm_irreducibleSpace` (L577): instance. Acceptable.
- `gm_smooth` (L597): `Smooth` instance gated on `gm_grpObj`. Acceptable.
- `projGm_locallyOfFiniteType` (L736): instance exported for Lane B
  (`morphism_P1_to_grpScheme_const_aux`). Acceptable (consumer-side helper).
- `gm_geomIrred` (L789): instance, **`by sorry`** — exported helper for Lane B
  (the `morphism_P1_to_grpScheme_const_aux` consumer). Chapter does not pin it
  by `\lean{...}`. Lean docstring (L783-788) honestly discloses the Mathlib gap.
  Minor — not a chapter-side adequacy failure (the helper is downstream
  infrastructure, not a load-bearing blueprint claim).
- `projGm_geomIrred` (L801): axiom-clean derivation from `gm_geomIrred`
  (currently `sorry`) + `projectiveLineBar_geomIrred` (also `sorry`). Acceptable
  as helper.
- `projGm_isReduced` (L819): instance, **`by sorry`** — Mathlib-gap helper.
  Lean docstring discloses honestly. Acceptable as helper.

## Blueprint adequacy for this file

- **Coverage**: 15 substantive Lean declarations have corresponding
  `\lean{...}` blocks in the chapter
  (`ProjectiveLineBar` / `Ga` / `Gm` + the three `ℙ¹` points + `Gm.onePt` +
  `gm_grpObj` + `projectiveLineBarAffineCover` + `homogeneousLocalizationAwayIso`
  + `homogeneousLocalizationAwayIso_aux_left` + `projectiveLineBar_isReduced` +
  `gmScalingP1` + `gmScalingP1_collapse_at_zero`); plus ONE pin that
  has become orphaned (`ga_grpObj`). Unreferenced helpers: ~25 (acceptable —
  all private/instance plumbing or downstream Lane B exports); 2 substantive
  unreferenced (`projectiveLineBar_isProper` — axiom-clean and worth pinning;
  `gm_geomIrred` / `projGm_isReduced` — `sorry`-bodied Mathlib-gap helpers,
  acceptable as consumer infrastructure though could be pinned for visibility).

- **Proof-sketch depth**: adequate for everything except `gmScalingP1` and
  `gmScalingP1_collapse_at_zero`, where the chapter prose describes the chart
  formulae but neither block carries an iter-169 `% NOTE` flagging the Lean
  escalation status. The prose-vs-Lean reality mismatch on these two is the
  major blueprint-side hygiene gap of this dispatch.

- **Hint precision**: precise on all live targets; **wrong** on
  `\lean{AlgebraicGeometry.ga_grpObj}` (the named declaration does not exist).

- **Generality**: matches need. The chapter pins
  `homogeneousLocalizationAwayIso` and `homogeneousLocalizationAwayIso_aux_left`
  at the right granularity for the chartwise glue the prover plans to consume.

- **Recommended chapter-side actions (for the iter-170 plan-writer / blueprint-writer
  dispatch)**:
  1. **Delete the `def:ga_grpObj` block (L1020-1032)** including its
     `\label{def:ga_grpObj}` and `\lean{AlgebraicGeometry.ga_grpObj}` pin and
     its `\uses{def:ga}` edge. Regenerate `blueprint/lean_decls` so the orphan
     entry at line 134 disappears.
  2. **Add a `% NOTE (iter-169)` to `def:gaTranslationP1` (L1156-1205)**
     acknowledging that `gmScalingP1` ships as a typed `sorry` (with the route-
     (a) / route-(b) routing rationale that the Lean docstring at
     `Genus0BaseObjects.lean:626-684` records). This mirrors the iter-169 NOTE
     already in place at `def:proj_chart_ring_iso` (L1105-1108).
  3. **Add a `% NOTE (iter-169)` to `lem:gmScaling_fixes_zero` (L1207-1220)**
     acknowledging the gated `sorry` (strictly downstream of `gmScalingP1`).
  4. (Optional) Add per-instance `\lean{...}` pins for `projectiveLineBar_isProper`
     (axiom-clean) and at least disclose the scaffold-sorry status of
     `projectiveLineBar_geomIrred` / `projectiveLineBar_smoothOfRelDim` in a
     `% NOTE` under `def:genus0_base_objects`, since the prose at L920-922
     claims `ℙ¹` is "smooth … geometrically irreducible curve of genus 0".

## Severity summary

- **must-fix-this-iter** — per the verbatim severity rule "Placeholder body
  (`:= sorry`…) on a declaration the blueprint claims is substantive":
  1. `AlgebraicGeometry.gmScalingP1` at `Genus0BaseObjects.lean:685` — body
     `:= sorry`; chapter `def:gaTranslationP1` (L1159) pins it as the
     substantive scaling action morphism.
  2. `AlgebraicGeometry.gmScalingP1_collapse_at_zero` at
     `Genus0BaseObjects.lean:709` — body `by sorry`; chapter
     `lem:gmScaling_fixes_zero` (L1210) pins it as the load-bearing $W$-axis-
     collapse hypothesis.
  3. `AlgebraicGeometry.gm_grpObj` at `Genus0BaseObjects.lean:593` — body
     `:= sorry`; chapter `def:gm_grpObj` (L1037) pins it as the substantive
     multiplicative `GrpObj` instance.

  These three are documented escalations (per the iter-169 prover task-result
  and the `[[genus0-aux-pile-discharged-iter167]]` /
  `[[genus0-scaffold-landed-iter165-166]]` memory entries) — the plan agent
  has visibility on them and the gate decision is the plan agent's. I am
  flagging severity per rule, not making a gate recommendation. NB: per the
  checker prompt I do not under-classify to soften the blow.

- **major**:
  4. Orphaned `\lean{AlgebraicGeometry.ga_grpObj}` pin at chapter L1023 (the
     `def:ga_grpObj` block, L1020-1032, in toto). Declaration was deleted from
     Lean this iter (SECONDARY-4 deletion); the chapter still names it, and
     `blueprint/lean_decls:134` still lists it. Plan-writer mechanical cleanup
     in iter-170.
  5. Stale narrative on `def:gaTranslationP1` (L1156-1205) and
     `lem:gmScaling_fixes_zero` (L1207-1220) — chapter prose describes the
     scaling action as a fully-built total morphism while the Lean side is
     `:= sorry`; no `% NOTE (iter-169)` annotation discloses the escalation
     status (the analogous NOTE *was* added near `def:proj_chart_ring_iso`,
     L1105-1108).
  6. `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left` at
     `Genus0BaseObjects.lean:364` body `sorry`. Demoted from must-fix because
     the chapter's `lem:proj_chart_ring_iso_aux_left` block (L1111-1132) and
     the parent `def:proj_chart_ring_iso` block (L1105-1108) **explicitly
     disclose** the scaffold-sorry status and even sketch the recommended
     closure path. Honest disclosure → major, not must-fix.

- **minor**:
  7. `projectiveLineBar_isProper` (`Genus0BaseObjects.lean:127`, axiom-clean)
     is unreferenced by any chapter `\lean{...}` block despite the chapter
     prose at L920-924 claiming `ℙ¹` is proper. Worth promoting to a per-decl
     block similar to `lem:projlinebar_isReduced`.
  8. `projectiveLineBar_geomIrred` (L175) and
     `projectiveLineBar_smoothOfRelDim` (L182) scaffold-sorry instances are
     not surfaced in the chapter despite prose at L920-924 claiming `ℙ¹` is
     smooth + geometrically irreducible. A `% NOTE` under
     `def:genus0_base_objects` would close this prose-vs-Lean disclosure gap.

Overall verdict: **the Lean→blueprint pairing is structurally sound** (every
live `\lean{...}` block points at the right Lean declaration with the right
signature, and the one axiom-clean substantive obligation — `projectiveLineBar_isReduced` —
faithfully realises the chapter sketch), but **iter-169 leaves three blueprint-
side hygiene actions for the iter-170 plan-writer**: drop the orphaned
`def:ga_grpObj` block, add iter-169 `% NOTE`s to `def:gaTranslationP1` and
`lem:gmScaling_fixes_zero` mirroring the iter-169 NOTE already in place near
`def:proj_chart_ring_iso`, and (optionally) tighten the `def:genus0_base_objects`
prose-vs-Lean coverage for the three `ℙ¹` instance properties.
