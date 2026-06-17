# Blueprint reviewer directive — iter-200 slug iter200

## Iteration

200

## Scope

Whole-blueprint audit. Per descriptor, you always read all chapters under `blueprint/src/chapters/` — do not restrict scope by directive.

## Iter-200 plan-phase direct blueprint edits (verify these)

The plan agent applied these edits directly this iter — confirm none introduce inconsistencies:

1. `Picard_FGAPicRepresentability.tex`:
   - `\sec:fga_pic_sorry_closure_order` intro paragraph (L596 onwards):
     replaced stale "one free sorry + six ⟨sorry⟩ instance bodies / six carrier
     typeclasses" with "all 7 ⟨sorry⟩ instance bodies / seven carrier
     typeclasses (added `HasSmoothProperQuotient`)".
   - `\subsec:sorry_smooth_proper_quotient` title + Location paragraph:
     updated from "L354 free sorry / proof body" to "L349
     `instHasSmoothProperQuotient` ⟨sorry⟩ / typeclass instance constructor".
   - Closure-order summary's Sorry 4 motivation (L1074 area):
     updated from "removes the only non-instance sorry" to "isolates the
     obligation into a single instance constructor".

2. `Albanese_AuslanderBuchsbaum.tex`:
   - New `\subsec:ab_gap1_first_step` subsection inserted after the
     `\paragraph{Iter budget refinement.}` paragraph at L640 of
     `\subsec:succ_pd_gap_sequence`.
   - The new subsection contains a standalone `\begin{lemma}…\end{lemma}` +
     `\begin{proof}…\end{proof}` pair pinning
     `lem:exists_minimalSurjection_finite_localRing` to
     `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}`
     (the iter-199 axiom-clean ~99 LOC substrate).
   - Per-gap effort table cell for gap (1) refreshed: "80--120 / 1--2 /
     absent / none" → "40--80 / 1--2 / per-syzygy step CLOSED iter-199 / none".

## HARD GATE verdicts requested

For each `.lean` file currently in PROGRESS.md `## Current Objectives`:

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` → `RiemannRoch_WeilDivisor.tex`
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` → `Albanese_AuslanderBuchsbaum.tex`
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` → `Albanese_CodimOneExtension.tex`

If a chapter is `partial | false` on either axis OR a must-fix-this-iter
finding names it, drop the corresponding file from the iter-200 prover
dispatch. Otherwise: CLEAR.

## Unstarted-phase blueprint proposals

The iter-199 review noted three deferral-confirmed proposals
(`Picard_CarrierSoundnessProbe.tex` deferred; `Picard_PicDSubstrate.tex`
deferred; `Albanese_TangentSpaceSubstrate.tex` deferred) and proposed
one new chapter (`Picard_TensorObjSubstrate.tex` for A.1.c.SubT).

iter-200 plan-phase dispatches a blueprint-writer
`tensorobj-substrate-chapter` to create `Picard_TensorObjSubstrate.tex`
this iter (per iter-199 progress-critic Lane RPF STUCK + OVER BUDGET
corrective). When you audit, confirm whether the new chapter is present
on disk and structurally sound (the writer may run in parallel with your
review; if absent at the time of your audit, note it as expected and
re-evaluate on iter-201).

## Out

Report to `task_results/blueprint-reviewer-iter200.md`.
