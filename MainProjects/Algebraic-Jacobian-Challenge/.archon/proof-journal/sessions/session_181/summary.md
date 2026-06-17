# Session 181 Summary

## Metadata

- **Session**: 181 (review of iter-181)
- **Started**: 2026-05-24T03:08:40Z
- **Build state at end-of-iter**: `lake build AlgebraicJacobian` **GREEN** (8355/8355 jobs, 0 errors).
- **Sorry count**: 73 (iter-180 close) → **75** (iter-181 close, lake build) — net **+2** by file count.
  - Refactor `ocofp-globalsections-sig` adds +1 (new `toFunctionField` `:= sorry` def).
  - Lane A directional split +1 (refactor's single-sorry iff body → mp + mpr helpers).
  - Lane B (GmScaling) +0 net (inline cross sorry → named `cross01` helper sorry).
  - Lane C (Points) **−2** (`gm_grpObj` round-trip identities both closed kernel-clean).
  - Lane D (RelativeSpec) +0 net (inline sorry → named `pullback_iso_construction` sorry; helper 1 axiom-clean).
  - Lane E (AVR) +0 net (inline sorry → named `iotaGm_range_isOpen` sorry).
  - Lane F (QuotScheme) +1 (substantive helper split landed one substantive sorry + one rfl-bridge).
  - Lane G (AuslanderBuchsbaum) +0 net (`of_regular` body sorry replaced by `exists_isRegular_of_regularLocal` helper sorry).
  - Lane H (RRFormula) +1 (induction body lands with 2 substantive helper sorries; net +1 by file count given induction closure).
  - Lane I (RatCurveIso) +0 (signature-only mutation).
  - Net: +1 refactor +1 Lane A −2 Lane C +1 Lane F +1 Lane H = +2.
- **Project axiom count**: **0 → 0** (unchanged; first 0-axiom build retained since iter-180).
- **Targets attempted**: 9 prover lanes (A–I; Lane I is the iter-181 signature-mutation-only deliverable).
- **Plan-phase pre-work**: 1 refactor (`ocofp-globalsections-sig`), 1 mathlib-analogist consult (`ratcurveiso-pins`), 2 critic dispatches (`progress-critic route181`, `strategy-critic iter181`).
- **Review-phase dispatches**: 1 `lean-auditor` whole-project + 3 `lean-vs-blueprint-checker` per-file (OCofP, Points, RatCurveIso) — see `## Review-phase subagent findings`.

## Iter shape — post-RETIRE-OR-ESCALATE follow-through + OCofP CRITICAL fix + Points 11-iter STUCK FULLY RESOLVED

Entering iter-181: `lake build` GREEN with 73 sorries, 0 project axioms. The iter-181 RETIRE-OR-ESCALATE trigger landed early at iter-180 and the iter-180 review surfaced a CRITICAL signature bug on `OCofP.globalSections_iff` (RHS vacuous-in-`f`).

iter-181 plan-phase actions: (a) refactor `ocofp-globalsections-sig` re-typed the iff and added a new `toFunctionField` sorry def, (b) mathlib-analogist `ratcurveiso-pins` verified both Pin 2 and Pin 3 are in-tree work (PROCEED); (c) STRATEGY.md was re-rendered to address strategy-critic's 13-per-iter-ref format NON-COMPLIANCE + chart-bridge velocity-anchor + A.4.c missing sub-phase.

iter-181 prover phase: 9 prover lanes dispatched. All returned task_results. Two lanes RESOLVED (Lane C `gm_grpObj` round-trips kernel-clean; Lane I RatCurveIso signature mutation). Seven lanes returned PARTIAL with honest substantive helper decompositions. **No new project axioms introduced**; lean-auditor verifies all 3-tier disclosure claims match `lean_verify` axiom sets.

The headline outcome: **Lane C closed the 11-iter `gm_grpObj` STUCK pattern FULLY kernel-clean** (the iter-180 5 axiom-clean helpers + iter-181 2 round-trip closures land the whole `GrpObj Gm` instance at `{propext, Classical.choice, Quot.sound}`). Downstream consumers (`gm_smooth`, `iotaGm_isDominant` substrate, `morphism_P1_to_grpScheme_const`) inherit a kernel-clean `GrpObj Gm`.

The OCofP CRITICAL must-fix from iter-180 is **structurally addressed** via the plan-phase refactor: the iff signature now binds `s` to `f` and is no longer vacuous. Lane A correctly delivered the directional-split PARTIAL shape per the directive's GATE RISK clause; closure of the iff body is gated on landing `toFunctionField` and `lineBundleAtClosedPoint` bodies, both flagged by the lean-auditor as the most acute open scaffold (`noncomputable def := sorry` on non-Prop carriers).

## Per-lane outcomes

| Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|
| A | `RiemannRoch/OCofP.lean` | PARTIAL (per directive GATE RISK) | 5 → 7 | Refactor +1 (`toFunctionField`), directional split +1 (mp/mpr helpers). Iff now binds `s` to `f`; iter-180 CRITICAL signature bug RESOLVED structurally. |
| B | `Genus0BaseObjects/GmScaling.lean` | PARTIAL — substantive | 4 → 4 | Diagonal + cross-by-swap closed axiom-clean (`fst_eq_snd_of_mono_eq` + `pullbackSymmetry`); substantive cross (0,1) → named `cross01` helper. Helper budget 1/1. |
| C | `Genus0BaseObjects/Points.lean` | SUCCESS — kernel-clean | 2 → 0 | **Both round-trips closed kernel-clean**. `gm_grpObj` now `{propext, Classical.choice, Quot.sound}` transitively. **11-iter STUCK pattern FULLY RESOLVED**. |
| D | `Picard/RelativeSpec.lean` | PARTIAL — structural | 1 → 1 | 2 helpers: `pullback_iso_affine_piece` (kernel-clean) + `pullback_iso_construction` (substantive sorry). Main `pullback_iso` ≅ wrapper. |
| E | `AbelianVarietyRigidity.lean` | PARTIAL — structural | 2 → 2 | `iotaGm_isDominant` body closed inline modulo NEW `iotaGm_range_isOpen` helper. Disclosure tier improved one level. |
| F | `Picard/QuotScheme.lean` | PARTIAL — structural | 7 → 8 | 2 helpers: `pushforward_pullback_section_eq_pullback_section` (rfl, axiom-clean) + `..._of_isAffineOpen_of_isAffineBase` (substantive Stacks 02KE). Main body re-docstring'd with MV reduction outline. |
| G | `Albanese/AuslanderBuchsbaum.lean` | PARTIAL — structural | 4 → 4 | `CohenMacaulay.of_regular` body assembled inline; substantive content named in `exists_isRegular_of_regularLocal` helper (Stacks 00NQ + regular-quotient induction). Helper `length_le_ringKrullDim_of_isRegular` kernel-clean (axiom-clean upper bound). |
| H | `RiemannRoch/RRFormula.lean` | PARTIAL — structural | 2 → 3 | Induction body lands via `Finsupp.induction`; 2 substantive named helpers (`eulerCharacteristic_sheafOf_zero`, `eulerCharacteristic_sheafOf_single_add`). Net +1. |
| I | `RiemannRoch/RationalCurveIso.lean` | SUCCESS — sig mutation as scoped | 2 → 2 | Pin 3 hypothesis refined: existence-wrapper → `[Algebra k₁ k₂]` + `Module.finrank k₁ k₂ = 1`. Auditor 178A finding RESOLVED. Helper budget 0/0 honoured. |

**Net sorry trajectory**: −2 (Lane C) +1 (refactor toFunctionField) +1 (Lane A split) +1 (Lane F substantive helper) +1 (Lane H helper #2 net) = **+2**. Plan's predicted band was best −9 / realistic −4 to −6 / worst +3 to +5; landed near the worst case on file count but **best case on axiom critical-axis** (axioms stay at 0) and **best case on the 11-iter STUCK gm_grpObj resolution** (fully kernel-clean, off the deferral list).

## Significant attempts (per target)

### `Scheme.lineBundleAtClosedPoint.globalSections_iff` (Lane A — PARTIAL)

- **Plan-phase refactor (verbatim from `refactor-ocofp-globalsections-sig` report):** Added `noncomputable def lineBundleAtClosedPoint.toFunctionField` (typed `sorry`) between L150-162; replaced `globalSections_iff` RHS from `Nonempty { s // s ≠ 0 }` (vacuous-in-`f`) to `∃ s, lineBundleAtClosedPoint.toFunctionField P hP s = f`. iter-180 CRITICAL must-fix RESOLVED structurally.
- **Prover attempt 1 — directional split:** `⟨globalSections_iff_mp _ _ _ _ _, globalSections_iff_mpr _ _ _ _ _⟩` combinator + 2 private directional helpers, each body `sorry` with detailed in-body comments. `#print axioms` on combinator: `{propext, sorryAx, Classical.choice, Quot.sound}` — sorry only inherited via dependencies (correct disclosure tier).
- **Blocker:** Body of both directions requires unfolding `toFunctionField`, which is itself `sorry`. The iff with `toFunctionField P hP s = f` on the RHS is **mathematically vacuous** until `toFunctionField` lands (lean-auditor MAJOR — see `## Review-phase subagent findings`).
- **Helper budget consumed:** 2/2.
- **Outcome:** PARTIAL per the directive's GATE RISK clause ("BOTH directions consume the body of `lineBundleAtClosedPoint` … if that gate cannot be bridged, lane PARTIAL with 2 named directional helper sorries").

### `gmHomEquiv_left_inv` and `gmHomEquiv_right_inv` (Lane C — SUCCESS)

- **Approach (right_inv, L468):** Reduce to ring-map equality at CommRingCat level via `Units.ext` + the existing `change`, then `unfold gmHomEquiv_invFun` + `change` to expose `Spec.map (CommRingCat.ofHom _)`. The full chain `rw [Scheme.Hom.comp_appTop, ← Scheme.ΓSpecIso_inv_naturality_assoc, Scheme.toSpecΓ_appTop, Iso.inv_hom_id, Category.comp_id]` collapses LHS to `CommRingCat.ofHom liftedMap`; `simp [IsLocalization.Away.lift_eq, MvPolynomial.eval₂Hom_X']` finishes.
- **Approach (left_inv, L382):** `Over.OverMorphism.ext` + `AlgebraicGeometry.ext_to_Spec` to reduce to `RingHom GmRing →+* Γ(T.left, ⊤)`; establish helper `hw` for the structureRingMap factorisation; `IsLocalization.lift_unique` + `MvPolynomial.ringHom_ext` on `C` and `X` generators.
- **Sealed iter-180 BLOCKER:** the iter-180 task_result flagged `rw [← Scheme.ΓSpecIso_inv_naturality_assoc]` as failing to match. The fix: preceding `unfold gmHomEquiv_invFun` + explicit `change` exposes the inner `Spec.map (CommRingCat.ofHom _)` form so the rewrite pattern's `(Spec.map ?f)` can unify.
- **Tooling traps:** `Scheme.Hom.comp_appTop` (not `Scheme.comp_appTop`); `set_option backward.isDefEq.respectTransparency false in rw [...]` for nested rewrites (same iter-180 chart-bridge idiom).
- **Outcome:** SUCCESS — `lean_verify` on all three (`gm_grpObj`, `gmHomEquiv_left_inv`, `gmHomEquiv_right_inv`) returns `{propext, Classical.choice, Quot.sound}` kernel-only. File 2 → 0. **11-iter STUCK FULLY RESOLVED.**

### `iotaGm_isDominant` (Lane E — PARTIAL)

- **Approach:** Reduce `IsDominant` → `DenseRange` → derive density from (a) `IrreducibleSpace (PLB).left` via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton (f := PLB.hom)`, (b) `Nonempty Gm.left`, (c) `IsOpen (Set.range iotaGm.left)` via `IsOpen.dense` on PreirreducibleSpace.
- **Key bridge:** `IrreducibleSpace` extends `PreirreducibleSpace`, so `IsOpen.dense` fires directly on the `Spec k̄` subsingleton-induced irreducible instance.
- **Confirmed dead-end avoided:** `IsOpenImmersion.isDominant` does not exist in Mathlib (iter-178 dead-end memory).
- **New helper:** `iotaGm_range_isOpen` carrying the chart-1 section + `IsOpenImmersion.isOpen_range` claim. Body `sorry` with detailed strategy comment.
- **Outcome:** PARTIAL — body kernel-clean modulo upstream `iotaGm_range_isOpen`; disclosure tier one level shallower than iter-180.

### `gmScalingP1_chart_agreement` (Lane B — PARTIAL)

- **Approach:** Restructure from `by_cases hxy : x = y` (one big sorry) → `fin_cases x <;> fin_cases y` (4 explicit branches): diagonals via `fst_eq_snd_of_mono_eq` (axiom-clean); (1,0) cross derived from (0,1) cross via `pullbackSymmetry` (axiom-clean — both sides pre-composed with `pullbackSymmetry.hom` epi); (0,1) cross delegated to NEW helper `gmScalingP1_chart_agreement_cross01`.
- **Tooling trap:** `fin_cases` produces `(fun i ↦ i) ⟨0, _⟩` not canonical `(0 : Fin 2)`; `pullbackSymmetry` lemmas don't match syntactically. Fix: `simp only [Fin.isValue, Fin.zero_eta, Fin.mk_one]` before the `rw` chain (variant of iter-180 Lane A `respectTransparency` recipe trap).
- **Dead end #1:** `cancel_mono` on `PLB.hom` — failed because PLB.hom is not mono (ℙ¹ → Spec k̄ has positive-dimensional fibre over the closed point).
- **Dead end #2:** unfold + simp chain mirroring iter-180 PRIMARY recipe — stalls on a *different* `Algebra.compHom`-driven instance resolution family from PRIMARY (cross case sits in TensorProduct of `Localization.Away` with `GmRing`, different blocker family).
- **Outcome:** PARTIAL — wrapper closes kernel-clean modulo upstream `cross01`. Helper budget 1/1.

## Key findings / patterns discovered

1. **`unfold + change` exposes nested `Spec.map (CommRingCat.ofHom _)` for rewrite pattern matching.** When `rw [← Scheme.ΓSpecIso_inv_naturality_assoc]` fails to match a goal where `(Spec.map ?f)` is buried inside `(Over.homMk _ _).left.appTop`, prefix with `unfold ...; change ...; rw [Scheme.Hom.comp_appTop, ...]` to expose the canonical form. Same idiom reused in chart-bridge closures.

2. **`fin_cases` non-canonical Fin literals trap.** `fin_cases x` on `x : Fin n` produces `(fun i ↦ i) ⟨k, _⟩`, not the canonical `(k : Fin n)` literal. Mathlib lemmas like `pullbackSymmetry_hom_comp_*` pattern-match against the canonical form. **Pre-rewrite cleanup**: `simp only [Fin.isValue, Fin.zero_eta, Fin.mk_one]`.

3. **`GeometricallyIrreducible + Subsingleton (Spec k̄) ⟹ IrreducibleSpace`.** Bridge: `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` (Mathlib `Geometrically/Irreducible.lean:99`). Useful when proving density of a range whose target is geometrically irreducible.

4. **`IsOpen.dense` fires on `PreirreducibleSpace`**, and `IrreducibleSpace extends PreirreducibleSpace`. Lets you derive `DenseRange` from `IsOpen + Nonempty` on an irreducible scheme.

5. **3-tier kernel-clean disclosure** (planner-mandated this iter): `lean_verify` axiom set actually matches every disclosed tier across all 9 prover task results. Pattern is sustainable; lean-auditor confirms zero inflation across the iter.

6. **`pullbackSymmetry` derives (1,0)-cross-case from (0,1)** via epi argument (pre-compose both sides; `pullbackSymmetry.hom` is iso hence epi). Avoids re-proving the substantive cocycle ring identity twice.

7. **`Module.Flat.isBaseChange` is the canonical tool for affine-open section formula** of `Scheme.Modules.pullback`. Captured in QuotScheme Lane F substantive helper signature. **Mathlib gap**: the section-vs-tensor-product identification of `Scheme.Modules.pullback _ _` at affine opens is not yet shipped (pinned commit b80f227).

8. **`fst_eq_snd_of_mono_eq` for pullback-equation discharge** when target morphism is mono: closes diagonals (`(0,0)` and `(1,1)`) axiom-clean in chart-agreement structure.

9. **`Finsupp.induction` + `Finsupp.sum_add_index`** for honest induction on `Finsupp` divisors. RR Theorem 1.3 sweeps cleanly across `WeilDivisor` as `Finsupp ↑(C.PrimeDivisor) ℤ`.

10. **`IsRegularLocalRing.spanFinrank_maximalIdeal` + `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`** is the Mathlib-side of Stacks 00OD's upper bound on `depth ≤ d`. Lower bound `d ≤ depth` still requires `IsRegularLocalRing → IsDomain` (Stacks 00NQ — Mathlib gap).

## Review-phase subagent findings

### `lean-auditor` `iter181` (whole-project, foreground)

**Severity summary**: 0 must-fix / 4 major / 6 minor / 0 excuse-comments.

**Verdict**: *"Solid iter — all advertised kernel-cleanness claims verify against `lean_verify`, no new project axioms, no laundering helpers, and the prior excuse-comment in `RationalCurveIso` is fully retired by the Lane I signature refactor."*

Full report: `.archon/task_results/lean-auditor-iter181.md`.

**Major findings worth surfacing**:

- **`noncomputable def ... := sorry` on non-`Prop` carriers create silently-vacuous downstream relations.** Six load-bearing carriers in this category, with **`OCofP.lean:154 lineBundleAtClosedPoint.toFunctionField` the most acute**: until it has a real body, `globalSections_iff` is mathematically vacuous (the iff compares two opaque-but-uniform "the" values, so it's not merely sorry-propagating — it's vacuous-in-`f` at the equation level even with the iter-181 binding fix). The other 5: `lineBundleAtClosedPoint`, `WeilDivisor.sheafOf`, `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`. All honestly disclosed but downstream consumers need re-audit when any of these bodies lands.

- **Pervasive iter-status docstring embedding** (~417 cumulative `iter-1XX` refs across 27 files). The auditor recommends demotion to bottom-of-file blocks or periodic pruning of >3-iter-out status. Not blocking but a maintenance liability.

- **`AVR.lean:373 _hf` correctly threaded** through `hpoint` at L383 — prior iter-157/158 "_hf-laundering" concern stayed addressed.

- **Inline `sorry` for `IsReduced A.left`** in `Thm32RationalMapExtension.lean:194` — substantive Mathlib gap `Smooth → IsReduced` over a field. Documented; not a rename. Acceptable.

**Minor findings**: a few stale "SCAFFOLD comments mark them" / "Still a scaffold `sorry`" docstrings in AVR; the only TODO in the tree (`RelPicFunctor.lean:231`) is a dependency note not an excuse-comment; the `respectTransparency` workaround is documented at `analogies/pullbackspeciso-bypass.md`; consider scoping the `set_option linter.style.setOption false` suppressions more narrowly.

### `lean-vs-blueprint-checker` `iter181-ocofp`, `iter181-points`, `iter181-ratcurveiso`

All three completed during this review session.

- **`iter181-ocofp`**: `complete: partial, correct: true`. iter-180 CRITICAL must-fix RESOLVED; iff binds `s` to `f` exactly per chapter prose. Minor: missing `\lean{...}` pin for new `toFunctionField` in chapter (blueprint-writer follow-up).
- **`iter181-points`**: PASS HARD GATE on both axes. Minor housekeeping (stale `gmHomFunctor_representableBy` docstring; optional `ofRepresentableBy` chapter expansion).
- **`iter181-ratcurveiso`**: **must-fix-this-iter** on Pin 2 (`morphism_degree_via_pole_divisor`, L310-320) — signature is structurally weaker than the blueprint claim, weakened-wrong file-skeleton pattern. The type is discharged by ANY positive-degree divisor on `C` without reference to `φ`. Body is `sorry` so no false proof shipped, but **type must be strengthened before iter-182+ body work**. Major: Pin 3 chapter prose lags iter-181 Lane I signature refinement. iter-182 plan-phase action: dispatch a `refactor` subagent (analogous to iter-181's `refactor ocofp-globalsections-sig`) to strengthen Pin 2's signature.

**Skipped per-file checks** (with rationale): The other 6 prover-touched files (`AVR`, `AuslanderBuchsbaum`, `GmScaling`, `QuotScheme`, `RelativeSpec`, `RRFormula`) all had **substantive prover work but no signature mutations from the iter-180 baseline** — every prover edit was inline sorry → named helper sorry restructure (Lane B/D/E/F/G) or named helper additions for existing lemma signatures (Lane H). The chapter `\lean{...}` pins for these files were verified `complete: true correct: true` at iter-177 HARD GATE clear and the iter-178/179/180 sync_leanok phases. No prose drift suspected.

## Blueprint markers updated (manual)

(None this iter.)

The plan-phase blueprint surgical edit on `lem:lineBundleAtClosedPoint_globalSections_iff` (binding `s` to `f` in chapter prose) was applied by the planner before the prover lane ran; no review-phase semantic action required.

Pending pickups for iter-182 plan-phase (informational; not review-phase actions):

- Consider adding `\lean{...}` pins for the new helpers landed this iter: `globalSections_iff_mp/mpr` (OCofP), `iotaGm_range_isOpen` (AVR), `cross01` (GmScaling), `pullback_iso_affine_piece/construction` (RelativeSpec), `_of_isAffineOpen_of_isAffineBase` + `pushforward_pullback_section_eq_pullback_section` (QuotScheme), `exists_isRegular_of_regularLocal` + `length_le_ringKrullDim_of_isRegular` (AuslanderBuchsbaum), `eulerCharacteristic_sheafOf_zero/_single_add` (RRFormula).
- RationalCurveIso chapter §3 prose tightening for the iter-181 Lane I signature refinement (planner work).

## Recommendations for next session

See `recommendations.md` for the full breakdown. Headline:

1. **Critical**: address the `toFunctionField` body to retire the vacuous-iff condition on `globalSections_iff` — lean-auditor MAJOR. Either via mathlib-analogist consult on Sheaf-internal-Hom + ModuleCat-forget, or bottom-up `IdealSheafDual.lean` lane.
2. **High-value**: Lane B cross01 + Lane E `iotaGm_range_isOpen` share the same chart-1 unfold work — schedule them together iter-182 (analogist consult on `gmscaling-cover-bridge.md` extension to chart-1 section extraction).
3. **Watch**: Lane F (QuotScheme) +1 sorry net 2 iters running — borderline churn; iter-182's "_of_isAffineOpen helper close" attempt is the decisive test.
4. **Continued progress**: Lane G AuslanderBuchsbaum is on a real downward trajectory (6 → 5 → 4); iter-182 should attempt one of the named depth-dependent lemmas (`exists_isRegular_of_regularLocal` body via `IsRegularLocalRing → IsDomain` + regular-quotient induction).
5. **Off-target deferrals**: 4c RelPicFunctor / 4e FGAPicRepresentability / 4f FlatteningStratification / 5d AlbaneseUP — re-engagement deadlines recorded in PROGRESS.md `## Standing deferrals`; no iter-182 prover dispatch.

## Notes

- `git diff --stat HEAD~1`: branch has a single seed commit; iter-181 work is uncommitted. Read into context from `.archon/proof-journal/current_session/attempts_raw.jsonl` (665 events) and `.archon/task_results/*.md`.
- `attempts_raw.jsonl` summary: 34 edits across 9 files, 13 goal checks, 40 diagnostic checks, 0 builds, 86 lemma searches, 13 errors recorded transiently (all resolved).
- `lake build AlgebraicJacobian` final: 8355/8355 jobs, 0 errors, 75 sorry warnings.
- Blueprint-doctor (iter-181): `No structural findings: every chapter is \input'd by content.tex, every \ref/\uses resolves to a defined \label, every annotation has a non-empty argument, and no axiom declarations are present under the project's .lean files.`
- `sync_leanok` iter-181: added 1, removed 1; touched `Albanese_AuslanderBuchsbaum.tex` and `Picard_RelativeSpec.tex`.
