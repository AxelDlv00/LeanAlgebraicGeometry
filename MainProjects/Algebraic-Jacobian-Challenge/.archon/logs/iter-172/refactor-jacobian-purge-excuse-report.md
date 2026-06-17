# Refactor Report

## Slug
jacobian-purge-excuse

## Status
COMPLETE

## Directive

### Problem
Per iter-171 lean-auditor verdict, the CRITICAL excuse-comment block under
`genusZeroWitness.isAlbaneseFor.key` at L237-263 of `AlgebraicJacobian/Jacobian.lean`
claimed the proof "CANNOT be wired" due to three plan-level gates (import cycle,
CharZero gate, missing base-change functor), all of which are stale relative to the
iter-163 Route C commitment (`rigidity_genus0_curve_to_grpScheme` is char-free,
import-clean from `AlgebraicJacobian.AbelianVarietyRigidity`, and the descent step
is a real but localized sub-build — not a plan-level gate). Additionally, the
strategic docstring on `genusZeroWitness` at L182-208 still framed the proof via
the OLD `rigidity_over_kbar` + faithfully-flat-descent strategy.

### Changes Requested
- Task 1: replace L237-263 excuse-comment block with an honest narrative referring
  to `rigidity_genus0_curve_to_grpScheme` and the localized pullback-+-descent
  sub-build.
- Task 2: refresh the docstring at L182-208 on `genusZeroWitness` to reflect the
  Route C strategy.
- Do NOT touch: declaration heads, fields, `key` body (`sorry` stays),
  `positiveGenusWitness` block, other declarations/docstrings, imports,
  `task_pending.md`, `STRATEGY.md`, blueprint chapters.

## Changes Made

### File: AlgebraicJacobian/Jacobian.lean

#### Edit 1 — Refreshed `genusZeroWitness` docstring (was L176-208 → now L176-197)
- **What:** Replaced the 33-line stale docstring framed around
  `rigidity_over_kbar` + CharZero + iter-127/iter-155 scaffolding history with a
  22-line Route C-aligned docstring naming
  `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` (in
  `AlgebraicJacobian.AbelianVarietyRigidity`, char-free, route-C, iter-163) as
  the genus-0 rigidity consumer. New docstring includes an explicit
  **Status (iter-172)** block enumerating the two residual sub-builds:
  (i) `Genus0BaseObjects` body-skeleton internal sorries, and
  (ii) the `k → k̄` pullback / descent step.
- **Why:** The previous docstring still cited the OLD M2.a `rigidity_over_kbar` +
  CharZero route as the closure path. Per iter-163 commitment, Route C
  (`rigidity_genus0_curve_to_grpScheme`) is the route, and the iter-156 CharZero
  fallback is demoted off-path.
- **Cascading:** none.

#### Edit 2 — Purged excuse-comment narrative inside `isAlbaneseFor` body (was L234-263 → now L223-234)
- **What:** Replaced the 30-line excuse narrative (claiming the proof "CANNOT be
  wired" due to import cycle / CharZero / missing base-change functor — all
  framed as out-of-file plan-level gates) with a 12-line honest narrative
  referring to `rigidity_genus0_curve_to_grpScheme` (declared in
  `AlgebraicJacobian.AbelianVarietyRigidity`, char-free and import-clean per
  iter-163), describing the residual sub-build as: pullback `(C, A, f, P)` to
  `Spec k̄`, apply the rigidity statement, descend the morphism equality via
  `Flat.epi_of_flat_of_surjective`. The new narrative explicitly states that
  the sub-build "is real but is not gated on any out-of-file plan-level
  decision."
