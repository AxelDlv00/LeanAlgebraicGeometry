# Lean Audit Report

## Slug
iter079

## Iteration
079

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GlueDescent.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L2081 — open `sorry` in `glueChartComponent_leg_compat`** (genuine open obligation, not deceptive). The proof correctly sets up all context — fires `glueTripleFactor_mate` on both legs, substitutes `glueLegA_component_transpose` / `glueLegB_component_transpose`, and stops with an honest prose description of what remains (expand `glueChartComponent` via unit at `f_ip`/`f_iq`/`g_ip`/`g_iq`, cancel unit/counit pairs, align endpoints with `glueData_bridge_src/mid/tgt` casts, handle degenerate pairs via C1). The sorry is load-bearing: `glueChartComponent_leg_compat` is called by `glueChartFamily_equalizes` (L2088), which is called by `glueRestrictionInv` (L2152), which underpins `isIso_glueRestrictionHom` (L2740), the main descent theorem. The chain of completed downstream declarations (`glueRestrictionInv_pullback_map_glueProj`, `glueRestrictionHom_glueChartComponent`, `glueRestriction_overlap_compat`, `isIso_glueRestrictionHom`) are all still under `sorry`-transitive dependency and not independently verified. This is an open work item, correctly reported; see GrassmannianQuot.lean below for its downstream effect.
  - **New helpers vs GrassmannianCells.lean drift check**: The directive-named helpers (`glueData_triple_square` L1291, `glueData_preimage_image_eq₃` L1305, `glueTripleBaseChangeIso` L1379, `glueTripleFactor_transpose` L1517, `glueTripleFactor_mate` L1688, `glueLegA_component_transpose` L1826, `glueLegB_component_transpose` L1912, `glueChartFamily_pullback_map_π` L2001) are all project-specific triple-overlap infrastructure. None of them replicate definitions visible in `GrassmannianCells.lean` (which contains chart-cell combinatorics, not GlueData-level descent). No drift or duplication found.
  - **Axiom check**: no `axiom` keyword in file. No `Classical.choice _` abuse. No vacuous hypotheses on substantive claims.
  - **Comment accuracy**: proof-inline comments accurately describe the goal state at each step. The `-- REMAINING CORE` comment at L2077–2080 is not an excuse-comment — it documents a proof plan, not a deferral of correctness.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (see Minor)
