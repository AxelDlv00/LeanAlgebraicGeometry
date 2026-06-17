# Lean Audit Report

## Slug
iter062

## Iteration
062

## Scope
- files audited: 2
- files skipped: 0 (directive specified exactly these two)

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged
- **excuse-comments**: none

#### Notes

**New declarations (iter-062 focus)**

- `isIso_map_prodLift_of_isLimit` (private, line 637): Genuine categorical helper — if `G`
  preserves binary products and `BinaryFan.mk (G.map α) (G.map β)` is a limit, then
  `G.map (prod.lift α β)` is an iso. Proof goes via the `prodComparison` triangle:
  `G.map (prod.lift α β) ≫ prodComparison G P Q = prod.lift (G.map α) (G.map β)`, then
  `IsIso.of_isIso_comp_right` using `[IsIso (prodComparison G P Q)]` synthesized from
  `[PreservesLimit (pair P Q) G]`. Axiom check: **propext / Classical.choice / Quot.sound only**. ✓

- `isIso_coprodDecompMap` (private, line 707): Genuine disjoint-union decomposition theorem.
  Proof via `TopCat.Sheaf.isProductOfDisjoint` on the underlying abelian sheaf, reflected
  through `SheafOfModules.evaluation ⋙ forget₂ (ModuleCat _) AddCommGrpCat` and then
  `isIso_map_prodLift_of_isLimit`. The `exact LimAb` at line 753 works by definitional
  equality of the evaluation paths (both compose to the abelian restriction map). Axiom
  check: **propext / Classical.choice / Quot.sound only**. ✓

  No Subsingleton/defeq/rfl launder; no unsound `ext`/`congr` trick; both declarations are
  genuine non-trivial proofs the kernel accepts.

**Sorry sites**

- Line 810 (`pushPull_sigma_iso`): **Honest.** Goal = product decomposition
  `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)`.  Planner route in the preceding
  block (lines 764–803) accurately describes the disjoint-component argument. No papering.

- Line 901 (`pushPull_eval_prod_iso`): **Honest.** Goal = degreewise section iso
  `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(U_σ ∩ V, F)`. Correctly depends on `pushPull_sigma_iso`
  (above); assembly sorry.

- Line 971 (`cechSection_complex_iso`): **Honest.** Goal = complex-level iso
  `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`. Correct augmented type (per the
  Stubs 5/6 false-alarm memory fix confirmed in iter-056). No papering.

- Line 1030 (`cechSection_contractible`): **Honest.** Goal = contracting homotopy
  `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`. Combinatorial residual,
  correctly depends on `cechSection_complex_iso`.

**Outdated / stale comments**

- **Lines 553–580** — Planner-strategy block before `cechBackbone_left_sigma`. The
  declaration at lines 582–607 is **fully proved** (no sorry). The block describes steps
  (a)–(d) and names "Key Mathlib anchors" as if the proof is still open. This is dead
  documentation that will mislead readers into thinking the lemma is incomplete.
  **Severity: major.**

- **Lines 814–842** — Planner-strategy block before `pushPull_leg_sections`. That
  declaration (lines 843–863) is **fully proved** (no sorry, ends with `eqToIso`). Same
  issue as above: a route-sketch for a proof already in the file. **Severity: major.**

- **Lines 666–700** — Iter-specific status/handoff block opening with
  `"**Status (iter-062): isIso_coprodDecompMap is DONE axiom-clean (below).**"`.
  This encodes the iteration number and will be immediately stale. It also describes
  the upcoming `pushPull_binary_coprod_prod` L2 assembly in forward-reference style
  appropriate for PROGRESS.md or a task result, not for Lean source. **Severity: major.**

**Bad practices**

- **Line 363** (`set_option maxHeartbeats 1600000`): Linter fires
  ("Please add a comment explaining the need"). This is the **only** heartbeat bump in
  `CechSectionIdentification.lean` with no inline or block explanation. Every other
  heartbeat bump in both project files under audit has an accompanying rationale comment;
  this one is the outlier. **Severity: minor.**

- **Line 804** (`set_option synthInstance.maxHeartbeats 800000`): Applied to
  `pushPull_sigma_iso`, which is a `sorry`. The option has no effect until the sorry is
  filled; linter warns about missing comment. Anticipatory bumps without explanation are
  confusing. **Severity: minor.**

- **Lines 736, 742** — `show` tactic used where `change` is idiomatic (linter fires
  `linter.style.show`). **Severity: minor.**

---

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: none

#### Notes

**New declarations (iter-062 focus)**

- `opensMapInvBase_isEquivalence` (instance, line 457): Genuine 1-line instance. Equates
  `(Opens.map φ.inv.base).IsEquivalence` to the `IsEquivalence` of the functor underlying
  `(Scheme.forgetToTop.mapIso φ).symm`. Axiom-clean (standard three). ✓

- `overPost_slice_isContinuous` (instance, lines 464–470): Genuine continuity instance.
  Uses `Functor.isContinuous_of_coverPreserving` + `CoverPreserving.overPost` +
  `compatiblePreservingOfFlat`. 3-line proof; all applied lemmas exist and match their
  types. Axiom-clean. ✓