- **Why:** The three gates the old block enumerated are all stale:
  (1) Import-cycle claim FALSE — `AbelianVarietyRigidity.lean` imports only
      `Genus`, `Genus0BaseObjects`, `RigidityLemma` (verified by inspection of
      that file's import block); importing it into `Jacobian.lean` is
      import-clean.
  (2) CharZero gate FALSE — `rigidity_genus0_curve_to_grpScheme` is char-free
      (the `[CharZero kbar]` instance was explicitly dropped per iter-163).
  (3) Base-change functor "missing" claim PARTIALLY valid but mischaracterised
      as a plan-level blocker; per directive it is a real but localized
      sub-build (`Over.tensorLeft`-style pullback + `Flat.epi_of_flat_of_surjective`
      descent), not a plan-level gate.
- **Cascading:** none — `key` body is still `sorry`, `refine ⟨η[A], key, ?_⟩`
  remains structurally intact, uniqueness block (L237-248) untouched, and
  `positiveGenusWitness` (L264+) untouched.

## New Sorries Introduced
None. The `sorry` on `genusZeroWitness.isAlbaneseFor.key` was already present
(L264 → now L236) and per directive must NOT be filled by this refactor. The
`sorry` on `positiveGenusWitness` was already present (was L303 → now L289)
and was untouched.

## Compilation Status
- `AlgebraicJacobian/Jacobian.lean`: **compiles** (`lake build
  AlgebraicJacobian.Jacobian` → 8321/8321 built, 4.5s). The two pre-existing
  `sorry` warnings are reported at L198 (`genusZeroWitness`) and L270
  (`positiveGenusWitness`) — both expected. One pre-existing long-line linter
  warning at L326 is unrelated to this refactor (it is in the
  `nonempty_jacobianWitness` docstring, outside the directive's write-domain).

## Verification
- `grep -n "CANNOT" AlgebraicJacobian/Jacobian.lean` → **0 matches** ✓ (the
  excuse-comment is fully purged).
- `grep -n "rigidity_over_kbar" AlgebraicJacobian/Jacobian.lean` → **1 match**
  at L26, in the **file-level** header docstring (`## Status (Phase C
  scaffolding)`). This match falls under the directive's "DO NOT TOUCH" list
  ("All other declarations / docstrings in the file") and is recorded for
  the plan agent under "Notes for Plan Agent" below.
- New line numbers:
  - Refreshed `genusZeroWitness` docstring: **L176-197**.
  - Replacement comment block inside `isAlbaneseFor`: **L223-234**.
  - `key` body `sorry`: **L235-236** (warning fires on the
    `noncomputable def genusZeroWitness` line at L198).
  - `positiveGenusWitness` `sorry`: **L289** (warning fires on
    `noncomputable def positiveGenusWitness` at L270).

## Notes for Plan Agent

1. **One residual `rigidity_over_kbar` reference remains** at L26, inside the
   file-level header docstring `## Status (Phase C scaffolding)` (lines L13-30).
   It says: *"the substantive mathematical content is the genus-`0` rigidity
   statement `rigidity_over_kbar` (M2.a; `AlgebraicJacobian.RigidityKbar`)."*
   This is stale relative to the iter-163 Route C commitment but falls outside
   this directive's write-domain ("All other declarations / docstrings in the
   file" listed under DO-NOT-TOUCH). The directive's verification language
   "at most 1 match (the historical reference in your refresh; **ideally 0**)"
   acknowledges this kind of residual. **Recommended follow-up directive**:
   refresh the file-level `## Status (Phase C scaffolding)` block (L8-53) in a
   future iteration to align item (1) of the "TWO `sorry`-bodied declarations"
   inventory with Route C, and update the stale iter-138+ closure horizon to
   the iter-172 status (rigidity consumer declared; gated on `Genus0BaseObjects`
   body-skeleton + pullback/descent).

2. **No import added.** The directive was explicit: `import
   AlgebraicJacobian.AbelianVarietyRigidity` is NOT added by this refactor.
   Adding it is iter-173+ structural work that requires careful import-graph
   analysis (currently `RigidityKbar.lean` imports `Rigidity.lean` which
   imports `Jacobian.lean` — the legacy cycle is real for the OLD route, but
   the new route via `AbelianVarietyRigidity.lean` is import-clean; the
   refactor lane that wires the import is a separate directive). The new
   comment narrative names the consumer explicitly so a future prover can
   find it.

3. **`positiveGenusWitness` docstring (L250-263) was untouched** per the
   directive's "What to leave UNTOUCHED" list. The plan agent may want to
   refresh this block in a future iteration as well — it still references
   STRATEGY.md M3 with the same M2-closes-first ordering that is now
   in-progress.

4. **Mathematical justification was sufficient** to perform both edits
   straightforwardly. No cascading breakage occurred — both edits are purely
   docstring/comment textual purges, and the `refine ⟨η[A], key, ?_⟩` +
   uniqueness scaffolding remained structurally intact.
