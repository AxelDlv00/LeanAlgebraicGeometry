# Lean Audit Report

## Slug
iter080

## Iteration
080

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GlueDescent.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 34: Comment `"axiom-clean since iter-056"` — stale iteration-number reference. The claim
    (no `axiom`) is correct, but the iteration pin is meaningless context. Minor.
  - Lines 3333–3346: Docstring for `isIso_glueRestrictionHom` (line 3347) retains
    `"PROOF ROUTE (scoped iter-066, partially built)"` and a trailing
    `"Remaining work: construct β_ij (via …) and verify the three conditions."` block.
    The theorem is fully proved (no `sorry`, no `axiom`; proof runs lines 3362–3381).
    The "partially built / Remaining work" language claims open obligations that no longer
    exist. Misleads future readers into thinking the proof is incomplete. Major.
  - No `sorry` or `axiom` anywhere in the 3409-line file.
  - No `set_option maxHeartbeats` anywhere in the file.
  - Private helpers `comp4_solve_last`, `comp4_solve_mid`, `comp4_solve_front`,
    `comp5_rearrange`, `side_collapse_left`, `side_collapse_right`, `final_cancel`
    (and many more abstract-category tactic helpers) — all used; none dead-end.
  - `glue`, `glueLift`, `glueRestrictionIso`, `isIso_glueRestrictionHom` — all proved,
    all connected in the dependency graph.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (the one sorry is honestly open; see below)
- **bad practices**: 1 flagged (maxHeartbeats block at line 1059)
- **replicated private lemmas**: 2 groups (8 lemmas total)
- **excuse-comments**: none
- **notes**:
  - **Residual sorry (confirmed honest):** Line 2469,
    `theorem tautologicalQuotient_epi (d r : ℕ) : Epi (tautologicalQuotient d r) := by sorry`.
    Preceded by a detailed ROUTE comment (lines 2456–2468) explaining the proof strategy
    and naming the missing ingredient ("the joint-reflection lemma"). The sorry is
    intentional and correctly placed. `tautologicalRankQuotient` (line 2475) uses
    `tautologicalQuotient_epi d r` in its `epi` field — load-bearing and correctly so;
    the downstream `represents` theorem (line 5469) ultimately depends on it through
    `tautologicalRankQuotient`. No laundering of this sorry was found (no alias, no
    `noncomputable def`, no `Classical.choice` substitute).
  - **Stale "not yet formalized" on complete proof (line 2621):** Docstring for
    `chartLocus_isOpenCover` (line 2632) contains
    `"PROOF ROUTE (scoped iter-067, not yet formalized):"`.
    The proof is complete and spans lines 2632–2852 with 0 sorry. The "not yet formalized"
    note is a historical artefact. Major.
  - **Stale iter-ref (line 443):** Docstring for `bundleTransition_self` contains
    `"Resource note (iter-060)"`. The content is correct; the iteration pin is noise. Minor.
  - **Stale iter-ref (lines 2456–2468):** ROUTE comment for `tautologicalQuotient_epi`
    contains `"scoped iter-066"`. The sorry is honestly open; the iter-pin is stale. Minor.
  - **maxHeartbeats without explicit attribution (line 1059):**
    `set_option maxHeartbeats 800000 in` for `pullback_map_freeMap_pullbackFreeIso`.
    The surrounding docstring describes the proof approach, but there is no inline `--`
    comment immediately before the `set_option` line explaining *why* the heartbeat budget
    needs raising (e.g. the cost driver). Every other `maxHeartbeats` block in the file
    (lines 1020, 1630, 1795, 1857, 3079, 3701, 3842, 3920, 3988, 4110, 4184, 4509, 4619,
    4937, 5110, 5148, 5195, 5236) carries an inline attribution comment. Minor.
  - **Private lemma replication — group 1 (lines 503–638):** 7 private lemmas with trailing
    `'`-names (`mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`,
    `isUnit_algebraMap_away_left'`, `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`,
    `cocycle_imageMatrix_eq'`) — verbatim or near-verbatim ports of private declarations
    from `GrassmannianCells.lean`. Comment at line 498 acknowledges this:
    `"Port of GrassmannianCells.X (private there)"`. The correct fix is to make these
    non-private in `GrassmannianCells.lean` or relocate them to a shared helper file. Major.
  - **Private lemma replication — group 2 (line 4026):** `matrixMap_nonsing_inv` is
    explicitly declared `"Project-local (copy of the private helper in GrassmannianCells.lean)"`.
    Same issue as group 1. Major.
  - **Documented non-private duplication (line 4038):** `imageMatrix_map_ringHom` is
    described as `"Non-private CommRing form of the helper inside GrassmannianCells.lean"` —
    a genuine CommRing generalisation rather than a verbatim copy. Should still be sourced in
    a shared location eventually. Minor.
  - **Documented verbatim proof copy (line 4070):** `chart_point_eq` notes `"proof copied
    verbatim"` from `existence_chart_kpoint_eq`. The `Field` hypothesis of the original is
    claimed to be unused. The generalisation is correct and the copy is documented. Minor.
  - Lines 1–2468 and 2470–5493: no additional `sorry` or `axiom`. All closed proofs are
    genuinely closed.
  - The `biproduct_matrix_comp` / `biproduct_matrix_comp_rect` / `biproduct_matrix_comp_rect₂`
    trio (lines 157, 254, 1150) each handles a different index shape; all are used. Not
    dead-end.

