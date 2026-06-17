# Blueprint reviewer directive — iter-199 (slug: `iter199`)

## Task

Audit the WHOLE blueprint (do NOT scope to a subset). Report per-
chapter completeness + correctness verdict + must-fix-this-iter
findings + unstarted-phase blueprint proposals.

## Context (no scope-limiting; for orientation only)

This is the second iter under USER 2026-05-28 standing directive
(ROUTE C PAUSE permanent; Route A bottom-up execution). iter-198
ended at 78 sorries / 0 axioms. iter-199 plan-phase has applied
the following blueprint edits:

1. `Picard_FGAPicRepresentability.tex`: fixed broken
   `\cref{df:Pfs}` → `\cref{def:rel_pic_sharp}` (iter-198 blueprint-
   doctor flagged this).
2. `Albanese_AlbaneseUP.tex`: added NOTE on
   `lem:symmetric_product_to_jacobian` flagging hidden Route C
   (Riemann-Roch) dependency in the birationality proof step.
3. `RiemannRoch_WeilDivisor.tex`: added standalone
   `lem:rationalMap_order_finite_support` block with
   `\lean{...}` pin (was previously embedded inside
   `def:principal_divisor`).
4. `Albanese_AuslanderBuchsbaum.tex`: added standalone
   `lem:auslander_buchsbaum_formula_succ_pd` block pinning
   the inductive-step helper + added
   `lem:depth_drops_by_one` block pinning the iter-198 new
   axiom-clean helper.
5. `Albanese_CodimOneExtension.tex`: added `\lean{...}` pin to
   `lem:smooth_to_regular_local_ring` (existing typed-sorry Lean
   declaration `isRegularLocalRing_stalk_of_smooth` was previously
   un-pinned); replaced the `_aux` pin on
   `lem:stage6_regular_stalk_assembly` with a NOTE explaining the
   in-body assembly pattern.

A blueprint-writer for `Picard_RelPicFunctor.tex` is also being
dispatched this iter to add `% NOTE: placeholder body` markers and
resolve the iter-198 lean-vs-blueprint-checker type-weakening
finding on `thm:rel_pic_etale_sheaf_group_structure`.

## What to report

1. Per-chapter complete + correct verdict (your standard format).
2. HARD GATE verdict for each `.lean` file under active prover
   consideration this iter:
   - `WeilDivisor.lean` → `RiemannRoch_WeilDivisor.tex`
   - `AuslanderBuchsbaum.lean` → `Albanese_AuslanderBuchsbaum.tex`
   - `CodimOneExtension.lean` → `Albanese_CodimOneExtension.tex`
   - `FGAPicRepresentability.lean` → `Picard_FGAPicRepresentability.tex`
3. Unstarted-phase blueprint proposals — name any strategy phase
   that has no blueprint coverage (one outline per missing-coverage
   phase). The iter-198 reviewer flagged 3
   (`Picard_CarrierSoundnessProbe.tex`, `Picard_PicDSubstrate.tex`,
   `Albanese_TangentSpaceSubstrate.tex`); re-evaluate whether any
   of these now warrant a writer dispatch (the iter-198 plan
   deferred all three).
4. Strategy-modifying findings — if any chapter prose surfaces a
   strategic issue (hidden route dependency, wrong definition,
   etc.), flag it under a `## Strategy-modifying findings` section.

## Particularly worth auditing this iter

- The iter-199 edits above (especially the `Albanese_AlbaneseUP.tex`
  Route C NOTE and the new `RiemannRoch_WeilDivisor.tex` lemma block)
  — confirm they don't introduce inconsistencies or break existing
  `\uses{...}` chains.
- The 4 prover-gate chapters' HARD GATE verdicts post-iter-199
  edits — confirm they're still CLEAR (or DEFER with specific
  follow-up writer dispatch needed).
- The `Picard_FGAPicRepresentability.tex` `\cref{df:Pfs}` fix — was
  `def:rel_pic_sharp` the right target, or is there another label
  the writer should have pointed to?
