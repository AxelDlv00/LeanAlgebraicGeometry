# Blueprint reviewer directive — iter-194

You are dispatched for the iter-194 plan-phase whole-blueprint audit.

## Audit scope

Whole blueprint. Read every chapter under `blueprint/src/chapters/`.
Per chapter, render a `complete` + `correct` verdict + must-fix-this-iter
flags + concrete writer-directive seeds for any chapter that fails the
HARD GATE.

## Notable since prior dispatch (iter-192 reviewer; iter-193 timed out)

The iter-193 `blueprint-reviewer iter193` dispatch SUBPROCESS TIMED OUT
after 28 minutes mid-Write; findings were reconstructed from the agent's
final thinking trace and actioned inline:

1. `AbelianVarietyRigidity.tex:3` — `\label{chap:avr_for_rr}` missing
   backslash. **Plan-phase ACTIONED iter-193**: fixed.
2. `Albanese_Thm32RationalMapExtension.tex:126` — empty `\(\)` math.
   **Plan-phase ACTIONED iter-193**: fixed.
3. `Picard_FGAPicRepresentability.tex:11` — empty `\(\)` in a comment.
   **Plan-phase LEFT iter-193** (comment-only, zero render impact).

So your iter-194 audit should treat the prior iter as "no full review";
re-audit every chapter as if the iter-191 verdict were the most recent
authoritative one. Pay particular attention to:

1. **NEW chapter** `Picard_Pic0AbelianVariety.tex` (landed iter-192
   plan-phase, file-skeleton landed iter-193 prover-phase) — the chapter
   declares `% archon:covers AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
   which now EXISTS (244 LOC, 5 typed-sorry skeletons matching the
   chapter pins). Audit this chapter for: completeness against Kleiman
   §5 + Milne III §6; correctness of the 5 `\lean{...}` pins; and the
   AddEquiv-vs-LinearEquiv universe-mismatch documentation note.

2. **Lane I signature corrective** landed iter-193 plan-phase, but
   **STILL FALSE** per the iter-193 prover report (`% NOTE (iter-193
   review, prover-surfaced CRITICAL)` annotation on
   `lem:degree_positivePart_principal_eq_finrank` in
   `RiemannRoch_WeilDivisor.tex`). Iter-194 plan-phase dispatches
   `refactor lane-i-localparameter-signature-v2` to fix the signature
   per Option (b): drop abstract `K`, pin to `(ProjectiveLineBar
   kbar).left.functionField`, add `hLPUnif` uniformiser hypothesis. Audit
   the chapter prose at `lem:degree_positivePart_principal_eq_finrank`
   for whether it correctly states the Option-b form (it currently
   states the abstract-K form; you should evaluate whether the prose
   needs editing). Treat the v2 form (Option b) as the authoritative
   Lean statement that the prose should match by iter-195.

3. **Lane H new substrate** in `RiemannRoch_H1Vanishing.tex`. iter-193
   landed 2 axiom-clean substrate helpers (`ext_succ_eq_zero_of_injective_of_lower_zero`,
   `IsFlasque.cokernel_of_shortExact_flasque_flasque`) and chained the
   `HModule_flasque_eq_zero` body structurally through 2 typed sorries
   (Hartshorne II Ex 1.16(b) + III Lemma 2.4). Audit the chapter for
   whether these substrate inputs are blueprint-pinned correctly.

4. **Lane M↓ Stage 5a/5b** in `Albanese_CodimOneExtension.tex`. iter-193
   landed 2 axiom-clean Kähler-localisation helpers. Audit chapter
   prose for whether the Stage 5/6 substrate breakdown matches.

5. **Pic0Scheme / PicScheme / QuotScheme / picSharp / etc. typed-`:= sorry`
   on carriers**. lean-auditor iter-193 flagged these as the project's
   "single largest soundness exposure". Iter-194 plan-phase will NOT
   dispatch the carrier-soundness refactor (deferred to iter-195+ pending
   design analysis) but you should flag the chapters which depend on
   these carriers — particularly `Picard_IdentityComponent.tex` (where
   `Pic0Scheme` is defined), `Picard_FGAPicRepresentability.tex` (where
   `PicScheme` is defined), `Picard_QuotScheme.tex`, `Picard_RelPicFunctor.tex`,
   and `Picard_Pic0AbelianVariety.tex` — for whether the prose accurately
   describes the typed-sorry status.

6. **iter-192 blueprint-doctor flagged `H1Vanishing` `\uses{}` malformation
   and Pic0AbelianVariety chapter-vs-file mismatch** — both RESOLVED per
   iter-193 review's blueprint-doctor section (NO findings iter-193).
   No action needed.

## Per-chapter checklist format

For each chapter `<slug>.tex`, render exactly:

```yaml
- chapter: <slug>
  complete: <true | partial | false>
  correct: <true | partial | false>
  must-fix-this-iter: <list of one-line findings; empty list if none>
  notes: <one short paragraph if there's a non-blocking observation>
```

`complete` = does the chapter cover all the math the corresponding Lean
file(s) need to formalize? `correct` = are the statements
mathematically correct and aligned with cited sources?

A must-fix-this-iter finding is one that BLOCKS prover work on the
affected file(s) THIS iter — wrong-as-stated theorems, missing
hypothesis essential to formalization, broken `\uses{}` to undefined
labels, citation gaps that affect the proof sketch.

## Outputs

Write your report to `.archon/task_results/blueprint-reviewer-iter194.md`.

Include:
1. Per-chapter checklist (yaml as above).
2. Cross-chapter findings (e.g. consistency between
   `Picard_IdentityComponent.tex` and `Picard_Pic0AbelianVariety.tex`).
3. Unstarted-phase blueprint proposals (any strategy phase in STRATEGY.md
   that has no chapter file yet, with concrete outline for what a new
   chapter would contain).
4. Headline: how many chapters pass / partial / fail; which are
   must-fix-this-iter; which are HARD GATE blockers for the iter-194
   prover dispatch list.

## Iter-194 prover dispatch list (FYI — for HARD GATE evaluation)

The plan agent will likely dispatch provers this iter on (subject to
your HARD GATE verdict):

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` → chapter
  `RiemannRoch_WeilDivisor.tex` (Lane I body, post refactor v2)
- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` → chapter
  `RiemannRoch_H1Vanishing.tex` (Lane H substrate)
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` → chapter
  `Albanese_CodimOneExtension.tex` (Lane M↓ Stage 6)
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` → chapter
  `AbelianVarietyRigidity.tex` (Lane E final closures)
- `AlgebraicJacobian/Picard/QuotScheme.lean` → chapter
  `Picard_QuotScheme.tex` (Lane F LinearEquiv extraction)
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` → chapter
  `AbelianVarietyRigidity.tex` (Lane B III.c substrate-hooks)
- `AlgebraicJacobian/Picard/IdentityComponent.lean` → chapter
  `Picard_IdentityComponent.tex` (Lane A.3.i Stacks 037Q project-side)
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` → chapter
  `RiemannRoch_RationalCurveIso.tex` (Lane RCI helper (a))
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` → chapter
  `Albanese_AuslanderBuchsbaum.tex` (Lane G n=0 branch)
- `AlgebraicJacobian/RiemannRoch/OCofP.lean` → chapter
  `RiemannRoch_OCofP.tex` (Lane A first body push)

Flag any chapter from this list that fails the HARD GATE — the plan
agent will defer the corresponding prover lane.