---

## Must-fix-this-iter

None.

---

## Major

- `GlueDescent.lean:3333` — Docstring for `isIso_glueRestrictionHom` retains `"PROOF ROUTE
  (scoped iter-066, partially built)"` and `"Remaining work: construct β_ij …"`. The proof
  is complete (0 sorry). Remove or replace with a "PROOF SUMMARY" note.
- `GrassmannianQuot.lean:2621` — Docstring for `chartLocus_isOpenCover` retains
  `"PROOF ROUTE (scoped iter-067, not yet formalized):"`. The proof is complete (0 sorry,
  lines 2632–2852). Remove the "not yet formalized" qualifier.
- `GrassmannianQuot.lean:503` — 7 private lemmas ported verbatim from `GrassmannianCells.lean`
  (group 1). Should be made non-private in GrassmannianCells.lean or moved to a shared file;
  until then the duplication is a maintenance hazard.
- `GrassmannianQuot.lean:4026` — `matrixMap_nonsing_inv` explicitly declared as a copy of a
  private helper in `GrassmannianCells.lean` (group 2). Same resolution as group 1.

---

## Minor

- `GlueDescent.lean:34` — Stale comment `"axiom-clean since iter-056"`. Remove the iter-pin.
- `GrassmannianQuot.lean:443` — Stale `"Resource note (iter-060)"` in `bundleTransition_self`
  docstring. Remove the iter-pin.
- `GrassmannianQuot.lean:2456` — ROUTE comment for `tautologicalQuotient_epi` includes
  `"scoped iter-066"`. The sorry is honestly open; the iter-pin is stale. Remove.
- `GrassmannianQuot.lean:1059` — `set_option maxHeartbeats 800000 in` for
  `pullback_map_freeMap_pullbackFreeIso` lacks an inline attribution comment (all other
  `maxHeartbeats` blocks in the file have one). Add a short `-- <reason>` before the
  `set_option` line.
- `GrassmannianQuot.lean:4038` — `imageMatrix_map_ringHom` documented as a CommRing form
  of a private helper in GrassmannianCells.lean. Low risk; note for future factoring.
- `GrassmannianQuot.lean:4070` — `chart_point_eq` proof described as "copied verbatim".
  Low risk; consider upstreaming the CommRing generalisation to GrassmannianCells.lean.

---

## Excuse-comments (always called out separately)

None found. No comment in either file qualifies as an excuse-comment (no "TODO: replace with
real def", "placeholder", "temporary wrong", "will fix later" patterns).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: Both files are sorry-clean except for the one honestly-open `tautologicalQuotient_epi` (declared as the residual sorry in the directive); no laundering was found; no axioms. The four major issues are stale "proof-in-progress" docstrings on two complete proofs and a code-duplication pattern (private lemma replication from `GrassmannianCells.lean`) that is acknowledged but unresolved across 8 instances.
