# Blueprint Clean Directive — iter019

Three chapters were edited this iter by a blueprint-writer / effort-breaker round. Clean each for
purity (math-only, timeless, no Lean leakage, no project history, no verbosity), fix any LaTeX issues,
and verify citation discipline (do NOT remove the existing verbatim `% SOURCE QUOTE` blocks).

## Chapters to clean
1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — an effort-break added a 5-link sub-lemma
   chain decomposing `lem:base_change_mate_fstar_reindex_legs` step-(iii):
   `..._unitExpand`, `..._gammaDistribute`, `..._eCancel`, `..._affineUnit`, `..._innerMatch`. These are
   Archon-original mate-calculus blocks. Scrub any Lean-syntactic leakage (tactic talk, typeclass-wiring
   notes, `rw`/`subst`/`erw` mentions, Lean line-number references, "iter-NNN" history). Keep the
   categorical notation that is already standard in the chapter (pushforward/pullback comp coherence,
   units/counits, Γ). Ensure prose reads as timeless mathematics.
2. `blueprint/src/chapters/Picard_FlatteningStratification.tex` — the proof of
   `lem:gf_noether_clear_denominators` Step 3 was expanded into sub-steps 3a/3b/3c (comparison map ν,
   injectivity via algebraic-independence descent, module-finiteness). Confirm no Lean lemma names leak
   into the rendered prose (they belong in PROGRESS.md), and that the existing `% SOURCE QUOTE PROOF`
   stays intact.
3. `blueprint/src/chapters/Picard_QuotScheme.tex` — ~18 new bespoke helper blocks (kernel/cokernel
   calculus, free polynomial-ring module structure, base-case finiteness) plus M2 prose fix and M4 pins.
   Confirm the new blocks are math-only (no Lean tactic/typeclass leakage), the `% NOTE` on the private
   IsRatHilb toolkit is a terse pointer (not verbose history), and LaTeX is balanced.

## Out of scope
- Do NOT alter mathematical content, statements, `\uses{}`, `\lean{}`, or `\label{}`.
- Do NOT add or remove `\leanok`.
- Do NOT touch the 4 protected stub blocks in the QUOT chapter.

## References
- references/** is in your write-domain only so you can spawn a reference-retriever if a `% SOURCE
  QUOTE` is genuinely missing for an externally-derived block. The new blocks this iter are
  Archon-original (no source quote needed); the GF Step-3 expansion reuses an existing verbatim quote.
  Do not invent citations.