- `sliceStructureSheafHom` (def, lines 479–484): Genuine definition. Constructs the
  cross-ring slice ring map as the image of `φ.inv.toRingCatSheafHom` under the
  `overPullback` functor. Type signature is complex but consistent with the described
  Beck–Chevalley `rfl` equality. ✓

- `sliceStructureSheafHom_pre_isRightAdjoint` (instance, lines 488–491): Genuine instance.
  Uses `Functor.isRightAdjoint_of_leftAdjointObjIsDefined_eq_top` with
  `PresheafOfModules.pullbackObjIsDefined_eq_top`. Axiom-clean. ✓

- `sliceStructureSheafHom_isRightAdjoint` (instance, lines 501–503): Genuine `inferInstance`
  proof; the large heartbeat bump (lines 493–494: `maxHeartbeats 4000000`,
  `synthInstance.maxHeartbeats 2000000`) is explained inline (lines 495–498: sliced-site
  `HasWeakSheafify`/`WEqualsLocallyBijective` synthesis times out at defaults). Axiom-clean. ✓

  None of the five new declarations is a Subsingleton/defeq/rfl launder. The `inferInstance`
  in `sliceStructureSheafHom_isRightAdjoint` is backed by the pre-instance and verified by
  the kernel at the elevated heartbeat budget.

**Sorry sites**

- Line 670 (inside `higherDirectImage_openImmersion_acyclic`, `hqc` case): **Honest.**
  Goal = `((Φ H).over (U.isoSpec.inv ⁻¹ᵁ qcd.X i)).IsQuasicoherent`. The 20-line comment
  block (lines 650–669) accurately identifies the comparison iso
  `pushforwardSlicePullbackIso` as the lone unbuilt piece and proposes a concrete route
  (`pullback ψ_r ≅ pushforward φ''` via `Adjunction.leftAdjointUniq`). No papering; the
  reduction plumbing above (lines 636–648) is complete and axiom-clean.

- Line 736 (`higherDirectImage_openImmersion_comp`): **Honest.** Goal =
  `higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`.
  Comment at lines 718–735 correctly names the two remaining dependencies (acyclicity of
  `j_* Iⁿ` and `f_*`-acyclicity). Depends on the Part (1) sorry being closed first.

**Bad practices**

- **Lines 414–415** (`set_option synthInstance.maxHeartbeats 1000000 in` /
  `set_option maxHeartbeats 2000000 in` before `pushforward_iso_qcoh_of_slice_qcoh`):
  Linter fires because the explanatory comment (lines 416–418) follows the `set_option`
  pair rather than sitting on the same line. The explanation IS present and IS accurate; the
  format does not satisfy the linter's expected `set_option X in -- reason` style. Since
  other bumps in the same file use the same post-comment pattern (lines 493–498), this is a
  consistent project convention that just doesn't satisfy the Mathlib linter. **Severity: minor.**

- **Lines 493–494** (`set_option maxHeartbeats 4000000`): Same format issue as above; linter
  fires on line 493. Comment at lines 495–498 is present and accurate. **Severity: minor.**

---

## Must-fix-this-iter

*None.* No excuse-comments, no wrong definitions, no unsound proofs, no unauthorized axioms
in any proved declaration.

---

## Major

- `CechSectionIdentification.lean:553–580` — Stale planner-strategy block before
  `cechBackbone_left_sigma`. Declaration is proved (no sorry). Block falsely implies an
  open proof obligation; must be deleted or collapsed to a one-line proof note.

- `CechSectionIdentification.lean:814–842` — Stale planner-strategy block before
  `pushPull_leg_sections`. Declaration is proved (no sorry). Same issue.

- `CechSectionIdentification.lean:666–700` — Iter-specific status/handoff block embedding
  "iter-062" and describing future L2 assembly work. Will be permanently stale from iter-063
  onward. Belongs in PROGRESS.md / task result, not Lean source.

---

## Minor

- `CechSectionIdentification.lean:363` — `set_option maxHeartbeats 1600000` with no
  explanatory comment (linter fires; every other heartbeat bump in both files has one).

- `CechSectionIdentification.lean:804` — `set_option synthInstance.maxHeartbeats 800000`
  applied to a `sorry` declaration; no effect until the sorry is filled, no comment.

- `CechSectionIdentification.lean:736,742` — `show` used where `change` is idiomatic
  (linter fires `linter.style.show`).

- `OpenImmersionPushforward.lean:414,493` — Heartbeat-bump explanatory comments present but
  after the `set_option` lines rather than inline; linter fires. Cosmetic format issue only.

- Both files: numerous long-line warnings (> 100 chars) throughout comment blocks and proof
  code — cosmetic.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 6 (counting the two long-line clusters each as one entry)
- **excuse-comments**: 0

**Overall verdict**: Both files are in good shape — all seven new declarations are genuine,
non-trivial, and axiom-clean; all six remaining sorries are honest with goal types that match
their stated claims. The three major findings are stale or iter-specific documentation in
`CechSectionIdentification.lean` that should be pruned to avoid reader confusion.
