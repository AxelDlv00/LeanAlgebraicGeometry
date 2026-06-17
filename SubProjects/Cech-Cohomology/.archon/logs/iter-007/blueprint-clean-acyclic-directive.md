# Directive: blueprint-clean — Cohomology_AcyclicResolution.tex

## Target chapter
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex` — the abstract acyclic-resolution
comparison chapter (Stacks Tags 015D/015E/05TA). It just received two rounds of writing:
(1) an effort-breaker decomposed the comparison theorem `lem:acyclic_resolution_computes_derived`
into a staircase of sub-lemmas (`lem:cosyzygy_ses`, `lem:acyclic_one_iso_coker`,
`lem:applied_cosyzygy_cycles`, `lem:cohomology_of_applied_resolution`), and (2) the plan agent
added two coverage-debt blocks (`lem:quasiIso_tau2`, `lem:right_derived_shift_split_resolution`).

## What to clean

1. **Strip project-history / process leakage from LaTeX comments and prose.** The chapter has
   accumulated `% NOTE (iter-NNN review)` / `% NOTE (iter-007 effort-breaker)` annotations,
   phrases like "see recommendations.md (session_5)", "ABSENT from Mathlib (only quasiIso_τ₃
   existed)", "the iter-005 'must be built first' framing is obsolete", "lean_aux", and similar
   iteration/process bookkeeping. Remove these so the chapter reads as a timeless mathematical
   document. KEEP all `% SOURCE`, `% SOURCE QUOTE`, `% SOURCE QUOTE PROOF`, `\textit{Source: …}`
   lines, all `\lean{}`, `\uses{}`, `\label{}`, and the mathematical prose.

2. **Do NOT touch `\leanok` or `\mathlibok` markers** — those are owned by sync_leanok / the
   review agent. Leave every existing marker exactly as is (add/remove none).

3. **Validate the source quotes in the new staircase blocks.** Each of `lem:acyclic_one_iso_coker`,
   `lem:cosyzygy_ses`, `lem:applied_cosyzygy_cycles`, `lem:cohomology_of_applied_resolution`, and
   `lem:acyclic_resolution_computes_derived` cites `references/homological-acyclic-derived.tex`
   (Stacks Tags 015D L5619–5654, 05TA L5785–5838, 015E L5692–5705). OPEN that file and confirm the
   `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` text is verbatim-faithful to the cited line ranges; fix
   any drift, and fill any block that is missing a verbatim quote. The two plan-written blocks
   (`lem:quasiIso_tau2`, `lem:right_derived_shift_split_resolution`) are project-bespoke Mathlib
   supplements (companions of Mathlib's `quasiIso_τ₃` / the homology four-lemma and the δ-iso of the
   homology LES) — they legitimately carry NO `% SOURCE` block; do not invent one.

4. **Trim verbosity** only where it does not remove mathematical content. The staircase proofs are
   detailed by design (the prover formalizes them) — keep that detail; only cut conversational or
   redundant passages.

## Out of scope
- Do not alter any other chapter.
- Do not change statements, `\lean{}` targets, or `\uses{}` dependency sets (they are now
  graph-consistent — every `\uses` resolves to a `\label`).

## Report
Return the path to your report and a one-line summary of what was stripped/validated.
