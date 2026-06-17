# Lean Audit Report

## Slug
iter031

## Iteration
031

## Scope
- files audited: 3 (per directive focus — all three modified this iter)
- files skipped (per directive): all other `.lean` files — no-changes-this-iter restriction in directive

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 33–44**: Stale "Planner note" block reads "The prover should build `affineChart` as..." — `affineChart` is already defined at line 56. The note was never removed after `affineChart` was built. Minor outdated comment.
  - **Lines 876, 1098**: `set_option maxHeartbeats 1600000` appears twice. Both carry explanatory comments placed **after** the `set_option` line (correct Mathlib linter placement). LSP diagnostics confirm zero warnings on these lines. The raised limits are substantiated: line 876 comment cites the `HasPullback` instance-diamond `erw` defeq cost; line 1098 comment cites the `Iso.inv_hom_id_assoc`/MvPolynomial away-localisation `simp` defeq cost. Not flagged.
  - **8 new iter-031 declarations verified axiom-clean** (propext, Classical.choice, Quot.sound only):
    - `awayMulCommEquiv_comp_awayInclLeft` (line 935) — term-mode ring-hom ext proof; clean.
    - `rotMid` (line 944) — private helper for cocycle rotation; clean.
    - `transitionInvImageMatrix` (line 961) — private matrix helper; clean.
    - `transitionInvPair` (line 1026) — private iso-pair for transition inverse; clean.
    - `cocyclePhiId` (line 1066) — the central ring-level cocycle Φ = id; axiom-clean confirmed via `lean_verify AlgebraicGeometry.Grassmannian.cocyclePhiId`.
    - `chartTransition'_cocycle` (line 1106) — scheme-level cocycle; uses `set_option maxHeartbeats 1600000`; axiom-clean confirmed via `lean_verify AlgebraicGeometry.Grassmannian.chartTransition'_cocycle`.
    - `theGlueData` (line 1141) — `Scheme.GlueData` record, all fields filled from named declarations; axiom-clean confirmed via `lean_verify AlgebraicGeometry.Grassmannian.theGlueData`.
    - `scheme` (line 1157) — `noncomputable def scheme (d r : ℕ) : Scheme := (theGlueData d r).glued`; one-liner delegating to `GlueData.glued`; axiom-clean confirmed via `lean_verify AlgebraicGeometry.Grassmannian.scheme`.
  - **Zero sorrys, zero admits, zero diagnostic errors** on entire file.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: none (the 4 sorry stubs are known/pre-existing per directive)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 4 flagged (all pre-existing, known/out-of-scope per directive)
- **notes**:
  - **4 new iter-031 declarations verified axiom-clean**:
    - `overRestrictEquiv` (line 930) — `SheafOfModules (X.ringCatSheaf.over U) ≌ U.toScheme.Modules` via `SheafOfModules.pushforwardPushforwardEquivalence`; axiom-clean confirmed.
    - `overRestrictFunctorIso` (line 963) — functor-level iso identifying slice functor with `restrictFunctor U.ι`; axiom-clean confirmed.
    - `overRestrictIso` (line 980) — object-level form `(overRestrictFunctorIso U).app M`; honest one-liner; axiom-clean confirmed.
    - `overRestrictPullbackIso` (line 990) — `overRestrictIso U M ≪≫ (restrictFunctorIsoPullback U.ι).app M`; axiom-clean confirmed.
  - **Zero compilation errors** on entire file (confirmed via LSP diagnostics).
  - **4 pre-existing sorry stubs** (flagged below as excuse-comments, classified per directive as out-of-scope):
    - `hilbertPolynomial` (line 123), `QuotFunctor` (line 165), `Grassmannian` (line 201), `Grassmannian.representable` (line 228).

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: none
- **suspect definitions**: none (the 4 sorrys are openly acknowledged)
- **dead-end proofs**: none
- **bad practices**: 3 flagged (1 unused simp arg, 2 misplaced maxHeartbeats comments)
- **excuse-comments**: none
- **notes**:
  - **Lines 1369–1371 and 979–981**: `set_option maxHeartbeats 4000000` appears with explanatory comments placed **before** the `set_option` line, triggering the Mathlib style linter: `"Please, add a comment explaining the need for modifying the maxHeartbeat limit, as in set_option maxHeartbeats N in -- reason"`. The explanations exist (lines 1369–1370 and 979–980) but in the wrong position. Minor style defect; not a correctness issue.
  - **Line 1452**: `simp only [base_change_mate_codomain_read_legs, Iso.trans_hom, Functor.mapIso_hom, Functor.map_comp, Category.assoc, Functor.comp_map]` — LSP diagnostic at line 1452, col 5: `"This simp argument is unused: Functor.map_comp"`. The other 5 lemmas in the simp set DO fire (the `simp only` is not a no-op), but `Functor.map_comp` is dead weight in this simp call. The docstring accurately claims a "concrete advance" (the live lemmas do simplify the goal), so this is not misleading — just a stale inclusion.
  - **Line 1486, `base_change_mate_fstar_reindex`**: proof body is `exact base_change_mate_fstar_reindex_legs ψ φ M _ _ hfst hsnd ...`, so this declaration is **transitively sorry-backed** through `_legs`. Its docstring describes the instantiation but does not include a sorry-backed disclaimer. This is a minor documentation gap — the chain is visible from the proof body but not surfaced in the docstring.
  - **Line 1635, `base_change_mate_inner_value_eq`**: proof body is `exact base_change_mate_fstar_reindex ψ φ M`, transitively sorry-backed two steps removed. No sorry-backed disclaimer in docstring. Same minor documentation gap.
  - **Correct sorry-backed disclaimers are present** on: `base_change_mate_section_identity` (line 1873) and `pushforward_base_change_mate_cancelBaseChange` (line 1943). These two correctly acknowledge their transitive dependency on `base_change_mate_gstar_transpose`.
  - **4 remaining sorrys** (all pre-existing per directive; locations verified):
    1. `base_change_mate_fstar_reindex_legs` — `sorry` at line ~1472; the iter-031 `simp only` at lines 1451–1452 is a genuine partial advance (5/6 lemmas fire per LSP).
    2. `base_change_mate_gstar_transpose` — `sorry` at line ~1844; accompanied by a detailed comment explaining what must be proved inline.
    3. `affineBaseChange_pushforward_iso` — `sorry` at line ~2025; affine reduction step.
    4. `flatBaseChange_pushforward_isIso` — `sorry` at line ~2047; final Čech-infrastructure step.
  - **Spurious `opaque` source-scan hits from `lean_verify`** at lines 848, 922, 1014, 1715, 1776, 1886: these are all the English word "opaque" used in explanatory comments (e.g. "the opaque object `Module R'` instances"), not Lean `opaque` declarations. Confirmed false positives — not flagged.

