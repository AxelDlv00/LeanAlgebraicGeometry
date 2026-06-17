# Blueprint Reviewer Directive — iter019 (same-iter fast path)

Whole-blueprint audit (you always read the whole blueprint; produce your per-chapter checklist +
HARD-GATE verdicts). This iter three chapters were edited; I need a fresh complete+correct verdict on
them to clear the per-file prover gate THIS iter:

1. `Cohomology_FlatBaseChange.tex` — an effort-break decomposed the long-unmoved step-(iii) crux of
   `lem:base_change_mate_fstar_reindex_legs` into a 5-link `\uses`-chain:
   `..._unitExpand` → `..._gammaDistribute` → `..._eCancel` → `..._affineUnit` → `..._innerMatch`. The
   prior per-file lean-vs-blueprint check (iter-018) flagged a MAJOR adequacy gap: the step-iii
   mechanism (literal-form conversion + ~150-LOC cancellation) was absent. Verify the new chain is
   detailed enough that a fine-grained prover can formalize each atomic sub-lemma and assemble the
   target. Flag whether `..._eCancel` (the load-bearing cancellation) needs a further (finer) break.
2. `Picard_FlatteningStratification.tex` — the proof of `lem:gf_noether_clear_denominators` (L4) had a
   MUST-FIX from the iter-018 per-file check: Step 3 (AlgHom assembly: injectivity + finiteness)
   under-specified. It was expanded into sub-steps 3a (comparison map ν), 3b (injectivity via
   algebraic-independence descent K→A_g), 3c (module-finiteness via integral-dependence pushforward).
   Verify the must-fix is resolved and L4 is now adequately specified to formalize.
3. `Picard_QuotScheme.tex` — coverage-debt round: ~18 new bespoke helper blocks (kernel/cokernel
   calculus, free polynomial-ring module structure, base-case finiteness) + M2 prose fix
   (`def:graded_subquotientHilb` finiteness condition now N/N' over κ[t]) + M3 (dropped broken
   `subquotient_ker_coker` pin) + M4 (`SubquotientDatum`/`.hilb` pins). Verify the new blocks are
   correct + adequately wired (leandag `lean_aux`/isolated dropped 21→1, the remaining 1 is the
   intentionally-private `finrank_comap_subtype`).

## What I need from your report
- Per-chapter `complete:` / `correct:` checklist for ALL chapters (whole-blueprint view).
- Explicit HARD-GATE verdict for the three chapters above (do their active prover lanes have a
  complete+correct chapter with no must-fix?). The three files heading to provers this iter are
  `FlatBaseChange.lean` (fine-grained on the new step-iii chain), `FlatteningStratification.lean`
  (prove L4), `QuotScheme.lean` (mathlib-build the induction body `subquotient_finite_transfer` →
  `subquotient_hilbertSeries_rational` → `gradedModule_hilbertSeries_rational`).
- Any remaining must-fix-this-iter findings on these chapters.
- Your standard `## Unstarted-phase blueprint proposals` section.

Context: build is GREEN (no Lean changes this iter — these are blueprint-only edits). leandag reported
0 broken `\uses` after the edits.
