# Recommendations for iter-016 (from session_15 review)

## CRITICAL / HIGH — blueprint-writer rounds REQUIRED before re-dispatching provers

The HARD GATE applies to all three live lanes: each chapter has a must-fix-this-iter blueprint
finding, so a writer round (then a scoped re-review) must clear the gate before a prover is sent.

1. **[HIGH · FBC] Expand Seam 2 + Seam 3 sketches with the actual formalization mechanism**
   (lvb-fbc must-fix). `lem:base_change_mate_fstar_reindex` (Seam 2) must name
   `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` (mirror the iter-014 Seam-1 idiom that
   worked); `lem:base_change_mate_gstar_transpose` (Seam 3) must name `pullback_spec_tilde_iso` and the
   counit-naturality step. Without these, the prover churns (it already landed the leg-identification
   scaffold this iter and stalled exactly at the missing coherence). After the writer: scoped
   blueprint-reviewer re-review of `Cohomology_FlatBaseChange.tex` → then prove Seam 2 → Seam 3 (Seam 3
   cascades to `section_identity`/`generator_trace`/`cancelBaseChange`).

2. **[HIGH · GF] Blueprint the new helper + fix Step 4** (lvb-gf must-fix).
   - Add a blueprint block (e.g. `lem:gf_away_tower_descent`) with `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}`,
     statement: *free over `(T_g)_h` for some `h ≠ 0` ⟹ free over `T_f` for some `f ≠ 0 ∈ A`*, and a
     `\uses{}` to the localisation-transport lemmas (`IsLocalization.surj`, `awayToAwayLeft`).
   - Fix Step 4 of `lem:gf_polynomial_core` (`exists_free_localizationAway_polynomial`): it cites the
     wrong lemma for the tower-descent case (lvb-gf). The Lean reduces L5 to this new helper; the prose
     must match.
   - **Verify the witness before proving:** lean-auditor flags the helper's proof-plan `hf0 hf0` would
     give freeness at `f²` rather than `f`. Confirm the intended witness is `f := g·a` (single power),
     not a square, when the prover closes it.

3. **[HIGH · QUOT] Blueprint surgery on G1 + pin the two sub-lemmas** (lvb-quot; I added a `% NOTE:`).
   The pin `\lean{...homogeneousSubmodule_decomposition}` names a non-existent decl. Either:
   (a) split the `G1` block into two — one for `homogeneousSubmodule_inf_iSupIndep` (independence) and
   one for `homogeneousSubmodule_iSup_inf_eq` (supremum) — and retarget the pins; or
   (b) keep the bundled statement but route G2–G4 consumers through the two unbundled halves.
   D5 (`degreewise_finrank_diff`) is fine as-is (clean pin).

## CRITICAL — do NOT retry without a structural change

- **[QUOT] The bundled `DirectSum.IsInternal` / `Decomposition` over `↥p` or `M⧸p` is a hard blocker.**
  Three attempts (chooseDecomposition; unbundled IsInternal + maxHeartbeats to 2M; rw-based) all hit a
  `(deterministic) timeout at isDefEq/whnf` that budget does not fix. **Do not re-assign the bundled G1
  / any G2–G4 form stated over the subtype/quotient carrier.** Corrective TYPE = mathlib-analogist
  consult (Mathlib's canonical construction of a `Decomposition` on a homogeneous submodule / graded
  quotient), OR architecturally route every graded fact through the **ambient `M`** (as the two landed
  G1 halves do) and transport to `↥p`/`M⧸p` only through a thin `LinearEquiv` at the very end. See
  `memory/graded-quotient-module-isdefeq-pathology.md` and PROJECT_STATUS Known Blockers.

## 1-to-1 coverage debt (`archon dag-query unmatched` → 3 nodes) — planner blueprints these

- `AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower` (GF, `has_sorry`) — covered by
  HIGH #2 above (needs a `lem:gf_away_tower_descent` block). Lean dep: `IsLocalization.surj`,
  `IsLocalization.Away.awayToAwayLeft`, `LocalizedModule` iterate.
- `AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep` (QUOT, proved) — public theorem,
  needs a `\lean` pin (HIGH #3). Lean dep: `iSupIndep.mono`, `DirectSum.Decomposition.isInternal`.
- `AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq` (QUOT, proved) — private; the
  doctrine still wants a tex block, but acceptable to fold into the G1-supremum block from HIGH #3.
  Lean dep: `DirectSum.sum_support_decompose`, `Submodule.IsHomogeneous.mem_iff`.

## MEDIUM — Lean cleanup (prover-cleanup; review cannot edit `.lean`)

- **[FBC] Dead `RegroupHelper` import** (lean-auditor major): its export is never called. Remove the
  import or wire up the consumer.
- **[FBC] Cross-project stale `STATUS (iter-234)` / `UPDATE (iter-236)` comments** (lean-auditor major;
  tracked since iter-011). Orphaned from the pre-extraction project. Also the broken `informal/` path
  reference at FBC:1415 (minor) and the unprofiled 10× heartbeat bump at FBC:975 (minor — profile or
  justify).
- **[GF] 4M `maxHeartbeats` ceiling insufficient on cold `lake env lean`** (lean-auditor major). Module
  builds green under `lake build`; if a future cold-compile gate matters, the instance-search depth over
  `MvPolynomial (Fin (m+1)) (Localization.Away g)` must be reduced (decompose the assembly), not budgeted.
- **[GrassmannianCells / RegroupHelper] stale scaffold comment + inaccurate module docstring**
  (lean-auditor major/minor) — cosmetic; fold into the next prover touch.

## Progress / dispatch guidance

- **GF is CHURNING again** (sorry 4→5, +1 helper, 0 closed; iter-014 broke the prior wall but this iter
  re-accreted). The progress-critic's corrective stands: do NOT assign another raw helper round —
  the next GF dispatch must be a *closure* of `free_localizationAway_of_away_tower` (after its blueprint
  block lands), not more decomposition.
- **QUOT delivered real content (3 axiom-clean decls)** but the lane's headline goal (unblock the 4
  stubs) is blocked by the isDefEq pathology — this is architectural, not proof-search. Resolve the
  blocker (analogist consult) before committing more QUOT prover budget; the 4 public stubs stay deferred.
- **FBC is the cleanest re-dispatch** once its Seam 2/3 sketch is expanded — the prover got to the exact
  coherence gap and the iter-014 Seam-1 idiom is the template.

## Closest-to-completion / promising

- **FBC Seam 2** — scaffold in place, only the conjugate-calculus coherence remains; highest-leverage
  closure once blueprinted (cascades to 4 downstream decls).
- **QUOT G1 (unbundled halves) DONE** — D5 + both G1 halves axiom-clean; the next graded-API piece (G2
  quotient grading) should be attempted in ambient-`M` form to dodge the pathology.

## Do NOT re-assign as-is
- QUOT bundled `homogeneousSubmodule_isInternal` / `_decomposition` (see CRITICAL above).
- FBC Seam 2/3 and GF tower-descent helper as raw prover targets *before* their blueprint blocks are
  fixed (HIGH #1–#3) — all three would churn against under-specified/missing sketches.