---

## Must-fix-this-iter

None.

All sorrys (QuotScheme × 4, FlatBaseChange × 4) are openly acknowledged. No load-bearing definitions have bodies that contradict the named concept. No unauthorized `axiom` usage detected. No weakened-wrong definitions. No parallel Mathlib API duplication.

The 4 excuse-comments in QuotScheme.lean meet the letter of the must-fix rule, but are classified below (see "Excuse-comments") as pre-existing out-of-scope per the directive's explicit carve-out. They are flagged for visibility; the plan agent should decide whether to gate them this iter.

---

## Major

- `GrassmannianCells.lean:33–44` — Stale planner-note block. The text "The prover should build `affineChart` as..." describes work that was already completed (`affineChart` lives at line 56). The note remains in the file unchanged and could mislead a future reader about what is built vs. unbuilt. Should be deleted.

---

## Minor

- `FlatBaseChange.lean:1452` — Unused simp argument `Functor.map_comp` in the new iter-031 `simp only`. LSP warning: `"This simp argument is unused"`. The `simp only` is not a no-op (5/6 lemmas fire), and the docstring claim of a "concrete advance" is accurate. Remove the dead argument.
- `FlatBaseChange.lean:1371` — `set_option maxHeartbeats 4000000` comment is placed two lines before the `set_option` rather than after it, triggering the Mathlib style linter. Move the comment to follow the `set_option` line. (Same pattern at line 979.)
- `FlatBaseChange.lean:979` — Same misplaced comment pattern as line 1371 (comment before `set_option maxHeartbeats 4000000`). Mathlib style linter fires at line 979.
- `FlatBaseChange.lean:1486` — `base_change_mate_fstar_reindex` docstring does not disclose sorry-backed status (inherited from `_legs`). The chain is inferable from the proof body but is not surfaced in documentation. Add a one-sentence disclaimer consistent with the disclaimers on `base_change_mate_section_identity` and `pushforward_base_change_mate_cancelBaseChange`.
- `FlatBaseChange.lean:1635` — `base_change_mate_inner_value_eq` docstring does not disclose sorry-backed status (two steps removed via `fstar_reindex` → `_legs`). Same recommendation: add a one-sentence disclaimer.

---

## Excuse-comments (always called out separately)

These are the four iter-176 skeleton comments in QuotScheme.lean. Per the directive they are pre-existing/out-of-scope for iter-031, but the auditor must call them out per policy.

- `QuotScheme.lean:119–126`: `"iter-177+: the body unfolds to a concrete computation ... For the iter-176 file-skeleton the body is a typed sorry."` — attached to `hilbertPolynomial` (line 123). Severity: **major** (load-bearing; blocks downstream Hilbert polynomial results).
- `QuotScheme.lean:155–165`: `"iter-177+: the body packages ... For the iter-176 file-skeleton the body is a typed sorry."` — attached to `QuotFunctor` (line 165). Severity: **major** (load-bearing functor definition).
- `QuotScheme.lean:193–201`: `"iter-177+: re-exports ... For the iter-176 file-skeleton the body is a typed sorry."` — attached to `Grassmannian` (line 201). Severity: **major**.
- `QuotScheme.lean:219–228`: `"iter-177+: follows from Grassmannian ... For the iter-176 file-skeleton the body is a typed sorry."` — attached to `Grassmannian.representable` (line 228). Severity: **major** (representability claim is a core theorem).

Strict policy note: each of these meets the "suspect body on substantive claim" must-fix criterion (`:= sorry` on load-bearing declarations with excuse-comment). Classified major (not must-fix) only because the directive explicitly identifies them as known/out-of-scope for this iter.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 (1 stale planner note in GrassmannianCells; 4 excuse-commented sorry stubs in QuotScheme, pre-existing/out-of-scope per directive)
- **minor**: 5 (1 unused simp arg; 2 misplaced maxHeartbeats comments; 2 missing sorry-backed disclaimers)
- **excuse-comments**: 4 (all in QuotScheme.lean, pre-existing; also counted under major above)

**Overall verdict**: GrassmannianCells is axiom-clean with 8 genuine new declarations and no sorrys; QuotScheme adds 4 clean new defs against a backdrop of 4 pre-existing sorry stubs with excuse-comments; FlatBaseChange's iter-031 `simp only` advance is substantiated but carries a dead simp argument and two intermediate lemmas lack sorry-backed disclaimers — no blocking issues, only housekeeping.