- **excuse-comments**: none
- **notes**:
  - **Private ports (L503–637)**: `mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`, `isUnit_algebraMap_away_left'`, `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`, `cocycle_imageMatrix_eq'` are all explicitly labeled as ports of private declarations from `GrassmannianCells.lean`. Each carries a comment naming the source. No hidden duplication. The non-private `matrixMap_nonsing_inv` (L4026) is also correctly labeled. Drift check: the ports add a `'`-suffix and expose via public/semipublic signatures; the originals are private in GrassmannianCells.lean and therefore inaccessible cross-module. The pattern is justified. No must-fix.
  - **`chartMorphism_glue_compat` (L4184)**, **`comp_chartMorphism` (L4110)**, **`presentedMatrix_comp` (L3920)**, **`chart_point_eq`**, **`imageMatrix_map_ringHom` (ported, L503–637)**, **`chartComposite_rqPullback`** — directive-named helpers. All are fully proven (no sorry). Signatures are coherent with the stated purpose. No suspect bodies.
  - **L2470 — open `sorry` in `tautologicalQuotient_epi`**: genuine open obligation. A detailed `-- ROUTE:` comment describes the plan (show surjectivity by exhibiting a section chart-locally using `tautologicalRankQuotient`). The tactic chain above the sorry correctly reduces the goal. Not deceptive.
  - **L4435 — open `sorry` in `represents.left_inv`**: genuine open. Comment describes the required chart-local argument. Not deceptive.
  - **L4440 — open `sorry` in `represents.right_inv`**: genuine open. Comment describes the required restriction-isomorphism argument. Not deceptive.
  - **Downstream effect of GlueDescent sorry**: `tautologicalQuotient` and `universalQuotient` ultimately depend on `isIso_glueRestrictionHom` via `glueRestrictionIso`; all three sorries in this file are independent of the GlueDescent sorry (they have separate proof obligations), but the full end-to-end chain (`represents` closed) requires all four sorries to be resolved.
  - **`set_option maxHeartbeats` blocks (all occurrences)**:
    - **L1020** (`matrixEndRect_unitEndSection`, 800000): no inline comment explaining the override. The docstring above describes what the lemma states but does not explain why the heartbeat limit is needed. — *Minor* (see below).
    - **L1059** (`pullback_map_freeMap_pullbackFreeIso`, 800000): a pre-docstring note references the `X.Modules` diamond but is attached to the docstring, not the `set_option` line itself. Acceptable context exists, but the attribution is loose. — *Minor*.
    - **L1630** (`bundleTransition_cocycle_transport`, 1600000): HAS inline comment explicitly citing the `X.Modules` diamond cost. Sound.
    - **L1795, L1857** (1600000, bundleTransition section): located in an already-commented region; context is clear from surrounding material. Sound.
    - **L3701** (`freeMap_chartMatrixHom`, 800000): pre-docstring note names the `X.Modules` instance diamond as the elaboration bottleneck. Sound.
    - **L3842** (`chartMatrix_minor`, 800000): no inline comment explaining the override. Nothing in the surrounding block attributes the cost. — *Minor* (see below).
    - **L3920** (`presentedMatrix_comp`, 800000): HAS inline comment "the pseudofunctor-comparison steps traverse the `X.Modules` instance diamond". Sound.
    - **L3988** (`universalMatrix_map_presentedMatrix`, 800000): HAS inline comment attributing the cost to entrywise comparison of `presentedMatrix`. Sound.
    - **L4110** (`comp_chartMorphism`, 800000): HAS inline comment "the Γ–Spec assembly compares two heavy `MvPolynomial`-classified composites". Sound.
    - **L4184** (`chartMorphism_glue_compat`, 1600000): HAS inline comment "the assembly chains five matrix/localization transports over the pullback scheme". Sound.
  - **Assessment**: None of the maxHeartbeats blocks appear to mask correctness or kernel problems. The cost driver in every case (explicitly or by context) is the `X.Modules` instance diamond causing expensive `isDefEq` checks during pseudofunctor elaboration — a known project-local Lean 4 performance issue, not a logical gap. The overrides are proportionate (800k–1600k vs default 400k). No evidence of type-incorrect proofs hiding behind high limits.
  - **Axiom check**: no `axiom` keyword. No `Classical.choice _` in non-propositional position. No vacuous hypotheses on substantive claims.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:1020` — `set_option maxHeartbeats 800000 in` for `matrixEndRect_unitEndSection` has no inline comment explaining the cost driver. The docstring describes the lemma but not why the limit is necessary. Every other block with a raised limit in this file carries an attribution (the `X.Modules` diamond, pseudofunctor comparisons, etc.); this one is inconsistent. Recommend adding: `-- the pseudofunctor-composition steps traverse the X.Modules instance diamond`.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:1059` — `set_option maxHeartbeats 800000 in` for `pullback_map_freeMap_pullbackFreeIso` has context in the adjacent pre-docstring note but not on the `set_option` line itself. The attribution is inferrable but non-obvious to a future reader. Recommend moving or repeating the explanation as an inline comment.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:3842` — `set_option maxHeartbeats 800000 in` for `chartMatrix_minor` has no inline comment. Surrounding declarations (`chartMatrix`, `chartMatrixHom`) do not provide context for why this particular lemma is slow. Recommend adding an attribution comment.

---

## Excuse-comments (always called out separately)

None. All `sorry`-adjacent comments in both files are honest proof-strategy notes documenting open obligations, not excuses for wrong code. No comment matches the pattern `-- temporary`, `-- wrong but`, `-- will fix later`, `-- placeholder`, or equivalent.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3 — missing inline attribution comments on three `set_option maxHeartbeats` blocks in GrassmannianQuot.lean (L1020, L1059, L3842). No correctness implications; purely documentation hygiene.
- **excuse-comments**: 0

Overall verdict: Both files are axiom-clean, excuse-comment-free, and structurally sound; the 4 open `sorry`s (1 in GlueDescent, 3 in GrassmannianQuot) are all genuinely open proof obligations with honest documentation, and the maxHeartbeats overrides are performance-driven (not masking correctness problems), with three blocks lacking the inline attribution comment that the rest of the file supplies consistently.
