# Directive — blueprint-reviewer, iter-198

## Mode
Whole-blueprint completeness + correctness audit (NOT scope-limited).

## Iteration framing

USER 2026-05-28 standing directive PAUSES Route C and shifts prover
capacity to Route A bottom-up. iter-198 will dispatch ≤5 Route A
prover lanes. The HARD GATE depends on a current verdict for each
chapter feeding those lanes.

## Chapters expected to feed iter-198 prover lanes (HARD GATE
applies)

- `Albanese_AuslanderBuchsbaum.tex` — gates AuslanderBuchsbaum.lean
  L1131 (`auslander_buchsbaum_formula_succ_pd` n=k+1 inductive step).
- `RiemannRoch_WeilDivisor.tex` — gates the A.4.a portion of
  WeilDivisor.lean (specifically L249
  `rationalMap_order_finite_support` non-zero branch / Stacks 02RV).
  The chapter covers BOTH A.4.a substrate and RR.1; verify §1–§2
  cover the general substrate.
- `Picard_RelPicFunctor.tex` — gates RelPicFunctor.lean's 6 sorries
  (functor builder + `representable` body; Kleiman §2-3, Nitsure §5).
- `Albanese_CodimOneExtension.tex` — gates CodimOneExtension.lean's
  3 sorries (Stage 6 Stacks 00OE / 02JK / Milne Thm 3.1 + Lemma 3.3).
- `Albanese_Thm32RationalMapExtension.tex` — gates Thm32 L155 helper.

## What I expect from your audit

For each of the 5 chapters above, fire the standard per-chapter
checklist: complete? correct? Lean targets well-formulated? citation
discipline (`% SOURCE`, `% SOURCE QUOTE`, `\textit{Source:}`)?
any unresolved structural gaps that would force a writer dispatch
before a prover can run?

For the rest of the blueprint, do the standard whole-blueprint audit:
flag any chapter with stale Route C narrative that should be neutered
in light of the PAUSE; flag any unstarted-phase blueprint proposals
(in particular: is there a chapter for the carrier-soundness probe?
is there a chapter for the Cartier-route Pic^d via
`𝓛 ↦ Div(𝓛)` on `C × Pic^d`?).

## Per the descriptor

- Read the WHOLE blueprint.
- Output the per-chapter checklist + the unstarted-phase proposals
  section.
- For the 5 iter-198 prover-gating chapters: explicit HARD GATE
  verdict (CLEAR / DEFER / FAST-PATH-CANDIDATE).

## Output

Write to `task_results/blueprint-reviewer-iter198.md`.
