# Iter 037 — Review (Quot-Foundations)

## Verdict
Build GREEN — both prover-edited modules (`GrassmannianCells.lean`, `QuotScheme.lean`) `lake build`
exit 0 (8317 jobs each; GrassmannianCells 33s; pre-existing scaffold `sorry` + style/deprecation/
maxHeartbeats warnings only). `FlatBaseChange.lean` was NOT edited (FBC-A1 was investigation-only).
All 5 new decls `lean_verify` = `{propext, Classical.choice, Quot.sound}` (provers + lean-auditor).
blueprint-doctor: **0 findings**. `sync_leanok` (iter 37, sha `a4c1e7d`): **+6 `\leanok`, 0 removed**
(Picard_GrassmannianCells, Picard_QuotScheme). leandag gaps=0, unmatched=14 (coverage debt: 3 substantive
public + 1 FBC redundant variant + ~10 private).

**One-keystone-landed iter: net 0 active sorry (FBC 4→4, QUOT 4→4 stubs, GR 0→0), +5 axiom-clean decls.
GR-E3full lane CLOSED. QUOT landed its two named bridges but deferred the Hfr assembly. FBC-A1's clean
assembly pass closed nothing → the pre-set tripwire FIRED; iter-038 dispatches a mathlib-analogist.**

## Overall progress this iter (active `sorry` per file)
- **GR 0 → 0 (LANE CLOSED — keystone landed).** `existence_factor_through_valuationRing`
  (`lem:gr_existence_factor_through_valuation_ring`) axiom-clean, closing the last matrix-algebra gap of
  the valuative-criterion existence step. +3 decls: `det_one_updateCol` (private; column-substituted-identity
  determinant = `v p`, no sign, via `Matrix.cramer_apply`+`mulVec_cramer`), `exists_minorDet_eq_free_entry`
  (NEW public; free entry = ±signed minor via `det_permute'`+`Int.units_eq_one_or`), and the E3-full
  assembly. GR existence now reduces to **E4 `existence_lift`** + `valuativeExistence_toSpecZ` → `isProper`
  (the `isProper_of_valuativeExistence` reduction @~1531 is already in place). A fresh phase.
- **QUOT 4 → 4 stubs (two named bridges LANDED; Hfr assembly deferred).** +2 axiom-clean non-private decls:
  `isLocalizedModule_of_ringEquiv_semilinear` (I — `IsLocalizedModule` across a ring iso + semilinear
  `AddEquiv`s; Mathlib only has the same-ring `of_linearEquiv`) and `isLocalizedModule_restrictScalars_powers_algebraMap`
  (II — descend a localization at `powers (algebraMap R Rr f)` to `powers f`). The Hfr chain + named
  `isLocalizedModule_basicOpen_descent` + gap1 were NOT attempted as compiling decls — the remaining wall is
  the **semilinearity of `gammaPullbackImageIso.hom` over the per-stage structure-sheaf ring iso**, its own
  sub-build. With (I)+(II) in hand the assembly is now a producing-`σ`'s + semilinearity + mechanical
  three-stage chain.
- **FBC-A1 4 → 4 (assembly pass closed nothing → TRIPWIRE FIRES).** No code edits. Verified that step (a)
  (inline reindex) and the crux `_legs_conj` (@1647, sorry @1700) are the SAME dependent-motive obstruction
  (`rw [← hW]` → "motive is not type correct"); the parametrised-leg conjugate discharge needs three unbuilt
  pieces (reframing keystone + conj-2b + conj-2d). Step (c) fusion (`rw [← Functor.map_comp]`) verified but
  the ~100-LOC `huce`-substitution glue is unbuilt and off the blind-`rw` route. Per the enforced tripwire,
  iter-038 dispatches a **mathlib-analogist** (cross-domain) on the reframing keystone — NOT another helper
  round, NOT user escalation. Do NOT re-assign an assembly/conjugate/section round on `_legs_conj`/step (a).

## Critic / auditor dispositions (all dispatched this review phase)
- **lean-auditor `iter037`** (both edited files): **0 must-fix**, 4 major (pre-existing scaffold
  excuse-comments on the 4 QuotScheme `iter-176` stubs — directive-acknowledged, not new dead code), 1 minor
  (vague `task_results/.../QuotScheme.md` doc-path). All 5 new decls confirmed honest + axiom-clean; no new
  sorry anywhere. → recommendations LOW.
- **lean-vs-blueprint-checker ×2** (the two edited files), **0 must-fix-this-iter on either**:
  - `gr037` (2 major): `exists_minorDet_eq_free_entry` is public with no `\lean{}` block (suggest
    `lem:gr_free_entry_eq_signed_minor`); cofactor sub-step under-specified in the blueprint. 1 minor:
    `existence_factor_through_valuationRing` proves range-membership (equivalent to the prose's factoring).
  - `quot037` (2 major): the two new transport theorems lack proper `\lean{}` blocks (only a NOTE mention).
    +1 pre-existing major (`Grassmannian.representable` pin under-delivers prose — authorized scaffold), 3
    minor (pending-gap NOTEs should track the two transports as gating). → recommendations HIGH (coverage
    debt) + LOW.

## Blueprint markers updated (manual, this review)
- **None.** No new Mathlib-alias decls (no `\mathlibok` warranted); no `\lean{}` renames flagged (names
  match); no stale `\notready` present. The 3 coverage-debt blocks (`exists_minorDet_eq_free_entry` + the two
  QUOT transports) and the `Grassmannian.representable` strengthening are **planner blueprint-authoring
  tasks** (informal prose — outside the review agent's marker domain). Listed in `recommendations.md`.

## leandag / structural
- gaps=0 (no ∞ holes). unmatched=14: 3 substantive public (the coverage-debt blocks above), 1 FBC redundant
  variant (`base_change_mate_extendScalars_inner_value_counit` — blueprint or schedule removal), ~10 private
  (no obligation). blueprint-doctor 0 findings.

## Subagent skips
- lean-vs-blueprint-checker (FlatBaseChange.lean): FBC-A1 was investigation-only — `FlatBaseChange.lean`
  received NO prover edits this iter (attempts_raw `files_edited` lists only GrassmannianCells + QuotScheme).
  Per the descriptor, the per-file checker is dispatched per prover-EDITED file; FBC has no new code to
  verify against its chapter.

## TO_USER.md
Updated (janitor): FBC bullet now states the tripwire fired and iter-038 goes to a mathlib-analogist
(decision made, autonomous); GR+QUOT merged into one progress bullet (E3-full CLOSED; QUOT two transports
landed, semilinearity wall named); Hilbert-poly reference ask retained.
